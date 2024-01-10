---
title: Java基础知识点
donate: true
date: 2018-04-15 17:33:19
categories:
tags:
---

## Java基础

1. java中==和equals和hashCode的区别
```
    “==”测试的是两个对象的引用是否相同
    equals()比较的是两个字符串的值是否相等（对象的内容是否相同）
    hashcode()方法返回一个int值，在Object类中的默认实现是“将该对象的内部地址转换成一个整数返回”
```

2. int、char、long各占多少字节数
```
    int 32位占4个字节
    char 16位占2个字节
    long 64位占4个字节
```
3. int与integer的区别
```
int与integer的区别

    int 是基本数据类型（byte,short,int,long,float,double等）
    Integer 是对象，用一个引用指向这个对象
    关系：Integer是int的封装类，都可以表示一个数值
```

4. 对java多态的理解
```
    定义：允许不同类的对象对同一个消息做出响应。即同一消息可以根据发送对象的不同而采用多种不同的行为方式。
    作用：消除类型之间的耦合关系
    三个必要条件：继承，重写，父类引用指向子类对象
    好处：可替换性，可扩充性，接口性，灵活性，简化性
    实现方式：接口实现，继承父类进行方法冲洗，同一个类中进行方法重载
```

5. String、StringBuffer、StringBuilder区别
```
    String: 字符串常量，字符串长度不可变。Java中String是immutable（不可变）的。用于存放字符的数组被声明为final的，因此只能赋值一次，不可再更改。
    StringBuffer: 字符串变量（Synchronized，即线程安全）
    StringBuilder：字符串变量（非线程安全）
    String 类型和StringBuffer的主要性能区别：String是不可变的对象, 因此在每次对String 类型进行改变的时候，都会生成一个新的 String 对象，然后将指针指向新的 String 对象，所以经常改变内容的字符串最好不要用 String。
    使用 StringBuffer 类时，每次都会对 StringBuffer 对象本身进行操作，而不是生成新的对象并改变对象引用。

    使用原则：
    基本原则：如果要操作少量的数据，用String ；单线程操作大量数据，用StringBuilder ；多线程操作大量数据，用StringBuffer
    不要使用String类的"+"来进行频繁的拼接，因为那样的性能极差的，应该使用StringBuffer或StringBuilder类，这在Java的优化上是一条比较重要的原则。
    为了获得更好的性能，在构造 StringBuffer 或 StringBuilder 时应尽可能指定它们的容量
    StringBuilder一般使用在方法内部来完成类似"+"功能，因为是线程不安全的，所以用完以后可以丢弃。StringBuffer主要用在全局变量中。
```

6. 什么是内部类？内部类的作用
```
    定义：定义在其它类中的类被称作内部类。内部类可以有访问修饰符，甚至可以被标记为abstract或final。内部类与外部类有特殊关系，这种关系允许内部类访问外部类的成员，也包括私有成员。
    分类：
        * inner class（一个内部类被声明在另外一个类当中）
        * 局部内部类（被定义在外部类的方法当中）
        * 匿名内部类 （没有名字，只能实例化一次，通常声明在方法或代码块的内部，以一个带有分毫的花括号结尾，没有构造函数，不能是静态的）--- 建行代码
        * 静态嵌套类（一个静态嵌套类是被标记为static的内部类，它无法访问外部类的非静态成员）

    内部类的特点：
        * 内部类可以实现隐藏，一般的非内部类，是不允许有private与projected权限的，但内部类可以
        * 内部类拥有外围类的所有元素的访问权限
        * 可是实现多重继承
        * 可以避免修改接口而实现同一个类中两种同名方法的调用
    
    静态内部类和非静态内部类比较：
        * 静态内部类可以有静态成员，而非静态内部类则不能有静态成员。
        * 静态内部类的非静态成员可以访问外部类的静态变量，而不可访问外部类的非静态变量
        * 非静态内部类的非静态成员可以访问外部类的非静态变量   

    生成一个静态内部类不需要外部类成员：这是静态内部类和成员内部类的区别。     
```
7. 抽象类和接口区别
```
    对比：
        * 默认方法的实现：抽象类可以有默认的方法实现，而接口完全是抽象的，不存在方法实现
        * 构造器： 抽象类可以有构造器，接口不能有构造器
        * 普通Java 类: 除不能实例化抽象类外，没有任何区别；接口是完全不同类型
        * 访问修饰符: 抽象类可以有public，private和protected及default修饰符，而接口默认是public，不可以用其它
        * main方法：抽象类可以有main方法，并且可以运行；而接口没有main方法，不能运行
        * 多继承：抽象类可以继承一个类多个接口，接口只可以继承一个或多个其它接口
        * 速度：抽象类比接口速度快；接口稍微有点慢，因为它需要时间去寻找在类中实现方法
        * 添加新方法：在抽象类中添加新的方法可以提供默认实现，可以不用改变现在的代码；接口中添加方法，必须改变实现该接口的类。

        接口是对动作的抽象，而抽象类是对根源的抽象；接口是抽象类的变体，接口中所有的方法都是抽象的，而抽象类中的声明的方法的存在而不去实现它的类。
        接口是多继承，而抽象类不行；接口定义方法不实现，抽象类可以实现部分方法；接口中的基本数据类型为static，而抽象类不是；抽象类功能查过接口，代价大。
```
8. 抽象类的意义
```
    * 为其子类提供一个公共的类型
    * 封装子类中的重复内容
    * 定义抽象方法，虽然子类有不同的实现，但是定义是一致的
```
9. 抽象类与接口的应用场景
```
    * 如果你拥有一些方法并且想让它有默认的实现，则使用抽象类。
    * 如果你想实现多继承，则必须使用接口。由于java不支持多继承，子类不能继承多个类，但可以实现多个接口。
    * 如果基本功能不断改变，那么需要使用抽象类。如果不断改变基本功能并且使用接口，那么需要改变所有实现了该接口的类。
```
10. 抽象类是否可以没有方法和属性？
```
    * 抽象类专用于派生出子类，子类必须实现抽象类所声明的抽象方法，否则，子类仍是抽象类。
    * 包含抽象方法的类一定是抽象类，但抽象类中的方法不一定是抽象方法。
    * 抽象类中可以没有抽象方法，但有抽象方法的一定是抽象类。所以，java中 抽象类里面可以没有抽象方法。比如HttpServlet类。抽象类和普通类的区别就在于，抽象类不能被实例化，就是不能被new出来，即使抽象类里面没有抽象方法。
    * 抽象类的作用在于子类对其的继承和实现，也就是多态；而没有抽象方法的抽象类的存在价值在于：实例化了没有意义，因为类已经定义好了，不能改变其中的方法体，但是实例化出来的对象却满足不了要求，只有继承并重写了他的子类才能满足要求。所以才把它定义为没有抽象方法的抽象类
```
11. 接口的意义
```
    * 使java拥有强大的面向对象的能力
    * 简单，规范
    * 维护可扩展
    * 安全严密
```
12. 泛型中extends和super的区别
```
    <? extends T> 表示类型的上界，表示参数化类型的可能是T 或是 T的子类
    <? super T> 表示类型下界（Java Core中叫超类型限定），表示参数化类型是此类型的超类型（父类型），直至Object

    extends 可用于的返回类型限定，不能用于参数类型限定
    super 可用于参数类型限定，不能用于返回类型限定
    带有super超类型限定的通配符可以向泛型对易用写入,带有extends子类型限定的通配符可以向泛型对象读取。
```


13. 父类的静态方法能否被子类重写
```
    因为静态方法从程序开始运行后就已经分配了内存，也就是说已经写死了。所有引用到该方法的对象（父类的对象也好子类的对象也好）所指向的都是同一块内存中的数据，也就是该静态方法。子类中如果定义了相同名称的静态方法，并不会重写，而应该是在内存中又分配了一块给子类的静态方法，没有重写这一说。
```


14. 进程和线程的区别
```
    一个程序至少有一个进程,一个进程至少有一个线程
    线程的划分尺度小于进程，使得多线程程序的并发性高
    进程在执行过程中拥有独立的内存单元，而多个线程共享内存，从而极大地提高了程序的运行效率
    线程在执行过程中与进程有区别。每个独立的线程有一个程序运行入口，顺序执行序列和程序的出口。但是线程不能够独立执行，必须依存在应用程序中，由应用程序提供多个线程执行控制。

    从逻辑角度来看，多线程的意义在于一个应用程序中，有多个执行部分可以同时执行。但操作系统并没有将多个线程看做多个独立的应用，来实现进程的调度和管理以及资源分配。
    一个线程可以创建和撤销另一个线程;同一个进程中的多个线程之间可以并发执行.
    进程和线程的主要差别在于它们是不同的操作系统资源管理方式。进程有独立的地址空间，一个进程崩溃后，在保护模式下不会对其它进程产生影响，而线程只是一个进程中的不同执行路径。线程有自己的堆栈和局部变量，但线程之间没有单独的地址空间，一个线程死掉就等于整个进程死掉，所以多进程的程序要比多线程的程序健壮，但在进程切换时，耗费资源较大，效率要差一些。但对于一些要求同时进行并且又要共享某些变量的并发操作，只能用线程，不能用进程。
```
15. final，finally，finalize的区别
```
    final 用于声明属性,方法和类, 分别表示属性不可变, 方法不可覆盖, 类不可继承
    finally 是异常处理语句结构的一部分，表示总是执行
    finalize 是Object类的一个方法，在垃圾收集器执行的时候会调用被回收对象的此方法，可以覆盖此方法提供垃圾收集时的其他资源回收，例如关闭文件等. JVM不保证此方法总被调用.
```

16. 序列化的方式
```
    序列化 (Serialization)将对象的状态信息转换为可以存储或传输的形式的过程。简单地说，将运行时的对象状态转换成二进制，然后保存到流、内存或者通过网络传输给其他端
    Serializable接口和和Parcelable 接口

```
17. Serializable 和Parcelable 的区别
```
    Serializable，要传递的类实现Serializable接口传递对象
    Parcelable，要传递的类实现Parcelable接口传递对象
    Serializable是序列化的意思，表示将一个对象转换成可存储或可传输的状态。序列化后的对象可以在网络上进行传输，也可以存储到本地。
    Parcelable方式的实现原理是将一个完整的对象进行分解，而分解后的每一部分都是Intent所支持的数据类型，这样也就实现传递对象的功能了。
    实现Parcelable的作用：永久性保存对象，保存对象的字节序列到本地文件中；通过序列化对象在网络中传递；通过序列化在进程间传递对象

    比较：在使用内存的时候，Parcelable比Serializable性能高；Serializable在序列化的时候会产生大量的临时变量，从而引起频繁的GC；
    Parcelable不能使用在要将数据存储在磁盘上的情况，因为Parcelable不能很好的保证数据的持续性在外界有变化的情况下。尽管Serializable效率低点，但此时还是建议使用Serializable 
```


18. 静态属性和静态方法是否可以被继承？是否可以被重写？以及原因？
```
 1. 静态变量和方法说继承并不确切，静态方法与变量是属于类的方法与变量。而子类也属于超类，所以子类也能够调用属于超类的静态变量和方法。注意：子类调用的其实是超类的静态变量和方法，
    而不是继承自超类的静态方法和变量。但是如果子类中有同名的静态方法和变量，这时候调用的是子类的本身，因为子类的静态变量和静态方法会隐藏父类的静态方法和静态变量。
 2. 如果子类中没有定义同名的变量和方法，那么调用子类名.静态方法/静态变量 调用的是父类的方法与变量
 3. 如果子类中指定以了同名的静态变量，而没有定义与父类同名的静态方法，则调用  子类名.静态方法 时，调用的是父类的静态方法，静态方法中的静态变量是父类的。
 4. 如果子类中定义了与父类同名的静态变量，也定义了与父类同名的静态方法，这时调用 子类名.静态方法 ，完全与父类无关，里面的静态变量也是子类的。   
```
19. 静态内部类的设计意图，成员内部类、静态内部类、局部内部类和匿名内部类的理解，以及项目中的应用
```
    内部类：即定义在一个类的内部的类。再java中类是单继承的，一个类只能继承另一个具体类或抽象类，实现多个接口。设计目的：在多继承中，当多个父类中有重复的属性或者方法，子类的调用结果会含糊不清。
           使用内部类的原因：每个内部类都能独立的继承一个接口的实现，所以无论外围类是否已经继承某个接口实现，对内部类都没有影响。

    成员内部类：是最普通的内部类，它是外围类的一个成员，可以无限制的访问外围类的所有成员属性和方法。而外围类访问内部类的成员属性和方法则需要通过内部类的实例类访问。
            成员内部类中不能存在任何static的变量和方法
            成员内部类依附与外围类，所以只有先创建外围类才能创建内部类。
    静态内部类与非静态内部类之间存在的最大区别：
        非静态内部类在编译完成之后会隐含地保存者一个引用，该引用是指向创建它的外围类，但是静态内部类却没有。
        所以：静态内部类的创建不依赖与外围类；它不能使用任何外围类的非static成员变量和方法。

    局部内部类：它是嵌套在方法的作用域内的，对于这个类的使用主要是应用与解决比较复杂的问题。

    匿名内部类：没有访问修饰符；new 匿名内部类，这个类首先要存在；当所在方法的形参需要被匿名内部类使用，那么这个形参必须为final；没有明面的构造方法，编译器会自动生成一个引用外部类的构造方法。    
```
21. 谈谈对kotlin的理解
```
     特性：轻量级，与java互操作，无缝通信；强类型，很少在代码中指定类型；NULL安全，使用的是显示的null，强制我们必要时进行null检查。
```
23. String与Integer的相互转化
```
    Integer转String：
    //方法一:Integer类的静态方法toString()
    Integer a = 2;
    String str = Integer.toString(a)

    //方法二:Integer类的成员方法toString(),若a为null，则返回null
    Integer a = 2;
    String str = a.toString();

    //方法三:String类的静态方法valueOf()
    Integer a = 2;
    String str = String.valueOf(a);//若a为null，则返回字符串null

    方式一和方式二，Integer的静态方法toString()和成员方法toString()是一样的，成员方法里面仅仅是调用了静态方法而已

    String转Integer

    String str = "...";
    Integer i = null;
    if(str!=null){
     i = Integer.valueOf(str);
    }
```


## java深入源码级

1. 哪些情况下的对象会被垃圾回收机制处理掉？
```
    Java 垃圾回收机制最基本的做法是分代回收。内存中的区域被划分成不同的世代，对象根据其存活的时间被保存在对应世代的区域中。
    一般的实现是划分成3个世代：年轻、年老和永久。内存的分配是发生在年轻世代中的。当一个对象存活时间足够长的时候，
    它就会被复制到年老世代中。对于不同的世代可以使用不同的垃圾回收算法。进行世代划分的出发点是对应用中对象存活时间进行研究之后得出的统计规律。
    一般来说，一个应用中的大部分对象的存活时间都很短。比如局部变量的存活时间就只在方法的执行过程中。基于这一点，对于年轻世代的垃圾回收算法就可以很有针对性。

    对象不可达时会被标记回收，即使不可达到，对象也并非非死不可
    1.首先对象会是否有必要执行finalize()方法。2.如果有必要执行，会把对象放到一个队列中，jvm会开一个线程去回收它们，这是对象最后一次可以逃脱清理的机会。
```
2. 讲一下常见编码方式？
```
    常见的字符集：ASCII、GBK、Unicode、GBK2312、
    UTF-8是Unicode的一种编码方式

    Unicode中大部分汉字是采用2字节表示的，因此UTF8编码后大小是3字节
    有些少数不常见的汉字是采用3字节表示的，因此UTF8编码后大小是4字节
    英文UTF-8编码只占一个字节

    - UTF8是Unicode字符集的一种编码方式，主要用与信息传输和存储； 
    - GBK编码对于汉字要比UTF8节省空间，但是不是全球通用，有些环境下会出现乱码； 
    - UTF-8中大部分汉字采用3字节表示，少些复杂的字采用4字节表示；分别对应的Unicode也是2字节和3字节；
```
3. utf-8编码中的中文占几个字节；int型几个字节？
```
    UTF-8中大部分汉字采用3字节表示，少些复杂的字采用4字节表示；分别对应的Unicode也是2字节和3字节；
    int型占4个字节
```
4. 静态代理和动态代理的区别，什么场景使用？
```
    https://blog.csdn.net/bohu83/article/details/51124094
    代理模式：代理类和委托类有共同的父类或父接口，这样在任何使用委托类对象的地方都可以使用代理对象替代。代理类负责请求的预处理、过滤、将请求分派给委托类处理、以及委托
    类执行完请求后的后续处理。

    静态代理：所谓静态也就是在程序运行前就已经存在代理类的字节码文件，代理类和委托类的关系在运行就确定了。
    代理接口（Subject）、代理类（ProxySubject）、委托类（RealSubject）
    静态代理类优缺点：
    优点：业务类只需要关注业务逻辑本身，保证了业务类的重要性。
    缺点：1.代理对象的一个接口只服务与一种类型的对象，如果要代理的方法很多，势必要为每一种方法都进行代理，静态代理在程序规模稍大时就无法胜任了。
         2.如果接口增加一个方法，除了所有实现类需要实现这个方法外，所有代理类也需要实现此方法。增加了代码的维护复杂度。

    动态代理类的源码是在程序运行期间由JVM根据反射等机制动态的生成，所以不存在代理类的字节码文件。  代理类和委托类的关系是在程序运行时确定。   
    动态代理类实现步骤：
    1.实现InvocationHandler接口创建自己的调用处理器
    2.给Proxy类提供ClassLoader和代理接口类型数组创建动态代理类
    3.以调用处理器类型为参数，利用反射机制得到构造函数
    4.以调用处理器对象为参数，利用动态代理类的构造函数创建动态代理对象
    动态代理机制的好处：
    1.减少编程的工作量，假如需要实现多种代理处理逻辑，只要写多个代理处理器就可以，无需每种方式都写一个代理类
    2.系统扩展性和维护性增强，程序修改起来也方便
    缺点：
    代理类和委托类需要实现同一个接口。只有实现了某个接口的类可以使用Java动态代理机制。所以对于没有实现接口的类，目前无法使用该机制。

    使用场景：
    作用：1.方法增强，让你可以在不修改源码的情况下，增强一些方法，比如添加日志
         2.以用作远程调用，好多rpc框架就是用代理方式实现的。
    代理这块与反射有关系，调用了其中的方法。动态代理除了jdk的接口实现方法还有cglib，以及相关的springAOP，还有RPC框架也是代理实现的。     
```
5. Java的异常体系
```
    Java把异常当作对象来处理，并定义一个基类java.lang.Throwable作为所有异常的超类。在Java API中，异常分为两大类：Error和Exception。Exception又分运行时异常和非运行时异常。
    异常之间的区别和联系：
    1.Error和Exception
    Error是程序无法处理的错误，比如OutOfMemoryError、ThreadDeath等。这些一次发生时，Java虚拟机一般不会选择线程终止。
    Exception是程序本身可以处理的异常，这种异常分为两大类运行时异常和非运行时异常。
    2.运行时异常和非运行时异常
    运行时异常都是RuntimeException类及其子类异常，如NullPointerException、IndexOutOfBoundsException等，这些异常是不检查异常，程序中可以选择捕获处理，也可以不处理。这些异常一般
    由程序逻辑错误引起的，程序应该从逻辑角度尽可能避免这类异常。

    非运行时异常是RuntimeException以外的异常，类型上都属于Exception类及其子类。从程序语法角度讲是必须处理的异常，如果不处理，程序不能编译通过。如IOException、SQLException等以及用户
    自定义的Exception异常，一般情况下不定义检查异常。

    异常的捕获和处理
    java异常处理涉及到五个关键字：try、catch、finally、throw、throws。
    异常处理的基本语法：try{}catch(异常类型 e){}finally{}
    throw、throws：
    throw关键字是用于方法体内部，用来抛出一个Throwable类型的异常。如果抛出了检查异常， 
    则还应该在方法头部声明方法可能抛出的异常类型。该方法的调用者也必须检查处理抛出的异常。 
    throws关键字用于方法体外部的方法声明部分，用来声明方法可能会抛出某些异常。仅当抛出了检查异常， 
    该方法的调用者才必须处理或者重新抛出该异常。

    Throwable类中的常用方法 ：
    getCause()：返回抛出异常的原因。如果 cause 不存在或未知，则返回 null。
    getMessage()：返回异常的消息信息。 
    printStackTrace()：对象的堆栈跟踪输出至错误输出流，作为字段 System.err 的值。

    异常处理的一般原则：
    1. 能处理就早处理，抛出不去还不能处理的就想法消化掉或者转换为RuntimeException处理。
    2. 对于检查异常，如果不能行之有效的处理，还不如转换为RuntimeException抛出。
    3. 对于一个应用系统来说，应该有自己的一套异常处理框架，这样当异常发生时，也能得到统一的处理风格，将优雅的异常信息反馈给用户

    总结：
    1.异常是程序运行过程过程出现的错误，在Java中用类来描述，用对象来表示具体的异常。 
    Java将其区分为Error与Exception，Error是程序无力处理的错误，Exception是程序可以处理的错误。 异常处理是为了程序的健壮性。
    2.Java异常类来自于Java API定义和用户扩展。通过继承Java API异常类可以实现异常的转译。
    3.异常能处理就处理，不能处理就抛出，最终没有处理的异常JVM会进行处理。
    4.异常可以传播，也可以相互转译，但应该根据需要选择合理的异常转译的方向。 
    5.对于一个应用系统，设计一套良好的异常处理体系很重要。这一点在系统设计的时候就应该考虑到。
```
6. 谈谈你对解析与分派的认识。
```
    解析：方法在程序真正运行之前就有一个可以确定的调用版本，并且这个方法的调用版本在运行期是不可改变的，即“编译期可知，运行期不可变”
    解析调用是一个静态过程，在编译期就完全确定。
    分派调用则可能是静态的也可能是动态的，分派是多态的体现，Java虚拟机底层提供了我们开发中重载和重写的底层实现。重载属于静态分派，重写属于动态分派。
    静态分派：所有依赖静态类型来定位方法执行版本的分派动作。
    动态分派一个最直接的例子是重写。
```
7. 修改对象A的equals方法的签名，那么使用HashMap存放这个对象实例的时候，会调用哪个equals方法？
```
    会调用对象对象的equals方法
    https://www.jianshu.com/p/985534b21089
```
8. Java中实现多态的机制是什么？
```
    多态就是指程序中定义的引用变量所指向的具体类型和通过该引用变量发出的方法调用在编程时并不确定，而是在程序运行期间才确定，即一个引用变量倒底会指向哪个类的实例对象，
    该引用变量发出的方法调用到底是哪个类中实现的方法，必须在由程序运行期间才能决定。因为在程序运行时才确定具体的类，这样，不用修改源程序代码，就可以让引用变量绑定到各种不同的类实现上，
    从而导致该引用调用的具体方法随之改变，即不修改程序代码就可以改变程序运行时所绑定的具体代码，让程序可以选择多个运行状态，这就是多态性。

    指向子类的父类引用由于向上转型了，它只能访问父类中拥有的方法和属性，而对于子类中存在而父类中不存在的方法，该引用是不能使用的，尽管是重载该方法。若子类重写了父类中的某些方法，
    在调用该些方法的时候，必定是使用子类中定义的这些方法（动态连接、动态调用）。

    编译时多态和运行时多态
    编译时多态是静态的，主要是方法重载
    运行时多态是通过动态绑定来实现的

    多态实现的三个必要条件：继承、重写、向上转型
    多态实现形式：继承和接口
```
9. 如何将一个Java对象序列化到文件里？
```
    Java中要实现将对象保存起来持久化，需要让对象实现Serializable接口，这样就能将java对象用二进制流保存并恢复。
    写文件：
    1.要保存到文件首先必须得获得文件输入流  new FileOutputStream(fileName)
    2.然后将文件输入流作为参数，构造对象输入流 ObjectOutputStream oos=new ObjectOutputStream(new FileOutputStream(fileName));  
    3.然后直接将对象输入到文件中 oos.writeObject(p); oos.close();    
    恢复文件：
    1.先获得文件输出流 new FileInputStream(fileName)
    2.将文件输出流作为参数，构造对象输出流 ObjectInputStream ois=new ObjectInputStream(new FileInputStream(fileName));  
    3.就能够得到对象，然后再强制性转换为原始对象即可 Person person=(Person)ois.readObject();  

```
10. 说说你对Java反射的理解
```
    Class对象：
    虚拟机在class文件的加载阶段，把类信息保存在方法区数据结构中，并在Java堆中生成一个Class对象，作为类信息的入口
    获取Class对象的三种方式：
    1.通过实例变量方式 Dog dog=new Dog();Class clazz = dog.getClass();
    2.通过类名Class clazz = Dog.class;//只会加载Dog类，并不会触发其类构造器的初始化
    3.通过Class.forName(String classname)方式 Class clazz = Class.forName("zzzzzz.Dog");

    反射机制reflect可以在运行期间获取类的字段、方法、父类和接口等信息。
    1.获取类字段
    Class class_dog = Dog.class;
    Field[] fields = class_dog.getDeclaredFields();
    for (Field field : fields) {
        System.out.println(field.getName());
    }

    2.获取类方法
    Class class_dog = Dog.class;
    Method[] methods = class_dog.getDeclaredMethods();
    for (Method method : methods) {
        System.out.println(method);
    }
    通过method.invoke(obj, ...args)可以调用obj实例的method方法。

    3.获取对应的实例构造器，并生成类实例
public class ClassTest {
    public static void main(String[] args) throws NoSuchMethodException {
        Class class_dog = Dog.class;
        Constructor constructor = class_dog.getConstructor(String.class, int.class);
        constructor.newInstance("Tom", 10);
    }
}

class Dog {
    private String name;
    private int age;

    public Dog(String name, int age) {
        this.name = name;
        this.age = age;
    }
}

    4.通过newInstance()方法生成类实例
    Class class_dog = Dog.class;
    Dog dog = class_dog.newInstance();

    5.设置私有变量
    Class class_dog = Dog.class;
    Field name = class_dog.getDeclaredField("name");
    name.setAccessible(true);
    Dog dog = (Dog) class_dog.newInstance();
    name.set(dog, "Tom");

    6.获取私有变量
    Field f = Unsafe.class.getDeclaredField("theUnsafe");
    f.setAccessible(true);
    return (Unsafe)f.get(null);

```
11. 说说你对Java注解的理解
```
    注解：也叫元数据。一种代码级别的说明，在JDK1.5之后引入的特性，与类、接口、枚举同一层次。
    可以声明在包、类、字段、方法、局部变量、方法参数等前面，来对这些元素进行说明，注释等。
    作用分类：
    1.编写文档：通过代码里的标识的元数据生成文档
    2.代码分析：通过代码里的标识的元数据对代码进行分析
    3.编译检查：通过代码里的标识的元数据让编译器能过实现基本的编译检查

    @Target ：规定注解所修饰的对象范围
    @Retention ： 表示注解的生命周期
    @Inherited : 标记注解，主要说明了一种继承性，意思是子类可以继承父类中的该注解
    @Documented ： 用于描述其它类型的annotation应该被作为被标注的程序成员的公共API,因此可以被例如javadoc此类的工具文档化
```
12. 说说你对依赖注入的理解
```
    控制反转是常用的面向对象编程的设计原则，使用这个原则我们可以降低耦合性。其中依赖注入是控制反转最常见的实现。
    依赖注入实现方式：
    1.构造方法注入
    2.setter方法注入
    3.接口注入

    Dagger是Android开发适合的依赖注入库，同样采用类注解的形式，不同的是在编译时生成辅助类，等到在运行时使用生成的辅助类完成依赖注入。
```
13. 说一下泛型原理，并举例说明
```
     Java泛型的内部原理：类型擦除
     Java中的泛型基本上都是在编译器这个层次来实现的。在生成的Java字节码中是不包含泛型中的类型信息的。使用泛型的时候加上的类型参数，会在编译器在编译的时候去掉。这个过程就称为类型擦除。

     在程序中定义了一个ArrayList泛型类型实例化为Integer的对象，如果直接调用add方法，那么只能存储整形的数据。不过当我们利用反射调用add方法的时候，却可以存储字符串。这说明了Integer泛型实例在编译之后被擦除了，只保留了原始类型。
        ArrayList<Integer> arrayList3=new ArrayList<Integer>();  
        arrayList3.add(1);//这样调用add方法只能存储整形，因为泛型类型的实例为Integer  
        arrayList3.getClass().getMethod("add", Object.class).invoke(arrayList3, "asd");  
        for (int i=0;i<arrayList3.size();i++) {  
            System.out.println(arrayList3.get(i));  
        }  
```
14. Java中String的了解
```
    特性：1.String是value不可改变的 2.String是不可被继承的，使用了final被修饰
    针对String ==的总结：
        1.new出来的对象是存放在堆内存，内存地址是唯一的
        2. 直接声明的字符串引用（String str1="abc";）是指向常量池的，而常量池中的相同内容的字符串只有一份
        3. 通过+号连接的字符串分如下两种情况：
            如果+号两边连接的是常量，那么会在编译期间进行优化，如同2，指向常量池
            如果+号两边连接的有变量，不管是new出来，还是直接声明的，java虚拟机执行的时候会生成一个StringBuilder对象sb,然后调用sb.append()的方法，
            通过sb.toString()返回一个新的字符串。注:toString方法 return new String(value,0,count);
```
15. String为什么要设计成不可变的？
```
    不可变对象：指一个对象被创建后就不再变化。不可变的意思：不能改变对象内的成员变量，包括基本数据类型的值不能改变，引用类型的变量不能指向其他对象，引用类型指向的对象的状态也不能改变。
    String的两个成员变量：
    private final char value[];（存放字符）
    private int hash;（String对象的哈希值）
    value是被private final修饰的，而且并没有提供set/get等公共方法来修改这些值，所以String类外部无法修改String，同时final保证了在String内部
    只要值初始化了，也不能被改变。
    在java中数组也是对象，value也仅仅是一个引用，指向真正的数组对象。
    不可变对象的好处：
        1.不可变独享更容易构造，测试与使用
        2.真正不可变对象都是线程安全的
        3.不可变对象的使用没有副作用（没有保护性拷贝）
        4.对象变化的问题得到了避免
        5.不可变对象的失败都是原子性的
        6.不可变对象更容易缓存，且可以避免null引用
        7.不可变对象可以避免时间上的耦合

    String，StringBuffer，StringBuilder，都是final类，不允许被继承，在本质上都是字符数组。
    不同的是：String的长度是不可变的而后两者长度可变，在进行连接操作时，String每次返回一个新的String实例。而StringBuffer和StringBuilder的append方法直接返回this，所以当进行大量的字符串连接操作时，不推荐使用String，因为它会产生大量的中间String对象。

    String 真的不可改变么
    答案是否定的（反射)，通过反射改变数组value中值
    String s = "ABCDEF";
    Field valueField = s.getClass().getDeclaredField("value");
    valueField.setAccessible(true);
    char[] value = (char[]) valueField.get(s);    
```
16. equals()深度解读
```
    1.equals()的所属以及内部原理
        它是超类Object中的一个基本方法，用于检测一个对象是否与另外一个对象相等。而在Object类中这个方法实际上是判断两个对象是否具有相同的引用，如果有，它们一定相等。
        public boolean equals(Object obj) {   return (this == obj);     }  "=="比较两个对象的内存地址，则Object的equals() 方法比较两个对象的内存地址是否相等

    2.equals()与==的区别
        默认情况下，从超类Object继承而来的equals方法与"=="是完全等价的,比较的都是对象内存地址，但我们可以重写equals方法，使其按照我们的需求的方式进行比较。如String类
        重写equals方法，使其比较的是字符的序列，而不再是内存地址。

    3.equals()的重写规则
        自反性：对于任何非null的引用值x,x.equals(x)应返回true
        对称性: 对于任何非null的引用值x与y,当且仅当y.equals(x)返回true时,x.equals(y)才返回true
        传递性: 对于任何非null的引用值x,y与z,如果y.equals(x)返回true,y.equals(z)返回true,那么x.equals(z)应返回true
        一致性: 对于任何非null的引用值x与y，假设对象上equals比较中的信息没有被修改，则多次调用x.equals(y)始终返回true或者始终返回false
        对于任何非空引用值x，x.equal(null)应返回false

    4.equals()重写规则之必要性深入解读
        举例:
        A a=new A();
        B b=new B();
        class A{
            @Override  
            public boolean equals(Object obj){
               return obj instanceOf A;
            }
        }

        class B extends A{
            @Override  
            public boolean equals(Object obj){
               return obj instanceOf B;
            }
        }

        List<A> list=new ArrayList<>();
        list.add(a);
        System.out.println("list.contains(a)->" + list.contains(a));  //true
        System.out.println("list.contains(b)->" + list.contains(b));  //false list.add(b);  
        list.clear(); 
        list.add(b);  
        System.out.println("list.contains(a)->" + list.contains(a));  //true
        System.out.println("list.contains(b)->" + list.contains(b)); //true

        需要修改B类的equals方法
        class B extends A{
            @Override  
            public boolean equals(Object obj){
                if(obj instanceOf B){
                    return true;
                }
               return super.equals(obj;
            }
        }
        由此例可以看出重写equals必须遵守几点原则的重要性。
    5.为什么重写equals()时必须重写hashCode()
        hash算法是利用数组寻下标访问速度高效的特点，将存储的元素和数组下标关联起来，来达到高查找效率的目标。
        Java API文档中关于hashCode方法有以下几点规定:
        1.在java应用程序执行期间，如果在equals方法比较中所用的信息没有被修改，那么在同一个对象上多次调用hashCode方法时必须一致地返回相同的整数。如果多次执行同一个应用时，不要求该整数必须相同。
        2.如果两个对象通过调用equals方法是相等的，那么这两个对象调用hashCode方法必须返回相同的整数
        3.如果两个对象通过调用equals方法是不相等的，不要求这两个对象调用hashCode方法必须返回不同的整数。

        在Object类中，hashCode方法是通过Object对象的地址计算出来的，因为Object对象只与自身相等，所以同一个对象的地址总是相等的，计算取得的哈希码也必然相等.
        对于不同的对象，由于地址不同，所获取的哈希码也不等，如果重写一个类的equals方法，但没有重写hashCode 方法，将会违反了第二条规定。


    6.重写equals()中使用instanceof与getClass()的区别
        https://blog.csdn.net/javazejian/article/details/51348320
        覆写 equals 时推荐使用 getClass 进行类型判断。而不是使用 instanceof（除非子类拥有统一的语义）

    7.编写一个完美的equals方法的几条建议
        1.显式参数命名为otherObject,稍后需要将它转换成另一个叫做other的变量
        2.检测this与otherObject是否引用同一个对象 ：if(this == otherObject) return true;（存储地址相同，肯定是同个对象，直接返回true）
        3.检测otherObject是否为null ，如果为null,返回false.if(otherObject == null) return false;
        4.比较this与otherObject是否属于同一个类
          如果equals的语义在每个子类中有所改变，就使用getClass检测 ：if(getClass()!=otherObject.getClass()) return false; 
          如果所有的子类都拥有统一的语义，就使用instanceof检测 ：if(!(otherObject instanceof ClassName)) return false;
        5.将otherObject转换为相应的类类型变量：ClassName other = (ClassName) otherObject;
        6.使用==比较基本类型域，使用equals比较对象域。如果所有的域都匹配，就返回true，否则就返回flase。
            如果在子类中重新定义equals，就要在其中包含调用super.equals(other)
            当此方法被重写时，通常有必要重写 hashCode 方法，以维护 hashCode 方法的常规协定，该协定声明 相等对象必须具有相等的哈希码 。
```

## 数据结构
1. 常用数据结构简介
```
    1.Collection接口
    LinkedList、ArrayList、Vector、Stack、Set
    2.Map 接口
    HashTable、HashMap、WeakHashMap

    Collection接口有两个子接口List和Set
    不论Collection的实际类型如何，都有一个iterator()的方法，该方法返回一个迭代子，使用这个迭代子可遍历每一个元素
    Iterator it=collection.iterator();
    while(it.hasNext()){
        Object obj=it.next();//得到下一个元素
    }

    List接口，使用该接口能够精确的控制每个元素插入位置，并且通过索引来访问List中的元素。
    实现List接口的常用类：LinkedList，ArrayList,Vector,Stack
    LinkedList类
    LinkedList实现了List接口，允许null元素。有额外的get,remove,insert方法在LinkedList的首部或尾部。这些操作使LinkedList可被用作堆栈，队列，双向队列
    注意：LinkedList没有同步方法，如果多个线程同时访问一个List，则必须自己实现访问同步。List list=Collections.synchronizedList(new LinkedList());

    ArrayList类
    ArrayList实现了可变大小的数组。它允许所有元素，包括null。ArrayList没有同步。size,isEmpty,get,set方法运行时间为常数。每个ArrayList实例都有一个容量（Capacity），即用于存储元素的数组的大小。当需要插入大量元素时，在插入前可以调用ensureCapacity方法来增加ArrayList的容量以提高插入效率。

    Vector类
    类似ArrayList,但是Vector是同步的。当一个Iterator被创建而且正在被使用，另一个线程改变了Vector的状态（例如，添加或删除了一些元素），这时调用Iterator的方法时将抛出ConcurrentModificationException，因此必须捕获该异常。

    Stack类
    Stack继承自Vector，实现一个后进先出的堆栈。Stack提供5个额外的方法使得Vector得以被当作堆栈使用。基本的push和pop方法，还有peek方法得到栈顶的元素，empty方法测试堆栈是否为空，search方法检测一个元素在堆栈中的位置。Stack刚创建后是空栈。

   Set接口
   Set是一种不包含重复的元素的Collection，即任意的两个元素e1和e2都有e1.equals(e2)=false,Set最多有一个null元
素

    Map接口
    Map没有继承Collection接口，Map提供key到value的映射。

    常用类：HashTable、HashMap、WeakHashMap
    Hashtable继承Map接口，实现一个key-value映射的哈希表。任何非空（non-null）的对象都可作为key或者value。
    Hashtable通过initial capacity和load factor两个参数调整性能。通常缺省的load factor 0.75较好地实现了时间和空间的均衡。增大load factor可以节省空间但相应的查找时间将增大，这会影响像get和put这样的操作。

    如果相同的对象有不同的hashCode，对哈希表的操作会出现意想不到的结果（期待的get方法返回null），要避免这种问题，只需要牢记一条：要同时复写equals方法和hashCode方法，而不要只写其中一个。Hashtable是同步的。

    HashMap和Hashtable类似，不同之处在于HashMap是非同步的，并且允许null，即null value和null key。
    WeakHashMap是一种改进的HashMap，它对key实行“弱引用”，如果一个key不再被外部所引用，那么该key可以被GC回收。

    总结：
    1.如果涉及到堆栈，队列等操作，应该考虑用List，对于需要快速插入，删除元素，应该使用LinkedList，如果需要快速随机访问元素，应该使用ArrayList。
    2.如果程序在单线程环境中，或者访问仅仅在一个线程中进行，考虑非同步的类，其效率较高，如果多个线程可能同时操作一个类，应该使用同步的类。
    3.要特别注意对哈希表的操作，作为key的对象要正确复写equals和hashCode方法。
    4.尽量返回接口而非实际的类型，如返回List而非ArrayList，这样如果以后需要将ArrayList换成LinkedList时，客户端代码不用改变。这就是针对抽象编程。
```
2. 同步集合和并发集合了解哪些？
```
    同步集合：
    HashTable
    Vector
    同步集合包装类，Collections.synchronizedMap()和Collections.synchronizedList() 

    并发集合类
    ConcurrentHashMap
    CopyOnWriteArrayList
    CopyOnWriteHashSet

    性能
    同步集合比并发集合会慢得多，主要原因是锁，同步集合会对整个May或List加锁

    并发集合的实现原理
    ConsurrentHashMap:把整个Map 划分成几个片段，只对相关的几个片段上锁，同时允许多线程访问其他未上锁的片段。
    CopyOnWriteArrayList:允许多个线程以非同步的方式读，当有线程写的时候它会将整个List复制一个副本给它。如果在读多写少这种对并发集合有利的条件下使用并发集合，这会比使用同步集合更具有可伸缩性。

    并发集合的使用建议：
    一般不需要多线程的情况，只用到HashMap、ArrayList，只要真正用到多线程的时候就一定要考虑同步。所以这时候才需要考虑同步集合或并发集合。

    ConcurrentHashMap实现原理
     ConcurrentHashMap是由Segment数组结构和HashEntry数组结构组成。Segment是一种可重入锁ReentrantLock，在ConcurrentHashMap里扮演锁的角色，HashEntry则用于存储键值对数据。一个ConcurrentHashMap里包含一个Segment数组，Segment的结构和HashMap类似，是一种数组和链表结构， 一个Segment里包含一个HashEntry数组，每个HashEntry是一个链表结构的元素， 每个Segment守护者一个HashEntry数组里的元素,当对HashEntry数组的数据进行修改时，必须首先获得它对应的Segment锁。

    什么是CopyOnWrite容器
    CopyOnWrite容器即写时复制的容器。通俗的理解是当我们往一个容器添加元素的时候，不直接往当前容器添加，而是先将当前容器进行Copy，复制出一个新的容器，然后新的容器里添加元素，添加完元素之后，再将原容器的引用指向新的容器。好处是我们可以对CopyOnWrite容器进行并发的读，而不需要加锁，因为当前容器不会添加任何元素。所以CopyOnWrite容器也是一种读写分离的思想，读和写不同的容器。

    CopyOnWrite缺点：
    内存占用大
    数据一致性
    只能保证数据的最终一致性，不能保证数据的实时一致性
```
345. 列举java的集合以及集合之间的继承关系==集合类以及集合框架
```
    [!集合](https://icefire.me/collection.gif)

    总结：
    1.Java集合框架主要包括Collection和Map两种类型。其中Collection又有3种子类型，分别是List、Set、Queue。Map中存储的主要是键值对映射。
    2.规则集Set中存储的是不重复的元素，线性表中存储可以包括重复的元素，Queue队列描述的是先进先出的数据结构，可以用LinkedList来实现队列。
    3.效率上，规则集比线性表更高效。
    4.ArrayList主要是用数组来存储元素，LinkedList主要是用链表来存储元素，HashMap的底层实现主要是借助数组+链表+红黑树来实现。
    5.Vector、HashTable等集合类效率比较低但都是线程安全的。包java.util.concurrent下包含了大量线程安全的集合类，效率上有较大提升。
```
6. List,Set,Map的区别
```
    Set是最简单的一种集合方式，不按特定顺序排序，并且没有重复对象
    List的特征是其元素以线性方式存储，集合中可以存放重复对象
    Map 是一种把键对象和值对象映射的集合，它的每一个元素都包含一对键对象和值对象


    List实现	    使用场景	                                    数据结构
    ArrayList	数组形式访问List链式集合数据，元素可重复，访问元素较快	数组
    LinkedList	链表方式的List链式集合，元素可重复，元素的插入删除较快	双向链表

    Set实现	    使用场景	                                    数据结构
    HashSet	    无序的、无重复的数据集合	                       基于HashMap
    LinkedSet	维护次序的HashSet	                            基于LinkedHashMap
    TreeSet	    保持元素大小次序的集合，元素需要实现Comparable接口	  基于TreeMap

    Map实现	        使用场景	                                数据结构
    HashMap	        哈希表存储键值对，key不重复，无序	              哈希散列表
    LinkedHashMap	是一个可以记录插入顺序和访问顺序的HashMap	     存储方式是哈希散列表，但是维护了头尾指针用来记录顺序
    TreeMap	        具有元素排序功能	红黑树
    WeakHashMap	    弱键映射，映射之外无引用的键，可以被垃圾回收	     哈希散列表

```
7. List和Map，Set的实现方式以及存储方式
```
    List 的实现方式：ArrayList和LinkedList
    ArrayList的存储方式：数组，查询快
    LinkedList的存储方式：链表，插入，删除快

    Map的实现方式：HashMap和TreeMap
    HashMap 的存储方式：哈希码算法，快速查找键值
    TreeMap存储方法：对键按序存放

    Set的实现方式：HashSet和TreeSet
    HashSet的存储方式：哈希码算法，加入的对象要实现hashcode()方法，快速查找元素
    TreeSet的存储方式：按序存放，想要有序就要实现Comparable接口
```
8. HashMap的实现原理
```
    HashMap实际上是一个“链表散列”的数据结构，即数组和链表的结合体。HashMap底层是一个数组结构，数组中每一项又是一个链表。
    简单说：HashMap在底层将key-value当成一个整体进行处理，这个整体就是一个Entry对象。HashMap底层采用一个Entry[]数组来保存所有的
    key-value对，当需要存储宇哥Entry对象时，会根据hash算法来决定其在数组中的存储位置，在根据equals方法决定其在数组中的存储位置，根据equals方法决定其在该数组位置上的链表中的存储位置，当需要取出一个Entry时，也会根据hash算法找到其在数组中的存储位置，再根据equals方法从该位置上的链表中取出该Entry。

    HashMap扩容：
    当HashMap元素中的元素越来越多的时候，hash冲突概率增大。数组扩容，最消耗性能的地方：原数组中的数据必须重新计算其在数组中的位置，并放进去，这就是resize。
    当HashMap中的元素超过（数组大小(16)*loadFactor(0.75)）时，数组大小扩展一倍。然后重新计算每个元素在数组中的位置。

    Fail-Fast机制
    HashMap 不是线程安全的，因此如果在使用迭代器的过程中有其他线程修改了 map，那么将抛出 ConcurrentModificationException，这就是所谓 fail-fast 策略。
    迭代器的快速失败行为应该仅用于检测程序错误。

    Map的遍历方式：
    方式一：for-each循环中使用entries来遍历
    Map<Integer,Integer> map=new HashMap<Integer,Integer>();
    for(Map.Entry<Integer,Integer> entry:map.entrySet()){
         System.out.println("key = "+entry.getKey()+", Value = "+entry.getValue());   
    }
    注：for-each循环在java5以上使用。map必须非空，否则抛出空指针异常。

    方式二：在for-each循环中遍历keys或values
    Map<Integer,Integer> map=new HashMap<Integer,Integer>();
    for(Integer key:map.keySet()){
        System.out.println("Key = "+key);
    } 

    for(Integer value:map.values()){
        System.out.println("Value = "+value);
    } 

    方式三：使用Iterator遍历
    Map<Integer,Integer> map=new HashMap<Integer,Integer>();
    Iterator<Map.Entry<Integer,Integer>> entries=map.entrySet().iterator();
    while(entries.hasNext()){
        Map.Entry<Integer,Integer> entry=entries.next();
        System.out.println("Key = "+entry.getKey()+", Value = "+entry.getValue());
    }

    方法四：通过键找值（效率低）
    Map<Integer,Integer> map=new HashMap<Integer,Integer>();
    for(Integer key:map.keySet()){
        Integer value=map.get(key);
        System.out.println("Key = "+key+", Value ="+value);
    }

    总结：仅需要键或值使用方法二。使用低于java5，或是打算遍历删除entries，必须使用方法三。否则使用方法一（键值都要）
```
9. HashMap数据结构、HashMap源码理解、HashMap如何put数据（从HashMap源码角度讲解）？
```
    HashMap数据结构----哈希散列表

    HashMap基本原理
    1.首先判断Key是否为Null，如果为null，直接查找Entry[0],如果不是null，先计算Key的HashCode，然后经过二次Hash，得到Hash值，这里的Hash的特征值是一个int值。
    2.根据Hash值，要找到对应的数组，所以对Entry[]的长度length求余，得到的就是Entry数组的index。
    3.找到对应的数组，就找到了所在的链表，然后按照链表的操作对Value进行插入，删除，查询操作。

    HashMap概念介绍
    size                大小       HashMap的存储大小
    threshold           临界值     HashMap大小达到临界值，需要重新分配大小
    loadFactor          负载因子    HashMap大小负载因子，默认为0.75
    modCount            统一修改    HashMap被修改或者删除的次数总数
    Entry               实体       HashMap存储对象的实际实体，由Key,value,hash,next组成

    HashMap初始化：
    初始化的时候需要知道初始化的容量大小，因为在后面要通过按位与的Hash算法计算Entry数组的索引，那么要求Entry的数组长度是2的N次方。

    HashMap中Hash计算和碰撞问题：
    HashMap中的hash计算时，先计算hashCode(),然后进行二次hash。
    int hash=hash(key.hashCode());//计算二次hash
    int i=indexFor(hash,table.length);//通过hash找数组索引

    public int hashCode(){
        int h=hash;
        if(h==0&&value.length>0){
            char val[]=value;
            for(int i=0;i<value.length;i++>){
                h=31*h+val[i];
            }
            hash=h;
        }
        return h;
    }

    HashMap的put()解析
    public V put(K key,V value){
        if(key==null){
            return putForNullKey(value);
        }
        int hash=hash(key.hashCode());
        int i=indexFor(hash,table.length);
        for(Entry<K,V> e=table[i];e!=null;e=e.next){
            Object k;
            if(e.hash==hash&&((k=e.key)==key || key.equals(k))){
                V oldVaule=e.value;
                e.value=value;
                e.recordAccess(this);
                return oldValue;
            }
        }
        modCount++;
        addEntry(hash,key,value,i);
        return null;
    }

    步骤：
    1.首先判断key是否为null,如果是null，就单独调用putForNullKey(value)处理。
    private V putForNullKey(V value) {
        for (Entry<K,V> e = table[0]; e != null; e = e.next) {
            if (e.key == null) {
                V oldValue = e.value;
                e.value = value;
                e.recordAccess(this);
                return oldValue;
            }
        }
        modCount++;
        addEntry(0, null, value, 0);
        return null;
    }
    如果key为null的值，默认就存储到table[0]开头的链表了。然后遍历table[0]的链表的每个节点Entry，如果发现其中存在节点Entry的key为null，
    就替换新的value，然后返回旧的value，如果没发现key等于null的节点Entry，就增加新的节点。
    2.计算key的hashcode，再用计算的结果二次hash，通过indexFor(hash, table.length);找到Entry数组的索引i。
    3.然后遍历以table[i]为头节点的链表，如果发现有节点的hash，key都相同的节点时，就替换为新的value，然后返回旧的value。
    4.HashMap不是线程安全的，但在某些容错能力较好的应用中，如果你不想仅仅因为1%的可能性而去承受hashTable的同步开销,HashMap使用了Fail-Fast机制来处理这个问题
    volatile关键字声明了modCount，代表了多线程环境下访问modCount，根据JVM规范，只要modCount改变了，其他线程将读到最新的值
    其实在Hashmap中modCount只是在迭代的时候起到关键作用.使用Iterator开始迭代时，会将modCount的赋值给expectedModCount，在迭代过程中，
    通过每次比较两者是否相等来判断HashMap是否在内部或被其它线程修改，如果modCount和expectedModCount值不一样，证明有其他线程在修改HashMap的结构，
    会抛出异常。HashMap的put、remove等操作都有modCount++的计算。

    5.如果没有找到key的hash相同的节点，就增加新的节点addEntry()
    void addEntry(int hash, K key, V value, int bucketIndex) {
    Entry<K,V> e = table[bucketIndex];
        table[bucketIndex] = new Entry<K,V>(hash, key, value, e);
        if (size++ >= threshold)
            resize(2 * table.length);
    }
    增加节点的时候取巧了，每个新添加的节点都增加到头节点，然后新的头节点的next指向旧的老节点。

    6. 如果HashMap大小超过临界值，就要重新设置大小，扩容。

    HashMap的get()解析：
    public V get(Object key) {
        if (key == null)
            return getForNullKey();
        int hash = hash(key.hashCode());
        for (Entry<K,V> e = table[indexFor(hash, table.length)];
             e != null;
             e = e.next) {
            Object k;
            if (e.hash == hash && ((k = e.key) == key || key.equals(k)))
                return e.value;
        }
        return null;
    }
    HashMap是非线程安全的,当你查找一个key的hash存在的时候，进入了循环，恰恰这个时候，另外一个线程将这个Entry删除了，那么你就一直因为找不到Entry而出现死循环。

    HashMap的size()解析：
    HashMap的大小很简单，不是实时计算的，而是每次新增加Entry的时候，size就递增。删除的时候就递减。空间换时间的做法。因为它不是线程安全的。完全可以这么做。效力高。

    HashMap的reSize()解析：
    当HashMap的大小超过临界值的时候，就需要扩充HashMap的容量了/
    void resize(int newCapacity) {
        Entry[] oldTable = table;
        int oldCapacity = oldTable.length;
        if (oldCapacity == MAXIMUM_CAPACITY) {
            threshold = Integer.MAX_VALUE;
            return;
        }

        Entry[] newTable = new Entry[newCapacity];
        transfer(newTable);
        table = newTable;
        threshold = (int)(newCapacity * loadFactor);
    }

    从代码可以看出，如果大小超过最大容量就返回。否则就new一个新的Entry数组，长度为旧的Entry数组长度两倍，然后将旧的Entry[]复制到新的Entry[].
    void transfer(Entry[] newTable) {
        Entry[] src = table;
        int newCapacity = newTable.length;
        for (int j = 0; j < src.length; j++) {
            Entry<K,V> e = src[j];
            if (e != null) {
                src[j] = null;
                do {
                    Entry<K,V> next = e.next;
                    int i = indexFor(e.hash, newCapacity);
                    e.next = newTable[i];
                    newTable[i] = e;
                    e = next;
                } while (e != null);
            }
        }
    }
    在复制的时候数组的索引int i = indexFor(e.hash, newCapacity);重新参与计算

```
13. ConcurrentHashMap的实现原理
```
    JDK1.7分析：
    ConcurrentHashMap采用 分段锁的机制，实现并发的更新操作，底层采用数组+链表的存储结构。
    包含两个核心静态内部类Segment和HashEntry
    1.Segment继承ReentrantLock来充当锁的角色，每个Segment对象守护每个散列映射表的若干个桶。
    2.HashEntry用来封装映射表的键/值对
    3.每个桶是由若干个HashEntry对象链接起来的链表
    一个 ConcurrentHashMap 实例中包含由若干个 Segment 对象组成的数组

    JDK1.8分析：
    1.8的实现已经抛弃了Segment分段锁机制，利用CAS+Synchronized来保证并发更新的安全，底层采用数组+链表+红黑树的存储结构
    重要概念：
    table:默认为null，初始化发生在第一次插入操作，默认大小为16的数组，用来存储Node节点数据，扩容时大小总是2的幂次方
    nextTable:默认为null，扩容时新生成的数组，其大小为原数组的两倍
    sizeCtl:默认为0，用来控制table的初始化和扩容操作，具体应用在后续会体现出来
    **-1 **代表table正在初始化
    **-N **表示有N-1个线程正在进行扩容操作
    如果table未初始化，表示table需要初始化的大小
    如果table初始化完成，表示table的容量，默认是table大小的0.75倍，居然用这个公式算0.75

    Node:保存key，value及key的hash值的数据结构
    class Node<K,V> implements Map.Entry<K,V> {
    final int hash;
    final K key;
    volatile V val;
    volatile Node<K,V> next;
    ... 省略部分代码
    }
    ForwardingNode:一个特殊的Node节点，hash值为-1，其中存储nextTable的引用

    table初始化
    table初始化操作会延缓到第一次put行为，但是put是可以并发执行的
    sizeCtl默认为0，如果ConcurrentHashMap实例化时有传参数，sizeCtl会是一个2的幂次方的值。所以执行第一次put操作的线程会执行Unsafe.compareAndSwapInt方法修改sizeCtl为-1，有且只有一个线程能够修改成功，其它线程通过Thread.yield()让出CPU时间片等待table初始化完成

    put操作
    假设table初始化完成，put操作采用CAS+synchronized实现并发插入或更新操作
    final V putVal(K key, V value, boolean onlyIfAbsent) {
    if (key == null || value == null) throw new NullPointerException();
    int hash = spread(key.hashCode());
    int binCount = 0;
    for (Node<K,V>[] tab = table;;) {
        Node<K,V> f; int n, i, fh;
        if (tab == null || (n = tab.length) == 0)
            tab = initTable();
        else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
            if (casTabAt(tab, i, null, new Node<K,V>(hash, key, value, null)))
                break;                   // no lock when adding to empty bin
        }
        else if ((fh = f.hash) == MOVED)
            tab = helpTransfer(tab, f);
        ...省略部分代码
    }
    addCount(1L, binCount);
    return null;
    }
    1.hash算法
    static final int spread(int h) {return (h ^ (h >>> 16)) & HASH_BITS;}
    2.table中定位索引位置，n是table的大小
    int index = (n - 1) & hash
    3.获取table中对应索引的元素f
    在java内存模型中，我们已经知道每个线程都有一个工作内存，里面存储着table的副本，虽然table是volatile修饰的，但不能保证线程每次都拿到table中的最新元素，Unsafe.getObjectVolatile可以直接获取指定内存的数据，保证了每次拿到数据都是最新的
    4.如果f为null，说明table中这个位置第一次插入元素，利用Unsafe.compareAndSwapObject方法插入Node节点
    如果CAS成功，说明Node节点已经插入，随后addCount(1L, binCount)方法会检查当前容量是否需要进行扩容
    如果CAS失败，说明有其它线程提前插入了节点，自旋重新尝试在这个位置插入节点
    5.如果f的hash值为-1，说明当前f是ForwardingNode节点，意味有其它线程正在扩容，则一起进行扩容操作
    6.其余情况把新的Node节点按链表或红黑树的方式插入到合适的位置，这个过程采用同步内置锁实现并发
    在节点f上进行同步，节点插入之前，再次利用tabAt(tab, i) == f判断，防止被其它线程修改
    1.如果f.hash >= 0，说明f是链表结构的头结点，遍历链表，如果找到对应的node节点，则修改value，否则在链表尾部加入节点
    2.如果f是TreeBin类型节点，说明f是红黑树根节点，则在树结构上遍历元素，更新或增加节点
    3.如果链表中节点数binCount >= TREEIFY_THRESHOLD(默认是8)，则把链表转化为红黑树结构

    总结：
    ConcurrentHashMap是一个并发散列映射表的实现，它允许完全并发的读取，并且支持给定数量的并发更新。相比于HashTable和同步
    包装的HashMap，使用一个全局的锁来同步不同线程间的并发访问，同一时间点，只能有一个线程持有锁，也就是说在同一时间点，只能有一个线程
    能访问容器，者虽然保证多线程间的安全并发访问，但同时也导致对容器的访问变成串行化的。
    1.6中的ReentrantLock分段锁的方式，使索格线程在不同的segment上进行写操作不会发现阻塞行文，1.8中直接采用了内置锁synchronized。
```
14. ArrayMap和HashMap、SparseArray的对比
```
    HashMap略
    ArrayMap分析：
    Object[] mArray;//存储key和value
    int[] mHashes;//存储key的hashcode

```
15. HashTable实现原理,HashSet的实现原理
```
    HashTable的数据结构采用table数组+链表的方式来实现
    HashTable初始化容量为11,负载因子0.75，初始阈值为8，table的大小总是2的幂次方
    Hashtable的put方法的实现：
    与HashMap实现步骤上没有区别，只是在put方法上增加synchronized关键字，保证线程安全。
    put实现步骤及思路：
        - 禁止null value插入
        - 根据key的hashCode值与0x7FFFFFFFF求与后得到新的hash值，然后计算其在table中的索引下标
        - 在索引下标下遍历链表，查找key是否已存在，存在则更新value值
        - 如果不存在，判断table.count是否超过阈值，超过则更新rehash，将原元素全部拷贝到新的table中，并重新计算索引下标。rehash后，容量是以前的2倍+1的大小
            这点和HashMap不同，HashMap是2倍。
        - 插入元素时直接插入在链表头部
        - 更新元素计数器

    保证线程安全：
    HashTable对外提供的public方法，几乎全部加上了synchronized关键字，因而性能上非常低效，ConcurrentHashMap用来替代HashTable

    HashSet的实现原理：
    1.基于HashMap实现的，默认初始容量为16,负载因子为0.75的HashMap。封装了一个HashMap对象来存储所有的集合元素，所有放入HashSet中的集合元素实际上
    由HashMap的key来保存，而HashMap的value则存储了一个PRESENT,他是一个静态的Object对象。
    2.当我们试图把某个类的对象当成HashMap的key，或试图将这个类的对象放入HashSet中保存时，重写该类的equals方法和hashCode方法很重要，而且这两个方法的返回值保持一致。该类的两个hashCode返回值相融，它们通过equals方法比较。通常所有参与计算hashCode返回值的关键属性，都应该用于作为equals比较的标准。
    3.HashSet的其它操作都属于HashMap的
```
16. TreeMap具体实现
```
    TreeMap是一个通过红黑树实现有序的key-value集合
    TreeMap集成AbstractMap,也即实现了Map,它是一个Map集合
    TreeMap实现了NavigableMap接口,它支持一系列的导航方法
    TreeMap实现了Cloneable接口,他可以被克隆
    TreeMap基于红黑树（Red-Black tree）实现。映射根据其键的自然顺序进行排序，或者根据创建映射时提供的 Comparator 进行排序，具体取决于使用的构造方法
    TreeMap的本质是Red-Black Tree,它包含几个重要的成员变量，root,size,comparator。其中root是红黑树的根节点。它是Entry类型，Entry是红黑树的节点，它包含
    了红黑树的6个基本组成部分：key,value,left,right,parent和color。 Entry节点根据key排序，包含的内容是value。Entry中key比较大小是根据比较器comparator
    来进行判断的。size是红黑树的节点个数。

```
17. HashMap和HashTable的区别
```
    HashMap和Hashtable都实现了Map接口，主要的区别有：线程安全性，同步(synchronization)，以及速度
    1.HashMap几乎可以等价于Hashtable，除了HashMap是非synchronized的，可以接受null(HashMap的键和值，而HashTable不可以)
    2.HashMap是非synchronized，而Hashtable是synchronized，Hashtable是线程安全的，多个线程可以共享一个Hashtable；而如果没有正确的同步的话，多个线程是不能共享HashMap的，Java 5提供了ConcurrentHashMap，它是HashTable的替代，比HashTable的扩展性更好
    3.HashMap的迭代器(Iterator)是fail-fast迭代器，而Hashtable的enumerator迭代器不是fail-fast的
    4.由于Hashtable是线程安全的也是synchronized，所以在单线程环境下它比HashMap要慢
    5.HashMap不能保证随着时间的推移Map中的元素次序是不变的
```
18. HashMap与HashSet的区别
```
    1.HashMap实现了Map接口，而HashSet实现了Set接口
    2.HashMap储存键值对,而HashSet仅仅存储对象
    3.HashMap食欲哦那个put方法将元素放入map中，而HashSet使用add方法将元素放入set中
    4.HashMap中使用键对象来计算hashcode值，HashSet使用成员对象来计算hashcode值，对于两个对象来说hashcode可能相同，所以equals方法用来判断对象的相等性，如果两个
      对象不同的话，那么返回false
    5.HashMap比较快，因为使用唯一的键来获取对象
```
19. HashSet与HashMap怎么判断集合元素重复？
```
    HashSet不能添加重复的元素，当调用add方法时候，首先会调用Object的hashCode方法判断hashCode是否已经存在，如不存在则直接插入元素
    如果存在，则调用Object对象的equals方法判断是否返回true，如果为true则说明元素已经存在，如为false则插入元素
    HashSet是借助HashMap来实现的，利用HashMap中key的唯一性，来保证HashSet中不出现重复值。key为对象Object,value为常量

    HashMap中的Key是根据对象的hashCode() 和 euqals()来判断是否唯一的
```
20. 集合Set实现Hash怎么防止碰撞
```
    HashSet不能添加重复的元素，当调用add方法时候，首先会调用Object的hashCode方法判断hashCode是否已经存在，如不存在则直接插入元素
    如果存在，则调用Object对象的equals方法判断是否返回true，如果为true则说明元素已经存在，如为false则插入元素
    HashSet是借助HashMap来实现的，利用HashMap中key的唯一性，来保证HashSet中不出现重复值。key为对象Object,value为常量
```
21. ArrayList和LinkedList的区别，以及应用场景
```
    ArrayList是实现了基于动态数组的数据结构，LinkedList基于链表的数据结构
    对于随机访问get和set，ArrayList觉得由于LinkedList，因为LinkedList要移动指针
    对于新增和删除操作add和remove，LinkedList比较占优势，因为ArrayList要移动数据

    ArrayList内部是使用可増长数组实现的，所以是用get和set方法是花费常数时间的，但是如果插入元素和删除元素，除非插入和删除的位置都在表末尾，
    否则代码开销会很大，因为里面需要数组的移动。
    LinkedList是使用双链表实现的，所以get会非常消耗资源，除非位置离头部很近。但是插入和删除元素花费常数时间。
    ArrayList更适合读取数据，linkedList更多的时候添加或删除数据
```
22. 数组和链表的区别
```
    数组和链表是两种基本的数据结构，他们在内存存储上的表现不一样，所以各有特点。
    数组的特点：
    - 在内存中，数组是一块连续的区域
    - 数组需要预留空间，在使用前要先申请占内存的大小，可能会浪费内存空间
    - 插入数据和删除数据效率低，插入数据时，这个位置后面的数据在内存中都要向后移。删除数据时，这个数据后面的数据都要向前移动。
    - 随机读取效率高，因为数组是连续的，知道每一个数据的内存地址，可以直接找到给定地址的数据
    - 不利于扩展，数组定义的空间不够时要重新定义数组

    链表的特点：
    - 在内存中可以存在任何地方，不要求连续。
    - 每一个数据都保存了下一个数据的内存地址，通过这个地址找到下一个数据。
    - 增加数据和删除数据很容易。
    - 查找数据时效率低，因为不具有随机访问性，所以访问某个位置的数据都要从第一个数据开始访问，然后根据第一个数据保存的下一个数据的地址找到第二个数据。
    - 不指定大小，扩展方便。链表大小不用定义，数据随意增删。

    数组的优点：
    随机访问性强；查找速度快
    数组的缺点：
    插入和删除效率低；可能浪费内存；内存空间要求高，必须有足够的连续内存空间；数组大小固定，不能动态扩展

    链表的优点：
    插入删除速度快；内存利用率高，不会浪费内存；大小没有固定，扩展很灵活
    链表的缺点：
    不能随机查找，必须从第一个开始遍历，查找效率低

```
23. 二叉树的深度优先遍历和广度优先遍历的具体实现
```
    深度优先遍历：
    - 先序遍历：对任一子树，先访问根，然后遍历其左子树，最后遍历其右子树
    - 中序遍历：对任一子树，先遍历其左子树，然后访问根，最后遍历右子树
    - 后序遍历：对任一子树，先遍历左子树，然后遍历其右子树，最后访问根

    广序遍历：
    从上往下对每一层依次访问，在每一层中从左到右访问结点，访问完一层进入下一层，直到没有结点可以访问为止
```
24. 堆的结构
```

    堆具有以下性质：
    - 任意节点小于（或大于）它的所有后裔，最小元（或最大元）在堆的根上（堆序性）
    - 堆总是一棵完全树。即除了最底层，其他层的节点都被元素填满，且最底层尽可能地从左到右填入/将根节点最大的堆叫最大堆或大根堆，根节点最小的堆叫做最小堆。

    堆的主要应用场景：堆排序及优先队列
```
25. 堆和树的区别
```
    二叉排序树：每个结点的值均大于其左子树上所有结点的值，小于其右子树上所有结点的值，对二叉排序树进行中序遍历得到一个有序序列，所以二叉排序树是
    结点之间满足一定次序关系的二叉树
    堆是一个完全二叉树，并且每个结点的值都大于或等于其左右孩子结点的值，所以堆是结点之间满足一定次序关系的完全二叉树。
    具有n个结点的二叉排序树，其深度取决与给定集合的初始排列顺序，最好情况其深度为logn，最坏情况其深度为n
    具有n个结点的堆，其深度即为堆所对应的完全二叉树的深度logn

    二叉排序树是为了实现动态查找而设计的数据结构，它是面向查找操作，在二叉排序树中查找一个结点的平均时间复杂度O(logn)
    堆是为了实现排序而设计的一种数据结构，它不是面向查找操作，因而在堆中查找一个结点需要进行遍历，其平均时间复杂度O(n)
```
26. 堆和栈在内存中的区别是什么(解答提示：可以从数据结构方面以及实际实现方面两个方面去回答)？
```
    申请方式：
    栈：由系统自动分配
    堆：需要程序员自己申请，并指明大小

    申请后的响应：
    栈：只要栈的剩余空间大于所申请的空间，系统将为程序提供内存，否则将报异常提示栈溢出
    堆：操作系统有一个记录空闲内存地址的链表，当系统收到程序的申请时，会遍历该链表，寻找第一个空间大于所申请空间的堆结点，然后将该结点从空闲结点链表中删除，
    并将该结点的空间分配给程序，另外，对于大多数系统，会在这块内存空间中的首地址处记录本次分配的大小，这样，代码中的delete语句才能正确的释放本内存空间

    申请大小限制：
    栈：在Windows下，栈是向低地址扩展的数据结构，是一块连续的内存的区域。即：栈顶的地址和栈的最大容量是系统预先规定好的，在win下，栈的大小是2M，如果申请的
        空间超过栈的剩余空间时，将提示overflow。因此能从栈获得的空间较小

    堆：堆是向高地址扩展的数据结构，是不连续的内存区域。由于系统是用链表来存储空闲的内存地址，自然是不连续的，而链表遍历方向是由低地址向高地址。堆的大小受限于
    计算机系统中有效的虚拟内存。由此可见，堆获得的空间比较灵活    

    申请效率：
    栈:由系统自动分配，速度较快
    堆:由new分配的内存，一般速度比较慢，而且容易产生内存碎片，不过用起来方便

    存储内容：
    栈：第一个进栈主函数中的下一条指令的地址，然后是函数的各个参数，函数中的局部变量
    堆：一般在堆的头部用一个字节存放堆的大小。
```
27. 什么是深拷贝和浅拷贝
```
    浅拷贝：使用一个已知实例对新创建实例的成员变量逐个赋值，这个方式被称为浅拷贝
    深拷贝：当一个类的拷贝构造方法，不仅要复制对象的所有非引用成员变量值，还要为引用类型的成员变量创建新的实例，并且初始化为形式参数实例值。

    浅拷贝只复制一个对象，传递引用，不能复制实例。而深拷贝对对象内部的引用均复制，他是创建一个新的实例，并且复制实例。
```
28. 手写链表逆序代码
```
/**
 * java 实现单链表的逆序
 * @author Administrator
 *
 */
public class SingleLinkedReverse {
	
	class Node{
		int data;
		Node next;
		
		public Node(int data){
			this.data = data;
		} 
	}
 
	public static void main(String[] args) {
		SingleLinkedReverse slr = new SingleLinkedReverse();
		Node head, tail;
		head = tail = slr.new Node(0);
		for(int i=1; i<10; i++){
			Node p = slr.new Node(i);
			tail.next = p;
			tail = p;
		}
		tail = head;
		while(tail != null){
			System.out.print(tail.data+"  ");
			tail = tail.next;
		}
		
		head = reverse(head);
		
		System.out.println(" ");
		while(head != null){
			System.out.print(head.data+"  ");
			head = head.next;
		}
	}

	private static Node reverse(Node head) {
		Node p1,p2 = null;
		p1 = head;
		
		while(head.next != null){
			p2 = head.next;
			head.next = p2.next;
			p2.next = p1;
			p1 = p2;
		}
		return p2;
	}
}
```
31. 判断单链表成环与否？
```
public class LinkedLoop {
	//内部静态类定义结点类
	static class Node{
		int val;
		Node next;
		public Node(int val){
			this.val = val;
		}
	}
	//判断单链表是否有环的方法
	public static boolean hasLoop(Node head){
		Node p1 = head;    //定义一个引用指向头结点
		Node p2 = head.next;    //定义另一个引用指向头结点的下一个结点
		
		/**
		 * 因为引用p2要比p1走的快，所以要用它作为循环的结束标志，为了防止当链表中个数为
		 * 偶数时出现p2.next=null空指针异常，这时可以在循环中进行一下判断，如果这种情况
		 * 出现一定是无环的。
		 */
		while(p2 != null && p2.next != null){  
			p1 = p1.next;
			p2 = p2.next.next;
			if(p2 == null)
				return false;
			//为了防止p2.val出现空指针异常，需要对p2进行判断
			int val1 = p1.val;
			int val2 = p2.val;
			if(val1 == val2)
				return true;
		}
		return false;
	}
	public static void main(String[] args) {
		Node n1 = new Node(1);
		Node n2 = new Node(3);
		Node n3 = new Node(6);
		Node n4 = new Node(4);
		Node n5 = new Node(5);
		Node n6 = new Node(10);
		n1.next = n2;
		n2.next = n3;
		n3.next = n4;
		n4.next = n5;
		n5.next = n6;
		n6.next = n5;
		System.out.println(hasLoop(n1));
	}
}
```
32. 链表翻转（即：翻转一个单项链表）
```
    单链表的结构：
    class Node {
	private int Data;// 数据域
	private Node Next;// 指针域
	public Node(int Data) {
		// super();
		this.Data = Data;
	}
	public int getData() {
		return Data;
	}
	public void setData(int Data) {
		this.Data = Data;
	}

	public Node getNext() {
		return Next;
	}
	public void setNext(Node Next) {
		this.Next = Next;
	}
}

翻转方法：
    1.递归法
    在反转当前节点之前先反转后续节点。这样从头结点开始，层层深入直到尾结点才开始反转指针域的指向。简单的说就是从尾结点开始，逆向反转各个结点的指针域指向，其过程图如下所示：
    head：是前一结点的指针域（PS：前一结点的指针域指向当前结点）
    head.getNext()：是当前结点的指针域（PS：当前结点的指针域指向下一结点）
    reHead：是反转后新链表的头结点（即原来单链表的尾结点）

    public static Node Reverse1(Node head) {  
        // head看作是前一结点，head.getNext()是当前结点，reHead是反转后新链表的头结点  
        if (head == null || head.getNext() == null) {  
            return head;// 若为空链或者当前结点在尾结点，则直接还回  
        }  
        Node reHead = Reverse1(head.getNext());// 先反转后续节点head.getNext()  
        head.getNext().setNext(head);// 将当前结点的指针域指向前一结点  
        head.setNext(null);// 前一结点的指针域令为null;  
        return reHead;// 反转后新链表的头结点  
    }  

    2.遍历反转法
    递归反转法是从后往前逆序反转指针域的指向，而遍历反转法是从前往后反转各个结点的指针域的指向。
    基本思路是：将当前节点cur的下一个节点 cur.getNext()缓存到temp后，然后更改当前节点指针指向上一结点pre。也就是说在反转当前结点指针指向前，先把当前结点的指针域用tmp临时保存，以便下一次使用，其过程可表示如下：
    pre：上一结点
    cur: 当前结点
    tmp: 临时结点，用于保存当前结点的指针域（即下一结点）

    public static Node reverse2(Node head) {  
        if (head == null)  
            return head;  
        Node pre = head;// 上一结点  
        Node cur = head.getNext();// 当前结点  
        Node tmp;// 临时结点，用于保存当前结点的指针域（即下一结点）  
        while (cur != null) {// 当前结点为null，说明位于尾结点  
            tmp = cur.getNext();  
            cur.setNext(pre);// 反转指针域的指向  
  
            // 指针往下移动  
            pre = cur;  
            cur = tmp;  
        }  
        // 最后将原链表的头节点的指针域置为null，还回新链表的头结点，即原链表的尾结点  
        head.setNext(null);  
          
        return pre;  
    }  
```
33. 合并多个单有序链表（假设都是递增的）
```
    思路：使用递归
    步骤：
    1.判断L1,L2是否为空
    2.创建一个头指针
    3.判断当前L1，L2指向的结点值的大小，根据结果，让头指针指向小结点，并让这个结点往下走一步，作为递归函数调用的参数放入，返回的就是新
    的两个值的比较结果，则新的比较结果放入头节点的下一个结点
    4.返回头结点

    struct ListNode* mergeTwoLists(struct ListNode *l1,struct ListNode *l2){
            struct ListNode *head=NULL;
            if(l1==NULL){
                return l2;
            }
            if(l2==NULL){
                return l1;
            }
            if(l1->val <= l2->val){
                 head=l1;
                 head->next=mergeTwoLists(l1->next,l2);   
            }else{
                head=l2;
                head->next=mergeTwoLists(l1,l2->next);
            }
            return head;
    }
```

## 线程、多线程和线程池

1. Java开启线程的三种方式？
```
    1.继承Thread类创建线程类
        - 定义Thread类创建线程类，重写run方法
        - 创建Thread子类的实例，即创建了线程对象
        - 调用线程对象的start()方法来启动该线程

    2.实现Runnable接口创建线程类
        - 定义runnable接口实现类，并重写run方法
        - 创建runnable实现类实例，并将该实例作为Thread的target来创建Thread对象，该对象才是真正的线程对象
        - 调用线程对象的start()方法启动该线程  

    3.通过Callable和Future创建线程
        - 创建Callable接口的实现类，并实现call()方法，该call()方法将作为线程执行体，并且有返回值
        - 创建Callable实现类的实例，使用FutureTask类来包装Callable对象，该FutureTask对象封装了该Callable对象的call()方法的返回值
        - 使用FutureTask对象作为Thread对象的target创建并启动新线程
        - 调用FutureTask对象的get()方法来获得子线程执行结束后的返回值
    对比：
    采用实现Runnable、Callable接口的方式创见多线程时
    优势：
    线程类只是实现了Runnable接口或Callable接口，还可以继承其他类
    并且多个线程可以共享同一个target对象，所以非常适合多个相同线程来处理同一份资源的情况，从而可以将CPU、代码和数据分开，形成清晰的模型，较好地体现了面向对象的思想
    劣势：
    编程稍微复杂，如果要访问当前线程，则必须使用Thread.currentThread()方法

    继承Thread类的方式创建多线程时
    优势：
    编写简单，如果需要访问当前线程，则无需使用Thread.currentThread()方法，直接使用this即可获得当前线程
    劣势：
    线程类已经继承了Thread类，所以不能再继承其他父类
```

2. 线程和进程的区别？
```
    进程和线程的主要差别在于它们是不同的操作系统资源管理方式。进程有独立的地址空间，一个进程崩溃后，在保护模式下不会对其它进程产生影响，而线程只是一个进程中的不同执行路径。线程有自己的堆栈和局部变量，但线程之间没有单独的地址空间，一个线程死掉就等于整个进程死掉，所以多进程的程序要比多线程的程序健壮，但在进程切换时，耗费资源较大，效率要差一些。但对于一些要求同时进行并且又要共享某些变量的并发操作，只能用线程，不能用进程。
    1）简而言之，一个程序至少有一个进程，一个进程至少又一个线程
    2）线程的划分尺度小于进程，使得多线程程序的并发性高
    3）另外，进程在执行过程中拥有独立的内存单元，而多个线程共享内存，从而极大地提高了程序的运行效率
    4）县城在执行过程中与进程还是有区别的。每个独立的线程有一个程序运行的入口，顺序执行序列和程序的出口。但是线程不能独立执行，必须依存在应用程序中，有应用程序提供多个线程执行控制
    5）从逻辑角度来看，多线程的意义在于一个应用程序中，有多个执行部分可以同时执行。但操作系统并没有将多个线程看作多个独立应用，来实现进程的调度和管理以及资源分配。这就是线程和进程的重要区别。
```
3. 为什么要有线程，而不是仅仅用进程？
```
    1）进程只能在一个时间干一件事，如果想同时干两件事或多件事，进程就无能为力了
    2）进程在执行的过程中如果阻塞，例如等待输入，整个进程就会刮起，即使进程中有些工作不依赖于输入的数据，也将无法执行

    因为要并发，我们发明了进程，又进一步发明了线程。只不过进程和线程的并发层次不同：进程属于在处理器这一层上提供的抽象；线程则属于在进程这个层次上再提供了一层并发的抽象。如果我们进入计算机体系结构里，就会发现，流水线提供的也是一种并发，不过是指令级的并发。这样，流水线、线程、进程就从低到高在三个层次上提供我们所迫切需要的并发！

    除了提高进程的并发度，线程还有个好处，就是可以有效地利用多处理器和多核计算机。现在的处理器有个趋势就是朝着多核方向发展，在没有线程之前，多核并不能让一个进程的执行速度提高，原因还是上面所有的两点限制。但如果讲一个进程分解为若干个线程，则可以让不同的线程运行在不同的核上，从而提高了进程的执行速度
```
4. run()和start()方法区别
```
    start:
    用start方法启动线程，真正实现了多线程运行，这时无需等待run方法体代码执行完毕而直接继续执行下面的代码。通过调用Thread类的start()方法来启动一个线程，这时
    线程处于就绪状态，并没有运行，一旦得到cpu时间片，就开始cpu时间片，就开始执行run方法，这里方法run称为线程体，它包含了要执行的这个线程的内容，run方法运行结束，此线程随即终止。

    run:
    run方法只是类的一个普通方法而已，如果直接调用run方法，程序中依然只有主线程这一个线程，其程序执行路径还是只有一条，还是要顺序执行，还是等待run方法体执行完毕后
    才可以继续执行下面的代码，这样没有达到多线程的目的。

    总结：调用start方法方可启动线程，而run方法只是一个thread的一个普通方法调用，还是在主线程里执行。
```
5. 如何控制某个方法允许并发访问线程的个数？
```
    使用信号量Semaphore，控制线程的并发访问的个数
    //获取许可
    semaphore.acquire();
    //释放
    semaphore.release();
```
6. 在Java中wait和seelp方法的不同；
```
    1.每个对象都有一个锁来控制同步访问，synchronized关键字可以和对象的锁交互，来实现同步方法或同步块。sleep方法正在执行的线程主动让出CPU（然后CPU可以去执行其它任务），在sleep指定时间后CPU再回到该线程继续往下执行（sleep方法只让出CPU，而并不会释放同步资源锁）。wait方法则指当前线程让自己暂时退出同步资源锁，以便其它正在等待该资源进而运行，只有调用了notify方法，之前调用wait的线程才会解除wait状态，可以去参与竞争同步资源锁，进而得到执行。（notify的作用相当于叫醒睡着的人，而并不会给他分配任务，也就是说notify只是让之前调用wait的线程有权利重新参与线程的调度）

    2.sleep方法可以在任何地方使用，wait方法只能在同步方法或同步块中使用

    3.sleep是线程类方法，调用慧暂停此线程指定的时间，但监控依然保持，不会释放对象锁，到时间自动恢复；wait是Object的方法，调用会放弃对象锁，进入等待队列，待调用
    notify()/notifyAll()唤醒指定的线程或者所有线程，才会进入锁池，不再次获得对象锁才会进入运行状态。
```
谈谈wait/notify关键字的理解
```
    1.使用wait()、notify()和notifyAll()时需要首先对调用对象加锁
    2.调用wait()方法后，线程状态会从RUNNING变为WAITING，并将当线程加入到lock对象的等待队列中
    3.调用notify()或者notifyAll()方法后，等待在lock对象的等待队列的线程不会马上从wait()方法返回，必须要等到调用notify()或者notifyAll()方法的线程将lock锁释放，等待线程才有机会从等待队列返回。这里只是有机会，因为锁释放后，等待线程会出现竞争，只有竞争到该锁的线程才会从wait()方法返回，其他的线程只能继续等待
    4.notify()方法将等待队列中的一个线程移到lock对象的同步队列，notifyAll()方法则是将等待队列中所有线程移到lock对象的同步队列，被移动的线程的状态由WAITING变为BLOCKED
    5.wait()方法上等待锁，可以通过wait(long timeout)设置等待的超时时间

```
7. 什么导致线程阻塞？
```
    线程在运行过程中因为某些原因而发生阻塞，阻塞状态的特点：该线程放弃CPU的使用，暂停运行，只有等到导致阻塞的原因消除后才恢复运行。
    原因：
    - 一般线程中的阻塞
    - Socket客户端的阻塞
    - Socket服务器端的阻塞


    一般线程中的阻塞：
    A:线程执行了Thread.sleep方法，当前线程放弃CPU，睡眠一段时间，然后在恢复执行
    B:线程执行一段同步代码，但是尚且无法获得相关同步锁，只能进入阻塞状态，等到获取了同步锁，才能恢复执行
    C:线程执行一个对象的wait方法，直接进入阻塞状态，等待其它线程执行notify或者notifyAll方法
    D:线程执行某些IO操作，因为等待相关的资源而进入了阻塞状态。

    Socket客户端的阻塞：
    A:请求与服务器连接时，调用connect方法，进入阻塞状态，直至连接成功。
    B:当从Socket输入流读取数据时，在读取足够的数据之前会进入阻塞状态，
    C:调用Socket的setSoLinger()方法关闭了Socket延迟，当执行Socket的close方法时，会进入阻塞状态,直到底层socket发送完所有的剩余数据

    Socket服务器的阻塞：
    A:线程执行ServerSocket的accept方法，等待客户的连接，直到接收到的客户连接，才从accept方法中返回一个socket对象
    B:从socket输入流读取数据时，如果输入流没有足够的数据，就会进入阻塞状态
    C:线程向socket的输入流写入一批数据，可能进入阻塞状态

     所谓非阻塞方法，就是指当线程执行这些方法时，如果操作还没有就绪，就立即返回，不会阻塞着等待操作就绪。Java.nio 提供了这些支持非阻塞通信的类
```
8. 线程如何关闭？
```
    1.使用标志位
    public class MyThread implements Runnable{
        private volatile boolean isCancelled;
        public void run(){
            while(!isCancelled){
                //do something
            }
        }
    }
    注意：isCanceled需要位volatile，保证线程读取时isCancelled是最新数据

    2.使用中断
    java中提供了中断机制，Thread类下有三个重要方法
    public void interrupt()
    public boolean isInterrupted()
    public static boolean interrupted();//清除终端标志，并返回状态

    每个线程都有个boolean类型的中断状态，当使用Thread的interrupt方法时，线程的中断状态会被设置为true
```
9. 讲一下java中的同步的方法
```
    1.同步方法
    即有synchronized关键字修饰的方法，由于java的每个对象都有一个内置锁，当用此关键字修饰方法时，内置锁会保护整个方法。在调用该方法前，需要获得内置锁，否则就处于阻塞状态。注：synchronized 关键字也可以修饰静态方法，此时调用该静态方法，将会锁住整个类

    2.同步代码块
    即有synchronized关键字修饰的语句块，被关键字修饰的语句块会自动被加上内置锁，从而实现同步
    注：同步是一种高开销的操作，因此应该尽量减少同步的内容

    3.使用特殊域变量(volatitle)实现线程同步
    a:volatile关键字为域变量的访问提供了一种免锁机制
    b:使用volatile修饰域
```
10. 数据一致性如何保证？
```
                    原子性         可见性         有序性
    Volatile          否             是           是
    Synchronized      是             是           是
    Final             是             是           否

    当数据从主内存复制到工作存储时，必须出现两个动作：第一，由主内存执行的读（read）操作；第二，由工作内存执行的相应的load操作；当数据从工作内存拷贝到主内存时，也出现两个操作：第一个，由工作内存执行的存储（store）操作；第二，由主内存执行的相应的写（write）操作
    每一个操作都是原子的，即执行期间不会被中断
    对于普通变量，一个线程中更新的值，不能马上反应在其他变量中
    如果需要在其他线程中立即可见，需要使用 volatile 关键字

    final不可变
    作用于类、方法、成员变量、局部变量。初始化完成后的不可变对象，其它线程可见。常量不会改变不会因为其它线程产生影响。Final修饰的引用类型的地址不变，同时需要保证引用类型各个成员和操作的线程安全问题。因为引用类型成员可能是可变的

    synchronized同步
    作用域代码块、方法上。通过线程互斥，同一时间的同样操作只允许一个线程操作。通过字节码指令实现。

    Volatile
    1）volatile 修饰的变量的变化保证对其它线程立即可见
       volatile变量的写，先发生于读。每次使用volatile修饰的变量个线程都会刷新保证变量一致性。但同步之前各线程可能仍有操作。如：各个根据volatile变量初始值分别进行一些列操作，然后再同步写赋值。每个线程的操作有先后，当一个最早的线程给线程赋值时，其它线程同步。但这时其它线程可能根据初始值做了改变，同步的结果导致其它线程工作结果丢失。
       根据volatile的语意使用条件：运算结果不依赖变量的当前值。 
    2）volatile禁止指令重排优化


    java.util.concurrent 包含许多线程安全、测试良好、高性能的并发构建块。不客气地说，创建java.util.concurrent 的目的就是要实现 Collection 框架对数据结构所执行的并发操作。通过提供一组可靠的、高性能并发构建块，开发人员可以提高并发类的线程安全、可伸缩性、性能、可读性和可靠性。
    此包包含locks,concurrent,atomic 三个包：
    Atomic：原子数据的构建
    Locks：基本的锁的实现，最重要的AQS框架和lockSupport
    Concurrent：构建的一些高级的工具，如线程池，并发队列等
       
```
11. 如何保证线程安全？
```
    实现方法：
    1.互斥同步
        互斥同步是常见的一种并发正确性保障手段。同步是指在多个线程并发访问共享数据时，保证共享数据在同一个时刻只被一个（或者一些，使用信号量的时候）线程使用。
        互斥是实现同步的一种手段，临界区、互斥量、信号量都是主要的互斥方式。互斥是方法，同步是目的。
        在java中，最基本的互斥同步手段是synchronized关键字，synchronized关键字经过编译后，会在同步块的前后分别形成monitorenter和monitorexit这两个字节码指令，这两个字节码都需要一个reference类型的参数来指明要锁定和解锁的对象。如果Java程序中synchronized明确制定了对象参数，那就是这个对象的reference；如果没有明确指定，那就根据synchronized修饰的是实例方法还是类方法，去取对应的对象实例或Class对象来作为锁对象。

    2.非阻塞同步
        互斥同步最主要的问题时进行线程阻塞和唤醒带来的性能问题，因此这种同步也成为阻塞同步。非阻塞同步是先进行操作，如果没有其他线程争用共享数据，那操作就成功，
        如果数据有争用，产生了冲突，那就采取其他的补偿措施。
    3.无同步方案
        对于一个方法本来就不涉及共享数据，那就自然无须同步措施来保证正确性。
        可重入代码：在代码执行的任何时候中断它，去执行另一段代码，控制权返回后，原来的程序就不会出现任何错误。
        线程本地存储：共享数据的代码是否能在同一个线程中执行，如生产者-消费者模式

    4.使用锁
        a) Lock使用起来比较灵活，但需要手动释放和开启；采用synchronized不需要用户去手动释放锁，当synchronized方法或者synchronized代码块执行完之后，系统会自动让线程释放锁的占用
        b) Lock不是Java语言内置的，synchronized是Java语言的关键字，因此是内置特性。Lock是一个类，通过这个类可以实现同步访问。
        c) 在并发量比较小的情况下，使用synchronized是个不错的选择，但是在并发量比较高的情况下，其性能下降很严重，此时Lock是个不错的方案。
        d) 使用Lock的时候，等待/通知是使用Condition对象的await()/singal()/signalAll(),而使用synchronized的时候，则是对象的wait()/notify()/notifyAll();由此看出使用Lock的时候；粒度更细了，一个Lock可以对应多个Condition
        e) 虽然Lock缺少了synchronized隐士获取释放锁的便捷性，但是却拥有了锁获取与释放的可操作性、可中断的获取锁以及超时获取锁等多种synchronized所不具备的同步特性

```
12. 如何实现线程同步？
```
    1.同步方法：
        即又synchronized关键字修饰的方法，由于java的没个对象都有一个内置锁，当用此关键字修饰方法时，内置锁会保护整个方法。在调用该方法获得内置锁，否则就处于阻塞状态。
        注：synchronized关键字也可以修饰静态方法，此时如果调用该静态方法，将会锁住整个类

    2.同步代码块
       即有synchronized关键字修饰的语句块，被该关键字修饰的语句块会自动被加上内置锁，从而实现同步
       注：同步是一种高开销的操作，因此应该尽量减少同步的内容。通常没有必要同步整个方法，使用synchronized代码块同步关键代码即可。

    3.使用特殊域变量（volatile）实现线程同步
        a)volatile关键字为域变量的访问提供了一种免锁机制
        b)使用volatile修饰域相当于告诉该域可能会被其它线程更新
        c)因此每次使用该域就要重新计算，而不是使用寄存器中的值
        d)volatile不会提供任何原子操作，它也不能用来修饰final类型的变量

    4.使用重入锁实现线程同步
      在javaSE5.0中新增一个java.util.concrurrent包来支持同步
      ReentrantLock类是可重入、互斥、实现了Lock接口的锁
      它与使用synchronized方法和块具有相同的基本行为和语义，并且扩展了其能力

      ReenreantLock类的常用方法有：
      ReentrantLock() : 创建一个ReentrantLock实例
      lock() : 获得锁
      unlock() : 释放锁   

      注：关于Lock对象和synchronized关键字的选择：
      a.最好两个都不用，使用一种java.util.concurrent包提供的机制，
        能够帮助用户处理所有与锁相关的代码。
      b.如果synchronized关键字能满足用户的需求，就用synchronized，因为它能简化代码
      c.如果需要更高级的功能，就用ReentrantLock类，此时要注意及时释放锁，否则会出现死锁，通常在finally代码释放锁 

    5.使用局部变量实现线程同步
      如果使用ThreadLocal管理变量，则每一个使用该变量的线程都获得该变量的副本，副本之间相互独立，这样每一个线程都可以随意修改自己的变量副本，而不会对其他线程产生影响。    
      ThreadLocal 类的常用方法
      ThreadLocal() : 创建一个线程本地变量
      get() : 返回此线程局部变量的当前线程副本中的值
      initialValue() : 返回此线程局部变量的当前线程的"初始值"
      set(T value) : 将此线程局部变量的当前线程副本中的值设置为value

      注：ThreadLocal与同步机制
        a.ThreadLocal与同步机制都是为了解决多线程中相同变量的访问冲突问题。
        b.前者采用以”空间换时间”的方法，后者采用以”时间换空间”的方式
```
15. Java中对象的生命周期
```
    1) 创建阶段
    2）应用阶段
    3）不可见阶段
    4）不可达阶段
    5）收集阶段
    6）终结阶段
    7）对象空间重分配阶段
```
16. Synchronized用法和原理
```
    Java中每个对象都可以作为锁：
    1.普通同步方法，锁是当前实例对象
    2.静态同步方法，锁是当前类的class对象
    3.同步代码块，锁是括号中的对象

    1）同步代码块使用了monitorenter和monitorexit指令实现
    2）同步方法中依靠方法修饰符上的ACC_SYNCHRONIZED实现
    无论哪种实现，本质上都是对指定对象相关联的monitor的获取，这个过程是互斥性的，也就是说同一时刻只有一个线程能够成功，其它失败的线程会被阻塞，并放入到同步队列中，进入BLOCKED状态
```
18. 谈谈对Synchronized关键字，类锁，方法锁，重入锁的理解
```
    方法锁即对象锁
    java的内置锁：每个java对象都可以用做一个实现同步的锁，这些锁称为内置锁。线程进入同步代码块或方法的时候会自动获得该锁，在退出同步代码块或方法时会释放该锁。
    获得内置锁的唯一途径就是进入这个锁的保护的同步代码块或方法。

    java内置锁是一个互斥锁，这就意味着最多只有一个线程能够获得该锁，当线程A尝试去获得线程B持有的内置锁时，线程A必须等待或者阻塞，知道线程B释放这个锁，如果线程B不释放这个锁，
    那么A线程永远等待下去。

    java的对象锁和类锁：java的对象锁和类锁在锁的概念上基本上和内置锁是一致的，但是两个锁实际是有很大的区别的，对象锁是用于对象实例方法，或者一个对象实例上的，类锁是用于类的
    静态方法或者一个类class对象上。类锁只是一个概念上的东西，并不是真实存在的，它只是用来帮助我们理解锁定实例方法和静态方法的区别。

    Synchronized用法：
    Synchronized修饰方法和修饰代码块
    synchronized只是一个内置锁的加锁机制，当某个方法加上synchronized关键字后，就表明要获得该内置锁才能执行，并不能阻止其他线程访问不需要获得该内置锁的方法

    类锁修饰（静态）方法和代码块：
    类锁修饰方法和代码块的效果和对象锁是一样的，因为类锁只是一个抽象出来的概念，只是为了区别静态方法的特点，因为静态方法是所有对象实例共用的，所以对应着synchronized
    修饰的静态方法的锁也是唯一的，所以抽象出来个类锁。

    synchronized同时修饰静态方法和实例方法，运行结果是交替进行的，这证明了类锁和对象锁是两个不一样的锁，控制着不同的区域，他们是互不干扰的，同样，线程获得对象锁的同时，
    也可以获得该类锁，即同时获得两个锁，这时允许的。

    注：一个类的对象锁和另一个类的对象锁是没有关联的，当一个线程获得A类的对象锁时，它同时也可以获得B类的对象锁

    synchronized：可重入锁
    ReentrantLock:可重入锁
```
19. static synchronized 方法的多线程访问和作用
```
    synchronized是对类的当前实例进行加锁，防止其他线程同时访问该类的该实例的所有synchronized块，注意这里是“类的当前实例”，类的两个不同实例就没有这种约束了。
    static synchronized则是所有该类的实例公用一个监视快了，也就是两个的区别了,也就是synchronized相当于this.synchronized，而staticsynchronized相当于Something.synchronized.

    结论：
    synchronized static是某个类的范围，synchronized static cSync{}防止多个线程同时访问这个类中的synchronized static 方法。它可以对类的所有对象实例起作用。
    synchronized 是某实例的范围，synchronized isSync(){}防止多个线程同时访问这个实例中的synchronized 方法。
```
20. 同一个类里面两个synchronized方法，两个线程同时访问的问题
```
    https://blog.csdn.net/aiyawalie/article/details/53261823
    同一个object中多个方法都加了synchronized关键字的时候，其中调用任意方法之后需等该方法执行完成才能调用其他方法，即同步的，阻塞的
    此结论同样适用于对于object中使用synchronized(this)同步代码块的场景
    synchronized锁定的都是当前对象
```
22. 谈谈volatile关键字的用法和作用及原理
```
    volatile作用：
    1）保持内存可见性：所有线程都能看到共享内存的最新状态
    2）防止指令重排序

    Java通过几种原子操作完成工作内存和主内存的交互
    1.lock:作用于主内存，把变量标识为线程独占状态
    2.unlock:作用于主内存，解除独占状态
    3.read:作用于主内存，把一个变量的值从主内存传输到线程的工作内存
    4.load:作用于工作内存，把read操作传过来的变量值加入工作内存的变量副本中
    5.use:作用于工作内存，把工作内存当中的一个变量值传给执行引擎
    6.assign:作用工作内存，把一个从执行引擎接收到的值赋值给工作内存的变量
    7.store:作用于工作内存的变量，把工作内存的一个变量的值传送到主内存
    8.write:作用于主内存的变量，把store操作传来的变量的值放入主内存的变量中

    volatile保持内存可见性：
    - read,load,user动作必须连续出现
    - assign,store,write动作必须连续出现
    volatile变量能够保证:
    - 每次读取前必须先从主内存刷新最新的值
    - 每次写入后必须立即同步回主内存当中

    即：volatile关键字修饰的变量看到的随时是自己的最新值

    防止指令重排：
    在基于偏序关系的Happen-Before内存模型中，指令重排技术大大提高了程序执行效率，但同时也引入了一些问题

    DCL（双重检查锁）,单例模式中用到
    在只有DCL没有volatile的懒加载单例模式中，仍然存在着并发陷阱，可能会拿到半个单例

    volatile如何防止指令重排：
    volatile关键字通过“内存屏障”来防止指令被重排序
    实现方式：
    - 在每个volatile写操作的后面插入一个Full Barriers
    - 在每个volatile读操作的前面插入一个Full Barriers

    基于保守策略的JMM内存屏障插入策略：
    - 在每个volatile写操作的前面插入一个StoreStore屏障
    - 在每个volatile写操作的后面插入一个StoreLoad屏障
    - 在每个volatile读操作的后面插入一个LoadLoad屏障
    - 在每个volatile读操作的后面插入一个LoadStore屏障

    Happens-Before内存模型和程序顺序规则
    只有在Happens-Before内存模型中才会出现这样的指令重排序问题。Happens-Before内存模型维护了几种Happens-Before规则，程序顺序规则最基本的规则。
    程序顺序规则的目标对象是一段程序代码中的两个操作A、B，其保证此处的指令重排不会破坏操作A、B在代码中的先后顺序，但与不同代码甚至不同线程中的顺序无关。

    注意：
    volatile关键字使变量的读、写具有了原子性。而这种原子性仅限于变量的读写，无法涵盖变量上的任何操作
    即：
    - 基本类型的自增（i++)等操作不是原子的
    - 对象的任何非原子成员调用（包括成员变量和成员方法）不是原子的
```
23. 谈谈AIO、BIO和NIO的理解
```
    BIO，同步阻塞式IO，一个连接一个线程，这个线程只针对这个连接而存在，专注于它的收发，如果没有数据读入他就一直阻塞等待。（可以通过线程池改善）
    AIO，同步非阻塞式IO，一个请求一个线程，即客户端发送的连接请求都会注册到多路复用器上，多路复用器轮询到连接有I/O请求时，才启动一个线程进行处理。用户进程也需要
    时不时的询问IO操作是否就绪，这就要求用户进程不停去询问。
    NIO，异步非阻塞式IO，一个有效请求一个线程，用户进程只需要发起一个IO操作然后立即返回，等IO操作真正的完成以后，应用程序会得到IO操作完成的通知，此时用户进程只需要对数据进行处理好了，不需要进行实际的IO读写操作。
```
24. ReentrantLock 、Lock、synchronized和volatile比较
```
    synchronized：
    互斥锁，即操作互斥，兵法线程过来，串行获得锁，串行执行代码。

    ReentrantLock：
    可重入锁，和同步锁功能类似，不过需要显示的创建、销毁。
    特点：
    1）ReentrantLock有tryLock方法，如果锁被其它线程持有，返回false，可避免形成死锁
    2）创建时可自定义是否可抢占
    3）ReentrantReadWriteLock,用于读多写少，且读不需要互斥的场景，大大提高性能

    volatile:
    只保证同一变量在多线程中的可见性
    1）它确保指令重排序时不会把其后面的指令排到内存屏障之前的位置，也不会把前面的指令排到内存屏障的后面，即在执行到内存屏障这句指令时，在它前面的操作已经全部完成
    2）他会强制将对缓存的修改操作立即写入贮存
    3）如果是写操作，它会导致其它CPU对应的缓存行失效
    注：虽然保证变量是主存数据，但是操作不是原子的，多线程读取到同一个值（是主存的值），同时进行判断或者操作，导致出错

    总结：
    synchronized和ReentrantLock是一个级别的，但是volatile只是一个轻量级的关键字
```
25. ReentrantLock的内部实现
```
https://blog.csdn.net/yanyan19880509/article/details/52345422
```
27. 死锁的四个必要条件？
```
    产生死锁的原因主要是：
    1）因为系统资源不足
    2）进程运行推进的顺序不合适
    3）资源分配不当等
    如果系统资源充足，进程的资源请求都能够得到满足，死锁出现的可能性就很低，否则就会因争夺有限的资源而陷入死锁。其次，进程运行推进顺序与速度不同，也可能产生死锁。

    产生死锁的四个必要条件：
    1）互斥条件：一个资源每次只能被一个进程使用
    2）请求与保持条件：一个进程因请求资源而阻塞时，对已获得的资源保持不放
    3）不剥夺条件：进程已获得的资源，在未使用完之前，不能强行剥夺
    4）循环等待条件：若干进程之间形成一种头尾相接的循环等待资源关系
    这四个条件时死锁的必要条件，只要系统发生死锁，这些条件必然成立，而只要上述条件之一不满足，就不会发生死锁。


```
28. 怎么避免死锁？
```
    1）加锁顺序（线程按照一定的顺序加锁）
    2）加锁时限（线程尝试获取锁的时候加上一定的时限，超过时限则放弃对该锁的请求，并释放自己占有的锁）
    3）死锁检测
```
29. 对象锁和类锁是否会互相影响？
```
对象锁：Java的所有对象都含有1个互斥锁，这个锁由JVM自动获取和释放。线程进入synchronized方法的时候获取该对象的锁，当然如果已经有线程获取了这个对象的锁，
那么当前线程会等待；synchronized方法正常返回或者抛异常而终止，JVM会自动释放对象锁。体现了synchronized来加锁的1个好处，方法抛异常的时候，锁仍然可以
由JVM来自动释放。
类锁：对象锁是用来控制实例方法之间的同步，类锁是用来控制静态方法（或静态变量互斥体）之间的同步。其实类锁只是一个概念上的东西，并不是真实存在的，它只是用来
帮助我们理解锁定实例方法和静态方法的区别。java类可能会有很多个对象，但是只有1个class对象，也就是说类的不同实例之间共享该类的Class对象。Class对象其实
也仅仅是1个java对象，只不过有点特殊而已。由于每个java对象都有1个互斥锁，而类的静态方法是需要Class对象。所以所谓的类锁，不过是Class对象的锁而已。获取类
的Class对象有好几种，最简单的是MyClass.class的方式。

类锁和对象锁不是同一个东西，一个是类的class对象的锁，一个是类实例的锁。1个线程访问静态synchronized的时候，允许另一个线程访问对象的实例synchronized
方法。反过来也是成立的，因为他们需要的锁是不同的。
```
30. 什么是线程池，如何使用?
```
线程池为线程生命周期开销问题和资源不足问题提供解决方案，通过对多个任务重用线程，线程创建的开销被分摊到了多个任务上。好处：因为在请求到达时线程已经存在，消除
线程创建带来的延迟。可以立即为请求服务，使应用程序响应更快。通过适当调用调整线程池中的线程数目，也就是当请求的数目超过某个阈值时，强制其它任何新到的请求一直
等待，直到获得一个线程处理为止，从而可与你防止资源不足。
```

31. Java的并发、多线程、线程模型
```
线程模型：
一对一模型
多对一模型
多对多模型
```

32. 谈谈对多线程的理解
```
1.程序，进程，线程三者之间的关系

2.单线程与多线程以及多线程的意义

3.理解并发与并行

4.线程的创建方式

5.线程在程序中的几种状态

6.多线程的安全隐患以及synchronized监视器

```

33. 多线程有什么要注意的问题？
```
1.死锁与定位
2.内存非法访问及定位
3.伪共享和volatile作用
4.多线程中的单例模式
5.对象生死与多线程
```

34. 谈谈你对并发编程的理解并举例说明
```
  高并发：
  高并发是请求，指的是多个客户端同时刻向服务器发送请求，它是一种现象。

  多线程：
  多线程是处理，指的是同一时刻多个执行者处理同一类的任务

  并行：
  多核cpu的情况，多个任务执行者并行处理任务

  并发：
  单个cpu的情况，cpu间断性的执行多个任务
  
  多线程一定效率高吗？
  多线程并非效率一定高。只有在并行的情况下效率才能保证，并发需要做上下文切换，会影响整体性能。

  并发编程需要注意2个问题：
  a.共享数据的安全性问题
  b.锁竞争带来的程序效率问题
```

35. 谈谈你对多线程同步机制的理解？
```
为什么要使用同步：
当多个线程同时操作一个可共享的资源变量时，将会导致数据不准确，相互之间产生冲突，因此在加入同步锁以避免在该线程没有完成
操作之前，被其它线程调用。从而保证了该变量的唯一性和准确性。

同步的方式：
1.同步方法
即有synchronized关键字修饰的方法，由于java的每个对象都有一个内置锁，当用此关键字修饰方法时，内置锁保护整个方法。在调用
该方法前，需要获得内置锁，否则处于阻塞状态。

2.同步代码块
即有synchronized关键字修饰的语句块，被该关键字修饰的语句块会自动被加上内置锁，从而实现同步

3.使用特殊域变量（volatile）实现线程同步
 a)volatile关键字为域变量的访问提供了一种免锁机制
 b)使用volatile修饰域相当于告诉虚拟机该域可能会被其它线程更新
 c)因此每次使用该域要重新计算，而不是使用寄存器中的值
 d)volatile不会提供任何原子操作，它也不能用来修饰final类型的变量

4.使用重入锁实现线程同步
 在JavaSE5.0中新增了一个java.util.concurrent包来支持同步
 ReentrantLock类是可重入、互斥、实现了Lock接口的锁，它和使用了synchronized方法和块具有相同的基本行为和语义，并且扩展了其能力
 ReentrantLock类的常用方法：
 ReentrantLock（）创建一个ReentrantLock实例
 lock()获得锁
 unlock()释放锁
 关于Lock对象和synchronized关键字的选择：
 a.最好两个都不用，使用一种java.util.concurrent包提供的机制，能够帮助用户处理所有与锁相关的代码
 b.如果synchronized关键字能满足用户的需求，就用synchronized，因为它能简化代码
 c.如果需要更高级的功能，就用ReentrantLock类，此时要注意及时释放锁，否则会出现死锁，通常在finally代码释放锁 

5.使用局部变量实现线程同步
如果使用ThreadLocal管理变量，则每个使用该变量的线程都获得该变量的副本，副本之间相互独立，这样每一个线程都可以随意修改自己的变量副本吧，而不会对其它线程产生影响
ThreadLocal类的常用方法：
ThreadLocal()创建一个线程本地变量
get()返回此线程局部变量的当前线程副本中的值
initialValue()返回此线程局部变量的当前线程的初始值
set(T value)将此线程局部变量的当前线程副本中的值设置为value

注：ThreadLocal与同步机制
a.ThreadLocal与同步机制都是为了解决多线程中相同变量的访问冲突问题
b.前者采用以空间换时间的方法，后者以时间换空间的方式
```
36. 如何保证多线程读写文件的安全？
```
文件锁保证多线程读写文件的安全
当一个线程获得文件时，给予这个线程文件锁。只有拥有文件锁的线程才能操作文件，其他线程需要一直等待，直到获得文件锁。

```
38. 断点续传的实现
```
断点续传就是在下载的断开点继续开始传输，不用再从头开始。
断点:线程停止的位置。
续传：从停止的为止重新下载。

断点：当前线程已经下载完成的数据长度
续传：向服务器请求上次线程停止位置之后的数据
实现：通过设置网络请求参数，请求服务器从指定为止开始读取数据
使用HttpURLConnection里面的setRequestProperty方法便可以实现
向服务器请求500-1000之间的500个byte
conn.setRequestProperty("","bytes="+500+"-"+1000);

RandomAccessFile来实现从指定位置给文件写入数据的功能
从文件的第100个byte后开始写入数据：
file.seek(100);
而开始写入数据时还需要用到RandomAccessFile里面的另外一个方法:
public void write(byte[] buffer, int byteOffset, int byteCount)

多线程断点续传
多线程断点续传在单线程的断点续传上延伸的，而多线程断点续传把整个文件分割成几个部分，每个部分由一条线程执行下载，而每一条下载线程都要
实现断点续传功能。
实现文件分割，用到HttpURLConnection的另外一个方法
public int getContentLength()
在请求成功时，通过该方法获取文件的总长度。
每一条线程下载大小=fileLength/threadNum;

由于文件是分成多个部分是被不同的线程的同时下载的，这就需要，每一条线程都分别需要有一个断点记录，和一个线程完成状态的记录
```
39. Transient关键字
```
    transient是Java语言的关键字，用来表示一个域不是该对象串行化的一部分
    当一个对象被串行化的一部分，当一个对象被串行化的时候，transient型变量的值不包括在串行化的表示中，然而非transient型的变量被包括进去。
    注意：static变量也是可以串行化的；通过反序列化得到的对象是不同的对象，而且得到的对象不是通过构造器得到的，也就是说反序列化得到的对象不执行构造器。

```
40. java四种线程池的用法分析
```
1. new Thread的弊端
a. 每次new Thread新建对象性能差
b. 线程缺乏统一管理，可能无限制新建线程，相互之间竞争，可能占用过多系统资源导致死机或oom
c. 缺乏更多功能，如定时执行，定期执行，线程终端

线程池的好处：
a.重用存在的线程，减少对象创建、消亡的开销，性能佳。
b.可有效控制最大并发线程数，提高系统资源的使用率，同时避免过多资源竞争，避免堵塞。 
c.提供定时执行、定期执行、单线程、并发数控制等功能。

四类线程池：
a.newCachedThreadPool 创建一个可缓存线程池，如果线程池长度超过处理需要，可灵活回收空闲线程，若无可回收，则新建线程。
b.newFixedThreadPool 创建一个定长线程池，可控制线程最大并发数，超出的线程会在队列中等待
c.newScheduledThreadPool创建一个定长线程池，支持定时及周期性任务执行
d.newSingleThreadExecutor创建一个单线程花的线程池，它只会用唯一的工作线程来执行任务，保证所有任务按照指定顺序(FIFO,LIFO)执行

1)newCachedThreadPool
创建一个可缓存线程池，如果线程池长度超过处理需要，可灵活回收空闲线程，若无可回收，则新建线程。
ExecutorService cachedThreadPool = Executors.newCachedThreadPool();
for(int i=0;i<10;i++){
    final int index=i;
    try{
       Thread.sleep(index*1000);  
    }catch(InterruptedException e){
         e.printStackTrace();
    }
}
cachedThreadPool.execute(new Runnable(){
    @Override
    public void run(){
        System.out.println(index);
    }
});
2）newFixedThreadPool
创建一个定长线程池，可控制线程最大并发数，超出的线程会在队列中等待。
定长线程池的大小最好根据系统资源进行设置，如Runtime.getRuntime().availableProcessors()。
ExecutorService fixedThreadPool = Executors.newFixedThreadPool(3);
for (int i = 0; i < 10; i++) {
    final int index = i;
    fixedThreadPool.execute(new Runnable(){
    @Override
    public void run(){
        try{
            System.out.println(index);
            Thread.sleep(2000);
        }catch(Exception e){
            e.printStackTrace();
        }    
    });
}

3）newScheduledThreadPool
创建一个定长线程池，支持定时及周期行任务执行。
ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(5);
scheduledThreadPool.schedule(new Runnable(){
    @Override
    public void run(){
        System.out.println("delay 3 seconds");    
    }
},3,TimeUnit.SECONDS);//表示延迟3秒执行
//},1,3,TimeUnit.SECONDS);//表示延迟1秒每3秒执行一次

4）newSingleThreadExecutor
ExecutorService singleThreadExecutor = Executors.newSingleThreadExecutor();
for (int i = 0; i < 10; i++) {
final int index = i;
singleThreadExecutor.execute(new Runnable() {
@Override
public void run() {
    try {
        System.out.println(index);
    Thread.sleep(2000);
} catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
        }
}
    });
}
Android中单线程可用于数据库操作，文件操作，应用批量安装，应用批量删除等不适合并发但可能IO阻塞性及影响UI线程响应的操作。

线程池的作用：
线程池作用就是限制系统中执行线程的数量。 

Java里面线程池的顶级接口是Executor，但是严格意义上讲Executor并不是一个线程池，而只是一个执行线程的工具。真正的线程池接口是ExecutorService。
比较重要的几个类：
ExecutorService：真正的线程池接口
ScheduledExecutorService：能和Timer/TimerTask类似，解决那些需要任务重复执行的问题。
ThreadPoolExecutor:ExecutorService的默认实现
ScheduledThreadPoolExecutor:继承ThreadPoolExecutor的ScheduledExecutorService接口实现，周期行任务调度的类实现。
```

