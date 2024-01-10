---
title: springboot相关知识
donate: true
date: 2019-02-24 16:28:57
categories:
tags:
---

1. SpringBoot优点
* 独立运行
* 简化配置
* 自动配置
* 应用监控
* 上手容易


2. SpringBoot 的配置文件有哪几种格式？他们有什么区别？
* .properties
```
app.user.name=demo
```

* .yml
```
app:
    user:
        name: demo

```

.yml格式不支持@PropertySource注解导入配置

3. SpringBoot的核心注解有哪些？
启动类注解@SpringBootApplication，它是SpringBoot的核心注解，包含以下3个注解：
@SpringBootConfiguration:组合了@Configuration注解，实现配置文件功能
@EnableAutoConfiguration:打开自动配置的功能，也可以关闭某个自动配置的选项，如关闭数据源自动配置功能：@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })

@ComponentScan：Spring组件扫描


4. SpringBoot运行方式
* 命令打war包放到容器中运行
* 用maven/gradle插件运行 mvn springboot:run
* 直接执行main方法

5. 如何在 Spring Boot 启动的时候运行一些特定的代码
可以通过实现接口ApplicationRunner或者CommandLineRunner，这两个接口实现方式一样，都只提供一个run方法

**CommandLineRunner：**启动获取命令行参数
```
public interface CommandLineRunner {
    void run(String... args) throws Exception;
}   
```

**ApplicationRunner：**启动获取应用启动的时候参数
```
public interface ApplicationRunner {
    void run(ApplicationArguments args) throws Exception;
}   
```

使用方式：
```
    import org.springframework.boot.*
    import org.springframework.stereotype.*
    @Component
    public class MyBean implements CommandLineRunner {
        public void run(String... args) {
            // Do something...
        }
    }
```
或者
```
    @Bean
    public CommandLineRunner init() {
        return (String... strings) -> {
        };
    }
```

6. Springboot有哪几种读取配置的方式？
* @PropertySource
* @Value
* @Environment 
* @ConfigurationProperties 

读取application文件，在application.yml或properties文件中添加
info.address=usa
info.company=Spring
info.degree=high

@Value注解读取方式
```
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
@Component
public class InfoConfig1 {
    @Value("${info.address}")
    private String address;
    @Value("${info.company}")
    private String company;
    @Value("${info.degree}")
    private String degree;

    ...
}
```

@ConfigurationProperties注解读取方式
```
@Component
@ConfigurationProperties(prefix = "info")
public class InfoConfig2 {
    private String address;
    private String company;
    private String degree;
}
```

**读取指定文件**
资源目录下建立config/db-config.properties:
db.username=root
db.password=123456

@PropertySource+@Value注解读取方式
```
@Component
@PropertySource(value = { "config/db-config.properties" })
public class DBConfig1 {
    @Value("${db.username}")
    private String username;
    @Value("${db.password}")
    private String password;
}
```
**注意：@PropertySource不支持yml文件读取**

@PropertySource+@ConfigurationProperties注解读取方式
```
    @Component
    @ConfigurationProperties(prefix = "db")
    @PropertySource(value = { "config/db-config.properties" })
    public class DBConfig2 {
        private String username;
        private String password;
    }    
```

Environment读取方式
以上所有加载出来的配置都可以通过Environment注入获取到
```
    @Autowired
    private Environment env;
    // 获取参数
    String getProperty(String key);
```

7. SpringBoot配置加载顺序
* properties文件
* YAML文件
* 系统环境变量
* 命令行参数
```
1、开发者工具 `Devtools` 全局配置参数；
2、单元测试上的 `@TestPropertySource` 注解指定的参数；
3、单元测试上的 `@SpringBootTest` 注解指定的参数；
4、命令行指定的参数，如 `java -jar springboot.jar --name="Java技术栈"`；
5、命令行中的 `SPRING_APPLICATION_JSONJSON` 指定参数, 如 `java -Dspring.application.json='{"name":"Java技术栈"}' -jar springboot.jar`
6、`ServletConfig` 初始化参数；
7、`ServletContext` 初始化参数；
8、JNDI参数（如 `java:comp/env/spring.application.json`）；
9、Java系统参数（来源：`System.getProperties()`）；
10、操作系统环境变量参数；
11、`RandomValuePropertySource` 随机数，仅匹配：`ramdom.*`；
12、JAR包外面的配置文件参数（`application-{profile}.properties（YAML）`）
13、JAR包里面的配置文件参数（`application-{profile}.properties（YAML）`）
14、JAR包外面的配置文件参数（`application.properties（YAML）`）
15、JAR包里面的配置文件参数（`application.properties（YAML）`）
16、`@Configuration`配置文件上 `@PropertySource` 注解加载的参数；
17、默认参数（通过 `SpringApplication.setDefaultProperties` 指定）；
```
数字小的优先级越高，即数字小的会覆盖数字大的参数值，我们来实践下，验证以上配置参数的加载顺序。


8. 控制反转/依赖注入
控制反转：是一种思想。由容器控制程序之间的关系，并为应用程序提供对象需要的外部资源。
依赖注入，即组件之间的依赖关系由容器在运行期决定，形象的来说，即由容器动态的将某种依赖关系注入到组件之中。
依赖注入机制减轻了组件之间的依赖关系，同时也大大提高了组件的可移植性，这意味着，组件得到重用的机会将会更多。