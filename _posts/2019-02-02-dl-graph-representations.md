---
layout: post
category: "dl"
title: "graph represention"
tags: [graph representation, ]
---

*目录

目录
{:toc #markdown-toc}

```shell
<!-- TOC -->

- [Introduction](#introduction)
- [Node Representation Learning](#node-representation-learning)
    - [Node Representation Methods](#node-representation-methods)
        - [LINE](#line)
            - [一阶相似度](#一阶相似度)
            - [二阶相似度](#二阶相似度)
            - [优化trick](#优化trick)
            - [讨论](#讨论)
            - [实验](#实验)
        - [DeepWalk](#deepwalk)
        - [Node2vec](#node2vec)
    - [Graph and High-dimensional Data Visualization](#graph-and-high-dimensional-data-visualization)
        - [t-SNE](#t-sne)
        - [Visualizing Large-scale and High-dimensional Data](#visualizing-large-scale-and-high-dimensional-data)
            - [Learning the Layout of KNN Graph](#learning-the-layout-of-knn-graph)
            - [A Probabilistic Model for Graph Layout](#a-probabilistic-model-for-graph-layout)
    - [Knowledge Graph Embedding](#knowledge-graph-embedding)
    - [A High-performance Node Representation System](#a-high-performance-node-representation-system)
- [Graph Neural Networks](#graph-neural-networks)
    - [Graph Convolutional Networks](#graph-convolutional-networks)
    - [Graph Convolutional Networks](#graph-convolutional-networks-1)
    - [GraphSAGE](#graphsage)
    - [Gated Graph Neural Networks](#gated-graph-neural-networks)
    - [Graph Attention Networks](#graph-attention-networks)
    - [Subgraph Embeddings](#subgraph-embeddings)
- [Deep Generative Models for Graph Generation](#deep-generative-models-for-graph-generation)
    - [Variational Autoencoders (VAEs)](#variational-autoencoders-vaes)
    - [Generative Adversarial Networks (GANs)](#generative-adversarial-networks-gans)
    - [Deep Auto-regressive Models](#deep-auto-regressive-models)

<!-- /TOC -->

```

参考AAAI2019的tutorial：[AAAI2019《图表示学习》Tutorial, 180 页 PPT 带你从入门到精通（下载）](https://mp.weixin.qq.com/s?__biz=MzI3MTA0MTk1MA==&mid=2652037887&idx=4&sn=730e6bd0cce6c3e40f4aec2de190f99d&chksm=f121960ec6561f1842640aff963fbe609e52fdd695386a442a9726016551c0a3697a196fd5a1&mpshare=1&scene=1&srcid=0202IYksgop7SmowGXrFkpMV&pass_ticket=IHFhi51iDztgrpluZGaofR7zoGSfaB%2F4Y6iACEc6lvxZ3KgGvbkA%2Fhp2MAVH09RS#rd)

ppt下载：[https://pan.baidu.com/s/1hRjm1nbMcj4_ynZ0niE2JA](https://pan.baidu.com/s/1hRjm1nbMcj4_ynZ0niE2JA)

传统的机器学习方法依赖于用户定义的启发式模型来提取关于图的结构信息的特征编码 (例如，degree statistics或核函数)。然而，近年来，使用基于深度学习和非线性降维的技术，自动学习将**图结构**编码为**低维embedding**的方法激增。

## Introduction

graph的几大传统ml任务：

+ **Node classification**：预测给定的结点的type
+ **Link prediction**：预测两个结点是否有边相连
+ **Community detection**：发现联系紧密的nodes的clusters
+ **Network similarity**：两个（子）网是否相似

目前的深度学习：

+ cnn：固定大小的图片/网格
+ rnn/w2v：文本/序列

图更加复杂：

+ 复杂的拓扑结构（例如，不像网格那样有spatial locality(空间局部性，在最近的将来将用到的信息很可能与现在正在使用的信息在**空间地址上是临近的**。)）
+ 没有固定的结点顺序或者参考点（reference point）(例如，isomorphism（同构）问题)
+ 经常是动态的并且有multimodal（多模态）的features

## Node Representation Learning

### Node Representation Methods

问题定义：给定`\(G=(V,E,W)\)`，其中，`\(V\)`是结点集合，`\(E\)`是边的集合，`\(W\)`是**边**的权重集合。所谓的node embedding就是对结点`\(i\)`学习一个向量`\(u_i\in R^d\)`。

相关工作：

+ 传统graph embedding算法：MDS, IsoMap, LLE, Laplacian Eigenmap, ...。缺点：hard to scale up
+ Graph factorization(Ahmed et al. 2013)：只适用于无向图，并非专门为网络表示而设计
+ Neural word embeddings(Bengio et al. 2003)：Neural language model；word2vec (skipgram), paragraph vectors, etc.

#### LINE

WWW2015上的[LINE: Large-scale Information Network Embedding](http://www.www2015.it/documents/proceedings/proceedings/p1067.pdf)

LINE代码（c++）：[https://github.com/tangjianpku/LINE](https://github.com/tangjianpku/LINE)

特点：

+ 任意类型的网络（有向图、无向图、有/无权重）
+ 明确的目标函数（一阶和二阶相似性（first/second proximity））
+ 可扩展性
    + 异步sgd
    + 百万级的结点和十亿级别的边：单机数小时

##### 一阶相似度

**First-order Proximity（一阶相似度）**：两个**顶点之间**的**自身**相似（不考虑其他顶点）。因为有些结点的link并没有被观测到，所以一阶相似度不足以保存网络结构。

分布：(定义在**无向**边`\(i-j\)`上)

一阶相似度的经验分布：

`\[
\hat{p_1}(v_i,v_j)=\frac{w_{ij}}{\sum_{(m,n)\in E}w_{mn}}
\]`

一阶相似度的模型分布：

`\[
p_1(v_i,v_j)=\frac{\exp(\vec{u_i}^T\vec{u_j})}{\sum_{(m,n)\in V\times V}\exp(\vec{u_m}^T\vec{u_n})}
\]`

其中，`\(\vec{u_i}\)`是节点`\(i\)`的embedding，其实就是sigmoid：

`\[
p_1(v_i,v_j)=\frac{1}{1+\exp(-\vec{u_i}^T\vec{u_j})}
\]`

目标函数是**KL散度**：

`\[
O_1=KL(\hat{p_1},p_1)
\]`

干掉常量`\(\sum_{(m,n)\in E}w_{mn}\)`，还有`\(\sum _{(i,j)\in E}w_{ij}\log w_{ij}\)`之后：

`\[
O_1=\sum _{(i,j)\in E}w_{ij}\log w_{ij}-\sum _{(i,j)\in E}w_{ij}\log p_1(v_i,v_j)\approx -\sum _{(i,j)\in E}w_{ij}\log p_1(v_i,v_j)
\]`

只考虑一阶相似度的情况下，改变同一条边的方向对于最终结果没有什么影响。因此一阶相似度只能用于**无向图**，不能用于有向图。

##### 二阶相似度

**Second-order Proximity（二阶相似度）**：网络中一对顶点`\((u,v)\)`之间的二阶相似度是它们**邻近网络结构**之间的相似性。

分布：(定义在**有向**边`\(i\rightarrow j\)`上)

邻近网络的经验分布：

`\[
\hat{p_2}(v_j|v_i)=\frac{w_{ij}}{\sum_{k\in V}w_{ik}}
\]`

邻近网络的模型分布，其中，`\(u_i\)`是`\(v_i\)`被视为顶点时的表示，`\(u'_i\)`是`\(v_i\)`被视为"context"时的表示：

`\[
p_2(v_j|v_i)=\frac{\exp(\vec{u'_j}^T\vec{u_i})}{\sum_{k\in V}\exp(\vec{u'_k}^T\vec{u_i})}
\]`

目标函数是**KL散度**：

`\[
O_2=\sum_i KL(\hat{p_2}(\cdot |v_i),p_2(\cdot|v_i))=-\sum _{(i,j)\in E}w_{ij}\log p_2(v_j|v_i)
\]`

##### 优化trick

+ sgd+negative sampling：随机sample一条边，以及多个negative的边

例如针对二阶的，对每条边`\((i,j)\)`来说，它的目标函数就是：

`\[
\log \sigma(\vec{u'_j}^T\vec{u'_i})+\sum ^K_{i=1}E_{v_n\sim P_n(v)}[\log \sigma (-\vec{u'_n}^T\vec{u_i})]
\]`

其中`\(\sigma(x)=1/(1+\exp(-x))\)`，设置`\(P_n(v)\propto d_v^{3/4}\)`，其中`\(d_v\)`是节点的出度（即`\(d_i=\sum _{k\in N(i)}w_{ik}\)`，其中`\(N(i)\)`是`\(v_i\)`的为起点的邻居的集合）。

针对一阶的，把上面式子里的第一项里的`\(\vec{u'_j}^T\)`换成`\(\vec{u_j}^T\)`就行啦~

+ 边`\((i,j)\)`的embedding的梯度：

`\[
\frac{\partial O_2}{\partial \vec{u_i}}=w_{ij}\frac{\partial \log \hat{p_2}(v_j|v_i)}{\partial \vec{u_i}}
\]`

+ 当边的权重方差很大的时候，从上式可知，目标函数的梯度是`\(p_2\)`的梯度再乘以边权重，所以目标函数的梯度的方差也会很大，这样会有问题。
+ 解决方法：**edge sampling**：根据边的权重来采样边，然后把采样到的边当成binary的，也就是把每条边的权重看成一样的！(例如一个边的权重是`\(w\)`，那么拆成`\(w\)`条binary的边)
+ 复杂度：`\(O(d\times K \times |E|)\)`：`\(d\)`是embedding的维数，`\(K\)`是负样本的个数，`\(|E|\)`是边的总数

##### 讨论

+ 对只有少量邻居的节点（low degree vertices）进行embed：
    + 通过增加高阶邻居来扩展邻居
    + BFS(breadth-first search)，使用广度优先搜索策略扩展每个顶点的邻域，即递归地添加邻居的邻居
    + 在大部分场景下，只增加二阶邻居就足够了
+ 对新节点进行emb（如果新节点和已有节点有边相连，可以如下方式来搞；否则，future work...）:
    + 保持现有节点的embedding不变
    + 根据新节点的embedding求经验分布和模型分布，从而优化目标函数 w.r.t. 新node的embedding

所以，对于新节点`\(i\)`，直接最小化如下目标函数：

`\[
-\sum_{j\in N(i)}w_{ji}\log p_1(v_j,v_i)
\]`

或者

`\[
-\sum _{j\in N(i)}w_{ji}\log p_2(v_j|v_i)
\]`

##### 实验

LINE(1st)只适用于无向图，LINE(2nd)适用于各种图。

LINE (1st+2nd)：同时考虑一阶相似度和二阶相似度。将由LINE（1st）和LINE（2nd）学习得到的两个向量表示，**连接成一个更长的向量**。在连接之后，对维度**重新加权**以**平衡两个表示**。因为在无监督的任务中，设定权重很困难，所以**只应用于监督学习**的场景。

更适合的方法是共同训练一阶相似度和二阶相似度的目标函数，比较复杂，文章中没有实现。

#### DeepWalk

KDD14上的[DeepWalk: Online Learning of Social Representations](http://www.perozzi.net/publications/14_kdd_deepwalk.pdf)

使用学习word representation的方法来学习node representation（例如skip gram）

将网络上的随机游走视为句子。

分成两步：

+ 通过随机游走生成结点的context
+ 预测周围的节点:

`\[
p(v_j|v_i)=\frac{\exp(\vec{u'_i}^T \vec{u_j})}{\sum _{k\in V}\exp(\vec{u'_k}^T\vec{u_i})}
\]`

#### Node2vec

KDD16上的[node2vec: Scalable Feature Learning for Networks](https://cs.stanford.edu/people/jure/pubs/node2vec-kdd16.pdf)

通过如下混合策略去寻找一个node的context：

+ Breadth-firstSampling(BFS): homophily（同质性）
+ Depth-firstSampling(DFS): structuralequivalence（结构等价）

使用带有参数`\(p\)`和`\(q\)`的**Biased Random Walk**来进行context的扩展，在BFS和DFS中达到一个平衡，同时考虑到微观局部(BFS)和宏观全局(DFS)的信息，并且具有很高的适应性：

+ `\(p\)`：Return parameter，控制在walk的过程中，**revisit**一个节点的概率，对应BFS
+ `\(q\)`：In-out parameter，控制探索"**outward**"节点的概率，对应DFS
+ 在有标签的数据上，用**cross validation**来寻找最优的`\(p\)`和`\(q\)`

<html>
<br/>
<img src='../assets/node2vec.png' style='max-height: 100px'/>
<br/>
</html>

刚从edge`\(t,v)\)`过来，现在在节点`\(v\)`上，要决定下一步`\((v,x)\)`怎么走：

`\[
\alpha _{pq}(t,x)=\left\{\begin{matrix}
\frac{1}{p}&if\ d_{tx}=0\\ 
1 &if\ d_{tx}=1\\ 
\frac{1}{q}&if\ d_{tx}=2
\end{matrix}\right.
\]`

其中的`\(d_{tx}\)`表示节点`\(t\)`到节点`\(x\)`间的最短路径：

+ 为0表示回到节点`\(t\)`本身
+ 为1表示节点`\(t\)`和节点`\(x\)`直接相连，但上一步却选择了节点`\(v\)`
+ 为2表示节点`\(t\)`和`\(x\)`不直接相连，但节点`\(v\)`和节点`\(x\)`直接相连

最简单的给random walk加上bias的方法就是转移概率`\(\pi _{vx}=w_{vx}\)`，而我们的方法就是`\(\pi _{vx}=\alpha _{pq}(t,x)w_{vx}\)`，相当于还考虑了跳到`\(v\)`之前的节点`\(t\)`。

优化目标和LINE的**一阶相似度**类似

LINE、DeepWalk、Node2vec的对比：

<html>
<center>
<table border="2" cellspacing="0" cellpadding="6" rules="all" frame="border">

<thead>
<tr>
<th scope="col" class="left">algorithm</th>
<th scope="col" class="left">neighbor expansion</th>
<th scope="col" class="left">proximity</th>
<th scope="col" class="left">optimization</th>
<th scope="col" class="left">validation data</th>
</tr>
</thead>

<tbody>
<tr>
<td class="left">LINE</td>
<td class="left">BFS</td>
<td class="left">1st or 2nd</td>
<td class="left">negative sampling</td>
<td class="left">No</td>
</tr>
<tr>
<td class="left">DeepWalk</td>
<td class="left">Random</td>
<td class="left">2nd</td>
<td class="left">hierarchical softmax</td>
<td class="left">No</td>
</tr>
<tr>
<td class="left">Node2vec</td>
<td class="left">BFS+DFS</td>
<td class="left">1st</td>
<td class="left">negative sampling</td>
<td class="left">Yes</td>
</tr>

</tbody>
</table></center>
</html>

node representation的应用：

+ Node **classification** (Perozzi et al. 2014, Tang et al. 2015a, Grover et al. 2015 )
+ Node **visualization** (Tang et al. 2015a)
+ **Link** prediction (Grover et al. 2015)
+ **Recommendation** (Zhao et al. 2016)
+ **Text** representation (Tang et al. 2015a, Tang et al. 2015b)

node representation的扩展：

+ Leverage **global structural information** (Cao et al. 2015)
+ Non-linear methods based on **autoencoders** (Wang et al. 2016) • Matrix-factorization based approaches (Qiu et al. 2018)
+ **Directed** network embedding (Ou et al. 2016)
+ **Signed** network embedding (Wang et al. 2017)
+ **Multi-view** networks ( Qu and Tang et al. 2017)
+ Networks with **node attributes** (Yang et al. 2015)
+ **Heterogeneous(异构)** networks (Chang et al. 2015)
+ **Task-specific** network embedding (Chen et al. 2017)

### Graph and High-dimensional Data Visualization

largevis代码（c++&python）：[https://github.com/lferry007/LargeVis](https://github.com/lferry007/LargeVis)

#### t-SNE

高维数据可视化的一个state-of-the-art的方法，tensorboard就用的这个。

缺点：

+ K-NNG(K-Nearest Neighbor Graph) construction: 复杂度是`\(O(NlogN)\)`，假设图中有`\(N\)`个数据点
+ Graph layout: 复杂度是`\(O(NlogN)\)`
+ 对参数非常敏感（Very sensitive parameters）

#### Visualizing Large-scale and High-dimensional Data

www16的best paper提名[Visualizing Large-scale and High-dimensional Data](https://arxiv.org/abs/1602.00370)

特点：

+ K-NNG construction的高效近似：
    + 比t-SNE的速度快30倍（300w的数据点）
    + 更好的time-accuracy tradeoff
+ graph layout的高效的probabilistic model
    + 从`\(O(NlogN)\)`到`\(O(N)\)`
    + 比t-SNE快7倍（300w的数据点）
    + 更好的visualization layouts
    + 在不同数据集间有更stable的参数

##### Learning the Layout of KNN Graph

+ 保持2D/3D空间的节点的相似度
    + 对每个节点使用一个2D/3D的向量来表示
    + 保持相似的数据距离近而不相似的距离远
+ 观测节点`\((i,j)\)`间的一条**binary**的边的概率：

`\[
p(e_{ij}=1)=\frac{1}{1+\begin{Vmatrix}
\vec{y_i}-\vec{y_j}
\end{Vmatrix}^2}
\]`

+ 观测节点`\((i,j)\)`间的一条**有权重**的边的likelihood：

`\[
p(e_{ij}=w_{ij})=p(e_{ij}=1)^{w_{ij}}
\]`

##### A Probabilistic Model for Graph Layout

目标函数：

`\[
O=\prod _{(i,j)\in E}p(e_{ij}=w_{ij})\prod _{(i,j)\in \bar{E}}(1-p(e_{ij}=w_{ij})^{\gamma }
\]`

其中`\(\gamma\)`是给**negative edge**赋值的**unified weight**

+ 随机sample一些negative edges
+ 使用异步sgd来优化
+ 时间复杂度：与数据点数是**线性**关系

### Knowledge Graph Embedding

知识图谱是异构图，有多种类型的relations

用(head entity, relation, tail entity)来表示facts的集合

related works：

+ 将entities用embeddings来表示
+ 将relations用embeddings或者matrices来表示

<html>
<br/>
<img src='../assets/knowledge-graph-embedding.png' style='max-height: 300px'/>
<br/>
</html>



### A High-performance Node Representation System

RotatE代码（pytorch）:[https://github.com/DeepGraphLearning/KnowledgeGraphEmbedding]



## Graph Neural Networks

### Graph Convolutional Networks

### Graph Convolutional Networks

### GraphSAGE

### Gated Graph Neural Networks

### Graph Attention Networks

### Subgraph Embeddings

## Deep Generative Models for Graph Generation

### Variational Autoencoders (VAEs)

### Generative Adversarial Networks (GANs)

### Deep Auto-regressive Models




