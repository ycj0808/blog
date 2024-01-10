---
title: Linux运维
donate: true
date: 2019-04-23 09:54:58
categories:
tags:
---


1. 仅清除页面缓存
```
sync; echo 1 > /proc/sys/vm/drop_caches
```

2. 清除目录项和inode
```
sync; echo 2 > /proc/sys/vm/drop_caches
```

3. 清除页面缓存，目录项和iNode
```
sync; echo 3 > /proc/sys/vm/drop_caches
```

## 手动清理内存缓存
```
cat /proc/sys/vm/drop_caches

echo 3 > /proc/sys/vm/drop_caches
```