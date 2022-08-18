## 执行步骤

1. 执行 `docker-compose --profile schema up -d` 初始化 postgresql 中的表结构
2. 执行 `docker-compose --profile all up -d` 启动所有服务, 如果 master 节点起不来就多执行几次
3. 可以通过 `http://localhost:12345/dolphinscheduler/ui` 访问操作界面，默认的用户和密码分别为 admin 和 dolphinscheduler123
4. 可以通过 `http://localhost:12345/dolphinscheduler/doc.html?language=zh_CN&lang=cn` 访问 api 说明文档
5. 由于原生的 API 仅提供 http 接口，没有任何的封装和工具，导致创建流程十分痛苦，推荐使用 `https://dolphinscheduler.apache.org/python/3.0.0/index.html` PyDolphinScheduler 工具生成工作流程