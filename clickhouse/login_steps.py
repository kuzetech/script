import json
import gzip
import os.path
import argparse
import datetime

import sqlalchemy as sa

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument("db_url")
arg_parser.add_argument("output_dir")
arg_parser.add_argument("--start")
arg_parser.add_argument("--end")

args = arg_parser.parse_args()

engine = sa.create_engine(args.db_url.replace("mysql://", "mysql+pymysql://"))

today = datetime.date.today()

weekend = today - datetime.timedelta(days=today.weekday() + 1)
weekstart = weekend - datetime.timedelta(days=6)

start = args.start or weekstart
end = args.end or weekend

print(f"download {start} - {end} to {args.output_dir}")

sql = """
select
    null as id,
    'sausage' as app_id,
    __id__ as log_id,
    'login_steps' as event,
    '1.0' as sdk_version,
    time,
    android_id,
    advertising_id,
    '安卓 oaid' as oaid,
    ios_idfa,
    deviceid as device_id,
    m as model,
    os,
    'client_version' as client_version,
    cip as ip,
    '网络运营商' as carrier,
    nw as network_type,
    chan as channel,
    '0.0' as longitude,
    '0.0' as latitude,
    '1920*1080' as resolution,
    1 as user_id,
    pid,
    e as step_name,
    case
        when os regexp '^Android OS' then split_part(os, " ", 3)
        when os regexp '^iOS' then split_part(os, " ", 2)
        else 'Unknown'
    end as os_version,
    case
        when os regexp '^Android' then 'Android'
        when os regexp '^iOS' then 'iOS'
        else 'Unknown'
    end as device_platform
from client_login_steps
where dt = %s
order by time
"""

with engine.connect() as conn:
    dt = start
    i = 0
    while dt <= end:
        output_location = os.path.join(args.output_dir, f"{dt}.json.gz")
        print(f"download {dt} to {output_location}")
        r = conn.execute(sql, [dt])

        with gzip.open(output_location, "wt") as f:
            for record in r:
                json.dump(dict(record), f)
                f.write("\n")
            print(f"{r.rowcount} downloaded")

        dt += datetime.timedelta(days=1)
        i += 1


# 启动命令如下
# python3 login_steps.py \
# mysql://huangshaowei_s1214710114158088:081VNbye08jRgUN2Rp@12gomudo1g8-6c990e49.cn-hangzhou.datalakeanalytics.aliyuncs.com:10000/sausage_first \
# ./data \
# --start "2021-09-05" \
# --end "2021-09-05"