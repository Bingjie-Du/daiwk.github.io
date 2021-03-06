#!/usr/bin/env python
# -*- coding: gbk -*-
########################################################################
# 
# 
########################################################################
 
"""
File: gen_urls.py
Date: 2018/01/28 00:10:09
"""

import os

import sys

path = "./_posts/"
filelist = os.listdir(path)

url_txt = "./urls.txt"

with open(url_txt, 'wb') as fout:
    for file_name in filelist:
        if file_name.endswith(".md"):
            real_name = file_name[11:-3]
            url_name = "https://daiwk.github.io/posts/" + real_name + ".html\n"
            fout.write(url_name.encode("utf8"))
    new_url = "https://daiwk.github.io/tags.html" + "\n"
    fout.write(new_url.encode("utf8"))

