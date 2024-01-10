---
title: Kafka安装
donate: true
date: 2017-12-05 20:34:27
categories: 软件
tags:
---

1. 下载安装Kafka，http://kafka.apache.org/downloads ，选择kafka_2.12-1.0.0版本


2. 启动Kafka

* 首先启动zookeeper。Kafka依赖Zookeeper，因此，启动Kafka前得先启动Zookeeper。在Kafka的根路径执行如下命令即可启动Zookeeper
```
bin/zookeeper-server-start.sh config/zookeeper.properties &
```

* 启动Kafka。启动完Zookeeper后，即可启动Kafka。执行如下命令即可。
```
bin/kafka-server-start.sh config/server.properties &
```