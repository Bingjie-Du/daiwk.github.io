pandoc -N -s --toc --smart --latex-engine=xelatex -V CJKmainfont='微软雅黑' -V mainfont='Times New Roman' -V geometry:margin=1in ./assets/int.md -o ./assets/int.pdf
pandoc -N -s --toc --smart --latex-engine=xelatex -V CJKmainfont='微软雅黑' -V mainfont='Times New Roman' -V geometry:margin=1in ./assets/int-ml.md -o ./assets/int-ml.pdf
