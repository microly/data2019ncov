# data2019ncov：武汉肺炎（2019-nCoV）数据的R语言接口

## 数据源
武汉肺炎（2019-nCoV）历史数据来源：https://gitlab.com/wybert/open-2019-ncov    （数据存在部分缺失，具体事宜请联系数据提供者。）

地图数据来源：http://datav.aliyun.com/tools/atlas

## 我的工作：
1.从上述肺炎数据源获取省级病例数据属性表，链接在省级数据地图上，返回sf对象。

2.从上述肺炎数据源获取城市粒度的空间点位数据，汇总在地级市数据地图上，返回sf对象。

## 安装：
```r
# install.packages("devtools")
devtools::install_github("microly/data2019ncov")
```

## 使用方法：
```r
library(data2019ncov)
library(sf) # I am sorry that you have to attach the sf package manually. I will handle this problem later.

# get the 2019-nCov data at provincial level at the time: 2:00, January 29.
sf_provice(month = 1, day = 29, hour = 2)

# get the 2019-nCov data at the prefecture city level at the time: 2:00, January 29.
sf_prefecture_city(month = 1, day = 29, hour = 2)
```
