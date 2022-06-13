# Lorenz_MI_python
import os
import pandas as pd

#從Chaos_data讀取資料
path=os.path.abspath(os.getcwd()+'/Chaos_data/')
file_path_lorenz=path+'\\LORENZ.DAT.txt'
lorenz_data= pd.read_csv(open(file_path_lorenz))

print(lorenz_data.head(5))

# 先對資料做normalize
from sklearn import preprocessing
import numpy as np

new_data= preprocessing.normalize(lorenz_data)
# 做一個延遲的樣本
new_data_lag = new_data.shift(1)

## Mutual Information function
##針對兩個變數X,Y ,假設其機率分別為P(X) P(B),其聯合機率為P(XY),則交互資訊如下
##P(XY)log(P(XY)/P(X)*P(Y))
##如果XY條件獨立,則相互資訊為0

##下列做 MI 公式, PA, PB
def MI(PA,PB,PAB):
    ans = pd.DataFrame(0)
    for i in range(100):
        for j in range(100):
            if PAB[i,j] !=0:
                ans[i,j]=PAB[i,j]*log((PAB[i,j]/PA[i])/PB[j])
    return(sum(ans))

 ## 求 AB的MI
 # 細節要再確認
 def MI_Prob(x,newx):
     PA =[]
     PB=[]
     for i in range(100):
         PA[i+1]= (len(x[]))  