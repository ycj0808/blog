---
title: elastalert监控日志报警
donate: true
date: 2018-07-03 14:48:08
categories: elk
tags: elastalert
---

## 简述
Elastalert是Yelp公司用python2写的一个报警框架

## 安装Elastalert(python2.6或2.7)

下载最新elastalert并安装
```
git clone https://github.com/Yelp/elastalert.git
sudo python setup.y install

sudo pip install -r requirement.txt
```

安装完成后，会在/usr/local/bin/ 下生成elastalert命令

```s
//查看生成的elastalert命令
ls -l /usr/local/bin/elastalert*

-rwxr-xr-x 1 root root 396 2月  14 10:03 /usr/local/bin/elastalert
-rwxr-xr-x 1 root root 422 2月  14 10:03 /usr/local/bin/elastalert-create-index
-rwxr-xr-x 1 root root 430 2月  14 10:03 /usr/local/bin/elastalert-rule-from-kibana
-rwxr-xr-x 1 root root 416 2月  14 10:03 /usr/local/bin/elastalert-test-rule
```

## 设置索引
elastalert-create-index 命令创建elasticsearch 创建索引，默认情况下创建的索引是elastalert_status
```
./elastalert-create-index
```

## 设置配置文件和规则Rule
```
cp elastalert/config.yaml.example elastalert/config.yaml

vi elastalert/config.yaml
```
config.yaml中的内容

```yaml
# This is the folder that contains the rule yaml files
# Any .yaml file will be loaded as a rule
rules_folder: example_rules

# How often ElastAlert will query Elasticsearch
# The unit can be anything from weeks to seconds
run_every:
  minutes: 1

# ElastAlert will buffer results from the most recent
# period of time, in case some log sources are not in real time
buffer_time:
  minutes: 15

# The Elasticsearch hostname for metadata writeback
# Note that every rule can have its own Elasticsearch host
es_host: localhost

# The Elasticsearch port
es_port: 9200

# The AWS region to use. Set this when using AWS-managed elasticsearch
#aws_region: us-east-1

# The AWS profile to use. Use this if you are using an aws-cli profile.
# See http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
# for details
#profile: test

# Optional URL prefix for Elasticsearch
#es_url_prefix: elasticsearch

# Connect with TLS to Elasticsearch
#use_ssl: True

# Verify TLS certificates
#verify_certs: True

# GET request with body is the default option for Elasticsearch.
# If it fails for some reason, you can pass 'GET', 'POST' or 'source'.
# See http://elasticsearch-py.readthedocs.io/en/master/connection.html?highlight=send_get_body_as#transport
# for details
#es_send_get_body_as: GET

# Option basic-auth username and password for Elasticsearch
#es_username: someusername
#es_password: somepassword

# Use SSL authentication with client certificates client_cert must be
# a pem file containing both cert and key for client
#verify_certs: True
#ca_certs: /path/to/cacert.pem
#client_cert: /path/to/client_cert.pem
#client_key: /path/to/client_key.key

# The index on es_host which is used for metadata storage
# This can be a unmapped index, but it is recommended that you run
# elastalert-create-index to set a mapping
writeback_index: elastalert_status

# If an alert fails for some reason, ElastAlert will retry
# sending the alert until this time period has elapsed
alert_time_limit:
  days: 2
```

创建smtp_auth_file.yaml
```yaml
#发送邮件的邮箱
user: xxx@163.com
#不是邮箱密码，是设置的POP3密码
password: xxx
```

创建example_frequency.yaml

参见[creating-a-rules](http://elastalert.readthedocs.io/en/latest/running_elastalert.html#creating-a-rule)

```yaml
# Alert when the rate of events exceeds a threshold

# (Optional)
# Elasticsearch host
es_host: localhost

# (Optional)
# Elasticsearch port
es_port: 9200

# (OptionaL) Connect with SSL to Elasticsearch
#use_ssl: True

# (Optional) basic-auth username and password for Elasticsearch
#es_username: someusername
#es_password: somepassword

# (Required)
# Rule name, must be unique
name: Example frequency rule

# (Required)
# Type of alert.
# the frequency rule type alerts when num_events events occur with timeframe time
type: frequency

# (Required)
# Index to search, wildcard supported
index: filebeat-*

# (Required, frequency specific)
# Alert when this many documents matching the query occur within a timeframe
num_events: 1

# (Required, frequency specific)
# num_events must occur within this amount of time to trigger an alert
timeframe:
  minutes: 1

# (Required)
# A list of Elasticsearch filters used for find events
# These filters are joined with AND and nested in a filtered query
# For more info: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl.html
filter:
- term:
    errorDesc: "201"



#SMTP协议的邮件服务器相关配置
#smtp.163.com是网易163邮箱的smtp服务器
#登陆163邮箱后，找到 【设置】>【POP3/SMTP/IMAP】>开启，然后设置【客户端授权密码】
smtp_host: smtp.qq.com
smtp_port: 587

#用户认证文件，需要user和password两个属性
#注意将${userName}替换成具体用户名
smtp_auth_file: /Users/yangchj/soft/develop/elk/elastalert/smtp_auth_file.yaml
#回复给那个邮箱
email_reply_to: xxx@qq.com
#从哪个邮箱发送
from_addr: xx@qq.com



# (Required)
# The alert is use when a match is found
alert:
- "email"

# (required, email specific)
# a list of email addresses to send alerts to
email:
- "xxx@126.com"
```

## 测试规则
```
elastalert-test-rule ~/elastalert/example_rules/example_frequency.yaml
```

## 运行
```s
cd ~/elastalert
python -m elastalert.elastalert --verbose --rule example_frequency.yaml
```


## Docker 安装elastalert
```
docker pull bitsensor/elastalert
```

运行
```s
docker run -d -p 3030:3030 \
-v `pwd`/config/elastalert.yaml:/opt/elastalert/config.yaml \
-v `pwd`/config/config.json:/opt/elastalert-server/config/config.json \
-v `pwd`/rules:/opt/elastalert/rules \
-v `pwd`/rules_templates:/opt/elastalert/rule_templates \
--net="host" \
--name elastalert bitsensor/elastalert:latest
```