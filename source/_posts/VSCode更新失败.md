---
title: VSCode更新失败
donate: true
date: 2018-12-29 09:41:48
categories:
tags:
---

## Mac vscode 更新失败：Permission denied解决办法

1. 先把vscode完全关闭
```

sudo chown $USER ~/Library/Caches/com.microsoft.VSCode.ShipIt/
sudo chown $USER ~/Library/Caches/com.microsoft.VSCode.ShipIt/*
xattr -dr com.apple.quarantine /Applications/Visual\ Studio\ Code.app
```