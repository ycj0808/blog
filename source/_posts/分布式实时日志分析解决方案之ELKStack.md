---
title: 分布式实时日志分析解决方案之ELKStack
donate: true
date: 2018-06-29 13:55:43
categories: ELK
tags:
---

## 概述
ELK Stack是目前最流行的集中式日志解决方案，它主要是由Elasticsearch、Logstash、Kibana、Beats等组件组成，来共同完成实时日志的收集，存储，
展示等一站式的解决方案。

1. Filebeat: Filebeat是一款轻量级，占用服务资源非常少的数据收集引擎。可以代替LogStash作为应用服务端的日志收集引擎，支持将收集的数据输出到Kafka,Redis等队列。

2. Logstash: 数据收集引擎，相较于Filebeat比较重量级，但集成了大量的插件，支持丰富的数据源收集，对收集的数据可以过滤，分析，格式化日志。

3. Elasticsearch：分布式数据搜索引擎，基于Apache Lucene实现，可集群，提供数据的集中式存储，分析，以及强大的数据搜索和聚合功能

4. Kibana：数据的可视化平台，通过web平台可以实时的查看Elasticsearch中的相关数据，并提供了丰富的图表统计功能。

## ELK常见部署架构
1. Logstash 作为日志收集器
这种架构是比较原始的部署架构，在各应用服务器端分别部署一个Logstash组件，作为日志收集器，然后将Logstash收集到的数据过滤、分析、格式化处理后发送至Elasticsearch存储，最后使用Kibana进行可视化展示，这种架构不足的是：Logstash比较耗服务器资源，所以会增加应用服务器端的负载压力。

2. Filebeat作为日志收集器
该架构与第一种架构唯一不同的是：应用端日志收集器换成了Filebeat，Filebeat轻量，占用服务器资源少，所以使用Filebeat作为应用服务器端的日志收集器，一般Filebeat会配合Logstash一起使用，这种部署方式也是目前最常用的架构。

3. 引入缓存队列的部署架构
第一种部署架构由于资源占用问题，现已很少使用，目前使用最多的是第二种部署架构，至于第三种部署架构个人觉得没有必要引入消息队列，除非有其他需求，因为在数据量较大的情况下，Filebeat 使用压力敏感协议向 Logstash 或 Elasticsearch 发送数据。如果 Logstash 正在繁忙地处理数据，它会告知 Filebeat 减慢读取速度。拥塞解决后，Filebeat 将恢复初始速度并继续发送数据。

 
## 组件的安装与使用

**Elasticsearch**
修改Elasticsearch的配置文件config/elasticsearch.yml
```
network.host=localhost
network.port=9200
```
运行
```
nohup ./elasticsearch >>nohup.out 2>$1 &
```
访问 localhost:9200


**logstash**
创建配置文件config/logstash-filebeat.conf
```conf
input {
 beats {
   port => 5044
   type => "service-log"
  }
}
filter {
  #   multiline {
  #     pattern => "%{LOGLEVEL}\s*\]\[%{YEAR}%{MONTHNUM}%{MONTHDAY}\s+%{TIME}\]"
  #     negate => true
  #     what => "previous"
  # }
  if [fields][logType] == "service-error" {
    grok {
      # match => [ "message" , "(?<customer_time>%{YEAR}-%{MONTHNUM}-%{MONTHDAY}\s+%{TIME})"]
      match => [
         "message","%{TIMESTAMP_ISO8601:customer_time}%{GREEDYDATA:thread-id}%{LOGLEVEL:loglevel} (?<classname>[^\]]+)-%{GREEDYDATA:logDetail}-%{GREEDYDATA:msgbody}"
      ]
    }
    date {
        match => ["customer_time", "yyyy-MM-dd HH:mm:ss.SSS"]
        target => "@timestamp"
    }
    
    kv {
      source => "msgbody"
      field_split => "\|"
      value_split => "="
    }
  }
    
}
output {
 elasticsearch {
    hosts => [ "localhost:9200" ]
    index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
    document_type => "%{[@metadata][type]}"
  }
}
```
注：log4j2.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="OFF">
    <Properties>
        <Property name="LOG_HOME">./</Property>
        <Property name="LOG_NAME">producer-eu-c</Property>
        <property name="LOG_PATTERN" value="%d{yyyy-MM-dd HH:mm:ss.SSS} [%t] %-5level %logger{36} - %l - %msg%n" />
    </Properties>
    <Appenders>
        <!--很直白，Console指定了结果输出到控制台-->
        <Console name="ConsolePrint" target="SYSTEM_OUT">
            <PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss.SSS} [%t] %-5level %logger{36} %l - %msg%n"/>
        </Console>
        <!--<File>输出结果到指定文件</File>-->
        <!--<RollingFile>同样输出结果到指定文件，但是使用buffer，速度会快点</RollingFile>-->
        <!--filePattern：表示当日志到达指定的大小或者时间，产生新日志时，旧日志的命名路径。-->
        <!--PatternLayout：和log4j一样，指定输出日志的格式，append表示是否追加内容，值默认为true-->
        <RollingFile name="RollingFileDebug" fileName="${LOG_HOME}/log/${LOG_NAME}-debug.log"
                     filePattern="${logFilePath}/log/$${date:yyyy-MM}/${LOG_NAME}-%d{yyyy-MM-dd}_%i.log.gz">
            <PatternLayout pattern="${LOG_PATTERN}"/>
            <!--注意，如果有多个ThresholdFilter，那么Filters标签是必须的-->
            <Filters>
                <!--首先需要过滤不符合的日志级别，把不需要的首先DENY掉，然后在ACCEPT需要的日志级别，次序不能颠倒-->
                <!--INFO及以上级别拒绝输出-->
                <ThresholdFilter level="INFO" onMatch="DENY" onMismatch="NEUTRAL"/>
                <!--只输出DEBUG级别信息-->
                <ThresholdFilter level="DEBUG" onMatch="ACCEPT" onMismatch="DENY"/>
            </Filters>
            <Policies>
                <!--时间策略，每隔24小时产生新的日志文件-->
                <TimeBasedTriggeringPolicy/>
                <!--大小策略，每到30M时产生新的日志文件-->
                <SizeBasedTriggeringPolicy size="30MB"/>
            </Policies>
        </RollingFile>
        <RollingFile name="RollingFileInfo" fileName="${LOG_HOME}/log/${LOG_NAME}-info.log"
                     filePattern="${LOG_HOME}/log/$${date:yyyy-MM}/${LOG_NAME}-%d{yyyy-MM-dd}_%i.log.gz">
            <Filters>
                <!--onMatch:Action to take when the filter matches. The default value is NEUTRAL-->
                <!--onMismatch:    Action to take when the filter does not match. The default value is DENY-->
                <!--级别在ERROR之上的都拒绝输出-->
                <!--在组合过滤器中，接受使用NEUTRAL（中立），被第一个过滤器接受的日志信息，会继续用后面的过滤器进行过滤，只有符合所有过滤器条件的日志信息，才会被最终写入日志文件-->
                <ThresholdFilter level="ERROR" onMatch="DENY" onMismatch="NEUTRAL"/>
                <ThresholdFilter level="INFO" onMatch="ACCEPT" onMismatch="DENY"/>
            </Filters>
            <PatternLayout pattern="${LOG_PATTERN}"/>
            <Policies>
                <TimeBasedTriggeringPolicy/>
                <SizeBasedTriggeringPolicy size="30MB"/>
            </Policies>
        </RollingFile>
        <RollingFile name="RollingFileError" fileName="${LOG_HOME}/log/${LOG_NAME}-error.log"
                     filePattern="${LOG_HOME}/log/$${date:yyyy-MM}/${LOG_NAME}-%d{yyyy-MM-dd}_%i.log.gz">
            <Filters>
                <ThresholdFilter level="ERROR" onMatch="ACCEPT" onMismatch="DENY"/>
            </Filters>
            <PatternLayout pattern="${LOG_PATTERN}"/>
            <Policies>
                <TimeBasedTriggeringPolicy/>
                <SizeBasedTriggeringPolicy size="30MB"/>
            </Policies>
        </RollingFile>
    </Appenders>
    <Loggers>
        <!--logger用于定义log的level以及所采用的appender，如果无需自定义，可以使用root解决，root标签是log的默认输出形式-->
        <!-- 级别顺序（低到高）：TRACE < DEBUG < INFO < WARN < ERROR < FATAL -->

        <logger name="com.neusoft" level="INFO">
            <Appender-ref ref="RollingFileInfo"/>
            <Appender-ref ref="RollingFileError"/>
        </logger>

        <!--<logger name="org.springframework" level="INFO">-->
            <!--<Appender-ref ref="RollingFileInfo"/>-->
        <!--</logger>-->
        <Root level="INFO">
            <!-- 只要是级别比ERROR高的，包括ERROR就输出到控制台 -->
            <!--appender-ref中的值必须是在前面定义的appenders-->
            <Appender-ref ref="ConsolePrint"/>
            <!--<Appender-ref ref="RollingFileDebug"/>-->
        </Root>
    </Loggers>
</Configuration>
```

运行
```
nohup ./bin/logstash -f config/logstash-filebeat.conf >>nohup.out 2>&1 &
```

访问 localhost:9600

**Filebeat**
filebeat.yml配置
```
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /Users/yangchj/work/kfw/kfw-demo-02/log/test*-info.log  
  multiline.pattern: ^\[
  multiline.negate: false
  multiline.match: after
filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: false

setup.template.settings:
  index.number_of_shards: 3
setup.kibana:

output.logstash:
  hosts: ["localhost:5044"]
```

启动
```
nohup ./filebeat -e -c filebeat.yml >>nohup.out 2>&1 &

nohup ./filebeat -e -c filebeat.yml >/dev/null 2>&1 &
```

**kibana**
```
nohup ./bin/kibana  >>nohup.out 2>&1 &
```

访问 http://localhost:5601/


## 问题及解决方案
1. 日志多行合并功能
使用Filebeat的multiline多行合并插件来实现,multiline在Filebeat中的配置方式:
```yml
filebeat.inputs:
- type: log
  paths:
    - /var/log/system.log
    - /var/log/wifi.log
multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
multiline.negate: true
multiline.match: after    
- type: log
  paths:
    - "/var/log/apache2/*"
  fields:
    apache: true
  fields_under_root: true
multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
multiline.negate: true
multiline.match: after   
output:
   logstash:
      hosts: ["localhost:5044"]
```
* pattern：正则表达式
* negate：默认为false，表示匹配pattern的行合并到上一行；true表示不匹配pattern的行合并到上一行
* match：after表示合并到上一行的末尾，before表示合并到上一行的行首

2. 如何将Kibana中显示日志的时间字段替换为日志信息中的时间？
使用grok分词插件与date时间格式化插件来实现,在Logstash的配置文件的过滤器中配置grok分词插件与date时间格式化插件
```conf
input {
  beats {
    port => 5044
  }
}

filter {
  multiline {
    pattern => "%{LOGLEVEL}\s*\]\[%{YEAR}%{MONTHNUM}%{MONTHDAY}\s+%{TIME}\]"
    negate => true
    what => "previous"
  }
 grok {
    match => [ "message" , "(?<customer_time>%{YEAR}%{MONTHNUM}%{MONTHDAY}\s+%{TIME})" ]
  }
  date {
        match => ["customer_time", "yyyyMMdd HH:mm:ss,SSS"]
        target => "@timestamp"
  }
}
output {
  elasticsearch {
    hosts => "localhost:9200"
  }
}
```

3. 如何在Kibana中通过选择不同的系统日志模块来查看数据
在Filebeat中的配置内容为:
```yml
filebeat.inputs:
- type: log
  paths:
    - /var/log/system.log
    - /var/log/wifi.log
multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
multiline.negate: true
multiline.match: after  
fields:
    log_from: serviceA #新增log_from字段
- type: log
  paths:
    - "/var/log/apache2/*"
  fields:
    apache: true
  fields_under_root: true
multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
multiline.negate: true
multiline.match: after   
fields:
    log_from: serviceA #新增log_from字段
output:
   logstash:
      hosts: ["localhost:5044"]
```
