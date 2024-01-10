---
title: App项目之服务基础篇
date: 2016-12-14 21:44:16
categories: Java
tags: 
- Java 
- 服务端
- Spring Boot
donate: true
---
工作四年多来，绝大部分时间从事APP的研发工作，对于服务端有一定的了解，但是近年来更偏向于APP客户端的开发，但是还是有一颗成为全栈工程师的心，所以在短期内捡了捡曾经遗忘的东西。
 
 
### **技术选型**
 由于刚参加工作的时候，做过一段时间的Java Web，那么服务端还是采用自己熟悉而且擅长的Java。

 开发工具（IDEA），因为它和android studio一脉相承，总之一句话就是熟悉。

 WEB框架，本打算采用SpringMVC。但是近期看了一篇文章，关于WEB框架的分析图
 ![WEB框架的分析图](https://icefire.me/images/12-10-57.jpg) 
 Spring依然是采用最多框架，SpringBoot增长的趋势明显。
 关于Spring Boot的介绍如下：
 * 可以创建独立的Spring应用程序
 * 嵌入式Tomcat，Jetty容器，可以选择构建jar包（内嵌Tomcat,只需执行java -jar命令），也可以选择构建war包部署
 * 简化了Maven，Gradle的配置（这两种构建方式都支持）
 * 自动化配置Spring，省去了我们自己配置XML

### **环境搭建**
 搭建SpringBoot环境，需要JDK的安装，IDEA安装，以及Mysql的安装，作为开发人员，环境的搭建是我们必备的技能，也不必多说了。
 
**项目构建**
 打开IDEA（我使用的版本是2016.2），新建一个项目，在左侧菜单选择Spring Initializr，如下图:
  ![图1](https://icefire.me/images/2016-12-10-1.png) 
 配置好自己的JDK的位置，设置Project的一些基本信息，如下图：
  ![图2](https://icefire.me/images/2016-12-10-2.png) 
 我们选择使用gradle构建项目(开发Android项目，已经习惯了)选择Spring的一些依赖库，选择Web，MySql，MyBatis.
  ![图3](https://icefire.me/images/2016-12-10-3.png) 
	
	然后设置自己的项目路径，完成项目的搭建。
在Project构建完成后，需要设置数据源，设置application.properties文件里进行设置在application.properties中添加如下内容：(数据库连接的配置)
```js
spring.datasource.url=jdbc:mysql://localhost:3306/ice
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
```

代开build.gradle文件,dependencies中的内容如下：
```js
dependencies {
	compile('org.mybatis.spring.boot:mybatis-spring-boot-starter:1.1.1')
	compile('org.springframework.boot:spring-boot-starter-web')
	runtime('mysql:mysql-connector-java')
	testCompile('org.springframework.boot:spring-boot-starter-test')
}
```

### **代码实现**

在我们新建数据库中新建一张user表，sql如下
```sql
DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user` (
  `userid` varchar(32) COLLATE utf8_bin NOT NULL,
  `gender` tinyint(1) DEFAULT '0' COMMENT '0:未知,1:男,2:女',
  `mobile` varchar(45) COLLATE utf8_bin NOT NULL COMMENT '手机号',
  `password` varchar(128) COLLATE utf8_bin NOT NULL COMMENT '密码',
  `email` varchar(45) COLLATE utf8_bin DEFAULT NULL COMMENT '邮箱',
  `nickname` varchar(45) COLLATE utf8_bin DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT '头像',
  `bio` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT '个人简介',
  `blog` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT '博客',
  `createTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`userid`),
  UNIQUE KEY `mobile_unique` (`mobile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
```

然后在我们的工程文件中新建bean,mapper,service,controller四个包，用于存放实体，实体映射，业务服务，控制器，在bean中新建一个UserModel的实体类，对应数据库表tb_user表结构，在 mapper包中
新建一个UserMapper接口，方法映射为User表的操作，在service包中新建一个UserService接口以及impl包中新建一个UserServiceImpl实现类实现UserService接口，在controller中创建UserController类，
实现对外的Request API。
UserModel 实现：
```java
public class UserModel {

    private String userId;
    private int gender;
    private String mobile;
    private String password;
    private String email;
    private String nickName;
    private String avatar;
    private String bio;
    private String blog;
    private Date createTime;
    private Date updateTime;
//setter和getter方法此处略去
}
```
UserMapper 接口内容：
```java
@Mapper
public interface UserMapper {

    //创建用户（用户注册）
    @Insert("insert into tb_user(userid,mobile,password,createTime) value(#{userId},#{mobile},#{password},null)")
    int createUser(UserModel userModel);

    @Update("update tb_user set email=#{email},nickname=#{nickName},avatar=#{avatar},bio=#{bio},blog=#{blog} where userid=#{id}")
    int updateUser(String id,UserModel userModel);

    @Select("select * from tb_user where userid=#{userId}")
    UserModel fetchUserById(String userId);

}
```

UserServiceImpl实现类：
```java
@Service
public class UserServiceImpl implements UserService{

    @Autowired
    private UserMapper userMapper;
    private final Logger logger = LoggerFactory.getLogger(UserServiceImpl.this.getClass());

    @Override
    public int createUser(UserModel userModel) {
        int result=0;
        try{
            userModel.setUserId(IceUtils.getUUID());
            result=userMapper.createUser(userModel);
        }catch (Exception e){
            logger.error("--UserServiceImpl.createUser---",e);
        }
        return result;
    }

    @Override
    public int updateUser(String userid,UserModel userModel) {
        int result=0;
        try{
            result=userMapper.updateUser(userid,userModel);
        }catch (Exception e){
            logger.error("--UserServiceImpl.updateUser---",e);
        }
        return result;
    }

    @Override
    public UserModel fetchUserByUserId(String userId) {
        UserModel userModel=null;
        try{
            userModel=userMapper.fetchUserById(userId);
        }catch (Exception e){
            logger.error("--UserServiceImpl.fetchUserByUserId---",e);
        }
        return userModel;
    }
}
```
UserController的实现
```java
@RestController
@RequestMapping("/api/v1/users")
public class UserController {

    @Autowired
    private UserService userService;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

  @RequestMapping(value="",method= RequestMethod.POST)
    public String createUser(@ModelAttribute UserModel userModel){
        String result="fail";
        int createRes=0;
        if(userModel!=null&&userModel.getUserId()==null){
            createRes=userService.createUser(userModel);
        }else{
            createRes=userService.updateUser(userModel.getUserId(),userModel);
        }

        if(createRes>0){
            result="success";
        }
        return result;
    }

    @RequestMapping(value = "/{userid}",method = RequestMethod.POST)
    public String updateUser(@PathVariable("userid") String userid,@ModelAttribute UserModel userModel){

        int res=userService.updateUser(userid,userModel);        if(res>0){
           result="success";
        }
     return result;
    }
    @RequestMapping(value = "/{userid}",method = RequestMethod.GET)
    public UserModel fetchUserById(@PathVariable("userid") String userid){
        UserModel userModel=null;
        userModel=userService.fetchUserByUserId(userid);
        return userModel;
    }
}
```

到此为止，一个简单的为APP或着Web后台提供Restful API的服务端搭建完成了，我们打开Application文件，右键运行该文件。
然后打开postman，测试我们的接口
* 创建用户
 ![图4](https://icefire.me/images/2016-12-11-2.jpg) 
 ![图5](https://icefire.me/images/2016-12-11-3.jpg) 
* 查询用户
 ![图6](https://icefire.me/images/2016-12-11-4.jpg) 

### **写在最后**
至此，简单的服务端的开发准备完成了，下一篇文章将会对服务端，标准化API输出，Restful API文档的输出，以及登录时Token生成及认证一套完整的配置。

----

*****************
参考：[Keegan小钢](https://keeganlee.me/)