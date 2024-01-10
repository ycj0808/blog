---
title: okio优点分析
donate: true
date: 2018-05-30 09:47:43
categories:
tags:
---

## okio优点
1. 使用方便
- Buffer是处理可变byte序列的利器，它可以根据使用情况自动增长，在使用过程中不用关心位置的处理
- Java.IO读取不同类型数据要用DataInputStream来包装,使用缓存要使用BufferedOutputStream,而在okio中BufferedSink/BufferedSource具有以上所有功能
- okio提供了方便压缩及字符常用处理工具

2. 速度快
- okio采用了segment机制进行内存共享，极大减少copy操作带来的时间消耗，加快了读写速度
- okio引入ByteString使其在byte[]与String之间转换速度非常快（ByteString内部以两种变量记录了同个数据byte[] data; transient String utf8;),空间换时间

3. 稳定
- okio提供了超时机制，不仅在IO操作上加上超时的判定，包括close，flush之类的方法中都有超时机制

4. 内存消耗小
- 虽然okio在byteString采用空间换时间，但是对内存也做极致优化，总体还是极大提高了性能
- okio的segement机制进行内存复用，上传大文件时完全不用考虑OOM

