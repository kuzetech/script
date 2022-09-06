## 官网地址

https://dolphinscheduler.apache.org/

## 执行步骤

1. 执行 `docker-compose --profile schema up -d` 初始化 postgresql 中的表结构
2. 执行 `docker-compose --profile all up -d` 启动所有服务, 如果 master 节点起不来就多执行几次
3. 可以通过 `http://localhost:12345/dolphinscheduler/ui` 访问操作界面，默认的用户和密码分别为 admin 和 dolphinscheduler123
4. 可以通过 `http://localhost:12345/dolphinscheduler/doc.html?language=zh_CN&lang=cn` 访问 api 说明文档
5. 原生的 rest api 创建 dag 的接口参数十分复杂，导致创建流程十分痛苦，推荐使用 `https://dolphinscheduler.apache.org/python/3.0.0/index.html` PyDolphinScheduler 工具生成工作流程

## 关于任务之间的参数传递
1. 可以参考[官网指导文档](https://dolphinscheduler.apache.org/zh-cn/docs/latest/user_doc/guide/parameter/context.html)
2. 官网的例子过于简单，都是静态变量，我需要的是传入一个变量，经过计算得出另一个变量，例如传入静态变量 table = "666", 传出动态变量 mytable = "my" + $table
3. 实现上述例子的 shell 脚本如下：
    ```shell
    echo "$table"                               # 输出为空
    value="my${table}"
    echo '${setValue(mytable='$value')}'  
    # echo '${setValue(mytable='${value}')}'    # 或者写成这样也行，但是里面的单引号是必须的  
    ```
4. 原理如下
   - 首先，dolphin 会扫描所有带 ${} 的变量值，仅将第一层级替换成系统参数的值。只带 $ 符号的不会
   - 然后，生成完整的 shell 脚本到 worker 上执行
   - 因此，第一句话的输出为空，因为 table 这个变量只在调度系统中存在，在 shell 中还未定义
   - 因此，第二句话 ${table} 先被替换成 666 的值，整个语句就变成 `value="my6666"`
   - 因此，第三句话中 value 如果是个变量必须加上单引号，不然会被当成常量。如果加上单引号后的变量不存在，会直接报错