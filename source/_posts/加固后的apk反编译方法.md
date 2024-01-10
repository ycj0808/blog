---
title: 加固后的apk反编译方法之Frida
donate: true
date: 2018-07-27 08:19:35
categories:
tags:
---

## 简介
Fria是一款基于Python + JavaScript 的Hook与调试框架，在Android\Linux\Windows等平台均能使用。以Mac平台为例，来对
android应用程序进行hook.[Frida官网](https://www.frida.re./)

## 安装Frida
1. 通过pip安装
```sh
pip install frida
```
2. 去下载对应平台的egg安装包进行安装
[下载地址](https://pypi.python.org/pypi/frida)
当前版本12.0.7。下载对应平台和python版本的安装包，如Mac python3.6对应frida-12.0.7-py3.6-macosx-10.6-intel.egg 

注：由于网络原因，方法1安装时间太久，这里推荐第二种方法。

安装完成后在命令窗口执行命令
```
frida-ps

 PID  Name
-----  --------------------------------------------
  564  AirPlayUIAgent
17427  Android Studio
  909  App
 1516  Code
67732  CoreServicesUIAgent
  602  Dr. Cleaner
60553  Firefox
61307  FirefoxCP Web Content
60566  FirefoxCP Web Content
68927  Google Chrome
62086  Keychain Circle Notification
  712  LaterAgent
  581  QQMacMgrMonitor
  618  Shadowsocks
69241  Siri
69270  SiriNCService
 1879  Sublime Text
  346  SystemUIServer
  577  TISwitcher
  501  Wi-Fi
  451  com.apple.PressAndHold
  393  com.apple.dock.extra
  385  iTunes Helper
  409  imklaunchagent
  117  loginwindow
  568  nbagent
```

## Android下Frida环境的搭建
真机：小米3- 已获取root 权限
genomotion模拟器7.1版本

1. [下载frida-server](https://github.com/frida/frida/releases)
找到对应平台对应版本的包下载，如frida-server-12.0.7-android-arm64.xz frida-server-12.0.7-android-arm.xz  frida-server-12.0.7-android-x86_64.xz

小米3,选择frida-server-12.0.7-android-arm64.xz

2. 解压包
```
 xz -d frida-server-12.0.7-android-arm64.xz
```

3. 文件上传到手机中，并赋予执行权限
```
adb push frida-server-12.0.7-android-arm64 /data/local/tmp/frida-server

adb shell
cd /data/local/tmp
chmod 755 frida-server
./frida-server
```

4. 查看frida-server是否启动成功
```
frida-ps -U #-U表示USB，允许Frida检查USB设备
```

## 下载基于Frida的脱壳工具
[frida-unpack](https://github.com/dstmath/frida-unpack.git)

脚本使用方法：
* 在手机上启动Frida server端
* 执行脱壳脚本
```
./inject.sh 脱壳的应用包名 OpenMemory.js
```
* 脱壳后的dex保存在/data/data/应用包名/目录下

另，python脚本支持
```
python3 frida_unpack.py 应用包名
```

* 查看/data/data/应用包名/目录下的dex文件

```
使用dex-tools

sh d2j-jar2dex.sh xxx.dex
```