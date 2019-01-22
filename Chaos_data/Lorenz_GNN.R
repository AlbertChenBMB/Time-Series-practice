#Global Nearest Neighbor
#first build a matrix
LORENZ<-read.table("LORENZ.DAT.txt")
GNN<-matrix(nrow = 16384,ncol = 2)
GNN[,1]<-LORENZ[,1]
for( i in c(1:16384)){
        
        GNN[i,2]<-LORENZ[i+1,1]
        
}
#function
GNN<-DimData(data = LORENZ,n = 3)
GNN<-GNN[1:(nrow(GNN)-3),]
#second calculate dist
mind<-matrix(nrow = 1,ncol = 3,c(100,101,102))
dist<-0
for (i in 1:(length(GNN[,1])-2)){
        fd<-GNN[(i+1):(length(GNN[,1])-1),1]-GNN[i,1]
        sd<-GNN[(i+1):(length(GNN[,1])-1),2]-GNN[i,2]
        td<-GNN[(i+1):(length(GNN[,1])-1),3]-GNN[i,3]
        ad<-cbind(fd,sd,td)
        dist<-ad[,1]^2+ad[,2]^2+ad[,3]^2
        if (mind[,3] > min(dist)){
                mind[,1]<-i
                mind[,2]<-which.min(dist)+i
                mind[,3]<-min(dist)  
        }
        
        
        
}
mind
#third calculate one more dimension
G4<-matrix(nrow = 16381,ncol=4)
G4[,1]<-GNN[,1]
G4[,2]<-GNN[,2]
G4[,3]<-GNN[,3]

for( i in c(1:16381)){
        
        G4[i,4]<-LORENZ[i+3,1]
        
}
#G3<-G3[1:16382,]
td<-G4[mind[,1],]-G4[mind[,2],]
tind<-td[1]^2+td[2]^2+td[3]^2
tind/mind[,3]
#
