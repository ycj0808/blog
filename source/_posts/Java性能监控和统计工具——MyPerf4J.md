---
title: Java性能监控和统计工具——MyPerf4J
donate: true
date: 2019-02-13 09:11:49
categories:
tags:
---

## 简介
[MyPerf4J](https://github.com/LinShunKang/MyPerf4J),一个针对高并发、低延迟应用设计的简单、快速且无侵入的Java方法性能监控和统计工具。

### 具有以下特性
* 无侵入: 采用JavaAgent方式，对应用程序完全无侵入，无需修改应用代码
* 高性能: 性能消耗非常小，每次记录只花费73ns，可以在生产环境长期使用
* 低内存: 采用内存复用的方式，整个生命周期只产生极少的临时对象，不影响应用程序的GC
* 高精度: 采用纳秒来计算响应时间
* 高实时: 支持秒级监控，最低1s!

## 架构
MyPerf4J的整体架构图如下所示：
![图1](https://icefire.me/images/MyPerf4J_整体架构图V2.jpeg) 

各组件：
* Java Application: MyPerf4J 的运行容器
* MyPerf4J: Metrics 收集和统计
* Collector: 日志收集器（可以是Telegraf或者是filebeat）
* Storage: 存储平台（可以是InfluxDB也可以是Elasticsearch）
* Dashboard: 可视化平台（可以是Grafana也可以是Chronograf）

关系：
* MyPerf4J 定时把指定时间片内的统计数据写入日志文件
* Collector 从日志文件中读取统计数据，并写入 Storage
* Dashboard 从 Storage 中读取数据并展示


## 监控指标

### Method Metrics
* RPS: 每秒请求数
* Count: 总请求数
* RT: 方法响应时间
* Avg: 方法平均响应时间
* Min: 方法最小响应时间
* Max: 方法最大响应时间
* StdDev: 方法响应时间的标准差
* TP50, TP90, TP95, TP99, TP999, TP9999, TP99999, TP100
* TP: Top 百分数(Top Percentile)
* TP90: 在一个时间段内（如1分钟），统计该方法每次调用所消耗的时间，并将这些时间按从小到大的顺序进行排序，取第 90% 的那个值作为 TP90 值

### JVM Thread Metrics
* TotalStarted: 自 JVM 启动以来启动过的线程数
* Active: 当前存活的线程数，包括守护线程和非守护线程
* Daemon: 当前存活的守护线程数
* Runnable: 正在 JVM 中执行的线程
* Blocked: 受阻塞并等待某个监视器锁的线程数
* Waiting: 无限期地等待另一个线程来执行某一特定操作的线程数
* TimedWaiting: 等待另一个线程来执行取决于指定等待时间的操作的线程处于这种状态数
* Terminated: 已退出的线程数
* Peak: 自 JVM 启动或峰值重置以来峰值活动线程计数
* New: 至今尚未启动的线程数

### JVM Memory Metrics
* HeapInit: JVM 在启动期间从操作系统请求的用于内存管理的初始堆内内存容量（以字节为单位）
* HeapUsed: JVM 当前已经使用的堆内内存量（以字节为单位）
* HeapCommitted: 已提交的堆内内存量，保证可以由 JVM 使用的堆内内存量（以字节为单位）
* HeapMax: 可以用于内存管理的最大堆内内存量（以字节为单位）
* NonHeapInit: JVM 在启动期间从操作系统请求的用于内存管理的初始非堆内内存容量（以字节为单位）
* NonHeapUsed: JVM 当前已经使用的非堆内内存量（以字节为单位）
* NonHeapCommitted: 已提交的堆内内存量，保证可以由 JVM 使用的非堆内内存量（以字节为单位）
* NonHeapMax: 可以用于内存管理的最大非堆内内存量（以字节为单位）


### JVM ByteBuff Metrics
* Name: 缓存池名称
* Count: 缓存池中 buffer 的数量
* MemoryUsed: JVM 用于此缓冲池的内存估计值
* MemoryCapacity: 缓存池中所有 buffer 的总容量估计值

### JVM GC Metrics
* CollectCount: 累计 GC 次数
* CollectTime: 累计 GC 时间

### JVM Class Metrics
* Total: 自 JVM 开始执行到目前已经加载的类的总数
* Loaded: 当前加载到 JVM 中的类的数量
* Unloaded: 自 JVM 开始执行到目前已经卸载的类的总数


使用方式：
```
java  -javaagent:/Users/yangchj/soft/java/MyPerf4J-2.4.0/MyPerf4J-ASM-2.4.0.jar -DMyPerf4JPropFile=/Users/yangchj/soft/java/MyPerf4J-2.4.0/conf/myPerf4j.properties -jar myperfdemo-0.0.1-SNAPSHOT.jar

```