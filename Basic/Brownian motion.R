#Brownian motion

T = 1     # end of interval[0,T]
N = 10000
x=0       #initial value of the process at time t0.
t0=0      #initial time
dt <- (T-t0)/N
t <- seq(t0,T, length=N+1)  # set up scale
X1 <- ts(cumsum(c(x,rnorm(N,mean = 0)*sqrt(dt))),start=t0, deltat=dt)
X2 <- ts(cumsum(c(x,rnorm(N)*sqrt(dt))),start=t0, deltat=dt)
ts.plot(X1)
mean(X1)
sd(X1)
#

#other way
t<-c(1:1000)
delta<-rnorm(1000,mean = 0)

for(i in c(2:1000)){
       
        t[i]= t[i-1] + delta[i-1]
        
}
png("plot1.png",width = 480,height = 480)
plot(c(1:1000),t,type = "l")
mean(delta)
sd(delta)
dev.off()
