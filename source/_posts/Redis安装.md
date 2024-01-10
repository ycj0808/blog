---
title: Redis安装
donate: true
date: 2018-03-14 15:21:05
categories: 软件
tags:
---

## Redis源码安装
```
wget http://download.redis.io/releases/redis-4.0.8.tar.gz
tar xzf redis-4.0.8.tar.gz
cd redis-4.0.8
make
make install

# 在/usr/local/bin目录下
redis-server
redis-cli
...
```

## 使用RPM安装
```
wget https://www.rpmfind.net/linux/remi/enterprise/6/remi/x86_64/redis-4.0.8-1.el6.remi.x86_64.rpm
rpm -ivh redis-4.0.8-1.el6.remi.x86_64.rpm
```