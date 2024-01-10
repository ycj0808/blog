---
title: maven命令package、install、deploy比较
donate: true
date: 2019-02-19 14:05:36
categories:
tags:
---


## mvn clean package
依次执行clean、resources、compile、testResources、testCompile、test、jar(打包)等7个阶段

## mvn clean install 
依次执行clean、resources、compile、testResources、testCompile、test、jar(打包)、install等8个阶段

## mvn clean deploy 
依次执行clean、resources、compile、testResources、testCompile、test、jar(打包)、install、deploy等9个阶段

## 区别
* package命令完成项目编译、单元测试、打包功能

* install命令完成项目编译、单元测试、打包功能，并把打好的可执行jar包部署到本地maven仓库

* deploy命令完成项目编译、单元测试、打包功能，并把打好的可执行jar包部署到本地maven仓库和远程私服仓库