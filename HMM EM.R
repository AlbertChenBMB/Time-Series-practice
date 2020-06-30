library(HMM)


hmm = initHMM(c("S1","S2"),c("R","G","B"),
              startProbs = c(1,0),
              transProbs=matrix(c(0.5,0.5,0.5,0.5),2),
              emissionProbs=matrix(c(.33,.33,.33,.33,.34,.34),3))
origin <- initHMM(c("S1","S2"),c("R","G","B"),
                  startProbs = c(1,0),
                  transProbs=matrix(c(0.1,0.9,0.9,0.1),2),
                  emissionProbs=matrix(c(.1,.7,.3,.2,.6,.1),3))
print(hmm)

#output = c("G","R","B","G","B","R","G","B","B","R")
# Baum-Welch
bw = baumWelch(hmm,output,1)
print(bw$hmm)

#Forward algorithm
alpha <- function(hmm, output, t, state){
   if(t>1){
     return(hmm$emissionProbs[state,output[t]] * (hmm$transProbs[1,state]*alpha(hmm, output, t-1, 1) +
                                                  hmm$transProbs[2,state]*alpha(hmm, output, t-1, 2)))
   }else{
     return(hmm$startProbs[state]*hmm$emissionProbs[state,output[1]])
   }
}

#backward algorithm
beta <- function(hmm, output, t, state){
  if(t<length(output)){
    return(beta(hmm, output, t+1, 1)*hmm$transProbs[state,1]*hmm$emissionProbs[1,output[t+1]] +
           beta(hmm, output, t+1, 2)*hmm$transProbs[state,2]*hmm$emissionProbs[2,output[t+1]]
      )
  }else{
    return(1)
  }
}

#gamma function
gamma <- function(hmm, output, t, state){
  alphasum <- 0
    for(i in 1:2){
      alphasum <- alphasum + (alpha(hmm, output, t, i) * beta(hmm, output, t, i))
    }
  gamma <- (alpha(hmm, output, t, state) * beta(hmm, output, t, state))/ alphasum
  
  return(gamma)
}

#epsilon function
epsilon <- function(hmm, output, t, si, sj){
  alphasum <- 0
  for(i in 1:2){
    for(j in 1:2){
      alphasum <- alphasum + alpha(hmm,output,t,i) * hmm$transProbs[i,j] * hmm$emissionProbs[j,output[t+1]] * beta(hmm,output,t+1,j)
    }
  }
  
  epsilon <- alpha(hmm,output,t,si) * hmm$transProbs[si,sj] * hmm$emissionProbs[sj,output[t+1]] * beta(hmm,output,t+1,sj)
  epsilon <- epsilon / alphasum
  
  return(epsilon)
}

#EM method update for HMM
update <- function(hmm, output, iteration){
 
  for(iter in 1:iteration){
    gam <- matrix(0,length(output), 2)
    ep <- matrix(0, length(output)-1, 4)
    b <- matrix(0, 2, 3)
    
    for(i in 1:length(output)){
      gam[i,1] <- gamma(hmm,output,i,1)
      gam[i,2] <- gamma(hmm,output,t = i, state = 2)
    }
    
    for(i in 1:(length(output)-1)){
      ep[i,1] <- epsilon(hmm,output, t = i,si = 1, sj = 1)
      ep[i,2] <- epsilon(hmm,output, t = i,si = 1, sj = 2)
      ep[i,3] <- epsilon(hmm,output, t = i,si = 2, sj = 1)
      ep[i,4] <- epsilon(hmm,output, t = i,si = 2, sj = 2)
    }
    for(i in 1:2){
      b[i,1] <- sum(gam[ifelse(output == "R", TRUE, FALSE),i]) / sum(gam[,i])
      b[i,2] <- sum(gam[ifelse(output == "G", TRUE, FALSE),i]) / sum(gam[,i])
      b[i,3] <- sum(gam[ifelse(output == "B", TRUE, FALSE),i]) / sum(gam[,i])
    }
    
    b[1,] <- b[1,] / sum(b[1,])
    b[2,] <- b[2,] / sum(b[2,])
    
    hmm$startProbs <- gam[1,] / sum(gam[1,])
    for(i in 1:2){
      for(j in 1:2){
        hmm$transProbs[i,j] <- sum(ep[,(i*(i-1)+j)]) / sum(gam[1:(length(output)-1),i])
      }
      hmm$transProbs[i,] <-  hmm$transProbs[i,] / sum(hmm$transProbs[i,])
    }
    
    hmm$emissionProbs[] <- b[]
  }
  return(hmm)
}

update(hmm, output, iteration = 10)
