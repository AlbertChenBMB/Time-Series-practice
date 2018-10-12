library(keras)
library(tensorflow)
library(lubridate)#for date type

dataset<-read.csv("MEI_FIN_12102018090343317.csv",
                  header = TRUE,sep = ",")
LR<-dataset[1:131,c(7,15)]
names(LR)<-c("Time","LTR")
#change to date type
LR$Time<-dym(paste("01-", LR$Time , sep =""))
#plot the interest rate change
plot(x=LR$Time,y=LR$LTR,type="l",col="blue")
#transofrm data to stationarity
diffed<-diff(LR$LTR,differences = 1)
head(diffed)

lag_transform<-function(x,k=1){
  lagged =c(rep(NA,k),x[1:(length(x)-k)])
  DF=as.data.frame(cbind(lagged,x))
  colnames(DF)<-c(paste0("x-",k),"x")
  DF[is.na(DF)]<-0
  return(DF)
}

supervised= lag_transform(diffed,1)
head(supervised)
#split into train and test sets for time series data
N=nrow(supervised)
n=round(N*0.7,digits=0)
train=supervised[1:n,]
test=supervised[(n+1):N,]
# scale data
scale_data=function(train,test,fr = c(0,1)){
  x= train
  fr_min=fr[1]
  fr_max=fr[2]
  std_train = ((x-min(x))/(max(x)-min(x) ))
  std_test = ((test-min(x))/(max(x)-min(x)))
  
  scaled_train=std_train*(fr_max-fr_min)+fr_min
  scaled_test=std_test*(fr_max-fr_min)+fr_min
  
  return(list(scaled_train=as.vector(scaled_train),
              scaled_test=as.vector(scaled_test),
              scaler=c(min=min(x),max=max(x))))
  
  }
Scaled=scale_data(train,test,fr = c(-1,1))

y_train<-Scaled$scaled_train[,2]
x_train<-Scaled$scaled_train[,1]
y_test<-Scaled$scaled_test[,2]
x_test<-Scaled$scaled_test[,1]
