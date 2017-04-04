---
layout: post
category: "platform"
title: "tf step by step: chap 1. 基础知识"
tags: [tf step by step,]
---

**目录**

* [1. 概要](#1-概要)
* [2. 编程模型简介](#2-编程模型简介)
   * [2.1 核心概念](#21-核心概念)
   * [2.2 实现原理](#22-实现原理)
   * [2.3 拓展功能](#23-拓展功能)
   * [2.4 性能优化](#24-性能优化)

-- 整理自《tensorflow实战》 chap 1

## 1. 概要
+ 2015年11月，tensorflow在github上开源。
+ 2016年4月，发布了分布式版本。
+ 2017年1月，发布1.0版本的预览。

注：而google还开源了android、Chromium、Go、Javascript V8、protobuf、Bazel(编译工具)、Tesseract(OCR工具)……

2011年，Google启动了Google Brain，同时搞了第一代分布式机器学习框架DistBelief，约50个项目在用。之后搞了tensorlfow，将Inception Net从DistBelief迁移到tf后，有6倍的训练速度提升。截至2016年，Google内近2k个项目用了tf。

tf的一些特点：
+ 使用tf，不需要给大规模的模型训练和小规模的应用分别开发部署不同的系统，**避免了同时维护两套程序的成本。**
+ tf的计算可以表示为**有状态的数据流式图**，对于大规模的神经网络训练，可以简单地实现并行计算，同时使用**不同的硬件资源**进行训练，**同步或异步**地更新**全局共享**的模型**参数和状态**。
+ **串行改并行**的改造成本非常低。
+ 前端支持py、cxx、go、java等语言，后端使用cxx、cuda。
+ 除了ml/dl，tf抽象的数据流式图也可以应用在**通用数值计算和符号计算**上（如分形图计算或者偏微分方程数值求解）

## 2. 编程模型简介

### 2.1 核心概念

tf中的计算可以表示为有向图（directed graph）或计算图（computation graph）。

每个运算操作是一个节点，节点间的连接是边。

**每个节点可以有任意多的输入和输出**，节点可以算作运算操作的实例化（instance）。在边中流动的数据称为张量（tensor）。**tensor的数据类型，可以一开始定义好，也可以通过计算图的结构推断得到。**

**没有数据流动**的特殊的边：依赖控制（control dependencies），作用是起始节点执行完再执行目标节点，例如控制内存使用的最高峰值。

示例：

![](../assets/tf step by step/chap1/computation graph.jpg)


### 2.2 实现原理

### 2.3 拓展功能

### 2.4 性能优化

哈哈