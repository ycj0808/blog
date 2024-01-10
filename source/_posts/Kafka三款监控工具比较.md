---
title: Kafka三款监控工具比较
donate: true
date: 2018-06-26 15:26:49
categories: Kafka
tags:
---

## 主流的三种Kafka监控程序
* Kafka Web Console
* Kafka Manager
* KafkaOffsetMonitor

### Kafka Web Console
使用Kafka Web Console，可以监控
* Brokers列表
* Kafka 集群中 Topic列表，及对应的Partition、LogSiz e等信息
* 点击Topic，可以浏览对应的Consumer Groups、Offset、Lag等信息
* 生产和消费流量图，消息预览

注： 唱给你发虚运行后，会定时去读取kafka集群分区的日志长度，读取完毕后，连接没有正常释放，一段时间后产生大量的socket连接，导致网络堵塞

### Kafka Manager
雅虎开源的Kafka集群管理工具：
* 管理几个不同的集群
* 监控集群的状态（topics,brokers,副本分布，分区分布）
* 产生分区分配，基于集群的当前状态
* 重新分配分区


### KafkaOffsetMonitor
* KafkaOffsetMonitor 可以实时监控
* Kafka集群状态
* Topic、Consumer Group列表
* 图形化展示topic和consumer之间的关系
* 图形化展示consumer的Offset、Lag等信息

## 总结
* Kafka Web Console：监控功能较为全面，可以预览消息，监控Offset、Lag等信息，但存在bug，不建议在生产环境中使用

* Kafka Manager：偏向Kafka集群管理，若操作不当，容易导致集群出现故障。对Kafka实时生产和消费消息是通过JMX实现的。没有记录Offset、Lag等信息

* KafkaOffsetMonitor：程序一个jar包的形式运行，部署较为方便。只有监控功能，使用起来也较为安全

若只需要监控功能，推荐使用KafkaOffsetMonitor，若偏重Kafka集群管理，推荐使用Kafka Manager