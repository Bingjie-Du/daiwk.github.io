---
layout: post
category: "ml"
title: "svm理解"
tags: [svm理解, ]
---

参考 
**支持向量机通俗导论（理解SVM的三层境界）**：[http://blog.csdn.net/v_july_v/article/details/7624837](http://blog.csdn.net/v_july_v/article/details/7624837)

## 1. 最大间隔分类器

### 1.1 logistic regression

**0/1分类：** 给sigmoid之前的函数值`\(\theta^Tx\)`是负无穷到正无穷，sigmoid之后的值相当于取y=1时的概率值，大于0.5就视为1的类。如果`\(\theta^Tx>0\)`则`\(sigmoid(\theta^Tx)>0.5\)`，换言之，要学到参数`\(\theta\)`，使正例的的`\(\theta^Tx\)`远大于0，负例的`\(\theta^Tx\)`远小于0.

### 1.2 +1/-1分类

svm中，使用+1/-1分类，而非logistic regression的0/1分类。

`\[
g(w^Tx+b) =
\begin{cases}
+1, w^Tx+b >= 0 \\
-1, w^Tx+b < 0 \\
\end{cases}
\]`

