---
title: Redis监控
donate: true
date: 2018-06-26 11:22:19
categories:
tags:
---

## Redis监控之Redis-monitor

### 简介
Redis-monitor 一个可视化的redis 监控程序。使用FLask+sqlite，非常轻量级，非常容易使用和部署。

### What
监控数据包括以下：
* redis服务器信息，包括redis版本，上线时间，os系统信息等等。
* 实时的消息处理信息，例如处理command数量、连接总数量等
* 联通时间动态图表
* ops时间动态图表
* 内存占用、cpu消耗实时动态图表

### 使用
1. 首先安装python库
```
pip install redis-monitor
```

2. 初始化配置和数据库
```
redis-monitor init
```

3. 启动webserver
```
redis-monitor start //默认端口9527

redis-monitor start -p 9999
```

然后访问，127.0.0.1:9527

[开源地址](https://github.com/NetEaseGame/redis-monitor)


