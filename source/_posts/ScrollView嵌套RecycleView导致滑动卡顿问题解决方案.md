---
title: ScrollView嵌套RecycleView导致滑动卡顿问题解决方案
donate: true
date: 2018-10-19 11:27:03
categories:
tags:
---
## 问题
ScrollView中嵌套RecycleView,由于ScollView和RecycleView都是滑动控件，会有滑动上的冲突，导致滑动起来有些卡顿

## 解决方案
重写LayoutManager,禁止纵向滑动，这样RecycleView就一如既往的流畅了
```java
LinearLayoutManager linearLayoutManager=new LinearLayoutManager(getActivity(), LinearLayoutManager.VERTICAL, false){
        @Override
        public boolean canScrollVertically() {
            return false;
        }

};
```