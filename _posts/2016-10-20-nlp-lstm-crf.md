---
layout: post
category: "nlp"
title: "lstm crf"
tags: [nlp, natural language processing, lstm crf, lstm, crf]
---

# **1. 【2015】Bidirectional LSTM-CRF Models for Sequence Tagging**

[论文地址](../assets/Bidirectional LSTM-CRF Models for Sequence Tagging.pdf)

# **2. 【2016】Conditional Random Fields as Recurrent Neural Networks**

[论文地址](../assets/Conditional Random Fields as Recurrent Neural Networks.pdf)

# **3. 在paddlepaddle上实现**

需要参考seq2seq的demo：[http://www.paddlepaddle.org/doc/demo/text_generation/text_generation.html](http://www.paddlepaddle.org/doc/demo/text_generation/text_generation.html)

先来了解一下seq2seq：
首先，拿到的数据是这样的（法语->英语,wmt14数据集）：

![](../assets/wmt14 directory.JPG)

gen/test/train三个目录，每个下面有xx.src和xx.trg两个文件，一行是一句话，src和trg的相同行表示那句话对应的翻译是什么，所以，src和trg一样多行。

然后，需要进行预处理(-i INPUT: the path of input original dataset;-d DICTSIZE: the specified word count of dictionary, if not set, dictionary will contain all the words in input dataset;-m --mergeDict: merge source and target dictionary, thus, two dictionaries have the same context)

```shell
python preprocess.py -i data/wmt14 -d 30000
```

得到结果如下：

![](../assets/wmt14 preprocessed directory.JPG)

+ 其中，train/test/gen目录下是将原始数据的src和trg对应的行用\t连接起来生成的。
+ train/test/gen.list是上述三个目录对应文件的指针。
+ src/trg.dict是上述dict_size大小的字典，包括dict_size-3个高频词和3个特殊词：<s>（sequence的开头）<e>（sequence的结尾）<unk>（不在词典中的词）

```python

```
