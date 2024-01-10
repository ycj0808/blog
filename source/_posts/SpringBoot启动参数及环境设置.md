---
title: SpringBoot启动参数及环境设置
donate: true
date: 2018-06-12 17:19:01
categories: SpringBoot
tags: SpringBoot jar
---

java命令的模版: java [-options] -jar jarfile [args...]

启动命令：
```
java -Xms128m -Xmx256m -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8081,suspend=n -jar /data/app/test.jar --spring.profiles.active=dev &

```

其中：

-Xms128m 设置的是JVM堆最小内存128m

-Xmx256m 设置的是JVM堆最大内存为256m


-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8081,suspend=n

设置debug模式，允许tomcat远程连接服务器调试，调试端口可指定，此处为8081

/data/app/test.jar 指定需要执行的jar包的路径

--spring.profiles.active=dev 设定SpringBoot运行环境为dev环境

& 后台模式执行