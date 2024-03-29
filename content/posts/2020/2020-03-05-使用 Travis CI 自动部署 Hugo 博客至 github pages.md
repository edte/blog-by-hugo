---
title: 使用 Travis CI 自动部署 Hugo 博客至 github pages
author: "edte"
tags: ["博客","hugo"]
date: 2020-03-05
---

[toc]

## 原理

在 github 上建立两个 repo, 一个用于放博客源码，假如名字是`blog`, 另一个用于部署博客, 名字符合 `username.github.io` 格式，username 是你的 github 名。用户只需将 `blog` clone 下来，将博客添加至对应目录，然后将此 rep push 至 github, 其他的都不用管，等一会便部署到 github pages 了。实际发生了什么呢，其实是用户 push 到 github 后，github 会自动发送通知到 travis, 然后 travis 就会按照用户的配置开始部署，它将项目 build 后就自动 push 到 username.github.io, 然后等会 github 就自动渲染了。

## 正文

### 一些设置

这里有一些设置，我本想自己写，但是发现有人已经写得很详细了。请自行查看

[使用 Travis CI 自动部署 Hugo 博客](https://mogeko.me/2018/028/)



### 编写配置文件

在 `Blog` 根目录创建 `.travis.yml` 文件，此文件是告诉 **Travis CI**  如何部署你的博客, 查看了一些博客，但是均不可，于是我自己参考别人写了个。

```
#启动一个有 go 语言环境的容器
language: go

#go 版本
go:
  - "1.8" 
  
# 安装最新的hugo  
install:
  - wget https://github.com/gohugoio/hugo/releases/download/v0.51/hugo_0.51_Linux-64bit.deb
  - sudo dpkg -i hugo*.deb
  
  
# 运行hugo命令
script:
  - hugo

deploy:
  #指定这是一份github pages的部署配置
  provider: pages
  
  skip_cleanup: true
  
  # 在 travis-ci.org 上设置的 Token 的名字[需要改]
  github_token: $GITHUB_TOKEN
  
  on:
    branch: master
    
  #将生成静态内容到 public/ 下
  local_dir: public
  
  #github pages rep[需要改]
  repo: edte/edte.github.io
  
  #部署到 master 分支
  target_branch: master
  
  #使用帐号 deployment-bot
  email: deploy@travis-ci.org
  name: deployment-bot

```



## 相关文章

* [使用 Travis CI 自动部署 Hugo 博客](https://mogeko.me/2018/028/)

* [我是如何用 Hugo、Travis CI 和 GitHub Pages 搭建博客的?](https://zyfdegh.github.io/post/201705-how-i-setup-hugo/)
