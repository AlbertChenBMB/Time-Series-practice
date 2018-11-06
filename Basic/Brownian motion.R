#Brownian motion
set.seed(1235)
T = 1     # end of interval[0,T]
N = 200
x=0       #initial value of the process at time t0.
t0=0      #initial time
dt <- (T-t0)/N
t <- seq(t0,T, length=N+1)  # set up scale
X1 <- ts(cumsum(c(x,rnorm(N,mean = 0)*sqrt(dt))),start=t0, deltat=dt)

ts.plot(X1)
mean(X1)
sd(X1)
#

#other way
t<-c(1:100) #set time
delta<-rnorm(100,mean = 0)

for(i in c(2:100)){
       
        t[i]= t[i-1] + delta[i-1]
        
}
png("plot2.png",width = 480,height = 480)
plot(c(1:100),t,type = "l")
grid(nx = 10,ny = 10)
mean(delta)
sd(delta)
dev.off()

# calculate fractal dimention
library(plotrix)
plot(X1,type = "l",xlim=c(0,1),ylim=c(-0.5,0.5))
grid(nx = 20,ny = 20)
draw.circle(x = 0  ,y= 0,radius = 0.1)
draw.circle(x = 0.1,y=X1[10],radius = 0.1)
draw.circle(x = 0.2,y=X1[20],radius = 0.1)
draw.circle(x = 0.3,y=X1[30],radius = 0.1)
draw.circle(x = 0.4,y=X1[40],radius = 0.1)
draw.circle(x = 0.5,y=X1[50],radius = 0.1)
draw.circle(x = 0.6,y=X1[60],radius = 0.1)
draw.circle(x = 0.7,y=X1[70],radius = 0.1)
draw.circle(x = 0.8,y=X1[80],radius = 0.1)
draw.circle(x = 0.9,y=X1[90],radius = 0.1)
draw.circle(x = 1 ,y=X1[100],radius = 0.1)








