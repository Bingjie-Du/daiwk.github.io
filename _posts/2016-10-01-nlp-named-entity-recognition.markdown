---
layout: post
category: "nlp"
title: "命名实体识别"
tags: [nlp, 命名实体识别, ner, named entity recognition]
---

详见《统计自然语言处理(第二版)》p150-162

# **1. 方法概述**
 
## **1.1 基本概念**
 
实体概念在文本中的引用（entity mention，即“指称项”）有三种形式：

+ **命名性指称**：例如，乔丹、麦迪。
+ **名词性指称**：例如，中国国家男足主教练、xx学生会主席。
+ **代词性指称**：例如，他、她。

MUC-6最早提出命名实体（named entity），当时关注的焦点是information extraction，即从报章等非结构化文本中抽取关于公司活动和国防相关活动的结构化信息，而**人名、地名、组织机构名、时间和数字表达（时间、日期、货币量和百分数等）**是结构化信息的关键内容。 
相关的评测会议还有CoNLL(Conference on Computational Natural Language Learning)、ACE和IEER(Information Extraction-Entity Recognition Evaluation)。
MUC-6关注人名、地名（细化为城市、州和国家）、组织机构名。CoNLL扩大了专有名词的范围，包含产品名的识别。其他研究工作中也涉及了电影名、书名、项目名、研究领域名、电子邮件地址、电话号码等，还有生物信息学领域的专有名词等。本文主要关注**人名、地名和组织机构名**三类专有名词的识别方法。

## **1.2 基于统计模型的命名实体识别方法归纳**

大致分类如下：

<html>
<center>
<table border="2" cellspacing="0" cellpadding="6" rules="all" frame="border">

<thead>
<tr>
<th scope="col" class="left">类型</th>
<th scope="col" class="left">采用的模型或方法</th>
</tr>
</thead>

<tbody>
<tr>
<td class="left">有监督</td>
<td class="left">隐马尔科夫模型或语言模型<br>最大熵模型<br>支持向量机<br>条件随机场<br>决策树<br></td>
</tr>
<tr>
<td class="left">半监督/弱监督</td>
<td class="left">利用标注的小数据集（种子数据）自举（bootstrap）学习</td>
</tr>
<tr>
<td class="left">无监督</td>
<td class="left">利用词汇资源（如WordNet）进行上下文聚类</td>
</tr>
<tr>
<td class="left">混合方法</td>
<td class="left">集中模型相结合或利用统计方法和人工总结的知识库</td>
</tr>

</tbody>
</table></center>
</html>

# 2. 基于CRF的命名实体识别方法

基本思路（以汉语为例）：
将给定的文本首先进行**分词**处理，然后对**人名、简单地名和简单的组织机构名** 进行识别，最后识别**复合地名和复合组织机构名**。
简单地名如北京、大不列颠；复合地名：北京市海淀区中关村xx路、中华人民共和国；简单组织机构名：北京大学、卫生部、联合国；复合组织机构名：欧洲中央银行、中华人民共和国卫生部、联合国世界粮食计划署。
由于基于CRF的命名实体识别属于有监督的学习方法，因此需要使用已标注的大规模语料，例如北京大学计算语言学研究所标注的现代汉语多级加工语料【[现代汉语多级加工语料库](http://klcl.pku.edu.cn:8088/qt/info!input.action?id=4#1)】。还有一个在线的资源[北大的CCL](http://ccl.pku.edu.cn/corpus.asp)。
