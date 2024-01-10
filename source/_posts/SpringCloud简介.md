---
title: SpringCloud简介
donate: true
date: 2018-03-16 16:25:07
categories: SpringCloud
tags: 
- Java 
- 服务端
- Spring Cloud
- 微服务
---

## SpringCloud简介
* 什么是Spring Boot
    Spring Boot 是由 Pivotal 团队提供的全新框架，其设计目的是用来简化新 Spring 应用的初始搭建以及开发过程。该框架使用了特定的方式来进行配置，从而使开发人员不再需要定义样板化的配置。 

    Spring Boot 简化了基于 Spring 的应用开发，通过少量的代码就能创建一个独立的、产品级别的 Spring 应用。Spring Boot 为 Spring 平台及第三方库提供开箱即用的设置，这样你就可以有条不紊地开始。   

* Spring Cloud 都做了哪些事
    Spring Cloud 是一系列框架的有序集合，它利用 Spring Boot 的开发便利性巧妙地简化了分布式系统基础设施的开发，如服务发现注册、配置中心、消息总线、负载均衡、断路器、数据监控等，都可以用 Spring Boot 的开发风格做到一键启动和部署。

* Spring Cloud的核心功能：
    - 分布式/版本化配置
    - 服务注册和发现
    - 路由
    - 服务和服务之间的调用
    - 负载具横
    - 断路器
    - 分布式消息传递


  ```mermaid
   graph TD;

    A[PC/Mobile] --> B[Nginx]
    B --> C[API网关]
    C --> D[服务注册中心]
    E --> F[配置中心]
    C --> E[各微服务模块]
    C --> F[配置中心]
    E --> D[服务注册中心]
    F --> D[服务注册中心]
    
  ```      

  * 各组件的运行流程：
   - 所有请求通过nginx，统一通过API网关（Zuul）来访问内部服务
   - 网关接收到请求后，从注册中心(Eureka)获取可用服务
   - 由 Ribbon 进行均衡负载后，分发到后端的具体实例
   - 微服务之间的调用通过Feign进行通信处理业务（Feign实现了Ribbon,实现了负载均衡）
   - Hystrix 负责处理服务超时熔断
   - Turbine 监控服务间的调用和熔断相关指标

   ## 关系
   Spring Boot 是一套快速配置脚手架，可以基于 Spring Boot 快速开发单个微服务。

   Spring Cloud 是一个基于 Spring Boot 实现的服务治理工具包;Spring Boot 专注于快速、方便集成的单个微服务个体;Spring Cloud 关注全局的服务治理框架。