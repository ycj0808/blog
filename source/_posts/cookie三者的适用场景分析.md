---
layout: 'localstorage,'
title: localStorage, sessionStorage,cookie三者的适用场景分析
date: 2020-03-23 09:30:22
tags:
---

H5浏览器缓存技术有以下三种：localStorage，sessionStorage，cookie

- localStorage 没有时间限制的数据存储，localStorage的生命周期是永久的，除非用户显示的再浏览器提供的UI上清除localStorage的信息，否则这些信息将永远存在。存放的数据大小一般为5MB，而且它仅再客户端中保存，不参与和服务器的通信。

- sessionStorage 仅再当前会话下有效，即会话级存储，关闭页面或浏览器后被清除。存放的数据大小一般为5MB，而且它仅再客户端中保存，不参与和服务器的通信。

- cookie 生命周期为只在设置cookie过期时间之前一直有效，即时窗口或浏览器关闭。存放数据大小为4K左右。有个数限制，一般不超过20个。与服务器通信，每次都会携带再HTTP投中，如果使用cookie保存过多数据会带来性能问题。

token一般使用cookie存储，可以设置过期时间