---
title: 迁移至AndroidX
donate: true
date: 2021-12-03 09:28:08
categories:
tags:
---
## 引用官方文档
### 前提条件
执行迁移之前，请先将应用更新到最新版本。 我们建议您将项目更新为使用支持库的最终版本：版本 28.0.0。 这是因为，1.0.0 版本的 AndroidX 工件是与支持库 28.0.0 工件等效的二进制文件。

### 使用 Android Studio 迁移现有项目
在gradle.properties文件中新增android.useAndroidX=true和android.enableJetifier=true(使第三方库支持)

使用 Android Studio 3.2 及更高版本，您只需从菜单栏中依次选择 Refactor > Migrate to AndroidX，即可将现有项目迁移到 AndroidX。

### 迁移坑
1. [库映射](https://developer.android.google.cn/jetpack/androidx/migrate/artifact-mappings?hl=zh-cn)
检查gradle文件中对应的旧库是否已经映射为最新的androidx库

2. [库类映射](https://developer.android.google.cn/jetpack/androidx/migrate/class-mappings?hl=zh-cn)
检查Java文件以及xml文件中的旧的类包，是否已经映射为新的androidx包，不要遗漏。
