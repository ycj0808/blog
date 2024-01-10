---
title: linux使用shell按序启动多个jar包
donate: true
date: 2018-03-20 08:53:33
categories: shell 
tags:
- shell
- linux
---

有以下四个jar包，按序启动：
1. fire-eureka-1.0-ALPHA.jar
2. fire-config-1.0-ALPHA.jar
3. fire-gateway-1.0-ALPHA.jar
4. fire-auth-service-1.0-ALPHA.jar

**下面是启动 停止 重启的脚本**
```shell
#!/bin/sh

export EUREKA=fire-eureka-1.0-ALPHA.jar
export CONFIG=fire-config-1.0-ALPHA.jar
export GATEWAY=fire-gateway-1.0-ALPHA.jar
export AUTH=fire-auth-service-1.0-ALPHA.jar

export EUREKA_port=8761
export CONFIG_port=4001
export GATEWAY_port=9999
export AUTH_port=3001

case "$1" in

start)
        ## 启动eureka
        echo "--------eureka 开始启动--------------"
        nohup java -jar $EUREKA >/dev/null 2>&1 &
        EUREKA_pid=`lsof -i:$EUREKA_port|grep "LISTEN"|awk '{print $2}'`
        until [ -n "$EUREKA_pid" ]
            do
              EUREKA_pid=`lsof -i:$EUREKA_port|grep "LISTEN"|awk '{print $2}'`  
            done
        echo "EUREKA pid is $EUREKA_pid" 
        echo "--------eureka 启动成功--------------"

        ## 启动config
        echo "--------开始启动CONFIG---------------"
        nohup java -jar $CONFIG >/dev/null 2>&1 &
        CONFIG_pid=`lsof -i:$CONFIG_port|grep "LISTEN"|awk '{print $2}'` 
        until [ -n "$CONFIG_pid" ]
            do
              CONFIG_pid=`lsof -i:$CONFIG_port|grep "LISTEN"|awk '{print $2}'`  
            done
        echo "CONFIG pid is $CONFIG_pid"     
        echo "---------CONFIG 启动成功-----------"

        ## 启动gateway
        echo "--------开始启动GATEWAY---------------"
        nohup java -jar $GATEWAY >/dev/null 2>&1 &
        GATEWAY_pid=`lsof -i:$GATEWAY_port|grep "LISTEN"|awk '{print $2}'`
        until [ -n "$GATEWAY_pid" ]
            do
              GATEWAY_pid=`lsof -i:$GATEWAY_port|grep "LISTEN"|awk '{print $2}'`  
            done
        echo "GATEWAY pid is $GATEWAY_pid"    
        echo "---------GATEWAY 启动成功-----------"

        ## 启动auth
        echo "--------开始启动AUTH---------------"
        nohup java -jar $AUTH >/dev/null 2>&1 &
        AUTH_pid=`lsof -i:$AUTH_port|grep "LISTEN"|awk '{print $2}'`
        until [ -n "$AUTH_pid" ]
            do
              AUTH_pid=`lsof -i:$AUTH_port|grep "LISTEN"|awk '{print $2}'`  
            done
        echo "AUTH pid is $AUTH_pid"     
        echo "---------AUTH 启动成功-----------"
        
        echo "===startAll success==="
        ;;

 stop)
        P_ID=`ps -ef | grep -w $EUREKA | grep -v "grep" | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===EUREKA process not exists or stop success"
        else
            kill -9 $P_ID
            echo "EUREKA killed success"
        fi
		P_ID=`ps -ef | grep -w $CONFIG | grep -v "grep" | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===CONFIG process not exists or stop success"
        else
            kill -9 $P_ID
            echo "CONFIG killed success"
        fi
		 P_ID=`ps -ef | grep -w $GATEWAY | grep -v "grep" | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===GATEWAY process not exists or stop success"
        else
            kill -9 $P_ID
            echo "GATEWAY killed success"
        fi
		 P_ID=`ps -ef | grep -w $AUTH | grep -v "grep" | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===AUTH process not exists or stop success"
        else
            kill -9 $P_ID
            echo "AUTH killed success"
        fi

        echo "===stop success==="
        ;;   

restart)
        $0 stop
        sleep 2
        $0 start
        echo "===restart success==="
        ;;   
esac	
exit 0                 
```