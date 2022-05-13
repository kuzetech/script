import sys
import time
from sqlalchemy import create_engine
from clickhouse_sqlalchemy import make_session

conf = {
    "clickhouse1": {
        "user": "default",
        "password": "",
        "server_host": "localhost",
        "port": "8123",
        "db": "default"
    },
    "clickhouse2": {
        "user": "default",
        "password": "",
        "server_host": "localhost",
        "port": "8124",
        "db": "default"
    }
}

sql_search_distinct = '''
select 
    tupleElement(delete_content, 1) as host,
    groupArray(tupleElement(delete_content, 3)) as delete_log_ids
from (
    select
        arrayJoin(arraySlice(arrayDistinct(groupArray(tuple(hostName(), toString(_partition_id), toString(log_id)))), 2)) as delete_content
    from event_all
    where dt = '2022-05-04'
    group by log_id
    having count(*) > 1
)
group by host
'''

sql_delete = 'alter table event_local delete where log_id in (%s)'

sql_unfinished_mutation_task = '''
select 
    * 
from system.mutations 
where is_done  = 0 
and positionCaseInsensitive(command, 'delete') = 1
order by create_time desc
'''


def create_clickhouse_engine(node_name):
    connection = 'clickhouse://{user}:{password}@{server_host}:{port}/{db}'.format(**conf[node_name])
    engine = create_engine(
        connection,
        echo=True,
        pool_size=8,
        pool_recycle=3600,
        pool_timeout=20)
    return engine


engine_map = {'clickhouse1': create_clickhouse_engine('clickhouse1')}


session = make_session(engine_map['clickhouse1'])
distinct_cursor = session.execute(sql_search_distinct)

try:
    host_and_delete_ids_list = distinct_cursor.fetchall()
finally:
    distinct_cursor.close()
    session.close()

if len(host_and_delete_ids_list) == 0:
    print("没有需要去重的数据")
    sys.exit(0)

execute_delete_host_list = []
for item in host_and_delete_ids_list:
    execute_delete_host_list.append(item[0])

for host in execute_delete_host_list:
    if engine_map.get(host) is None:
        engine_map[host] = create_clickhouse_engine(host)

mutation_check_list = []
for item in host_and_delete_ids_list:
    host = item[0]
    delete_session = make_session(engine_map[host])
    delete_ids_array_str = str(item[1])
    delete_ids_str = delete_ids_array_str[1: len(delete_ids_array_str) - 1]
    try:
        delete_cursor = delete_session.execute(sql_delete % delete_ids_str)
    finally:
        delete_cursor.close()
    mutation_check_list.append((host, delete_session))

# time.sleep(10)

all_mutation_task_unfinished_index = True
while all_mutation_task_unfinished_index:
    for item in mutation_check_list:
        check_session = item[1]
        unfinished_mutation_cursor = check_session.execute(sql_unfinished_mutation_task)
        try:
            unfinished_mutation_list = unfinished_mutation_cursor.fetchall()

            if len(unfinished_mutation_list) == 0:
                check_session.close()
                mutation_check_list.remove(item)
            else:
                print("%s 节点上还有任务没有完成" % item[0])
        finally:
            unfinished_mutation_cursor.close()

    if len(mutation_check_list) == 0:
        all_mutation_task_unfinished_index = False
    else:
        time.sleep(10)


