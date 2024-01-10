---
title: Centos7安装TICK套装进行系统监控
donate: true
date: 2018-07-06 17:53:16
categories: TICK
tags: TICK 报警
---



## 添加 TICK 套装 Repository
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

## 安装Chronograf
Chronograf是一个数据可视化软件，包含控制台，报表。同时集成了Kapacitor的报警功能
```s
sudo yum install chronograf

或
docker pull quay.io/influxdb/chronograf:1.5.0.1
```

启动
```s
sudo systemctl start chronograf
```
关闭防火墙或者设置防火墙
```s
firewall-cmd --state //查看防火墙状态

systemctl status firewalld.service //查看防火墙状态

systemctl stop firewalld.service //关闭防火墙
systemctl disable firewalld.service //禁止防火墙开机启动
```
访问 http://ip:8888 Chronograf界面，输入influxdb数据库的用户名和密码，然后单击连接数据源。
单击host列表，可以看到主机的一系列图表。


## 安装Kapacitor

Kapacitor 是数据处理引擎，主要用来作为报警使用
```s
sudo yum install kapacitor  //安装失败

或
wget https://dl.influxdata.com/kapacitor/releases/kapacitor-1.5.0.x86_64.rpm
sudo yum localinstall kapacitor-1.5.0.x86_64.rpm

或docker 安装
docker pull kapacitor
```
编辑文件 /etc/kapacitor/kapacitor.conf,定位到[[influxdb]] 
```s
# Multiple InfluxDB configurations can be defined.
# Exactly one must be marked as the default.
# Each one will be given a name and can be referenced in batch queries and InfluxDBOut nodes.
[[influxdb]]
  # Connect to an InfluxDB cluster
  # Kapacitor can subscribe, query and write to this cluster.
  # Using InfluxDB is not required and can be disabled.
  enabled = true
  default = true
  name = "localhost"
  urls = ["http://localhost:8086"]
  username = "admin"
  password = "admin"
```
启动
```s
sudo systemctl daemon-reload
sudo systemctl start kapacitor
```

验证Kapacitor是否在运行，使用以下命令：
```s
kapacitor list tasks
```
如果Kapacitor启动并运行，您将看到一个空的任务列表，如下所示：
```
    ID                            Type      Status    Executing Databases and Retention Policies
```
安装和配置Kapacitor后，我们安装TICK的用户界面组件，以便我们可以看到一些结果并配置一些警报。


## 配置警报
设置一个简单的警报，寻找高CPU使用率。 将鼠标悬停在左侧导航菜单上，找到ALERTING部分，然后点击Kapacitor Rules 。 然后单击创建新规则 。 在第一部分中，单击telegraf.autogen选择时间序列。 然后从显示的列表中选择系统 。 然后选择load1 。您将在下面的部分中立即看到相应的图表。 在图表上方，找到Load1大于的值为“ 发送警报”的字段，并为该值输入1.0 。 然后将以下文本粘贴到“ 警报消息”字段中以配置警报消息的文本：
```s
{{ .ID }} is {{ .Level }} value: {{ index .Fields "value" }}
```
可以将鼠标悬停在“ 模板”部分中的条目上，以获取每个字段的说明。 然后从发送此警报到下拉列表中选择Smtp选项，并在相关字段中输入您的电子邮件地址。 默认情况下，您将以JSON格式接收邮件，如下所示：


```json
//示例消息
{
    "Name":"system",
    "TaskName":"chronograf-v1-50c67090-d74d-42ba-a47e-45ba7268619f",
    "Group":"nil",
    "Tags":{
        "host":"centos-tick"
    },
    "ID":"TEST:nil",
    "Fields":{
        "value":1.25
    },
    "Level":"CRITICAL",
    "Time":"2017-03-08T12:09:30Z",
    "Message":"TEST:nil is CRITICAL value: 1.25"
}
```

您可以为邮件警报设置更多可供人读取的邮件。为此，请在将电子邮件正文文本放在此处占位符的文本框中输入消息。 您可以通过单击页面左上角的名称并输入新名称来重命名此规则。 最后，单击右上角的Save Rule以完成配置此规则。 要测试此新创建的警报，请使用dd命令从/dev/zero读取数据并将其发送到/dev/null ，以创建CPU尖峰：
```s
dd if=/dev/zero of=/dev/null
```

让命令运行几分钟，这应该足以创建一个尖峰。您可以随时通过按CTRL+C停止命令。 过一会儿，您将收到一封电子邮件。此外，您还可以通过单击Chronograf用户界面左侧导航菜单中的警报历史记录来查看所有警报。 注意 ：确认您可以接收快讯后，请务必停止使用CTRL+C启动的dd命令


