---
layout: post
category: "knowledge"
title: "tf安装"
tags: [tf安装, ]
---

目录

<!-- TOC -->

- [装备工作](#装备工作)
    - [bazel](#bazel)
    - [jdk1.8](#jdk18)
- [源码安装](#源码安装)
    - [clone](#clone)
    - [configure](#configure)
    - [生成pip_package](#生成pip_package)
        - [仅cpu](#仅cpu)
        - [gpu](#gpu)
    - [生成whl](#生成whl)
    - [安装c++库](#安装c库)
        - [手动下载依赖库](#手动下载依赖库)
        - [重新configure](#重新configure)
        - [编译cc的so](#编译cc的so)
        - [拷贝所需头文件](#拷贝所需头文件)
        - [拷贝所需lib文件](#拷贝所需lib文件)

<!-- /TOC -->

## 装备工作

### bazel

### jdk1.8

## 源码安装

### clone

```shell
git clone https://github.com/tensorflow/tensorflow 
```

### configure

```shell
./configure
```

注意，这里可以配置默认python路径

### 生成pip_package

#### 仅cpu

```shell
bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
```

#### gpu

```shell
bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
```

### 生成whl

```shell
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
```

这样，就在```/tmp/tensorflow_pkg```生成了```tensorflow-xxxx-py2-none-any.whl```

### 安装c++库

参考：

[https://github.com/hemajun815/tutorial/blob/master/tensorflow/compilling-tensorflow-source-code-into-C++-library-file.md](https://github.com/hemajun815/tutorial/blob/master/tensorflow/compilling-tensorflow-source-code-into-C++-library-file.md)

#### 手动下载依赖库

进入目录：

```shell
cd tensorflow/contrib/makefile
```

执行文件：

```shell
sh -x ./build_all_linux.sh
```

注意：

必要时修改```download_dependencies.sh```文件：

+ curl需要支持https(可以升级)，比如，我们发现jumbo的curl是符合预期的，那可以在```build_all_linux.sh```一开头就加上```export PATH=~/.jumbo/bin/:$PATH```
+ wget加上```--no-check-certificate```参数，还有```--secure-protocol=TLSv1.2 ```参数，当然如果版本不够高就升级wget。如果不好升级可以做如下改动：

把

```shell
wget -P "${tempdir}" "${url}"
```

改成

```shell
curl -Ls "${url}" > "${tempdir}"/xxx
```

#### 重新configure

```shell
cd tensorflow
./configure
```

#### 编译cc的so

```shell
cd tensorflow
bazel build :libtensorflow_cc.so
```

产出在```bazel-bin/tensorflow/libtensorflow_cc.so```

#### 拷贝所需头文件

```shell
mkdir /usr/local/tensorflow/include
cp -r tensorflow/contrib/makefile/downloads/eigen/Eigen /usr/local/tensorflow/include/
cp -r tensorflow/contrib/makefile/downloads/eigen/unsupported /usr/local/tensorflow/include/
cp -r tensorflow/contrib/makefile/gen/protobuf/include/google /usr/local/tensorflow/include/
cp tensorflow/contrib/makefile/downloads/nsync/public/* /usr/local/tensorflow/include/
cp -r bazel-genfiles/tensorflow /usr/local/tensorflow/include/
cp -r tensorflow/cc /usr/local/tensorflow/include/tensorflow
cp -r tensorflow/core /usr/local/tensorflow/include/tensorflow
mkdir /usr/local/tensorflow/include/third_party
cp -r third_party/eigen3 /usr/local/tensorflow/include/third_party/
```

#### 拷贝所需lib文件

```shell
mkdir /usr/local/tensorflow/lib
cp bazel-bin/tensorflow/libtensorflow_*.so /usr/local/tensorflow/lib
```
