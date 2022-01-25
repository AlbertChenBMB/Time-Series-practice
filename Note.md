# python Time Series

[![hackmd-github-sync-badge](https://hackmd.io/Cqw7NdqATImnU58TFimG9w/badge)](https://hackmd.io/Cqw7NdqATImnU58TFimG9w)

###### tags: `Python` `Time Series`


## timedelta 格式
```
from datetime import timedelta
```
### time index
```python=
FT.index = pd.to_datetime(FT.index)
```
### 計算時間差
若要計算時間差須注意
尤其是超過24小時的時間差
舉例
```python=

d1=np.datetime64('2020-11-04 07:02:54')
d2=np.datetime64('2020-11-03 15:00:00')
d3=np.datetime64('2020-11-04 00:00:00')
d1-d2
d1-d3
###
#-1 days +07:57:06
###
```
要比較d1-d2和d1-d3時會出一些錯誤
最需要注意的就是用.days取和.seconds取
會分別只取到天和秒的部分
必須自己在加起來
如下,我們想看真正的時間差
```python=
true_diff = (d1-d2).days*24*60*60 + (d1-d2).seconds
```
### 取出小時做特徵
```python=
data['hour']=data['Date'].dt.hour
```


## 位移的時間資料

想要合併前30分種的資料
暫時不用套件的做法為
取前一筆~前60筆資料做合併
```python=
#暫時以每60筆資料做一次標準差處理存入
All_max=[]
All_min=[]
All_std=[]
All_median=[]
All_mean=[]
for i in range(0,len(train_data),60):
    All_max.append(train_data[['CDA_A']].iloc[i:i+60].get('CDA_A').max())
    All_mean.append(train_data[['CDA_A']].iloc[i:i+60].get('CDA_A').mean())
    All_std.append(train_data[['CDA_A']].iloc[i:i+60].get('CDA_A').std())
    All_median.append(train_data[['CDA_A']].iloc[i:i+60].get('CDA_A').median())
    All_min.append(train_data[['CDA_A']].iloc[i:i+60].get('CDA_A').min())


    
    
newdata=pd.DataFrame({'All_max':All_max,'All_std':All_std,'All_mean':All_mean,'health_check':health_check})  

```






## 時間轉換處理問題
```python=
from datetime import datetime
import time
Need_PM_set["Date_one"]=Need_PM_set["Date_one"].map(lambda x: x.strftime('%Y%m%d') if x else "")
```
上面這個程式是我原本DF中的Data_one標註為到分的單位, 為了要檢查以天為範圍的資料我將其轉換

## 時間篩選
```python=
mask = (CH_data1['Date'] < '2020/12/15')

New_data=CH_data1.copy().loc[mask]
```
### 時間範圍
* Select observations between two datetimes
```python=
df[(df['date'] > '2002-1-1 01:00:00') & (df['date'] <= '2002-1-1 04:00:00')]
```

### Moveing average
```python=
def moving_average_forecast(series, window_size):
  """Forecasts the mean of the last few values.
     If window_size=1, then this is equivalent to naive forecast"""
  forecast = []
  for time in range(len(series) - window_size):
    forecast.append(series[time:time + window_size].mean())
  return np.array(forecast)
```

# 確認週期性
```python=
#確認週期性
from sklearn.feature_selection import f_regression, mutual_info_regression

#read data, rember check the header is exit or not


#normalize function
def normalize(data,col_num=0):
    mu=data[[col_num]].mean()
    std=data[[col_num]].std()
    norma=(data[[col_num]]-mu)/std
    return norma


#create the "new", the data after normalize
#new=normalize(data)[0:(len(data))-1]
#create the "newB", which is "new" delay in one time step
#newB=normalize(data)[1:len(data)]

#run 100 times to find mutual_info
Ans=[]
for i in range(0,20):
    new=normalize(df,'DO314C1_OWWR_AEROBIC_TANK_1C(CUB_B2)')[0:(len(df))-(1+i)]
    newB=normalize(df,'DO314C1_OWWR_AEROBIC_TANK_1C(CUB_B2)')[(i+1):len(df)]
    Ans.append(mutual_info_regression(new,newB))

max_value=max(Ans)
print(Ans.index(max_value) )

fig = px.line(Ans,  title='mutual_info')
fig.show()


```

## 判斷時間窗格確認是否有缺
```python=
x = []
    for i in range(1,len(data)):
        x = np.append(x,(data.loc[i,'time'] - data.loc[i-1,'time']).seconds)
    timedelta = int(stats.mode(x)[0][0]) #單位:sec
    
#上面這段取出時間區間是多少秒(每筆資料的間隔)
#如果資料的區間一致, np.unique(x) 會等於 1    
#補齊缺少的時間
    len_t_NA = 0
    if len(np.unique(x))>1: #若時間間格值>1種，則表示時間資料有缺
        #找出缺少資料的時間
        t_all = pd.date_range(data.loc[0,'time'],data.loc[len(data)-1,'time'], freq= str(timedelta) +'s') #取出正常的話會有哪些時間段的資料
        t_NA = pd.DataFrame(data = list(set(t_all).difference(set(data['time']))), columns = ['time'])
        len_t_NA = len(t_NA)
        col_NA = pd.DataFrame(columns = data.columns[1:],index = range(len_t_NA))
        data_NA = pd.concat([t_NA, col_NA], axis = 1)
        data = pd.concat([data, data_NA])
        data = data.sort_values(by='time').reset_index(drop=True) #依時間重新排序    

```

* 注意
set(t_all).difference(set(data['time']))
這段是在比正常的時間區間(t_all)和原始資料的時間(data['time'])的差別是哪幾筆
注意要用set,這樣才會是變成分開的筆數

**有用 set的結果**
Output:
{Timestamp('2020-03-30 16:00:00', freq='3600S'),
 Timestamp('2020-03-31 06:00:00', freq='3600S')} 
 
**沒用set的結果**
Output:
DatetimeIndex(['2020-03-30 16:00:00', '2020-03-31 06:00:00'], dtype='datetime64[ns]', freq=None)

## 時間做log
```python=

import time 
struct_time = time.localtime()


   
model_change=ans
file = out_path +'\\log\\'+str(struct_time.tm_mon)+str(struct_time.tm_mday)+str(struct_time.tm_hour)+'check.csv'
model_change.to_csv(file,index = False)

```
## 中文轉日期(取年日月)
```python=

def Ch_date(x,y='m'):
    if y == 'y':
        x=x.split('年')[0]
    elif y == 'm':
        x=x.split('月')[0].split('年')[1]
    elif y == 'd':
        x=x.split('日')[0].split('月')[1]
    
    return int(x)

```
再用apply套入
```python=
Check["y"]=Check["日(Dtime)"].apply(Ch_date)
```