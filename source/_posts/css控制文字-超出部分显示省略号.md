---
title: 'css控制文字,超出部分显示省略号'
donate: true
date: 2020-06-30 09:18:33
categories:
tags:
---

### 单行文本溢出显示省略号
```
overflow: hidden;
text-overflow:ellipsis;
white-space:nowrap;
```
### 多行文本溢出显示省略号
```
overflow:hidden; 
text-overflow:ellipsis;
display: -webkit-box;//必须结合的属性 ，将对象作为弹性伸缩盒子模型显示
-webkit-box-orient: vertical;//必须结合的属性 ，设置或检索伸缩盒对象的子元素的排列方式 
-webkit-line-clamp: 3;//用来限制在一个块元素显示的文本的行数
overflow: hidden;
```
**适用范围：**
因使用了WebKit的CSS扩展属性，该方法适用于WebKit浏览器及移动端

