##################################################################
# Data 2022/04/21
# Author Fei Li
#E-mail l0714c1114ftt0010@petalmail.com
# criclize photo
##################################################################
# 加载R包
library(tidyverse)
library(countrycode)
library(circlize)
library(ggplot2)
library(cowplot)
library(grid)
library(ggplotify)

# 加载数据
df <- readr::read_csv(file.choose())

# 选择标签
top_countries <- c("Germany","Italy","Spain","Poland","United 
                   Kingdom","Romania","Belgium","France",
                   "Netherlands (the)","Austria" ,"Luxembourg",
                   "Lithuania","Czechia")

# 数据清洗
data <- df%>%
  mutate(
    to= countrycode(receiving_country_code, origin="iso2c", 
                    destination="iso.name.en"),
    from= countrycode(sending_country_code , origin="iso2c", 
                      destination="iso.name.en"))%>%
  mutate(
    to = replace(to, receiving_country_code=="UK","United Kingdom"),
    from = replace(from, sending_country_code=="UK","United 
                   Kingdom"), 
    to = replace(to, receiving_country_code=="EL","Greece"),
    from = replace(from, sending_country_code=="EL","Greece")
  )%>%
  group_by(from, to)%>%
  summarise(value=sum(participants))%>%
  arrange(-value)

# 提取部分数据
chord_data <- data%>%
  filter(from!=to)%>%
  filter(from %in% top_countries & to %in% top_countries)%>%
  arrange(-value)
chord_data[chord_data=="Netherlands (the)"]<-"Netherlands"

# 定义颜色
pal <- c("#002765","#0061fd","#1cc6ff","#00b661","#5bf34d",
         "#ffdd00","#ff7d00","#da2818","#ff006d","#8f00ff",
         "#453435","black","grey80")

# 绘制circlize图
chordDiagram(chord_data, grid.col = pal)

# 转化为gg格式
p <- recordPlot()
as.ggplot(ggdraw(p))+
  theme(text=element_text(family="Arial"),
        plot.margin   =margin(t=20))
