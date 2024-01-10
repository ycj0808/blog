---
title: SpringCloud测试负载均衡
donate: true
date: 2018-03-26 11:41:13
categories: SpringCloud
tags:
---

## 测试SpringCloud 服务负载均衡
```
    @Autowired
    private DiscoveryClient client;

    @RequestMapping(value = "/add/{a}/{b}",method = RequestMethod.GET)
    public String add(@PathVariable Integer a,@PathVariable Integer b){
        System.out.println("host:"+client.getLocalServiceInstance().getHost()+"   -----port:"+client.getLocalServiceInstance().getPort());
        return a+b+" ------      host:"+client.getLocalServiceInstance().getHost()+"   -----port:"+client.getLocalServiceInstance().getPort();
    }
```
