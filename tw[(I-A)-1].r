tw[(I-A0-1].r


# 調用 XLConnect 套件包，讀入產業關聯程度表 xls 檔案之項目名稱及數值內容。
library(XLConnect)
wb <- loadWorkbook("./datafile/misc/F1005203.xls", create = FALSE)
item <- readWorksheet(object = wb, sheet = 1, region ='B3:B54', header = FALSE)
item <- unclass(item) # 將數據框改為列表。
item <- unlist(item) # 將列表改為向量。
iot <- readWorksheet(object = wb, sheet = 1, region = 'C3:BB54', header = FALSE)
iot <- as.matrix(iot) # 將數據框改為矩陣。
# 將項目名稱指派為產業關聯程度表的橫排名稱與直欄名稱。
rownames(iot) <- item; colnames(iot) <- item
iot.log <- log(iot)

# 調用 pheatmap 套件包，用於繪製熱圖。
library(pheatmap)
png(file="IOT[(I-A)-1].png",width=1280,height=720)
pheatmap(mat = iot.log,  
         cluster_rows = FALSE, cluster_cols = FALSE, 
         legend = FALSE, main = "產業關聯程度熱圖",
         fontsize = 11, display_numbers = FALSE,
         cellwidth = 11, cellheight = 11)
dev.off()

# ============================================


# 將「產業關聯程度表(I-A)-1」之網絡位置，指派至一變項。
# datapath <- "https://www.dgbas.gov.tw/public/data/dgbas03/bs6/BOOK100/F1005203.xls"
# datapath <- "/datafile/F1005203.csv"
setwd("/datafile")
data00 <- read.csv("F1005203.csv", stringsAsFactors = FALSE)
# 讀入上表，取出該表各產業別清單，指派為一向量。
# sectorname <- readWorksheetFromFile(datapath, sheet =1, header = FALSE, startCol = 2, endcol =2, startRow = 3, endRow =55)

# 讀入同表數據（不含直欄及橫排之合計值），指派至一矩陣。
# datamatrix <- readWorksheetFromFile(datapath, sheet =1, header = FALSE, startCol = 3, endcol = 54, startRow = 3, endRow =54)
# data00 <- read.csv(datapath, stringsAsFactors = FALSE)
data01 <- as.matrix(as.numeric(data00[(2:53),(3:54)]))
# dim(data01) <- c(52, 52)

test <- data00[(2:53),(3:54)]
test <- as.matrix(test)
test <- as.numeric(test)
dim(test) <- c(52, 52)
heatmap.2(test)

datatest <- data01[(1:10), (1:10)]

# 將各產業別名稱，設為前揭數據矩陣之直欄與橫排名稱，但不含最末之合計。
# colnames(datamatrix) <- sectorname[-length(sectorname)]
# rownames(datamatrix) <- sectorname[-length(sectorname)]

# 調用 gplots 套件包
library(gplots)
heatmap.2(data01)
heatmap.2(datatest)


# 調用 d3heatmap 套件包
# library(d3heatmap)
# d3heatmap(datamatrix)





------------------------------------------------------

台灣景氣指標查詢系統
http://index.cepd.gov.tw/n/zh_tw




Credit Rating for countries
http://www.tradingeconomics.com/country-list/rating

d3heatmap

You can easily customize the colors using the colors parameter. This can take an RColorBrewer palette name, a vector of colors, or a function that takes (potentially scaled) data points as input and returns colors.


Let’s modify the previous example by using the "Blues" colorbrewer palette, and dropping the clustering and dendrograms:

d3heatmap(nba_players, scale = "column", dendrogram = "none",
    color = "Blues")
d3heatmap

If you want to use discrete colors instead of continuous, you can use the col_* functions from the scales package.

d3heatmap(nba_players, scale = "column", dendrogram = "none",
    color = scales::col_quantile("Blues", NULL, 5))
d3heatmapThanks to integration with the dendextend package, you can customize dendrograms with cluster colors:

d3heatmap(nba_players, colors = "Blues", scale = "col",
    dendrogram = "row", k_row = 3)
d3heatmapFor issue reports or feature requests, please see our GitHub repo.

===============================================================
hec <- as.data.frame(xtabs(Freq ~ Hair + Eye, HairEyeColor))

hec%>%
  ggvis(~Hair, ~Eye, fill=~Freq) %>%
  layer_rects(width = band(), height = band()) %>%
  layer_text(
    x = prop("x", ~Hair, scale = "xcenter"),
    y = prop("y", ~Eye, scale = "ycenter"),
    text:=~Freq, fontSize := 20, fill:="white", baseline:="middle", align:="center") %>%
  scale_nominal("x", padding = 0, points = FALSE) %>%
  scale_nominal("y", padding = 0, points = FALSE) %>% 
  scale_nominal("x", name = "xcenter", padding = 1, points = TRUE) %>%
  scale_nominal("y", name = "ycenter", padding = 1, points = TRUE)


# Read three data sets in one from known positions
# dflist <- readWorksheetFromFile(
#   demoExcelFile,
#   sheet = c("FirstSheet","FirstSheet","SecondSheet"),header = TRUE,
#   startRow = c(2,2,3),startCol = c(2,5,2),endCol = c(5,8,6),endRow = c(9,15,153)
# )























