---
title: App项目之服务高级篇
donate: true
date: 2016-12-25 21:56:58
categories: Java
tags:
- Java 
- 服务端
- token
- JWT
- REST
---

### **写在前面**
* [App项目之服务基础篇](https://icefire.me/2016/12/14/App%E9%A1%B9%E7%9B%AE%E4%B9%8B%E6%9C%8D%E5%8A%A1%E5%9F%BA%E7%A1%80%E7%AF%87/)
* [App项目之服务进阶篇](https://icefire.me/2016/12/17/App%E9%A1%B9%E7%9B%AE%E4%B9%8B%E6%9C%8D%E5%8A%A1%E8%BF%9B%E9%98%B6%E7%AF%87/)

我们在前两篇文章的基础上，继续探讨APP服务端的高级配置。那么，我们在此主要探讨的内容有：

* [什么是REST](#jump1)
* [传统的身份认证方法](#jump2)
* [基于Token的身份认证](#jump3)
* [Token的生成之JWT](#jump4)
* [程序示例](#jump5)

### **<span id = "jump1">什么是REST</span>**
REST(Representational State Transfer)是一种软件架构风格。它将服务端的信息和功能等所有事物统称为资源，客户端的请求实际就是对资源进行操作。
它的主要特点有： – 每一个资源都会对应一个独一无二的url – 客户端通过HTTP的GET、POST、PUT、DELETE请求方法对资源进行查询、创建、修改、删除操作 – 客户端与服务端的交互必须是无状态的。

什么是RESTful架构：
* 每一个URI代表一种资源；
* 客户端和服务器之间，传递这种资源的某种表现层；
* 客户端通过四个HTTP动词，对服务器端资源进行操作，实现"表现层状态转化"。

### **<span id = "jump2">传统的身份认证方法</span>**
Http是一种没有状态的协议，也就是服务端不知道谁是访问的应用。把用户看成是客户端，客户端使用用户名和密码进行身份认证，
不过这个客户端再次发送请求，还要验证。解决的方法是，当用户请求登录的时候，如果登录成功，那么在服务端生成一条记录
这条记录用于说明登录用户是谁，然后把这条记录的ID号发给客户端，客户端收到以后把这个ID存储到cookie中，下次这个用户
再向服务器发送请求的时候，可以带着这个Cookie，这样服务端验证一下这个Cookie里的信息，看看能不能在服务端找到对应的纪录，
如果可以，说明用户已经通过了身份验证，把用户请求的数据返回给客户端。

上面说的就是Session，服务端存储为登录的用户生成的Session，这些Session可能存储在内存，磁盘或者数据库中，并且需要服务端定期的清理过期的Session。

### **<span id = "jump3">基于Token的身份认证</span>**
使用基于Token的身份认证，大概的流程是：

1. 客户端使用用户名和密码请求登录
2. 服务端接收请求，去验证用户名与密码
3. 验证成功，服务端签发一个Token(有效期较短)和一个RefreshToken(有效期较长)，再把Token和RefreshToken发送给客户端
4. 客户端接收到Token和RefreshToken后，再把它们存储起来
5. 客户端每次向服务端请求资源的时候需要带着服务端签发的Token
6. 服务端接收到请求，然后去验证客户端请求里面的Token
7. 如果验证成功，则向客户端返回请求结果；如果验证不成功，则用RefreshToken向服务器请求新的Token
8. 服务端接收到请求，然后去验证RefreshToken
9. 如果验证成功,则签发一个新的Token,把Token发给客户端；如果验证不成功，则告诉客户端refreshToken失效，重新登录


### **<span id = "jump4">Token的生成之JWT</span>**
Token的生成方式有很多种，比较热门的有JWT（JSON WEB TOKEN），OAuth等。那我们采用JWT来生成我们的Token。
JWT 标准的 Token 有三个部分：

* header
* payload
* signature

中间用点分隔开，并且都会使用Base64编码，其形式为：

```js
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ
```

#### **Header**
 header 部分主要是两部分内容，一个是Token的类型，另一个是使用的算法，形式如下：

 ```json
{
  "typ": "JWT",
  "alg": "HS256"
}
 ```
 上面的内容用Base64的形式编码一下，变成：

 ```js
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
 ```
 #### **Payload**
 Payload 里面是Token的具体内容，这些内容里面有一些事标准字段，同时可以添加自己需要的内容，标准字段如下：
 * iss: Issuer,发行者
 * sub: Subject,主题
 * aub: Audience,观众
 * exp,Expiration time,过期时间
 * nbf: Not before
 * iat: Issued at,发行时间
 * jti: JWT id

 比如下面的Payload，用到了sub,另外有两个自定义的字段，一个是name,还有一个是admin。

 ```json
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true
}
 ```
 使用Base64编码以后变成这个样子：

 ```js
 eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9
 ```

  #### **Signature**
  JWT 的最后一部分是Signature，这部分内容有三个部分，先是用Base64编码的header.payload，再用加密算法加密一下，加密的时候
  要放进去一个Secret，这个相当于一个密码，这个密码秘密地存储在服务端。
  
  * header
  * payload
  * secret

  ```js
HMACSHA256(base64UrlEncode(header) + "." +base64UrlEncode(payload), 'secret')
  ```
处理完成以后看起来像这样：

```js
TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ
```

最后这个在服务端生成并且要发送给客户端的 Token 看起来像这样：

```js
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ
```
客户端收到这个 Token 以后把它存储下来，下回向服务端发送请求的时候就带着这个 Token 。服务端收到这个 Token ，然后进行验证，通过以后就会返回给客户端想要的资源。

### **<span id = "jump5">程序示例</span>**
* **JWT的生成**
JWT的生成，我们使用的是一个Java的开源库jjwt，添加引用

```groovy
compile 'io.jsonwebtoken:jjwt:0.7.0'
```
同时使用该库，创建一个工具类,用于对token创建，检验等操作

```Java
@Component
public class JwtUtil {

    @Value("${sign.key}")
    private String secrect_key;

    @Value("${spring.profiles.active}")
    private String profiles;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * 生成签名的Key
     * @return
     */
    private SecretKey generalKey(){
        String stringKey=profiles+secrect_key;
        byte[] encodedKey= Base64.decodeBase64(stringKey);
        return new SecretKeySpec(encodedKey,0,encodedKey.length,"AES");
    }

    /**
     * 生成JWT
     * @param id
     * @param subject
     * @return
     */
    public String createJWT(String id,String subject,long ttlMillis) throws Exception{
        String token=null;
        long nowMillis = System.currentTimeMillis();
        Date now = new Date(nowMillis);
        JwtBuilder builder=Jwts.builder().setId(id)
                .setSubject(subject)
                .setIssuedAt(now)
                .signWith(SignatureAlgorithm.HS256,generalKey());
        if(ttlMillis>0){
            long expMillis = nowMillis + ttlMillis;
            Date exp=new Date(expMillis);
            builder.setExpiration(exp);
        }
        return builder.compact();
    }

    /**
     * 检验Token是否
     * @param compactJws
     * @return
     */
    public boolean checkJWT(String compactJws){
        boolean result=false;
        try{
            Claims claims=Jwts.parser().setSigningKey(generalKey()).parseClaimsJws(compactJws).getBody();
            long expTime=claims.getExpiration().getTime();
            long nowTime=System.currentTimeMillis();
            if(expTime>nowTime){
                result=true;
            }
        }catch (Exception e){
            result=false;
            logger.error("parseJWT",e);
        }
        return result;
    }

    /**
     * 解析JWT字符串
     * @param compactJws
     * @return
     */
    public Claims parseJWT(String compactJws){
        Claims claims =null;
        try {
            claims = Jwts.parser().setSigningKey(generalKey()).parseClaimsJws(compactJws).getBody();
        }catch (Exception e){
            logger.error("checkJWT",e);
        }
        return claims;
    }
}
```

创建一个TokenModel的类，存储于JWT的Subject
```Java
public class TokenModel {
    private String userId;
    private String roleId;
    //getter和setter省略
}
```

Token的创建与检测的类
```Java
@Service
public class TokenServiceImpl implements TokenService{

    @Autowired
    private StringRedisTemplate redisTemplate;
    @Autowired
    private JwtUtil jwtUtil;

    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    @Override
    public String createAccessToken(String userId) {
        String access_token=null;
        TokenModel tokenModel=new TokenModel(userId);
        try {
            //生成Token
            access_token = jwtUtil.createJWT(Constant.JWT_ID, JSONUtils.toJson(tokenModel), Constant.JWT_TTL);
            //保存登录状态(存储于redis服务器中)
            redisTemplate.boundValueOps(RedisUtils.generateTokenKey(userId)).set(access_token,Constant.JWT_TTL, TimeUnit.MILLISECONDS);
        }catch (Exception e){
            logger.error("---TokenServiceImpl---createToken---",e);
        }
        return access_token;
    }

    @Override
    public String createRefreshToken(String userId) {
        String refreshToken=null;
        TokenModel tokenModel=new TokenModel(userId);
        try {
            //生成Token
            refreshToken = jwtUtil.createJWT(Constant.JWT_ID, JSONUtils.toJson(tokenModel), Constant.JWT_REFRESH_TTL);
            //保存登录状态
            redisTemplate.boundValueOps(RedisUtils.generateRefreshTokenKey(userId)).set(refreshToken,Constant.JWT_REFRESH_TTL, TimeUnit.MILLISECONDS);
        }catch (Exception e){
            logger.error("---TokenServiceImpl---createToken---",e);
        }
        return refreshToken;
    }

    @Override
    public boolean checkToken(String token) {
        if(token==null){
            return false;
        }
        Claims claims = jwtUtil.parseJWT(token);//解析获取token中的userId
        if(claims!=null){
            long expireTime=claims.getExpiration().getTime();
            long currentTime=System.currentTimeMillis();
            if(currentTime<expireTime){//表示已过期
                TokenModel tokenModel=JSONUtils.fromJson(claims.getSubject(),TokenModel.class);
                String userId=tokenModel.getUserId();
                String redisToken=redisTemplate.opsForValue().get(RedisUtils.generateTokenKey(userId));
                if(TextUtils.equals(token,redisToken)){//相同
                    //如果验证成功，说明此用户进行了一次有效操作，延长token的过期时间
                    //redisTemplate.boundValueOps(RedisUtils.generateTokenKey(userId)).expire(Constant.JWT_TTL, TimeUnit.MILLISECONDS);
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public boolean checkRefreshToken(String refresh_token) {
        if(refresh_token==null){
            return false;
        }
        Claims claims = jwtUtil.parseJWT(refresh_token);//解析获取token中的userId
        if(claims!=null){
            long expireTime=claims.getExpiration().getTime();
            long currentTime=System.currentTimeMillis();
            if(currentTime<expireTime) {//表示已过期
                TokenModel tokenModel=JSONUtils.fromJson(claims.getSubject(),TokenModel.class);
                String userId=tokenModel.getUserId();
                String redisToken=redisTemplate.opsForValue().get(RedisUtils.generateRefreshTokenKey(userId));
                if(TextUtils.equals(refresh_token,redisToken)) {//相同
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public void deleteToken(String userId) {
        redisTemplate.delete(RedisUtils.generateTokenKey(userId));
    }

    @Override
    public void deleteRefreshToken(String userId) {
        redisTemplate.delete(RedisUtils.generateRefreshTokenKey(userId));
    }

    @Override
    public TokenModel parseToken(String token) {
        TokenModel tokenModel=null;
        Claims claims = jwtUtil.parseJWT(token);//解析获取token中的userId
        if(claims!=null){
            tokenModel=JSONUtils.fromJson(claims.getSubject(),TokenModel.class);
        }
        return tokenModel;
    }
}
```

再来看我们的TokenController类了：用户登录获取token以及通过refreshToken获取token
```Java
@RestController
@RequestMapping("/api/v1/")
public class TokenController {

    @Autowired
    private UserService userService;

    @Autowired
    private TokenService tokenService;

    @ApiOperation(value="用户登录", notes="该API用于用户登录,成功后返回用户信息")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "username", value = "用户登录账号", required = true, dataType = "String"),
            @ApiImplicitParam(name = "password", value = "用户登录密码", required = true, dataType = "String")
    })
    @RequestMapping(value="login",method = RequestMethod.POST)
    public ResponseEntity login(@RequestParam String username,@RequestParam String password){
        Assert.notNull(username, "username can not be empty");
        Assert.notNull(password, "password can not be empty");
        UserModel userModel=userService.fetchUserByUserName(username);
        if(userModel==null || !userModel.getPassword().equals(password)){
            return ResponseUtil.custom("用户名或密码错误", Constant.USERNAME_OR_PASSWORD_ERROR);
        }

        //生成一个token，保存用户登录状态
        String accessToken=tokenService.createAccessToken(userModel.getUserId());
        String refreshToken=tokenService.createRefreshToken(userModel.getUserId());
        if(accessToken==null||refreshToken==null){
            return ResponseUtil.exception("创建token失败");
        }
        LoginResult loginResult=createResult(userModel);
        loginResult.setAccess_token(accessToken);
        loginResult.setExpire_in(Constant.JWT_TTL);
        loginResult.setRefresh_token(refreshToken);
        loginResult.setExpire_refresh_in(Constant.JWT_REFRESH_TTL);
        return ResponseUtil.success("登录成功",loginResult);
    }


    @ApiOperation(value="获取token", notes="该API用于用户使用refreshToken获取token")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "grant_type", value = "授权类型", required = true, dataType = "String"),
            @ApiImplicitParam(name = "refresh_token", value = "refresh_token", required = true, dataType = "String")
    })
    @RequestMapping(value = "token",method = RequestMethod.POST)
    public ResponseEntity refresh(@RequestParam String grant_type,@RequestParam String refresh_token){
        Assert.notNull(grant_type, "username can not be empty");
        Assert.notNull(refresh_token, "password can not be empty");

        if(!TextUtils.equals(grant_type,"refresh_token")){
            return ResponseUtil.paramError();
        }
        if(!tokenService.checkRefreshToken(refresh_token)){//验证未通过
            return ResponseUtil.custom(Constant.RESCODE_EXPIRE_OR_NOTEXIST,"refresh_token不正确或者已过期");
        }

        TokenModel tokenModel=tokenService.parseToken(refresh_token);
        //生成一个token，保存用户登录状态
        String accessToken=tokenService.createAccessToken(tokenModel.getUserId());
        if(accessToken==null){
            return ResponseUtil.exception("创建token失败");
        }
        RefreshResult refreshResult=new RefreshResult();
        refreshResult.setAccess_token(accessToken);
        refreshResult.setRefresh_token(refresh_token);
        return ResponseUtil.success("获取token成功",refreshResult);
    }
    /**
     * 创建返回结果
     * @param userModel
     * @return
     */
    private LoginResult createResult(UserModel userModel){
        LoginResult loginResult=new LoginResult();
        loginResult.setUserId(userModel.getUserId());
        loginResult.setGender(userModel.getGender());
        loginResult.setMobile(userModel.getMobile());
        loginResult.setEmail(userModel.getEmail());
        loginResult.setNickName(userModel.getNickName());
        loginResult.setAvatar(userModel.getAvatar());
        loginResult.setBio(userModel.getBio());
        loginResult.setBlog(userModel.getBlog());
        return loginResult;
    }
}
```

此外，我们创建一个注解Authorization,该注解用于标注哪些方法需要登录（即带有token信息）
```Java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Authorization {

}
```

最后要讲的是如何对于token的解析，创建一个AuthorizationInterceptor权限拦截器，在请求处理之前
我们拦截到token，对token的真实性及失效性进行分析

```Java
@Component
public class AuthorizationInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtUtil jwt;

    @Autowired
    private TokenService tokenService;

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * 在请求处理之前进行调用
     * @param request
     * @param response
     * @param handler
     * @return
     * @throws Exception
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //如果不是映射到方法直接通过
        if (!(handler instanceof HandlerMethod)) {
            return true;
        }

        HandlerMethod handlerMethod = (HandlerMethod) handler;
        Method method = handlerMethod.getMethod();
        //从header中取出token
        String authorization = request.getHeader(Constant.AUTHORIZATION);
        //验证token
        if(tokenService.checkToken(authorization)){//token验证成功
            TokenModel tokenModel=tokenService.parseToken(authorization);
            if(tokenModel!=null){
                request.setAttribute(Constant.CURRENT_USER_ID, tokenModel.getUserId());
                return true;
            }
        }
        //如果验证token失败，并且方法注明了Authorization，返回401错误
        if (method.getAnnotation(Authorization.class) != null){
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return false;
        }
        return true;
    }

    /**
     * 请求处理之后进行调用，但是在视图被渲染之前
     * @param request
     * @param response
     * @param handler
     * @param modelAndView
     * @throws Exception
     */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    /**
     * 在整个请求结束之后被调用，也就是在DispatcherServlet 渲染了对应的视图之后执行
     * @param request
     * @param response
     * @param handler
     * @param ex
     * @throws Exception
     */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
```

最后就是对刚刚创建的拦截器进行注册：
```Java
@Configuration
@EnableWebMvc
public class InterceptorConfiguration extends WebMvcConfigurerAdapter {
    @Bean
    public AuthorizationInterceptor authorizationInterceptor(){
        return new AuthorizationInterceptor();
    }
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authorizationInterceptor())
                .addPathPatterns("/**");

    }
}
```

### **写在最后**
到此为止，我们已经创建了一个比较简易的能够支撑轻量级的APP服务端，然后根据我们的业务，在进行扩充就可以了。