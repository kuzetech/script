## 执行步骤

1. 执行 `docker-compose --profile schema up -d` 初始化 postgresql 中的表结构
2. 执行 `docker-compose --profile all up -d` 启动所有服务
3. 如果 master 节点起不来就多执行几次 `docker-compose --profile all up -d`
4. 可以通过 `http://localhost:12345/dolphinscheduler/ui` 访问操作界面，默认的用户和密码分别为 admin 和 dolphinscheduler123