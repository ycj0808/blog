---
title: 使用gradle发布项目到Jcenter仓库
donate: true
date: 2018-06-24 18:13:19
categories: android
tags: android gradle
---


## 申请Bintray账号
Bintray的基本功能类似于Maven Central,[申请账号](https://bintray.com),进行注册。

登录后，点击edit打开编辑，然后点击api key

## 项目中配置

**项目的build.gradle添加构建依赖，如下：**
```
buildscript {
    
    repositories {
        google()
        jcenter()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:3.1.3'
        classpath 'com.jfrog.bintray.gradle:gradle-bintray-plugin:1.6'
        classpath 'com.github.dcendents:android-maven-gradle-plugin:1.3'
    }
}

allprojects {
    repositories {
        google()
        jcenter()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
```

1. 在.gradle目录下，编辑gradle.properties加入配置
```
BINTRAY_USER=xxx  
BINTRAY_KEY=xxx  
```

2. 在本地项目的local.properties，添加如上配置

**在gradle.properties文件下配置**
```
PROJ_GROUP=com.android.icefire
PROJ_VERSION=1.0.1
PROJ_NAME=wifimanagerlib
PROJ_WEBSITEURL=https://github.com/ycj0808/wifimanager
PROJ_ISSUETRACKERURL=https://github.com/ycj0808/wifimanager/issues
PROJ_VCSURL=https://github.com/ycj0808/wifimanager.git
PROJ_DESCRIPTION=WIFI manager 
PROJ_ARTIFACTID=wifimanagerlib

DEVELOPER_ID=icefire
DEVELOPER_NAME=icefire
DEVELOPER_EMAIL=yangchj@icefire.me
```

**添加bintray.gradle文件,内容如下:**
```
group = PROJ_GROUP
version = PROJ_VERSION
project.archivesBaseName = PROJ_ARTIFACTID

apply plugin: 'com.jfrog.bintray'
apply plugin: 'maven-publish'

task sourcesJar(type: Jar) {
    from android.sourceSets.main.java.srcDirs
    classifier = 'sources'
}

task javadoc(type: Javadoc) {
    source = android.sourceSets.main.java.srcDirs
    classpath += configurations.compile
    classpath += project.files(android.getBootClasspath().join(File.pathSeparator))
}

task javadocJar(type: Jar, dependsOn: javadoc) {
    classifier = 'javadoc'
    from javadoc.destinationDir
}

javadoc {
    options{
        encoding "UTF-8"
        charSet 'UTF-8'
        author true
        version true
        links "http://docs.oracle.com/javase/7/docs/api"
        title PROJ_ARTIFACTID
    }
}

artifacts {
    archives javadocJar
    archives sourcesJar
}

def pomConfig = {
    licenses {
        license {
            name "The Apache Software License, Version 2.0"
            url "http://www.apache.org/licenses/LICENSE-2.0.txt"
            distribution "repo"
        }
    }
    developers {
        developer {
            id DEVELOPER_ID
            name DEVELOPER_NAME
            email DEVELOPER_EMAIL
        }
    }
}

/*publishing {
    publications {
        mavenJava(MavenPublication) {
            artifactId PROJ_ARTIFACTID
            pom{
                packaging 'aar'
            }
            pom.withXml {
                def root = asNode()
                root.appendNode('description', PROJ_DESCRIPTION)
                root.children().last() + pomConfig
            }
        }
    }
}*/


install {
    repositories.mavenInstaller {
        pom.project {
            packaging 'aar'
            name COMMON_NOTIFICATION_NAME
            url PROJ_WEBSITEURL
            licenses {
                license {
                    name "The Apache Software License, Version 2.0"
                    url "http://www.apache.org/licenses/LICENSE-2.0.txt"
                    distribution "repo"
                }
            }
            developers {
                developer {
                    id DEVELOPER_ID
                    name DEVELOPER_NAME
                    email DEVELOPER_EMAIL
                }
            }

            scm {
                connection PROJ_WEBSITEURL
                developerConnection PROJ_WEBSITEURL
                url PROJ_WEBSITEURL
            }
        }
    }
}

bintray {
    Properties properties = new Properties()
    properties.load(project.rootProject.file('local.properties').newDataInputStream())

    user = properties.getProperty('BINTRAY_USER');
    key = properties.getProperty('BINTRAY_KEY');

    configurations = ['archives']
    publications = ['mavenJava']
    publish = true

    pkg {
        repo = 'maven'
        name = PROJ_NAME
        desc = PROJ_DESCRIPTION
        websiteUrl = PROJ_WEBSITEURL
        issueTrackerUrl = PROJ_ISSUETRACKERURL
        vcsUrl = PROJ_VCSURL
        licenses = ['Apache-2.0']
        publicDownloadNumbers = true
    }
}
```

**在libray的build.gradle下添加**
```
//文件的最下方添加
apply from: '../bintray.gradle'
```

## 执行发布命令
```

./gradlew install
./gradlew bintrayUpload
```

## 将库加入Jcenter
登录 bintray.com,刚刚发布的库申请加入到jcenter,进入[此页面](https://bintray.com/bintray/jcenter),点击Include My Package，然后在弹出的对话框中搜索并勾上你的项目。然后你可以写一下你的提交请求（貌似也可以不写？），点“Send”，接下来就看管理员审核了。