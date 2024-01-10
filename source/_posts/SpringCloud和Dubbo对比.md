---
title: SpringCloud和Dubbo对比
donate: true
date: 2018-04-26 17:05:33
categories:
tags:
---
Spring Cloud 是一个基于SpringBoot实现的云应用开发工具，它为基于JVM的应用开发中的配置管理、服务发现、
断路器、智能路由、微代理、控制总线、全局锁、决策竞选、分布式会话和集群状态管理等操作提供了一种简单的开发方式。

ESB（企业数据总线）,一般采用集中式转发请求，适合大量异构系统集成，侧重任务的编排，性能问题可通过异构的方式来进行
规避，无法支持特别大的并发。

Dubbo(服务注册管理)，采用是分布式调用，注册中心只记录地址信息，然后直连调用，适合并发及压力比较大的情况，其侧重服务的
治理，将各个服务颗粒化，各个子业务系统在程序逻辑上完成业务的编排。

## SpringCloud 常用核心组件
1. SpringCloud Config
    - 统一管理各个服务的配置信息
    - 在服务横向扩展时避免同时维护多个配置文件
    - 支持实时刷新配置文件内容
    - 支持git版本管理配置文件

2. SpringCloud eureka
    - 服务注册发现组件
    - 满足A.P原则，不用额外处理

3. SpringCloud Ribbon
    - 服务间的负载均衡组件
    - 可以和服务发现组件和熔断器组合使用

4. SpringCloud Hystrix
    - 熔断器组件
    - 使用熔断机制避免错误扩散

5. SpringCloud Feign
    - 声明式,模版化http客户端
    - 基于http协议调用服务，简化调用代码

6. SpringCloud Zuul
    - api网关，类似nginx反向代理的功能
    - 可以和服务发现灵活集成

 ## dubbo常用核心功能和组件                 
 1. zookeeper
    - dubbo的服务发现注册依赖组件
    - 满足C.P原则，dubbo额外处理，满足A.P原则

 2. Monitor
    - 监控中心
    - 监控服务的运行使用情况

 3. RPC 
    - 使用rpc通讯
    - 需要依赖api包
    - 性能强于rest。但依赖包管理复杂。  

### dubbo核心部件
    - Provider：暴露服务的提供方，可以通过jar或者容器的方式启动服务
    - Consumer:调用远程服务的服务消费方
    - Registry:服务注册中心和发现中心
    - Monitor:统计服务和调用次数，调用时间监控中心。
    - Container：服务运行的容器

 ![image](https://icefire.me/images/dubbo_framework.png)   



 ## 微服务架构核心要素比较
| 核心要素         | Dubbo             | Spring Cloud  |
| --------------- |:-------------:    | :------------|
| 服务注册中心      | Zookeeper、Redis  | Spring Cloud Netflix Eureka |
| 服务调用方式      | RPC               | REST API |
| 服务网关         | 无                 | Spring Cloud Netflix Zuul|
| 断路器           | 不完善             | Spring Cloud Netflix Hystrix |
| 分布式配置        | 无                | Spring Cloud Config |
| 分布式追踪系统    | 无                 | Spring Cloud Sleuth |
| 消息总线         | 无                 | Spring Cloud Bus |
| 数据流           | 无                 | Spring Cloud Stream 基于Redis,Rabbit,Kafka实现的消息微服务 |
| 批量任务	       | 无                 | Spring Cloud Task |


## 通讯协议

1. 支持协议
    - Dubbo：使用RPC通讯协议，提供序列化方式如下：
    dubbo:Dubbo缺省协议采用单一长连接和NIO异步通讯，适合于小数据大量并发的服务调用，以及服务消费者机器数远大于服务提供者机器数的情况。
    rmi:RMI协议采用JDK标准的java.rmi.*实现，采用阻塞式短连接和JDK标准列化方式
    Hessian:Hessian协议用于集成Hessian的服务，Hessian底层采用http通讯，采用Servlet暴露服务,Dubbo缺省内嵌Jetty作为服务器实现
    http:采用Spring的HttpInvoker实现
    WebService:基于CXF的fronted-simple和transports-http实现

    - SpringCloud：SpringCloud使用HTTP协议的RESTAPI


## 性能比较
使用一个Pojo对象包含10个属性，请求10万次，Dubbo和Spring Cloud在不同的线程数量下，每次请求耗时如下：

| 线程数         | Dubbo             | Spring Cloud  |
| --------------- |:-------------:    | :------------:|
| 10线程	| 2.75	| 6.52	|
| 20线程	| 4.18	| 10.03	|
| 50线程	| 10.3	| 28.14	|
| 100线程	| 20.13	| 55.23	|
| 200线程	| 42	| 110.21	|
评：dubbo支持各种通信协议，而且消费方和服务方使用长链接方式交互，通信速度上略胜Spring Cloud，如果对于系统的响应时间有严格要求，长链接更合适。

## 服务依赖方式
Dubbo：服务提供方与消费方通过接口的方式依赖，服务调用设计如下：
- interface层：服务接口层，定义了服务对外提供的所有接口
- Model层：服务的DTO对象层
- business层：业务实现层，实现interface接口并且和DB交互

因此需要为每个微服务定义了各自的interface接口，并通过持续集成发布到私有仓库中，调用方应用对微服务提供的抽象接口存在强依赖关系，开发、测试、集成环境都需要严格的管理版本依赖。
通过maven的install & deploy命令把interface和Model层发布到仓库中，服务调用方只需要依赖interface和model层即可。在开发调试阶段只发布Snapshot版本。等到服务调试完成再发布Release版本，通过版本号来区分每次迭代的版本。通过xml配置方式即可方面接入dubbo，对程序无入侵。

Spring Cloud：服务提供方和服务消费方通过json方式交互，因此只需要定义好相关json字段即可，消费方和提供方无接口依赖。通过注解方式来实现服务配置，对于程序有一定入侵。

点评：Dubbo服务依赖略重，需要有完善的版本管理机制，但是程序入侵少。而Spring Cloud通过Json交互，省略了版本管理的问题，但是具体字段含义需要统一管理，自身Rest API方式交互，为跨平台调用奠定了基础。

![dubbo](https://icefire.me/images/dubbo_framework1.png)
Dubbo组件运行流程
- gateway：前置网关，具体业务操作，gateway通过dubbo提供的负载均衡机制自动完成
- service：原子服务，只提供该业务员相关的原子服务
- Zookeeper:原子服务注册到zk上

![springcloud](https://icefire.me/images/springcloud_framwork.png)
- 所有请求都统一通过 API 网关（Zuul）来访问内部服务
- 网关接收到请求后，从注册中心（Eureka）获取可用服务
- 由 Ribbon 进行均衡负载后，分发到后端的具体实例
- 微服务之间通过 Feign 进行通信处理业务

点评：业务部署方式相同，都需要前置一个网关来隔绝外部直接调用原子服务的风险。Dubbo需要自己开发一套API 网关，而Spring Cloud则可以通过Zuul配置即可完成网关定制。使用方式上Spring Cloud略胜一筹。

![micro_service](https://icefire.me/images/framwork_micro_service.png)

### 架构分解
- 网关集群：数据的聚合、实现对接入客户端的身份认证、防报文重放与防数据篡改、功能调用的业务鉴权、响应数据的脱敏、流量与并发控制等
- 业务集群：一般情况下移动端访问和浏览器访问的网关需要隔离，防止业务耦合
- Local Cache：由于客户端访问业务可能需要调用多个服务聚合，所以本地缓存有效的降低了服务调用的频次，同时也提示了访问速度。本地缓存一般使用自动过期方式，业务场景中允许有一定的数据延时。
- 服务层：原子服务层，实现基础的增删改查功能，如果需要依赖其他服务需要在Service层主动调用
- Remote Cache：访问DB前置一层分布式缓存，减少DB交互次数，提升系统的TPS
- DAL：数据访问层，如果单表数据量过大则需要通过DAL层做数据的分库分表处理
- MQ：消息队列用来解耦服务之间的依赖，异步调用可以通过MQ的方式来执行
- 数据库主从：服务化过程中毕竟的阶段，用来提升系统的TPS

### 注意事项
- 服务启动方式建议使用jar方式启动，启动速度快，更容易监控
- 缓存、缓存、缓存，系统中能使用缓存的地方尽量使用缓存，通过合理的使用缓存可以有效的提高系统的TPS
- 服务拆分要合理，尽量避免因服务拆分而导致的服务循环依赖
- 合理的设置线程池，避免设置过大或者过小导致系统异常