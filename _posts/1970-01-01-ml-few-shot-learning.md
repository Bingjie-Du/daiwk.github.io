---
layout: post
category: "ml"
title: "few-shot learning"
tags: [few-shot, fewshot, 小样本, ]

---

目录

<!-- TOC -->


<!-- /TOC -->

参考[小样本学习（Few-shot Learning）综述](https://mp.weixin.qq.com/s?__biz=MzA3MzI4MjgzMw==&mid=2650759590&idx=3&sn=d7573d59fdffae5fc7bb83ea77a26fa6&chksm=871aa5d8b06d2cce197f93547df18d412c173dcb2149f31797c1c9fbea2ec7948f6b1100ab3e&mpshare=1&scene=1&srcid=0429y1qxBdLrdZ8C5KgRqP0e&pass_ticket=ZltpB2rBQ1hXYEBIClPX5yEh187BJtWG0mhs8mqho%2F%2FHR%2BUZZqkJ8efTvcnsT5KF#rd)

参考[Few-shot Learning: A Survey](https://arxiv.org/pdf/1904.05046.pdf)

关于meta learning，可以参考[https://daiwk.github.io/posts/dl-meta-learning.html](https://daiwk.github.io/posts/dl-meta-learning.html)

Few-shot Learning 是 Meta Learning 在**监督学习**领域的应用

Meta Learning，又称为learning to learn，在meta training阶段将数据集分解为不同的**meta task**，去学习类别变化的情况下模型的泛化能力，在**meta testing**阶段，面对全新的类别，**不需要变动已有的模型**，就可以完成分类。

few-shot的训练集中包含了很多的类别，每个类别中有多个样本。在训练阶段，会在训练集中随机抽取C个类别，每个类别K个样本（总共CK个数据），构建一个 meta-task，作为模型的支撑集（support set）输入；再从这 C 个类中剩余的数据中抽取一批（batch）样本作为模型的预测对象（batch set）。即要求模型从 C*K 个数据中学会如何区分这 C 个类别，这样的任务被称为 C-way K-shot 问题。


