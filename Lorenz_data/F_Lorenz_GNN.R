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
                        GNN[i,j]<-data[(i+j-1),1]    
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
        GN<-DimData(data = data,n = n)
        
        for (i in 1:(length(GN[,1])-(n+2))){
                GNN<-GN[1:(nrow(GN)-n),]
                
                for (j in 1:n){
                        
                        GNN[(i+1):(length(GNN[,1])),j]<-GNN[(i+1):(length(GNN[,1])),j]-GNN[i,j]
                        
                                }
                dist<-0
                for(k in 1:n){
                        dist<-dist+na.omit(GNN[,k])^2 #problem dist+ give empty back
                }
                if (mind[,3] > min(dist)){
                                mind[,1]<-i
                                mind[,2]<-which.min(dist)
                                mind[,3]<-min(dist)
                                            }
                
                }      
        
        return(mind)
}
result<-Dist(data = LORENZ,n = 2)
#solution 1 , reload data(put GNN in the first for loop)
result
#third calculate one more dimension
#4080 10035 
G4<-DimData(LORENZ,3)
fd<-G3[4082,]-G3[5957,]
tind<-sum(fd^2)
sqrt((tind-result[,3])/result[,3])
abs(LORENZ[4084,]-LORENZ[5959,])^2/result[,3]
tind#
#PLOT   from 2 to 10 

rs<-list()
for (i in 1:9){
        
        d<-Dist(data = LORENZ,n=i+1)
        rs[i]<-abs(LORENZ[d[1]+i+1,]-LORENZ[d[2]+i+1,])^2/d[,3]
        print(rs[i])
        
}
plot(rs,type = "l")
