


# ================================================

# XLConnect, xlsx 套件包都安裝不上，只好改存為 cvs 檔再讀入，略去前三橫排、文字不轉為因子。
data00 <- read.csv("datafile/台灣1984年至2015年主要貨品外銷訂單金額.USD_M.csv", skip = 3, stringsAsFactors = FALSE)
# 第一橫排、最末三橫排及第二直欄為空白，刪除之。
data00 <- data00[c(-1, -34:-36),-2]
# 整理直欄名稱。
names(data00) <- gsub("\\.{2}", "", names(data00))
names(data00)[1] <- gsub("月別", "度", names(data00[1]))
# 刪除每個元素的撇節。
data00 <- as.data.frame(lapply(data00, function(x) gsub(",", "", x)), stringsAsFactors = FALSE)
# 刪除第一直欄代表年度的元素的「年」。
data00[1] <- unlist(lapply(data00[1], function(x) gsub("年", "", x)))
# 將數據框由文字型態改為數值型態。
data00 <- data.frame(lapply(data00, as.numeric))
# 將民國年度改為西元年度。
data00[1] <- data00[1] + 1911 
# 後續分析暫用不到總額數據，除去該欄另設一數據框。
data01 <- data00[-2]

# 由於後續使用 googleVis 在顯示中文上似有問題，先為直欄名稱設立一中英對照，再將欄名改為英文。
# NameList = data.frame(ChiName = names(data01), EngName = c("Year", LETTERS[1:(ncol(data01)-1)]))
# names(data01) <- NameList$EngName

# 以下計算年度各主要貨品之成長率。
tmp <- array(0, dim = c(nrow(data01), ncol(data01)-1))
for (j in 2:ncol(data01)) { # 臨時陣列（矩陣）的直欄數為數據框的直欄數減一（年度）。
  for (i in 2:(nrow(data01))) { # 臨時陣列（矩陣）的橫排數不計算最初年度的成長率。
    tmp[i,(j-1)] <- (data01[i,j]/data01[(i-1),j]-1)*100
  }
}
tmp <- data.frame(tmp)
names(tmp) <- names(data01)[-1]
data02 <- cbind(data01[1], tmp)

# 清除臨時變項。
rm(tmp, i, j)

# 調用 tidyr 套件包，用於 reshape 處理。
# install.packages("tidyr")
library(tidyr)
# 將金額及成長率這二個數據框，由寬式改為長式。
data01 <- gather(data01, "Sector", "USD_M", -年度)
data02 <- gather(data02, "Sector", "YoY", -年度)
# 將以上二數據框合併。
data03 <- merge(data01, data02)
names(data03)[1] <- "Year"
write.csv(data03, "twex.csv")


# 繪圖測試。
library(ggplot2)

data04 <- subset(data03, Year == 2015)
ggplot(data04, aes(x=USD_M, y=YoY, colour=Sector, size=USD_M))  + geom_point(alpha=.5) +  geom_text(aes(label=Sector))

scale_size_area(max_size=15)
  
library(dplyr)
library(ggvis)
# data03 %>% filter(年度 == 2015) %>% ggvis(~USD_M, ~YoY, size = ~USD_M, fill = ~sector) %>% layer_point()

# data03 %>% filter(Year == 2015) %>% data04


dplyr::filter(data03, Year == 2013) %>%
  ggvis( ~USD_M, ~ YoY) %>%
  layer_points(fill = ~Sector) %>%
  scale_numeric("x", domain = c(0, 150000)) %>%
  scale_numeric("y", domain = c(-40, 90)) %>%
  add_legend("fill") %>%
  set_options(height = 720, width = 1280) 

  
test %>%  ggvis( ~USD_M, ~ YoY) %>%
    layer_points(size = ~USD_M, fill = ~YoY) %>%
    scale_numeric("x", domain = c(0, 150000)) %>%
    scale_numeric("y", domain = c(-40, 10)) %>%
    layer_text(text:= ~Sector) %>%
    add_legend(c("size", "fill"))

# add_legend(c("fill", "size"))
#   add_legend("fill", title = "YoY in %")
#   add_legend("fill", "size")
# 
# data04 <- subset(data03, 年度 == 2015)
# ggvis(data04, ~USD_M, ~YoY) %>% layer_points(size = ~USD_M, fill = ~Sector)  %>% layer_text(text:=~Sector)

# 調用 googleVis 套件包，用於後續繪圖。
# install.packages("googleVis")
# library(googleVis)
# 
# m <- gvisMotionChart(data03, idvar="Sector", timevar="Year"	)
# plot(m)
# 
# write.csv(data03, file = "/datafile/TwEx_1974-2015.csv", row.names = FALSE)
# 
# write.table(data03, file = "/datafile/TwEx_1974-2015.csv", row.names=FALSE, sep=",")

######################################################

# 1280
# 720

# for (i in 2:length(NameList$EngName)){
#   for (j in 1:length(data03$Sector){
#     if data03$Sector[j] == NameList$EngName[i]
#     data03$Sector[j] <- NameList$ChiName[i]
#   } == NameList$EngName
# }
# 
# 
# data03$Sector == NameList$EngName





# options = list(title="台灣歷年主要貨品\n外銷訂單金額及成長率",
#                width=1280, height=720)

# install.packages("xlsx")
# library(xlsx)
# data00 <- loadWorksheet(loadWorkbook("/datafile/台灣1984年至2015年主要貨品外銷訂單金額.USD_M.xls"), sheet="BB01")

#  1、Animal, Vegetable Products
# " 2、Prepared Foodstuffs; Beverages and
#        Tobacco Products"
#  3、Chemicals
# " 4、Plastics and Articles Thereof; 
#        Rubber and Articles Thereof "
#  5、Leather and Articles Thereof
#  6、Wood, Articles of Wood and Manufactures
#  7、Textile Products
# " 8、Footwear, Headgear, Umbrellas; 
#        Articles of Human Hair; Artificial Flowers "
# " 9、Articles of stone, Plaster Cement; 
#        Ceramic, Glass and Articles Thereof"
# 10、Basic Metals and Articles Thereof 
# 11、Electronic Products
# 12、Machineries
# 13、Electrical Machinery Products
# 14、Information & Communication Products
# 15、Household Electrical Appliances
# 16、Transport Equipments
# "17、Precision Instruments, 
#         Clocks and Watches, Musical Instruments "
# 18、Furniture
# 19、Toys, Games and Sports Requisites
# 21、Others 