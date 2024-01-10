---
title: android8.0及9.0适配
donate: true
date: 2019-05-15 10:15:40
categories:
tags:
---

## Android8.0适配

1. **通知**
Android8.0引入了通知渠道，其允许您为要显示的每种通知类型创建用户自定义的渠道。targetSdkVersion为26的应用创建通知时必须传入channelId,否则通知将不会显示。

```java
   NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        if (manager!=null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {//创建通知渠道
                NotificationChannel mChannel = new NotificationChannel("channel_default", "订阅消息", NotificationManager.IMPORTANCE_DEFAULT);
                manager.createNotificationChannel(mChannel);
            }
            NotificationCompat.Builder mBuilder;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
                mBuilder=
                        new NotificationCompat.Builder(context,"channel_default")
                                .setSmallIcon(R.drawable.ic_icon_niu)
                                .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.drawable.ic_icon))
                                .setContentText(content);
            }else{
                mBuilder=
                        new NotificationCompat.Builder(context,null)
                                .setSmallIcon(R.drawable.ic_icon_niu)
                                .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.drawable.ic_icon))
                                .setContentText(content);
            }
            if (TextUtils.isEmpty(title)) {
                title = context.getResources().getString(R.string.app_name);
            }
            mBuilder.setContentTitle(title);
            mBuilder.setDefaults(Notification.DEFAULT_ALL);
            mBuilder.setAutoCancel(true);
            mBuilder.setContentIntent(pendingIntent);
            mBuilder.setStyle(new NotificationCompat.BigTextStyle().bigText(content));
            int nid = new Random().nextInt(10000000);
            manager.notify(nid, mBuilder.build());
        }
```

2. **后台执行限制**
> 如果针对 Android 8.0 的应用尝试在不允许其创建后台服务的情况下使用 startService() 函数，则该函数将引发一个 IllegalStateException。

我们无法得知系统如何判断是否允许应用创建后台服务，所以我们目前只能简单 try-catch startService()，保证应用不会 crash，示例代码：
```java

Intent intent = new Intent(getApplicationContext(), InitializeService.class);
intent.setAction(InitializeService.INITIALIZE_ACTION);
intent.putExtra(InitializeService.EXTRA_APP_INITIALIZE, appInitialize);
ServiceUtils.safeStartService(mApplication, intent);

public static void safeStartService(Context context, Intent intent) {
    try { 
        context.startService(intent);
    } catch (Throwable th) {
        DebugLog.i("service", "start service: " + intent.getComponent() + "error: " + th);
        ExceptionUtils.printExceptionTrace(th);
    }
}
```

3. 允许安装未知来源应用
针对8.0的应用需要在AndroidManifest.xml中声明REQUEST_INSTALL_PACKAGES 权限，否则将无法进行应用内升级。

```
<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
```

4. 主题的Activity设置屏幕方向
针对8.0的应用，设置了透明主题的Activity，再设置屏幕方向，代码如下：
```
<style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
    <item name="android:windowIsTranslucent">true</item>
</style>

<activity
    android:name=".MainActivity"
    android:screenOrientation="portrait"
    android:theme="@style/AppTheme">
</activity>
```
将会抛出以下异常：
 ```
java.lang.IllegalStateException: Only fullscreen opaque activities can request orientation
 ```

 即使满足上述条件，该异常也并非一定会出现，为什么这么说，看下面两种表现：

- targetSdk=26，满足上述条件，API 26 手机没问题，API 27 手机没问题
- targetSdk=27，满足上述条件，API 26 手机Crash，API 27 手机没问题

可知，targetSdk=26时，API26和27都没问题

5. 桌面图标适配
针对8.0的应用如果不适配桌面图标，则应用图标在Launcher中将会被添加白色背景
[图标适配](https://mp.weixin.qq.com/s/WxgHJ1stBjokPi6lTUd1Mg)

6.隐式广播
> 由于  Android 8.0 引入了新的广播接收器限制，因此您应该移除所有为隐式广播 Intent 注册的广播接收器。将它们留在原位并不会在构建时或运行时令应用失效，但当应用运行在 Android 8.0 上时它们不起任何作用。

显式广播 Intent（只有您的应用可以响应的 Intent）在 Android 8.0 上仍以相同方式工作。
这个新增限制有一些例外情况。如需查看在以 Android 8.0 为目标平台的应用中仍然有效的隐式广播的列表，请参阅隐式广播例外。

自定义的广播无法被静态注册的BroadcastReceiver收到了，一下几个解决方案：
1. 动态注册BroadcastReceiver
因为registerReceiver()方法只能从一个运行的进程里调用，也就是说你需要一个正在运行的Activity或者一个后台Service，这样的方法虽然可用，但是这个进程终究会被kill导致广播收不到。

2. JobScheduler
官方推荐使用 JobScheduler 代替原来用隐式广播实现的「当某条件达成时发生广播完成某事」的「周期性」功能，并没有广播那么灵活。

3. 改为显示广播
如果广播只是APP自己发自己收，那么改为显示广播是最简单的。
```java
 intent.action = "com.example.test.CLOSE”;
 intent.setPackage(getPackageName()); //指定包名
 context.sendBroadcast(intent);
```
但是如果要发给其他 App 接收，而且不知道他们的包名的情况下，该怎么做的。
通过pm把所有隐式注册了这个自定义广播的 App列出来，然后转成显式调用

```java
Intent intent = new Intent();    
intent.setAction("com.example.test.CLOSE");    
sendImplicitBroadcast(context, intent);

private static void sendImplicitBroadcast(Context context, Intent i) {        
    PackageManager pm = context.getPackageManager();       
    List&lt;ResolveInfo&gt; matches = pm.queryBroadcastReceivers(i, 0);
    for (ResolveInfo resolveInfo : matches) {            
        Intent intent = new Intent(i);            
        intent.setPackage(resolveInfo.activityInfo.applicationInfo.packageName);            
        intent.setAction("com.example.test.CLOSE");            
        context.sendBroadcast(intent);        
    }
}
```

## Android9.0 适配

1. Apache HTTP client 相关类找不到
将 compileSdkVersion 升级到 28 之后，如果在项目中用到了 Apache HTTP client 的相关类，就会抛出找不到这些类的错误。这是因为官方已经在 Android P 的启动类加载器中将其移除，如果仍然需要使用 Apache HTTP client，可以在 Manifest 文件中加入：
```xml
    <uses-library android:name="org.apache.http.legacy" android:required="false"/>
```

在Android6.0以上使用
```
android {
    useLibrary 'org.apache.http.legacy'
}
```

2. 隐私权变更
如果您的应用需要访问设备的硬件序列号，您应改为请求 READ_PHONE_STATE 权限，然后调用 getSerial()
```
String serial;
 if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P){
     serial=Build.getSerial()。
 }else{
     serial=Build.SERIAL;
 }

```

3. 安全
默认情况下启用网络传输层安全协议 (TLS)
如果您的应用 Target 28+，则默认情况下 isCleartextTrafficPermitted() 函数返回 false。 如果您的应用需要为特定域名启用明文，您必须在应用的网络安全性配置中针对这些域名将 cleartextTrafficPermitted 显式设置为 true。

> 定义配置文件 res/xml/network_security_config.xml：
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">secure.example.com</domain>
    </domain-config>
</network-security-config>
```

> 然后在清单文件中申明
```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest ... >
    <application android:networkSecurityConfig="@xml/network_security_config"
                    ... >
        ...
    </application>
</manifest>
```

