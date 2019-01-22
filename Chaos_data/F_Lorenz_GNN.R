#Global Nearest Neighbor
#first build a matrix
Dataset<-read.table("HENON.DAT.txt")
#function
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
result<-Dist(data = Dataset,n = 2)
#look for GNN
rs<-list()
for (i in 1:9){
        d<-Dist(data = Dataset,n=i+1)
        rs[i]<-abs(Dataset[d[1]+i+1,]-Dataset[d[2]+i+1,])^2/d[,3]
        print(rs[i])
        
}
#PLOT   from 2 to 10
png("GNN for HENON.png", width=480, height=480)
plot(rs,x = 1:9,type = "l",main = "Embedded Dimension")
dev.off()
