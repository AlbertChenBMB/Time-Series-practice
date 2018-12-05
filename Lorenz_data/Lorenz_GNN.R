#Global Nearest Neighbor
#first build a matrix
LORENZ<-read.table("LORENZ.DAT.txt")
GNN<-matrix(nrow = 16384,ncol = 2)
GNN[,1]<-LORENZ[,1]
for( i in c(1:16384)){
        
        GNN[i,2]<-LORENZ[i+1,1]
        
}

#second calculate dist
mind<-matrix(nrow = 1,ncol = 3,c(100,101,102))
dist<-0
for (i in 1:(length(GNN[,1])-2)){
        fd<-GNN[(i+1):(length(GNN[,1])-1),1]-GNN[i,1]
        sd<-GNN[(i+1):(length(GNN[,1])-1),2]-GNN[i,2]
        ad<-cbind(fd,sd)
        dist<-ad[,1]^2+ad[,2]^2
        if (mind[,3] > min(dist)){
                mind[,1]<-i
                mind[,2]<-which.min(dist)+i
                mind[,3]<-min(dist)  
        }
        
        
        
}
mind
#third calculate one more dimension
G3<-matrix(nrow = 16384,ncol=3)
G3[,1]<-GNN[,1]
G3[,2]<-GNN[,2]

for( i in c(1:16384)){
        
        G3[i,3]<-LORENZ[i+2,1]
        
}
G3<-G3[1:16382,]
td<-G3[mind[,1],]-G3[mind[,2],]
tind<-td[1]^2+td[2]^2+td[3]^2
tind/mind[,3]
#
