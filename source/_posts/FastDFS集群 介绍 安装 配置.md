---
title: FastDFS集群 介绍 安装 配置
donate: true
date: 2018-3-14 10:30:27
categories: 软件
tags:
---
## FastDFS 介绍

FastDFS 有三个角色：跟踪服务器（Tracker Server）、存储服务器（Storage Server）和客户端（Client）

- Tracker Server:跟踪服务器，主要做调度工作，起到均衡的作用；负责管理所有的 storage server
和 group，每个 storage 在启动后会连接 Tracker，告知自己所属 group 等信息，并保持周期性心跳。

- 存储服务器，主要提供容量和备份服务；以 group 为单位，每个 group 内可以有多台 storage server，数据互为备份。

- 客户端，上传下载数据的服务器，也就是我们自己的项目所部署在的服务器。

![架构图](http://icefire.me/images/fastdfs.png)


## 环境准备
- 系统 centos6.8 或centos7+
- 至少四台服务器：10.4.120.31/32，10.4.120.33/34
- 安装包
```
fastdfs-5.11.tar.gz
libfastcommon.zip
nginx1.12+
fastdfs-nginx-module_v1.16.tar.gz
```
- 规划
tracker 服务器：10.4.120.31/32  storage服务器：10.4.120.33/34

## 安装
* 在安装FastDFS和nginx之前，确保gcc，gcc-c++，libstdc++-devel pcre-devel make等依赖工具
```
#安装依赖软件
yum -y install gcc gcc-c++ libstdc++-devel pcre-devel zlib-devel wget make
yum -y groupinstall 'Development Tools'
```

1. 安装libfastcommon
```
unzip libfastcommon.zip -d /usr/local
cd /usr/local/libfastcommon
make 
make install
```

2. 安装FastDFS
```
tar -xvzf fastdfs-5.11.tar.gz -C /usr/local
cd /usr/local/fastdfs-5.11
make 
make install
```

安装好之后，在/usr/bin目录下，可以看fdfs开头的命令工具
```
FastDFS安装完成之后，所有配置文件在/etc/fdfs目录下，tracker需要tracker.conf配置文件，storage需要storage.conf配置文件
```

3. 安装tracker(31/32)
将tracker.conf.sample文件重命名为tracker.conf，然后修改配置文件/etc/fdfs/tracker.conf
```

# 存储日志和数据的根目录
mkdir /data/fastdfs

cd /etc/fdfs
cp tracker.conf.sample tracker.conf
```
修改tracker.conf文件，修改base_path路径（文件存储路径）
```
vi tracker.conf
base_path=/data/fastdfs
```

配置文件中这几个参数需要注意：
```
#启用配置文件
disabled=false
#设置tracker的端口号
port=22122
#设置tracker的数据文件和日志目录（需手动创建）
base_path=/data/fastdfs
#设置http端口号
http.server_port=80
```

启动tracker
```
fdfs_trackerd /etc/fdfs/tracker.conf #启动tracker

fdfs_trackerd /etc/fdfs/tracker.conf restart #重启
```

查看端口22122是否开始监听
```
ps -ef|grep fdfs

netstat -unltp | grep fdfs
```

或查看tracker日志是否启动
```
cat /data/fastdfs/logs/trackerd.log
```

## 安装storage（33/34）

存储节点分为一个组，group1(33/34)
```
mkdir /data/fastdfs

cd /etc/fdfs
cp storage.conf.sample storage.conf
```
修改配置

storage主要完成base_path，store_path以及tracker的连接地址以及storage的http服务端口配置等
```
vi /etc/fdfs/storage.conf

group_name=group1                   # 组名（第一组为group1，第二组为group2，依次类推...）
base_path=/data/fastdfs             # 数据和日志文件存储根目录
store_path0=/data/fastdfs           #第一个存储目录，第二个存储目录起名为：store_path1=xxx，其它存储目录名依次类推...
store_path_count=1                  # 存储路径个数，需要和store_path个数匹配
tracker_server=10.4.120.31:22122          # tracker服务器IP和端口
tracker_server=10.4.120.32:22122          # tracker服务器IP和端口
```

启动Storage

启动storage，会根据配置文件的设置自动创建多级存储目录，查看端口23000是否开始监听，确认启动是否成功。
```
fdfs_storaged /etc/fdfs/storage.conf start   #启动
fdfs_storaged /etc/fdfs/storage.conf restart #重启

netstat -unltp | grep fdfs 查看监听端口
```

查看日志
```
cat /data/fastdfs/logs/storaged.log 
```
使用fdfs_monitor /etc/fdfs/storage.conf，运行fdfs_monitor查看storage服务器是否已经登记到tracker服务器
```
fdfs_monitor /etc/fdfs/storage.conf
```

如果出现ip_addr = Active, 则表明storage服务器已经登记到tracker服务器，如下：
```
Storage 1:
        id = 10.4.120.32
        ip_addr =10.4.120.32 (localhost)  ACTIVE
```

至此，tracker、storage等配置都完成并成功启动

## 在storage上安装nginx
解压安装包
```
tar -xvzf fastdfs-nginx-module_v1.16.tar.gz -C /usr/local
tar -zvxf nginx-1.12.0.tar.gz  -C /usr/local

```

需要先配置软连接：
```
ln -sv /usr/include/fastcommon /usr/local/include/fastcommon 
ln -sv /usr/include/fastdfs /usr/local/include/fastdfs 
ln -sv /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so
```
安装nginx的时候，添加 fastdfs-nginx-module-master模块
```
cd /usr/local/nginx-1.12.0
./configure --prefix=/usr/local/nginx --add-module=/usr/local/fastdfs-nginx-module/src
make 
make install
```

安装成功，查看版本信息(配置环境变量 添加/usr/local/nginx/sbin/)
```
nginx -V
```

## 配置
配置fastdfs-nginx-module

进入fastdfs-nginx-module的src目录，将md_fastdfs.conf配置文件拷贝到/etc/fdfs/目录中
```
cd /usr/local/fastdfs-nginx-module/src
cp mod_fastdfs.conf /etc/fdfs/
```

配置 mod_fastdfs.conf
```
vi /etc/fdfs/mod_fastdfs.conf


一般只需改动以下几个参数即可：
base_path=/data/fastdfs           #保存日志目录
tracker_server=10.4.120.30:22122
tracker_server=10.4.120.31:22122 
storage_server_port=23000         #storage服务器的端口号
group_name=group1                 #当前服务器的group名
url_have_group_name = true        #文件url中是否有group名
store_path_count=1                #存储路径个数，需要和store_path个数匹配
store_path0=/data/fastdfs         #存储路径
group_count = 1                   #设置组的个数
```

在末尾增加组的具体信息：
```
[group1]
group_name=group1
storage_server_port=23000
store_path_count=1
store_path0=/data/fastdfs
```

建立M00至存储目录的符号连接
```
ln -s /data/fastdfs/data /data/fastdfs/data/M00
ll /data/fastdfs/data/M00
```

配置nginx

编辑/usr/local/nginx/conf配置文件目录下的nginx.conf，设置添加storage信息并保存
```
vi /usr/local/nginx/conf/nginx.conf

在server段中添加

location ^~ /group1/M00 {
                 root /data/fastdfs/;
                 ngx_fastdfs_module;
        }
```
复制fastdfs中的http.conf、mime.types文件到/etc/fdfs
```
cp /usr/local/fastdfs-5.11/conf/http.conf /usr/local/fastdfs-5.11/conf/mime.types  /etc/fdfs
```
至此，nginx以及FastDFS插件模块设置完成.

## 运行
```
nginx 

netstat -untlp | grep nginx

cat /usr/local/nginx/logs/error.log
```

在error.log中没有错误，既启动成功。可以打开浏览器，直接访问http://10.4.120.31，查看是否弹出nginx欢迎页面

将nginx设置为开机启动：
```
vi /etc/rc.d/rc.local

#添加命令
/usr/local/nginx/sbin/nginx
```

## 在tracker上安装nginx
在tracker上安装的nginx主要为了提供http访问的反向代理、负载均衡以及缓存服务

1. 安装

解压
```
tar -zvxf nginx-1.12.2.tar.gz -C /usr/local

cd /usr/localnginx-1.12.2
./configure --prefix=/usr/local/nginx
make
make install
```

配置

编辑/usr/local/nginx/conf配置文件目录下的nginx.conf，设置负载均衡
```
vi /usr/local/nginx/conf/nginx.conf

## 配置
worker_processes  4;                  #根据CPU核心数而定
events {
    worker_connections  65535;        #最大链接数
    use epoll;                        #新版本的Linux可使用epoll加快处理性能
}
http {
    #设置group1的服务器
    upstream fdfs_group1 {
        server 10.4.120.33:80 weight=1 max_fails=2 fail_timeout=30s;
        server 10.4.120.34:80 weight=1 max_fails=2 fail_timeout=30s;
    }
    /*#设置group2的服务器
    upstream fdfs_group2 {
        server 192.168.54.233:8080 weight=1 max_fails=2 fail_timeout=30s;
        server 192.168.54.234:8080 weight=1 max_fails=2 fail_timeout=30s;
    }*/

   server {
       #设置服务器端口
        listen       80;
       #设置group1的负载均衡参数
        location /group1/M00 {
            proxy_pass http://fdfs_group1;
        }
        /*#设置group2的负载均衡参数
        location /group2/M00 {
            proxy_pass http://fdfs_group2;
        }*/
      }

    }
```

至此nginx设置完成


## 运行
```
nginx 

netstat -untlp | grep nginx

cat /usr/local/nginx/logs/error.log
```

在error.log中没有错误，既启动成功。可以打开浏览器，直接访问http://10.4.120.33，查看是否弹出nginx欢迎页面

将nginx设置为开机启动：
```
vi /etc/rc.d/rc.local

#添加命令
/usr/local/nginx/sbin/nginx
```


## 测试上传

尝试上传一个文件到FastDFS，然后访问试试。先配置client.conf文件
```
cd /etc/fastdfs
cp client.conf.sample  client.conf
vi /etc/fdfs/client.conf

##修改以下参数
base_path=/data/fastdfs                   #日志存放路径
tracker_server=10.4.120.31:22122         
tracker_server=10.4.120.32:22122 
http.tracker_server_port=80
```

fdfs_upload_file上传一个文件，程序会自动返回文件的URL
```
fdfs_upload_file /etc/fdfs/client.conf /root/test.jpg
group2/M00/00/00/wKg26VncfamAEqZ0AAu-4Kcs3QI677.jpg
```

然后使用浏览器访问:
```
http://10.4.120.31/group2/M00/00/00/wKg26VncfamAEqZ0AAu-4Kcs3QI677.jpg
```



## 参考
 * http://www.ityouknow.com/fastdfs/2017/10/10/cluster-building-fastdfs.html
 * https://my.oschina.net/wangmengjun/blog/1142982