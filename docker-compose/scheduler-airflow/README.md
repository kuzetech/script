## 官网地址

https://airflow.apache.org/docs/apache-airflow/stable/tutorial.html#

## 执行步骤

1. 执行 `docker-compose up airflow-init` 初始化存储数据库 postgres 和 redis
2. 执行 `docker-compose up -d` 启动所有基础服务
3. 执行 `docker-compose --profile flower up -d` 启动监控服务
4. 可以通过 `http://localhost:8080` 访问操作界面，默认的用户和密码都是 airflow
5. 可以通过 `http://localhost:5555/` 访问监控系统

## 命令行模式测试运行

1. 执行 `docker exec -it scheduler-airflow_airflow-worker_1 sh` 进入命令行，可以是 scheduler、worker、webserver 节点
2. 执行 `airflow tasks test [dag_id] [task_id] [logical_date]`，logical_date 的作用是模拟该任务执行的时间，例如 2015-06-01。命令在本地运行任务实例，将其日志输出到标准输出(在屏幕上) ，不考虑依赖关系，并且不将状态(运行、成功、失败、 ...)传递给数据库。只允许测试单个任务实例
3. 执行 `airflow dags test [dag_id] [logical_date]`，logical_date 的作用是模拟该任务执行的时间，例如 2015-06-01。该命令会完整的执行一次 DAG 运行，但是数据库中没有注册任何状态