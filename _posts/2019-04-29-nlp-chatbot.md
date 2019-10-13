---
layout: post
category: "nlp"
title: "chatbot"
tags: [chatbot, 对话, CCPE, taskmaster-1, space fusion, style fusion, ]
---

目录

<!-- TOC -->

- [小冰](#%e5%b0%8f%e5%86%b0)
- [space fusion](#space-fusion)
- [style fusion](#style-fusion)

<!-- /TOC -->


[专栏 \| 聊天机器人：困境和破局](https://mp.weixin.qq.com/s?__biz=MzA3MzI4MjgzMw==&mid=2650761302&idx=3&sn=879c2289b422313908ca31214a5f96d1&chksm=871aac28b06d253ebc991f2f17ff2d508e213e09b97be0d0039ccd08b42db060278f751c24b4&mpshare=1&scene=1&srcid=0806FV1ysWjPk9GNKVFxYbGM&sharer_sharetime=1565082872880&sharer_shareid=8e95986c8c4779e3cdf4e60b3c7aa752&pass_ticket=Kz97uXi0CH4ceADUC3ocCNkjZjy%2B0DTtVYOM7n%2FmWttTt5YKTC2DQT9lqCel7dDR#rd)


[最新综述：对话系统之用户模拟器](https://mp.weixin.qq.com/s?__biz=MzIwMTc4ODE0Mw==&mid=2247498768&idx=1&sn=fcfe600c5424d0574bb2388bb84f6201&chksm=96ea2390a19daa86945c6770eae0d901461012a2d3f0db0e9d588b2890a4dc56cf0f44484065&mpshare=1&scene=1&srcid=&sharer_sharetime=1565003633118&sharer_shareid=8e95986c8c4779e3cdf4e60b3c7aa752&pass_ticket=Kz97uXi0CH4ceADUC3ocCNkjZjy%2B0DTtVYOM7n%2FmWttTt5YKTC2DQT9lqCel7dDR#rd)


[AI更懂人话：谷歌发布全新对话数据集，模仿智能助理](https://mp.weixin.qq.com/s/uI1yCNPN5eb1_cdB2RvT6g)

谷歌发布了Coached Conversational Preference Elicitation（CCPE）和Taskmaster-1 对话数据集，在设计中独特地模仿当今基于语音的数字助理，在自动化系统的环境中保留口语对话的特征。

## 小冰

[第七代微软小冰现身：史上最大升级，订制私人AI不是梦](https://mp.weixin.qq.com/s/h8kHxiJVb9TdVirPUiJmvg)

[DIY自己的AI助理，萝莉御姐暖男霸道总裁全凭你定义，微软小冰团队发布新框架](https://mp.weixin.qq.com/s/8l-MkmoeEqtK75P6CrpKBA)

[开放框架，进驻OV手机，五岁的微软小冰已经学会了养活自己](https://mp.weixin.qq.com/s/L_8Uj-LeJdGjc7Qsi1_PUA)


## space fusion

[Jointly optimizing diversity and relevance in neural response generation](https://arxiv.org/abs/1902.11205)

NACCL 2019

## style fusion

[节后收心困难？这15篇论文，让你迅速找回学习状态](https://mp.weixin.qq.com/s/aaz-s87vorroyepNCd9-AA)

[Structuring Latent Spaces for Stylized Response Generation](https://arxiv.org/abs/1909.05361)

[https://github.com/golsun/StyleFusion](https://github.com/golsun/StyleFusion)

本文是微软发表于 EMNLP 2019 的工作，这是 SpaceFusion  的后续之作。SpaceFusion 尝试将对话系统中的 source 和 target 映射到同一隐空间上，从而转换生成对话的问题成为生成隐空间向量的问题。本文（StyleFusion）进一步将额外的风格化文本的特征迁移到生成回复中，从而达到对话个性化和风格化的效果。在若干标准数据集上取得了很好的效果。

