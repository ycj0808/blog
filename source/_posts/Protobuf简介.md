---
title: Protobuf简介
donate: true
date: 2018-04-26 10:56:35
categories: protobuf
tags: protobuf
---

## Protobuf简介
Google Protocol Buffer(Protobuf)是Google公司内部的混合语言数据标准，可以用于RPC系统和持续数据存储系统。

Protocol Buffers是一种轻便高效的数据化存储格式，可以用于结构化数据穿行化，或者说序列化。它很适合做数据存储或RPC数据交换格式。可用于通讯协议、
数据存储等领域的语言无关、平台无关、可扩展的序列化结构数据格式。

## 安装
下载Protobuf：http://code.google.com/p/protobuf/downloads/list

linux自行编译
```
tar zxvf protobuf-2.5.0.tar.gz
cd protobuf-2.5.0
./configure --prefix=/usr/local/protobuf
make
make check
make install
```

**Protobuf消息定义，数据类型**
完整的Protobuf数据类型参考：http://www.cnblogs.com/dkblog/archive/2012/03/27/2419010.html

**ProtoBuf的简单使用**
定义一个消息的协议：如下协议，命名为user.proto
```
option java_package="cn.slimsmart.protoc.demo"
option java_outer_classname="User";
message UserInfo{
    required string id=1;
    required string name=2 [default = "Jack"];
    required int32 age=3 [default=20];
    optional string desc=4;
}
```

java_package java包路径
java_outer_classname java类型
message 定义类及属性
用protoc生成各种定义语言的消息实体，如Java
./protoc --java_out=./user.proto
在当前目录下生成cn/slimsmart/protoc/demo/User.java

在工程引入依赖jar包
```
        <dependency>
			<groupId>com.google.protobuf</groupId>
			<artifactId>protobuf-java</artifactId>
			<version>2.6.1</version>
		</dependency>
```

**序列化测试**
```
package cn.slimsmart.protoc.demo
public class Test {  
    public static void main(String[] args) {  
        User.UserInfo.Builder builder =User.UserInfo.newBuilder();  
        builder.setId("699B599EF7E44EEFA0B9A659A03CD159");  
        builder.setAge(55);  
        builder.setName("lucy");  
        builder.setDesc("hello world");  
        User.UserInfo userinfo = builder.build();  
        System.out.println(userinfo.toString());  
        System.out.println(userinfo.toByteString().toStringUtf8());  
    }  
} 
```

## Protobuf的优点
Protobuf相比XML，更小、更快、也更简单。可以定义自己的数据结构，然后使用代码生成器生成的代码来读写这个数据结构。
使用Protobuf对数据结构进行一次描述，即可利用各种不同语言或从各种不同数据流中对你的结构化数据轻松读写。
Protobuf语义更清晰，无需类似XML解析器的东西。

使用Protobuf无需学习复杂的文档对象模型，Protobuf编程模式比较友好，简单易学，同时拥有良好的文档和示例。

## Protobuf不足
Protobuf与XML相比也有不足之处。功能简单，无法用来表示复杂的概念。
XML已经成为多种行业标准的编写工具，Protobuf只是Google公司内部使用的工具，在通用性上还差很多。