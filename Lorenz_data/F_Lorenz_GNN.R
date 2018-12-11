#Global Nearest Neighbor
#first build a matrix
LORENZ<-read.table("LORENZ.DAT.txt")
GNN<-matrix(nrow = 16384,ncol = 2)
#function
LORENZ<-read.table("LORENZ.DAT.txt")

DimData<-function(data,n){
        GNN<-matrix(ncol = n,nrow = (nrow(data)))
        GNN[,1]<-data[,1]
        for( i in c(1:(nrow(data)))){
                for(j in c(1:n)){
                        GNN[i,j]<-data[(i+j),1]    
                }
            }
        return(GNN)
}
#check function 
head(DimData(data = LORENZ,n = 4))
tail(DimData(data = LORENZ,n = 4))
##second calculate dist
Dist<-function(data,n){
        mind<-matrix(nrow = 1,ncol = 3,100)
        dist<-0
        GNN<-DimData(data = LORENZ,n = n)
        GNN<-GNN[1:(nrow(GNN)-n),]
        for (i in 1:(length(GNN[,1])-2)){
                dm<-matrix(nrow =(length(GNN[,1])-(i+1)),ncol = n)# problem from here
                for (j in 1:n){
                        
                        dm[,j]<-GNN[(i+1):(length(GNN[,1])),j]-GNN[i,j]
                        
                                }
                dist<-0
                for(k in 1:n){
                        dist<-dist+na.omit(dm[,k])^2
                }
                if (mind[,3] > min(dist)){
                                mind[,1]<-i
                                mind[,2]<-which.min(dist)+i
                                mind[,3]<-min(dist)
                                            }
                
                }      
        
        return(mind)
}

#solution 1 , reload data(put GNN in the first for loop)


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
