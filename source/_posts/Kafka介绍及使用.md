---
title: Kafka介绍及使用
donate: true
date: 2018-06-14 10:20:52
categories:
tags:
---

## Kafka简介
1. 关键能力
* 消息队列  

* 容错存储

* 流处理

Kafka 构建了一个语言无关的基于TCP protocol 的通信机制，用来高性能的实现clients 和 servers 之间通信

2. 基本术语
* Broker
Kafka集群包含一个或多个服务器，其中服务器被称为broker

* Topic
每条发布到Kafka集群的消息都有一个类别，这个类别被称为Topic。（物理上不同Topic的消息分开存储，逻辑上一个Topic的消息虽然保存在一个或多个broker上但用户只需要指定消息的Topic即可生产和消费数据）

* Partition
Partition是物理上的概念，每个Topic包含一个或多个Partition（一般为Kafka节点数CPU的总核数）

作用：
    1. Partitions实现高并发
    2. Partitions 复制+ zookeeper实现了高可用

* Producer
负责发布消息到Kafka broker；写入要指定topic和partition；消息如何分到不同的partition，算法由producer指定

* Consumer
消息消费者，向Kafka broker读取消息的客户端

* Consumer Group
每个Consumer属于一个特定的Consumer Group（每个Consumer指定group name,若不指定group name则属于默认的group）
    - 每条消息分发一个消费者，每条消息广播给消费者组的所有消费者
    - 一条消息发送到一个consumer group后，只能由该group的一个consumer接收和使用
    - 一个group中的每个consumer对应一个partition有如下好处
        * 可以按照partition的数目进行并发处理
        * 每个partition都只有一个consumer读取，因而保证了消息被处理的顺序是按照partition的存放顺序进行
    -  一个Consumer可以有多个线程进行消费，线程数应不多于topic的partition数，因为对于一个包含一或多消费线程的consumer group来说，一个partition只能分给其中的一个消费线程消费
    - 如果consumer从多个partition读到数据，不保证数据间的顺序性，kafka只保证在一个partition上数据是有序的，但多个partition，根据你读的顺序会有不同
    - 增减consumer，broker，partition会导致rebalance，所以rebalance后consumer对应的partition会发生变化

3. 消息队列
* 特性
    1. 可扩展
        - 在不需要下线的情况下进行扩容
        - 数据流分区存储在多个机器上
    2. 高性能
        - 单个broker能服务上千个客户端
        - 单个broker每秒读/写几百兆字节
        - 多个broker组成的集群能达到非常强的吞吐能力
        - 性能稳定，无论数据多大
        - Kafka在底层摒弃了Java堆缓存机制，采用了操作系统级别的页缓存，同时将随机写操作改为顺序写，再结合Zero-Copy的特性极大地改善了IO性能
    3. 持久存储
        - 存储在磁盘上
        - 冗余备份到其他服务器以防丢失    

## 安装和使用
下载kafka_2.11-1.10，解压后进入目录

1. 启动zookeeper
* 启动
```
./bin/zookeeper-server-start.sh config/zookeeper.properties & 
```    
其中，config/zookeeper.properties是zookeeper的配置文件

* 结束
```
./bin/zookeeper-server-stop.sh
```

2. 启动Kafka服务器

配置文件 config/server.properties文件，一般需要配置如下字段，其它按默认即可
```
broker.id：    　　　　　　每一个broker在集群中的唯一表示，要求是正数
listeners（效果同之前的版本的host.name及port）：注意绑定host.name，否则可能出现莫名其妙的错误如consumer找不到broker。这个host.name是Kafka的server的机器名字，会注册到Zookeeper中
log.dirs：    　　　　　　 kafka数据的存放地址，多个地址的话用逗号分割,多个目录分布在不同磁盘上可以提高读写性能
log.retention.hours：   　数据文件保留多长时间， 存储的最大时间超过这个时间会根据log.cleanup.policy设置数据清除策略
zookeeper.connect：   　　指定ZooKeeper的connect string，以hostname:port的形式，可有多个以逗号分隔，如hostname1:port1,hostname2:port2,hostname3:port3，还可有路径，如：hostname1:port1,hostname2:port2,hostname3:port3/kafka，注意要事先在zk中创建/kafka节点，否则会报出错误：java.lang.IllegalArgumentException: Path length must be > 0
```

* 命令
```
//启动
./bin/kafka-server-start.sh config/server.properties,生产环境最好以守护程序启动
```

```
//结束
./bin/kafka-server-stop.sh
```

## 使用
kafka本身是和zookeeper相连的，而对应producer和consumer的状态保存也都是通过zookeeper完成的。对Kafka的各种操作通过其所连接的Zookeeper完成

* 命令行客户端
创建topic
```
./bin/kafka-topics.sh  --create  --zookeeper  localhost:2181  --replication-factor 1  --partitions  1  --topic test
```

列出所有topic
```
./bin/kafka-topics.sh --list --zookeeper localhost:2181 
```

查看topic信息（包括分区、副本情况等）
```
kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-replicated-topic
```

生产某种topic消息
```
./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
```

消费某种topic消息
```
./bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning
```

## kafka-manager用于管理kafka集群
编译好的包在/Users/yangchj/soft/develop/kafka-manager.zip

1. 解压
```
unzip kafka-manager.zip
```

2. 配置conf/application.conf里的kafka-manager.zkhosts
```
kafka-manager.zkhosts="192.168.6.131:2181,192.168.6.132:2181,192.168.6.133:2181"
```

3. 启动
```
./bin/kafka-manager -Dconfig.file=conf/application.conf   默认端口9000

指定端口，指定zkhost
./bin/kafka-manager -Dhttp.port=9001 -Dkafka-manager.zkhosts="192.168.6.131:2181,192.168.6.132:2181,192.168.6.133:2181"
```

4. 使用
访问 http://127.0.0.1:9000,在Cluster-> Add Cluster 输入要监控的Kafka集群的Zookeeper