

# 調用 XLConnect 套件包，讀入含有董監持股不足名單及掛牌公司財務數字之 xls 檔案內容。
library(XLConnect)
wb <- loadWorkbook("./datafile/misc/20160131台灣上市、上櫃、興櫃公司董監持股不足.xls", create = FALSE)

underHolder <- readWorksheet(object = wb, sheet = 1, region ='A1:E109', header = TRUE)
listedFS <- readWorksheet(object = wb, sheet =2, region ='A1:L1868', header = TRUE)

# 使共用欄位的型態一致。
underHolder$股票代碼 <- as.character(underHolder$股票代碼)

# 調用 dplyr 套件包，結合前面讀入的二個工作表。
library(dplyr)
df <- dplyr::inner_join(underHolder, listedFS, by="股票代碼" )
# 移除重覆直欄，調整欄名。
df <- df[ , -which(names(df) %in% c("公司名稱.y","交易市場.y"))]
names(df)[names(df)=="公司名稱.x"] <- "公司名稱"
names(df)[names(df)=="交易市場.x"] <- "交易市場"

#
df$業外收支 <- gsub(",", "", df$業外收支)
df$業外收支 <- as.numeric(df$業外收支) 
df$每股純益 <- as.numeric(df$每股純益)
df$流動比率 <- as.numeric(df$流動比率)

write.csv(df, file = "./datafile/misc/201601董監持股不足.csv")


=======================================================


    To make your approach work, you'd need to replace ==
with %in%:

> rows.to.keep<-which(rownames(data) %in% names.to.keep)
[1] 1 3 4

But to answer you're original question, remember that the
point of rownames is that they can be used to index a 
data frame:

> data[rows.to.keep,]
   [,1] [,2]
a    1    2
c    3    4
d    4    5



You can use the %in% operator:

> df <- data.frame(id=c(LETTERS, LETTERS), x=1:52)
> L <- c("A","B","E")
> subset(df, id %in% L)
   id  x
1   A  1
2   B  2
5   E  5
27  A 27
28  B 28
31  E 31
If your IDs are unique, you can use match():

> df <- data.frame(id=c(LETTERS), x=1:26)
> df[match(L, df$id), ]
  id x
1  A 1
2  B 2
5  E 5
or make them the rownames of your dataframe and extract by row:

> rownames(df) <- df$id
> df[L, ]
  id x
A  A 1
B  B 2
E  E 5



營業收入（TWD K）
上市櫃為2015年一至九月
興櫃則為2015年一至六月