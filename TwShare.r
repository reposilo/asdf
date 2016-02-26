library(XML)
url <- "http://siis.twse.com.tw/publish/sii/105IRB100_01.HTM"
doc <- htmlParse(url, encoding = 'BIG5')
tmp <- readHTMLTable(doc)

-----------------
  
library(XML)
library(RCurl)
library(httr)
Sys.setlocale(category='LC_ALL', locale='C')

##generate the list of url
url='http://www.twse.com.tw/ch/trading/indices/twco/tai50i.php'


#網頁內有中文字，先以Big5編碼捉取網頁
get_url_parse =htmlParse(url,encoding ='BIG5')

#抓取關鍵的變項，我們需要的變項夾在一個table的class=tb2，裡面<tr>標籤裡面
tablehead <- xpathSApply(get_url_parse, "//tr[@class='tb2']/td", xmlValue)

#將擷取到的關鍵字轉成XP系統內建編碼 CP950
#特別的是經過xpathSApply解析出來的文字編碼，似乎會自動從BIG5變為UTF-8?
tablehead<-iconv(tablehead,"UTF-8","CP950")

#將擷取到的關鍵字轉成容易閱讀的矩陣格式
table <- matrix(tablehead, ncol = 6, byrow = T)
