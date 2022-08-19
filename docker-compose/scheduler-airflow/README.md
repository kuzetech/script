## 官网地址

https://airflow.apache.org/docs/apache-airflow/stable/tutorial.html#

## 执行步骤

1. 执行 `docker-compose up airflow-init` 初始化存储数据库 postgres 和 redis
2. 执行 `docker-compose up -d` 启动所有基础服务
3. 执行 `docker-compose --profile flower up -d` 启动监控服务
4. 可以通过 `http://localhost:8080` 访问操作界面，默认的用户和密码都是 airflow
5. 可以通过 `http://localhost:5555/` 访问监控系统