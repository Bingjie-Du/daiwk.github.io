---
layout: post
category: "dl"
title: "激活函数"
tags: [激活函数, activation function ]
---

目录

<!-- TOC -->

- [selu](#selu)
    - [概述](#概述)

<!-- /TOC -->


## selu

参考
[引爆机器学习圈：「自归一化神经网络」提出新型激活函数SELU](https://zhuanlan.zhihu.com/p/27362891)
[加速网络收敛——BN、LN、WN与selu](http://skyhigh233.com/blog/2017/07/21/norm/)
[如何评价 Self-Normalizing Neural Networks 这篇论文?](https://www.zhihu.com/question/60910412)

paper: [Self-Normalizing Neural Networks](https://arxiv.org/abs/1706.02515)

### 概述

其实就是ELU乘了个lambda，关键在于这个lambda是大于1的。以前relu，prelu，elu这些激活函数，都是在负半轴坡度平缓，这样在activation的方差过大的时候可以让它减小，防止了梯度爆炸，但是正半轴坡度简单的设成了1。而selu的正半轴大于1，在方差过小的的时候可以让它增大，同时防止了梯度消失。这样激活函数就有一个不动点，网络深了以后每一层的输出都是均值为0方差为1。


