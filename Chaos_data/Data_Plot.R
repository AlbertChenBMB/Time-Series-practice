#data plot
Dataset<-read.table("HENON.DAT.txt")
plotdata<-matrix(nrow = nrow(Dataset),ncol = 2)
plotdata[,1]<-Dataset[1:(nrow(Dataset)-1),]
plotdata[,2]<-Dataset[2:nrow(Dataset),]
png("HENON.png", width=480, height=480)
plot(x=plotdata[,2],y=plotdata[,1],main = "HENON",xlab = "T+1",ylab = "T")
dev.off()
