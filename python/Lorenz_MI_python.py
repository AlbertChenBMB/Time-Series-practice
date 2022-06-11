# Lorenz_MI_python
import os
import pandas as pd

#從Chaos_data讀取資料
path=os.path.abspath(os.getcwd()+'/Chaos_data/')
file_path_lorenz=path+'\\LORENZ.DAT.txt'
lorenz_data= pd.read_csv(open(file_path_lorenz))

print(lorenz_data.head(5))

