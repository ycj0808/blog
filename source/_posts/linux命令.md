---
title: linux命令
donate: true
date: 2019-02-19 14:28:44
categories:
tags:
---

## wc 
可以计算文件的byte数，字数或列数

### 参数
* -c或--bytes或--chars只显示bytes数

* -l或--lines只显示行数

* -w或--words只显示字数

```
wc testfile #testfile文件的统计信息
3 92 598 testfile  #testfile文件的行数为3、单词数92、字节数598
```


## 删除x个文件
```
ls -t test-* |tail -n 5|xargs rm -f #删除5个以test-开头的文件，按时间从远到近的顺序
```


## 从远程服务器复制目录到本地
```
scp -r root@10.10.35.21:/app/env/redis/conf/ ./




scp ./service-basicdata-provider-5.0.0-SNAPSHOT.jar root@10.10.35.15:/app 

scp ./service-basicdata-provider-5.0.0-SNAPSHOT.jar root@10.10.35.18:/app/service-basicdata-provider-5.0.0-SNAPSHOT


scp ./service-airline-adaptor-intl-recommend-5.0.0-SNAPSHOT.jar   root@10.10.135.24:/app/service-airline-adaptor-intl-recommend-5.0.0-SNAPSHOT
/app/service-airline-adaptor-intl-recommend-5.0.0-SNAPSHOT

service-airline-adaptor-intl-recommend-5.0.0-SNAPSHOT.jar
```





