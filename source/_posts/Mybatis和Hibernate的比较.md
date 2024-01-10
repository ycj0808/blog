---
title: Mybatis和Hibernate的比较
donate: true
date: 2018-04-10 10:52:33
categories: java
tags: java
---

## 性能
由于Hibernate比Mybatis抽象封装的程度更高，理论上单个语句执行的性能会低一些。
但Hibernate会设置缓存，对于重复查询有一定的优化，而且从编码效率来说，Hibernate 的编码效果肯定是会高一点的。

## ORM
Hibernate 是完备的 ORM 框架，是符合 JPA 规范的，但 MyBatis 不是。MyBatis 比单纯写 JDBC 肯定是方便一点，但无可避免还是要写SQL，且无法做到跨数据库 。Hibernate 使用 JPA 就可以无需考虑数据库的兼容性问题。

使用 Hibernate 的一个难点是，如何来设计对象之间的关系。如果是关系型数据库的话，表和表是通过外键来进行关联的。而在 ORM 中，则需要从面向对象的角度出发，来设计对象之间的关联关系。

Hibernate着力点对象和对象之间的关系；Mybatis着力于POJO与SQL之间的映射关系。

## SPring集成
Spring 以及 Spring Boot 官方都没有针对 MyBatis 有具体的支持，但对 Hibernate 的集成一直是有的。

## 开发难度
Hibernate的开发难度大于Mybatis、Spring Data。主要由于Hibernate封装了完整的对象关系映射机制，以至于内部的实现比较复杂庞大，学习周期长。

Mybatis主要依赖于SQL的编写与ResultMap的映射

Spring Data易上手，通过命名规范、注解查询简化查询操作

## 查询
简单查询：Hibernate 提供了基础的查询方法，也可以根据具体的业务编写相应的SQL

Mybatis需要手动编写SQL语句，Spring Data 继承基础接口,可使用内置的增删改查方法

高级查询:Hibernate通过对象映射机制,开发者无需关心SQL的生成与结果映射,专注业务流程；Mybatis需要通过手动在XML文件中编写SQL语句以及ResultMap或者注解,Spring Data 提供了命名规范查询和注解查询更简便的编写想要的SQL。

## 扩展性
Hibernate与数据库具体的关联都在XML中，所以HQL对具体是用什么数据库并不是很关心

Mybatis由于所有SQL都是依赖数据库书写的，所以扩展性，迁移性比较差

Spring Data 与数据具体的关联可以通过命名规范查询、注解查询,无需关心数据库的差异,但是通过本地化SQL查询的话,就不易扩展。

## 缓存机制
相同点：Hibernate和Mybatis的二级缓存除了采用系统默认的缓存机制外，都可以通过实现你自己的缓存或为其他第三方缓存方案，创建适配器来完全覆盖缓存行为。

不同点：Hibernate的二级缓存配置在SessionFactory生成的配置文件中进行详细配置，然后再在具体的表-对象映射中配置是那种缓存。

MyBatis的二级缓存配置都是在每个具体的表-对象映射中进行详细配置，这样针对不同的表可以自定义不同的缓存机制。并且Mybatis可以在命名空间中共享相同的缓存配置和实例，通过Cache-ref来实现。

Spring Data 可以通过自己的缓存或者第三方缓存方案,配置满足自己业务需要的缓存行为。

## 总结
Hibernate 对数据库提供了较为完整的封装,封装了基本的DAO层操作,有较好的数据库移植性

Mybatis 可以进行更细致的SQL优化,查询必要的字段,但是需要维护SQL和查询结果集的映射,而且数据库的移植性较差,针对不同的数据库编写不同的SQL

Spring Data JPA 极大的简化了数据库访问,可以通过命名规范、注解的方式较快的编写SQL
