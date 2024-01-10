---
title: nohup命令使用
donate: true
date: 2018-06-15 16:38:44
categories:
tags:
---

## nohup命令使用
* 一般形式：nohup command &
* 指定输出文件 nohup command > myout.file 2>&1 </dev/null &

说明：
* command > myout.file是将command的输出重定向到myout.file文件，即输出内容不打印到屏幕上，而是输出到myout.file文件

* 2>&1 是将标准出错重定向到标准输出， 这里的标准输出已经重定向到了myout.file,即将标准出错也输出到myout.file文件中

* </dev/null 不会有任何错误提示

* & 让命令在后台执行