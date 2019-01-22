# data after MI
#for ROS
Dataset<-read.table("ROSSLER.DAT.txt")
newRdata<-data.frame(0)
for(i in 1:(nrow(Dataset)/15)){
        newRdata[i,1]<-Dataset[(1+i*15),]
}
newRdata

#for HEN
Dataset<-read.table("HENON.DAT.txt")
newHdata<-data.frame(0)
for(i in 1:(nrow(Dataset)/28)){
        newHdata[i,1]<-Dataset[(1+i*28),]
}
newHdata
#########################################################
#for GNN
#look for GNN for R

Rrs<-list()
for (i in 1:9){
        d<-Dist(data = newRdata,n=i+1)
        Rrs[i]<-abs(newRdata[d[1]+i+1,]-newRdata[d[2]+i+1,])^2/d[,3]
        print(Rrs[i])
        
}
#PLOT   from 2 to 10 
png("GNN for ROSSLER.png", width=480, height=480)
plot(Rrs,x = 1:9,type = "l")
dev.off()
##########################################################
#look for GNN for H

Hrs<-list()
for (i in 1:9){
        d<-Dist(data = newHdata,n=i+1)
        Hrs[i]<-abs(newHdata[d[1]+i+1,]-newHdata[d[2]+i+1,])^2/d[,3]
        print(Hrs[i])
        
}
#PLOT   from 2 to 10 
png("GNN for HENON.png", width=480, height=480)
plot(Hrs,x = 1:9,type = "l")
dev.off()
#####

png("GNN for HENON(1:5).png", width=480, height=480)
plot(x=3:5,y = Hrs[3:5],type = "l")
dev.off()
#####
Rdata<-matrix(nrow =( nrow(newRdata)-4),ncol = 4)
for(i in 1:4){
        Rdata[,i]<-newRdata[( i:(nrow(newRdata)-(5-i))),]
}
names(Rdata)<-c("v1","v2","v3","ans")
#####
Hdata<-matrix(nrow =( nrow(newHdata)-6),ncol = 6)
for(i in 1:6){
        Hdata[,i]<-newHdata[( i:(nrow(newHdata)-(7-i))),]
}



Hdata<-as.data.frame(Hdata)
#spread data
library(caTools)
H_training_set<-Hdata[1:463,   ]
H_testset<-Hdata[463:579,   ]
#SVM
library(e1071)
library(MLmetrics)
Error<-matrix(nrow = 20,ncol = 20)
for(i in 1:20){
        for(j in 1:20){
                H_s_regression <- svm(formula = V6 ~.,
                                      data = H_training_set,
                                      type = 'eps-regression',
                                      kernel = 'radial',
                                      cost=(i/10),
                                      gamma=(j/10))
                # Predicting the Test set results
                s_pred = predict(H_s_regression, newdata = H_testset[-6])
                Error[i,j]<-RMSE(s_pred,H_testset[6])
                print( Error[i,j])
        }
}
head(Error)

which.min(Error)
#############
G_one<-Error[,10]
C_one<-Error[1,]
plot(G_one,type = "l",xlab = "Cost/10",ylab = "Error",main = "Gamma = 1")
plot(C_one,type = "l",xlab = "Gamma/10",ylab = "Error",main = "Cost = 0.1")
#############
ansplot<-H_testset[6]
plot(Best)
plot(x=c(463:579),y=ansplot$V6,type = "l")
