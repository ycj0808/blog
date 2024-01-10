---
title: Kafka监控之KafkaOffsetMonitor使用
donate: true
date: 2018-06-25 17:32:28
categories:
tags:
---

## 简述
KafkaOffsetMonitor是Kafka的一款客户端消费监控工具，用来实时监控Kafka服务的Consumer以及他们所在的Partition中的Offset，可以浏览当前的消费者组，并且每个Topic的所有Partition的消费情况一目了然。

**注**
经过测试，KafkaOffsetMonitor对kafka_2.10-0.10.2.1版本可以查看consumer groups。最新版本无法查看groups，部分功能不可用。
## 下载

**[官方下载](https://github.com/quantifind/KafkaOffsetMonitor)**
**[官方维护ing](https://github.com/Morningstar/kafka-offset-monitor/),支持Scala2.11版编译的Kafka**
**[百度网盘](https://pan.baidu.com/s/1kUZJrCV)**

## 启动
**方式一**
直接启动
```sh
java -cp KafkaOffsetMonitor-assembly-0.3.0-SNAPSHOT.jar \
com.quantifind.kafka.offsetapp.OffsetGetterWeb \
--offsetStorage kafka --zk 127.0.0.1:2181 \
--port 8096 \
--refresh 10.seconds \
--retain 2.day 1>./logs/stdout.log 2>./logs/stderr.log &
```

**方式二**
编写脚本kafka-monitor-start-0.3.0.sh
```
#!/bin/bash
java -cp KafkaOffsetMonitor-assembly-0.3.0-SNAPSHOT.jar \
com.quantifind.kafka.offsetapp.OffsetGetterWeb \
--offsetStorage kafka --zk 127.0.0.1:2181 \
--port 8096 \
--refresh 10.seconds \
--retain 2.day 1>./logs/stdout.log 2>./logs/stderr.log &
```

### 各个参数的含义
* offsetStorage：有效的选项是"zookeeper","kafka","storm"。0.9版本以后，offset存储的位置在kafka。

* zk: zookeeper的地址
* port: 端口号
* refresh 刷新频率，更新到DB
* retain 保留DB的时间
* dbName 在哪里存储（默认offsetapp）

