#logistic map
# x[i]= a*x[i-1]*(1-x[i-1])
# x is step, int is initial value of x

logict_plot<-function(x,int=0.4,a=4){
        x[1]<-int
        for(i in c(2:length(x))){
                x[i]= a*x[i-1]*(1-x[i-1])
                   
        }
        return(x)
}

# a= 0.26  
x<-c(1:20)
y<-logict_plot(x=x,int=0.2,a=2.6)
plot(x=x,y=y,type = "l")
# a=0.32
x<-c(1:20)
y<-logict_plot(x=x,int=0.2,a=3.2)
plot(x=x,y=y,type = "l")
# a=3.52
x<-c(1:20)
y<-logict_plot(x=x,int=0.2,a=3.52)
plot(x=x,y=y,type = "l")
# a=4
x<-c(1:100)
y<-logict_plot(x=x,int=0.2,a=4)
plot(x=x,y=y,type = "l")

#########
y<-logict_plot(x=c(1:15),int=0.4,a=6)
y1<-y[1:9]
y2<-y[2:10]
plot(x=y1,y=y2,type="l")
