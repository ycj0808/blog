---
title: App项目之服务进阶篇
donate: true
date: 2016-12-17 19:26:11
categories: Java
tags:
- Java 
- 服务端
- Spring Boot
- Swagger2
- Redis
---
接着上一篇文章[App项目之服务基础篇](https://icefire.me/2016/12/14/App%E9%A1%B9%E7%9B%AE%E4%B9%8B%E6%9C%8D%E5%8A%A1%E5%9F%BA%E7%A1%80%E7%AF%87/)，继续探讨我们App服务端的搭建与配置。今天的主题是配置，上一篇我们已经使用Spring boot搭建了一个Restful API的工程，那么在此基础上进行一些改进和配置。

* [返回参数的格式统一化](#jump1)
* [错误处理的统一配置](#jump2)
* [Redis的配置](#jump3)
* [分页查询的配置](#jump4)
* [文件上传](#jump5)
* [Swagger2的配置，生成Restful API文档](#jump6)


### **<span id = "jump1">返回参数的格式统一化</span>**
对于服务端参数的格式的统一化，有助于App端的解析，对于双方的接口调试能够达到事倍功半的效果。返回参数的格式我是这样设置的：每个Controller中的请求方法返回值都采用的是ResponseEntity这个Spring内部的实体类，
此外我还自己定义一个ApiResponse的实体类，包括code,msg,data,datas,timestamp这几个属性。

```java
public class ApiResponse<T> {

    private String code;//返回码，0000：成功,0001:缺少参数, 0002 请求错误
    private String msg;//返回信息
    private T data;//单个对象
    private PageInfo<T> datas;//多个对象,注此处的PageInfo是Mybatis分页库中的实体，下文会介绍
    private long timestamp;//系统时间戳

    //构造函数，初始化code和msg
    public ApiResponse(String msg, String code) {
        this.code = code;
        this.msg = msg;
        this.timestamp=System.currentTimeMillis();
    }

    public ApiResponse(String msg) {
        this.code = "0000";
        this.msg = msg;
        this.timestamp=System.currentTimeMillis();
    }
    //getter和setter此处省略了
}
```
另外，还定义了一个工具类ResponseUtil，便于处理返回实体的构建

```java
public class ResponseUtil {


    private static ResponseEntity<ApiResponse> generalOK(ApiResponse apiResponse){
        return new ResponseEntity<ApiResponse>(apiResponse, HttpStatus.OK);
    }

    private static ResponseEntity<ApiResponse> generalUnAuthor(ApiResponse apiResponse){
        return new ResponseEntity<ApiResponse>(apiResponse, HttpStatus.UNAUTHORIZED);
    }

    /**
     * 未授权认证成功
     * @param msg
     * @return
     */
    public static ResponseEntity<ApiResponse> unAuthor(String msg){
        return generalUnAuthor(new ApiResponse(msg));
    }

    /**
     * 成功返回(只包含msg和code)
     * @param msg
     * @return
     */
    public static ResponseEntity<ApiResponse> success(String msg){
        return generalOK(new ApiResponse(msg,Constant.RESCODE_SUCCESS));
    }

    /**
     * 成功返回（包含msg,code,Obj）
     * @param msg
     * @param object
     * @return
     */
    public static ResponseEntity<ApiResponse> success(String msg,Object object){
        ApiResponse apiResponse=new ApiResponse(msg,Constant.RESCODE_SUCCESS);
        apiResponse.setData(object);
        return generalOK(apiResponse);
    }

    /**
     * 成功返回（包含msg,code,Obj）
     * @param msg
     * @param object
     * @return
     */
    public static ResponseEntity<ApiResponse> success(String msg,PageInfo object){
        ApiResponse apiResponse=new ApiResponse(msg,Constant.RESCODE_SUCCESS);
        apiResponse.setDatas(object);
        return generalOK(apiResponse);
    }

    /**
     * 不存在
     * @return
     */
    public static ResponseEntity<ApiResponse> notExist(){
        ApiResponse apiResponse=new ApiResponse("不存在",Constant.RESCODE_NOEXIST);
        return generalOK(apiResponse);
    }

    public static ResponseEntity<ApiResponse> error(){
        ApiResponse apiResponse=new ApiResponse("操作失败了",Constant.RESCODE_ERROR);
        return generalOK(apiResponse);
    }
    /**
     * 请求出现异常信息
     * @param msg
     * @return
     */
    public static ResponseEntity<ApiResponse> exception(String msg){
        return generalOK(new ApiResponse(msg,Constant.RESCODE_EXCEPTION));
    }

    /**
     * 未知异常
     * @return
     */
    public static ResponseEntity<ApiResponse> unKonwException(){
        return exception("请稍后再试！");
    }

    /**
     * 自定义返回code和msg
     * @param msg
     * @param code
     * @return
     */
    public static ResponseEntity<ApiResponse> custom(String msg,String code){
        return generalOK(new ApiResponse(msg,code));
    }
}
```

### **<span id = "jump2">错误处理的统一配置</span>**
在日常开发中发生了异常，往往是需要通过一个统一的异常处理处理所有异常，来保证客户端能够收到友好的提示。
SpringBoot在页面 发生异常的时候会自动把请求转到/error，SpringBoot内置了一个BasicErrorController对异常进行统一的处理。
那么我们定义一个AppErrorController来处理异常。通常都会涉及到Html和Json请求，如果是Json请求则返回String或者ReponseEntity类型
，如果是Html请求，则返回ModelAndView的错误页面。

```java
@Controller
public class AppErrorController implements ErrorController{

    private ErrorAttributes errorAttributes;
    private final static String ERROR_PATH = "/error";

    public AppErrorController(ErrorAttributes errorAttributes) {
        this.errorAttributes = errorAttributes;
    }


    @RequestMapping(value = ERROR_PATH)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> error(HttpServletRequest request) {
        Map<String, Object> body = getErrorAttributes(request, getTraceParameter(request));
        HttpStatus status = getStatus(request);
        return new ResponseEntity<Map<String, Object>>(body, status);
    }


    private boolean getTraceParameter(HttpServletRequest request) {
        String parameter = request.getParameter("trace");
        if (parameter == null) {
            return false;
        }
        return !"false".equals(parameter.toLowerCase());
    }

    private Map<String, Object> getErrorAttributes(HttpServletRequest request,
                                                   boolean includeStackTrace) {
        RequestAttributes requestAttributes = new ServletRequestAttributes(request);
        return this.errorAttributes.getErrorAttributes(requestAttributes,
                includeStackTrace);
    }

    private HttpStatus getStatus(HttpServletRequest request) {
        Integer statusCode = (Integer) request
                .getAttribute("javax.servlet.error.status_code");
        if (statusCode != null) {
            try {
                return HttpStatus.valueOf(statusCode);
            }
            catch (Exception ex) {
            }
        }
        return HttpStatus.INTERNAL_SERVER_ERROR;
    }

    @Override
    public String getErrorPath() {
        return ERROR_PATH;
    }
}
```

### **<span id = "jump3">Redis的配置</span>**
对于Redis服务器的安装此处就不介绍了，默认我们已经安装了Redis。在build.gradle中添加

```groovy
compile 'org.springframework.boot:spring-boot-starter-data-redis:1.4.2.RELEASE'
```
在application.properties文件中添加对redis的配置
```js
# REDIS (RedisProperties)
# Redis数据库索引（默认为0）
spring.redis.database=0
# Redis服务器地址
spring.redis.host=127.0.0.1
# Redis服务器连接端口
spring.redis.port=6379
# Redis服务器连接密码（默认为空）
spring.redis.password=
# 连接池最大连接数（使用负值表示没有限制）
spring.redis.pool.max-active=8
# 连接池最大阻塞等待时间（使用负值表示没有限制）
spring.redis.pool.max-wait=-1
# 连接池中的最大空闲连接
spring.redis.pool.max-idle=8
# 连接池中的最小空闲连接
spring.redis.pool.min-idle=0
# 连接超时时间（毫秒）
spring.redis.timeout=0
```

如果在redis服务器中存储自定义的Bean的话，我们建一个RedisObjectSerializer继承自RedisSerializer的类

```java
public class RedisObjectSerializer implements RedisSerializer<Object> {

    private Converter<Object, byte[]> serializer = new SerializingConverter();
    private Converter<byte[], Object> deserializer = new DeserializingConverter();

    static final byte[] EMPTY_ARRAY = new byte[0];

    @Override
    public byte[] serialize(Object object) throws SerializationException {
        if (object == null) {
            return EMPTY_ARRAY;
        }
        try {
            return serializer.convert(object);
        } catch (Exception ex) {
            return EMPTY_ARRAY;
        }
    }

    @Override
    public Object deserialize(byte[] bytes) throws SerializationException {
        if (isEmpty(bytes)) {
            return null;
        }
        try {
            return deserializer.convert(bytes);
        } catch (Exception ex) {
            throw new SerializationException("Cannot deserialize", ex);
        }
    }

    private boolean isEmpty(byte[] data) {
        return (data == null || data.length == 0);
    }
}
```

Redis的配置类

```java 
@Configurable
@EnableCaching
public class RedisConfig {

    @Bean
    JedisConnectionFactory jedisConnectionFactory() {
        return new JedisConnectionFactory();
    }

    @Bean
    public CacheManager cacheManager(@SuppressWarnings("rawtypes") RedisTemplate redisTemplate) throws IOException {
        RedisCacheManager manager = new RedisCacheManager(redisTemplate);
        manager.setDefaultExpiration(Constant.DEFAULT_TOKEN_EXPIRES_TIME);
        return manager;
    }

    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, Object> template = new RedisTemplate<String, Object>();
        template.setConnectionFactory(jedisConnectionFactory());
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new RedisObjectSerializer());
        return template;
    }
}
```
### **<span id = "jump4">分页查询的配置</span>**
分页查询，我使用的是MyBatis的一个插件PageHelper,其中上文中提到的PageInfo这个实体类就是在PagerHelper这个库中定义的，我们来看一下它的使用。

```groovy
compile 'com.github.pagehelper:pagehelper:4.1.6'
```

在项目中创建一个PageHelperConfig类，对MyBatis分页插件进行配置

```java
@Configuration
public class PageHelperConfig {
    @Bean
    public PageHelper pageHelper(){
        PageHelper pageHelper=new PageHelper();
        Properties p=new Properties();
        p.setProperty("offsetAsPageNum","true");
        p.setProperty("rowBoundsWithCount","true");
        p.setProperty("reasonable", "true");
        //通过设置pageSize=0或者RowBounds.limit = 0就会查询出全部的结果
        p.setProperty("pageSizeZero", "true");
        pageHelper.setProperties(p);
        return pageHelper;
    }
}
```

随后在Mapper中我们定义一个查询全部的方法，在Service中实现分页查询

```java
    @Select("select * from tb_user")
    List<UserModel> fetchAllUsers();
```

```java
    @Override
    public PageInfo<UserModel> fetchAllUsers(int pageNum, int pageSize) {
        PageHelper.startPage(pageNum,pageSize);
        List<UserModel> userModelList=userMapper.fetchAllUsers();
        return new PageInfo<>(userModelList);
    }
```

这样我们就实现了分页查询，具体在Controller中返回的结果，我们看一下

```json
{
  "code": "string",
  "data": {},
  "datas": {
    "endRow": 0,
    "firstPage": 0,
    "hasNextPage": true,
    "hasPreviousPage": true,
    "isFirstPage": true,
    "isLastPage": true,
    "lastPage": 0,
    "list": [
      {}
    ],
    "navigatePages": 0,
    "navigatepageNums": [
      0
    ],
    "nextPage": 0,
    "orderBy": "string",
    "pageNum": 0,
    "pageSize": 0,
    "pages": 0,
    "prePage": 0,
    "size": 0,
    "startRow": 0,
    "total": 0
  },
  "msg": "string",
  "timestamp": 0
}
```

### **<span id = "jump5">文件上传</span>**
几乎所有的App项目中都会有文件图片上传的功能，有的是单文件上传，有的是批量上传，那我们看一下在Spring boot工程下实现的文件上传功能。
* 首先在application.properties 文件中添加服务器存储的路径
```js
    web.upload.file_path=/User/xxx/upload 具体服务器中的某一路径
```

* 新建一个FileUploadController
```java
    @Value("${web.upload.file_path}")
    private String uploadPath;
    
    @RequestMapping(value = "imgs/upload",method = RequestMethod.POST)
    public ResponseEntity handleImagesUpload(@RequestParam("imgs") MultipartFile[] files){
        ResponseEntity responseEntity=null;
        int len;
        if(files!=null&&(len=files.length)>0){
            for(int i=0;i<len;i++) {
                try {
                    String fileName = files[i].getOriginalFilename();
                    if (!TextUtils.isEmpty(fileName) && isImageFile(fileName)) {//判断文件名是否存在且是否为图片类型
                        //创建输出文件对象
                        File outFile = new File(uploadPath + File.separator +"imgs_"+ IceUtils.getUUID() + getFileType(fileName));
                        //拷贝文件到输出文件对象
                        FileUtils.copyInputStreamToFile(files[i].getInputStream(), outFile);
                        //上传成功，写数据库等操作

                    }
                } catch (Exception e) {
                    logger.error("--FileUploadController--handleImagesUpload--", e);
                }
            }
            responseEntity=ResponseUtil.success("上传成功");
        }else{
            responseEntity= ResponseUtil.custom("上传的文件为空或者文件类型不符",RESCODE_PARAM_ERROR);
        }
        return responseEntity;
    }
```

### **<span id = "jump6">Swagger2的配置，生成Restful API文档</span>**
Swagger2可以轻松的整合到Spring boot中，并与Spring MVC程序配合组织出强大RESTful API文档。
它既可以减少我们创建文档的工作量，同时说明内容又整合入实现代码中，让维护文档和修改代码整合为一体，
可以让我们在修改代码逻辑的同时方便的修改文档说明。另外Swagger2也提供了强大的页面测试功能来调试每个RESTful API。
![图1](https://icefire.me/images/swagger01.png)
![图2](https://icefire.me/images/swagger02.png)

接下来看如何使用Swagger2,首先在build.gradle 中添加swagger的库

```groovy
//swagger生成restful api文档
compile 'io.springfox:springfox-swagger-ui:2.6.1'
compile 'io.springfox:springfox-swagger2:2.6.1'
```
在Apllication同目录下新建一个Swagger2的类：

```java
@Configuration
@EnableSwagger2
public class Swagger2 {

    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.icefire.api.controller"))
                .paths(PathSelectors.any())
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("Spring Boot中使用Swagger2构建RESTful APIs")
                .description("Spring Boot中使用Swagger2构建RESTful APIs")
                .termsOfServiceUrl("https://blog.didispace.com/")
                .version("1.0")
                .build();
    }
}
```




如上代码所示，通过@Configuration注解，让Spring来加载该类配置。再通过@EnableSwagger2注解来启用Swagger2。
再通过createRestApi函数创建Docket的Bean之后，apiInfo()用来创建该Api的基本信息（这些基本信息会展现在文档页面中）。
select()函数返回一个ApiSelectorBuilder实例用来控制哪些接口暴露给Swagger来展现，本例采用指定扫描的包路径来定义，
Swagger会扫描该包下所有Controller定义的API，并产生文档内容（除了被@ApiIgnore指定的请求）。

#### 添加文档内容
在完成了上述配置后，其实已经可以生产文档内容，但是这样的文档主要针对请求本身，而描述主要来源于函数等命名产生，对用户并不友好，
我们通常需要自己增加一些说明来丰富文档内容。如下所示，我们通过@ApiOperation注解来给API增加说明、通过@ApiImplicitParams、@ApiImplicitParam注解来给参数增加说明。

```java
@RestController
@RequestMapping("/api/v1/users")
public class UserController {

    @Autowired
    private UserService userService;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @ApiOperation(value="创建用户", notes="该API用于创建新的用户")
    @ApiImplicitParam(name = "userModel", value = "用户详细实体userModel", required = true, dataType = "UserModel")
    @RequestMapping(value="",method= RequestMethod.POST)
    public ResponseEntity<ApiResponse> createUser(@ModelAttribute UserModel userModel){
        ResponseEntity<ApiResponse> responseEntity = ResponseUtil.error();
        int createRes=0;
        if(userModel!=null){
            createRes=userService.createUser(userModel);
        }
        if(createRes>0){
            responseEntity=ResponseUtil.success("success");
        }
        return responseEntity;
    }

    @ApiOperation(value="更新用户信息", notes="该API用于更新用户信息")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "userid", value = "用户userid", required = true, dataType = "String"),
            @ApiImplicitParam(name = "userModel", value = "用户详细实体userModel", required = true, dataType = "UserModel")
    })
    @RequestMapping(value = "/{userid}",method = RequestMethod.POST)
    public ResponseEntity<ApiResponse> updateUser(@PathVariable("userid") String userid,@ModelAttribute UserModel userModel){
        ResponseEntity<ApiResponse> responseEntity = ResponseUtil.error();
        int res=userService.updateUser(userid,userModel);
        if(res>0){
            responseEntity=ResponseUtil.success("success");
        }
        return responseEntity;
    }

    @ApiOperation(value="获取用户信息", notes="该API用于根据用户ID获取用户信息")
    @ApiImplicitParam(name = "userid", value = "用户userid", required = true, dataType = "String")
    @RequestMapping(value = "/{userid}",method = RequestMethod.GET)
    public ResponseEntity<ApiResponse> fetchUserById(@PathVariable("userid") String userid){
        ResponseEntity<ApiResponse> responseEntity = ResponseUtil.notExist();
        UserModel userModel=userService.fetchUserByUserId(userid);
        if(userModel!=null){
            responseEntity= ResponseUtil.success("success",userModel);
        }
        return responseEntity;
    }

    @ApiOperation(value="获取所有的用户信息", notes="该API用于获取所有的用户信息")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "pageNum", value = "页码数", required = false, dataType = "Integer"),
            @ApiImplicitParam(name = "pageSize", value = "一页显示的数目", required = false, dataType = "Integer")
    })
    @RequestMapping(value = "",method = RequestMethod.GET)
    public ResponseEntity<ApiResponse> fetchAllUsers(@RequestParam(value = "pageNum", required = false, defaultValue = "1") Integer pageNum,@RequestParam(value = "pageSize", required = false, defaultValue = "10")Integer pageSize){
        ResponseEntity<ApiResponse> responseEntity = null;
        PageInfo<UserModel> userList=userService.fetchAllUsers(pageNum,pageSize);
        if(userList!=null){
            responseEntity= ResponseUtil.success("success",userList);
        }else{
            responseEntity=ResponseUtil.notExist();
        }
        return responseEntity;
    }
}
```
完成上述代码添加上，启动Spring Boot程序，访问：https://localhost:8080/swagger-ui.html, 就能看到前文所展示的RESTful API的页面。

### 写在最后
到此为止，对Spring boot工程中的一些基本配置就介绍完了。下一篇会介绍登录注册，及Token的创建及验证等和权限控制这部分内容。

