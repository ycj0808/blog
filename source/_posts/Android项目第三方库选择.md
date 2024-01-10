---
title: Android项目第三方库选择
donate: true
date: 2018-04-11 09:48:24
categories: android
tags: android
---

## 网络请求
* okhttp (一个支持HTTP 和 HTTP/2 的客户端)
```
implementation 'com.squareup.okhttp3:okhttp:3.7.0'
implementation 'com.squareup.okhttp3:logging-interceptor:3.7.0'
```

* retrofit（一个基于Okhttp的Restful的http网络请求框架）
```
implementation 'com.squareup.retrofit2:retrofit:2.2.0'
implementation 'com.squareup.retrofit2:converter-gson:2.2.0'
implementation 'com.squareup.retrofit2:adapter-rxjava:2.2.0'
```

* Rxjava （1.x）（异步响应式库）
```
implementation 'io.reactivex:rxjava:1.2.7'
implementation 'io.reactivex:rxandroid:1.2.1'
implementation 'com.artemzin.rxjava:proguard-rules:1.2.7.0'
```

* Rxjava 2.x
```
implementation 'io.reactivex.rxjava2:rxjava:2.1.4'
implementation 'io.reactivex.rxjava2:rxandroid:2.0.2'

```

* RxEasyHttp
```
implementation 'com.zhouyou:rxeasyhttp:2.1.2'
```

* okhttputils
```
implementation 'com.zhy:okhttputils:2.6.2'
```

## 文件下载
* RxDownload 
```
implementation  'zlc.season:rxdownload3:1.2.2'
```

## 权限处理
* easypermissions
```
implementation 'pub.devrel:easypermissions:1.2.0'
```

## 万能Adapter
```
implementation 'com.zhy:base-rvadapter:3.0.3'
```

## 下拉刷新
```
implementation 'com.scwang.smartrefresh:SmartRefreshLayout:1.0.5.1'
implementation 'com.scwang.smartrefresh:SmartRefreshHeader:1.0.5.1'
```

## 图片处理

* advancedluban （图片压缩工具）
```
implementation 'me.shaohui.advancedluban:library:1.3.3'
```

* glide (图片加载)
```
implementation 'com.github.bumptech.glide:glide:3.7.0'
```

* imgsel(文件选择)
```
implementation 'com.yuyh.imgsel:library:1.3.8'
```

* circleimageview（圆形头像）
```
implementation 'de.hdodenhof:circleimageview:2.1.0'
```


## 弹出框

* material-dialogs
```
implementation 'com.afollestad.material-dialogs:core:0.9.6.0'
```

## 状态栏兼容处理
* statusbaruitl
```
implementation 'com.jaeger.statusbaruitl:library:1.3.6'
```

## 底部菜单
* bottom-navigation-bar
```
implementation 'com.ashokvarma.android:bottom-navigation-bar:1.3.0'
```

## 单Activity+多Fragment的架构和多Activity+多Fragment的形式架构
* fragmentation
```
implementation 'me.yokeyword:fragmentation:1.3.3'
```

## android日志
* logger
```
implementation 'com.orhanobut:logger:1.15'
```

## 依赖注入

* Dagger(帮我们把依赖对象的实力化工作完成)
```
implementation 'com.google.dagger:dagger:2.5'
annotationProcessor 'com.google.dagger:dagger-compiler:2.5'
```

* ButterKnife (只是做View的注入)
```
implementation 'com.jakewharton:butterknife:8.5.1'
annotationProcessor 'com.jakewharton:butterknife-compiler:8.5.1'
provided 'org.glassfish:javax.annotation:10.0-b28'
```

## Banner 广告页
```
implementation 'com.youth.banner:banner:1.4.10'
```

## 页面布局
* vlayout
```
implementation ('com.alibaba.android:vlayout:1.2.8@aar') {
        transitive = true
}
```

## 日期格式化
* joda
```
implementation 'net.danlew:android.joda:2.9.5'
```

## 应用更新

* AppUpdater
```
implementation 'com.github.javiersantos:AppUpdater:2.6.1'
```









