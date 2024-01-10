---
title: Byteman使用教程
donate: true
date: 2018-07-06 10:22:57
categories: Byteman
tags: Byteman
---


## 简介
Byteman由JBoss出品。Byteman的代码插入能力相比BTrace而言更强，似乎可以在代码中任意的位置插入我们的跟踪代码（当然，你可能需要对Java代码生成、字节码技术有一定的了解），以及访问当前方法中变量的能力（包括方法参数、局部变量、甚至于调用其它函数的参数值、返回值等），而BTrace在这方面的能力要弱很多。

## 安装Byteman
[官方下载](http://downloads.jboss.org/byteman/4.0.3/byteman-download-4.0.3-bin.zip)
配置BYTEMAN_HOME

验证,
```s
./bminstall.sh

usage: bminstall [-p port] [-h host] [-b] [-s] [-m] [-Dname[=value]]* pid
pid is the process id of the target JVM
-h host selects the host name or address the agent listener binds to
-p port selects the port the agent listener binds to
-b adds the byteman jar to the bootstrap classpath
-s sets an access-all-areas security policy for the Byteman agent code
-m activates the byteman JBoss modules plugin
-Dname=value can be used to set system properties whose name starts with “org.jboss.byteman.”
expects to find a byteman agent jar and byteman JBoss modules plugin jar (if -m is indicated) in BYTEMAN_HOME
```

## 使用示例1（读取局部变量）
```java
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * @author yangchj
 * @email yangchj@icefire.me
 * @date 2018/7/6
 */
public class BytemanDemo {

    public static void main(String[] args) {
        new BytemanDemo().start();
    }

    private void start(){
        new Thread(()->{
            DataInputStream in=new DataInputStream(System.in);
            BufferedReader buf=new BufferedReader(new InputStreamReader(in));
            try{
                String next=buf.readLine();
                while (next!=null&&!next.contains("end")){
                    consume(next);
                    next=buf.readLine();
                }
            }catch (IOException e){
                e.printStackTrace();
            }
        }).start();
    }

    public void consume(String text){
        final String arg=text;
        Thread thread=new Thread(()-> System.out.println("program confirm " + arg));
        thread.start();
        try {
            thread.join();
        }catch (InterruptedException e){
            e.printStackTrace();
        }
    }
}
```

启动程序 BytemanDemo

加载byteman到JVM中，并将attach到需要监听的进程上，指定byteman监控程序监听55000端口
```s
jps

18592 Jps
20011 BytemanDemo

./bminstall.sh -b -Dorg.jboss.byteman.transform.all -Dorg.jboss.byteman.verbose -p 55000 20011
```

回到被监控的程序的控制台看到如下输出：
```s
Setting org.jboss.byteman.transform.all=
Setting org.jboss.byteman.verbose=
TransformListener() : accepting requests on localhost:55000
```
从输出信息中可以看到，byteman监听55000端口，并在该端口接收请求，编写btm脚本，showLocalVar.btm，如下：
```
RULE trace line local var
CLASS BytemanDemo
METHOD consume(String)
AFTER WRITE $arg
IF TRUE
        DO traceln("*** transfer value is : " + $arg + " ***")
ENDRULE
```

安装脚本吧，运行bmsubmit提交脚本
```s
./bmsubmit -p 55000 -l showLocalVar.btm
```

再回控制台，输入测试语句“hhhhhhhhhhh”,查看输出

卸载脚本
```
./bmsubmit -p 55000 -u showLocalVar.btm
```

卸载完成，再回到被监控程序的控制台，输入测试语句，查看输出