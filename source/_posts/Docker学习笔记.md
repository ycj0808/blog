---
title: Docker学习笔记
donate: true
date: 2017-12-06 20:11:37
categories:
tags:
---

## 创建Docker镜像（两种方法）
1. docker commit #保存container状态到image后，然后生成对应的image
```
docker run -it centos /bin/bash

yum install nmap-ncat -y

rpm -qa nmap-ncat #查看是否安装成功

exit

docker images #查看镜像

docker ps -a #可以查看容器的ID

docker commit <container Id> <image_name> #创建镜像

```
2. docker build #使用Dockerfile 自动化制作image
```
make /docker-build

cd /docker-build

touch Dockerfile

vi Dockerfile

```
Dockerfile的内容

```shell
FROM centos
MAINTAINER icefire <ycj0808@126.com>
RUN yum -y install httpd
ADD start.sh /usr/local/bin/start.sh
ADD index.html /var/www/html/index.html
```

start.sh 的内容
```
echo "/usr/sbin/httpd -DFOREGROUND" > start.sh
chmod a+x start.sh
echo "docker image build test" > index.html

```

* 使用命令build创建新的image

语法：docker build -t 父镜像名：自定义镜像名 Dockerfie文件所在路径 -t表示tag,用于指定新的镜像名

```
docker build -t centos:httpd .
```

## Docker Image 的发布
* 方法1:Save Image TO TarBall(保存Image到 tar包)

语法：docker save -o 镜像名.tar 要导出的本地镜像名
```
docker save -o centos-httpd-docker-image.tar centos:httpd
```
后期使用方法：
```
docker load -i centos-httpd-docker-image.tar
```
* 方法2:Push Image To Docker Hub 发布到外网
1. 注册一个账号 https://hub.docker.com
2. 登录到docker hub
```
docker login -u ycj0808 -p abc123 -e ycj0808@126.com
```
3. 发布Image到docker hub
```
docker push centos:httpd
```

4. 从docker hub 下载image
```
docker pulll ycj0808/centos:httpd
```

## Docker常用的20个命令

1. docker start/stop/restart/kill  启动/停止/重启/杀掉容器
```s

docker start myweb
docker stop myweb
docker restart myweb
docker kill -s kill myweb  #参数-s 向容器发送信号
```

2. docker run 创建并启动一个新的容器
常用参数如下：
```s
-d  #后台运行容器，并返回容器ID
-i  #以交互模式运行容器，常与-t参数同时使用
-t  #给容器重新分配一个伪终端，常与-i参数同时使用
--name #给容器指定一个名称
-m  #指定容器使用内存的最大值
--net #指定容器使用的网络类型
--link  #链接到另一个容器
```
操作如下：
```s
docker run -d --name nginx nginx:latest  #后台启动并运行一个名为nginx容器，运行前他会自动去docker镜像站点下载最新镜像文件

docker run -d -p 80:80 nginx:latest #后台启动并运名为nginx的容器，然后将容器的80端口映射到物理机的80端口

docker run -d -v /docker/data:/docker/data -p 80:80 nginx:latest 
#后台启动并运名为nginx的容器，然后将容器的80端口映射到物理机的80端口,并且将物理机的/docker/data目录映射到容器的/docker/data

docker run -it  nginx:latest /bin/bash  #以交互式模式运行容器，然后在容器内执行/bin/bash命令
```

3. docker rm   删除容器
常用参数
```s
-f  #强制删除一个运行中的容器
-l  #删除指定的链接
-v  #删除与容器关联和卷
```
操作如下：
```s
docker rm -f mydocker  #强制删除容器mydocker
docker rm -f dockerA dockerB #强制删除容器dockerA dockerB
docker rm -v mydocker #删除容器，并删除容器挂载的数据卷
```

4. docker create 创建一个新容器但不启动它
```s
docker create --name myserver nginx:latest #创建一个名为myserver的容器
```

5. docker exec 在运行的容器中执行命令
 常用参数如下：
 ```
-d #在后台运行
-i #保持STDIN打开
-t #分配一个伪终端
 ```
操作如下：
```s
docker exec -it mydocker /bin/sh /server/scripts/docker.sh #以交互模式执行容器中的/server/scripts/docker.sh脚本

docker exec -it mydocker /bin/sh  #以交互模式给容器分配一个伪终端连接
```

6. docker ps  列出容器
```
-a #列出所有容器包括停止的
-f #根据条件过滤显示内容
-l #列出最近创建的容器
-n #列出最近创建的N个容器，N为数字
-q #只显示容器ID
-s #显示总文件大小
```
操作如下：
```s
docker ps   #列出正在运行的容器

docker ps -n 2 #列出最近创建的2个容器

docker ps -a -q #显示所有容器的ID
```

7. docker inspect 获取容器的元数据
常用参数如下：
```s
-f      #指定返回值格式或模板文件
-s      #显示总文件大小
--type  #为指定类型返回JSON
```
操作如下：
```s
docker inspect 容器ID

docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cadvisor

docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' influxdb
```

8. docker logs  获取容器日志
常用参数如下:
```
-f #跟踪日志输出
-t #显示时间戳
--tail #只显示最新n条容器日志
--since #显示某个开始时间的所有日志
```

```s
docker logs -f cadvisor #跟踪查看容器cadvisor的日志
```

9. docker port 显示指定容器的端口映射
操作如下：
```s
docker port cadvisor  #显示cadvisor容器的端口映射信息
```

10. docker commit 用已存在的容器重新创建一个新的镜像
常用参数如下:
```s
-a      #提交的镜像作者
-c      #使用Dockerfile指令来创建镜像
-m      #提交时附上说明文字
-p      #在commit时，将容器暂停
````
操作如下：
```s
docker commit -a "mingongge" -m "add a new images" bd96d72ed9c7  newdocker_images:v1.0.0
docker images
#将容器bd96d72ed9c7重新生成一个新的镜像名为newdocker_images
```

11. docker cp 用于容器与物理主机之间拷贝文件
操作如下：
```s
docker cp /data/index.html bd96d72ed9c7:/web/
#将物理主机中的/data/index.html拷贝到容器bd96d72ed9c7:/web/目录下
docker cp /data/index.html bd96d72ed9c7:/web/index.php
#将物理主机中的/data/index.html拷贝到容器bd96d72ed9c7:/web/目录下并改名为index.php
docker cp  bd96d72ed9c7:/web  /data/
#拷贝容器bd96d72ed9c7:/web/目录到物理主机中的/data/目录下
```

12. docker login/logout 用于登录与登出容器镜像仓库
```s
docker login       #登陆到一个Docker镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub

docker logout      #登出一个Docker镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub

-u #登录用户名
-p #登录的密码
```

操作如下：
```s
docker login -u username -p password
docker logout
#默认的容器镜像仓库https://index.docker.io/v1/
```

13. docker pull/push
```s
docker pull    #从镜像仓库中拉取或者更新指定镜像
docker push    #将本地的镜像上传到镜像仓库,要先登陆到镜像仓库
```

14. docker images 显示系统本地容器镜像文件
```
-a                #列出所有的镜像（含中间映像层，默认，过滤掉中间映像层）；
--digests      #显示镜像的摘要信息；
-f                  #显示满足条件的镜像；
--format       #指定返回值的模板文件；
--no-trunc     #显示完整的镜像信息；
-q                 #只显示镜像ID。
```

15. docker rmi 删除镜像
```
-f #强制删除
```

16. docker tag  标记本地镜像
```s
[root@docker ~]# docker images
REPOSITORY           TAG        IMAGE ID            CREATED             SIZE
newdocker_images     v1.1.0     858cbd9ba687        39 seconds ago      62.2 MB
[root@docker ~]# docker tag newdocker_images:v1.1.0 newdocker_images:v2
[root@docker ~]# docker images
REPOSITORY           TAG        IMAGE ID            CREATED             SIZE
newdocker_images     v1.1.0     858cbd9ba687        4 minutes ago       62.2 MB
newdocker_images     v2         858cbd9ba687        4 minutes ago       62.2 MB
#从结果可以看出两个容器的ID是一样的，只是TAG改变了，类似于linux中文件与文件的硬链接一样，其两者的inode号相同。
```

17. docker build 使用Dockerfile创建镜像
```s
-f                          #指定要使用的Dockerfile路径
--label=[]              #设置镜像使用的元数据；
-m                        #设置内存最大值
--memory-swap   #设置Swap的最大值为内存+swap，"-1"表示不限swap
--no-cache          #创建镜像的过程不使用缓存
--pull                   #尝试去更新镜像的新版本
-q                       #安静模式，成功后只输出镜像ID
--rm                    #设置镜像成功后删除中间容器
--ulimit               #Ulimit配置


docker build  https://github.com/nginxinc/docker-nginx/
```

18. docker history 查看指定镜像的创建历史
```s
-H               #以可读的格式打印镜像大小和日期，默认为true；
--no-trunc       #显示完整的提交记录；
-q               #仅列出提交记录ID。
```

19. docker info 显示Docker系统信息，包括镜像和容器数
```s
docker info 
```

20. docker version 显示Docker版本信息
```s
docker version
```


