---
title: Centos7系统实时监控之Telegraf+influxdb+grafana
donate: true
date: 2018-07-09 14:27:50
categories:
tags:
---


创建文件/etc/yum.repos.d/influxdata.repo
```s
sudo vi /etc/yum.repos.d/influxdata.repo
```
编辑内容
```repo
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
```

## 安装InfulxDB
```s
sudo yum install influxdb

或

docker pull influxdb
```
启动
```s
sudo systemctl start influxdb
```
查看是否正常运行
```s
systemctl status influxdb

● influxdb.service - InfluxDB is an open-source, distributed, time series database
   Loaded: loaded (/usr/lib/systemd/system/influxdb.service; enabled; vendor preset: disabled)
   Active: active (running) since 五 2018-07-06 14:08:56 CST; 17s ago
     Docs: https://docs.influxdata.com/influxdb/
 Main PID: 1879 (influxd)
   Memory: 6.2M
   CGroup: /system.slice/influxdb.service
           └─1879 /usr/bin/influxd -config /etc/influxdb/influxdb.conf

```

启动influxdb控制台
```s
influx
```
创建一个admin用户，作为管理用户
```s
create user "admin" with password 'admin' with all privileges
```
验证是否已创建用户：
```s
show users

user  admin
----  -----
admin true

```
退出控制台
```s
exit
```

修改/etc/influxdb/influxdb.conf，这是influxdb的配置文件
```s
[http]
 # Determines whether HTTP endpoint is enabled.
 # enabled = true
 # The bind address used by the HTTP service.
 # bind-address = ":8086"
 # Determines whether HTTP authentication is enabled.
 auth-enabled = true
```
保存文件，重启influxdb服务
```s
sudo systemctl restart influxdb
```
infulxdb已配置，安装Telegraf

## 安装和配置Telegraf
```s
sudo yum install telegraf

或

docker pull telegraf
```

Telegraf使用插件来输入和输出数据，默认输出插件用于influxdb。由于我们启用了influxdb的身份认证，
我们修改Telegraf的配置文件以指定我们配置的用户和密码。
```s
sudo vi /etc/telegraf/telegraf.conf
```

找到[outputs.influxdb]部分提供用户名和密码
```s
[[outputs.influxdb]]
      ## The full HTTP or UDP endpoint URL for your InfluxDB instance.
      ## Multiple urls can be specified as part of the same cluster,
      ## this means that only ONE of the urls will be written to each interval.
      # urls = ["udp://localhost:8089"] # UDP endpoint example
      urls = ["http://localhost:8086"] # required
      ## The target database for metrics (telegraf will create it if not exists).
      database = "telegraf" # required

      ...

      ## Write timeout (for the InfluxDB client), formatted as a string.
      ## If not provided, will default to 5s. 0s means no timeout (not recommended).
      timeout = "5s"
      username = "sammy"
      password = "sammy_admin"
      ## Set the user agent for HTTP POSTs (can be useful for log differentiation)
      # user_agent = "telegraf"
      ## Set UDP payload size, defaults to InfluxDB UDP Client default (512 bytes)
      # udp_payload = 512
```

保存文件，退出编辑器，然后启动Telegraf:
```s
sudo systemctl start telegraf
```

然后检查服务是否正常运行
```s
systemctl status telegraf

● telegraf.service - The plugin-driven server agent for reporting metrics into InfluxDB
   Loaded: loaded (/usr/lib/systemd/system/telegraf.service; enabled; vendor preset: disabled)
   Active: active (running) since 五 2018-07-06 14:33:23 CST; 18s ago
     Docs: https://github.com/influxdata/telegraf
 Main PID: 2252 (telegraf)
   Memory: 10.8M
   CGroup: /system.slice/telegraf.service
           └─2252 /usr/bin/telegraf -config /etc/telegraf/telegraf.conf -config-directory /et...

```

Telegraf现在正在收集数据并将其写入influxdb。登录influxdb的控制台
```
influx -username 'admin' -password 'admin'
```
登录后，执行以下命令查看可用的数据库
```s
show databases
```
查看输出的数据库:
```s
name: databases
name
----
_internal
telegraf
```

查看telegraf数据库
```s
user telegraf
```
显示Telegraf通过执行此命令收集的各种测量
```s
show measurements

name: measurements
name
----
cpu
disk
diskio
kernel
mem
processes
swap
system
```
在终端窗口中运行telegraf -usage plugin-name，可以查看每个输入插件的使用说明。


## 安装Grafana及配置
[Grafana下载](https://grafana.com/grafana/download)

```s
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-5.2.1-1.x86_64.rpm 
sudo yum localinstall grafana-5.2.1-1.x86_64.rpm 

或
docker run -d --name=grafana -p 3000:3000 grafana/grafana 
```

配置告警邮箱
```s
cd /etc/grafana
vi grafana.ini

[smtp]
enabled = true
host = smtp.qq.com:587
user= xxx@qq.com
password= xxx
;cert_file=
;key_file=
skip_verify= true
from_address= xxx@qq.com
from_name= xxx
;ehlo_identity = dashboard.example.com

[emails]
;welcome_email_on_sign_up=false
```
启动服务、添加开机启动
```s
systemctl daemon-reload

systemctl start grafana-server

systemctl status grafana-server

systemctl enable grafana-server.service

```

Grafana使用及配置
登录http://localhost:3000,默认用户名 admin,密码：admin

连接数据源后，进入dashboard页面，创建仪表盘。可以通过https://grafana.com/dashboards来查看已经由其他用户共享的仪表盘
选取https://grafana.com/dashboards/1443 这个仪表盘，该仪表盘基本涵盖了一个系统需要监控的相关参数

Telegraf相关配置：
```s

[[inputs.net]]
interfaces= ["eth0,eth1,Io"]


[[inputs.cpu]]
percpu= true

totalcpu = true

collect_cpu_time = false

[[inputs.disk]]
ignore_fs =["tmpfs","devtmpfs"]

[[inputs.diskio]]
## Bydefault, telegraf will gather stats for all devices including

##disk partitions.

##Setting devices will restrict the stats to the specified devices.

#devices = ["sda", "sdb"]

##Uncomment the following line if you need disk serial numbers.

#skip_serial_number = false

[[inputs.kernel]]
# noconfiguration

[[inputs.mem]]
# noconfiguration

[[inputs.processes]]
# noconfiguration

[[inputs.swap]]

[[inputs.system]]

[[inputs.netstat]]

```

通过对任意监控项进行编辑可以增加告警规则