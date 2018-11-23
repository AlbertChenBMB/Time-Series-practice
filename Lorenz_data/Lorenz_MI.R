################################
test<-read.table("LORENZ.DAT.txt")
library("BBmisc")
new<-normalize(x=test$V1,method ="range",range = c(0,1))
newB<-new[2:length(new)]
boundaries<-seq(0,1,by=0.1)
hist(new,breaks = boundaries)
##################################################################
#MI function
# MI & average MI
MI<-function(PA,PB,PAB){
        
        ans<-matrix(0,nrow = 100,ncol = 100)
        
        for (i in c(1:100)) {
                for(j in c(1:100)){
                        if (PAB[i,j] !=0){
                                ans[i,j] <- PAB[i,j]*log2((PAB[i,j]/PA[i])/PB[j])
                        }
                        
                }
        }
        return(sum((ans)))       
}
##################################################################
#PA PB function
prob<-function(new,newB){
        PA<-0
        PB<-0
        for (i in c(0:100)) {
                
                
                PA[i+1]<- (length(subset(new, i/100 < new & new <= ((i+1)/100) )) / length(new))
                PB[i+1]<- (length(subset(newB, i/100 < newB & newB <= ((i+1)/100) )) / length(newB))
        }
        PA<-PA[1:100]
        PB<-PB[1:100]
        AB<-cbind(new,newB)
        PAB<-matrix(0, nrow = 101, ncol = 101)
        for(i in c(0:100)){
                
                for(j in c(0:100)){
                        
                        PAB[i+1,j+1]<-length(subset(AB, i/100 < new & new <= ((i+1)/100) & j/100 < newB & newB <= ((j+1)/100) )) / length(AB)
                        
                }
                
        }
        MI(PA,PB,PAB)
}

# probability AB

##################################################################
# for new and newB
Ans<-0
for(i in c(1:100)) {
        new<-normalize(x=test$V1,method ="range",range = c(0,1))
        newB<-new[(i+1):length(new)]
        new<-new[1:(length(new)-i)]
        Ans[i]<-prob(new,newB)
        print(Ans[i])
}
###################################################################
plot(Ans,type = "l")








