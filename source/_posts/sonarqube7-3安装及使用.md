---
title: sonarqube7.3安装及使用
donate: true
date: 2018-10-23 09:41:57
categories:
tags:
---

## 下载sonarqube7.3
[下载sonar](https://www.sonarqube.org/downloads/)

## 安装配置
解压下载sonarqube-7.3.zip

* bin 用来启动 SonarQube 服务，这里已经提供好了不同系统启动 | 停止脚本了，目前提供了 linux-x86-32、linux-x86-64、macosx-universal-64、windows-x86-32、windows-x86-64

* conf 用来存放配置文件，若需要修改配置，修改 sonar.properties 文件即可

* 用来存放数据，SonarQube默认使用 h2 数据库存储，同时支持其他如Mysql、Orace、Mssql、Postgresql数据库存储

* extensions 用来存放插件 jar 包，以后我们需要安装插件就放在这里

* lib 用来存放各种所依赖的 jar 包，包括上边各数据库驱动包 (默认已提供一个版本，如果版本不匹配，则在这里手动更新下

* logs 用来存放各日志信息

* web 用来提供 SonarQube web 网页服务


## 配置mysql数据库
```yaml
# 修改sonar.properties
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
sonar.jdbc.url=jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8
sonar.jdbc.driverClassName:com.mysql.jdbc.Driver
```

```sql
#创建本地 Mysql 创建数据库
CREATE DATABASE sonar CHARACTER SET utf8 COLLATE utf8_general_ci;
```

```sql
// 本地 Mysql 创建用户并分配权限
CREATE USER 'sonar' IDENTIFIED BY 'sonar';
GRANT ALL PRIVILEGES ON *.* TO 'sonar'@'%' IDENTIFIED BY 'sonar' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'sonar'@'localhost' IDENTIFIED BY 'sonar' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

## 使用
本人使用的是Mac环境，通过执行/bin/macosx-universal-64/sonar.sh start | stop | restart | status

本地访问http://localhost:9000,初始管理员admin/admin

## 插件安装
配置->系统->更新中心
安装所需的插件

* Chinese Pack 汉化


## 使用SonarQube 分析Maven项目
在Maven的setting.xml文件中增加 sonarQube 配置
```xml
<settings>
    <pluginGroups>
        <pluginGroup>org.sonarsource.scanner.maven</pluginGroup>
    </pluginGroups>
    <profiles>
        <profile>
            <id>sonar</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <!-- 配置 Sonar Host地址，默认：http://localhost:9000 -->
                <sonar.host.url>
                  http://localhost:9000
                </sonar.host.url>
            </properties>
        </profile>
     </profiles>
</settings>
```

在maven工程目录中执行
```
mvn clean verify sonar:sonar  #或

mvn clean install sonar:sonar
```

指定使用某个版本的sonar-maven-plugin插件
1. pom文件中
```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.sonarsource.scanner.maven</groupId>
      <artifactId>sonar-maven-plugin</artifactId>
      <version>3.3.0.603</version>
    </plugin>
  </plugins>
</build>
```

2. 使用mvn命令指定
```sh
mvn clean install org.sonarsource.scanner.maven:sonar-maven-plugin:3.3.0.603:sonar
```


## 下载SonarQube Scanner
[下载SonarQube+Scanner](https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner)

## Jekins配置
**jenkins启动**
```
nohup java -jar jenkins.war --httpPort=8098 &
```
安装插件sonar 插件
**jenkins上安装sonarqube plugin ,如果没有就安装sonarqube scanner for jenkins这个插件**

### 关联sonar插件


1. 系统设置
系统管理->系统设置-> Add SonarQube ->sonarqube servers 修改
```
server Url 指定sonar的地址
```
2. 全局设置
**设置sonar扫描器位置**
系统管理->Global Tool Configuration ->SonarQube Scanner -> 新增SonarQube Scanner
```
Name: sonar
去掉自动安装，配置source_runner_home:指定自己的sonar扫描器的安装目录
```

### 关联项目
选择一个项目，配置>构建>执行Exceute SonarQube Scanner > Analysis properties填写相关参数
```
sonar.projectKey=demo
sonar.projectName=demo
sonar.projectVersion=1.0
sonar.sources=/xxx/src
sonar.language=java
sonar.sourceEncoding=UTF-8
```

保存配置

### 新建一个Jenkins项目或者选择一个已有的Jenkins项目
https://www.ibm.com/developerworks/cn/devops/1612_qusm_jenkins/index.html

使用 SonarQube Scanner 进行代码分析有两种方法：
1. 使用构建后步骤
2. 在构建的过程中增加SonarQube Scanner的步骤
