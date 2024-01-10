---
title: Docker容器技术
donate: true
date: 2018-07-11 15:36:38
categories: Docker
tags:
---

## 简介
DOCKER是一个基于LXC技术之上构建的container容器引擎，通过内核虚拟化技术（namespace及cgroups）来提供容器的资源隔离与安全保障，KVM是通过硬件实现的虚拟化技术，它是通过系统来实现资源隔离与安全保障，占用系统资源比较小。

**Docker组成**

    客户端和服务端

**Docker组件**
* 镜像
* 容器
* 仓库

## Docker与Openstack对比
| 类别        | Docker          |  OpenStack  |
| --------   | -----:           | :----: |
| 部署难度    | 非常简单           |   组件多，部署复杂    |
| 启动速度    | 秒级              |   分钟级    |
| 执行性能    | 和物理系统几乎一致  |   VM会占用一些资源    |
| 镜像体积    | 镜像MB级别        |   虚拟机镜像GB级别    |
| 管理效率    | 管理简单          |   组件相互依赖，管理复杂    |
| 隔离性      | 隔离性高          |   彻底隔离    |
| 可管理性    | 单进程、不建议启动SSH|   完整的系统管理    |
| 网络连接    | 比较弱 | 借助neutron管理OpenStack环境中虚拟网络  |

## Docker 优点
1. 简化程序
Docker 让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发不到任何流行的Linux机器上，便可以实现虚拟化。
Docker改变了虚拟化的方式，在Docker容器的处理下，只需要数秒就能完成。

2. 多样性
Docker可以简化部署多种应用实例工作。

3. 节省开支
云计算时代到来，使开发者不必为了追求效果而配置高额的硬件，Docker 改变了高性能必然高价格的思维定势。Docker 与云的结合，
让云空间得到更充分的利用。不仅解决了硬件管理的问题，也改变了虚拟化的方式。

## Docker的应用场景
1. 需要简化配置（测试环境与生产环境不同）
2. 代码管理
3. 提升开发效率
4. 应用隔离
5. 服务器整合
6. 调试
7. 多终端、多租户
8. 需要快速部署与环境一致性

## Docker安装与配置
**安装Docker**
```s
yum install docker -y
systemctl start docker

```

**下载镜像文件**
```s
[root@centos7 ~]# docker pull centos:latest
Trying to pull repository docker.io/library/centos ... 
centos7: Pulling from docker.io/library/centos
93857f76ae30: Pull complete 
Digest: sha256:4eda692c08e0a065ae91d74e82fff4af3da307b4341ad61fa61771cc4659af60
[root@centos7 ~]# docker images
REPOSITORY        TAG      IMAGE ID     CREATED     SIZE
docker.io/centos  centos7  a8493f5f50ff 3 days ago  192.5 MB
```
**删除镜像**
```s
docker rmi 容器ID
```

## Docker容器创建与管理
1. 创建容器
* 方法一
```s
docker run centos /bin/echo "nihao"  ##创建容器

docker ps -a ## 查看所有容器
```
注：没有指定容器名称，自动命名，状态是自动退出

* 方法二 创建一个自定义名称的容器
```s
docker run --name mgg -i -t centos /bin/bash  ## 名称 分配伪终端 -i 处于打开状态

ps -ef
```
docker ps -a是显示所有容器包括没有运行的

2. 进入、退出、启动容器
```s
exit ##退出容器

docker start 2db7f1389dbd ## 启动容器
或
docker start mgg

docker attach 2db7f1389dbd ##进入容器（必须是启动状态下）

hostname ##容器中执行命令 hostname
```
这种进入方式，退出后容器进入Down状态，如下：
```s
exit 

docker ps
```

3. 使用nsenter命令进入容器
```s
nsenter --help

Usage:
 nsenter [options] <program> [<argument>...]
Run a program with namespaces of other processes.
Options:
 -t, --target <pid>     target process to get namespaces from
 -m, --mount[=<file>]   enter mount namespace
 -u, --uts[=<file>]     enter UTS namespace (hostname etc)
 -i, --ipc[=<file>]     enter System V IPC namespace
 -n, --net[=<file>]     enter network namespace
 -p, --pid[=<file>]     enter pid namespace
 -U, --user[=<file>]    enter user namespace
 -S, --setuid <uid>     set uid in entered namespace
 -G, --setgid <gid>     set gid in entered namespace
     --preserve-credentials do not touch uids or gids
 -r, --root[=<dir>]     set the root directory
 -w, --wd[=<dir>]       set the working directory
 -F, --no-fork          do not fork before exec'ing <program>
 -Z, --follow-context   set SELinux context according to --target PID
 -h, --help     display this help and exit
 -V, --version  output version information and exit
```

获取容器PID
```s
docker inspect --format "{{.State.Pid}}" 2db7f1389dbd 
4580

nsenter -t 4580 -u -i -n -p

hostname

eixt

docker ps
```

4. 删除容器
```s
docker ps -a

docker rm 容器ID   ## 删除一个已停止的容器

docker rm -f 容器ID ##删除一个正在运行的容器

docker ps -a

docker run --rm centos /bin/echo "hello" ##创建时自动删除，用于测试

docker --kill $(docker ps -a -q) ## 删除正在运行的容器
```


## Docker网络模式
Docker通过使用Linux桥连接提供容器之间的通信，Docker的网络模式有四种：
* host模式，使用--net=host 指定
* container模式，使用--net=container:容器名或容器ID指定
* none模式，使用--net=none 指定
* bridge模式，使用--net=bridge 指定，默认配置

### host模式
如果容器使用 host 模式，那么容器将不会获得一个独立的 Network Namespace，而是和宿主机共用一个 Network Namespace。容器将不会虚拟出自己的网卡与配置 IP 等，
而是使用宿主机的 IP 和端口。就和直接跑在宿主机中一样。但是容器的文件系统、进程列表等还是和宿主机隔离的。

### container模式
这个模式指定新创建的容器和已经存在的一个容器共享一个 Network Namespace，而不是和宿主机共享。新创建的容器不会创建自己的网卡与配置 IP，而是和一个指定的容器共享 IP、端口范围等。同样，两个容器除了网络方面，其他方面仍然是隔离的。

### none模式
此模式不同于前两种，Docker 容器有自己的 Network Namespace，但是，Docker容器没有任何网络配置。而是需要我们手动给 Docker容器添加网卡、配置 IP 等

### bridge模式
此模式是Docker默认的网络设置，此模式会为每一个容器分配Network Namespace，并将一个主机上的Docker容器连接到一个虚拟网桥上。

##运行容器
```s
docker run -d -P nginx ##-d启动到后台运行

docker ps 
```
参数说明：
docker -P 随机端口映射
docker -p 指定端口映射
-p hostport:containerport
-p ip:hostport:containerport

实例说明
```s
docker run -d -p 81:80  nginx ##指定端口81映射容器80端口
```

## Docker数据存储
docker管理数据的方式有两种：
* 数据卷
* 数据卷容器

### 数据卷
数据卷是一个或多个容器专门指定绕过Union File System的目录，为持续性或共享数据提供一些有用的功能：
- 数据卷可以在容器间共享和重用
- 数据卷数据改变是直接修改的
- 数据卷数据改变不会被包括在容器中
- 数据卷是持续性的，直到没有容器使用它们

参数说明：
-v /data直接将数据目录挂载到容器 /data目录
-v src:dist 将物理机目录挂载到容器目录

实例操作
```s
docker run -it --name test-001 -v /data centos

ls -l /data/

docker ps

docker inspect 容器ID ##找到source目录

cd source目录
ll
mkdir test ##创建目录然后到容器里查看
```
容器里查看数据
```s
cd /data/   ##这个是容器里的目录
ll
##可以看到刚才新建的test目录
```

使用下面的方法挂载
```s
docker run -it -v /data1:/mnt centos
## 前者是物理机目录，后者是容器目录
```

* 此种方法适合开发代码管理，代码目录直接挂载到容器中，修改WEB站点目录即可访问
```s
docker run -it -v /data2:/opt:ro centos
##指定只读权限进行挂载
```

```s
docker run -it -v /data2:/opt:rw centos
##指定读写权限进行挂载
```

```s
docker run -it -v /root/file1:file1 centos
##挂载单个文件到容器目录
```

### 容器卷的方式
--volumes-from  使用其它容器的目录
```s

docker run -d --name mydocker -v /data centos
3********************************b

docker run -it --name mynfs --volumes-from mydocker centos

ll /data/
```
对mydocker容器/data目录写入数据进行测试
```s
cd /var/lib/docker/volumes/3********************************b/_data

ls
echo "welcome to here">file
ll
```

再查看刚刚的容器中是否有数据
```s
hostname
cd /data/
ll
```


