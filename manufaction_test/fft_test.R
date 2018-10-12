#
library(xlsx)
library(TSA)
library(ggplot2)
MS<-read.xlsx("MSample.xls",
              sheetIndex=1,startRow = 1,
              endRow = 7500, header = F,
              colIndex =1:4,encoding = "UTF-8")
head(MS)
tail(MS)
#check each variables
ggplot(data = MS, aes(x =1:7500, y= X1,group1))+geom_line()
ggplot(data = MS, aes(x =1:7500, y= X2,group1))+geom_line()
ggplot(data = MS, aes(x =1:7500, y= X3,group1))+geom_line()
ggplot(data = MS, aes(x =1:7500, y= X4,group1))+geom_line()
#do FFT to get periodogram
per1 = periodogram(MS$X1)
per2 = periodogram(MS$X2)
per3 = periodogram(MS$X3)
per4 = periodogram(MS$X4)
#spread 
p1f_1<-per1$freq[1:750]
p1f_2<-per1$freq[751:1500]
p1f_3<-per1$freq[1501:2250]
p1f_4<-per1$freq[2251:3750]
#get std, mean
p1_m<-mean(p1f_1)
p1_s<-sd(p1f_1)
