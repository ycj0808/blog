---
title: Genymotion模拟器安装配置ARM支持
donate: true
date: 2018-09-21 09:18:28
categories:
tags:
---

针对5.0以上模拟器的解决方法：

1. 下载[Genymotion-ARM-Translation.zip](https://pan.baidu.com/s/1dFxiVol)

2. 把下载的文件push到手机中
```
adb push Genymotion-ARM-Translation.zip /sdcard/Download
```

3. 然后adb shell flash-archive.sh 该zip包 即可
```
adb shell flash-archive.sh /sdcard/Download/Genymotion-ARM-Translation.zip
```