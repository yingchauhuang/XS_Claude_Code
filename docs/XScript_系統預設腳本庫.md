# XScript 系統預設腳本庫

> 本文件收錄 XQ 官方
> [[XScript_Preset]{.underline}](https://github.com/sysjust-xq/XScript_Preset)
> 倉庫中的所有系統預設腳本。 共 5 大類、1,366 個 .xs 腳本，可作為撰寫
> XScript 時的標準寫法參考。

## 目錄

1.  [[🔧 函數]{.underline}](#1-函數) (224 個腳本)

    -   Array函數 (4)

    -   交易相關 (2)

    -   價格取得 (33)

    -   價格計算 (12)

    -   價格關係 (26)

    -   技術指標 (55)

    -   排行 (6)

    -   日期相關 (8)

    -   期權相關 (10)

    -   統計分析 (6)

    -   趨勢分析 (16)

    -   跨頻率 (29)

    -   邏輯判斷 (13)

    -   量能相關 (4)

2.  [[📊 指標]{.underline}](#2-指標) (395 個腳本)

    -   XQ技術指標 (32)

    -   XQ量能指標 (18)

    -   主圖指標 (30)

    -   即時籌碼 (17)

    -   大盤指標 (40)

    -   市場動能 (11)

    -   技術指標 (83)

    -   期權指標 (24)

    -   籌碼指標 (34)

    -   籌碼高手 (53)

    -   財報指標 (25)

    -   跨頻率指標 (12)

    -   量能指標 (16)

3.  [[🔔 警示]{.underline}](#3-警示) (359 個腳本)

    -   !語法範例 (13)

    -   1.籌碼監控 (17)

    -   2.市場常用語 (23)

    -   3.出場常用警示 (38)

    -   A股用語 (11)

    -   ETF策略 (21)

    -   價量指標 (34)

    -   出場訊號 (3)

    -   技術分析 (65)

    -   抄底策略 (5)

    -   期權策略 (2)

    -   波段操作型 (34)

    -   當沖交易型 (32)

    -   盤中常用 (5)

    -   短線操作型 (23)

    -   酒田戰法 (30)

    -   長線投資 (3)

4.  [[🔍 選股]{.underline}](#4-選股) (324 個腳本)

    -   00.語法範例 (19)

    -   01.常用過濾條件 (7)

    -   02.基本技術指標 (24)

    -   03.進階技術分析 (24)

    -   04.價量選股 (40)

    -   05.型態選股 (18)

    -   06.籌碼選股 (57)

    -   07.月營收選股 (18)

    -   08.財報選股 (74)

    -   09.時機操作 (7)

    -   10.價值投資 (12)

    -   11.選股機器人 (24)

5.  [[🤖 自動交易]{.underline}](#5-自動交易) (64 個腳本)

    -   0-基本語法 (12)

    -   1-常用下單方式 (10)

    -   2-下單出場方式 (9)

    -   3-Algo策略委託 (5)

    -   常見技術分析 (28)

## 1. 🔧 函數 (224 個腳本)

> 系統函數的原始碼實作，可作為自訂函數的參考範本

### 1.1 Array函數 (4 個)

#### 📄 ArrayLinearRegSlope

{@type:function}

{

傳入Array來計算LinearRegression的Slope

最新一期的資料放在ThePriceArray\[1\]

}

Input: ThePriceArray\[DataLength\](NumericArray);

Input: Length(numericsimple, \"統計天期\");

if DataLength \< Length then
RaiseRunTimeError(\"Array的長度不能小於Length\");

variable: SumX(0), //和

SumX2(0), //平方和

SumY(0),

SumXY(0);

SumX = Length \* (Length+1)/2;

SumX2 = Length \* (Length+1)\*(2\*Length+1)/6;

variable: Xi(0);

SumXY=0; SumY=0;

for Xi = 1 to Length

Begin

SumXY += Xi\* ThePriceArray\[Length-Xi+1\];

SumY += ThePriceArray\[Length-Xi+1\];

End;

retval = IFF((Length\*SumX2 - Square(SumX)) \<\> 0,

(Length\*SumXY - SumX\*SumY) / (Length\*SumX2 - Square(SumX)),

0);

#### 📄 ArrayMASeries

{@type:function}

{

把某個數值序列的MA轉成Array

範例:

Array: MAArray\[\](0);

ArrayMASeries(Close, 10, MAArray);

// Array_GetMaxIndex(MAArray) = 10

// MAArray\[1\] = MA(Close, 10),

// MAArray\[2\] = MA(Close\[1\], 10),

// MAArray\[3\] = MA(Close\[2\], 10),

// \...

}

input: TheSeries(numericseries, \"序列\");

input: MALength(numericsimple, \"MA天期\");

Input: TargetArray\[X\](NumericArrayRef);

Array_SetMaxIndex(TargetArray, MALength);

var: acc(0), idx(0);

acc = 0;

for idx = 0 to MALength-1 begin

acc = acc + TheSeries\[idx\];

end;

for idx = 0 to MALength-1 begin

TargetArray\[idx+1\] = acc / MALength;

acc = acc - TheSeries\[idx\];

acc = acc + TheSeries\[MALength + idx\];

end;

#### 📄 ArraySeries

{@type:function}

{

把某個數值序列轉成Array

範例:

Array: CloseArray\[\](0);

ArraySeries(Close, 10, CloseArray);

// Array_GetMaxIndex(CloseArray) = 10

// CloseArray\[1\] = Close, CloseArray\[2\] = Close\[1\],
CloseArray\[3\] = Close\[2\], ..

}

input: TheSeries(numericseries, \"序列\");

input: Length(numericsimple, \"序列長度\");

Input: TargetArray\[X\](NumericArrayRef);

Array_SetMaxIndex(TargetArray, Length);

Var: idx(0);

for idx = 0 to Length - 1 begin

TargetArray\[idx+1\] = TheSeries\[idx\];

end;

#### 📄 ArrayXDaySeries

{@type:function}

{

以Array儲存跨頻率的序列值，傳入一個序列

範例:

Array: CloseArray\[\](0);

ArrayXDaySeries(GetField(\"收盤價\",\"D\"),SBB_length,\_DayValue);

}

Input: TheSeries(numericseries, \"序列\");

Input: SBB_length(NumericSimple, \"SetBackBar的筆數\");

Input: TargetArray\[X\](NumericArrayRef);

Var: idx(0),\_length(0),\_xf_CurrentBar(0);

\_length = GetBarBack(\"D\");

\_xf_CurrentBar = xf_GetCurrentBar(\"D\");

if \_length \< SBB_length then
raiseRunTimeError(\"新上市櫃商品資料引用筆數不足，所以不允計算\");

if currentBar = 1 then begin

Array_SetMaxIndex(TargetArray, \_length);

for idx = 0 to \_length - 1 begin

TargetArray\[idx + 1\] = TheSeries\[idx\];

end;

end else begin

if \_xf_CurrentBar \> \_xf_CurrentBar\[1\] then begin

Array_Copy(TargetArray, 1, TargetArray, 2, \_length - 1);

end;

TargetArray\[1\] = TheSeries\[0\];

end;

### 1.2 交易相關 (2 個)

#### 📄 CalcVWAPDistribution

{@type:function}

{

計算過去N日的VWAP分佈

請傳入

\- 計算天數

\- 開始時間, 例如091000

\- 結束時間, 例如095900 (請注意請以1分K的Time為基準)

\- 一個array, 用來儲存上述指定區間內每分鐘的累積成交量分佈%,

\- CalcVWAPDistribution會自動設定array的大小,

\- array\[1\]是從開始時間後第1分鐘的累計成交量%,
array\[2\]是從開始時間到後第2分鐘的累計成交量%, etc.

\- 請注意這是一個累積的數值, 例如array\[1\] = 2.5, array\[2\] = 5.4,
array\[3\] = 7.0, \... array\[最後一個\]=100.0,

}

input: totaldays(numericsimple, \"計算天數\");

input: start_hhmmss(numericsimple, \"開始時間, 例如091000\");

input: end_hhmmss(numericsimple, \"結束時間, 例如095900\");

input: dist_array\[X\](numericarrayref, \"回傳成交量分佈%\");

var: total_minutes(0);

array: day_dist\[\](0); { 儲存每一日的成交量分佈% }

{ 請注意: 不支援跨日的計算 }

if start_hhmmss \>= end_hhmmss then
raiseruntimeerror(\"開始時間必須小於結束時間\");

total_minutes = TimeDiff(end_hhmmss, start_hhmmss, \"M\") + 1; {
頭尾都算 }

Array_SetMaxIndex(day_dist, total_minutes);

Array_SetMaxIndex(dist_array, total_minutes);

var: lastdate(0);

lastdate = GetFieldDate(\"Date\", \"1\"); // 目前1分鐘K棒的TDate

var: idx(0), days(0);

var: idx_daystart(0), idx_dayend(0);

Array_SetValRange(dist_array, 0, total_minutes, 0);

{ 先找到昨日的最後一筆, 從這裡開始統計N日的資料 }

idx = 1;

while GetFieldDate(\"Date\", \"1\")\[idx\] = lastdate begin

idx = idx + 1;

end;

days = 0;

while days \< totaldays begin

lastdate = GetFieldDate(\"Date\", \"1\")\[idx\];

idx_daystart = -1;

idx_dayend = -1;

while GetFieldDate(\"Date\", \"1\")\[idx\] = lastdate begin

if GetField(\"Time\", \"1\")\[idx\] = end_hhmmss then idx_dayend = idx;

if GetField(\"Time\", \"1\")\[idx\] = start_hhmmss then idx_daystart =
idx;

idx = idx + 1;

end;

if idx_daystart = -1 or idx_dayend = -1 then
raiseruntimeerror(\"Internal error\");

{print(

\"days=\", numtostr(days, 0),

\"date=\", formatdate(\"yyyy/MM/dd\", lastdate),

\"idx_daystart=\", numtostr(idx_daystart, 0),

\"idx_dayend=\", numtostr(idx_dayend, 0),

\"\"

);}

{ 收集從idx_start到idx_end之間的成交量分佈 }

var: totalvolume(0), jdx(0);

totalvolume = 0;

day_dist\[0\] = 0;

for jdx = idx_daystart downto idx_dayend begin

{ 每一筆 = 前一筆的累積 + 這一分K的成交量 }

day_dist\[idx_daystart - jdx + 1\] = GetField(\"Volume\",
\"1\")\[jdx\] + day_dist\[idx_daystart - jdx\];

{print(

\"Index=\", numtostr(idx_daystart - jdx + 1, 0),

\"day_dist\[\]=\", numtostr(day_dist\[idx_daystart - jdx + 1\], 0),

\"Date=\", FormatDate(\"yyyy/MM/dd\", GetField(\"Date\", \"1\")\[jdx\]),

\"Time=\", FormatTime(\"HH:mm\", GetField(\"Time\", \"1\")\[jdx\]),

\"Vol=\", numtostr(GetField(\"Volume\", \"1\")\[jdx\], 0),

\"\"

);}

end;

for jdx = idx_daystart downto idx_dayend begin

{ 換算成累積到目前為止的成交量% }

day_dist\[idx_daystart - jdx + 1\] = day_dist\[idx_daystart - jdx + 1\]
\* 100 / day_dist\[idx_daystart - idx_dayend + 1\];

{ 累積到 dist_array }

dist_array\[idx_daystart - jdx + 1\] = dist_array\[idx_daystart - jdx +
1\] + day_dist\[idx_daystart - jdx + 1\];

{print(

\"Index=\", numtostr(idx_daystart - jdx + 1, 0),

\"day_dist\[\]=\", numtostr(day_dist\[idx_daystart - jdx + 1\], 2),

\"dist_array\[\]=\", numtostr(dist_array\[idx_daystart - jdx + 1\], 2),

\"\"

);}

end;

days = days + 1;

end;

{ 回傳dist_array = 近N日的平均值 }

for jdx = 1 to total_minutes begin

dist_array\[jdx\] = dist_array\[jdx\] / totaldays;

end;

#### 📄 EnterMarketCloseTime

{@type:function_bool}

{

判斷是否已經進入收盤階段: 用來判斷不再進場 or 平倉當日部位

使用時須傳入N, 代表在最後可以送單前N分鐘就認定進入收盤階段,

例如如果傳1, 而且是台股的話, 那在13:24:00就會回傳True,
代表已經進入收盤階段

請注意: 這個函數只支援台股, 以及台灣期貨市場內的常用商品,
也不考慮部分外匯期貨 or 其他市場期貨, 例如東証指

}

input: exit_period(numericsimple, \"收盤前N分鐘\");

var: market_close_time(0); { 市場收盤時間 }

var: market_lasttrade_time(0); { 最後可交易時間 }

if symbolexchange = \"TW\" then begin

market_close_time = 134000; { 往後延長一點, 處理Tick可能延後收到的情形 }

market_lasttrade_time = 132500;

end else if symbolexchange = \"TF\" then begin

if daystoexpirationtf = 0 then begin

market_lasttrade_time = 133000;

market_close_time = 134000; { 往後延長一點, 處理Tick可能延後收到的情形 }

end else begin

market_lasttrade_time = 134500;

market_close_time = 135000; { 往後延長一點, 處理Tick可能延後收到的情形 }

end;

end else

raiseruntimeerror(\"不支援此商品\");

{ 往前推算N分鐘 }

market_lasttrade_time = TimeAdd(market_lasttrade_time, \"M\", -1 \*
exit_period);

if CurrentTime \>= market_lasttrade_time and CurrentTime \<=
market_close_time then retval = true else retval = false;

### 1.3 價格取得 (33 個)

#### 📄 AvgPrice

{@type:function}

SetBarMode(1);

AvgPrice = (Open + High + Low + Close) /4;

#### 📄 CloseD

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

CloseD = GetField(\"Close\",\"D\")\[PeriodsAgo\];

#### 📄 CloseH

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

CloseH = GetField(\"Close\",\"H\")\[PeriodsAgo\];

#### 📄 CloseM

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

CloseM = GetField(\"Close\",\"M\")\[PeriodsAgo\];

#### 📄 CloseQ

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

CloseQ = GetField(\"Close\",\"Q\")\[PeriodsAgo\];

#### 📄 CloseW

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

CloseW = GetField(\"Close\",\"W\")\[PeriodsAgo\];

#### 📄 CloseY

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

CloseY = GetField(\"Close\",\"Y\")\[PeriodsAgo\];

#### 📄 FastHighest

{@type:function}

SetBarMode(1);

input: thePrice(numericseries),Length(numericsimple);

variable: \_Output(0);

Extremes(thePrice, Length, 1, \_Output, value2);

FastHighest = \_Output;

#### 📄 FastLowest

{@type:function}

SetBarMode(1);

input: thePrice(numericseries), Length(numericsimple);

variable: \_Output(0);

Extremes(thePrice, Length, -1, \_Output, value2);

FastLowest = \_Output;

#### 📄 HighD

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

HighD = GetField(\"High\",\"D\")\[PeriodsAgo\];

#### 📄 HighH

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

HighH = GetField(\"High\",\"H\")\[PeriodsAgo\];

#### 📄 HighM

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

HighM = GetField(\"High\",\"M\")\[PeriodsAgo\];

#### 📄 HighQ

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

HighQ = GetField(\"High\",\"Q\")\[PeriodsAgo\];

#### 📄 HighW

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

HighW = GetField(\"High\",\"W\")\[PeriodsAgo\];

#### 📄 HighY

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

HighY = GetField(\"High\",\"Y\")\[PeriodsAgo\];

#### 📄 Highest

{@type:function}

SetBarMode(1);

input: thePrice(numericseries),Length(numericsimple);

variable: \_Output(0);

Extremes(thePrice, Length, 1, \_Output, value2);

Highest = \_Output;

#### 📄 LowD

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

LowD = GetField(\"Low\",\"D\")\[PeriodsAgo\];

#### 📄 LowH

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

LowH = GetField(\"Low\",\"H\")\[PeriodsAgo\];

#### 📄 LowM

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

LowM = GetField(\"Low\",\"M\")\[PeriodsAgo\];

#### 📄 LowQ

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

LowQ = GetField(\"Low\",\"Q\")\[PeriodsAgo\];

#### 📄 LowW

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

LowW = GetField(\"Low\",\"W\")\[PeriodsAgo\];

#### 📄 LowY

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

LowY = GetField(\"Low\",\"Y\")\[PeriodsAgo\];

#### 📄 Lowest

{@type:function}

SetBarMode(1);

input: thePrice(numericseries), Length(numericsimple);

variable: \_Output(0);

Extremes(thePrice, Length, -1, \_Output, value2);

Lowest = \_Output;

#### 📄 OpenD

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

OpenD = GetField(\"Open\",\"D\")\[PeriodsAgo\];

#### 📄 OpenH

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

OpenH = GetField(\"Open\",\"H\")\[PeriodsAgo\];

#### 📄 OpenM

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

OpenM = GetField(\"Open\",\"M\")\[PeriodsAgo\];

#### 📄 OpenQ

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

OpenQ = GetField(\"Open\",\"Q\")\[PeriodsAgo\];

#### 📄 OpenW

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

OpenW = GetField(\"Open\",\"W\")\[PeriodsAgo\];

#### 📄 OpenY

{@type:function}

SetBarMode(1);

input: PeriodsAgo(numericsimple);

OpenY = GetField(\"Open\",\"Y\")\[PeriodsAgo\];

#### 📄 TrueHigh

{@type:function}

SetBarMode(1);

if Close\[1\] \> High then TrueHigh = Close\[1\]

else TrueHigh = High;

#### 📄 TrueLow

{@type:function}

SetBarMode(1);

if Close\[1\] \< Low then TrueLow = Close\[1\]

else TrueLow = Low;

#### 📄 TypicalPrice

{@type:function}

SetBarMode(1);

TypicalPrice = (High + Low + Close) /3;

#### 📄 WeightedClose

{@type:function}

SetBarMode(1);

WeightedClose = (2 \* Close + High + Low) / 4;

### 1.4 價格計算 (12 個)

#### 📄 Average

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

if Length \> 0 then

Average = Summation(thePrice, Length) / Length

else

Average =0;

#### 📄 AvgDeviation

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

variable: truesum(0),

averageprice(0),

counter(0);

truesum = 0;

averageprice = Average(thePrice,Length);

for counter = 0 to Length - 1 begin

truesum = truesum + AbsValue(thePrice\[counter\] - averageprice);

end;

AvgDeviation = truesum / Length;

#### 📄 DwLimit

{@type:function}

SetBarMode(1);

input:refPrice(numericsimple);

variable:obup1(0),obdw1(0),STOCKUP(0),STOCKDW(0);

if date \< 20150601 then begin

obup1= refPrice\*1.07;

obdw1= refPrice\*0.93;

end else begin

obup1= refPrice\*1.1;

obdw1= refPrice\*0.9;

end;

if (obup1\<10 and obdw1\<10) then begin

STOCKUP = ((floor((floor(obup1\*100)\*100)))/100)/100;

STOCKDW = ((floor((ceiling(obdw1\*100)\*100)))/100)/100;

end else if (obup1\>=10 and obdw1\<10) then begin

STOCKUP = ((floor(((floor(obup1/0.05)\*0.05)\*100)\*100))/100)/100;

STOCKDW = ((floor((ceiling(obdw1\*100)\*100)))/100)/100;

end else if (obup1\>=10 and obdw1\>=10 and obup1\<50 and obdw1\<50) then
begin

STOCKUP = ((floor(((floor(obup1/0.05)\*0.05)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/0.05)\*0.05)\*100)\*100))/100)/100;

end else if (obup1\>=50 and obdw1\<50 ) then begin

STOCKUP = ((floor(((floor(obup1/0.1)\*0.1)\*100)\*100))/100)/100;

STOCKDW = (ceiling(obdw1/0.05)\*0.05);

end else if (obup1\>=50 and obdw1\>=50 and obup1\<100 and obdw1\<100)
then begin

STOCKUP = ((floor(((floor(obup1/0.1)\*0.1)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/0.1)\*0.1)\*100)\*100))/100)/100;

end else if (obup1\>=100 and obdw1\<100 ) then begin

STOCKUP = ((floor(((floor(obup1/0.5)\*0.5)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/0.1)\*0.1)\*100)\*100))/100)/100;

end else if (obup1\>=100 and obdw1\>=100 and obup1\<500 and obdw1\<500)
then begin

STOCKUP = ((floor(((floor(obup1/0.5)\*0.5)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/0.5)\*0.5)\*100)\*100))/100)/100;

end else if (obup1\>=500 and obdw1\<500) then begin

STOCKUP = ((floor(((floor(obup1/0.5)\*0.5)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/0.1)\*0.1)\*100)\*100))/100)/100;

end else if (obup1\>=500 and obdw1\>=500 and obup1\<1000 and
obdw1\<1000) then begin

STOCKUP = ((floor(((floor(obup1/ 1)\* 1)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/ 1)\* 1)\*100)\*100))/100)/100;

end else if (obup1\>=1000 and obdw1\<1000) then begin

STOCKUP = ((floor(((floor(obup1/5)\*5)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/ 1)\* 1)\*100)\*100))/100)/100;

end else if (obup1\>=1000 and obdw1\>=1000) then begin

STOCKUP = ((floor(((floor(obup1/5)\*5)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/5)\*5)\*100)\*100))/100)/100;

end;

DwLimit = STOCKDW;

#### 📄 EMA

{@type:function}

SetBarMode(2);

input:thePrice(numericseries); //\"價格序列\"

input:Length(Numeric); //\"計算期間\"

variable: Factor(0);

if length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);

if CurrentBar = 1 then

EMA = thePrice

else if CurrentBar \<= Length then

EMA = (thePrice + (EMA\[1\]\*(CurrentBar-1)))/CurrentBar

else

EMA = EMA\[1\] + Factor \* (thePrice - EMA\[1\]);

#### 📄 Range

{@type:function}

SetBarMode(1);

Range = High - Low;

#### 📄 RateOfChange

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

if thePrice\[Length\] \<\> 0 then RateOfChange = (thePrice /
absvalue(thePrice\[Length\]) - sign(thePrice\[Length\])) \* 100

else RateOfChange = 0;

#### 📄 ReadTicks

{@type:function}

{

讀取從上次洗價到這次洗價之間的Tick資料

\- 可以指定最大的讀取筆數(如果兩次洗價之間的資料量超過這個限制的話,
則只回傳最新的資料)

\- 自動合併台股逐筆撮合的MultiTick(連續成交序列)

\- 所謂MultiTick, 指的是在台股逐筆撮合時,
一筆買單(賣單)同時產生了多筆不同價格的成交的情形,

\- 當發生這種情形時, 交易所會把每一個價格的成交資料分別傳送,
可是ReadTicks會把這些成交紀錄合併統計,

方便使用者計算這個大單的總量,

\- 關於MultiTick, 請參考 https://bit.ly/3uZtwbG 內的更多說明

呼叫方式:

var: intrabarpersist readtick_cookie(0);// ReadTicks內部使用,
每次呼叫時請照實傳入

array: tick_array\[100, 11\](0); // 需要宣告一個2維陣列來儲存Tick資料

// 陣列的第一維是最大讀取筆數,

// 陣列的第二維是每一筆的欄位數, 請傳入11

var: idx(0);

value1 = ReadTicks(tick_array, readtick_cookie);

for idx = 1 to value1 begin

// 依序處理回傳的每一筆Tick

// 每一筆Tick共有11個欄位, 分別是 tick_array\[idx, 1\], tick_array\[idx,
2\], .. tick_array\[idx, 11\]

// 請參考底下說明

end;

回傳結果說明:

\- value1會是tick_array內所讀到的筆數,
如果上次洗價到這次洗價之間實際成交筆數超過tick_array宣告的大小的話,
則只會回傳最新的前N筆資料

\- tick_array\[1, ..\]是洗價當時最新的一筆, tick_array\[2, ..\]是前一筆,
tick_array\[value1, ..\]是回傳的最後一筆

舉例:

如果目前已經收到了#1, #2, #3, #4 這四筆ticks,
而#3跟#4是屬於同一組MultiTick, 那麼呼叫ReadTicks時, 會回傳3筆紀錄,

第一筆紀錄(tick_array\[1,..\])是#3跟#4合併的結果,
第二筆紀錄(tick_array\[2,..\])是#2的資料,第三筆紀錄(tick_array\[3,..\])是#1的資料

\- value1有可能是0, 表示到目前為止還沒有收到一筆完整的Tick.
這種情形可能會發生在系統收到了MultiTick的資料,
可是最後一筆MultiTick的資料還沒有收到.

因為ReadTicks會把完整的MultiTick合併成一筆回傳給你,
所以此時value1會先回0.
等到下一次收到最後一筆MultiTick時就會把完整的MultiTick資料回傳給用戶.

每一筆資料會有11個欄位, 以下分別說明

\- tick_array\[n, 1\] = Date (成交日期, 格式為yyyyHHmm)

\- tick_array\[n, 2\] = Time (成交時間, 格式為HHmmss)

\- 如果是MultiTick的話, 每一筆的Time都是一樣的(同時間成交)

\- tick_array\[n, 3\] = Close (成交價),

\- 如果是MultiTick的話, 回的是MultiTick序列最後一筆的成交價,
如果是買盤的話, 會是價格最高的那一筆, 如果是賣盤的話,
會是價格最低的那一筆

\- tick_array\[n, 4\] = Volume (成交量),

\- 如果是MultiTick的話, 回的是MultiTick序列最後一筆的成交量,
如果想要得到整組MultiTick的成交量(加總)的話, 請讀取tick_array\[n, 10\]

\- tick_array\[n, 5\] = BidAskFlag (內外盤標記, 1=外盤, -1=內盤,
0=不分),

\- tick_array\[n, 6\] = SeqNo (Tick序號, 每日的第一筆從1開始編制,
越來越大)

\- 如果是MultiTick的話, 回的是MultiTick序列最後一筆的Tick序號

\- tick_array\[n, 7\] = 成交方式註記

\- 如果不是台股的話, 這個欄位都會回-1

\- 如果是台股的話, 則依照這一筆成交資料的撮合方式來決定.
如果這一筆是集合競價的話, 回傳-1.

依照目前台股的撮合規則, 每一日的開盤, 收盤, 都是集合競價,
如果商品被處置(分盤交易), 每一筆資料也是集合競價,

如果商品委託價格發生很大的異動時, 交易所可能也會暫緩撮合,
此時也是集合競價.

\- 當這一筆資料被標示成集合競價時, 代表的是, 這一筆資料的價格/數量,
可能是很多個人委託單的合併, 所以XQ統計大單時, 會略過這些資料,

\- 如果是台股, 而且不是集合競價的話(也就是逐筆撮合),
那則依照這一筆是單筆成交, 還是連續成交序列(MultiTick)來判斷,

\- 如果是單筆成交的話, 回傳0, 如果是連續成交序列的話,
則回傳連續成交序列的筆數

\- tick_array\[n, 8\] (請看底下說明)

\- tick_array\[n, 9\] (請看底下說明)

\- tick_array\[n, 10\] = 成交量加總

\- 如果不是MultiTick的話, tick_array\[n, 10\]的數值跟tick_array\[n,
4\]是一樣的

\- 如果是MultiTick的話, tick_array\[n,
10\]的數值是這一組MultiTick每一筆成交量的加總

\- tick_array\[n, 11\] = 成交值加總(股票適用)

\- 如果不是MultiTick的話, tick_array\[n,
11\]是這一筆成交資料的成交值(元)

\- 如果是MultiTick的話, tick_array\[n,
10\]的數值是這一組MultiTick每一筆成交值的加總

應用方式:

value1 = ReadTicks(tick_array, readtick_cookie);

for idx = 1 to value1 begin

if tick_array\[idx, 7\] = -1 then begin

// 集合撮合: 不判斷這一筆是否是大單

end else begin

// 逐筆撮合:
可以用tick_array\[10\]跟tick_array\[11\]來判斷這一筆資料的成交量/成交金額

//

if tick_array\[idx, 10\] \>= 400 then ret=1; // 400張的大單

if tick_array\[idx, 11\] \>= 100\*10000 then ret=1; // 100萬的大單

end;

end;

\- tick_array\[n, 8\] =
這一筆資料與目前系統最新一筆Tick的資料間隔(offset)

\- 如果這是MultiTick的話, 則\[n,
8\]回傳的是MultiTick序列內「第一筆資料」與目前系統最新一筆tick的offset,

\- 如果這不是MultiTick的話, 則\[n,
8\]回傳的是這一筆資料與目前系統最新一筆tick的offset,

\- 這個欄位的主要目的,
是讓使用者如果想要讀取MultiTick內「每一筆成交紀錄」時可以使用,
請參考底下的範例

\- tick_array\[n, 9\] =
這一筆資料與目前系統最新一筆Tick的資料間隔(offset)

\- 如果這是MultiTick的話, 則\[n,
9\]回傳的是MultiTick序列內「最後一筆資料」與目前系統最新一筆tick的offset,

\- 如果這不是MultiTick的話, 則\[n,
9\]回傳的是這一筆資料與目前系統最新一筆tick的offset,

應用方式:

value1 = ReadTicks(tick_array, readtick_cookie);

for idx = 1 to value1 begin

if tick_array\[idx, 7\] \> 0 then begin

// 這是一個MultiTick

// 以下的寫法是從第一筆scan到最後一筆, 如果是買盤的話, 則價格由低到高,
如果是賣盤的話, 則價格由高到低

//

for j = tick_array\[\_i, 8\] downto tick_array\[\_i, 9\] begin

value11 = GetField(\"Close\", \"Tick\")\[j\]; // MultiTick:
其中一筆成交價

value12 = GetField(\"Volume\", \"Tick\")\[j\]; // MultiTick:
其中一筆成交量

end;

end;

end;

}

input: tick_array\[X,Y\](NumericArray); { 參數1:
傳入要儲存tick資料的array }

input: readtick_cookie(NumericRef); { 參數2: Cookie:
儲存最後一次\*\*處理\*\*完畢的Tick編號 }

if Y \< 10 then raiseruntimeerror(\"tick_array的第二維至少要 \>= 10\");

var: \_cur_tickseq(0), \_row(0), \_i(0);

var: \_last_multitick_start(0);

var: \_lotsize(-1);

\_cur_tickseq = GetField(\"SeqNo\", \"Tick\");

if readtick_cookie \> \_cur_tickseq then

readtick_cookie = 0;

if \_lotsize \< 0 then begin

if symbolType = 2 then

\_lotsize = GetSymbolInfo(\"交易單位\")

else

\_lotsize = 1;

end;

// 從上次到目前的資料範圍: readtick_cookie+1 .. \_cur_tickseq

//

\_i = \_cur_tickseq;

\_row = 1;

\_last_multitick_start = 0;

while \_i \> readtick_cookie and \_row \<= X begin

value1 = GetField(\"Date\", \"Tick\")\[\_cur_tickseq - \_i\];

value2 = GetField(\"Time\", \"Tick\")\[\_cur_tickseq - \_i\];

value3 = GetField(\"Close\", \"Tick\")\[\_cur_tickseq - \_i\];

value4 = GetField(\"Volume\", \"Tick\")\[\_cur_tickseq - \_i\];

value5 = GetField(\"BidAskFlag\", \"Tick\")\[\_cur_tickseq - \_i\];

value6 = GetField(\"SeqNo\", \"Tick\")\[\_cur_tickseq - \_i\];

value7 = GetField(\"TickGroup\", \"Tick\")\[\_cur_tickseq - \_i\];

if value7 = 0 or value7 = -1 then begin

// 不是MultiTick

//

tick_array\[\_row, 1\] = value1; // Date

tick_array\[\_row, 2\] = value2; // Time

tick_array\[\_row, 3\] = value3; // Close

tick_array\[\_row, 4\] = value4; // Volume

tick_array\[\_row, 5\] = value5; // BidAskFlag

tick_array\[\_row, 6\] = value6; // SeqNo

if Y = 10 then

tick_array\[\_row, 7\] = 0 // (舊版邏輯) 不是MultiTick: 回0

else

tick_array\[\_row, 7\] = value7; // (新版邏輯) 不是MultiTick:
回這一筆的TickGroup

tick_array\[\_row, 8\] = \_cur_tickseq - value6; // 這一筆的offset

tick_array\[\_row, 9\] = \_cur_tickseq - value6; // 這一筆的offset

tick_array\[\_row, 10\] = value4; // Volume

if Y \> 10 then

tick_array\[\_row, 11\] = value3 \* value4 \* \_lotsize; // (新版邏輯)
成交金額

\_row = \_row + 1;

\_i = \_i - 1;

end else begin

// 這是MultiTick

//

// value7的內容應該是1, 2, 2, 3 (從舊到新)

//

var: \_total_v(0), \_total_pv(0), \_count(0);

var: \_complete(false);

\_complete = false;

\_count = 1;

\_i = \_i - 1;

\_total_v = value4;

\_total_pv = value3 \* value4 \* \_lotsize;

if value7 = 1 then begin

\_complete = true;

end else begin

while not \_complete and \_i \> readtick_cookie begin

value33 = GetField(\"Close\", \"Tick\")\[\_cur_tickseq - \_i\];

value44 = GetField(\"Volume\", \"Tick\")\[\_cur_tickseq - \_i\];

value66 = GetField(\"SeqNo\", \"Tick\")\[\_cur_tickseq - \_i\];

value77 = GetField(\"TickGroup\", \"Tick\")\[\_cur_tickseq - \_i\];

\_total_v = \_total_v + value44;

\_total_pv = \_total_pv + value33 \* value44 \* \_lotsize;

\_i = \_i - 1;

\_count = \_count + 1;

if value77 = 1 then \_complete = true;

end;

end;

// 三種情形

// case#1: \_complete 而且 value7(最新一筆的標記) =3 =\>
我們讀到了一個完整的multitick序列

// case#2: \_complete 可是 value7不是3

// =\> 這個表示我們收到了一個multitick序列的開頭, 可是結尾還沒有收到

// case#2a =\> 如果這種情形發生在最新的資料端,
那我們可以等待下一次洗價時再來處理

// Example: 0, 0, 0, 1 (2, 3 is coming)

// case#2b =\> 如果這種情形發生在最新的資料端,
那我們可以等待下一次洗價時再來處理

// Example: 0, 0, 0, 1, 2, 2 (3 is coming)

// case#2c =\> 可是如果這種情形是發生在中間的話, 那就是資料有問題了,
例如

// Example: 0, 0, 0, 1 (where is 3 ?) 0, 0

// case#3: not \_complete =\>
這個表示這一整批資料的第一筆竟然不是multitick序列的開頭, 可能有人傳錯
readtick_cookie了 ?

// Example: (where is 1 ?) 2, 2, 2, 3

//

// 如果是 case#2a的話, 目前收到的multitick資料就先不處理,
等下一次呼叫時再來處理

// 其餘情形我們就組一筆MultiTick的資料

//

if \_complete and value7 \<\> 3 and \_row = 1 then begin

// 紀錄這一批multitick的第一筆, 當成下一次的開始

//

\_last_multitick_start = \_i;

end else begin

tick_array\[\_row, 1\] = value1; // Date

tick_array\[\_row, 2\] = value2; // Time

tick_array\[\_row, 3\] = value3; // Close = MultiTick最後一筆的價格

tick_array\[\_row, 4\] = value4; // Volume

tick_array\[\_row, 5\] = value5; // BidAskFlag

tick_array\[\_row, 6\] = value6; // SeqNo

tick_array\[\_row, 7\] = \_count; // MultiTick的筆數

tick_array\[\_row, 8\] = \_cur_tickseq - value66; // MultiTick
第一筆的位置

tick_array\[\_row, 9\] = \_cur_tickseq - value6; // MultiTick
最後一筆的位置

tick_array\[\_row, 10\] = \_total_v; // MultiTick的總成交量

if Y \> 10 then

tick_array\[\_row, 11\] = \_total_pv; // (新版邏輯)
成交金額(MultiTick加總)

\_row = \_row + 1;

end;

end;

end;

if \_last_multitick_start \<\> 0 then begin

readtick_cookie = \_last_multitick_start;

end else begin

readtick_cookie = \_cur_tickseq;

end;

retval = \_row - 1; // 回傳的筆數

#### 📄 Summation

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

variable:Sum(0),SumLength(0);

Sum=0;

for SumLength = 0 to Length - 1

begin

Sum = Sum + thePrice\[SumLength\];

end;

Summation = Sum;

#### 📄 TrueRange

{@type:function}

SetBarMode(1);

TrueRange = TrueHigh - TrueLow;

#### 📄 UpLimit

{@type:function}

SetBarMode(1);

input:refPrice(numericsimple);

variable:obup1(0),obdw1(0),STOCKUP(0),STOCKDW(0);

if date \< 20150601 then begin

obup1= refPrice\*1.07;

obdw1= refPrice\*0.93;

end else begin

obup1= refPrice\*1.1;

obdw1= refPrice\*0.9;

end;

if (obup1\<10 and obdw1\<10) then begin

STOCKUP = ((floor((floor(obup1\*100)\*100)))/100)/100;

STOCKDW = ((floor((ceiling(obdw1\*100)\*100)))/100)/100;

end else if (obup1\>=10 and obdw1\<10) then begin

STOCKUP = ((floor(((floor(obup1/0.05)\*0.05)\*100)\*100))/100)/100;

STOCKDW = ((floor((ceiling(obdw1\*100)\*100)))/100)/100;

end else if (obup1\>=10 and obdw1\>=10 and obup1\<50 and obdw1\<50) then
begin

STOCKUP = ((floor(((floor(obup1/0.05)\*0.05)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/0.05)\*0.05)\*100)\*100))/100)/100;

end else if (obup1\>=50 and obdw1\<50 ) then begin

STOCKUP = ((floor(((floor(obup1/0.1)\*0.1)\*100)\*100))/100)/100;

STOCKDW = (ceiling(obdw1/0.05)\*0.05);

end else if (obup1\>=50 and obdw1\>=50 and obup1\<100 and obdw1\<100)
then begin

STOCKUP = ((floor(((floor(obup1/0.1)\*0.1)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/0.1)\*0.1)\*100)\*100))/100)/100;

end else if (obup1\>=100 and obdw1\<100 ) then begin

STOCKUP = ((floor(((floor(obup1/0.5)\*0.5)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/0.1)\*0.1)\*100)\*100))/100)/100;

end else if (obup1\>=100 and obdw1\>=100 and obup1\<500 and obdw1\<500)
then begin

STOCKUP = ((floor(((floor(obup1/0.5)\*0.5)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/0.5)\*0.5)\*100)\*100))/100)/100;

end else if (obup1\>=500 and obdw1\<500) then begin

STOCKUP = ((floor(((floor(obup1/0.5)\*0.5)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/0.1)\*0.1)\*100)\*100))/100)/100;

end else if (obup1\>=500 and obdw1\>=500 and obup1\<1000 and
obdw1\<1000) then begin

STOCKUP = ((floor(((floor(obup1/ 1)\* 1)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/ 1)\* 1)\*100)\*100))/100)/100;

end else if (obup1\>=1000 and obdw1\<1000) then begin

STOCKUP = ((floor(((floor(obup1/5)\*5)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/ 1)\* 1)\*100)\*100))/100)/100;

end else if (obup1\>=1000 and obdw1\>=1000) then begin

STOCKUP = ((floor(((floor(obup1/5)\*5)\*100)\*100))/100)/100;

STOCKDW = ((floor(((ceiling(obdw1/5)\*5)\*100)\*100))/100)/100;

end;

UpLimit = STOCKUP;

#### 📄 WMA

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(Numeric); //\"計算期間\"

variable: Factor(0);

if Factor = 0 then Factor = 0.5 \* Length \* (Length+1);

if CurrentBar \< Length then

WMA = thePrice

else begin

WMA = Length \* thePrice;

for value1 = 1 to Length - 1

WMA += thePrice\[value1\] \* (Length - value1);

WMA = WMA/Factor;

end;

#### 📄 XAverage

{@type:function}

SetBarMode(2);

input:thePrice(numericseries); //\"價格序列\"

input:Length(Numeric); //\"計算期間\"

variable: Factor(0);

if length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);

if CurrentBar = 1 then

XAverage = thePrice

else

XAverage = XAverage\[1\] + Factor \* (thePrice - XAverage\[1\]);

### 1.5 價格關係 (26 個)

#### 📄 Extremes

{@type:function}

SetBarMode(2);

input:

SourceSeries(numericseries), //來源數列

Length(numericsimple), //計算期間

DscAsc(numericsimple), //極大值(1)或極小值(-1)

refExtremeValue(numericref), //輸出極值

refExtremeBar(numericref); //輸出極值K棒相對位置

var:

exLength(0),

exCalcBar(0),

calcInterval(0);

if 1 \> Length then

begin

refExtremeValue = 0 ;

refExtremeBar = -1 ;

extremes = -1 ;

return;

end;

if Length \< exLength or currentbar = 1 or value2 \>= Length - 1 then
//強制進行重算的case

begin

value1 = SourceSeries;

value2 = 0;

for value3 = 1 to Length - 1

begin

if DscAsc \* SourceSeries\[value3\] \> DscAsc \* value1 then

begin

value1 = SourceSeries\[value3\];

value2 = value3;

end;

end;

end else if Length \> exLength and Length - exLength = currentBar -
exCalcBar then //判斷計算長度是否和K棒同步長大，若是，只需要計算差額。

begin

calcInterval = Length - exLength;

for value3 = calcInterval - 1 to 0

begin

if DscAsc \* SourceSeries\[value3\] \>= DscAsc \* value1 then

begin

value1 = SourceSeries\[value3\];

value2 = value3;

end else

value2 = value2 + 1;

end;

end else

begin

if DscAsc \* SourceSeries \>= DscAsc \* value1 then begin

value1 = SourceSeries;

value2 = 0;

end else

value2 = value2 + 1;

end;

exLength = Length;

exCalcBar = currentBar;

refExtremeValue = value1;

refExtremeBar = value2;

extremes = 1;

#### 📄 ExtremesArray

{@type:function}

SetBarMode(1);

input:

SourceArray\[MaxSize\](numericarray), //來源陣列

Size(numericsimple), //來源陣列大小

DscAsc(numericsimple), //極大值(1)或極小值(-1)

refExtremeValue(numericref), //輸出極值

refExtremeIndex(numericref); //輸出極值陣列索引值

variable: price(0),

\_bar(0),

counter(0);

if Size \< 1 or Size \> MaxSize then

begin

refExtremeValue = 0 ;

refExtremeIndex = -1 ;

ExtremesArray = -1 ;

return;

end;

price = SourceArray\[1\];

\_bar = 1;

for counter = 2 to Size

begin

if (DscAsc=1 and SourceArray\[counter\]\>price) then

begin

price = SourceArray\[counter\];

\_bar = counter;

end

else if (DscAsc=-1 and SourceArray\[counter\]\<price) then

begin

price = SourceArray\[counter\];

\_bar = counter;

end;

end;

refExtremeValue = price;

refExtremeIndex = \_bar;

ExtremesArray = 1;

#### 📄 FastHighestBar

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

variable: \_Output(0);

Extremes(ThePrice, Length, 1, value1, \_Output);

FastHighestBar = \_Output;

#### 📄 FastLowestBar

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

variable: \_Output(0);

Extremes(ThePrice, Length, -1, value1, \_Output);

FastLowestbar = \_Output;

#### 📄 HighDays

{@type:function}

SetBarMode(1);

// 計算過去幾筆資料內創新高的次數

//

input: length(numeric); // 計算天期(含當根bar)

variable: tt(0);　　

variable: ix(0);

variable: currentHigh(0);

tt=0;

currentHigh = high\[length-1\];

for ix = length-2 downto 0

begin

if ( high\[ix\] \> currentHigh ) then

begin

tt+=1;　　

currentHigh = high\[ix\];

end;

end;

HighDays=tt;

#### 📄 HighestArray

{@type:function}

SetBarMode(1);

input: thePriceArray\[MaxSize\](NumericArray),ArraySize(numericsimple);

variable: \_Output(0);

ExtremesArray(thePriceArray, ArraySize, 1, \_Output, value2);

HighestArray = \_Output;

#### 📄 HighestBar

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

variable: \_Output(0);

Extremes(ThePrice, Length, 1, value1, \_Output);

HighestBar = \_Output;

#### 📄 LowDays

{@type:function}

SetBarMode(1);

// 計算過去幾筆資料內創新低的次數

//

input: length(numeric); // 計算天期(含當根bar)

variable: tt(0);　　

variable: ix(0);

variable: currentlow(0);

tt=0;

currentlow = low\[length-1\];

for ix = length-2 downto 0

begin

if ( low\[ix\] \< currentlow ) then

begin

tt+=1;　　

currentlow = low\[ix\];

end;

end;

LowDays=tt;

#### 📄 LowestArray

{@type:function}

SetBarMode(1);

input: thePriceArray\[MaxSize\](NumericArray),ArraySize(numericsimple);

variable: \_Output(0);

ExtremesArray(thePriceArray, ArraySize, -1, \_Output, value2);

LowestArray = \_Output;

#### 📄 LowestBar

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

variable: \_Output(0);

Extremes(ThePrice, Length, -1, value1, \_Output);

Lowestbar = \_Output;

#### 📄 MoM

{@type:function}

SetBarMode(1);

input:MomVal(numericseries);

if barfreq \<\> \"M\" and barfreq \<\> \"AM\" then

raiseruntimeerror(\"僅支援月頻率\")

else

MOM = (MomVal/MomVal\[1\]-1)\*100;

#### 📄 NthExtremes

{@type:function}

SetBarMode(1);

input:

SourceSeries(numericseries), //來源數列

Length(numericsimple), //計算期間

N(numericsimple), //極值順序

DscAsc(numericsimple), //極大值(1)或極小值(-1)

refExtremeValue(numericref), //輸出極值

refExtremeBar(numericref); //輸出極值K棒相對位置

array: nthA\[500\](0),nthB\[500\](0);

variable:x(0),y(0),temp(0);

if N\>Length or Length\>500 then

begin

refExtremeValue = 0;

refExtremeBar = -1;

NthExtremes = -1;

end

else

begin

for x = 0 to Length -1

begin

nthA\[x\] = SourceSeries\[x\];

nthB\[x\] = x ;

end;

for x = 0 to Length -2

begin

for y = x + 1 to Length -1

begin

if ((DscAsc=1 and nthA\[x\] \< nthA\[y\])or

(DscAsc=-1 and nthA\[x\] \> nthA\[y\])) then

begin

temp = nthA\[ y \];

nthA\[ y \] = nthA\[ x \];

nthA\[ x \] = temp;

temp = nthB\[ y \];

nthB\[ y \] = nthB\[ x \];

nthB\[ x \] = temp;

end;

end;

end;

refExtremeValue = nthA\[ N-1 \];

refExtremeBar = nthB\[ N-1 \] + ExecOffset;

NthExtremes = 1;

end;

#### 📄 NthExtremesArray

{@type:function}

SetBarMode(1);

input:

SourceArray\[MaxSize\](numericarray), //來源陣列

Size(numericsimple), //來源陣列大小

N(numericsimple), //極值順序

DscAsc(numericsimple), //極大值(1)或極小值(-1)

refExtremeValue(numericref), //輸出極值

refExtremeIndex(numericref); //輸出極值陣列索引值

array: ntharrayA\[200\](0),ntharrayB\[200\](0);

variable: x(0),y(0),temp(0);

variable: startIndex(0),endIndex(0),NIndex(0);

if N \> Size or Size \> MinList(MaxSize+1,200) then

begin

refExtremeValue = 0;

refExtremeIndex = -1;

NthExtremesarray = -1;

end

else

begin

if Size = MaxSize+1 then begin

startIndex = 0;

endIndex = MaxSize;

NIndex = N - 1;

end else begin

startIndex = 1;

endIndex = Size;

NIndex = N;

end;

for x = startIndex to endIndex

begin

ntharrayA\[x\] = SourceArray\[x\];

ntharrayB\[x\] = x;

end;

for x = startIndex to endIndex - 1

begin

for y = x + 1 to endIndex

begin

if((DscAsc = 1 and ntharrayA\[x\] \< ntharrayA\[y\] )or

(DscAsc = -1 and ntharrayA\[x\] \> ntharrayA\[y\])) then

begin

temp = ntharrayA\[x\];

ntharrayA\[x\] = ntharrayA\[y\];

ntharrayA\[y\] = temp;

temp = ntharrayB\[x\];

ntharrayB\[x\] = ntharrayB\[y\];

ntharrayB\[y\] = temp;

end;

end;

end;

refExtremeValue = ntharrayA\[NIndex\];

refExtremeIndex = ntharrayB\[NIndex\];

NthExtremesarray = 1;

end;

#### 📄 NthHighest

{@type:function}

SetBarMode(1);

input: N (numericsimple), thePrice(numericseries),
Length(numericsimple);

variable: \_Output(0);

NthExtremes(thePrice, Length, N, 1, \_Output, value2);

NthHighest = \_Output;

#### 📄 NthHighestArray

{@type:function}

SetBarMode(1);

input: thePriceArray\[MaxSize\](NumericArray), Size(numericsimple), N
(numericsimple);

variable: \_Output(0);

NthExtremesArray(thePriceArray, Size, N, 1, \_Output, value2);

NthHighestArray = \_Output;

#### 📄 NthHighestBar

{@type:function}

SetBarMode(1);

input: N (numericsimple), thePrice(numericseries),
Length(numericsimple);

variable: \_Output(0);

NthExtremes(thePrice, Length, N, 1, value1, \_Output);

NthHighestBar = \_Output;

#### 📄 NthLowest

{@type:function}

SetBarMode(1);

input: N (numericsimple), thePrice(numericseries),
Length(numericsimple);

variable: \_Output(0);

NthExtremes(thePrice, Length, N, -1, \_Output, value2);

NthLowest = \_Output;

#### 📄 NthLowestArray

{@type:function}

SetBarMode(1);

input: thePriceArray\[MaxSize\](NumericArrayRef), Size(numericsimple), N
(numericsimple);

variable: \_Output(0);

NthExtremesArray( thePriceArray, Size, N, -1, \_Output, value2) ;

NthLowestArray = \_Output ;

#### 📄 NthLowestBar

{@type:function}

SetBarMode(1);

input: N (numericsimple), thePrice(numericseries),
Length(numericsimple);

variable: \_Output(0);

NthExtremes(thePrice, Length, N, -1, value1, \_Output);

NthLowestBar = \_Output;

#### 📄 OHLCPeriodsAgo

{@type:function}

SetBarMode(2);

input:

FreqType(numericsimple),
//指定K棒頻率，1:日線、2:週線、3:月線、3.25:季、3.5 半年、4:年線

FreqAgo(numericsimple), //指定K棒位置

refFreqOpen(numericref), //輸出K棒開盤價

refFreqHigh(numericref), //輸出K棒最高價

refFreqLow(numericref), //輸出K棒最低價

refFreqClose(numericref); //輸出K棒收盤價

variable:

varBarFreqInt(-1),

varBarIndex(-1);

array:

arrayO\[200\](-1),

arrayH\[200\](-1),

arrayL\[200\](-1),

arrayC\[200\](-1);

switch (barfreq)

begin

case \"Tick\":

varBarFreqInt = 0;

case \"Min\",\"Hour\":

varBarFreqInt = 1;

case \"D\",\"AD\":

varBarFreqInt = 2;

case \"W\",\"AW\":

varBarFreqInt = 3;

case \"M\",\"AM\",\"Q\",\"H\",\"Y\":

varBarFreqInt = 4;

default:

varBarFreqInt = -1;

end;

if FreqAgo \> 200 or FreqAgo \< 0 or varBarFreqInt = -1 or varBarFreqInt
\> FreqType + 1 then return;

switch (FreqType)

begin

case 2:

condition1 = WeekofYear(Date) \<\> WeekofYear(Date\[1\]) ;

if WeekofYear(Date\[1\]) =53 and DayofWeek(Date)\> DayofWeek(Date\[1\])
then condition1= false;

case 3:

condition1 = Month(Date) \<\> Month(Date\[1\]);

case 3.25:

condition1 = Mod(Month(Date),3)=1 and Mod(Month(Date\[1\]),3)=0 ;

case 3.5:

condition1 = Mod(Month(Date),6)=1 and Mod(Month(Date\[1\]),6)=0 ;

case 4:

condition1 = Year(Date) \<\> Year(Date\[1\]);

default:

condition1 = Date \<\> Date\[1\];

end;

condition1 = CurrentBar = 1 or condition1;

if condition1 then

begin

varBarIndex = varBarIndex - 1;

if varBarIndex \< 0 then varBarIndex = FreqAgo;

arrayO\[varBarIndex\] = Open;

arrayH\[varBarIndex\] = High;

arrayL\[varBarIndex\] = Low;

arrayC\[varBarIndex\] = Close;

end

else

begin

arrayC\[varBarIndex\] = Close;

if High \> arrayH\[varBarIndex\] then

arrayH\[varBarIndex\] = High;

if Low \< arrayL\[varBarIndex\] then

arrayL\[varBarIndex\] = Low;

end;

refFreqOpen = arrayO\[Mod( varBarIndex + FreqAgo, FreqAgo + 1) \];

refFreqHigh = arrayH\[Mod( varBarIndex + FreqAgo, FreqAgo + 1) \];

refFreqLow = arrayL\[Mod( varBarIndex + FreqAgo, FreqAgo + 1) \];

refFreqClose = arrayC\[Mod( varBarIndex + FreqAgo, FreqAgo + 1) \];

OHLCPeriodsAgo = 1;

#### 📄 QoQ

{@type:function}

SetBarMode(1);

input:QoQVal(numericseries);

if barfreq \<\> \"Q\" then

raiseruntimeerror(\"僅支援季頻率\")

else

QoQ = 100\*(QoQVal/QoQVal\[1\]-1);

#### 📄 SimpleHighest

{@type:function}

SetBarMode(1);

input: thePrice(numericseries),Length(numericsimple);

variable: highValue(0);

variable: i(0);

highValue = thePrice\[0\];

for i = 1 to Length-1

begin

if thePrice\[i\] \> highValue then

highValue = thePrice\[i\];

end;

SimpleHighest = highValue;

#### 📄 SimpleHighestBar

{@type:function}

SetBarMode(1);

input: thePrice(numericseries),Length(numericsimple);

variable: highValue(0);

variable: i(0);

variable: barOffset(0);

highValue = thePrice\[0\];

barOffset = 0;

for i = 1 to Length-1

begin

if thePrice\[i\] \> highValue then begin

highValue = thePrice\[i\];

barOffset = i;

end;

end;

SimpleHighestBar = barOffset;

#### 📄 SimpleLowest

{@type:function}

SetBarMode(1);

input: thePrice(numericseries),Length(numericsimple);

variable: lowValue(0);

variable: i(0);

lowValue = thePrice\[0\];

for i = 1 to Length-1

begin

if thePrice\[i\] \< lowValue then

lowValue = thePrice\[i\];

end;

SimpleLowest = lowValue;

#### 📄 SimpleLowestBar

{@type:function}

SetBarMode(1);

input: thePrice(numericseries),Length(numericsimple);

variable: lowValue(0);

variable: i(0);

variable: barOffset(0);

lowValue = thePrice\[0\];

barOffset = 0;

for i = 1 to Length-1

begin

if thePrice\[i\] \< lowValue then begin

lowValue = thePrice\[i\];

barOffset = i;

end;

end;

SimpleLowestBar = barOffset;

#### 📄 YoY

{@type:function}

SetBarMode(1);

input:YoYVal(numericseries);

switch(barfreq)

begin

Case \"M\",\"AM\":

YoY = RateOfChange(YoYVal,12);

Case \"Q\":

YoY = RateOfChange(YoYVal,4);

Case \"Y\":

YoY = RateOfChange(YoYVal,1);

default:

raiseruntimeerror(\"僅支援月、季、年頻率\");

end;

### 1.6 技術指標 (55 個)

#### 📄 ACC

{@type:function}

SetBarMode(1);

{

ACC加速量指標(Acceleration)，用來觀察行情價格變化的加速度幅度，

是MOM運動量指標的再一次計算，使用收盤價，並以相同期間長度計算

Length: 計算期數

}

input: Length(numeric);

value1 = Momentum(Close, Length);

value2 = Momentum(value1, Length);

ACC =value2;

#### 📄 ADI

{@type:function}

SetBarMode(2);

{

輸出ADI指標值:

當日價格是漲時，表示上升力道戰勝，將此力道累積起來。

若當日是下跌，便從上升累積力道中減去下降的力道。

}

variable: ADIt(0);

if Close \> Close\[1\] then

ADIt = ADIt\[1\] + (Close - minlist(low, close\[1\]))

else

begin

if Close \< Close\[1\] then

ADIt = ADIt\[1\] - (maxlist(high, close\[1\]) - close)

else

ADIt = ADIt\[1\];

end;

ADI =ADIt;

#### 📄 ADO

{@type:function}

SetBarMode(1);

{

Accumulation／Distribution Oscillator，「聚散擺盪」指標。

傳回ADO值

}

variable: bp(0), sp(0), adot(0);

bp = High - Open;

sp = Close - Low;

if High \<\> low then

adot = (bp + sp)/(2\*(High - Low))\*100

else

adot = 50;

ADO =adot;

#### 📄 AR

{@type:function}

SetBarMode(2);

{

買賣氣勢強度的測試指標。

AR值高時，代表行情很活潑，當AR值介於0.25\~1.85間時，屬於盤整行情。AR值低時，表示人氣不足

Length: 計算期數

}

input: Length(numeric);

variable: sum(0), art(0);

sum = Summation((Open - Low), Length);

if sum \<\> 0 then

art = 100 \* Summation((High - Open), length) / sum

else

art = art\[1\];

AR = art;

#### 📄 ATR

{@type:function}

SetBarMode(1);

{

傳回平均真實區間

Length: 計算期數

}

input: Length(numeric);

ATR = Average(TrueRange, Length);

#### 📄 BR

{@type:function}

SetBarMode(2);

{

BR買賣願指標:買賣行情雙方力道強弱的參考指標

當BR指標值介於70\~50時，行情為處盤整狀態。

若BR值超過300，表行情處相對高價，應小心回檔。

若BR值低於50，表行情處於相對低價，應注意價位的反彈。

Length: 計算期數

}

input: Length(numeric);

variable: sum(0), brt(0);

sum= Summation((Close\[1\] - Low), length);

if sum \<\> 0 then

brt = 100 \* Summation((High - Close\[1\]), length) / sum

else

brt = brt\[1\];

BR = brt;

#### 📄 Bias

{@type:function}

SetBarMode(1);

// Bias function (for 乖離率相關指標)

//

input: length(numericsimple);

value1 = Average(close, length);

if value1 \<\> 0 then

Bias = ((close / absValue(value1)) - sign(value1)) \* 100

else begin

if close \> 0 then

Bias = 999

else if close \< 0 then

Bias = -999

else

Bias = 0;

end;

#### 📄 BiasDiff

{@type:function}

SetBarMode(1);

{

Bias function (計算乖離率差值)

輸入兩個期間數值,計算並輸出此兩期間的乖離率差

Length1: 短期期數

Length2: 長期期數

}

input: length1(numericsimple),length2(numericsimple);

BiasDiff = Bias(Length1) - Bias(Length2);

#### 📄 BollingerBand

{@type:function}

SetBarMode(1);

// BollingerBand function

//

Input: price(numericseries), length(numericsimple),
\_band(numericsimple);

BollingerBand = Average(price, length) + \_band \* StandardDev(price,
length, 1);

#### 📄 BollingerBandWidth

{@type:function}

// BollingerBand Width function

//

input:

Price(numericseries, \"數列\"),

Length(numericsimple, \"天數\"),

UpperBand(numericsimple, \"上\"),

LowerBand(numericsimple, \"下\");

variable:

up(0), down(0), mid(0), bbandwidth(0);

up = bollingerband(Price, Length, UpperBand);

down = bollingerband(Price, Length, -1 \* LowerBand);

mid = (up + down) / 2;

if mid \<\> 0 then

bollingerbandwidth = 100 \* (up - down) / mid

else

bollingerbandwidth = 0;

#### 📄 CCI

{@type:function}

SetBarMode(1);

{

Length : CCI指標計算期間

}

input: Length(numeric);

cci = CommodityChannel(Length);

#### 📄 CV

{@type:function}

SetBarMode(2);

If CurrentBar = 1 then

CV = Close \* Volume

else

CV = CV\[1\] + (Close - Close\[1\]) \* Volume;

#### 📄 CommodityChannel

{@type:function}

SetBarMode(2);

// CommodityChannel function (for CCI指標)

//

input: length(numericsimple);

variable: avgtp(0);

variable: idx(0);

variable: sumDist(0);

avgtp = average(High + Low + Close, length);

sumDist = 0;

for idx = 0 to length - 1

begin

sumDist = sumDist + AbsValue(avgtp\[idx\] - (High + Low +
Close)\[idx\]);

end ;

sumDist = sumDist / length;

if sumDist \<\> 0 then

CommodityChannel = (High + Low + Close - avgtp) / (0.015 \* sumDist)

else

CommodityChannel = 0;

#### 📄 DIF

{@type:function}

SetBarMode(1);

{

傳回XQ: MACD指標中DIF值

FastLength: 短期期數

SlowLength: 長期期數

}

input: FastLength(numeric), SlowLength(numeric);

variable: price(0);

price = WeightedClose();

DIF = XAverage(price, FastLength) - XAverage(price, SlowLength);

#### 📄 DMO

{@type:function}

SetBarMode(1);

{

DMO指標(Directional Movement Oscillator)以

DMI趨向指標指標中正負DI值，將此二條線合併而成的一條指標線。

Length: 計算期數

}

input: Length(numeric);

variable: pdi_value(0), ndi_value(0), adx_value(0);

DirectionMovement(Length, pdi_value, ndi_value, adx_value);

DMO =(pdi_value - ndi_value);

#### 📄 DPO

{@type:function}

SetBarMode(1);

{

XQ: DPO指標

Detrended Price Oscillator，「非趨勢價格擺盪」指標

Length: 計算期數

}

input: Length(numeric);

DPO = Close - Average(Close, Length)\[(Length /2) + 1\];

#### 📄 D_Value

{@type:function}

SetBarMode(1);

{

XQ: KD指標中的D值

Length:計算期數

Kt:Kt權數

}

input: Length(numeric), Kt(numeric);

variable:\_rsv(0), \_k(0), \_d(0);

Stochastic(Length, Kt, Kt, \_rsv, \_k, \_d);

D_value = \_d;

#### 📄 DirectionMovement

{@type:function}

SetBarMode(2);

// DirectionMovement function (for DMI相關指標)

// Input: length

// Return: pdi_value(+di), ndi_value(-di), adx_value(adx)

//

input:

length(numericsimple),

pdi_value(numericref),

ndi_value(numericref),

adx_value(numericref);

variable:

padm(0), nadm(0), radx(0),

atr(0), pdm(0), ndm(0), tr(0),

dValue0(0), dValue1(0), dx(0),

idx(0);

if currentbar = 1 then

begin

padm = close / 10000;

nadm = padm;

atr = padm \* 5;

radx = 20;

end

else

begin

pdm = maxlist(High - High\[1\], 0);

ndm = maxlist(Low\[1\] - Low, 0);

if pdm \< ndm then

pdm = 0

else

begin

if pdm \> ndm then

ndm = 0

else

begin

pdm = 0;

ndm = 0;

end;

end;

if Close\[1\] \> High then

tr = Close\[1\] - Low

else

begin

if Close\[1\] \< Low then

tr = High - Close\[1\]

else

tr = High - Low;

end;

padm = padm\[1\] + (pdm - padm\[1\]) / length;

nadm = nadm\[1\] + (ndm - nadm\[1\]) / length;

atr = atr\[1\] + (tr - atr\[1\]) / length;

if atr \<\> 0 then begin

dValue0 = 100 \* padm / atr;

dValue1 = 100 \* nadm / atr;

end;

if dValue0 + dValue1 \<\> 0 then

dx = AbsValue(100 \* (dValue0 - dValue1) / (dValue0 + dValue1));

radx = radx\[1\] + (dx - radx\[1\]) / length;

end;

pdi_value = dValue0;

ndi_value = dValue1;

adx_value = radx;

#### 📄 EMP

{@type:function}

SetBarMode(1);

EMP= (AVERAGE(C,3)+AVERAGE(C,6)+AVERAGE(C,12)+AVERAGE(C,24))/4;

#### 📄 ERC

{@type:function}

SetBarMode(1);

{

RC指標變動率的移動平均值(ERC)

Length: 計算期數

EMALength: 平滑期數

}

input: Length(numeric), EMALength(numeric);

if Close\[Length\] \> 0 then

value1 = (Close - Close\[Length\]) / Close\[Length\];

ERC = XAverage(value1, EMALength);

#### 📄 HL_Osc

{@type:function}

SetBarMode(1);

{

XQ: HL-Osc 指標

}

variable: hlot(0);

if TrueRange \<\> 0 then

hlot = 100 \* (H - C\[1\]) / TrueRange

else

hlot = 0;

hl_osc = hlot;

#### 📄 KO成交量擺盪指標

{@type:function}

SetBarMode(2);

Input: Length1(numericsimple, \"短天期\");

Input: Length2(numericsimple, \"長天期\");

variable: kovolume(0), tp(0), ko(0), koaverage(0);

tp = typicalprice;

if tp \>= tp\[1\] then

kovolume = volume

else

kovolume = -volume;

ko = average(kovolume, Length1) - average(kovolume, Length2);

ret = ko;

#### 📄 KST確認指標

{@type:function}

SetBarMode(1);

value1=average(rateofchange(close,12),10);

value2=average(rateofchange(close,20),10);

value3=average(rateofchange(close,30),8);

value4=average(rateofchange(close,40),15);

ret = value1+value2\*2+value3\*3+value4\*4;

#### 📄 K_Value

{@type:function}

SetBarMode(1);

{

XQ: KD指標中的K值

Length:計算期數

RSVt:RSVt權數

}

input: Length(numeric), RSVt(numeric);

variable: \_rsv(0), \_k(0),\_d(0);

Stochastic(Length, RSVt, RSVt, \_rsv, \_k, \_d);

k_value = \_k;

#### 📄 KeltnerLB

{@type:function}

SetBarMode(1);

input:Para(NumericSimple);

//Keltner Channels 的繪製，是以一條指數移動平均線為中間，
然後在上下兩邊依據所謂的\"平均真實範圍值\"來繪出軌道的範圍來。

KeltnerLB = KeltnerMA(20) - ATR(20) \* Para;

#### 📄 KeltnerMA

{@type:function}

SetBarMode(1);

input:n(NumericSimple);

//Keltner Channels 的繪製，是以一條指數移動平均線為中間，
然後在上下兩邊依據所謂的\"平均真實範圍值\"來繪出軌道的範圍來。

KeltnerMA = XAverage(close, n);

#### 📄 KeltnerUB

{@type:function}

SetBarMode(1);

input:Para(NumericSimple);

//Keltner Channels 的繪製，是以一條指數移動平均線為中間，
然後在上下兩邊依據所謂的\"平均真實範圍值\"來繪出軌道的範圍來。

KeltnerUB = KeltnerMA(20) + ATR(20) \* Para;

#### 📄 MACD

{@type:function}

SetBarMode(1);

// MACD function

// Input: Price序列, FastLength, SlowLength, MACDLength

// Output: DifValue, MACDValue, OscValue

//

Input: Price(numericseries), FastLength(numericsimple),
SlowLength(numericsimple), MACDLength(numericsimple);

Input: DifValue(numericref), MACDValue(numericref),
OscValue(numericref);

DifValue = XAverage(price, FastLength) - XAverage(price, SlowLength);

MACDValue = XAverage(DifValue, MACDLength) ;

OscValue = DifValue - MACDValue;

#### 📄 MAM

{@type:function}

SetBarMode(2);

{

XQ: MAM指標 :當日所計算出移動平均值減去n日前的移動平均值

Length:計算平均期數

Distance:相隔期間

}

Input: Length(numeric), Distance(numeric);

Value1 = Average(Close, Length);

Value2 = Average(Close, Length)\[Distance\];

MAM = Value1 - Value2;

#### 📄 MA_Osc

{@type:function}

SetBarMode(1);

{

XQ: MA-Osc :移動平均線擺盪指標。將兩條不同天期的簡單移動平均線相減即得

Length1:第1條平均線期數

Length2:第2條平均線期數

}

input: Length1(numeric), Length2(numeric);

value1 = Average(close, Length1);

value2 = Average(close, Length2);

value3 = (value1 - value2);

ma_osc = value3;

#### 📄 MI

{@type:function}

SetBarMode(1);

{

XQ: MI 質量指標

Length:計算EMA期數

SumLength:計算總和期數

}

input: Length(numeric), SumLength(numeric);

variable: ema1(0), ema2(0), divSeries(0), mit(0);

ema1 = XAverage(High - Low, length);

ema2 = XAverage(ema1, length);

if ema2 \<\> 0 then

divSeries = ema1 / ema2

else

divSeries = 0;

if CurrentBar \>= sumLength then

mit = Summation(divSeries, sumLength)

else

mit = 0;

MI =mit;

#### 📄 MO

{@type:function}

SetBarMode(2);

{

MO運動量震盪指標(Momentum Oscillator)可以說是

MOM運動量指標的另一種的表現方式，

它把原先以絕對數值展現的MOM指標，改成以相對的數值來展現

Length: 計算期數

}

input: Length(numeric);

if Close\[Length\] \> 0 then

mo = 100 \* Close / Close\[Length\]

else

mo=0;

#### 📄 MTM

{@type:function}

SetBarMode(1);

{

以收盤價計算的運動量指標

Length: 計算期數

}

input: Length(numeric);

MTM = Momentum(Close, Length);

#### 📄 MTM_MA

{@type:function}

SetBarMode(2);

{

對收盤價的運動量指標取再次平均價

Length: 計算期數

}

input: Length(numeric);

value1 = Momentum(Close, Length);

if CurrentBar \>= Length then

Value2 = Average(Value1, Length)

else

Value2 = Value1;

mtm_ma = value2;

#### 📄 Momentum

{@type:function}

SetBarMode(2);

// Momentum function

//

input: price(numericseries), length(numericsimple);

Momentum = price - price\[length\];

#### 📄 PSY

{@type:function}

SetBarMode(1);

{

XQ心理線:人氣指標心理線，計算特定期間內，行情上漲期數的比例

Length: 計算期數

}

input: Length(numeric);

PSY = 100 \* CountIf(Close \> Close\[1\], Length) / Length;

#### 📄 PVC

{@type:function}

SetBarMode(1);

Input: Length(numericsimple, \"天數\");

value1 = Average(Volume, Length);

if value1 \<\> 0 then

PVC = 100 \* (Volume - value1) / value1

else

PVC = 0;

#### 📄 PercentB

{@type:function}

// %b from BollingerBand function

//

input:

Price(numericseries, \"數列\"),

Length(numericsimple, \"天數\"),

UpperBand(numericsimple, \"上\"),

LowerBand(numericsimple, \"下\");

variable: up(0), down(0), mid(0);

up = bollingerband(Price, Length, UpperBand);

down = bollingerband(Price, Length, -1 \* LowerBand);

if up - down \<\> 0 then

percentb = 100 \* (Price - down) / (up - down)

else

percentb = 0;

#### 📄 PercentR

{@type:function}

SetBarMode(1);

// PercentR function (for 威廉指標)

//

input: Length(numericsimple);

variable: variableA(0), variableB(0);

variableA = Highest(High, Length);

variableB = variableA - Lowest(Low, Length);

if variableB \<\> 0 then

PercentR = 100 - ((variableA - Close) / variableB) \* 100

else

PercentR = 0;

#### 📄 Q指標

{@type:function}

SetBarMode(2);

input:t1(numericsimple,\"天期\");

input:t2(numericsimple,\"平均天期\");

input:t3(numericsimple,\"雜訊平滑天期\");

variable:Qindicator(0);

value1=close-close\[1\]; //價格變化

value2=summation(value1,t1); //累積價格變化

value3=average(value2,t2);

value4=absvalue(value2-value3); //雜訊

value5=average(value4,t3); //把雜訊移動平均

if value5 = 0 then

Qindicator = 0

else

Qindicator = value3 / value5\*5;

ret = Qindicator;

#### 📄 RC

{@type:function}

SetBarMode(2);

{

RC指標變動率

Length: 計算期數

}

input: Length(numeric);

if Close\[Length\] \> 0 then

RC = (Close - Close\[Length\]) / Close\[Length\]

else

RC=0;

#### 📄 RSI

{@type:function}

SetBarMode(2);

// RSI function (for RSI指標)

//

input: price(numericseries), length(numericsimple);

variable: sumUp(0), sumDown(0), up(0), down(0);

if CurrentBar = 1 then

begin

sumUp = Average(maxlist(price - price\[1\], 0), length);

sumDown = Average(maxlist(price\[1\] - price, 0), length);

end

else

begin

up = maxlist(price - price\[1\], 0);

down = maxlist(price\[1\] - price, 0);

sumUp = sumUp\[1\] + (up - sumUp\[1\]) / length;

sumDown = sumDown\[1\] + (down - sumDown\[1\]) / length;

end;

if sumUp + sumDown = 0 then

RSI = 0

else

RSI = 100 \* sumUp / (sumUp + sumDown);

#### 📄 RSV

{@type:function}

SetBarMode(1);

{

XQ: RSV指標 Raw Stochastic Value

Length: 計算期數

}

input: Length(numeric);

variable: RSVt(3), Kt(3), rsvx(0), k(0), \_d(0);

Stochastic(Length, RSVt, Kt, rsvx, k, \_d);

RSV =rsvx;

#### 📄 SAR

{@type:function}

SetBarMode(2);

// SAR function (for SAR指標)

//

Input: AFInitial(numericsimple);

Input: AFIncrement(numericsimple);

Input: AFMax(numericsimple);

variable:

presar(0), ep(0), upTrend(false), af(0);

if CurrentBar = 1 then

begin

if Close \> Close\[1\] then // 上漲

begin

upTrend = true;

sar = Low\[1\];

ep = High\[1\];

end

else // 下跌

begin

upTrend = false;

sar = High\[1\];

ep = Low\[1\];

end;

af = AFInitial;

presar = sar;

end

else

begin

sar = presar + af \* (ep - presar);

presar = sar;

if upTrend = true then

begin

if High \> ep then // 繼續破high

begin

ep = High;

af = minlist(af + AFIncrement, AFMax);

end;

if sar \>= Low then // 反轉

begin

presar = ep;

ep = Low;

af = AFInitial;

sar = presar;

upTrend = false;

end;

end

else

begin

if Low \< ep then // 繼續破low

begin

ep = Low;

af = minlist(af + AFIncrement, AFMax);

end;

if sar \<= High then // 反轉

begin

presar = ep;

ep = High;

af = AFInitial;

sar = presar;

upTrend = true;

end;

end;

end;

#### 📄 Stochastic

{@type:function}

SetBarMode(2);

// Stochastic function (for KD/RSV相關指標)

//

// Input: length, rsvt, kt

// Return: rsv_value, k_value, d_value

//

input:

length(numericsimple), rsvt(numericsimple), kt(numericsimple),

rsv(numericref), k(numericref), d(numericref);

variable:

maxHigh(0), minLow(0);

maxHigh = Highest(high, length);

minLow = Lowest(low, length);

if maxHigh \<\> minLow then

rsv = 100 \* (close - minLow) / (maxHigh - minLow)

else

rsv = 50;

if currentbar = 1 then

begin

k = 50;

d = 50;

end

else

begin

k = (k\[1\] \* (rsvt - 1) + rsv) / rsvt;

d = (d\[1\] \* (kt - 1) + k) / kt;

end;

stochastic = 1;

#### 📄 TRIX

{@type:function}

SetBarMode(2);

// TRIX function (for TRIX指標)

//

Input: price(numericseries), length(numericsimple);

value1 = XAverage(price, length);

value2 = XAverage(value1, length);

value3 = XAverage(value2, length);

if CurrentBar = 1 then

TRIX = 0

else

begin

if value3\[1\] \<\> 0 then

TRIX = (value3 - value3\[1\]) / value3\[1\]

else

TRIX = 0;

end;

#### 📄 TechScore

{@type:function}

SetBarMode(2);

// 利用多種指標, 計算多空分數

//

variable: count(0);

// 每次計算都要reset

count = 0;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- Arron指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

variable: arron_up(0),arron_down(0),arron_oscillator(0);//arron
oscillator

arron_up=(25-nthhighestbar(1,high,25))/25\*100;

arron_down=(25-nthlowestbar(1,low,25))/25\*100;

arron_oscillator=arron_up-arron_down;

if arron_up \> arron_down and arron_up \> 70 and arron_oscillator \> 50

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- 隨機漫步指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

variable: RWIH(0),RWIL(0);

value1 = standarddev(close,10,1);

value2 = average(truerange,10);

if value1 \<\> 0 and value2 \<\> 0 then

begin

RWIH=(high-low\[9\])/value2\*value1;

RWIL=(high\[9\]-low)/value2\*value1;

end;

if RWIH \> RWIL

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- 順勢指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

variable:bp1(0),abp1(0);

if truerange \<\> 0 then

bp1=(close-close\[1\])/truerange\*100;//順勢指標

abp1=average(bp1,10);

if abp1 \> 0

then count=count+1;

//\-\-\-\-\-\-\-\-\-- CMO錢德動量擺動指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

variable:SU(0),SD(0),CMO1(0), SUSUM(0), SDSUM(0);

if close \>= close\[1\] then

SU=CLOSE-CLOSE\[1\]

else

SU=0;

if close \< close\[1\] then

SD=CLOSE\[1\]-CLOSE

else

SD=0;

SUSUM = summation(SU,9);

SDSUM = summation(sd,9);

if (SUSUM+SDSUM) \<\> 0 then

cmo1=(SUSUM-SDSUM)/(SUSUM+SDSUM)\*100;

if linearregslope(cmo1,5) \> 0

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- RSI指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

variable: rsiShort(0), rsiLong(0);

rsiShort=rsi(close,5);

rsiLong=rsi(close,10);

if rsiShort \> rsiLong and rsiShort \< 90

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- MACD指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

variable: Dif_val(0), MACD_val(0), Osc_val(0);

MACD(Close, 12, 26, 9, Dif_val, MACD_val, Osc_val);

if osc_val \> 0

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- MTM指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

if mtm(10) \> 0

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- KD指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

variable:rsv1(0),k1(0),d1(0);

stochastic(9,3,3,rsv1,k1,d1);

if k1 \> d1 and k1 \< 80

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- DMI指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

variable:pdi_value(0),ndi_value(0),adx_value(0);

DirectionMovement(14,pdi_value,ndi_value,adx_value);

if pdi_value \> ndi_value

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- AR指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

variable: arValue(0);

arValue = ar(26);

if linearregslope(arValue,5) \> 0

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- ACC指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

if acc(10) \> 0

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- TRIX指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

if trix(close,9) \> trix(close,15)

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- SAR指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

if close \> SAR(0.02, 0.02, 0.2)

then count=count+1;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- 均線指標
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--//

if average(close,5) \> average(close,12)

then count=count+1;

// Return value

//

ret = count;

#### 📄 TurnOverRate

{@type:function}

input:period(numericsimple);

value1=GetField(\"股本(億)\",\"D\")\*10000;

value2=average(volume,period);

if value1\<\>0

then value3=value2/value1\*100;

turnoverrate=value3;

#### 📄 VA

{@type:function}

SetBarMode(2);

VA = VA\[1\] + VAO;

#### 📄 VAO

{@type:function}

SetBarMode(1);

variable: support(0), resist(0), hlDiff(0);

support = (Close - Low);

resist = (High - Close);

hlDiff = (High - Low);

if hlDiff = 0 then

VAO = 0

else

VAO = (support - resist) / hlDiff \* v;

#### 📄 VHF

{@type:function}

SetBarMode(2);

{

XQ: VHF指標

Length: 計算期數

}

input: Length(numeric);

Variable: hp(0), lp(0), numerator(0), denominator(0), VHFt(0);

hp = highest(Close, Length);

lp = lowest(Close, Length);

numerator = hp - lp;

denominator = Summation(absvalue((Close - Close\[1\])), Length);

if denominator \<\> 0 then

VHFt = numerator / denominator

else

VHFt = 0;

VHF = VHFt;

#### 📄 VPT

{@type:function}

SetBarMode(2);

// XQ: PVT指標

//

If CurrentBar = 1 then

VPT = 0

else

VPT = VPT\[1\] + (close - close\[1\])/close\[1\] \* Volume;

#### 📄 VR

{@type:function}

SetBarMode(2);

input:Length(numericsimple);

setinputname(1,\"天數\");

variable:UPV(0),DNV(0),NCV(0);

{

VR容量比率

UPV=N日內上漲天數的成交量總合

DNV=N日內下跌天數的成交量總合

NCV=N日內持平天數的成交量總合

}

UPV = SummationIf((C \> C\[1\]), volume, Length);

DNV = SummationIf((C \< C\[1\]), volume, Length);

NCV = SummationIf((C = C\[1\]), volume, Length);

VR = iff(DNV + NCV/2=0,VR\[1\],100 \* (UPV + NCV/2)/(DNV + NCV/2));

#### 📄 VVA

{@type:function}

SetBarMode(2);

// XQ: VVA指標

//

if High \<\> Low then

Value1 = (Close - Open)/(High - Low) \* Volume

else

Value1 = 0;

If CurrentBar = 1 then

VVA = Value1

else

VVA = Value1 + VVA\[1\];

#### 📄 WAD

{@type:function}

SetBarMode(2);

{

XQ: WA/D 指標

}

variable: wadt(0), adt(0);

if CurrentBar = 1 then

wadt = 0

else

begin

if close = close\[1\] then

adt = 0

else

begin

if close \< close\[1\] then

adt = close - TrueHigh

else

adt = close - TrueLow;

end;

wadt = adt + wadt\[1\];

end;

WAD = wadt;

### 1.7 排行 (6 個)

#### 📄 乖離率排行榜

{@type:function}

SetBarMode(1);

// 這是一個自訂排行條件的範例

// 示範如何針對內建函數的回傳值進行排序

// 使用者可以自行替換成需要使用的函數

//

// Length是期數

//

input:

Length(5, numericsimple, \"計算期間\");

retval = bias(Length);

#### 📄 外資連續買超排行榜

{@type:function}

SetBarMode(1);

// 這是一個自訂排行條件的範例

// 示範如何依外資連續N期買超的張數進行排序

// 使用者可以自行替換成需要使用的欄位

//

// Length是期數

//

input:

Length(10, numericsimple, \"計算期間\");

if TrueAll(GetField(\"外資買賣超\") \> 0, Length) Then

retval = Summation(GetField(\"外資買賣超\"), Length)

Else

return;

{

//如果要排序投信連續買超，可以改用\"投信買賣超\"的欄位:

if TrueAll(GetField(\"投信買賣超\") \> 0, Length) Then

retval = Summation(GetField(\"投信買賣超\"), Length)

Else

return;

//如果要排序自營商連續買超，可以改用\"自營商買賣超\"的欄位:

if TrueAll(GetField(\"自營商買賣超\") \> 0, Length) Then

retval = Summation(GetField(\"自營商買賣超\"), Length)

Else

return;

//可以依需要自行更換欄位

}

#### 📄 收盤價排行榜

{@type:function}

SetBarMode(1);

// 這是一個自訂排行條件的範例

// 示範如何針對特定欄位的數值進行排序

// 使用者可以自行替換成需要使用的欄位

//

//

retval = GetField(\"收盤價\");

{

//同理，當日漲跌幅的排行榜就會是：

retval = GetField(\"漲跌幅\");

}

#### 📄 收盤均價排行榜

{@type:function}

SetBarMode(1);

// 這是一個自訂排行條件的範例

// 示範如何針對特定欄位的N期平均進行排序

// 使用者可以自行替換成需要使用的欄位

//

// Length是期數

input:

Length(3, numericsimple, \"計算期間\");

retval = Average(GetField(\"收盤價\"),Length);

{

//如果想做均量的排行榜，只需要更換欄位為成交量：

retval = Average(GetField(\"成交量\"),Length);

}

#### 📄 漲幅排行榜

{@type:function}

SetBarMode(1);

// 這是一個自訂排行條件的範例

// 示範如何針對特定欄位的N期增幅進行排序

// 使用者可以自行替換成需要使用的欄位

//

// Length是期數

input:

Length(20, numericsimple, \"計算期間\");

retval = rateofchange(GetField(\"收盤價\"),Length);

#### 📄 跌幅排行榜

{@type:function}

SetBarMode(1);

// 這是一個自訂排行條件的範例

// 示範如何針對特定欄位的N期減幅進行排序

// 使用者可以自行替換成需要使用的欄位

//

// Length是期數

input:

Length(20, numericsimple, \"計算期間\");

retval = -rateofchange(GetField(\"收盤價\"),Length);

### 1.8 日期相關 (8 個)

#### 📄 BarsLast

{@type:function}

SetBarMode(2);

input: pX(TrueFalseSeries);

if pX then value1 = currentbar;

BarsLast = currentbar - value1;

#### 📄 DateTime

{@type:function}

setbarmode(1);

datetime = date\*1000000 + time;

#### 📄 DaysToExpiration

{@type:function}

SetBarMode(1);

// 傳入到期月份/年份, 回傳資料日期與到期日之間還差幾日

// 範例: Value1 = DaysToExpiration(4, 2013)

//

input:

\_ExpiredM(numericsimple),

\_ExpiredY(numericsimple);

variable:

lastTradeDate(0);

lastTradeDate = GetLastTradeDate(\_ExpiredM, \_ExpiredY);

DaysToExpiration = DateDiff(lastTradeDate, Date) + 1;

#### 📄 FormatMQY

{@type:function_string}

SetBarMode(1);

input:Date1(numericsimple);

value1 = ceiling(month(Date1)/3);

switch (Barfreq) Begin

case \"M\",\"AM\":

formatMQY = Formatdate(\"yyyyMM\",Date1);

case \"Q\" :

formatMQY = Formatdate(\"yyyy\",Date1) + \"Q\" + numtostr(value1,0);

case \"Y\" :

formatMQY = Formatdate(\"yyyy\",Date1);

default:

formatMQY = Formatdate(\"yyyyMMdd\",Date1);

end;

#### 📄 GetBarOffsetForYears

{@type:function}

{

計算BarOffset for N years

return 0 if out-of-range

}

input: years(numericsimple, \"N年\");

value1 = DateAdd(Date, \"Y\", -1 \* years);

retval = GetBarOffset(value1);

#### 📄 GetLastTradeDate

{@type:function}

SetBarMode(1);

// 傳入到期月份/年份, 回傳台灣期交所指數期貨的到期日

// (不考慮國定假日等特殊事件)

//

input:

\_ExpiredM(numericsimple),

\_ExpiredY(numericsimple);

GetLastTradeDate =
NthDayofMonth(EncodeDate(\_ExpiredY,\_ExpiredM,1),3,3);

#### 📄 LastDayOfMonth

{@type:function}

SetBarMode(1);

input: SelectedMonth(numericsimple);

value1 = dateadd(EncodeDate(year(date),SelectedMonth,1),\"M\",1);

value2 = dateadd(value1,\"D\",-DayOfMonth(value1));

retval = DayOfMonth(value2);

#### 📄 NthDayOfMonth

{@type:function}

SetBarMode(1);

// 計算自某一天起算的第N個星期序數的日期

//

input: StartDate(numericsimple), Nth(numericsimple),
TargetDay(numericsimple);

variable: OddDaysOfWeek(0);

OddDaysOfWeek = TargetDay - DayOfWeek(StartDate);

If OddDaysOfWeek \> 0 Then

NthDayofMonth = dateadd(startdate,\"D\", iff(Nth \>= 0,(Nth - 1 ),Nth)
\* 7 + OddDaysOfWeek)

Else if OddDaysOfWeek \< 0 Then

NthDayofMonth = dateadd(startdate,\"D\", iff(Nth \>= 0,Nth,(Nth + 1)) \*
7 + OddDaysOfWeek)

Else

NthDayofMonth = dateadd(startdate,\"D\", iff(Nth \>= 0,Nth - 1, Nth + 1)
\* 7);

### 1.9 期權相關 (10 個)

#### 📄 BSDelta

{@type:function}

SetBarMode(1);

input:

iCallPutFlag(stringsimple), //C表買權、P表賣權

iSpotPrice(numericsimple), //標的價格

iStrikePrice(numericsimple), //履約價

iDtoM(numericsimple), //到期天數

iRate100(numericsimple), //無風險利率

iB100(numericsimple), //持有成本

//股票選擇權 b=r-殖利率

//期貨選擇權 b=0

//外匯選擇權 b=r-外國無風險利率

iVolity100(numericsimple); //波動率

variable: \_Output(0);

blackscholesmodel(iCallPutFlag,iSpotPrice,iStrikePrice,iDtoM,iRate100,iB100,iVolity100,

value1,\_Output,value3,value4,value5,value6);

BSDelta = \_Output;

#### 📄 BSGamma

{@type:function}

SetBarMode(1);

input:

iCallPutFlag(stringsimple), //C表買權、P表賣權

iSpotPrice(numericsimple), //標的價格

iStrikePrice(numericsimple), //履約價

iDtoM(numericsimple), //到期天數

iRate100(numericsimple), //無風險利率

iB100(numericsimple), //持有成本

//股票選擇權 b=r-殖利率

//期貨選擇權 b=0

//外匯選擇權 b=r-外國無風險利率

iVolity100(numericsimple); //波動率

variable: \_Output(0);

blackscholesmodel(iCallPutFlag,iSpotPrice,iStrikePrice,iDtoM,iRate100,iB100,iVolity100,

value1,value2,\_Output,value4,value5,value6);

BSGamma = \_Output;

#### 📄 BSPrice

{@type:function}

SetBarMode(1);

input:

iCallPutFlag(stringsimple), //C表買權、P表賣權

iSpotPrice(numericsimple), //標的價格

iStrikePrice(numericsimple), //履約價

iDtoM(numericsimple), //到期天數

iRate100(numericsimple), //無風險利率

iB100(numericsimple), //持有成本

//股票選擇權 b=r-殖利率

//期貨選擇權 b=0

//外匯選擇權 b=r-外國無風險利率

iVolity100(numericsimple); //波動率

variable: \_Output(0);

blackscholesmodel(iCallPutFlag,iSpotPrice,iStrikePrice,iDtoM,iRate100,iB100,iVolity100,

\_Output,value2,value3,value4,value5,value6);

BSPrice = \_Output;

#### 📄 BSTheta

{@type:function}

SetBarMode(1);

input:

iCallPutFlag(stringsimple), //C表買權、P表賣權

iSpotPrice(numericsimple), //標的價格

iStrikePrice(numericsimple), //履約價

iDtoM(numericsimple), //到期天數

iRate100(numericsimple), //無風險利率

iB100(numericsimple), //持有成本

//股票選擇權 b=r-殖利率

//期貨選擇權 b=0

//外匯選擇權 b=r-外國無風險利率

iVolity100(numericsimple); //波動率

variable: \_Output(0);

blackscholesmodel(iCallPutFlag,iSpotPrice,iStrikePrice,iDtoM,iRate100,iB100,iVolity100,

value1,value2,value3,value4,\_Output,value6);

BSTheta = \_Output;

#### 📄 BSVega

{@type:function}

SetBarMode(1);

input:

iCallPutFlag(stringsimple), //C表買權、P表賣權

iSpotPrice(numericsimple), //標的價格

iStrikePrice(numericsimple), //履約價

iDtoM(numericsimple), //到期天數

iRate100(numericsimple), //無風險利率

iB100(numericsimple), //持有成本

//股票選擇權 b=r-殖利率

//期貨選擇權 b=0

//外匯選擇權 b=r-外國無風險利率

iVolity100(numericsimple); //波動率

variable: \_Output(0);

blackscholesmodel(iCallPutFlag,iSpotPrice,iStrikePrice,iDtoM,iRate100,iB100,iVolity100,

value1,value2,value3,\_Output,value5,value6);

BSVega = \_Output;

#### 📄 BlackScholesModel

{@type:function}

SetBarMode(1);

input:

iCallPutFlag(stringsimple), //C表買權、P表賣權

iSpotPrice(numericsimple), //標的價格

iStrikePrice(numericsimple), //履約價

iDtoM(numericsimple), //到期天數

iRate100(numericsimple), //無風險利率

iB100(numericsimple), //持有成本

//股票選擇權 b=r-殖利率

//期貨選擇權 b=0

//外匯選擇權 b=r-外國無風險利率

iVolity100(numericsimple), //波動率

oOptPriceValue(numericref), //選擇權理論價

oDelta(numericref), //Delta

oGamma(numericref), //Gamma

oVega(numericref), //Vega

oTheta(numericref), //Theta

oRho(numericref); //Rho

variable:

optiontype(iff(upperstr(iCallPutFlag)=\"P\",-1,1)),

d1(0),d2(0),nd1(0),nd2(0),nd1_prob(0),iRate(0),iB(0),iVolity(0),

ty(0.002739726027),

t(iDtoM\*ty);

optiontype = iff(upperstr(iCallPutFlag)=\"P\",-1,1);

t = iDtoM\*ty;

iRate = iRate100\*0.01;

iB = iB100\*0.01;

iVolity = iff(iVolity100=0,0.00000001,iVolity100\*0.01);

t = iDtoM\*ty;

If t \> 0 Then

begin

d1 = (Log(iSpotPrice / iStrikePrice) + (iB + square(iVolity) \* 0.5) \*
t) / (iVolity \* SquareRoot(t));

d2 = d1 - iVolity \* SquareRoot(t);

Nd1 = NormSDist(d1 \* optiontype);

Nd2 = NormSDist(d2 \* optiontype);

Nd1_Prob = ExpValue( -Square(d1) \* 0.5 ) \* 0.398942280407;

oOptPriceValue = (iSpotPrice \* ExpValue((iB - iRate) \* t) \* Nd1 -
iStrikePrice \* ExpValue(-iRate \* t) \* Nd2) \* optiontype;

oDelta = ExpValue((iB - iRate) \* t) \* Nd1 \* optiontype;

oGamma = ExpValue((iB - iRate) \* t) \* Nd1_Prob / (iSpotPrice \*
iVolity \* SquareRoot(t));

oVega = iSpotPrice \* ExpValue((iB - iRate) \* t) \* SquareRoot(t) \*
Nd1_Prob \* 0.01;

oTheta = (-iSpotPrice \* ExpValue((iB - iRate) \* t) \* Nd1_Prob \*
iVolity / (2 \* SquareRoot(t)) - optiontype \* ((iB - iRate) \*
iSpotPrice \* ExpValue((iB - iRate) \* t) \* Nd1 + iRate \* iStrikePrice
\* ExpValue(-iRate \* t) \* Nd2)) \* ty;

oRho = iff(iB \<\> 0, (t \* iStrikePrice \* ExpValue(-iRate \* t) \*
Nd2) \* optiontype \* 0.0001, -t \* oOptPriceValue \* 0.0001);

end else begin

oOptPriceValue=maxlist((iSpotPrice - iStrikePrice) \* optiontype, 0);

oDelta=iff(iSpotPrice \> iStrikePrice,0.5 \* (1 + optiontype),

iff(iSpotPrice \< iStrikePrice,0.5 \* (1 + optiontype),

0.5 \* optiontype));

oGamma=iff(iSpotPrice \<\> iStrikePrice,0,1);

oVega=0;

oTheta=0;

oRho=0;

end;

blackscholesmodel = 1;

#### 📄 DaysToExpirationTF

{@type:function}

SetBarMode(1);

variable:string1(\"\"),string2(\"\"),string3(\"\");

variable:strike(0),cpflag(\"\"),ww(0),mm(0),yy(0);

if instr(symbol,\".TF\") = 0 then

raiseruntimeerror(\"僅支援台股期貨及選擇權\")

else

string1 = leftstr(symbol,strlen(symbol) - 3);

if leftstr(string1,1) = \"F\" or midstr(string1,3,1) = \"O\" then

begin

yy = year(date);

if leftstr(string1,1) = \"F\" then

mm = strtonum(midstr(string1,5,2))

else

mm = strtonum(midstr(string1,4,2));

if mm = 0 then begin

mm = month(date);

value1 = 0;

while (value1 \< strtonum(rightstr(string1,1)))

begin

daystoexpirationtf = daystoexpiration(mm,yy);

if (daystoexpirationtf \> 0) then value1 = value1 + 1;

value99 = DateAdd(encodedate(yy,mm,1),\"M\",1);

mm = month(value99);

yy = year(value99);

end;

return;

end;

daystoexpirationtf = daystoexpiration(mm,yy);

return;

end else if leftstr(string1,2) = \"TX\" then

begin

value99 = NthDayofMonth(date,1,3);

daystoexpirationtf = DateDiff(value99, Date) + 1;

return;

end;

daystoexpirationtf = -1;

#### 📄 HVolatility

{@type:function}

SetBarMode(1);

input:

thePrice(numericseries),

Length(numericsimple);

variable:

vTradingDays(SquareRoot(260));

vTradingDays = SquareRoot(260);

if thePrice\[1\] = 0 then

value1 = 0

else

value1 = Log(thePrice / thePrice\[1\]);

HVolatility = 100 \* vTradingDays \* StandardDev(value1, Length, 0) ;

#### 📄 IVolatility

{@type:function}

SetBarMode(1);

input:

iCallPutFlag(stringsimple), //C表買權、P表賣權

iSpotPrice(numericsimple), //標的價格

iStrikePrice(numericsimple), //履約價

iDtoM(numericsimple), //到期天數

iRate100(numericsimple), //無風險利率

iB100(numericsimple), //持有成本

//股票選擇權 b=r-殖利率

//期貨選擇權 b=0

//外匯選擇權 b=r-外國無風險利率

iPrice(numericsimple); //選擇權現價

variable:

var1( 0 ),

var2( 0 ),

var3( 0 ),

var4( 0 ) ;

condition1 = iDtoM \> 0 and iStrikePrice \> 0 and iSpotPrice \> 0 ;

if condition1 then

begin

var1 = 100 ;

var2 = bsprice(iCallPutFlag, iSpotPrice, iStrikePrice, iDtoM, iRate100,
iB100, var1);

while var2 \< iPrice and var1 \<= 900

begin

var1 = var1 + 100 ;

var2 = bsprice(iCallPutFlag, iSpotPrice, iStrikePrice, iDtoM, iRate100,
iB100, var1);

end ;

if var2 \< iPrice then

ivolatility= 999

else

begin

var3 = 1 ;

var4 = 100 ;

while AbsValue( var2 - iPrice ) \>= .005 and var3 \< 11

begin

var4 = var4 \* .5 ;

if var2 \> iPrice then

var1 = var1 - var4

else if var2 \< iPrice then

var1 = var1 + var4 ;

var2 = bsprice(iCallPutFlag, iSpotPrice, iStrikePrice, iDtoM, iRate100,
iB100, var1);

var3 = var3 + 1 ;

end ;

ivolatility= var1 ;

end ;

end

else

ivolatility= 0 ;

#### 📄 NormSDist

{@type:function}

SetBarMode(1);

//利用多項式計算近似值，精確度到小數點以下六位。

input:

zvalue(numericsimple);

variable:

a1(0.31938153),

a2(-0.356563782),

a3(1.781477937),

a4(-1.821255978),

a5(1.330274429),

sqrtof2pi(2.506628275),

gamma(0.2316419);

value1 = 1 / ( 1 + gamma \* AbsValue( zvalue ) ) ;

value2 = ExpValue( -Square( zvalue ) \* .5 ) / sqrtof2pi ;

value3 = 1 - value2 \* ( ( ( ( ( a5 \* value1 + a4 ) \* value1 + a3 ) \*
value1 + a2 ) \* value1 + a1 )

\* value1 ) ;

if zvalue \< 0 then

NormSDist = 1 - value3

else

NormSDist = value3;

### 1.10 統計分析 (6 個)

#### 📄 CoefficientR

{@type:function}

SetBarMode(1);

input:Indep(numericseries);{說明:獨立的K棒值}

input:Dep(numericseries);{說明:不獨立的K棒值}

input:Length(numericsimple);{說明:過去N期}

{

Sum((Xi-Xb)\*(Yi-Yb))

r =
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Sqrt(Sum((Xi-Xb)(Xi-Xb)) \* Sum((Yi-Yb)\*(Yi-Yb)))

}

variable:

idx(0), Xb(0), Yb(0), sumXiXb(0), sumYiYb(0), sumCovar(0);

CoefficientR = 0;

if Length \<= 0 Then Return;

Xb = average(Indep, Length);

Yb = average(Dep, Length);

sumXiXb = 0;

sumYiYb = 0;

sumCovar = 0;

for idx = 0 to Length - 1

begin

sumXiXb = sumXiXb + (Indep\[idx\] - Xb) \* (Indep\[idx\] - Xb);

sumYiYb = sumYiYb + (Dep\[idx\] - Yb) \* (Dep\[idx\] - Yb);

sumCovar = sumCovar + (Indep\[idx\] - Xb) \* (Dep\[idx\] - Yb);

end;

if sumXiXb \<\> 0 and sumYiYb \<\> 0 then

begin

Value1 = sumCovar / squareroot(sumXiXb \* sumYiYb);

if -1 \<= Value1 and Value1 \<= 1 then

CoefficientR = Value1;

end;

#### 📄 Correlation

{@type:function}

SetBarMode(1);

input:Indep(numericseries);{說明:獨立的K棒值}

input:Dep(numericseries);{說明:不獨立的K棒值}

input:Length(numericsimple);{說明:過去N期}

Correlation = -2;

if Length \<= 0 then return;

Value1 = CountIf(Indep \> Indep\[1\] and Dep \> Dep\[1\], Length);

value2 = CountIf(Indep \< Indep\[1\] and Dep \< Dep\[1\], Length);

value3 = CountIf(Indep = Indep\[1\] and Dep = Dep\[1\], Length);

Correlation = (Value1-value2)/(Value1+value2+value3);

#### 📄 Covariance

{@type:function}

SetBarMode(1);

input: DepValue(numericseries),

IndepVal(numericseries),

Length(numericsimple);

variable:

Xb(0), Yb(0), idx(0), sum(0);

{

Covar(x,y) = Sum((Xi-Xb)\*(Yi-Yb)) / N

}

If Length \<\> 0 Then

Begin

Xb = Average(IndepVal, Length);

Yb = Average(DepValue, Length);

sum = 0;

For idx = 0 To Length - 1

Begin

sum = sum + (IndepVal\[idx\] - Xb) \* (DepValue\[idx\] - Yb);

End;

Covariance = sum / Length;

End;

#### 📄 RSquare

{@type:function}

SetBarMode(1);

input: Indep(numericseries), Dep(numericseries), Length(numericsimple);

RSquare = Square(CoefficientR(Indep, Dep, Length));

#### 📄 StandardDev

{@type:function}

SetBarMode(1);

input: thePrice(numericseries), Length(numericsimple),
DataType(numericsimple);

Value1 = VariancePS(thePrice, Length, DataType);

if Value1 \> 0 then

StandardDev = SquareRoot(Value1)

else

StandardDev = 0;

#### 📄 VariancePS

{@type:function}

SetBarMode(1);

input: thePrice(numericseries), Length(numericsimple),
DataType(numericsimple);

variable: Period(0), sum(0), avg(0);

VariancePS = 0;

Period = Iff(DataType = 1, Length, Length - 1);

if Period \> 0 then

begin

avg = Average(thePrice, Length);

sum = 0;

for Value1 = 0 to Length - 1

begin

sum = sum + Square(thePrice\[Value1\] - avg);

end;

VariancePS = sum / Period;

end;

### 1.11 趨勢分析 (16 個)

#### 📄 Angle

{@type:function}

SetBarMode(1);

input:Date1(numeric),Date2(numeric);

variable:Date1Bar(0),Date2Bar(0),Date1Price(0),Date2Price(0),\_Slope(0);

Date1Bar = getbaroffset(date1); Date1Price =Open\[Date1Bar\];

Date2Bar = getbaroffset(date2); Date2Price =Close\[Date2Bar\];

if Date1Bar \> Date2Bar then

\_Slope = (Date2Price/Date1Price-1)\*100 / (Date1Bar-Date2Bar);

Angle = arcTangent(\_Slope);

#### 📄 Angleprice

{@type:function}

input:Date1(numeric),ang(numeric);

variable:Date1Price(0);

Date1Price =Open\[Date1\];

value1=tan(ang);

value2=date1price\*(1+value1\*date1/100);

angleprice=value2;

#### 📄 DownTrend

{@type:function_bool}

{

判斷某個序列是否趨勢朝下

注意事項:

\- 判斷N日趨勢會判斷均線的趨勢, 所以資料必須要有Length\*2以上

\- 每次計算時會讀取近Length\*2筆計算, 為了效能起見,
僅需在最新筆呼叫此函數即可

範例:

SetBackBar(2 \* Length); // 需有2倍的資料筆數

SetTotalBar(2); //

if CurrentBar \<\> GetTotalBar() then return;

ret = DownTrend(Close, Length);

}

input: TheSeries(numericseries, \"序列\");

input: Length(numericsimple, \"天期\");

{

底下是目前選股系統腳本使用的計算邏輯

Condition1 = rateofchange(TheSeries, Length) \<= Length;

Condition2 = TheSeries \< TheSeries\[Length/2\];

Condition3 = TheSeries \< average(TheSeries, Length);

Condition4 = TheSeries \<= TheSeries\[1\];

retval = condition1 and condition2 and condition3 and condition4;

}

Array: TheSeriesArray\[\](0);

Array: LongMA\[\](0); // 儲存長MA (MA(Length))

Array: ShortMA\[\](0); // 儲存短MA (MA(Length/2))

ArraySeries(TheSeries, Length, TheSeriesArray);

// Value1 = Average(TheSeries, Length);

// Value2 = Average(TheSeries, Length/2);

Var: ShortLength(Ceiling(Length/2));

ArrayMASeries(TheSeries, Length, LongMA);

ArrayMASeries(TheSeries, ShortLength, ShortMA);

if Length \>= 10 then begin

retval =

ShortMA\[1\] \<= LongMA\[1\] and // Value2 \<= Value1 and

ArrayLinearRegSlope(LongMA, Length) \< 0 and //LinearRegSlope(Value1,
Length) \< 0 and

ArrayLinearRegSlope(ShortMA, ShortLength) \< 0 and
//LinearRegSlope(Value2, Length/2) \< 0 and

LongMA\[1\] \<= LongMA\[2\] and // Value1 \<= Value1\[1\] and

ShortMA\[1\] \<= ShortMA\[2\] and // Value2 \<= Value2\[1\] and

TheSeriesArray\[1\] \<= TheSeriesArray\[2\]; // TheSeries \<=
TheSeries\[1\];

end else begin

retval =

ArrayLinearRegSlope(LongMA, Length) \< 0 and //LinearRegSlope(Value1,
Length) \< 0 and

LongMA\[1\] \<= LongMA\[2\] and // Value1 \<= Value1\[1\] and

TheSeriesArray\[1\] \<= TheSeriesArray\[2\]; // TheSeries \<=
TheSeries\[1\];

end;

#### 📄 LinearReg

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); {資料序列}

input:Length(numericsimple); {資料長度}

input:target(numericsimple);
{預期日期位置:0表示現在,-1表示未來一天,1表示過去一天}

input:\_slope(numericref); {回傳:斜率}

input:\_angle(numericref); {回傳:弧度}

input:intercept(numericref); {回傳:X軸切點}

input:forecast(numericref); {回傳:target日後預期值}

variable: SumX((Length\* (Length+1))/2), //和

sumX2(Length\*(Length+1)\*(2\*Length+1)/6 ), //平方和

sumY(0),

SumXY(0),

t_slope(0),

tIntercept(0);

sumX2 = Length\*(Length+1)\*(2\*Length+1)/6;

SumX = (Length\* (Length+1))/2;

LinearReg = -1;

if Length \< 1 then return;

variable: Xi(0);

SumXY=0; SumY =0;

for Xi = 1 to Length

Begin

SumXY += Xi\* thePrice\[ Length -Xi\];

SumY += thePrice\[ Length -Xi\];

End;

t_slope = IFF((Length\*SumX2 -Square(SumX))\<\>0,

( Length \*SumXY -SumX \*SumY) / (Length\*SumX2 -Square(SumX)),

0);

tIntercept = (SumY - t_slope\*SumX)/Length;

\_slope =t_slope;

\_angle = arctangent(t_slope);

intercept =tIntercept;

forecast = intercept + \_slope \* (Length - target + ExecOffset);

LinearReg = 1;

#### 📄 LinearRegAngle

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

variable: \_Output(0);

LinearReg(thePrice, Length, 0, value1, \_Output, value3, value4);

LinearRegAngle = \_Output;

#### 📄 LinearRegSlope

{@type:function}

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

variable: \_Output(0);

LinearReg(thePrice, Length, 0, \_Output, value2, value3, value4);

LinearRegSlope = \_Output;

#### 📄 NDaysAngle

{@type:function}

{

計算股價N日走勢的角度

上漲趨勢回傳值 = 0 \~ 90

下跌趨勢回傳值 = 0 \~ -90

}

input: Length(numericsimple, \"天期\");

{

\| y=\<Close/Close\[N\]-1\>

\|

\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+ y=0

\- Y軸的數值, 是Close/Close\[N\]-1,

\- 第一筆的數值是0, 如果上漲50%, 則數值 = 0.5, 如果上漲100%, 則數值=1

\- consider: X邊如果是N, Y邊如果是0.5(上漲50%), 那算出來的斜率 x 2N之後,
表示這是一個x=1/y=1的三角形, 角度=45度角

上漲跟下跌的差異

\- 上漲100%, 例如4元漲到8元 =\> y = 1

\- 下跌50%, 例如8元跌到4元 =\> y = -0.5

}

array: thePriceArray\[\](0);

var: idx(0);

var: angle45(0), factor45(0);

// 定義N日上漲 x% = 45度

//

if Length \<= 5 then angle45 = 30

else if Length \<= 10 then angle45 = 50

else if Length \<= 20 then angle45 = 75

else if Length \<= 60 then angle45 = 100

else if Length \<= 120 then angle45 = 150

else angle45 = 200;

// 底邊 = Length

// 高度 = 上漲%

//

factor45 = Length / (0.01 \* angle45);

Array_SetMaxIndex(thePriceArray, Length);

for idx = 1 to Length begin

thePriceArray\[idx\] = (Close\[idx-1\] / Close\[Length-1\] - 1) \*
factor45;

end;

value1 = ArrayLinearRegSlope(thePriceArray, Length);

value2 = arctangent(value1);

// 因為下跌最多就是100%, 所以算出來最多角度=-45度, 所以下跌角度會 x 2,
希望上漲角度/下跌角度可以在同一個scale內

//

if value2 \< 0 then value2 = value2 \* 2;

retval = value2;

#### 📄 SwingHigh

{@type:function}

SetBarMode(2);

input: Price(numericseries), Length(numericsimple),
LeftStrength(numericsimple), RightStrength(numericsimple),
occur(numericsimple);

//價格序列、時間長度、左區間、右區間、第幾個峰值

variable: now(0), tmpnow(0), cnt(0), success(0);

now = Rightstrength;

cnt = 0;

while cnt \< occur and now \< Length

begin

success = 1;

tmpnow = now+1;

while success = 1 and tmpnow-now \<= LeftStrength

begin

if Price\[now\] \< Price\[tmpnow\] then

success = 0

else tmpnow = tmpnow+1;

end;

tmpnow = now-1;

while success = 1 and now-tmpnow \<= RightStrength

begin

if Price\[now\] \<= Price\[tmpnow\] then

success = 0

else tmpnow = tmpnow-1;

end;

if success = 1 then

cnt = cnt+1;

now = now+1;

end;

if cnt \< occur then

SwingHigh = -1

else

swingHigh = Price\[now-1\];

#### 📄 SwingHighBar

{@type:function}

SetBarMode(2);

input:

Price(numericseries),

Length(numericsimple),

LeftStrength(numericsimple),

RightStrength(numericsimple),

occur(numericsimple);

//價格序列、時間長度、左區間、右區間、第幾個峰值

variable: now(0), tmpnow(0), cnt(0), success(false);

now = Rightstrength;

cnt = 0;

while cnt \< occur and now \< Length

begin

success = true;

tmpnow = now+1;

while success = true and tmpnow-now \<= LeftStrength

begin

if Price\[now\] \< Price\[tmpnow\] then

success = false

else tmpnow = tmpnow+1;

end;

tmpnow = now-1;

while success = true and now-tmpnow \<= RightStrength

begin

if Price\[now\] \<= Price\[tmpnow\] then

success = false

else tmpnow = tmpnow-1;

end;

if success = true then

cnt = cnt+1;

now = now+1;

end;

if cnt \< occur then

swingHighBar = -1

else

swingHighBar = now-1;

#### 📄 SwingLow

{@type:function}

SetBarMode(2);

input: Price(numericseries), Length(numericsimple),
LeftStrength(numericsimple), RightStrength(numericsimple),
occur(numericsimple);

//價格序列、時間長度、左區間、右區間、第幾個峰值

variable: now(0), tmpnow(0), cnt(0), success(0);

now = Rightstrength;

cnt = 0;

while cnt \< occur and now \< Length

begin

success = 1;

tmpnow = now+1;

while success = 1 and tmpnow-now \<= LeftStrength

begin

if Price\[now\] \> Price\[tmpnow\] then

success = 0

else tmpnow = tmpnow+1;

end;

tmpnow = now-1;

while success = 1 and now-tmpnow \<= RightStrength

begin

if Price\[now\] \>= Price\[tmpnow\] then

success = 0

else tmpnow = tmpnow-1;

end;

if success = 1 then

cnt = cnt+1;

now = now+1;

end;

if cnt \< occur then

SwingLow = -1

else

swingLow = Price\[now-1\];

#### 📄 SwingLowBar

{@type:function}

SetBarMode(2);

input: Price(numericseries), Length(numericsimple),
LeftStrength(numericsimple), RightStrength(numericsimple),
occur(numericsimple);

//價格序列、時間長度、左區間、右區間、第幾個峰值

variable: now(0), tmpnow(0), cnt(0), success(0);

now = Rightstrength;

cnt = 0;

while cnt \< occur and now \< Length

begin

success = 1;

tmpnow = now+1;

while success = 1 and tmpnow-now \<= LeftStrength

begin

if Price\[now\] \> Price\[tmpnow\] then

success = 0

else tmpnow = tmpnow+1;

end;

tmpnow = now-1;

while success = 1 and now-tmpnow \<= RightStrength

begin

if Price\[now\] \>= Price\[tmpnow\] then

success = 0

else tmpnow = tmpnow-1;

end;

if success = 1 then

cnt = cnt+1;

now = now+1;

end;

if cnt \< occur then

SwingLowBar = -1

else

SwingLowBar = now-1;

#### 📄 TSELSindex

{@type:function}

{

函數說明

https://www.xq.com.tw/xstrader/打造自己的大盤多空函數/

}

SetBarMode(1);

input:Length(numeric);

input:LowLimit(numeric);

if countif(GetSymbolField(\"tse.tw\",\"外資買賣超金額\",\"D\") \>
0,Length) \>= LowLimit

and GetSymbolField(\"tse.tw\",\"外資買賣超金額\",\"D\") \> 0 then

value1 = 1

else

value1 = 0;

tselsindex = value1;

#### 📄 TSEMFI

{@type:function}

SetBarMode(2);

variable: tp(0), tv(0), utv(0), dtv(0), pmf(0), nmf(0), mfivalue(0);

tp =
(getsymbolfield(\"TSE.TW\",\"最高價\")+getsymbolfield(\"TSE.TW\",\"最低價\")+getsymbolfield(\"TSE.TW\",\"收盤價\"))
/3;

tv = tp \* getsymbolfield(\"TSE.TW\",\"成交量\");

if tp \> tp\[1\] then begin

utv = tv;

dtv = 0;

end else begin

utv = 0;

dtv = tv;

end;

pmf = Average(utv, MinList(CurrentBar, 6));

nmf = Average(dtv, MinList(CurrentBar, 6));

if CurrentBar \< 6 or (pmf + nmf) = 0 then

mfivalue = 50

else

mfivalue = 100 \* pmf /(pmf + nmf);

if mfivalue \> 50 then

tsemfi = 1

else

tsemfi = 0;

#### 📄 TimeSeriesForecast

{@type:function}

SetBarMode(1);

input: thePrice(numericseries), Length(numericsimple),
TgtBar(numericsimple);

variable: \_Output(0);

LinearReg(thePrice, Length, TgtBar, value1, value2, value3, \_Output);

TimeSeriesForecast = \_Output;

#### 📄 UpShadow

{@type:function}

//上影線佔實體比例

SetBarMode(1);

if range = 0 then

upshadow = 0

else

upshadow = (high - maxlist(open,close)) / range;

#### 📄 UpTrend

{@type:function_bool}

{

判斷某個序列是否趨勢朝上

注意事項:

\- 判斷N日趨勢會判斷均線的趨勢, 所以資料必須要有Length\*2以上

\- 每次計算時會讀取近Length\*2筆計算, 為了效能起見,
僅需在最新筆呼叫此函數即可

範例:

SetBackBar(2 \* Length); // 需有2倍的資料筆數

SetTotalBar(2); //

if CurrentBar \<\> GetTotalBar() then return;

ret = UpTrend(Close, Length);

}

input: TheSeries(numericseries, \"序列\");

input: Length(numericsimple, \"天期\");

{

底下是目前選股系統腳本使用的計算邏輯

Condition1 = rateofchange(TheSeries, Length) \>= Length;

Condition2 = TheSeries \> TheSeries\[Length/2\];

Condition3 = TheSeries \> average(TheSeries, Length);

Condition4 = TheSeries \>= TheSeries\[1\];

retval = condition1 and condition2 and condition3 and condition4;

}

Array: TheSeriesArray\[\](0);

Array: LongMA\[\](0); // 儲存長MA (MA(Length))

Array: ShortMA\[\](0); // 儲存短MA (MA(Length/2))

ArraySeries(TheSeries, Length, TheSeriesArray);

// Value1 = Average(TheSeries, Length);

// Value2 = Average(TheSeries, Length/2);

Var: ShortLength(Ceiling(Length/2));

ArrayMASeries(TheSeries, Length, LongMA);

ArrayMASeries(TheSeries, ShortLength, ShortMA);

if Length \>= 10 then begin

retval =

ShortMA\[1\] \>= LongMA\[1\] and // Value2 \>= Value1 and

ArrayLinearRegSlope(LongMA, Length) \> 0 and //LinearRegSlope(Value1,
Length) \> 0 and

ArrayLinearRegSlope(ShortMA, ShortLength) \> 0 and
//LinearRegSlope(Value2, Length/2) \> 0 and

LongMA\[1\] \>= LongMA\[2\] and // Value1 \>= Value1\[1\] and

ShortMA\[1\] \>= ShortMA\[2\] and // Value2 \>= Value2\[1\] and

TheSeriesArray\[1\] \>= TheSeriesArray\[2\]; // TheSeries \>=
TheSeries\[1\];

end else begin

retval =

ArrayLinearRegSlope(LongMA, Length) \> 0 and //LinearRegSlope(Value1,
Length) \> 0 and

LongMA\[1\] \>= LongMA\[2\] and // Value1 \>= Value1\[1\] and

TheSeriesArray\[1\] \>= TheSeriesArray\[2\]; // TheSeries \>=
TheSeries\[1\];

end;

### 1.12 跨頻率 (29 個)

#### 📄 xfMin_CrossOver

{@type:function_bool}

SetBarMode(1);

// 傳入兩個序列(跟目前的頻率不同), 判斷是否crossover

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// SeriesA, SeriesB是傳入的序列

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string),

SeriesA(numericseries),

SeriesB(numericseries);

variable:

valA(0), valB(0), posA(0), posB(0);

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

posA = 0;

posB = 0;

valA = xfMin_getvalue(FreqType, SeriesA, posA);

valB = xfMin_getvalue(FreqType, SeriesB, posB);

if valA \<= valB then

begin

xfMin_CrossOver = false;

return;

end;

variable: idx(0);

for idx = 1 to 6

begin

posA = posA + 1;

posB = posB + 1;

valA = xfMin_getvalue(FreqType, SeriesA, posA);

valB = xfMin_getvalue(FreqType, SeriesB, posB);

if valA \< valB then

begin

xfMin_CrossOver = true;

return;

end

else

begin

if valA \> valB then

begin

xfMin_CrossOver = false;

return;

end;

end;

end;

xfMin_CrossOver = false;

#### 📄 xfMin_CrossUnder

{@type:function_bool}

SetBarMode(1);

// 傳入兩個序列(跟目前的頻率不同), 判斷是否crossunder

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// SeriesA, SeriesB是傳入的序列

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string),

SeriesA(numericseries),

SeriesB(numericseries);

variable:

valA(0), valB(0), posA(0), posB(0);

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

posA = 0;

posB = 0;

valA = xfMin_getvalue(FreqType, SeriesA, posA);

valB = xfMin_getvalue(FreqType, SeriesB, posB);

if valA \>= valB then

begin

xfMin_CrossUnder = false;

return;

end;

variable: idx(0);

for idx = 1 to 6

begin

posA = posA + 1;

posB = posB + 1;

valA = xfMin_getvalue(FreqType, SeriesA, posA);

valB = xfMin_getvalue(FreqType, SeriesB, posB);

if valA \> valB then

begin

xfMin_CrossUnder = true;

return;

end

else

begin

if valA \< valB then

begin

xfMin_CrossUnder = false;

return;

end;

end;

end;

xfMin_CrossUnder = false;

#### 📄 xfMin_DirectionMovement

{@type:function}

SetBarMode(2);

// 跨頻率DirectionMovement function (for DMI相關指標)

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// 輸入: FreqType, Length

// Return: pdi_value(+di), ndi_value(-di), adx_value(adx)

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string), //引用頻率

length(numericsimple), //計算期間

pdi_value(numericref), //回傳+DI

ndi_value(numericref), //回傳-DI

adx_value(numericref); //回傳ADX

variable:

padm(0), nadm(0), radx(0),

LastPAdm(0), LastNAdm(0), LastRAdx(0), LastATR(0),

atr(0), pdm(0), ndm(0), tr(0),

dValue0(0), dValue1(0), dx(0),

changeHigh(0),changeLow(0),closePeriod(0),

idx(0);

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

//跨頻率會用到的前期值需要手動記錄

if FreqType=\"D\" or FreqType=\"AD\" or FreqType=\"W\" or
FreqType=\"AW\" or FreqType=\"M\" or FreqType=\"AM\" then

condition1 = xfMin_getdtvalue(FreqType, GetFielddate(\"Date\")) \<\>
xfMin_getdtvalue(FreqType, GetFielddate(\"Date\")\[1\])

else

condition1 = xfMin_getdtvalue(FreqType, datetime) \<\>
xfMin_getdtvalue(FreqType, datetime\[1\]);

if condition1 then

begin

LastPAdm = padm\[1\];

LastNAdm = nadm\[1\];

LastRAdx = radx\[1\];

LastATR = atr\[1\];

end;

//取得跨頻率會用到的變數值

switch (FreqType)

begin

case \"1\":

if GetField(\"Close\", \"1\")\[1\] \> GetField(\"High\", \"1\") then

tr = GetField(\"Close\", \"1\")\[1\] - GetField(\"Low\", \"1\")

else if GetField(\"Close\", \"1\")\[1\] \< GetField(\"Low\", \"1\") then

tr = GetField(\"High\", \"1\") - GetField(\"Close\", \"1\")\[1\]

else

tr = GetField(\"High\", \"1\") - GetField(\"Low\", \"1\");

changeHigh = GetField(\"High\", \"1\") - GetField(\"High\", \"1\")\[1\];

changeLow = GetField(\"Low\", \"1\")\[1\] - GetField(\"Low\", \"1\");

closePeriod = GetField(\"Close\", \"1\");

case \"2\":

if GetField(\"Close\", \"2\")\[1\] \> GetField(\"High\", \"2\") then

tr = GetField(\"Close\", \"2\")\[1\] - GetField(\"Low\", \"2\")

else if GetField(\"Close\", \"2\")\[1\] \< GetField(\"Low\", \"2\") then

tr = GetField(\"High\", \"2\") - GetField(\"Close\", \"2\")\[1\]

else

tr = GetField(\"High\", \"2\") - GetField(\"Low\", \"2\");

changeHigh = GetField(\"High\", \"2\") - GetField(\"High\", \"2\")\[1\];

changeLow = GetField(\"Low\", \"2\")\[1\] - GetField(\"Low\", \"2\");

closePeriod = GetField(\"Close\", \"2\");

case \"3\":

if GetField(\"Close\", \"3\")\[1\] \> GetField(\"High\", \"3\") then

tr = GetField(\"Close\", \"3\")\[1\] - GetField(\"Low\", \"3\")

else if GetField(\"Close\", \"3\")\[1\] \< GetField(\"Low\", \"3\") then

tr = GetField(\"High\", \"3\") - GetField(\"Close\", \"3\")\[1\]

else

tr = GetField(\"High\", \"3\") - GetField(\"Low\", \"3\");

changeHigh = GetField(\"High\", \"3\") - GetField(\"High\", \"3\")\[1\];

changeLow = GetField(\"Low\", \"3\")\[1\] - GetField(\"Low\", \"3\");

closePeriod = GetField(\"Close\", \"3\");

case \"5\":

if GetField(\"Close\", \"5\")\[1\] \> GetField(\"High\", \"5\") then

tr = GetField(\"Close\", \"5\")\[1\] - GetField(\"Low\", \"5\")

else if GetField(\"Close\", \"5\")\[1\] \< GetField(\"Low\", \"5\") then

tr = GetField(\"High\", \"5\") - GetField(\"Close\", \"5\")\[1\]

else

tr = GetField(\"High\", \"5\") - GetField(\"Low\", \"5\");

changeHigh = GetField(\"High\", \"5\") - GetField(\"High\", \"5\")\[1\];

changeLow = GetField(\"Low\", \"5\")\[1\] - GetField(\"Low\", \"5\");

closePeriod = GetField(\"Close\", \"5\");

case \"10\":

if GetField(\"Close\", \"10\")\[1\] \> GetField(\"High\", \"10\") then

tr = GetField(\"Close\", \"10\")\[1\] - GetField(\"Low\", \"10\")

else if GetField(\"Close\", \"10\")\[1\] \< GetField(\"Low\", \"10\")
then

tr = GetField(\"High\", \"10\") - GetField(\"Close\", \"10\")\[1\]

else

tr = GetField(\"High\", \"10\") - GetField(\"Low\", \"10\");

changeHigh = GetField(\"High\", \"10\") - GetField(\"High\",
\"10\")\[1\];

changeLow = GetField(\"Low\", \"10\")\[1\] - GetField(\"Low\", \"10\");

closePeriod = GetField(\"Close\", \"10\");

case \"15\":

if GetField(\"Close\", \"15\")\[1\] \> GetField(\"High\", \"15\") then

tr = GetField(\"Close\", \"15\")\[1\] - GetField(\"Low\", \"15\")

else if GetField(\"Close\", \"15\")\[1\] \< GetField(\"Low\", \"15\")
then

tr = GetField(\"High\", \"15\") - GetField(\"Close\", \"15\")\[1\]

else

tr = GetField(\"High\", \"15\") - GetField(\"Low\", \"15\");

changeHigh = GetField(\"High\", \"15\") - GetField(\"High\",
\"15\")\[1\];

changeLow = GetField(\"Low\", \"15\")\[1\] - GetField(\"Low\", \"15\");

closePeriod = GetField(\"Close\", \"15\");

case \"30\":

if GetField(\"Close\", \"30\")\[1\] \> GetField(\"High\", \"30\") then

tr = GetField(\"Close\", \"30\")\[1\] - GetField(\"Low\", \"30\")

else if GetField(\"Close\", \"30\")\[1\] \< GetField(\"Low\", \"30\")
then

tr = GetField(\"High\", \"30\") - GetField(\"Close\", \"30\")\[1\]

else

tr = GetField(\"High\", \"30\") - GetField(\"Low\", \"30\");

changeHigh = GetField(\"High\", \"30\") - GetField(\"High\",
\"30\")\[1\];

changeLow = GetField(\"Low\", \"30\")\[1\] - GetField(\"Low\", \"30\");

closePeriod = GetField(\"Close\", \"30\");

case \"60\":

if GetField(\"Close\", \"60\")\[1\] \> GetField(\"High\", \"60\") then

tr = GetField(\"Close\", \"60\")\[1\] - GetField(\"Low\", \"60\")

else if GetField(\"Close\", \"60\")\[1\] \< GetField(\"Low\", \"60\")
then

tr = GetField(\"High\", \"60\") - GetField(\"Close\", \"60\")\[1\]

else

tr = GetField(\"High\", \"60\") - GetField(\"Low\", \"60\");

changeHigh = GetField(\"High\", \"60\") - GetField(\"High\",
\"60\")\[1\];

changeLow = GetField(\"Low\", \"60\")\[1\] - GetField(\"Low\", \"60\");

closePeriod = GetField(\"Close\", \"60\");

case \"D\":

if GetField(\"Close\", \"D\")\[1\] \> GetField(\"High\", \"D\") then

tr = GetField(\"Close\", \"D\")\[1\] - GetField(\"Low\", \"D\")

else if GetField(\"Close\", \"D\")\[1\] \< GetField(\"Low\", \"D\") then

tr = GetField(\"High\", \"D\") - GetField(\"Close\", \"D\")\[1\]

else

tr = GetField(\"High\", \"D\") - GetField(\"Low\", \"D\");

changeHigh = GetField(\"High\", \"D\") - GetField(\"High\", \"D\")\[1\];

changeLow = GetField(\"Low\", \"D\")\[1\] - GetField(\"Low\", \"D\");

closePeriod = GetField(\"Close\", \"D\");

case \"W\":

if GetField(\"Close\", \"W\")\[1\] \> GetField(\"High\", \"W\") then

tr = GetField(\"Close\", \"W\")\[1\] - GetField(\"Low\", \"W\")

else if GetField(\"Close\", \"W\")\[1\] \< GetField(\"Low\", \"W\") then

tr = GetField(\"High\", \"W\") - GetField(\"Close\", \"W\")\[1\]

else

tr = GetField(\"High\", \"W\") - GetField(\"Low\", \"W\");

changeHigh = GetField(\"High\", \"W\") - GetField(\"High\", \"W\")\[1\];

changeLow = GetField(\"Low\", \"W\")\[1\] - GetField(\"Low\", \"W\");

closePeriod = GetField(\"Close\", \"W\");

case \"M\":

if GetField(\"Close\", \"M\")\[1\] \> GetField(\"High\", \"M\") then

tr = GetField(\"Close\", \"M\")\[1\] - GetField(\"Low\", \"M\")

else if GetField(\"Close\", \"M\")\[1\] \< GetField(\"Low\", \"M\") then

tr = GetField(\"High\", \"M\") - GetField(\"Close\", \"M\")\[1\]

else

tr = GetField(\"High\", \"M\") - GetField(\"Low\", \"M\");

changeHigh = GetField(\"High\", \"M\") - GetField(\"High\", \"M\")\[1\];

changeLow = GetField(\"Low\", \"M\")\[1\] - GetField(\"Low\", \"M\");

closePeriod = GetField(\"Close\", \"M\");

case \"AD\":

if GetField(\"Close\", \"AD\")\[1\] \> GetField(\"High\", \"AD\") then

tr = GetField(\"Close\", \"AD\")\[1\] - GetField(\"Low\", \"AD\")

else if GetField(\"Close\", \"AD\")\[1\] \< GetField(\"Low\", \"AD\")
then

tr = GetField(\"High\", \"AD\") - GetField(\"Close\", \"AD\")\[1\]

else

tr = GetField(\"High\", \"AD\") - GetField(\"Low\", \"AD\");

changeHigh = GetField(\"High\", \"AD\") - GetField(\"High\",
\"AD\")\[1\];

changeLow = GetField(\"Low\", \"AD\")\[1\] - GetField(\"Low\", \"AD\");

closePeriod = GetField(\"Close\", \"AD\");

case \"AW\":

if GetField(\"Close\", \"AW\")\[1\] \> GetField(\"High\", \"AW\") then

tr = GetField(\"Close\", \"AW\")\[1\] - GetField(\"Low\", \"AW\")

else if GetField(\"Close\", \"AW\")\[1\] \< GetField(\"Low\", \"AW\")
then

tr = GetField(\"High\", \"AW\") - GetField(\"Close\", \"AW\")\[1\]

else

tr = GetField(\"High\", \"AW\") - GetField(\"Low\", \"AW\");

changeHigh = GetField(\"High\", \"AW\") - GetField(\"High\",
\"AW\")\[1\];

changeLow = GetField(\"Low\", \"AW\")\[1\] - GetField(\"Low\", \"AW\");

closePeriod = GetField(\"Close\", \"AW\");

case \"AM\":

if GetField(\"Close\", \"AM\")\[1\] \> GetField(\"High\", \"AM\") then

tr = GetField(\"Close\", \"AM\")\[1\] - GetField(\"Low\", \"AM\")

else if GetField(\"Close\", \"AM\")\[1\] \< GetField(\"Low\", \"AM\")
then

tr = GetField(\"High\", \"AM\") - GetField(\"Close\", \"AM\")\[1\]

else

tr = GetField(\"High\", \"AM\") - GetField(\"Low\", \"AM\");

changeHigh = GetField(\"High\", \"AM\") - GetField(\"High\",
\"AM\")\[1\];

changeLow = GetField(\"Low\", \"AM\")\[1\] - GetField(\"Low\", \"AM\");

closePeriod = GetField(\"Close\", \"AM\");

default:

if Close\[1\] \> High then

tr = Close\[1\] - Low

else if Close\[1\] \< Low then

tr = High - Close\[1\]

else

tr = High - Low;

changeHigh = High - High\[1\];

changeLow = Low\[1\] - Low;

closePeriod = Close;

end;

//原始的技術指標計算

value1 = xfMin_GetCurrentBar(FreqType);

if value1 = 1 then

begin

padm = closePeriod / 10000;

nadm = padm;

atr = padm \* 5;

radx = 20;

end

else

begin

pdm = maxlist(changeHigh, 0);

ndm = maxlist(changeLow, 0);

if pdm \< ndm then

pdm = 0

else

begin

if pdm \> ndm then

ndm = 0

else

begin

pdm = 0;

ndm = 0;

end;

end;

padm = LastPAdm + (pdm - LastPAdm) / length;

nadm = LastNAdm + (ndm - LastNAdm) / length;

atr = LastATR + (tr - LastATR) / length;

if atr \<\> 0 then begin

dValue0 = 100 \* padm / atr;

dValue1 = 100 \* nadm / atr;

end;

if dValue0 + dValue1 \<\> 0 then

dx = AbsValue(100 \* (dValue0 - dValue1) / (dValue0 + dValue1));

radx = LastRAdx + (dx - LastRAdx) / length;

end;

pdi_value = dValue0;

ndi_value = dValue1;

adx_value = radx;

xfMin_directionmovement = 1;

#### 📄 xfMin_EMA

{@type:function}

SetBarMode(2);

// 跨頻率EMA

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// 輸入: FreqType, Series, Length

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string), //引用頻率

Series(numericseries), //價格序列

Length(numericsimple); //計算期間

variable:

Factor(0), lastEMA(0);

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

if FreqType=\"D\" or FreqType=\"AD\" or FreqType=\"W\" or
FreqType=\"AW\" or FreqType=\"M\" or FreqType=\"AM\" then

condition1 = xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")) \<\>
xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")\[1\])

else

condition1 = xfMin_getdtvalue(FreqType, datetime) \<\>
xfMin_getdtvalue(FreqType, datetime\[1\]);

if condition1 then

lastEMA = xfMin_EMA\[1\];

value1 = xfMin_GetCurrentBar(FreqType);

if Length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);

if value1 = 1 then

xfMin_EMA = Series

else if value1 \<= Length then

xfMin_EMA = (Series + (lastEMA \* (value1 - 1)))/value1

else

xfMin_EMA = lastEMA + Factor \* (Series - lastEMA);

#### 📄 xfMin_GetBoolean

{@type:function_bool}

SetBarMode(1);

// 傳入一個序列(跟目前的頻率不同), 取得這個序列以此頻率的第幾筆

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// TFSeries是傳入的布林序列

// poi是要取得的位置

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string),

TFSeries(truefalseseries),

poi(numeric);

variable: \_pos(0);

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

\_pos = poi;

if \_pos \<= 0 then

xfMin_GetBoolean = TFSeries\[0\]

else

begin

variable: idx(0), dt(0), dt2(0);

idx = 0;

while \_pos \> 0 and idx \< currentbar-1

begin

switch (FreqType)

begin

case \"1\",\"2\",\"3\",\"5\",\"10\",\"15\",\"30\",\"60\":

dt = xfMin_getdtvalue(FreqType, datetime\[idx\]);

dt2 = xfMin_getdtvalue(FreqType, datetime\[idx+1\]);

if dt \<\> dt2 then \_pos = \_pos - 1;

idx = idx + 1;

default:

dt = xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")\[idx\]);

dt2 = xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")\[idx+1\]);

if dt \<\> dt2 then \_pos = \_pos - 1;

idx = idx + 1;

end;

end;

xfMin_GetBoolean = TFSeries\[idx\];

end;

#### 📄 xfMin_GetCurrentBar

{@type:function}

SetBarMode(2);

// 取得指定頻率的K棒編號（CurrentBar）

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// 輸入: FreqType

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string); //引用頻率

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

if FreqType=\"D\" or FreqType=\"AD\" or FreqType=\"W\" or
FreqType=\"AW\" or FreqType=\"M\" or FreqType=\"AM\" then

condition1 = xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")) \<\>
xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")\[1\])

else

condition1 = xfMin_getdtvalue(FreqType, datetime) \<\>
xfMin_getdtvalue(FreqType, datetime\[1\]);

if currentbar = 1 then

xfMin_GetCurrentBar = 1

else if condition1 then

xfMin_GetCurrentBar = xfMin_GetCurrentBar\[1\] + 1

else

xfMin_GetCurrentBar = xfMin_GetCurrentBar\[1\];

#### 📄 xfMin_GetDTValue

{@type:function}

SetBarMode(1);

// 回傳某個日期的\'normalized\' value

// 用這個value來比對是否已經跨期

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// dtValue 是目前資料序列上面的Date

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string),

dtValue(numeric);

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

switch (FreqType)

begin

case \"1\",\"2\",\"3\",\"5\",\"10\",\"15\",\"30\",\"60\":

// 回傳分鐘線的日期時間YYYYMMDDhhmmss。例如：2018/9/10
12:03:59的五分線會回傳20180910120000

if symbolExchange=\"TF\" then begin

if dtValue \< 19870106000000 then begin

xfMin_GetDTValue = dtValue;

return;

end;

value1 = strtonum(FreqType);

value2 = strtonum(rightstr(numtostr(dtValue,0),6));

if value2\>=084500 and value2\<150000 then value20=084500

else if value2 \>=150000 then value20=150000

else value20=000000;

value21= timediff(value2,value20,\"M\");

value3 = IntPortion(value21 / value1) \* value1;

value31= timeadd(value20,\"M\",value3);

xfMin_GetDTValue = dtValue - value2 + value31;

end

else begin

if dtValue \< 19870106000000 then begin

xfMin_GetDTValue = dtValue;

return;

end;

value1 = strtonum(FreqType);

value2 = strtonum(rightstr(numtostr(dtValue,0),6));

value3 = IntPortion(minute(value2) / value1) \* value1;

xfMin_GetDTValue = dtValue - value2 + EncodeTime(hour(value2), value3,
0);

end;

case \"D\" , \"AD\":

// 回傳YYYYMMDD

xfMin_GetDTValue = dtValue;

case \"W\" , \"AW\":

// 年度 \* 100 + 周別, e.g. 201001, 表示是2010年的第一週

xfMin_GetDTValue = Year(dtValue) \* 100 + WeekofYear(dtValue);

// 每年的第一週需要判斷是否和去年的最後一週重疊

if WeekofYear(DateAdd(dtValue,\"D\", 1-DayofWeek(dtValue))) = 53 then

xfMin_GetDTValue = Year(DateAdd(dtValue,\"D\", 1-DayofWeek(dtValue))) \*
100 + WeekofYear(DateAdd(dtValue,\"D\", 1-DayofWeek(dtValue)));

case \"M\" , \"AM\":

// 年度 \* 100 + 月別, e.g. 201001, 表示是2010年的第一個月

xfMin_GetDTValue = Year(dtValue) \* 100 + Month(dtValue);

default:

xfMin_GetDTValue = dtValue;

end;

#### 📄 xfMin_GetValue

{@type:function}

SetBarMode(1);

// 傳入一個序列(跟目前的頻率不同), 取得這個序列以此頻率的第幾筆

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// PriceSeries是傳入的序列

// poi是要取得的位置

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string),

PriceSeries(numericseries),

poi(numeric);

variable: \_pos(0);

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

\_pos = poi;

if \_pos \<= 0 then

xfMin_GetValue = PriceSeries\[0\]

else

begin

variable: idx(0), dt(0), dt2(0);

idx = 0;

while \_pos \> 0 and idx \< currentbar-1

begin

switch (FreqType)

begin

case \"1\",\"2\",\"3\",\"5\",\"10\",\"15\",\"30\",\"60\":

dt = xfMin_getdtvalue(FreqType, datetime\[idx\]);

dt2 = xfMin_getdtvalue(FreqType, datetime\[idx+1\]);

if dt \<\> dt2 then \_pos = \_pos - 1;

idx = idx + 1;

default:

dt = xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")\[idx\]);

dt2 = xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")\[idx+1\]);

if dt \<\> dt2 then \_pos = \_pos - 1;

idx = idx + 1;

end;

end;

xfMin_GetValue = PriceSeries\[idx\];

end;

#### 📄 xfMin_MACD

{@type:function}

SetBarMode(1);

// 跨頻率MACD函數

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// 輸入: FreqType, FastLength, SlowLength, MACDLength;

// 輸出: DifValue, MACDValue, OscValue;

// 不支援XS選股、XS選股自訂排行與XS選股回測。

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

input:

FreqType(string), //引用頻率

Price(numericseries),

FastLength(numericsimple), SlowLength(numericsimple),
MACDLength(numericsimple),

DifValue(numericref), MACDValue(numericref), OscValue(numericref);

DifValue = xfMin_XAverage(FreqType, Price, FastLength) -
xfMin_XAverage(FreqType, Price, SlowLength);

MACDValue = xfMin_XAverage(FreqType, DifValue, MACDLength);

OscValue = DifValue - MACDValue;

xfMin_macd = 1;

#### 📄 xfMin_PercentR

{@type:function}

SetBarMode(1);

// 跨頻率PercentR函數(for 威廉指標)

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// 輸入: FreqType, SeriesH, SeriesL, SeriesC, Length, rsvt, kt

// 輸出: rsv_value, k_value, d_value

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string),

Length(numericsimple);

variable:

maxHigh(0), minLow(0),variableA(0),variableB(0),closePeriod(0);

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

switch (upperstr(FreqType))

begin

case \"1\":

maxHigh = simplehighest(GetField(\"High\", \"1\"),Length);

minLow = simplelowest(GetField(\"Low\", \"1\"),Length);

closePeriod = GetField(\"Close\", \"1\");

case \"2\":

maxHigh = simplehighest(GetField(\"High\", \"2\"),Length);

minLow = simplelowest(GetField(\"Low\", \"2\"),Length);

closePeriod = GetField(\"Close\", \"2\");

case \"3\":

maxHigh = simplehighest(GetField(\"High\", \"3\"),Length);

minLow = simplelowest(GetField(\"Low\", \"3\"),Length);

closePeriod = GetField(\"Close\", \"3\");

case \"5\":

maxHigh = simplehighest(GetField(\"High\", \"5\"),Length);

minLow = simplelowest(GetField(\"Low\", \"5\"),Length);

closePeriod = GetField(\"Close\", \"5\");

case \"10\":

maxHigh = simplehighest(GetField(\"High\", \"10\"),Length);

minLow = simplelowest(GetField(\"Low\", \"10\"),Length);

closePeriod = GetField(\"Close\", \"10\");

case \"15\":

maxHigh = simplehighest(GetField(\"High\", \"15\"),Length);

minLow = simplelowest(GetField(\"Low\", \"15\"),Length);

closePeriod = GetField(\"Close\", \"15\");

case \"30\":

maxHigh = simplehighest(GetField(\"High\", \"30\"),Length);

minLow = simplelowest(GetField(\"Low\", \"30\"),Length);

closePeriod = GetField(\"Close\", \"30\");

case \"60\":

maxHigh = simplehighest(GetField(\"High\", \"60\"),Length);

minLow = simplelowest(GetField(\"Low\", \"60\"),Length);

closePeriod = GetField(\"Close\", \"60\");

case \"D\":

maxHigh = simplehighest(GetField(\"High\", \"D\"),Length);

minLow = simplelowest(GetField(\"Low\", \"D\"),Length);

closePeriod = GetField(\"Close\", \"D\");

case \"W\":

maxHigh = simplehighest(GetField(\"High\", \"W\"),Length);

minLow = simplelowest(GetField(\"Low\", \"W\"),Length);

closePeriod = GetField(\"Close\", \"W\");

case \"M\":

maxHigh = simplehighest(GetField(\"High\", \"M\"),Length);

minLow = simplelowest(GetField(\"Low\", \"M\"),Length);

closePeriod = GetField(\"Close\", \"M\");

case \"AD\":

maxHigh = simplehighest(GetField(\"High\", \"AD\"),Length);

minLow = simplelowest(GetField(\"Low\", \"AD\"),Length);

closePeriod = GetField(\"Close\", \"AD\");

case \"AW\":

maxHigh = simplehighest(GetField(\"High\", \"AW\"),Length);

minLow = simplelowest(GetField(\"Low\", \"AW\"),Length);

closePeriod = GetField(\"Close\", \"AW\");

case \"AM\":

maxHigh = simplehighest(GetField(\"High\", \"AM\"),Length);

minLow = simplelowest(GetField(\"Low\", \"AM\"),Length);

closePeriod = GetField(\"Close\", \"AM\");

default:

maxHigh = simplehighest(High,Length);

minLow = simplelowest(Low,Length);

closePeriod = Close;

end;

variableB = maxHigh - minLow;

if variableB \<\> 0 then

xfMin_PercentR = 100 - ((maxHigh - closePeriod) / variableB) \* 100

else

xfMin_PercentR = 0;

#### 📄 xfMin_RSI

{@type:function}

SetBarMode(2);

// 跨頻率RSI函數

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// 輸入: FreqType, Series, Length

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string), //引用頻率

Series(numericseries), //價格序列

Length(numericsimple); //計算期間

variable:

SumUp(0), SumDown(0),

LastSumUp(0), LastSumDown(0),LastRefSeries(Series),

up(0), down(0),

closePeriod(0);

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

if FreqType=\"D\" or FreqType=\"AD\" or FreqType=\"W\" or
FreqType=\"AW\" or FreqType=\"M\" or FreqType=\"AM\" then

condition1 = xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")) \<\>
xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")\[1\])

else

condition1 = xfMin_getdtvalue(FreqType, datetime) \<\>
xfMin_getdtvalue(FreqType, datetime\[1\]);

if condition1 then

begin

LastSumUp = SumUp\[1\];

LastSumDown = SumDown\[1\];

LastRefSeries = Series\[1\];

end;

if xfMin_GetCurrentBar(FreqType) = 1 then

begin

SumUp = Average(maxlist(Series - LastRefSeries, 0), Length);

SumDown = Average(maxlist(LastRefSeries - Series, 0), Length);

end

else

begin

up = maxlist(Series - LastRefSeries, 0);

down = maxlist(LastRefSeries - Series, 0);

SumUp = LastSumUp + (up - LastSumUp) / Length;

SumDown = LastSumDown + (down - LastSumDown) / Length;

end;

if SumUp + SumDown = 0 then

xfMin_RSI = 0

else

xfMin_RSI = 100 \* SumUp / (SumUp + SumDown);

#### 📄 xfMin_Stochastic

{@type:function}

SetBarMode(2);

// 跨頻率Stochastic函數(for KD/RSV相關指標)

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"2\", \"3\",
\"5\", \"10\", \"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\",
\"AW\", \"AM\"

// 輸入: FreqType, SeriesH, SeriesL, SeriesC, Length, rsvt, kt

// 輸出: rsv_value, k_value, d_value

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string),

Length(numericsimple), rsvt(numericsimple), kt(numericsimple),

rsv(numericref), k(numericref), d(numericref);

variable:

maxHigh(0), minLow(0),lastK(50),lastD(50),closePeriod(0);

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

if FreqType=\"D\" or FreqType=\"AD\" or FreqType=\"W\" or
FreqType=\"AW\" or FreqType=\"M\" or FreqType=\"AM\" then

condition1 = xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")) \<\>
xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")\[1\])

else

condition1 = xfMin_getdtvalue(FreqType, datetime) \<\>
xfMin_getdtvalue(FreqType, datetime\[1\]);

if condition1 then

begin

lastK = k\[1\];

lastD = d\[1\];

end;

switch (FreqType)

begin

case \"1\":

maxHigh = simplehighest(GetField(\"High\", \"1\"),Length);

minLow = simplelowest(GetField(\"Low\", \"1\"),Length);

closePeriod = GetField(\"Close\", \"1\");

case \"2\":

maxHigh = simplehighest(GetField(\"High\", \"2\"),Length);

minLow = simplelowest(GetField(\"Low\", \"2\"),Length);

closePeriod = GetField(\"Close\", \"2\");

case \"3\":

maxHigh = simplehighest(GetField(\"High\", \"3\"),Length);

minLow = simplelowest(GetField(\"Low\", \"3\"),Length);

closePeriod = GetField(\"Close\", \"3\");

case \"5\":

maxHigh = simplehighest(GetField(\"High\", \"5\"),Length);

minLow = simplelowest(GetField(\"Low\", \"5\"),Length);

closePeriod = GetField(\"Close\", \"5\");

case \"10\":

maxHigh = simplehighest(GetField(\"High\", \"10\"),Length);

minLow = simplelowest(GetField(\"Low\", \"10\"),Length);

closePeriod = GetField(\"Close\", \"10\");

case \"15\":

maxHigh = simplehighest(GetField(\"High\", \"15\"),Length);

minLow = simplelowest(GetField(\"Low\", \"15\"),Length);

closePeriod = GetField(\"Close\", \"15\");

case \"30\":

maxHigh = simplehighest(GetField(\"High\", \"30\"),Length);

minLow = simplelowest(GetField(\"Low\", \"30\"),Length);

closePeriod = GetField(\"Close\", \"30\");

case \"60\":

maxHigh = simplehighest(GetField(\"High\", \"60\"),Length);

minLow = simplelowest(GetField(\"Low\", \"60\"),Length);

closePeriod = GetField(\"Close\", \"60\");

case \"D\":

maxHigh = simplehighest(GetField(\"High\", \"D\"),Length);

minLow = simplelowest(GetField(\"Low\", \"D\"),Length);

closePeriod = GetField(\"Close\", \"D\");

case \"W\":

maxHigh = simplehighest(GetField(\"High\", \"W\"),Length);

minLow = simplelowest(GetField(\"Low\", \"W\"),Length);

closePeriod = GetField(\"Close\", \"W\");

case \"M\":

maxHigh = simplehighest(GetField(\"High\", \"M\"),Length);

minLow = simplelowest(GetField(\"Low\", \"M\"),Length);

closePeriod = GetField(\"Close\", \"M\");

case \"AD\":

maxHigh = simplehighest(GetField(\"High\", \"AD\"),Length);

minLow = simplelowest(GetField(\"Low\", \"AD\"),Length);

closePeriod = GetField(\"Close\", \"AD\");

case \"AW\":

maxHigh = simplehighest(GetField(\"High\", \"AW\"),Length);

minLow = simplelowest(GetField(\"Low\", \"AW\"),Length);

closePeriod = GetField(\"Close\", \"AW\");

case \"AM\":

maxHigh = simplehighest(GetField(\"High\", \"AM\"),Length);

minLow = simplelowest(GetField(\"Low\", \"AM\"),Length);

closePeriod = GetField(\"Close\", \"AM\");

default:

maxHigh = simplehighest(High,Length);

minLow = simplelowest(Low,Length);

closePeriod = Close;

end;

if maxHigh \<\> minLow then

rsv = 100 \* (closePeriod - minLow) / (maxHigh - minLow)

else

rsv = 50;

if currentbar = 1 then

begin

k = 50;

d = 50;

end

else

begin

k = (lastK \* (rsvt - 1) + rsv) / rsvt;

d = (lastD \* (kt - 1) + k) / kt;

end;

xfMin_Stochastic = 1;

#### 📄 xfMin_WeightedClose

{@type:function}

SetBarMode(1);

// 跨頻率WeightedClose函數

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string);

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

switch (UpperStr(FreqType))

begin

case \"1\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"1\") +
GetField(\"High\", \"1\") + GetField(\"Low\", \"1\")) / 4;

case \"2\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"2\") +
GetField(\"High\", \"2\") + GetField(\"Low\", \"2\")) / 4;

case \"3\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"3\") +
GetField(\"High\", \"3\") + GetField(\"Low\", \"3\")) / 4;

case \"5\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"5\") +
GetField(\"High\", \"5\") + GetField(\"Low\", \"5\")) / 4;

case \"10\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"10\") +
GetField(\"High\", \"10\") + GetField(\"Low\", \"10\")) / 4;

case \"15\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"15\") +
GetField(\"High\", \"15\") + GetField(\"Low\", \"15\")) / 4;

case \"30\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"30\") +
GetField(\"High\", \"30\") + GetField(\"Low\", \"30\")) / 4;

case \"60\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"60\") +
GetField(\"High\", \"60\") + GetField(\"Low\", \"60\")) / 4;

case \"D\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"D\") +
GetField(\"High\", \"D\") + GetField(\"Low\", \"D\")) / 4;

case \"W\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"W\") +
GetField(\"High\", \"W\") + GetField(\"Low\", \"W\")) / 4;

case \"M\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"M\") +
GetField(\"High\", \"M\") + GetField(\"Low\", \"M\")) / 4;

case \"AD\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"AD\") +
GetField(\"High\", \"AD\") + GetField(\"Low\", \"AD\")) / 4;

case \"AW\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"AW\") +
GetField(\"High\", \"AW\") + GetField(\"Low\", \"AW\")) / 4;

case \"AM\":

xfMin_WeightedClose = (2 \* GetField(\"Close\", \"AM\") +
GetField(\"High\", \"AM\") + GetField(\"Low\", \"AM\")) / 4;

default:

xfMin_WeightedClose = (2 \* Close + High + Low) / 4;

end;

#### 📄 xfMin_XAverage

{@type:function}

SetBarMode(2);

// 跨頻率XAverage

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// 輸入: FreqType, Series, Length

// 不支援XS選股、XS選股自訂排行與XS選股回測。

//

input:

FreqType(string), //引用頻率

Series(numericseries), //價格序列

Length(numericsimple); //計算期間

variable:

Factor(0), lastXAverage(0);

if getinfo(\"Instance\")=3 and getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

if FreqType=\"D\" or FreqType=\"AD\" or FreqType=\"W\" or
FreqType=\"AW\" or FreqType=\"M\" or FreqType=\"AM\" then

condition1 = xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")) \<\>
xfMin_getdtvalue(FreqType, getfieldDate(\"Date\")\[1\])

else

condition1 = xfMin_getdtvalue(FreqType, datetime) \<\>
xfMin_getdtvalue(FreqType, datetime\[1\]);

if condition1 then

lastXAverage = xfMin_XAverage\[1\];

value1 = xfMin_GetCurrentBar(FreqType);

if Length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);

if value1 = 1 then

xfMin_XAverage = Series

else

xfMin_XAverage = lastXAverage + Factor \* (Series - lastXAverage);

#### 📄 xf_CrossOver

{@type:function_bool}

SetBarMode(1);

// 傳入兩個序列(跟目前的頻率不同), 判斷是否crossover

//

// FreqType是傳入序列的資料期別, 支援\"D\", \"W\", \"M\"

// SeriesA, SeriesB是傳入的序列

//

input:

FreqType(string),

SeriesA(numericseries),

SeriesB(numericseries);

variable:

valA(0), valB(0), posA(0), posB(0);

posA = 0;

posB = 0;

valA = xf_getvalue(FreqType, SeriesA, posA);

valB = xf_getvalue(FreqType, SeriesB, posB);

if valA \<= valB then

begin

xf_CrossOver = false;

return;

end;

variable: idx(0);

for idx = 1 to 6

begin

posA = posA + 1;

posB = posB + 1;

valA = xf_getvalue(FreqType, SeriesA, posA);

valB = xf_getvalue(FreqType, SeriesB, posB);

if valA \< valB then

begin

xf_CrossOver = true;

return;

end

else

begin

if valA \> valB then

begin

xf_CrossOver = false;

return;

end;

end;

end;

xf_CrossOver = false;

#### 📄 xf_CrossUnder

{@type:function_bool}

SetBarMode(1);

// 傳入兩個序列(跟目前的頻率不同), 判斷是否crossunder

//

// FreqType是傳入序列的資料期別, 支援\"D\", \"W\", \"M\"

// SeriesA, SeriesB是傳入的序列

//

input:

FreqType(string),

SeriesA(numericseries),

SeriesB(numericseries);

variable:

valA(0), valB(0), posA(0), posB(0);

posA = 0;

posB = 0;

valA = xf_getvalue(FreqType, SeriesA, posA);

valB = xf_getvalue(FreqType, SeriesB, posB);

if valA \>= valB then

begin

xf_CrossUnder = false;

return;

end;

variable: idx(0);

for idx = 1 to 6

begin

posA = posA + 1;

posB = posB + 1;

valA = xf_getvalue(FreqType, SeriesA, posA);

valB = xf_getvalue(FreqType, SeriesB, posB);

if valA \> valB then

begin

xf_CrossUnder = true;

return;

end

else

begin

if valA \< valB then

begin

xf_CrossUnder = false;

return;

end;

end;

end;

xf_CrossUnder = false;

#### 📄 xf_DirectionMovement

{@type:function}

SetBarMode(2);

// 跨頻率DirectionMovement function (for DMI相關指標)

//

// FreqType是預期要比對的期別, 支援\"D\", \"W\", \"M\"

// 輸入: FreqType, Length

// Return: pdi_value(+di), ndi_value(-di), adx_value(adx)

//

input:

FreqType(string), //引用頻率

length(numericsimple), //計算期間

pdi_value(numericref), //回傳+DI

ndi_value(numericref), //回傳-DI

adx_value(numericref); //回傳ADX

variable:

padm(0), nadm(0), radx(0),

LastPAdm(0), LastNAdm(0), LastRAdx(0), LastATR(0),

atr(0), pdm(0), ndm(0), tr(0),

dValue0(0), dValue1(0), dx(0),

changeHigh(0),changeLow(0),closePeriod(0),

idx(0);

//跨頻率會用到的前期值需要手動記錄

condition1 = xf_getdtvalue(FreqType, getFieldDate(\"Date\")) \<\>
xf_getdtvalue(FreqType, getFieldDate(\"Date\")\[1\]);

if condition1 then

begin

LastPAdm = padm\[1\];

LastNAdm = nadm\[1\];

LastRAdx = radx\[1\];

LastATR = atr\[1\];

end;

//取得跨頻率會用到的變數值

switch (FreqType)

begin

case \"D\":

if GetField(\"Close\", \"D\")\[1\] \> GetField(\"High\", \"D\") then

tr = GetField(\"Close\", \"D\")\[1\] - GetField(\"Low\", \"D\")

else if GetField(\"Close\", \"D\")\[1\] \< GetField(\"Low\", \"D\") then

tr = GetField(\"High\", \"D\") - GetField(\"Close\", \"D\")\[1\]

else

tr = GetField(\"High\", \"D\") - GetField(\"Low\", \"D\");

changeHigh = GetField(\"High\", \"D\") - GetField(\"High\", \"D\")\[1\];

changeLow = GetField(\"Low\", \"D\")\[1\] - GetField(\"Low\", \"D\");

closePeriod = GetField(\"Close\", \"D\");

case \"W\":

if GetField(\"Close\", \"W\")\[1\] \> GetField(\"High\", \"W\") then

tr = GetField(\"Close\", \"W\")\[1\] - GetField(\"Low\", \"W\")

else if GetField(\"Close\", \"W\")\[1\] \< GetField(\"Low\", \"W\") then

tr = GetField(\"High\", \"W\") - GetField(\"Close\", \"W\")\[1\]

else

tr = GetField(\"High\", \"W\") - GetField(\"Low\", \"W\");

changeHigh = GetField(\"High\", \"W\") - GetField(\"High\", \"W\")\[1\];

changeLow = GetField(\"Low\", \"W\")\[1\] - GetField(\"Low\", \"W\");

closePeriod = GetField(\"Close\", \"W\");

case \"M\":

if GetField(\"Close\", \"M\")\[1\] \> GetField(\"High\", \"M\") then

tr = GetField(\"Close\", \"M\")\[1\] - GetField(\"Low\", \"M\")

else if GetField(\"Close\", \"M\")\[1\] \< GetField(\"Low\", \"M\") then

tr = GetField(\"High\", \"M\") - GetField(\"Close\", \"M\")\[1\]

else

tr = GetField(\"High\", \"M\") - GetField(\"Low\", \"M\");

changeHigh = GetField(\"High\", \"M\") - GetField(\"High\", \"M\")\[1\];

changeLow = GetField(\"Low\", \"M\")\[1\] - GetField(\"Low\", \"M\");

closePeriod = GetField(\"Close\", \"M\");

case \"AD\":

if GetField(\"Close\", \"AD\")\[1\] \> GetField(\"High\", \"AD\") then

tr = GetField(\"Close\", \"AD\")\[1\] - GetField(\"Low\", \"AD\")

else if GetField(\"Close\", \"AD\")\[1\] \< GetField(\"Low\", \"AD\")
then

tr = GetField(\"High\", \"AD\") - GetField(\"Close\", \"AD\")\[1\]

else

tr = GetField(\"High\", \"AD\") - GetField(\"Low\", \"AD\");

changeHigh = GetField(\"High\", \"AD\") - GetField(\"High\",
\"AD\")\[1\];

changeLow = GetField(\"Low\", \"AD\")\[1\] - GetField(\"Low\", \"AD\");

closePeriod = GetField(\"Close\", \"AD\");

case \"AW\":

if GetField(\"Close\", \"AW\")\[1\] \> GetField(\"High\", \"AW\") then

tr = GetField(\"Close\", \"AW\")\[1\] - GetField(\"Low\", \"AW\")

else if GetField(\"Close\", \"AW\")\[1\] \< GetField(\"Low\", \"AW\")
then

tr = GetField(\"High\", \"AW\") - GetField(\"Close\", \"AW\")\[1\]

else

tr = GetField(\"High\", \"AW\") - GetField(\"Low\", \"AW\");

changeHigh = GetField(\"High\", \"AW\") - GetField(\"High\",
\"AW\")\[1\];

changeLow = GetField(\"Low\", \"AW\")\[1\] - GetField(\"Low\", \"AW\");

closePeriod = GetField(\"Close\", \"AW\");

case \"AM\":

if GetField(\"Close\", \"AM\")\[1\] \> GetField(\"High\", \"AM\") then

tr = GetField(\"Close\", \"AM\")\[1\] - GetField(\"Low\", \"AM\")

else if GetField(\"Close\", \"AM\")\[1\] \< GetField(\"Low\", \"AM\")
then

tr = GetField(\"High\", \"AM\") - GetField(\"Close\", \"AM\")\[1\]

else

tr = GetField(\"High\", \"AM\") - GetField(\"Low\", \"AM\");

changeHigh = GetField(\"High\", \"AM\") - GetField(\"High\",
\"AM\")\[1\];

changeLow = GetField(\"Low\", \"AM\")\[1\] - GetField(\"Low\", \"AM\");

closePeriod = GetField(\"Close\", \"AM\");

default:

if Close\[1\] \> High then

tr = Close\[1\] - Low

else if Close\[1\] \< Low then

tr = High - Close\[1\]

else

tr = High - Low;

changeHigh = High - High\[1\];

changeLow = Low\[1\] - Low;

closePeriod = Close;

end;

//原始的技術指標計算

value1 = xf_GetCurrentBar(FreqType);

if value1 = 1 then

begin

padm = closePeriod / 10000;

nadm = padm;

atr = padm \* 5;

radx = 20;

end

else

begin

pdm = maxlist(changeHigh, 0);

ndm = maxlist(changeLow, 0);

if pdm \< ndm then

pdm = 0

else

begin

if pdm \> ndm then

ndm = 0

else

begin

pdm = 0;

ndm = 0;

end;

end;

padm = LastPAdm + (pdm - LastPAdm) / length;

nadm = LastNAdm + (ndm - LastNAdm) / length;

atr = LastATR + (tr - LastATR) / length;

if atr \<\> 0 then begin

dValue0 = 100 \* padm / atr;

dValue1 = 100 \* nadm / atr;

end;

if dValue0 + dValue1 \<\> 0 then

dx = AbsValue(100 \* (dValue0 - dValue1) / (dValue0 + dValue1));

radx = LastRAdx + (dx - LastRAdx) / length;

end;

pdi_value = dValue0;

ndi_value = dValue1;

adx_value = radx;

xf_directionmovement = 1;

#### 📄 xf_EMA

{@type:function}

SetBarMode(2);

// 跨頻率EMA

//

// FreqType是預期要比對的期別, 支援\"D\", \"W\", \"M\"

// 輸入: FreqType, Series, Length

//

input:

FreqType(string), //引用頻率

Series(numericseries), //價格序列

Length(numericsimple); //計算期間

variable:

Factor(0), lastEMA(0);

condition1 = xf_getdtvalue(FreqType, getFieldDate(\"Date\")) \<\>
xf_getdtvalue(FreqType, getFieldDate(\"Date\")\[1\]);

if condition1 then

lastEMA = xf_EMA\[1\];

value1 = xf_GetCurrentBar(FreqType);

if Length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);

if value1 = 1 then

xf_EMA = Series

else if value1 \<= Length then

xf_EMA = (Series + (lastEMA \* (value1 - 1)))/value1

else

xf_EMA = lastEMA + Factor \* (Series - lastEMA);

#### 📄 xf_GetBoolean

{@type:function_bool}

SetBarMode(1);

// 傳入一個序列(跟目前的頻率不同), 取得這個序列以此頻率的第幾筆

//

// FreqType是傳入序列的資料期別, 支援\"D\", \"W\", \"M\"

// TFSeries是傳入的布林序列

// poi是要取得的位置

//

input:

FreqType(string),

TFSeries(truefalseseries),

poi(numeric);

variable: \_pos(0);

\_pos = poi;

if \_pos \<= 0 then

xf_GetBoolean = TFSeries\[0\]

else

begin

variable: idx(0), dt(0), dt2(0);

idx = 0;

while \_pos \> 0 and idx \< currentbar-1

begin

dt = xf_getdtvalue(FreqType, getFieldDate(\"Date\")\[idx\]);

dt2 = xf_getdtvalue(FreqType, getFieldDate(\"Date\")\[idx+1\]);

if dt \<\> dt2 then \_pos = \_pos - 1;

idx = idx + 1;

end;

xf_GetBoolean = TFSeries\[idx\];

end;

#### 📄 xf_GetCurrentBar

{@type:function}

SetBarMode(2);

// 取得指定頻率的K棒編號（CurrentBar）

//

// FreqType是預期要引用的頻率, 支援\"D\", \"W\", \"M\"

// 輸入: FreqType

//

input:

FreqType(string); //引用頻率

condition1 = xf_getdtvalue(FreqType, getFieldDate(\"Date\")) \<\>
xf_getdtvalue(FreqType, getFieldDate(\"Date\")\[1\]);

if currentbar = 1 then

xf_GetCurrentBar = 1

else if condition1 then

xf_GetCurrentBar = xf_GetCurrentBar\[1\] + 1

else

xf_GetCurrentBar = xf_GetCurrentBar\[1\];

#### 📄 xf_GetDTValue

{@type:function}

SetBarMode(1);

// 回傳某個日期的\'normalized\' value

// 用這個value來比對是否已經跨期

//

// FreqType是預期要比對的期別, 支援\"D\", \"W\", \"M\"

// dtValue 是目前資料序列上面的Date

//

input:

FreqType(string),

dtValue(numeric);

switch (FreqType)

begin

case \"D\" , \"AD\":

xf_GetDTValue = dtValue;

case \"W\" , \"AW\":

// 年度 \* 100 + 周別, e.g. 201001, 表示是2010年的第一週

//

xf_GetDTValue = Year(dtValue) \* 100 + WeekofYear(dtValue);

// 每年的第一週需要判斷是否和去年的最後一週重疊

//

if mod(dtValue, 10000) \<= 104 and WeekofYear(DateAdd(dtValue,\"D\",
1-DayofWeek(dtValue))) = 53 then

xf_GetDTValue = round(dtValue / 10000 - 1, 0) \* 100 + 53;

case \"M\" , \"AM\":

// 年度 \* 100 + 月別, e.g. 201001, 表示是2010年的第一個月

//

xf_GetDTValue = Year(dtValue) \* 100 + Month(dtValue);

default:

xf_GetDTValue = dtValue;

end;

#### 📄 xf_GetValue

{@type:function}

SetBarMode(1);

// 傳入一個序列(跟目前的頻率不同), 取得這個序列以此頻率的第幾筆

//

// FreqType是傳入序列的資料期別, 支援\"D\", \"W\", \"M\"

// PriceSeries是傳入的序列

// poi是要取得的位置

//

input:

FreqType(string),

PriceSeries(numericseries),

poi(numeric);

variable: \_pos(0);

\_pos = poi;

if \_pos \<= 0 then

xf_GetValue = PriceSeries\[0\]

else

begin

variable: idx(0), dt(0), dt2(0);

idx = 0;

while \_pos \> 0 and idx \< currentbar-1

begin

dt = xf_getdtvalue(FreqType, getfieldDate(\"Date\")\[idx\]);

dt2 = xf_getdtvalue(FreqType, getfieldDate(\"Date\")\[idx+1\]);

if dt \<\> dt2 then \_pos = \_pos - 1;

idx = idx + 1;

end;

xf_GetValue = PriceSeries\[idx\];

end;

#### 📄 xf_MACD

{@type:function}

SetBarMode(1);

// 跨頻率MACD函數

//

// FreqType是預期要引用的頻率, 支援\"D\", \"W\", \"M\"

// 輸入: FreqType, FastLength, SlowLength, MACDLength;

// 輸出: DifValue, MACDValue, OscValue;

input:

FreqType(string), //引用頻率

Price(numericseries),

FastLength(numericsimple), SlowLength(numericsimple),
MACDLength(numericsimple),

DifValue(numericref), MACDValue(numericref), OscValue(numericref);

DifValue = xf_XAverage(FreqType, Price, FastLength) -
xf_XAverage(FreqType, Price, SlowLength);

MACDValue = xf_XAverage(FreqType, DifValue, MACDLength);

OscValue = DifValue - MACDValue;

xf_MACD = 1;

#### 📄 xf_PercentR

{@type:function}

SetBarMode(1);

// 跨頻率PercentR函數(for 威廉指標)

//

// FreqType是預期要引用的頻率, 支援\"D\", \"W\", \"M\"

// 輸入: FreqType, SeriesH, SeriesL, SeriesC, Length, rsvt, kt

// 輸出: rsv_value, k_value, d_value

//

input:

FreqType(string),

Length(numericsimple);

variable:

maxHigh(0), minLow(0),variableA(0),variableB(0),closePeriod(0);

switch (upperstr(FreqType))

begin

case \"D\":

maxHigh = highest(GetField(\"High\", \"D\"),Length);

minLow = lowest(GetField(\"Low\", \"D\"),Length);

closePeriod = GetField(\"Close\", \"D\");

case \"W\":

maxHigh = highest(GetField(\"High\", \"W\"),Length);

minLow = lowest(GetField(\"Low\", \"W\"),Length);

closePeriod = GetField(\"Close\", \"W\");

case \"M\":

maxHigh = highest(GetField(\"High\", \"M\"),Length);

minLow = lowest(GetField(\"Low\", \"M\"),Length);

closePeriod = GetField(\"Close\", \"M\");

case \"AD\":

maxHigh = highest(GetField(\"High\", \"AD\"),Length);

minLow = lowest(GetField(\"Low\", \"AD\"),Length);

closePeriod = GetField(\"Close\", \"AD\");

case \"AW\":

maxHigh = highest(GetField(\"High\", \"AW\"),Length);

minLow = lowest(GetField(\"Low\", \"AW\"),Length);

closePeriod = GetField(\"Close\", \"AW\");

case \"AM\":

maxHigh = highest(GetField(\"High\", \"AM\"),Length);

minLow = lowest(GetField(\"Low\", \"AM\"),Length);

closePeriod = GetField(\"Close\", \"AM\");

default:

maxHigh = highest(High,Length);

minLow = lowest(Low,Length);

closePeriod = Close;

end;

variableB = maxHigh - minLow;

if variableB \<\> 0 then

xf_PercentR = 100 - ((maxHigh - closePeriod) / variableB) \* 100

else

xf_PercentR = 0;

#### 📄 xf_RSI

{@type:function}

SetBarMode(2);

// 跨頻率RSI函數

//

// FreqType是預期要引用的頻率, 支援\"D\", \"W\", \"M\"

// 輸入: FreqType, Series, Length

//

input:

FreqType(string), //引用頻率

Series(numericseries), //價格序列

Length(numericsimple); //計算期間

variable:

SumUp(0), SumDown(0),

LastSumUp(0), LastSumDown(0),LastRefSeries(Series),

up(0), down(0),

closePeriod(0);

condition1 = xf_getdtvalue(FreqType, getFieldDate(\"Date\")) \<\>
xf_getdtvalue(FreqType, getFieldDate(\"Date\")\[1\]);

if condition1 then

begin

LastSumUp = SumUp\[1\];

LastSumDown = SumDown\[1\];

LastRefSeries = Series\[1\];

end;

if xf_GetCurrentBar(FreqType) = 1 then

begin

SumUp = Average(maxlist(Series - LastRefSeries, 0), Length);

SumDown = Average(maxlist(LastRefSeries - Series, 0), Length);

end

else

begin

up = maxlist(Series - LastRefSeries, 0);

down = maxlist(LastRefSeries - Series, 0);

SumUp = LastSumUp + (up - LastSumUp) / Length;

SumDown = LastSumDown + (down - LastSumDown) / Length;

end;

if SumUp + SumDown = 0 then

xf_RSI = 0

else

xf_RSI = 100 \* SumUp / (SumUp + SumDown);

#### 📄 xf_Stochastic

{@type:function}

SetBarMode(2);

// 跨頻率Stochastic函數(for KD/RSV相關指標)

//

// FreqType是預期要引用的頻率, 支援\"D\", \"W\", \"M\"

// 輸入: FreqType, SeriesH, SeriesL, SeriesC, Length, rsvt, kt

// 輸出: rsv_value, k_value, d_value

//

input:

FreqType(string),

Length(numericsimple), rsvt(numericsimple), kt(numericsimple),

rsv(numericref), k(numericref), d(numericref);

variable:

maxHigh(0), minLow(0),lastK(50),lastD(50),closePeriod(0);

condition1 = xf_getdtvalue(FreqType, getFieldDate(\"Date\")) \<\>
xf_getdtvalue(FreqType, getFieldDate(\"Date\")\[1\]);

if condition1 then

begin

lastK = k\[1\];

lastD = d\[1\];

end;

switch (FreqType)

begin

case \"D\":

maxHigh = highest(GetField(\"High\", \"D\"),Length);

minLow = lowest(GetField(\"Low\", \"D\"),Length);

closePeriod = GetField(\"Close\", \"D\");

case \"W\":

maxHigh = highest(GetField(\"High\", \"W\"),Length);

minLow = lowest(GetField(\"Low\", \"W\"),Length);

closePeriod = GetField(\"Close\", \"W\");

case \"M\":

maxHigh = highest(GetField(\"High\", \"M\"),Length);

minLow = lowest(GetField(\"Low\", \"M\"),Length);

closePeriod = GetField(\"Close\", \"M\");

case \"AD\":

maxHigh = highest(GetField(\"High\", \"AD\"),Length);

minLow = lowest(GetField(\"Low\", \"AD\"),Length);

closePeriod = GetField(\"Close\", \"AD\");

case \"AW\":

maxHigh = highest(GetField(\"High\", \"AW\"),Length);

minLow = lowest(GetField(\"Low\", \"AW\"),Length);

closePeriod = GetField(\"Close\", \"AW\");

case \"AM\":

maxHigh = highest(GetField(\"High\", \"AM\"),Length);

minLow = lowest(GetField(\"Low\", \"AM\"),Length);

closePeriod = GetField(\"Close\", \"AM\");

default:

maxHigh = highest(High,Length);

minLow = lowest(Low,Length);

closePeriod = Close;

end;

if maxHigh \<\> minLow then

rsv = 100 \* (closePeriod - minLow) / (maxHigh - minLow)

else

rsv = 50;

if currentbar = 1 then

begin

k = 50;

d = 50;

end

else

begin

k = (lastK \* (rsvt - 1) + rsv) / rsvt;

d = (lastD \* (kt - 1) + k) / kt;

end;

xf_Stochastic = 1;

#### 📄 xf_WeightedClose

{@type:function}

SetBarMode(1);

// 跨頻率WeightedClose函數

//

// FreqType是預期要引用的頻率, 支援\"D\", \"W\", \"M\"

//

input:

FreqType(string);

switch (upperstr(FreqType))

begin

case \"D\":

xf_WeightedClose = (2 \* GetField(\"Close\", \"D\") + GetField(\"High\",
\"D\") + GetField(\"Low\", \"D\")) / 4;

case \"W\":

xf_WeightedClose = (2 \* GetField(\"Close\", \"W\") + GetField(\"High\",
\"W\") + GetField(\"Low\", \"W\")) / 4;

case \"M\":

xf_WeightedClose = (2 \* GetField(\"Close\", \"M\") + GetField(\"High\",
\"M\") + GetField(\"Low\", \"M\")) / 4;

case \"AD\":

xf_WeightedClose = (2 \* GetField(\"Close\", \"AD\") +
GetField(\"High\", \"AD\") + GetField(\"Low\", \"AD\")) / 4;

case \"AW\":

xf_WeightedClose = (2 \* GetField(\"Close\", \"AW\") +
GetField(\"High\", \"AW\") + GetField(\"Low\", \"AW\")) / 4;

case \"AM\":

xf_WeightedClose = (2 \* GetField(\"Close\", \"AM\") +
GetField(\"High\", \"AM\") + GetField(\"Low\", \"AM\")) / 4;

default:

xf_WeightedClose = (2 \* Close + High + Low) / 4;

end;

#### 📄 xf_XAverage

{@type:function}

SetBarMode(2);

// 跨頻率XAverage

//

// FreqType是預期要比對的期別, 支援\"D\", \"W\", \"M\"

// 輸入: FreqType, Series, Length

//

input:

FreqType(string), //引用頻率

Series(numericseries), //價格序列

Length(numericsimple); //計算期間

variable:

Factor(0), lastXAverage(0);

condition1 = xf_getdtvalue(FreqType, getFieldDate(\"Date\")) \<\>
xf_getdtvalue(FreqType, getFieldDate(\"Date\")\[1\]);

if condition1 then

lastXAverage = xf_XAverage\[1\];

value1 = xf_GetCurrentBar(FreqType);

if Length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);

if value1 = 1 then

xf_XAverage = Series

else

xf_XAverage = lastXAverage + Factor \* (Series - lastXAverage);

#### 📄 xfmin_MTM

{@type:function}

SetBarMode(1);

// 跨頻率MTM函數(for MTM指標)

//

// FreqType是預期要比對的期別, 支援 \"1\", \"2\", \"3\", \"5\", \"10\",
\"15\", \"30\", \"60\", \"D\", \"W\", \"M\", \"AD\", \"AW\", \"AM\"

// 輸入: FreqType, Series, Length

//

input:

FreqType(string), //引用頻率

Length(numericsimple); //計算期間

if getinfo(\"Instance\")=3 or getinfo(\"Instance\")=31 then
raiseruntimeerror(\"此函數不支援XS選股與XS選股自訂排行\");

switch (FreqType)

begin

case \"1\":

xfMin_MTM = GetField(\"收盤價\", \"1\") - GetField(\"收盤價\",
\"1\")\[length\];

case \"2\":

xfMin_MTM = GetField(\"收盤價\", \"2\") - GetField(\"收盤價\",
\"2\")\[length\];

case \"3\":

xfMin_MTM = GetField(\"收盤價\", \"3\") - GetField(\"收盤價\",
\"3\")\[length\];

case \"5\":

xfMin_MTM = GetField(\"收盤價\", \"5\") - GetField(\"收盤價\",
\"5\")\[length\];

case \"10\":

xfMin_MTM = GetField(\"收盤價\", \"10\") - GetField(\"收盤價\",
\"10\")\[length\];

case \"15\":

xfMin_MTM = GetField(\"收盤價\", \"15\") - GetField(\"收盤價\",
\"15\")\[length\];

case \"30\":

xfMin_MTM = GetField(\"收盤價\", \"30\") - GetField(\"收盤價\",
\"30\")\[length\];

case \"60\":

xfMin_MTM = GetField(\"收盤價\", \"60\") - GetField(\"收盤價\",
\"60\")\[length\];

case \"D\":

xfMin_MTM = GetField(\"收盤價\", \"D\") - GetField(\"收盤價\",
\"D\")\[length\];

case \"W\":

xfMin_MTM = GetField(\"收盤價\", \"W\") - GetField(\"收盤價\",
\"W\")\[length\];

case \"M\":

xfMin_MTM = GetField(\"收盤價\", \"M\") - GetField(\"收盤價\",
\"M\")\[length\];

case \"AD\":

xfMin_MTM = GetField(\"收盤價\", \"AD\") - GetField(\"收盤價\",
\"AD\")\[length\];

case \"AW\":

xfMin_MTM = GetField(\"收盤價\", \"AW\") - GetField(\"收盤價\",
\"AW\")\[length\];

case \"AM\":

xfMin_MTM = GetField(\"收盤價\", \"AM\") - GetField(\"收盤價\",
\"AM\")\[length\];

default:

xfMin_MTM = close - close\[length\];

end;

### 1.13 邏輯判斷 (13 個)

#### 📄 AverageIF

{@type:function}

SetBarMode(1);

input: TrueAndFalse(truefalseseries),

thePrice(numericseries),

Length(numericsimple);

variable: variableA(0);

variable:Sum(0);

variableA = 0;

Sum = 0;

for Value1 = 0 to Length - 1

begin

if TrueAndFalse\[Value1\] then

begin

variableA = variableA + 1;

Sum = Sum + thePrice\[Value1\];

end;

end;

if variableA \> 0 then

AverageIf = Sum/variableA

else

AverageIf = 0;

#### 📄 CountIF

{@type:function}

SetBarMode(1);

input:TrueAndFalse(truefalseseries),Length(numericsimple);

variable: variableA(0);

variableA = 0;

for Value1 = 0 to Length - 1

begin

if TrueAndFalse\[Value1\] then

variableA = variableA + 1;

end;

CountIf = variableA;

#### 📄 CountIfARow

{@type:function}

SetBarMode(1);

input:TrueAndFalse(truefalseseries),Length(numericsimple);

CountIfARow = truecount(TrueAndFalse,Length);

#### 📄 CrossOver

{@type:function_bool}

SetBarMode(1);

input:

SeriesA(numericseries),

SeriesB(numericseries);

variable:

valA(0), valB(0), posA(0), posB(0), idx(0);

CrossOver = false;

posA = 0;

posB = 0;

valA = SeriesA\[posA\];

valB = SeriesB\[posB\];

if valA \<= valB then

CrossOver = false

else begin

for idx = 1 to minlist(6, currentbar)

begin

posA = posA + 1;

posB = posB + 1;

valA = SeriesA\[posA\];

valB = SeriesB\[posB\];

if valA \< valB then

begin

CrossOver = true;

break;

end

else

begin

if valA \> valB then

begin

CrossOver = false;

break;

end;

end;

end;

end;

#### 📄 CrossUnder

{@type:function_bool}

SetBarMode(1);

input:

SeriesA(numericseries),

SeriesB(numericseries);

variable:

valA(0), valB(0), posA(0), posB(0), idx(0);

CrossUnder = false;

posA = 0;

posB = 0;

valA = SeriesA\[posA\];

valB = SeriesB\[posB\];

if valA \>= valB then

CrossUnder = false

else begin

for idx = 1 to minlist(6, currentbar)

begin

posA = posA + 1;

posB = posB + 1;

valA = SeriesA\[posA\];

valB = SeriesB\[posB\];

if valA \> valB then

begin

CrossUnder = true;

break;

end

else

begin

if valA \< valB then

begin

CrossUnder = false;

break;

end;

end;

end;

end;

#### 📄 Filter

{@type:function_bool}

SetBarMode(2);

input: pX(TrueFalseSimple), pLength(NumericSimple);

variable: vCounter(0);

If pX Then begin

If vCounter \< pLength Then begin

vCounter = vCounter + 1;

Filter = False;

end Else begin

vCounter = 0;

Filter = True;

End;

end Else begin

vCounter = vCounter + 1;

Filter = False;

End;

#### 📄 IFF

{@type:function}

SetBarMode(1);

input: Logicoperator(truefalsesimple),

TrueReturnV(numericsimple),

FalseReturnV(numericsimple);

if Logicoperator then IFF = TrueReturnV

else IFF = FalseReturnV;

#### 📄 IsXLOrder

{@type:function_bool}

{

判斷成交金額是否是特大單

級距表請參考:

https://www.xq.com.tw/%e5%8f%b0%e8%82%a1%e9%80%90%e7%ad%86%e5%8a%9f%e8%83%bd%e8%a1%8c%e6%83%85%e7%ab%af%e7%9b%b8%e9%97%9c%e7%95%b0%e5%8b%95/

}

input: pv(numericsimple, \"成交金額\");

var: intraBarPersist \_open_price(0);

var: intraBarPersist \_threshold(0);

var: intraBarPersist \_last_date(0);

if \_last_date \<\> Date then begin

\_last_date = Date;

\_open_price = GetField(\"Open\", \"D\");

if \_open_price \< 30 then

\_threshold = 800000

else if \_open_price \< 50 then

\_threshold = 1000000

else if \_open_price \< 100 then

\_threshold = 1200000

else if \_open_price \< 200 then

\_threshold = 2000000

else if \_open_price \< 500 then

\_threshold = 4000000

else

\_threshold = 4000000;

end;

if pv \> \_threshold then retval = true else retval = false;

#### 📄 IsXOrder

{@type:function_bool}

{

判斷成交金額是否是大單(大單+特大單)

級距表請參考:

https://www.xq.com.tw/%e5%8f%b0%e8%82%a1%e9%80%90%e7%ad%86%e5%8a%9f%e8%83%bd%e8%a1%8c%e6%83%85%e7%ab%af%e7%9b%b8%e9%97%9c%e7%95%b0%e5%8b%95/

}

input: pv(numericsimple, \"成交金額\");

var: intraBarPersist \_open_price(0);

var: intraBarPersist \_threshold(0);

var: intraBarPersist \_last_date(0);

if \_last_date \<\> Date then begin

\_last_date = Date;

\_open_price = GetField(\"Open\", \"D\");

if \_open_price \< 30 then

\_threshold = 400000

else if \_open_price \< 50 then

\_threshold = 500000

else if \_open_price \< 100 then

\_threshold = 700000

else if \_open_price \< 200 then

\_threshold = 1200000

else if \_open_price \< 500 then

\_threshold = 2000000

else

\_threshold = 2500000;

end;

if pv \> \_threshold then retval = true else retval = false;

#### 📄 SummationIF

{@type:function}

SetBarMode(1);

input: TrueAndFalse(truefalseseries), thePrice(numericseries),
Length(numericsimple);

variable: \_Output(0);

\_Output = 0;

for Value1 = 0 to Length - 1

begin

if TrueAndFalse\[Value1\] then \_Output = \_Output + thePrice\[Value1\];

end;

SummationIf = \_Output;

#### 📄 TrueAll

{@type:function_bool}

SetBarMode(1);

input:TrueAndFalse(truefalseseries), Length(numericsimple);

TrueAll = True;

for Value1 = 0 to Length - 1

begin

if TrueAndFalse\[Value1\] = False then

begin

TrueAll = False;

break;

end;

end;

#### 📄 TrueAny

{@type:function_bool}

SetBarMode(1);

input:TrueAndFalse(truefalseseries), Length(numericsimple);

TrueAny = False;

for Value1 = 0 to Length - 1

begin

if TrueAndFalse\[Value1\] then

begin

TrueAny = True;

break;

end;

end;

#### 📄 TrueCount

{@type:function}

SetBarMode(1);

input:TrueAndFalse(truefalseseries), Length(numericsimple);

value2 = 0;

for Value1 = 0 to Length - 1

begin

if TrueAndFalse\[Value1\] = true then

value2 = value2 +1

else

begin

break;

end;

end;

TrueCount = value2;

### 1.14 量能相關 (4 個)

#### 📄 DiffBidAskVolumeLxL

{@type:function}

{

DiffBidAskVolumeLxL為近15分鐘大戶買賣超的函數，

該函數運算出來的數值，與XS指標的「流動大戶買賣力」指標相同。

}

array:\_ArrayLarge\[15\](0),\_ArraySmall\[15\](0);

var:\_Count(0);

if barfreq \<\> \"Min\" or barinterval \<\> 1 then

raiseruntimeerror(\"僅支援 1 分鐘頻率\");

//初始化

if getfieldDate(\"Date\") \<\> getfieldDate(\"Date\")\[1\] then begin

\_Count = 0;

Array_SetValRange(\_ArrayLarge, 1, 15, 0);

Array_SetValRange(\_ArraySmall, 1, 15, 0);

value3 = 0;

value99 = 0;

end else begin

\_Count += 1;

end;

value99 = mod(\_count,15) + 1;

\_ArrayLarge\[value99\] = GetField(\"買進大單量\", \"1\") +
GetField(\"買進特大單量\", \"1\");

\_ArraySmall\[value99\] = GetField(\"賣出大單量\", \"1\") +
GetField(\"賣出特大單量\", \"1\");

value1 = Array_Sum(\_ArrayLarge, 1, 15);

value2 = Array_Sum(\_ArraySmall, 1, 15);

DiffBidAskVolumeLxL = value1 - value2;

#### 📄 DiffBidAskVolumeXL

{@type:function}

{

DiffBidAskVolumeXL為近15分鐘特大單買賣超的函數。

計算方式為「近15分鐘累計的買進特大單量－賣出特大單量」

}

array:\_ArrayLarge\[15\](0),\_ArraySmall\[15\](0);

var:\_Count(0);

if barfreq \<\> \"Min\" or barinterval \<\> 1 then

raiseruntimeerror(\"僅支援 1 分鐘頻率\");

//初始化

if getfieldDate(\"Date\") \<\> getfieldDate(\"Date\")\[1\] then begin

\_Count = 0;

Array_SetValRange(\_ArrayLarge, 1, 15, 0);

Array_SetValRange(\_ArraySmall, 1, 15, 0);

value3 = 0;

value99 = 0;

end else begin

\_Count += 1;

end;

value99 = mod(\_count,15) + 1;

\_ArrayLarge\[value99\] = GetField(\"買進特大單量\", \"1\");

\_ArraySmall\[value99\] = GetField(\"賣出特大單量\", \"1\");

value1 = Array_Sum(\_ArrayLarge, 1, 15);

value2 = Array_Sum(\_ArraySmall, 1, 15);

DiffBidAskVolumeXL = value1 - value2;

#### 📄 DiffTradeVolumeAtAskBid

{@type:function}

{

DiffTradeVolumeAtAskBid為分時買賣力的函數，

該函數運算出來的數值，與XS指標的「分時買賣力」指標相同。

}

value1 = GetField(\"外盤量\");

value2 = GetField(\"內盤量\");

DiffTradeVolumeAtAskBid = value1 - value2;

#### 📄 DiffUpDownVolume

{@type:function}

{

DiffUpDownVolume為分時漲跌成交量的函數，

該函數運算出來的數值，與XS指標的「分時漲跌成交量」指標相同。

}

DiffUpDownVolume = GetField(\"上漲量\") - GetField(\"下跌量\");

## 2. 📊 指標 (395 個腳本)

> 技術指標、量能指標、籌碼指標等的繪圖腳本

### 2.1 XQ技術指標 (32 個)

#### 📄 3-6 乖離率

{@type:indicator}

// XQ 3-6 乖離率

//

input: Length1(3), Length2(6);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

Plot1(Bias(Length1) - Bias(Length2), \"3-6乖離率(%)\");

#### 📄 3-6乖離率轉折點

{@type:indicator}

// XQ: 3-6乖離率轉折點

//

Value1 = 2 \* Close\[3\] - Close\[6\];

Plot1(Value1, \"T\");

#### 📄 ACC (加速量指標)

{@type:indicator}

// XQ: ACC指標

//

input: Length(10);

SetInputName(1, \"天數\");

value1 = Momentum(Close, Length);

value2 = Momentum(value1, Length);

Plot1(value2, \"ACC\");

#### 📄 AD-Osc(聚散擺盪指標)

{@type:indicator}

// XQ: A/D Osc 指標

//

variable: bp(0), sp(0), ado(0);

bp = High - Open;

sp = Close - Low;

if High \<\> low then

ado = (bp + sp)/(2\*(High - Low))\*100

else

ado = 50;

plot1(ado, \"A/D-Osc\");

#### 📄 ADI (累積分配指標)

{@type:indicator}

// XQ: A/DI 指標

//

variable: adi(0);

if Close \> Close\[1\] then

adi = adi\[1\] + (Close - minlist(low, close\[1\]))

else

begin

if Close \< Close\[1\] then

adi = adi\[1\] - (maxlist(high, close\[1\]) - close)

else

adi = adi\[1\];

end;

Plot1(adi, \"A/DI\");

#### 📄 AR 指標

{@type:indicator}

// XQ: AR指標

//

input: Length(26);

variable: sum(0), ar(0);

SetInputName(1, \"天數\");

sum = Summation((Open - Low), Length);

if sum \<\> 0 then

ar = 100 \* Summation((High - Open), length) / sum

else

ar = ar\[1\];

Plot1(ar, \"AR(%)\");

#### 📄 ATR (平均真實區域)

{@type:indicator}

// XQ: ATR指標

//

input: Length(14);

SetInputName(1, \"天數\");

value1 = Average(TrueRange, Length);

Plot1(value1, \"ATR\");

#### 📄 BBand width (布林通道寬度指標)

{@type:indicator}

// XQ: BBandWidth指標

//

input: Length(20), UpperBand(2), LowerBand(2), EMALength(3);

variable: up(0), down(0), mid(0), bbandwidth(0), ema(0);

SetInputName(1, \"天數\");

SetInputName(2, \"上\");

SetInputName(3, \"下\");

SetInputName(4, \"EMA\");

up = bollingerband(Close, Length, UpperBand);

down = bollingerband(Close, Length, -1 \* LowerBand);

mid = (up + down) / 2;

bbandwidth = 100 \* (up - down) / mid;

ema = XAverage(bbandwidth, EMALength);

Plot1(bbandwidth , \"BBand width(%)\");

Plot2(ema, \"Band% EMA\");

#### 📄 BIAS 乖離率

{@type:indicator}

// XQ 乖離率

//

input: Length1(5), Length2(10), Length3(20);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

SetInputName(3, \"天數三\");

Plot1(Bias(Length1), \"BIAS1(%)\");

Plot2(Bias(Length2), \"BIAS2(%)\");

Plot3(Bias(Length3), \"BIAS3(%)\");

#### 📄 BR 指標

{@type:indicator}

// XQ BR指標

//

input: Length(26);

variable: sum(0), \_br(0);

SetInputName(1, \"天數\");

sum= Summation((Close\[1\] - Low), length);

if sum \<\> 0 then

\_br = 100 \* Summation((High - Close\[1\]), length) / sum

else

\_br = \_br\[1\];

Plot1(\_br, \"BR(%)\");

#### 📄 CCI (商品通道指標)

{@type:indicator}

// XQ: CCI指標

//

input:

Length1(14,\"天數一\"),

Length2(28,\"天數二\"),

Length3(42,\"天數三\"),

UpBaseLine(100,\"上基準線\"),

MidBaseLine(0,\"中基準線\"),

UnderBaseLine(-100,\"下基準線\");

Plot1(CommodityChannel(Length1), \"CCI1\");

Plot2(CommodityChannel(Length2), \"CCI2\");

Plot3(CommodityChannel(Length3), \"CCI3\");

plot4(UpBaseLine, \"上基準線\", checkbox:=0);

plot5(MidBaseLine, \"中基準線\", checkbox:=0);

plot6(UnderBaseLine, \"下基準線\" , checkbox:=0);

#### 📄 DMI (趨向指標)

{@type:indicator}

// XQ: DMI指標

//

input: Length(14);

variable: pdi_value(0), ndi_value(0), adx_value(0);

SetInputName(1, \"天數\");

DirectionMovement(Length, pdi_value, ndi_value, adx_value);

// 初始區波動較大, 先不繪出

//

if CurrentBar \< Length then

begin

pdi_value = 0;

ndi_value = 0;

adx_value = 0;

end;

Plot1(pdi_value, \"+DI\");

Plot2(ndi_value, \"-DI\");

Plot3(adx_value, \"ADX\");

#### 📄 DMI-Osc(趨向擺盪線)

{@type:indicator}

// XQ: DMI-Osc指標

//

input: Length( 14 );

variable: pdi_value(0), ndi_value(0), adx_value(0);

SetInputName(1, \"天數\");

DirectionMovement(Length, pdi_value, ndi_value, adx_value);

// 初始區波動較大, 先不繪出

//

if CurrentBar \< Length then

begin

pdi_value = 0;

ndi_value = 0;

adx_value = 0;

end;

Plot1(pdi_value - ndi_value, \"DMI-Osc\");

#### 📄 DPO (非趨勢價格擺盪指標)

{@type:indicator}

// XQ: DPO指標

//

input: Length(10);

variable: dpo(0);

SetInputName(1, \"天數\");

dpo = Close - Average(Close, Length)\[(Length /2) + 1\];

Plot1(dpo, \"DPO\");

#### 📄 HL-Osc (高低價擺盪指標)

{@type:indicator}

// XQ: HL-Osc 指標

//

variable: tr(0), hlo(0);

tr = TrueRange;

if tr \<\> 0 then

hlo = 100 \* (H - C\[1\]) / tr

else

hlo = 0;

plot1(hlo, \"HL-Osc\");

#### 📄 KD 隨機指標

{@type:indicator}

// XQ: KD指標

//

input: Length(9), RSVt(3), Kt(3);

variable: rsv(0), k(0), \_d(0);

SetInputName(1, \"天數\");

SetInputName(2, \"RSVt權數\");

SetInputName(3, \"Kt權數\");

Stochastic(Length, RSVt, Kt, rsv, k, \_d);

Plot1(k, \"K(%)\");

Plot2(\_d, \"D(%)\");

#### 📄 KDJ 隨機指標

{@type:indicator}

// XQ: KDJ指標

//

input: Length(9), RSVt(3), Kt(3), JType(0);

variable: rsv(0), k(0), \_d(0), j(0);

SetInputName(1, \"天數\");

SetInputName(2, \"RSVt權數\");

SetInputName(3, \"Kt權數\");

Stochastic(Length, RSVt, Kt, rsv, k, \_d);

Plot1(k, \"K(%)\");

Plot2(\_d, \"D(%)\");

if JType = 0 then

j = 3 \* k - 2 \* \_d

else

j = 3 \* \_d - 2 \* k;

Plot3(j, \"J(%)\");

#### 📄 MA-Osc (移動平均線擺盪指標)

{@type:indicator}

// XQ: MA-Osc

//

input: Length1(5), Length2(10);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

value1 = Average(close, Length1);

value2 = Average(close, Length2);

value3 = (value1 - value2);

Plot1(value3, \"MA-Osc\");

#### 📄 MACD 指標

{@type:indicator}

// XQ: MACD指標

//

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: price(0);

SetInputName(1, \"DIF短天數\");

SetInputName(2, \"DIF長天數\");

SetInputName(3, \"MACD天數\");

price = WeightedClose();

Value1 = XAverage(price, FastLength) - XAverage(price, SlowLength);

Value2 = XAverage(Value1, MACDLength) ;

Value3 = Value1 - Value2 ;

// 前面區段資料變動較大, 先不繪出

//

if CurrentBar \<= SlowLength then

begin

Value1 = 0;

Value2 = 0;

Value3 = 0;

end;

Plot1(Value1, \"DIF\");

Plot2(Value2, \"MACD\");

Plot3(Value3, \"Osc\");

#### 📄 MAM(移動平均動量指標)

{@type:indicator}

// XQ: MAM指標

//

Input: Length(10), Distance(10);

Variable: mam(0);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

Value1 = Average(Close, Length);

Value2 = Average(Close, Length)\[Distance\];

mam = Value1 - Value2;

Plot1(mam, \"MAM\");

#### 📄 MI(質量指標)

{@type:indicator}

// XQ: MI指標

//

input: Length(9), SumLength(25);

variable: ema1(0), ema2(0), divSeries(0), mi(0);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

ema1 = XAverage(High - Low, length);

ema2 = XAverage(ema1, length);

if ema2 \<\> 0 then

divSeries = ema1 / ema2

else

divSeries = 0;

if CurrentBar \>= sumLength then

mi = Summation(divSeries, sumLength)

else

mi = 0;

Plot1(mi, \"MI\");

#### 📄 MO(運動量擺盪指標)

{@type:indicator}

// XQ: MO指標

//

input: Length(10);

variable: mo(0);

SetInputName(1, \"天數\");

mo = 100 \* Close / Close\[Length\];

Plot1(mo, \"MO\");

#### 📄 MTM(動量指標)

{@type:indicator}

// XQ: MTM指標

//

input: Length(10);

SetInputName(1, \"天數\");

value1 = Momentum(Close, Length);

if CurrentBar \>= Length then

Value2 = Average(Value1, Length)

else

Value2 = Value1;

Plot1(value1, \"MTM\");

Plot2(value2, \"MA\");

#### 📄 PSY 心理線

{@type:indicator}

// XQ: 心理線

//

input: Length1(12), Length2(24);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

Value1 = 100 \* CountIf(Close \> Close\[1\], Length1) / Length1;

Value2 = 100 \* CountIf(Close \> Close\[1\], Length2) / Length2;

Plot1(Value1, \"PSY1\");

Plot2(Value2, \"PSY2\");

#### 📄 RC(價格變動率指標)

{@type:indicator}

// XQ: RC指標

//

input: Length(12), EMALength(12);

SetInputName(1, \"天數\");

SetInputName(2, \"平滑天數\");

value1 = (Close - Close\[Length\]) / Close\[Length\];

value2 = XAverage(value1, EMALength);

Plot1(value1, \"RC\");

Plot2(value2, \"ERC\");

#### 📄 RSI指標

{@type:indicator}

// XQ: RSI指標

//

input: Length1(6), Length2(12);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

Plot1(RSI(Close, Length1), \"RSI1\");

Plot2(RSI(Close, Length2), \"RSI2\");

#### 📄 RSV 指標

{@type:indicator}

// XQ: RSV指標

//

input: Length(9);

variable: RSVt(3), Kt(3), rsv(0), k(0), \_d(0);

SetInputName(1, \"天數\");

Stochastic(Length, RSVt, Kt, rsv, k, \_d);

Plot1(rsv, \"RSV(%)\");

#### 📄 TRIX(三重指數平滑移動平均指標)

{@type:indicator}

// XQ: TRIX指標

//

input: Length1(9), Length2(15);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

Value1 = TRIX(Close, Length1) \* 100;

Value2 = TRIX(Close, Length2) \* 100;

Plot1(Value1, \"TRIX1\");

Plot2(Value2, \"TRIX2\");

#### 📄 VHF(垂直水平過濾指標)

{@type:indicator}

// XQ: VHF指標

//

input: Length(42);

Variable: hp(0), lp(0), numerator(0), denominator(0), \_vhf(0);

SetInputName(1, \"天數\");

hp = highest(Close, Length);

lp = lowest(Close, Length);

numerator = hp - lp;

denominator = Summation(absvalue((Close - Close\[1\])), Length);

if denominator \<\> 0 then

\_vhf = numerator / denominator

else

\_vhf = 0;

Plot1(\_vhf, \"VHF\");

#### 📄 WAD 威廉多空力度線

{@type:indicator}

// XQ: WA/D 指標

//

variable: wad(0), \_ad(0);

if CurrentBar = 1 then

wad = 0

else

begin

if close = close\[1\] then

\_ad = 0

else

begin

if close \< close\[1\] then

\_ad = close - TrueHigh

else { close \> close\[1\] }

\_ad = close - TrueLow;

end;

wad = \_ad + wad\[1\];

end;

Plot1(wad, \"WA/D\");

#### 📄 威廉指標

{@type:indicator}

// XQ: 威廉指標

//

input: Length1(14), Length2(28), Length3(42);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

SetInputName(3, \"天數三\");

value1 = PercentR(Length1) - 100;

value2 = PercentR(Length2) - 100;

value3 = PercentR(Length3) - 100;

Plot1(value1, \"威廉指標1\");

Plot2(value2, \"威廉指標2\");

Plot3(value3, \"威廉指標3\");

#### 📄 快速KD 隨機指標

{@type:indicator}

// XQ: 快速KD指標

//

input: Length(9), RSVt(3);

variable: rsv(0), k(0), \_d(0);

SetInputName(1, \"天數\");

SetInputName(2, \"RSVt權數\");

Stochastic(Length, RSVt, 3, rsv, k, \_d);

Plot1(rsv, \"K(%)\");

Plot2(k, \"D(%)\");

### 2.2 XQ量能指標 (18 個)

#### 📄 CV(積量指標)

{@type:indicator}

// XQ: CV指標

//

Variable: \_cv(0);

If CurrentBar = 1 then

\_cv = Close \* Volume

else

\_cv = \_cv\[1\] + (Close - Close\[1\]) \* Volume;

Plot1(\_cv, \"CV\");

#### 📄 CVI(累計成交量指標)

{@type:indicator}

// XQ: CVI指標

//

variable: \_cvi(0);

If CurrentBar \> 1 then

\_cvi = \_cvi\[1\] + GetField(\"UpVolume\") - GetField(\"DownVolume\");

Plot1(\_cvi, \"CVI\");

#### 📄 EMV(簡易波動指標)

{@type:indicator}

// XQ: EMV指標

//

Input: Length(14);

variable: \_emv(0), factor(10000), avg(0);

SetInputName(1, \"天數\");

if Volume = 0 then

\_emv = 0

else

\_emv = factor \* (((High + Low) / 2 - (High\[1\] + Low\[1\]) / 2) \*
(High - Low)) / Volume;

Plot1(\_emv, \"EMV\");

If CurrentBar \>= Length Then

avg = Average(\_emv, Length)

else

avg = \_emv;

Plot2(avg, \"EMVA\");

#### 📄 MFI(資金流向指標)

{@type:indicator}

// XQ: MFI指標

//

Input: Length(6);

variable: tp(0), tv(0), utv(0), dtv(0), pmf(0), nmf(0), mfivalue(0);

SetInputName(1, \"天數\");

tp = TypicalPrice;

tv = tp \* Volume;

if tp \> tp\[1\] then

begin

utv = tv;

dtv = 0;

end

else

begin

utv = 0;

dtv = tv;

end;

pmf = Average(utv, MinList(CurrentBar, length));

nmf = Average(dtv, MinList(CurrentBar, length));

if CurrentBar \< Length or (pmf + nmf) = 0 then

mfivalue = 50

else

mfivalue = 100 \* pmf /(pmf + nmf);

Plot1(mfivalue, \"MFI\");

#### 📄 NVI(負量指標)

{@type:indicator}

// XQ: NVI指標

//

Variable: \_nvi(1);

if CurrentBar = 1 then

\_nvi = 1

else

begin

if Volume \< Volume\[1\] then

\_nvi = \_nvi\[1\] + (Close - Close\[1\]) / Close\[1\]

else

\_nvi = \_nvi\[1\];

end;

Plot1(\_nvi, \"NVI\");

#### 📄 OBV(能量潮指標)

{@type:indicator}

// XQ: OBV指標

//

input:SMAlength(5,\"OBV的短MA期數\"), MMAlength(20,\"OBV的中MA期數\");

variable: obvolume(0), obvSMA(0), obvSMA_Str(\"\"), obvMMA(0),
obvMMA_Str(\"\");

if CurrentBar = 1 then

obvolume = 0

else

begin

if close \> close\[1\] then

obvolume = obvolume\[1\] + volume

else

begin

if close \< close\[1\] then

obvolume = obvolume\[1\] - volume

else

obvolume = obvolume\[1\];

end;

end;

obvSMA = average(obvolume,SMAlength);

obvMMA = average(obvolume,MMAlength);

obvSMA_Str = text(numToStr(SMAlength,0),\"MA\");

obvMMA_Str = text(numToStr(MMAlength,0),\"MA\");

Plot1(obvolume,\"OBV\");

plot2(obvSMA,\"SMA\",checkbox:=1);

plot3(obvMMA,\"MMA\",checkbox:=1);

setplotLabel(2,obvSMA_Str);

setplotLabel(3,obvMMA_Str);

#### 📄 PVC(成交量變動百分比指標)

{@type:indicator}

// XQ: PVC指標

//

Input: Length(10);

Variable: \_pvc(0);

SetInputName(1, \"天數\");

value1 = Average(Volume, Length);

if value1 \<\> 0 then

\_pvc = 100 \* (Volume - value1) / value1

else

\_pvc = 0;

Plot1(\_pvc, \"PVC\");

#### 📄 PVI(正量指標)

{@type:indicator}

// XQ: PVI指標

//

Variable: \_pvi(1);

If CurrentBar = 1 then

\_pvi = 1

else

begin

if Volume \> Volume\[1\] then

\_pvi = \_pvi\[1\] + (Close - Close\[1\]) / Close\[1\]

else

\_pvi = \_pvi\[1\];

end;

Plot1(\_pvi, \"PVI\");

#### 📄 PVT(價量趨勢指標)

{@type:indicator}

// XQ: PVT指標

//

variable: \_pvt(0);

If CurrentBar = 1 then

\_pvt = 0

else

\_pvt = \_pvt\[1\] + (close - close\[1\])/close\[1\] \* Volume;

Plot1(\_pvt, \"PVT\");

#### 📄 TAPI(每點成交值指標)

{@type:indicator}

// XQ: TAPI指標

//

Plot1(Volume / Close, \"TAPI\");

#### 📄 VA(成交量累積散佈指標)

{@type:indicator}

// XQ: VA指標

//

Variable: \_va(0);

if High \<\> Low then

Value1 = ((Close - Low) - (High - Close))/(High - Low) \* Volume

else

Value1 = 0;

If CurrentBar = 1 then

\_va = Value1

else

\_va = Value1 + \_va\[1\];

Plot1(\_va, \"VA\");

#### 📄 VAOsc(成交量累積散佈擺盪指標)

{@type:indicator}

// XQ: VA-Osc指標

//

variable: support(0), resist(0), hlDiff(0), netSupportResist(0);

support = (Close - Low);

resist = (High - Close);

hlDiff = (High - Low);

if hlDiff = 0 then

netSupportResist = 0

else

netSupportResist = (support - resist) / hlDiff;

Plot1(netSupportResist \* Volume, \"VA-Osc\");

#### 📄 VR(成交量比率指標)

{@type:indicator}

// XQ: VR指標

//

input: Length(26);

variable: \_index(0), qu(0), qd(0), qf(0), \_vr(0);

SetInputName(1, \"天數\");

qf = 0;

qu = 0;

qd = 0;

for \_index = 1 to length

begin

if close\[(\_index - 1)\] \> close\[\_index\] then

qu = qu + Volume\[(\_index - 1)\]

else

begin

if close\[(\_index - 1)\] \< close\[\_index\] then

qd = qd + Volume\[(\_index - 1)\]

else { close\[(\_index - 1)\] = close\[\_index\] }

qf = qf + Volume\[(\_index - 1)\];

end;

end;

if (qd + qf/2) \<\> 0 then

\_vr = 100 \* (qu + qf/2) /(qd + qf/2)

else

\_vr = 1000;

Plot1(\_vr, \"VR\");

#### 📄 VRC(成交量變動指標)

{@type:indicator}

// XQ: VRC指標

//

Input: Length(12);

Variable: \_vrc(0);

SetInputName(1, \"天數\");

if volume\[Length\] \<\> 0 then

\_vrc = 100 \* (volume - volume\[Length\])/volume\[Length\]

else

\_vrc = 50;

Plot1(\_vrc, \"VRC\");

#### 📄 VVA指標

{@type:indicator}

// XQ: VVA指標

//

variable: \_vva(0);

if High \<\> Low then

Value1 = (Close - Open)/(High - Low) \* Volume

else

Value1 = 0;

If CurrentBar = 1 then

\_vva = Value1

else

\_vva = Value1 + \_vva\[1\];

Plot1(\_vva, \"VVA\");

#### 📄 投資建議目標價潛在獲利率

{@type:indicator}

//支援頻率：不定期

//支援商品 ：美(股票)

var:exchange(\"\");

exchange = GetSymbolInfo(\"交易所\");

if exchange \<\> \"NYSE\" and exchange \<\> \"NASDAQ\" and exchange \<\>
\"AMEX\" then raiseruntimeerror(\"僅支援美股\");

if getField(\"投資建議目標價\") \<\> 0 then

value1 =
(getField(\"投資建議目標價\")-close)/getField(\"投資建議目標價\")

else value1 = 0;

plot1(value1,\"潛在獲利率\");

#### 📄 投資建議評級(%)

{@type:indicator}

//支援頻率：不定期

//支援商品 ：美(股票)

{ 說明：

value1 = getField(\"投資建議評級\");

1\<= value1 \< 1.5 (SB_積極買進)

1.5 \<= value1 \< 2.5 (B_買進)

2.5 \<= value1 \< 3.5 (H_中立)

3.5 \<= value1 \< 4.5 (S_賣出)

4.5 \<= value1 \<= 5(SS_積極賣出)

}

var:exchange(\"\");

exchange = GetSymbolInfo(\"交易所\");

if exchange \<\> \"NYSE\" and exchange \<\> \"NASDAQ\" and exchange \<\>
\"AMEX\" then raiseruntimeerror(\"僅支援美股\");

var:\_rank(0);

value1 = getField(\"投資建議評級\");

if value1 = 0 then raiseruntimeerror(\"無投資建議評級的歷史紀錄\");

\_rank = (5-value1)/4; //將投資建議評級，轉成0\~100的分布形式

plot1(\_rank);

if 1\>=\_rank and \_rank\>0.875 then begin

plot20(\_rank);

setplotLabel(1,\"積極買進\");

end else if 0.875\>=\_rank and \_rank\>0.625 then begin

plot21(\_rank);

setplotLabel(1,\"買進\");

end else if 0.625\>=\_rank and \_rank\>0.375 then begin

plot22(\_rank);

setplotLabel(1,\"中立\");

end else if 0.375\>=\_rank and \_rank\>0.125 then begin

plot23(\_rank);

setplotLabel(1,\"賣出\");

end else if 0.125\>=\_rank and \_rank\>=0 then begin

plot24(\_rank);

setplotLabel(1,\"積極賣出\");

end;

#### 📄 新聞分數

{@type:indicator}

{

XQ量能指標。

支援日頻率。支援上市櫃普通股商品。

}

value1 = GetField(\"新聞正向分數\") - GetField(\"新聞負向分數\");

//新聞總分=正向分數－負向分數。來判斷目前的新聞聲量為正向或者負向。

plot1(value1,\"新聞總分\");//正向分數-負向分數

plot2(GetField(\"新聞聲量分數\"),\"新聞總量\",checkbox:=1);//正向分數+負向分數

plot3(GetField(\"新聞正向分數\"),\"新聞正總量\",checkbox:=0);

plot4(GetField(\"新聞負向分數\"),\"新聞負總量\",checkbox:=0);

### 2.3 主圖指標 (30 個)

#### 📄 BBand軌道線

{@type:indicator}

input:

Length(20, \"MA的天數\"),

UpperBand(2, \"上通道標準差倍數\"),

LowerBand(2, \"下通道標準差倍數\");

variable: mid(0), up(0), down(0);

up = bollingerband(Close, Length, UpperBand);

mid = average(close, Length);

down = bollingerband(Close, Length, -1 \* LowerBand);

plot1(up, \"UB\");

plot2(mid, \"BBandMA\");

plot3(down, \"LB\");

#### 📄 CDP

{@type:indicator}

{

PlotLine(PlotIndex, x1, y1, x2, y2, add:=0);

PlotIndex為 1 \~ 999，作用如同 Plot 的序列編號

x1 為起點的 Bar Number (可用 CurrentBar 確認)

y1 為起點的 Y 軸數值 (ex. 價格)

x2 為終點的 Bar Number

add 為非必要參數，預設為
0，執行後會先清除之前的趨勢線，若不希望清除的話則可以設為 1。

CDP指標

CDP＝(H\[1\] + L\[1\] + 2C\[1\])/4

AH = CDP + (H\[1\]-L\[1\])

NH = 2\*CDP - L\[1\]

NL = 2\*CDP - H\[1\]

AL = CDP - (H\[1\]-L\[1\])

只支援分鐘線

}

input: plotLen(1, \"繪圖區間\", inputkind:= Dict(\[\"每日\", 1\],
\[\"當日\", 2\]));

if BarFreq \<\> \"Min\" then RaiseRunTimeError(\"請跑分鐘頻率\");

var: HH(0), LL(0), CC(0);

var: CDP(0), AH(0), NH(0), NL(0), AL(0);

var: bar_count(0);

var: x1_bar(0);

//換日時計算當日的CDP數值

if GetFieldDate(\"Date\") \<\> GetFieldDate(\"Date\")\[1\] then begin

bar_count = 0;

x1_bar = CurrentBar;

HH = GetField(\"High\", \"D\")\[1\];

LL = GetField(\"Low\", \"D\")\[1\];

CC = GetField(\"Close\", \"D\")\[1\];

CDP = (HH + LL + 2\*CC) / 4;

AH = CDP + HH - LL;

NH = 2\*CDP - LL;

NL = 2\*CDP - HH;

AL = CDP - (HH - LL);

end;

if plotLen = 1 then begin

if x1_bar \<\> 0 then begin

PlotLine(1, x1_bar, CDP, CurrentBar, CDP, \"CDP\", add:=1);

PlotLine(2, x1_bar, NH, CurrentBar, NH, \"NH\", add:=1);

PlotLine(3, x1_bar, NL, CurrentBar, NL, \"NL\", add:=1);

PlotLine(4, x1_bar, AH, CurrentBar, AH, \"AH\", add:=1);

PlotLine(5, x1_bar, AL, CurrentBar, AL, \"AL\", add:=1);

end;

end

else if plotLen = 2 then begin

if islastBar then begin

PlotLine(1, x1_bar, CDP, CurrentBar, CDP, \"CDP\");

PlotLine(2, x1_bar, NH, CurrentBar, NH, \"NH\");

PlotLine(3, x1_bar, NL, CurrentBar, NL, \"NL\");

PlotLine(4, x1_bar, AH, CurrentBar, AH, \"AH\");

PlotLine(5, x1_bar, AL, CurrentBar, AL, \"AL\");

end;

end;

#### 📄 EMA

{@type:indicator}

Input: Period1(50); SetInputName(1, \"EMA1\");

Input: Period2(120); SetInputName(2, \"EMA2\");

Input: Period3(240); setinputname(3, \"EMA3\");

Plot1(EMA(Close, Period1), \"EMA1\");

Plot2(EMA(Close, Period2), \"EMA2\");

Plot3(EMA(Close, Period3), \"EMA3\");

#### 📄 SAR

{@type:indicator}

input:

AFInitial(0.02, \"加速因子起始值\"),

AFIncrement(0.02, \"加速因子累加值\"),

AFMax(0.2, \"加速因子最高值\");

plot1(SAR(AFInitial, AFIncrement, AFMax), \"SAR\");

#### 📄 ZigZag

{@type:indicator}

{

PlotLine(PlotIndex, x1, y1, x2, y2, add:=0);

PlotIndex為 1 \~ 999，作用如同 Plot 的序列編號

x1 為起點的 Bar Number (可用 CurrentBar 確認)

y1 為起點的 Y 軸數值 (ex. 價格)

x2 為終點的 Bar Number

add 為非必要參數，預設為
0，執行後會先清除之前的趨勢線，若不希望清除的話則可以設為 1。

繪製zigzag指標

指標參數:

zz_deviation: 單位是%, 代表每一個波段的滿足幅度,
也就是當某個低點到某個高點的價差%大於這個數值時,
這個就視為一個完整的上漲/下跌波段

zz_depth: 多少根bar.
這個數值代表指標區間的高點/低點必須比他的左邊/右邊各zz_depth根bar都來的大/小,
才可以視為一個區間高點/低點

一個ZigZag指標, 就是連結區間高點/低點的波段,
且每一個波段的價差必須滿足指定的價差%

}

input: zz_deviation(10, \"每個波段的滿足幅度(%)\");

input: zz_depth(5, \"判斷頂點的左右bar間隔\");

// 底下pv_開頭的這幾個變數, 用來紀錄已經找到的波段

//

var: pv_count(0); // 目前總共找倒了幾個波段(pivot), 0表示還沒有找到

var: pv_start_index(0); // pivot的起點位置, 1-based的barIndex

var: pv_start_price(0); // pivot的起點價格

var: pv_end_index(0); // pivot的終點位置, 1-based的barIndex

var: pv_end_price(0); // pivot的終點價格

var: pv_is_high(false); // pivot的方向, true=上升, false=下降

array: maxmin\[2\](0); // 紀錄每根bar所找到的區間高點/低點的bar的位置,
maxmin\[1\]是高點, maxmin\[2\]是低點

var: pivot_updated(false); // 這次洗價是否異動了pivot (pv\_\...)

pivot_updated = false;

// 找最近一個區間高點/區間低點

//

maxmin\[1\] = SwingHighBar(High, zz_depth + 1, zz_depth, zz_depth, 1);

maxmin\[2\] = SwingLowBar(Low, zz_depth + 1, zz_depth, zz_depth, 1);

var: \_i(0);

var: p_index(0);

var: p_price(0);

var: is_high(false);

var: dev(0);

// 當遇到一個新的區間高點/低點時, 判斷這個點跟目前的波段(pivot)的關係,
更新pivot, 或是產生新的pivot

//

for \_i = 1 to 2 begin

if maxmin\[\_i\] \>= 0 then begin

if \_i = 1 then is_high = true else is_high = false;

if is_high then

p_price = High\[maxmin\[\_i\]\]

else

p_price = Low\[maxmin\[\_i\]\];

p_index = CurrentBar - maxmin\[\_i\]; // 轉換成1-based的barIndex

// Print(\"(FindPoint)\", NumToStr(Date\[maxmin\[\_i\]\], 0),
NumToStr(p_price, 2), is_high);

if pv_count = 0 then begin

// 目前還沒有pivot: 先產生一個只有一個點的pivot, 這是第一個pivot

//

pv_count = 1;

pv_start_index = p_index;

pv_start_price = p_price;

pv_end_index = p_index;

pv_end_price = p_price;

pv_is_high = is_high;

pivot_updated = true;

end else begin

if pv_is_high = is_high then begin

// 如果同方向, 而且新的點的價格比上一個pivot的價格更高/更低,
就更新pivot(延伸pivot的長度)

//

if (is_high and p_price \> pv_end_price) or (not is_high and p_price \<
pv_end_price) then begin

if pv_count = 1 then begin

// 如果是第一個pivot, 而且還只有一個點, 則讓start/end都挪到新的那個點

//

pv_start_index = p_index;

pv_start_price = p_price;

end;

pv_end_index = p_index;

pv_end_price = p_price;

pivot_updated = true;

end;

end else begin

// 如果反方向, 而且新的點產生了價格的轉折, 則產生一個新的pivot(波段)

//

dev = 100 \* (p_price - pv_end_price) / pv_end_price;

if (not pv_is_high and dev \>= zz_deviation) or (pv_is_high and dev \<=
-1 \* zz_deviation) then begin

// 產生新的pivot

//

pv_count = pv_count + 1;

pv_start_index = pv_end_index;

pv_start_price = pv_end_price;

pv_end_index = p_index;

pv_end_price = p_price;

pv_is_high = is_high;

pivot_updated = true;

end;

end;

if pivot_updated then begin

//Print(

// Text(\"PLOT(\", NumToStr(pv_count, 0), \")\"),

// \"from\", NumToStr(Date\[CurrentBar - pv_start_index\], 0),
NumToStr(pv_start_price, 2),

// \"to\", NumToStr(Date\[CurrentBar - pv_end_index\], 0),
NumToStr(pv_end_price, 2),

// pv_is_high

//);

// 畫出最新一段pivot

//

if pv_start_index \<\> pv_end_index then

PlotLine(1, pv_start_index, pv_start_price, pv_end_index, pv_end_price,
\"ZigZag\", add:=1);

// 只要有更新pivot, 就不再處理另一個方向的區間高點/低點

//

break;

end;

end;

end;

end;

#### 📄 一目均衡表

{@type:indicator}

input: ConvPeriod(9, \"轉換天數\");

input: BasePeriod(26, \"樞紐天數\");

input: LagPeriod(52, \"延遲天數\");

// 轉換線

Value1 = (Highest(High, ConvPeriod) + Lowest(Low, ConvPeriod)) / 2;

// 樞紐線

Value2 = (Highest(High, BasePeriod) + Lowest(Low, BasePeriod)) / 2;

// 先行帶 A

Value3 = (Value1 + Value2) / 2;

// 先行帶 B

Value4 = (Highest(High, LagPeriod) + Lowest(Low, LagPeriod)) / 2;

Plot(1, value1, \"轉換線\");

Plot(2, value2, \"樞紐線\");

Plot(3, Close, \"後行時間\", shift:=-BasePeriod);

Plot(4, Value3, \"先行時間(1)\", shift:=BasePeriod);

Plot(5, Value4, \"先行時間(2)\", shift:=BasePeriod);

if value3 \> value4 then begin

PlotFill(6, Value3, Value4, shift:=BasePeriod);

noplot(7);

end

else begin

plotfill(7, Value3, Value4, shift:=BasePeriod);

noplot(6);

end;

#### 📄 修正式移動平均線

{@type:indicator}

input:n(20,\"計算期數\");

variable: w(0);

if barfreq = \"Tick\" or barfreq = \"Min\" then

begin

value1=GetField(\"內盤量\");//單位:元

value2=GetField(\"外盤量\");//單位:元

end else begin

value1=GetField(\"內盤量\",\"D\");//單位:元

value2=GetField(\"外盤量\",\"D\");//單位:元

end;

//計算內外盤比

if value2\<\>0 then

value3=value1/value2\*100

else

value3=100;

if close\>close\[1\] then begin

if value3\>130 then

w=2.5

else if value3\>120 then

w=2.2

else if value3\>110 then

w=2.1

else if value3\>100 then

w=1.9

else

w=1.8;

end else if value3\<70 then

w=2.5

else if value3\<80 then

w=2.2

else if value3\<90 then

w=2.1

else if value3\<100 then

w=1.9

else

w=1.8;

value4=(w/(n+1))\*close+(n-1)/(n+1)\*value4\[1\];

value5=average(close,n);

plot2(value5,\"移動平均線\");

#### 📄 個股儀表板

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/打造個股儀表板/

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 330頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

if barfreq \<\> \"D\" then raiseruntimeerror(\"不支援此頻率\");

condition1=false;

condition2=false;

condition3=false;

condition4=false;

condition5=false;

condition6=false;

condition7=false;

condition8=false;

condition9=false;

condition10=false;

switch(close)

begin

case \>150: value5=low\*0.9;

case \<50 : value5=low\*0.98;

default: value5=low\*0.95;

end;

//==========日KD黃金交叉================

input: \_TEXT1(\"===============\",\"KD參數\");

input: Length_D(9,\"日KD期間\");

variable:rsv_d(0),kk_d(0),dd_d(0),c5(0);

stochastic(Length_D, 3, 3, rsv_d, kk_d, dd_d);

c5=barslast(kk_d crosses over dd_d);

if c5=0 and c5\[1\]\>20 then

condition1=true;

if condition1 then

plot1(value5,\"月KD高檔鈍化且日KD黃金交叉\");

//============內外盤量比差====================

variable:c3(0);

value6=GetField(\"內盤量\");//單位:元

value7=GetField(\"外盤量\");//單位:元

if volume\<\>0 then begin

value8=value7/volume\*100;//外盤量比

value9=value6/volume\*100;//內盤量比

end;

value10=average(value8,5);

value11=average(value9,5);

value7=value10-value11+5;

c3=barslast(value7 crosses over 0);

if c3=0 and c3\[1\]\>20 then

condition2=true;

if condition2 then

plot2(value5\*0.99,\"內外盤量比差\");

//===========淨力指標==============

input: \_TEXT2(\"===============\",\"淨力指標參數\");

input:period2(10,\"長期參數\");

variable:c4(0);

value12=summation(high-close,period2);//上檔賣壓

value13=summation(close-open,period2); //多空實績

value14=summation(close-low,period2);//下檔支撐

value15=summation(open-close\[1\],period2);//隔夜力道

if close\<\>0 then

value16=(value13+value14+value15-value12)/close\*100;

c4=barslast(value16 crosses over -4);

if c4=0 and c4\[1\]\>20 then

condition3=true;

if condition3 then

plot3(value5\*0.98,\"淨力指標\");

//===========多頭起漲前的籌碼收集================

variable:c2(0);

//狀況1.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量=0，則交易家數相關指標回傳0。

//狀況2.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量\<\>0，則交易家數相關指標正常運算。

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司買進家數\") and
GetField(\"成交量\") = 0 then value1=GetField(\"分公司買進家數\");

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司賣出家數\") and
GetField(\"成交量\") = 0 then value2=GetField(\"分公司賣出家數\");

value3=value2-value1;

value4=countif(value3\>20,10);

c2=barslast(value4\>6);

if c2=0 and c2\[1\]\>20 then

condition4=true;

if condition4=true then

plot4(value5\*0.97,\"籌碼收集\");

//===========法人同步買超====================

variable: v1(0),v2(0),v3(0),c1(0);

v1=GetField(\"外資買賣超\");

v2=GetField(\"投信買賣超\");

v3=GetField(\"自營商買賣超\");

c1= barslast(maxlist2(v1,v2,v3)\>100);

if c1=0 and c1\[1\]\>20 then

condition5=true;

if condition5=true then

plot5(value5\*0.96,\"法人同步買超\");

//========DIF-MACD 翻正=============

input: \_TEXT3(\"===============\",\"MACD參數\");

input: FastLength(12,\"DIF短天數\"), SlowLength(26, \"DIF長天數\"),
MACDLength(9, \"MACD天數\");

variable: difValue(0), macdValue(0), oscValue(0);

MACD(weightedclose(), FastLength, SlowLength,MACDLength, difValue,
macdValue, oscValue);

variable:c6(0);

c6=barslast(oscValue Crosses Above 0);

if c6=0 and c6\[1\]\>20 then

condition6=true;

if condition6 then

plot6(value5\*0.95,\"DIF-MACD 翻正\");

//========資金流向======================

variable: m1(0),ma1(0),c7(0);

m1=GetField(\"資金流向\");

ma1=average(m1,20)\*1.5;

c7=barslast(m1 crosses over ma1 and close\>close\[1\]);

if c7=0 and c7\[1\]\>20 then

condition7=true;

if condition7 then

plot7(value5\*0.94,\"資金流向\");

//=========總成交次數================

variable: t1(0),mat1(0),c8(0);

t1=GetField(\"總成交次數\",\"D\");

mat1=average(t1,20)\*1.5;

c8=barslast(t1 crosses over mat1 and close\>close\[1\]);

if c8=0 and c8\[1\]\>20 then

condition8=true;

if condition8 then

plot8(value5\*0.93,\"成交次數\");

//=========強弱指標==================

variable:s1(0),c9(0);

s1=GetField(\"強弱指標\",\"D\");

c9=barslast(trueall(s1\>0,3));

if c9=0 and c9\[1\]\>20 then

condition9=true;

if condition9 then

plot9(value5\*0.92,\"強弱指標\");

//============開盤委買================

variable:b1(0),mab1(0),c10(0);

b1=GetField(\"主力買張\");

mab1=average(b1,10);

c10=barslast(b1 crosses over mab1);

if c10=0 and c10\[1\]\>10 then

condition10=true;

if condition10 then

plot10(value5\*0.91,\"主力買張\");

#### 📄 內盤成本線

{@type:indicator}

{內盤成本線 = 累計當日賣出金額(元) / 累計當日賣出量\*1000,
就是特大+大+中+小, 不分大小單

支援商品：台股}

value91 = GetField(\"買進特大單金額\");

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" then

raiseruntimeerror(\"僅支援分鐘與日頻率\");

value1 = GetField(\"賣出特大單金額\",\"D\") +
GetField(\"賣出大單金額\",\"D\") + GetField(\"賣出中單金額\",\"D\") +
GetField(\"賣出小單金額\",\"D\");

value2 = GetField(\"賣出特大單量\",\"D\") +
GetField(\"賣出大單量\",\"D\") + GetField(\"賣出中單量\",\"D\") +
GetField(\"賣出小單量\",\"D\");

if value2 \<\> 0 then

value3 = value1 / (value2 \* 1000)

else

value3 = value3\[1\];

plot1(value3,\"內盤成本線\");

#### 📄 唐奇安通道

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/唐奇安通道/

}

input:Period(13,\"天數\");

value1 = Highest(H, period);

value2 = Lowest(L, period);

plot1(value1\[1\],\"通道上緣\");

plot2((value1+value2)/2,\"通道中線\");

plot3(value2\[1\],\"通道下緣\" );

#### 📄 外盤成本線

{@type:indicator}

{外盤成本線 = 累計當日買進金額(元) / 累計當日買進量\*1000,
就是特大+大+中+小, 不分大小單

支援商品：台股}

value91 = GetField(\"買進特大單金額\");

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" then

raiseruntimeerror(\"僅支援分鐘與日頻率\");

value1 = GetField(\"買進特大單金額\",\"D\") +
GetField(\"買進大單金額\",\"D\") + GetField(\"買進中單金額\",\"D\") +
GetField(\"買進小單金額\",\"D\");

value2 = GetField(\"買進特大單量\",\"D\") +
GetField(\"買進大單量\",\"D\") + GetField(\"買進中單量\",\"D\") +
GetField(\"買進小單量\",\"D\");

if value2 \<\> 0 then

value3 = value1 / (value2 \* 1000)

else

value3 = value3\[1\];

plot1(value3,\"外盤成本線\");

#### 📄 外資均價線

{@type:indicator}

Input: period(20); setinputname(1, \"期間(天)\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: avg_b(0), avg_s(0);

if GetField(\"Volume\") \> 0 then

begin

Value5 =
GetField(\"外資買張\")\*GetField(\"成交金額\")/(GetField(\"Volume\")\*1000);

Value6 =
GetField(\"外資賣張\")\*GetField(\"成交金額\")/(GetField(\"Volume\")\*1000);

end else begin

Value5 = 0;

Value6 = 0;

end;

Value1 = summation(Value5, period);

Value2 = summation(GetField(\"外資買張\"), period);

Value3 = summation(Value6, period);

Value4 = summation(GetField(\"外資賣張\"), period);

if Value2 \> 0 and Value2 \<\> Value2\[1\] then avg_b = Value1 / Value2;

if Value4 \> 0 and Value4 \<\> Value4\[1\] then avg_s = Value3 / Value4;

Plot1(avg_b, \"外資買進均價\");

Plot2(avg_s, \"外資賣出均價\");

#### 📄 大戶成本線

{@type:indicator}

{大戶成本線有兩個線圖, 可以分開勾選,

一個是買進成本線, 計算方式都是累計當日大單+特大單的買進金額/買進量

一個是賣出成本線, 計算方式都是累計當日大單+特大單的賣出金額/買進量

支援商品：台股}

value91 = GetField(\"買進特大單金額\");

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" then

raiseruntimeerror(\"僅支援分鐘與日頻率\");

//買進成本

value1 = GetField(\"買進特大單金額\",\"D\") +
GetField(\"買進大單金額\",\"D\");

value2 = GetField(\"買進特大單量\",\"D\") +
GetField(\"買進大單量\",\"D\");

if value2 \<\> 0 then

value3 = value1 / (value2\*1000)

else

value3 = value3\[1\];

//賣出成本

value11 = GetField(\"賣出特大單金額\",\"D\") +
GetField(\"賣出大單金額\",\"D\");

value21 = GetField(\"賣出特大單量\",\"D\") +
GetField(\"賣出大單量\",\"D\");

if value21 \<\> 0 then

value31 = value11 / (value21\*1000)

else

value31 = value31\[1\];

plot1(value3,\"大戶買進成本線\",checkbox:=1);

plot2(value31,\"大戶賣出成本線\",checkbox:=1);

#### 📄 寶塔線

{@type:indicator}

input: \_len(3, \"天數\"), \_reversal(1, \"趨勢反轉判斷\",
inputkind:=Dict(\[\"依據K線圖高/低點\",1\],\[\"依據寶塔線高低/點\",2\]));

var: \_name(\"\");

SetBackBar(\_len);

if \_reversal = 1 then begin

value1 = highest(high\[1\], \_len);

value2 = lowest(low\[1\], \_len);

end

else if \_reversal = 2 then begin

value1 = highest(value3\[1\], \_len);

value2 = lowest(value4\[1\], \_len);

end;

value3 = maxlist(close, close\[1\]);

value4 = minlist(close, close\[1\]);

if close cross over value1 then begin

condition1 = True;

condition2 = False;

end

else if close cross under value2 then begin

condition1 = False;

condition2 = True;

end;

if currentbar \> \_len then begin

if not condition1\[1\] and condition1 then

\_name = \"翻紅\"

else if condition1 then

\_name = \"續紅\"

else if not condition2\[1\] and condition2 then

\_name = \"翻黑\"

else if condition2 then

\_name = \"續黑\";

if condition1 then

plotk(1, value4, value3, value4, value3)

else if condition2 then

plotk(1, value3, value3, value4, value4);

end;

setplotLabel(1, text(\_name));

#### 📄 平均K線

{@type:indicator}

var: ha_open(0), ha_high(0), ha_low(0), ha_close(0);

if currentbar = 1 then

ha_open = (open + close) / 2

else

ha_open = (ha_open\[1\] + ha_close\[1\]) / 2;

ha_close = (open + high + low + close) / 4;

ha_high = maxlist(high, ha_open, ha_close);

ha_low = minlist(low, ha_open, ha_close);

PlotK(1, ha_open, ha_high, ha_low, ha_close, \"平均K線\");

#### 📄 平均波幅通道

{@type:indicator}

input : length(5); setinputname(1, \"天期\");

input : atrlength(15); setinputname(2, \"ATR天期\");

input : k(1.35); setinputname(3, \"通道常數\");

variable : hband(0),lband(0);

hband = average(close,length)+average(truerange,atrlength)\*k;

lband = average(close,length)-average(truerange,atrlength)\*k;

plot1(hband, \"通道上限\");

plot2(lband, \"通道下限\");

#### 📄 投信均價線

{@type:indicator}

Input: period(20); setinputname(1, \"期間(天)\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: avg_b(0), avg_s(0);

if GetField(\"Volume\") \> 0 then

begin

Value5 =
GetField(\"投信買張\")\*GetField(\"成交金額\")/(GetField(\"Volume\")\*1000);

Value6 =
GetField(\"投信賣張\")\*GetField(\"成交金額\")/(GetField(\"Volume\")\*1000);

end else begin

Value5 = 0;

Value6 = 0;

end;

Value1 = summation(Value5, period);

Value2 = summation(GetField(\"投信買張\"), period);

Value3 = summation(Value6, period);

Value4 = summation(GetField(\"投信賣張\"), period);

if Value2 \> 0 and Value2 \<\> Value2\[1\] then avg_b = Value1 / Value2;

if Value4 \> 0 and Value4 \<\> Value4\[1\] then avg_s = Value3 / Value4;

Plot1(avg_b, \"投信買進均價\");

Plot2(avg_s, \"投信賣出均價\");

#### 📄 投資建議目標價

{@type:indicator}

//支援頻率：不定期

//支援商品 ：美(股票)

var:exchange(\"\");

exchange = GetSymbolInfo(\"交易所\");

if exchange \<\> \"NYSE\" and exchange \<\> \"NASDAQ\" and exchange \<\>
\"AMEX\" then raiseruntimeerror(\"僅支援美股\");

plot1(getField(\"投資建議目標價\"),\"目標價\");

#### 📄 散戶成本線

{@type:indicator}

{散戶成本線內有兩個線圖, 可以分開勾選,

一個是散戶買進成本線, 計算方式都是累計當日小單的買進金額/買進量

一個是散戶賣出成本線, 計算方式都是累計當日小單的賣出金額/買進量

支援商品：台股}

value91 = GetField(\"買進小單金額\");

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" then

raiseruntimeerror(\"僅支援分鐘與日頻率\");

//買進成本

value1 = GetField(\"買進小單金額\",\"D\");

value2 = GetField(\"買進小單量\",\"D\");

if value2 \<\> 0 then

value3 = value1 / (value2\*1000)

else

value3 = value3\[1\];

//賣出成本

value11 = GetField(\"賣出小單金額\",\"D\");

value21 = GetField(\"賣出小單量\",\"D\");

if value21 \<\> 0 then

value31 = value11 / (value21\*1000)

else

value31 = value31\[1\];

plot1(value3,\"散戶買進成本線\",checkbox:=1);

plot2(value31,\"散戶賣出成本線\",checkbox:=1);

#### 📄 樂活五線譜

{@type:indicator}

input:period(720,\"計算期間\");

array: line_diff\[\](0);

var: diff_avg(0), \_sum(0);

Array_SetMaxIndex(line_diff, period);

linearreg(close,period,0,value2,value3,value4,value5);

{計算(收盤-迴歸)標準差}

//先計算區間內的 收盤 - 迴歸 值

\_sum = 0;

for value1 = 1 to period begin

line_diff\[value1\] = close\[period - value1\] - (value2 \* value1 +
value4);

\_sum += close\[period - value1\] - (value2 \* value1 + value4);

end;

// 收盤-迴歸的平均

diff_avg = \_sum / period;

//計算標準差

\_sum = 0;

for value1 = 1 to period begin

\_sum += power((line_diff\[value1\] - diff_avg), 2);

end;

value6 = squareroot(\_sum / period);

value7=value5+value6;

value8=value5+2\*value6;

value9=value5-value6;

value10=value5-2\*value6;

plot1(value8,\"+2SD\");

plot2(value7,\"+1SD\");

plot3(value5,\"TL\");

plot4(value9,\"-1SD\");

plot5(value10,\"-2SD\");

#### 📄 樂活五線譜_趨勢線

{@type:indicator}

{

PlotLine(PlotIndex, x1, y1, x2, y2, add:=0);

PlotIndex為 1 \~ 999，作用如同 Plot 的序列編號

x1 為起點的 Bar Number (可用 CurrentBar 確認)

y1 為起點的 Y 軸數值 (ex. 價格)

x2 為終點的 Bar Number

add 為非必要參數，預設為
0，執行後會先清除之前的趨勢線，若不希望清除的話則可以設為 1。

樂活五線譜是由「股息現金流被動收入理財的心路歷程」已故的版主 Allan
Lin（艾倫）醫師改良曾淵滄博士的曾氏通道，

以原始價格取代對數值，同樣以 5 條平衡線作參考，分別為極度樂觀線（95%
樂觀線），過度樂觀線（75% 樂觀線），

中線（長期走勢線），過度悲觀線（75% 悲觀線）和極度悲觀線（95% 悲觀線）。

樂活五線譜的形成，是以統計學的方法來計算一段時間（預設為 3.5
年）的平均價格，並畫出一條股價趨勢線，

然從趨勢線的上方和下方各加上一個標準差以及兩個標準差而形成的五條線。

在這個腳本範例內，使用者可以指定統計天期（從最新一期往回統計N筆K線資料)，之後會畫出從統計起點到最新一根K線

所算出來的5條樂活通道線，分別是：

TL = 從統計起點到最新一根K線的線性回歸線(以每根K棒的Close價格統計)

SDP1 = 往上一個標準差

SDP2 = 往上兩個標準差

SDM1 = 往下一個標準差

SDM2 = 往下兩個標準差

}

input: length(100, \"天期\");

var: lr_slope(0), lr_deg(0), lr_intercept(0), lr_forecast(0);

var: idx(0), std(0), diff_avg(0), last_y(0);

array: diff_array\[\](0);

if CurrentBar = GetTotalBar() and CurrentBar \>= length then begin

LinearReg(Close, length, length, lr_slope, lr_deg, lr_intercept,
lr_forecast);

// 統計每個收盤價到回歸線的距離並計算平均值

//

Array_SetMaxIndex(diff_array, length);

diff_avg = 0;

for idx = 1 to length begin

diff_array\[idx\] = Close\[length - idx\] - (lr_intercept + lr_slope \*
idx);

diff_avg = diff_avg + diff_array\[idx\];

end;

diff_avg = diff_avg / length;

// 計算回歸線與收盤價差距的標準差

//

Value1 = 1;

for idx = 1 to length begin

Value1 += power((diff_array\[idx\] - diff_avg), 2);

end;

std = SquareRoot(Value1 / length);

// 每次價格更新時會重畫, 產生新的bar時也會重畫

//

last_y = Close - diff_array\[length\];

PlotLine(1,

CurrentBar-length, lr_forecast,

CurrentBar, last_y, \"TL\");

PlotLine(2,

CurrentBar-length, lr_forecast+std,

CurrentBar, last_y+std, \"SDP1\");

PlotLine(3,

CurrentBar-length, lr_forecast+2\*std,

CurrentBar, last_y+2\*std, \"SDP2\");

PlotLine(4,

CurrentBar-length, lr_forecast-std,

CurrentBar, last_y-std, \"SDM1\");

PlotLine(5,

CurrentBar-length, lr_forecast-2\*std,

CurrentBar, last_y-2\*std, \"SDM2\");

end;

#### 📄 權益線分析

{@type:indicator}

input:Update(-1);

variable:hHigh(0),pC(0),iHigh(0),iLow(10000),iDate(0),ALow(0),ND(0),EP(0);

array:peak\[300,5\](0);

if currentbar = 1 then begin

iHigh =high;

iDate =Date;

value1=open;

end;

hHigh = maxlist(high,hHigh);

if hHigh \> iHigh then begin

if iHigh \<\> iLow then begin

peak\[pc,0\] = date;

peak\[pc,1\] = iHigh;

peak\[pc,2\] = iLow;

peak\[pc,3\] = (iHigh- iLow)/iHigh\*100;

peak\[pc,4\] = datediff(date,iDate);

if pc \> 0 and peak\[pc-1,2\] \<\> 0 then peak\[pc,5\] = (iHigh/
peak\[pc-1,2\]-1)\*100;

pc+=1;

end;

iHigh =hHigh;

iLOw = hHigh;

iDate =Date;

end else

iLow =minlist(Low,iLow);

if DateDiff(currentdate,date) \> update and value1 \> 0 and pc \> 1 then
begin

variable: summ(0),avg(0);

summ=0;

for value2 = 1 to pc -1

summ += peak\[value2,3\];

avg=summ/(pc-1);

variable: summeans(0);

summeans=0;

for value2 = 1 to pc -1 begin

summeans += square(peak\[value2,3\]-avg);

end;

variable:stdev(0);

if pc-1 \> 0 then

stdev = squareroot( summeans/(pc-1))

else

stdev=0;

variable:msg(\"Hold\"),poLow(0);

poLow = iHigh\*(1- (avg+stdev)/100);

if Close \< PoLow then msg =\"Sell\";

end;

if date \<\>currentdate then ALow =Polow;

if C \> alow and ALow \> 0 then plot1(Alow,\"95%CF\");
//95%信心水準回檔最大值

if C \> iHigh\*0.86 then begin

plot3(iHigh\*0.92,\"N1D\"); //第1減碼線

plot4(iHigh\*0.86,\"N2D\"); //第2減碼線

end;

plot5(Close,\"現價\");

plot6(V,\"成交量\");

ND=100\*(average(H/L-1,20)+standarddev(H/L-1,20,1)\*3);

if ND \< 3 and trueall(ND\[1\]\> 3,5) then EP=h;

if ND \< 5 and trueall(ND\[1\]\> 5,5) then EP=h;

if c \> EP and c\[1\] \< EP then plot8(v,\"作多點量\");

if EP \> 0 then plot9(EP,\"關鍵價\");

#### 📄 當日成本線

{@type:indicator}

{均線 = 當日所有成交Tick的平均價格(sum(pv)/sum(v)), 也就是當日的成本

支援商品：台股/期貨/選擇權/陸股/港股/美股/大盤/類股}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" then

raiseruntimeerror(\"僅支援分鐘與日頻率\");

plot1(GetField(\"均價\"),\"均價\");

#### 📄 肯特納通道

{@type:indicator}

Input: Length(20); setinputname(1, \"天期\");

Input: UpperBand(2); SetInputName(2, \"上通道寬度\");

Input: LowerBand(2); SetInputName(3, \"下通道寬度\");

variable : hband(0),lband(0),midline(0);

midline = XAverage(close, Length);

hband = midline + ATR(Length) \* UpperBand;

lband = midline - ATR(Length) \* LowerBand;

Plot1(hband, \"UB\");

Plot2(midline, \"KeltnerMA\");

Plot3(lband, \"LB\");

#### 📄 自營商均價線

{@type:indicator}

Input: period(20); setinputname(1, \"期間(天)\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: avg_b(0), avg_s(0);

if GetField(\"Volume\") \> 0 then

begin

Value5 =
GetField(\"自營商買張\")\*GetField(\"成交金額\")/(GetField(\"Volume\")\*1000);

Value6 =
GetField(\"自營商賣張\")\*GetField(\"成交金額\")/(GetField(\"Volume\")\*1000);

end else begin

Value5 = 0;

Value6 = 0;

end;

Value1 = summation(Value5, period);

Value2 = summation(GetField(\"自營商買張\"), period);

Value3 = summation(Value6, period);

Value4 = summation(GetField(\"自營商賣張\"), period);

if Value2 \> 0 and Value2 \<\> Value2\[1\] then avg_b = Value1 / Value2;

if Value4 \> 0 and Value4 \<\> Value4\[1\] then avg_s = Value3 / Value4;

Plot1(avg_b, \"自營商買進均價\");

Plot2(avg_s, \"自營商賣出均價\");

#### 📄 處置期間

{@type:indicator}

if BarFreq \<\> \"d\" and BarFreq \<\> \"ad\" then
raiseruntimeerror(\"僅支援日與還原日頻率\");

value1 = GetField(\"處置開始日期\");

value2 = GetField(\"處置結束日期\");

value3 = getField(\"Date\");

if value1 = 0 then raiseruntimeerror(\"無處置的歷史紀錄\");

//用點顯示處置區間

if value3 \>= value1 and value3 \<= value2 then plot1(value1,\"處置中\")
//尚在處置中

else noplot(1);

//用來顯示處置相關的日期數值

if value1 \<\> value1\[1\] or (value3 \>= value1 and value3 \<= value2)
then begin

plot3(value1,\"開始日期\");

plot4(value2,\"結束日期\");

end else begin

noplot(3);

noplot(4);

end;

#### 📄 融券均價線

{@type:indicator}

Input: period(20); setinputname(1, \"期間(天)\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: avg(0);

if GetField(\"Volume\") \> 0 then

Value3 =
GetField(\"融券賣出張數\")\*GetField(\"成交金額\")/(GetField(\"Volume\")\*1000)

else

Value3 = 0;

Value1 = summation(Value3, period);

Value2 = summation(GetField(\"融券賣出張數\"), period);

if Value2 \> 0 and Value2 \<\> Value2\[1\] then avg = Value1 / Value2;

Plot1(avg, \"融券賣出均價\");

#### 📄 融資均價線

{@type:indicator}

Input: period(20); setinputname(1, \"期間(天)\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: avg(0);

if GetField(\"Volume\") \> 0 then

Value3 =
GetField(\"融資買進張數\")\*GetField(\"成交金額\")/(GetField(\"Volume\")\*1000)

else

Value3 = 0;

Value1 = summation(Value3, period);

Value2 = summation(GetField(\"融資買進張數\"), period);

if Value2 \> 0 and Value2 \<\> Value2\[1\] then avg = Value1 / Value2;

Plot1(avg, \"融資買進均價\");

#### 📄 趨勢線

{@type:indicator}

input: periods(30, \"期間\");

input: startyear(2017, \"起始年份\");

variable: maxh_bar(0), idx(0), line_a(0), line_b(0), x_bar(0), idx2(0),
temp_y(0), base_bar(0);

// 起始年之前的資料不計算

if year(date) \< startyear then return;

// 如果已經有趨勢線的話, 檢查是否突破

if base_bar \> 0 then begin

temp_y = line_a \* (currentbar - base_bar) + line_b;

if high \> temp_y then

plot1(high)

else

noplot(1);

end;

// 計算過去N期的趨勢線

maxh_bar = nthhighestbar(1, high, periods);

base_bar = 0; // 用來追蹤最近一個趨勢線的x=0的位置

idx = maxh_bar-1;

while idx \>= 0 begin

// 畫一條曲線從maxh_bar to idx, 假設maxh_bar的位置x=0

//

// x0 = 0, y0 = high\[maxh_bar\] == b

// x1 = maxh_bar - idx, y1 = high\[idx\]

//

line_b = high\[maxh_bar\];

line_a = (high\[idx\] - line_b) / (maxh_bar - idx);

x_bar = idx;

// 檢查是否所有的點都落在這條切線底下

//

condition1 = false;

for idx2 = maxh_bar - 1 downto 0 begin

// x = maxh_bar - idx2

//

temp_y = line_a \* (maxh_bar - idx2) + line_b;

if high\[idx2\] \> temp_y then begin

condition1 = true;

break;

end;

end;

if not condition1 then begin

base_bar = currentbar - maxh_bar;

break;

end;

idx = idx - 1;

end;

#### 📄 開盤第N根的每日高低價線

{@type:indicator}

Input:Length(1,\"第N根K棒\");

Var:\_MH(0), \_ML(0), \_HHMMSS(0), \_ChageDNum(0), \_MaxCDN(0);

if barfreq \<\> \"Min\" then raiseRunTimeError(\"僅支援分鐘頻率\");

if Length = 0 then raiseRunTimeError(\"參數請設定大於0的合理數值\");

if gettotalBar = currentBar and Length - 1 \> \_MaxCDN then
raiseRunTimeError(\"參數設定超過每日分鐘K棒數\");

if getfieldDate(\"date\") \<\> getfieldDate(\"date\")\[1\] then

\_ChageDNum = 0

else begin

\_ChageDNum += 1;

end;

if \_ChageDNum \> \_MaxCDN then \_MaxCDN = \_ChageDNum;

if \_ChageDNum \< Length - 1 then begin

NoPlot(1);

NoPlot(2);

NoPlot(3);

end else if \_ChageDNum = Length - 1 then begin

\_MH = GetField(\"最高價\", \"D\");

\_ML = GetField(\"最低價\", \"D\");

\_HHMMSS = time;

plot1(\_HHMMSS,\"時間\");

plot2(\_MH,\"最高價\");

plot3(\_ML,\"最低價\");

end else begin

plot1(\_HHMMSS,\"時間\");

plot2(\_MH,\"最高價\");

plot3(\_ML,\"最低價\");

end;

setplotLabel(1,Text(\"第\",NumToStr(Length, 0),\"根時間\"));

### 2.4 即時籌碼 (17 個)

#### 📄 分時大戶買賣力(金額)

{@type:indicator}

{指標數值定義：\"大戶單=特大單+大單資料為分鐘統計金額\"

支援商品：台(股票)}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value91 = GetField(\"賣出特大單金額\");

value1 = GetField(\"賣出特大單金額\") + GetField(\"賣出大單金額\");

value2 = GetField(\"買進特大單金額\") + GetField(\"買進大單金額\");

value3 = value2 - value1;

plot1(value3,\"大戶買賣力(金額)\");

plot2(value2,\"大戶外盤量(金額)\",checkbox:=0);

plot3(value1,\"大戶內盤量(金額)\",checkbox:=0);

#### 📄 分時大戶買賣力

{@type:indicator}

{指標數值定義：\"大戶單=特大單+大單資料為分鐘統計張數\"

支援商品：台(股票)}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value1 = GetField(\"賣出特大單量\") + GetField(\"賣出大單量\");

value2 = GetField(\"買進特大單量\") + GetField(\"買進大單量\");

value3 = value2 - value1;

plot1(value3,\"大戶買賣力\");

plot2(value2,\"大戶外盤量\",checkbox:=0);

plot3(value1,\"大戶內盤量\",checkbox:=0);

#### 📄 分時散戶買賣力(金額)

{@type:indicator}

{指標數值定義：\"散戶單=小單資料為分鐘統計金額\"

支援商品：台(股票)}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value91 = GetField(\"賣出小單金額\");

value1 = GetField(\"賣出小單金額\");

value2 = GetField(\"買進小單金額\");

value3 = value2 - value1;

plot1(value3,\"散戶買賣力(金額)\");

plot2(value2,\"散戶外盤量(金額)\",checkbox:=0);

plot3(value1,\"散戶內盤量(金額)\",checkbox:=0);

#### 📄 分時散戶買賣力

{@type:indicator}

{指標數值定義：\"散戶單=小單資料為分鐘統計張數\"

支援商品：台(股票)}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value91 = GetField(\"賣出小單量\");

value1 = GetField(\"賣出小單量\");

value2 = GetField(\"買進小單量\");

value3 = value2 - value1;

plot1(value3,\"散戶買賣力\");

plot2(value2,\"散戶外盤量\",checkbox:=0);

plot3(value1,\"散戶內盤量\",checkbox:=0);

#### 📄 分時漲跌成交量

{@type:indicator}

{支援商品類型：台股/期權/選擇權/大盤/類股指數}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value1 = GetField(\"上漲量\");

value2 = GetField(\"下跌量\");

value3 = value1 - value2;

plot1(value3,\"漲跌成交(分時)\");

plot2(value1,\"上漲量\",checkbox:=0);

plot3(value2,\"下跌量\",checkbox:=0);

#### 📄 分時買賣力

{@type:indicator}

{支援商品：指數/台股/期貨/選擇權}

if symbolexchange \<\> \"TW\" and symbolexchange \<\> \"TF\" then
raiseruntimeerror(\"不支援此商品\");

if SymbolType \<\> 1 and SymbolType \<\> 2 and SymbolType \<\> 3 and
SymbolType \<\> 5 then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value1 = GetField(\"外盤量\");

value2 = GetField(\"內盤量\");

value3 = value1 - value2;

plot1(value3,\"買賣力\");

plot2(value1,\"外盤量\",checkbox:=0);

plot3(value2,\"內盤量\",checkbox:=0);

#### 📄 大戶散戶籌碼流向(金額)

{@type:indicator}

{指標數值定義：\"大戶=特大單+大單, 散戶=小單

資料為大戶/散戶從開盤累計到現在的(外盤-內盤)金額\"

支援商品：台(股票)}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value91 = GetField(\"賣出特大單金額\");

value1 = GetField(\"賣出特大單金額\",\"D\") +
GetField(\"賣出大單金額\",\"D\");

value2 = GetField(\"買進特大單金額\",\"D\") +
GetField(\"買進大單金額\",\"D\");

value3 = value2 - value1;

value11 = GetField(\"賣出小單金額\",\"D\");

value21 = GetField(\"買進小單金額\",\"D\");

value31 = value21 - value11;

plot1(value3,\"大戶買賣力(金額)\");

plot2(value31,\"散戶買賣力(金額)\");

#### 📄 大戶散戶籌碼流向

{@type:indicator}

{指標數值定義：\"大戶=特大單+大單, 散戶=小單

資料為大戶/散戶從開盤累計到現在的(外盤-內盤)張數\"

支援商品：台(股票)}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value91 = GetField(\"賣出特大單量\");

value1 = GetField(\"賣出特大單量\",\"D\") +
GetField(\"賣出大單量\",\"D\");

value2 = GetField(\"買進特大單量\",\"D\") +
GetField(\"買進大單量\",\"D\");

value3 = value2 - value1;

value11 = GetField(\"賣出小單量\",\"D\");

value21 = GetField(\"買進小單量\",\"D\");

value31 = value21 - value11;

plot1(value3,\"大戶買賣力\");

plot2(value31,\"散戶買賣力\");

#### 📄 大戶買賣力(金額)

{@type:indicator}

{大戶買賣力(金額)是特大單金額+大單金額，資料為開盤迄今的累計

支援商品：台(股票)}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value91 = GetField(\"賣出特大單金額\");

value1 = GetField(\"賣出特大單金額\",\"D\") +
GetField(\"賣出大單金額\",\"D\");

value2 = GetField(\"買進特大單金額\",\"D\") +
GetField(\"買進大單金額\",\"D\");

value3 = value2 - value1;

plot1(value3,\"大戶買賣力(金額)\");

plot2(value2,\"大戶外盤金額\",checkbox:=0);

plot3(value1,\"大戶內盤金額\",checkbox:=0);

#### 📄 大戶買賣力

{@type:indicator}

{\"大戶=特大單+大單，資料為開盤迄今的累計張數\"

支援商品：台(股票)}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value91 = GetField(\"賣出特大單量\");

value1 = GetField(\"賣出特大單量\",\"D\") +
GetField(\"賣出大單量\",\"D\");

value2 = GetField(\"買進特大單量\",\"D\") +
GetField(\"買進大單量\",\"D\");

value3 = value2 - value1;

plot1(value3,\"大戶買賣力\");

plot2(value2,\"大戶外盤量\",checkbox:=0);

plot3(value1,\"大戶內盤量\",checkbox:=0);

#### 📄 散戶買賣力(金額)

{@type:indicator}

{散戶買賣力(金額)是小單金額，資料為開盤迄今的累計

支援商品：台(股票)}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value91 = GetField(\"賣出小單金額\");

value1 = GetField(\"賣出小單金額\",\"D\");

value2 = GetField(\"買進小單金額\",\"D\");

value3 = value2 - value1;

plot1(value3,\"散戶買賣力(金額)\"); //bar，axis2

plot2(value2,\"散戶外盤金額\",checkbox:=0); //line，axis11

plot3(value1,\"散戶內盤金額\",checkbox:=0); //line，axis11

#### 📄 散戶買賣力

{@type:indicator}

{指標數值定義：\"散戶單=小單資料為開盤迄今的累計張數\"

支援商品：台(股票)}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value91 = GetField(\"賣出小單量\");

value1 = GetField(\"賣出小單量\",\"D\");

value2 = GetField(\"買進小單量\",\"D\");

value3 = value2 - value1;

plot1(value3,\"散戶買賣力\"); //bar，axis2

plot2(value2,\"散戶外盤量\",checkbox:=0); //line，axis11

plot3(value1,\"散戶內盤量\",checkbox:=0); //line，axis11

#### 📄 流動大戶買賣力

{@type:indicator}

{近15分鐘累計的(買進大單量+買進特大單量)-(賣出大單量+賣出特大單量)

抓近15分鐘的目的是希望可以看到最近的買賣力。}

array:\_ArrayLarge\[15\](0),\_ArraySmall\[15\](0);

var:\_Count(0);

if barfreq \<\> \"Min\" or barinterval \<\> 1 then

raiseruntimeerror(\"僅支援 1 分鐘頻率\");

//初始化

if getfieldDate(\"Date\") \<\> getfieldDate(\"Date\")\[1\] then begin

\_Count = 0;

Array_SetValRange(\_ArrayLarge, 1, 15, 0);

Array_SetValRange(\_ArraySmall, 1, 15, 0);

value3 = 0;

value99 = 0;

end else begin

\_Count += 1;

end;

value99 = mod(\_count,15) + 1;

\_ArrayLarge\[value99\] = GetField(\"買進大單量\", \"1\") +
GetField(\"買進特大單量\", \"1\");

\_ArraySmall\[value99\] = GetField(\"賣出大單量\", \"1\") +
GetField(\"賣出特大單量\", \"1\");

value1 = Array_Sum(\_ArrayLarge, 1, 15);

value2 = Array_Sum(\_ArraySmall, 1, 15);

value3 = value1 - value2;

plot1(value3,\"流動大戶買賣力\");

#### 📄 漲跌成交量

{@type:indicator}

{指標數值定義：(上漲)量 = 開盤累計到目前比前一價(上漲)的成交量的加總

支援商品：台股,大盤,類股,期貨,選擇權}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" and barfreq \<\> \"AD\"
then

raiseruntimeerror(\"僅支援分鐘與日頻率（含還原）\");

value91 = GetField(\"上漲量\");

value1 = GetField(\"上漲量\",\"D\");

value2 = GetField(\"下跌量\",\"D\");

value3 = value1 - value2;

plot1(value3,\"漲跌成交\");

plot2(value1,\"上漲量\",checkbox:=0);

plot3(value2,\"下跌量\",checkbox:=0);

#### 📄 自訂大戶買賣力

{@type:indicator}

{指標數值定義：主力 = 成交單量 \>= X的委託由Tick資料去累積計算

支援商品：台(股票)、台(期貨)}

value91 = GetField(\"上漲量\");

if symbolexchange \<\> \"TW\" and symbolexchange \<\> \"TF\" then
raiseruntimeerror(\"不支援此商品\");

if SymbolType \<\> 2 and SymbolType \<\> 3 then
raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"Min\" then

raiseruntimeerror(\"僅支援分鐘頻率\");

{

顯示開盤迄今的累計外盤大單 - 累計內盤大單, 也就是盤中大戶的買賣力趨勢

大單定義: 成交單量 \> X

}

input: threshold(100, \"大單門檻(張or口)\");

var: intrabarpersist \_v_buy_acc(0), intrabarpersist \_v_sell_acc(0);

var: intrabarpersist \_last_seq(0);

var: \_cur_seq(0), \_i(0), \_curbar_date(0);

var: \_last_date(0);

if getfielddate(\"date\") \<\> \_last_date then begin

\_last_date = getfielddate(\"date\");

\_v_buy_acc = 0;

\_v_sell_acc = 0;

\_last_seq = 0;

end;

// 抓洗價當時最新一筆Tick的位置跟日期

//

\_cur_seq = GetField(\"SeqNo\", \"Tick\");

\_curbar_date = GetField(\"Date\", \"Tick\");

if symbolexchange = \"TW\" and SymbolType = 2 then begin //台(股票)

if \_curbar_date \<\> date then begin

// 如果開盤到有某些分鐘沒有成交, 此時會對到昨日之前的Tick =\>
這些分鐘不要計算

//

\_cur_seq = 0;

end else if \_cur_seq \> 0 and \_cur_seq \> \_last_seq then begin

// \_last_seq是上一次畫圖時最後一筆Tick的位置

//

// 所以就統計 \_cur_seq .. \_last_seq之間的Tick的成交資料

//

\_i = \_last_seq + 1;

while \_i \<= \_cur_seq begin

var: tv(0), \_first(0), \_complete(0);

value1 = GetField(\"BidAskFlag\", \"Tick\")\[\_cur_seq - \_i\]; //
外盤=1, 內盤=-1

value2 = GetField(\"Close\", \"Tick\")\[\_cur_seq - \_i\]; // 價格

value3 = GetField(\"Volume\", \"Tick\")\[\_cur_seq - \_i\]; // 單量

value4 = GetField(\"SeqNo\", \"Tick\")\[\_cur_seq - \_i\]; // Tick編號

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// multitick的處理

//

// TickGroup回傳以下數值

// -1 = 集合競價(每天第一盤, 最後一盤, 包含暫緩之後的搓合, etc.)

// 0 = 逐筆搓合單筆

// 1 = 逐筆搓合開始

// 2 = 逐筆搓合中間

// 3 = 逐筆搓合結束

//

value5 = GetField(\"TickGroup\", \"Tick\")\[\_cur_seq - \_i\];

tv = value3;

\_complete = 0;

if value5 = -1 then begin

// 集合競價: 不列入統計

\_i = \_i + 1;

tv = 0;

end else if value5 = 0 then begin

// 獨立一筆: 列入統計

\_i = \_i + 1;

end else if value5 = 1 then begin

// 把連續撮合的所有資料合併成一筆統計

// 連續撮合的第一筆 = 1, 中間 = 2, 最後 = 3

\_first = \_i;

\_i = \_i + 1;

while \_i \<= \_cur_seq and \_complete = 0 begin

value99 = GetField(\"Time\", \"Tick\")\[\_cur_seq - \_i\]; // 價格

value22 = GetField(\"Close\", \"Tick\")\[\_cur_seq - \_i\]; // 價格

value33 = GetField(\"Volume\", \"Tick\")\[\_cur_seq - \_i\]; // 單量

value44 = GetField(\"SeqNo\", \"Tick\")\[\_cur_seq - \_i\]; // Seq

value55 = GetField(\"TickGroup\", \"Tick\")\[\_cur_seq - \_i\];

tv = tv + value33;

\_i = \_i + 1;

if value55 = 3 then \_complete = 1;

end;

if \_complete = 0 then begin

// 有可能交易所還沒有傳送完整的連續撮合Ticks, 所以等下一次洗價時再處理

//

\_cur_seq = \_first;

break;

end;

end else begin

// 異常狀況: 跳過

\_i = \_i + 1;

end;

// 如果超過門檻, 則依照外盤/內盤分別累計(成交量)

//

if tv \> threshold then begin

if value1 = 1 then \_v_buy_acc = \_v_buy_acc + tv;

if value1 = -1 then \_v_sell_acc = \_v_sell_acc + tv;

end;

end;

end;

end;

if symbolexchange = \"TF\" and SymbolType = 3 then begin //台(期貨)

if \_curbar_date \<\> date then begin

// 如果開盤到有某些分鐘沒有成交, 此時會對到昨日之前的Tick =\>
這些分鐘不要計算

//

\_cur_seq = 0;

end else if \_cur_seq \> 0 and \_cur_seq \> \_last_seq then begin

// \_last_seq是上一次畫圖時最後一筆Tick的位置

//

// 所以就統計 \_cur_seq .. \_last_seq之間的Tick的成交資料

//

\_i = \_last_seq + 1;

while \_i \<= \_cur_seq begin

value1 = GetField(\"BidAskFlag\", \"Tick\")\[\_cur_seq - \_i\]; //
外盤=1, 內盤=-1

value2 = GetField(\"Close\", \"Tick\")\[\_cur_seq - \_i\]; // 價格

value3 = GetField(\"Volume\", \"Tick\")\[\_cur_seq - \_i\]; // 單量

value4 = GetField(\"SeqNo\", \"Tick\")\[\_cur_seq - \_i\]; // Tick編號

// 如果超過門檻, 則依照外盤/內盤分別累計(成交量)

//

if value3 \>= threshold then begin

if value1 = 1 then \_v_buy_acc = \_v_buy_acc + value3;

if value1 = -1 then \_v_sell_acc = \_v_sell_acc + value3;

end;

\_i = \_i + 1;

end;

end;

end;

\_last_seq = \_cur_seq;

plot1(\_v_buy_acc - \_v_sell_acc, \"大戶買賣力(自訂)\");

plot2(\_v_buy_acc, \"大戶(自訂)外盤量\",checkbox:=0);

plot3(\_v_sell_acc, \"大戶(自訂)內盤量\",checkbox:=0);

#### 📄 自訂散戶買賣力

{@type:indicator}

{指標數值定義：散戶 = 成交單量 \< X的委託由Tick資料去累計計算

支援商品：台(股票)、台(期貨)}

if symbolexchange \<\> \"TW\" and symbolexchange \<\> \"TF\" then
raiseruntimeerror(\"不支援此商品\");

if SymbolType \<\> 2 and SymbolType \<\> 3 then
raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"Min\" then

raiseruntimeerror(\"僅支援分鐘頻率\");

value91 = GetField(\"上漲量\");

{

顯示開盤迄今的累計外盤小單 - 累計內盤小單, 也就是盤中散戶的買賣力趨勢

小單定義: 成交單量 \<= X

}

input: threshold(30, \"小單門檻(張or口)\");

var: intrabarpersist \_v_buy_acc(0), intrabarpersist \_v_sell_acc(0);

var: intrabarpersist \_last_seq(0);

var: \_cur_seq(0), \_i(0), \_curbar_date(0);

var: \_last_date(0);

if getfielddate(\"date\") \<\> \_last_date then begin

\_last_date = getfielddate(\"date\");

\_v_buy_acc = 0;

\_v_sell_acc = 0;

\_last_seq = 0;

end;

// 抓洗價當時最新一筆Tick的位置跟日期

//

\_cur_seq = GetField(\"SeqNo\", \"Tick\");

\_curbar_date = GetField(\"Date\", \"Tick\");

if symbolexchange = \"TW\" and SymbolType = 2 then begin //台(股票)

if \_curbar_date \<\> date then begin

// 如果開盤到有某些分鐘沒有成交, 此時會對到昨日之前的Tick =\>
這些分鐘不要計算

//

\_cur_seq = 0;

end else if \_cur_seq \> 0 and \_cur_seq \> \_last_seq then begin

// \_last_seq是上一次畫圖時最後一筆Tick的位置

//

// 所以就統計 \_cur_seq .. \_last_seq之間的Tick的成交資料

//

\_i = \_last_seq + 1;

while \_i \<= \_cur_seq begin

var: tv(0), \_first(0), \_complete(0);

value1 = GetField(\"BidAskFlag\", \"Tick\")\[\_cur_seq - \_i\]; //
外盤=1, 內盤=-1

value2 = GetField(\"Close\", \"Tick\")\[\_cur_seq - \_i\]; // 價格

value3 = GetField(\"Volume\", \"Tick\")\[\_cur_seq - \_i\]; // 單量

value4 = GetField(\"SeqNo\", \"Tick\")\[\_cur_seq - \_i\]; // Tick編號

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// multitick的處理

//

// TickGroup回傳以下數值

// -1 = 集合競價(每天第一盤, 最後一盤, 包含暫緩之後的搓合, etc.)

// 0 = 逐筆搓合單筆

// 1 = 逐筆搓合開始

// 2 = 逐筆搓合中間

// 3 = 逐筆搓合結束

//

value5 = GetField(\"TickGroup\", \"Tick\")\[\_cur_seq - \_i\];

tv = value3;

\_complete = 0;

if value5 = -1 then begin

// 集合競價: 不列入統計

\_i = \_i + 1;

tv = 0;

end else if value5 = 0 then begin

// 獨立一筆: 列入統計

\_i = \_i + 1;

end else if value5 = 1 then begin

// 把連續撮合的所有資料合併成一筆統計

// 連續撮合的第一筆 = 1, 中間 = 2, 最後 = 3

\_first = \_i;

\_i = \_i + 1;

while \_i \<= \_cur_seq and \_complete = 0 begin

value99 = GetField(\"Time\", \"Tick\")\[\_cur_seq - \_i\]; // 價格

value22 = GetField(\"Close\", \"Tick\")\[\_cur_seq - \_i\]; // 價格

value33 = GetField(\"Volume\", \"Tick\")\[\_cur_seq - \_i\]; // 單量

value44 = GetField(\"SeqNo\", \"Tick\")\[\_cur_seq - \_i\]; // Seq

value55 = GetField(\"TickGroup\", \"Tick\")\[\_cur_seq - \_i\];

tv = tv + value33;

\_i = \_i + 1;

if value55 = 3 then \_complete = 1;

end;

if \_complete = 0 then begin

// 有可能交易所還沒有傳送完整的連續撮合Ticks, 所以等下一次洗價時再處理

//

\_cur_seq = \_first;

break;

end;

end else begin

// 異常狀況: 跳過

\_i = \_i + 1;

end;

// 如果小於門檻, 則依照外盤/內盤分別累計(成交量)

//

if tv \<= threshold then begin

if value1 = 1 then \_v_buy_acc = \_v_buy_acc + tv;

if value1 = -1 then \_v_sell_acc = \_v_sell_acc + tv;

end;

end;

end;

end;

if symbolexchange = \"TF\" and SymbolType = 3 then begin //台(期貨)

if \_curbar_date \<\> date then begin

// 如果開盤到有某些分鐘沒有成交, 此時會對到昨日之前的Tick =\>
這些分鐘不要計算

//

\_cur_seq = 0;

end else if \_cur_seq \> 0 and \_cur_seq \> \_last_seq then begin

// \_last_seq是上一次畫圖時最後一筆Tick的位置

//

// 所以就統計 \_cur_seq .. \_last_seq之間的Tick的成交資料

//

\_i = \_last_seq + 1;

while \_i \<= \_cur_seq begin

value1 = GetField(\"BidAskFlag\", \"Tick\")\[\_cur_seq - \_i\]; //
外盤=1, 內盤=-1

value2 = GetField(\"Close\", \"Tick\")\[\_cur_seq - \_i\]; // 價格

value3 = GetField(\"Volume\", \"Tick\")\[\_cur_seq - \_i\]; // 單量

value4 = GetField(\"SeqNo\", \"Tick\")\[\_cur_seq - \_i\]; // Tick編號

// 如果超過門檻, 則依照外盤/內盤分別累計(成交量)

//

if value3 \< threshold then begin

if value1 = 1 then \_v_buy_acc = \_v_buy_acc + value3;

if value1 = -1 then \_v_sell_acc = \_v_sell_acc + value3;

end;

\_i = \_i + 1;

end;

end;

end;

\_last_seq = \_cur_seq;

plot1(\_v_buy_acc - \_v_sell_acc, \"散戶買賣力(自訂)\");

plot2(\_v_buy_acc, \"大戶(自訂)外盤量\",checkbox:=0);

plot3(\_v_sell_acc, \"大戶(自訂)內盤量\",checkbox:=0);

#### 📄 買賣力

{@type:indicator}

{指標數值定義：(外盤)量 = 開盤累計到目前的(外盤)成交量

支援商品：台股/期貨/選擇權}

value91 = GetField(\"外盤量\");

value1 = GetField(\"外盤量\",\"D\");

value2 = GetField(\"內盤量\",\"D\");

value3 = value1 - value2;

plot1(value3,\"買賣力\");

plot2(value1,\"外盤量\",checkbox:=0);

plot3(value2,\"內盤量\",checkbox:=0);

### 2.5 大盤指標 (40 個)

#### 📄 ALF亞歷山大過濾指標

{@type:indicator}

input: length(10); setinputname(1, \"天期\");

Value1 = close / close\[length-1\];

plot1(Value1, \"亞歷山大過濾指標\");

#### 📄 BBand寬度指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/bband-width/

}

input:

Length(20, \"MA的天數\"),

UpperBand(2, \"上通道標準差倍數\"),

LowerBand(2, \"下通道標準差倍數\");

variable: mid(0), up(0), down(0), bbandwidth(0) ;

up = bollingerband(Close, Length, UpperBand);

down = bollingerband(Close, Length, -1 \* LowerBand);

mid = (up + down) / 2;

bbandwidth = 100 \* (up - down) / mid;

Plot1(bbandwidth , \"BBand width(%)\");

plot2(4,\"低檔\");

#### 📄 ETF成交量統計指標

{@type:indicator}

array:ETF\[50\](0);

etf\[1\]=GetSymbolField(\"0050.tw\",\"成交金額\");

etf\[2\]=GetSymbolField(\"0051.tw\",\"成交金額\");

etf\[3\]=GetSymbolField(\"0052.tw\",\"成交金額\");

etf\[4\]=GetSymbolField(\"0053.tw\",\"成交金額\");

etf\[5\]=GetSymbolField(\"0054.tw\",\"成交金額\");

etf\[6\]=GetSymbolField(\"0055.tw\",\"成交金額\");

etf\[7\]=GetSymbolField(\"0056.tw\",\"成交金額\");

etf\[8\]=GetSymbolField(\"0057.tw\",\"成交金額\");

etf\[9\]=GetSymbolField(\"0058.tw\",\"成交金額\");

etf\[10\]=GetSymbolField(\"0059.tw\",\"成交金額\");

etf\[11\]=GetSymbolField(\"0061.tw\",\"成交金額\");

etf\[12\]=GetSymbolField(\"006201.tw\",\"成交金額\");

etf\[13\]=GetSymbolField(\"006203.tw\",\"成交金額\");

etf\[14\]=GetSymbolField(\"006204.tw\",\"成交金額\");

etf\[15\]=GetSymbolField(\"006205.tw\",\"成交金額\");

etf\[16\]=GetSymbolField(\"006206.tw\",\"成交金額\");

etf\[17\]=GetSymbolField(\"006207.tw\",\"成交金額\");

etf\[18\]=GetSymbolField(\"006208.tw\",\"成交金額\");

etf\[19\]=GetSymbolField(\"00631L.tw\",\"成交金額\");

etf\[20\]=GetSymbolField(\"00632R.tw\",\"成交金額\");

etf\[21\]=GetSymbolField(\"00633L.tw\",\"成交金額\");

etf\[22\]=GetSymbolField(\"00634R.tw\",\"成交金額\");

etf\[23\]=GetSymbolField(\"00635U.tw\",\"成交金額\");

etf\[24\]=GetSymbolField(\"00636.tw\",\"成交金額\");

etf\[25\]=GetSymbolField(\"00637L.tw\",\"成交金額\");

etf\[26\]=GetSymbolField(\"00638R.tw\",\"成交金額\");

etf\[27\]=GetSymbolField(\"00639.tw\",\"成交金額\");

etf\[28\]=GetSymbolField(\"00640L.tw\",\"成交金額\");

etf\[29\]=GetSymbolField(\"00641R.tw\",\"成交金額\");

etf\[30\]=GetSymbolField(\"00642U.tw\",\"成交金額\");

etf\[31\]=GetSymbolField(\"00643.tw\",\"成交金額\");

etf\[32\]=GetSymbolField(\"00645.tw\",\"成交金額\");

etf\[33\]=GetSymbolField(\"00646.tw\",\"成交金額\");

etf\[34\]=GetSymbolField(\"00647L.tw\",\"成交金額\");

etf\[35\]=GetSymbolField(\"00648R.tw\",\"成交金額\");

etf\[36\]=GetSymbolField(\"00649.tw\",\"成交金額\");

etf\[37\]=GetSymbolField(\"00650L.tw\",\"成交金額\");

etf\[38\]=GetSymbolField(\"00651R.tw\",\"成交金額\");

etf\[39\]=GetSymbolField(\"00652.tw\",\"成交金額\");

etf\[40\]=GetSymbolField(\"00653L.tw\",\"成交金額\");

etf\[41\]=GetSymbolField(\"00654R.tw\",\"成交金額\");

etf\[42\]=GetSymbolField(\"00655L.tw\",\"成交金額\");

etf\[43\]=GetSymbolField(\"00656R.tw\",\"成交金額\");

etf\[44\]=GetSymbolField(\"00657.tw\",\"成交金額\");

etf\[45\]=GetSymbolField(\"00658L.tw\",\"成交金額\");

etf\[46\]=GetSymbolField(\"00659R.tw\",\"成交金額\");

etf\[47\]=GetSymbolField(\"00660.tw\",\"成交金額\");

etf\[48\]=GetSymbolField(\"00661.tw\",\"成交金額\");

etf\[49\]=GetSymbolField(\"00662.tw\",\"成交金額\");

etf\[50\]=GetSymbolField(\"008201.tw\",\"成交金額\");

value1=array_sum(etf,1,50);

if volume\<\>0 then

value3=value1/volume\*100;

plot1(value3);

#### 📄 KST確認指標

{@type:indicator}

variable:kst(0);

value1=average(rateofchange(close,12),10);

value2=average(rateofchange(close,20),10);

value3=average(rateofchange(close,30),8);

value4=average(rateofchange(close,40),15);

kst=value1+value2\*2+value3\*3+value4\*4;

plot1(kst,\"KST確認指標\");

#### 📄 OTC佔大盤成交量比

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/otc跟上市成交量比值是股市多空指標/

}

input: Period(5,\"期數\");

value1=GetSymbolField(\"tse.tw\",\"成交量\");

value2=GetSymbolField(\"otc.tw\",\"成交量\");

value3=value2/value1\*100;

value4=average(value3,Period);

plot1(value4,\"OTC/TSE(%)\");

Plot2(value2,\"OTC成交量\");

#### 📄 Q指標

{@type:indicator}

input:t1(10); setinputname(1,\"天期\");

input:t2(5); setinputname(2,\"平均天期\");

input:t3(20); setinputname(3,\"雜訊平滑天期\");

value1=close-close\[1\]; //價格變化

value2=summation(value1,t1); //累積價格變化

value3=average(value2,t2);

value4=absvalue(value2-value3); //雜訊

value5=average(value4,t3); //把雜訊移動平均

variable:Qindicator(0);

if value5 = 0 then

Qindicator = 0

else

Qindicator = value3 / value5\*5;

plot1(Qindicator,\"Q-indicator\");

#### 📄 上漲下跌家數差RSI指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/上漲下跌家數差RSI指標/

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 256頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

input:period(10,\"RSI計算天數\");

if barfreq \<\> \"D\" then raiseruntimeerror(\"不支援此頻率\");

value1=getfield(\"上漲家數\");

value2=getfield(\"下跌家數\");

value3=value1-value2;

value4=summation(value3,period);

value5=rsi(value4,period);

plot1(value5,\"上漲家數RSI\");

#### 📄 上漲下跌量差

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/進場點一目了然的大盤儀表板/

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 244頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

input:period1(3,\"短天期\");

input:period2(5,\"長天期\");

if barfreq = \"Tick\" or barfreq = \"Min\" then

begin

value1=GetField(\"上漲量\");

value2=getfield(\"下跌量\");

end else begin

value1=GetField(\"上漲量\",\"D\");

value2=getfield(\"下跌量\",\"D\");

end;

value3=average(value1,period1);

value4=average(value2,period1);

value5=value3-value4;//上漲量與下跌量比例

value6=average(value5,period2);

plot1(value6,\"上漲下跌量差\");

#### 📄 上漲佔比

{@type:indicator}

value1=GetField(\"上漲家數\");

value2=GetField(\"下跌家數\");

value3=value1+value2;

if value3 = 0 then value4 = 0 else value4=value1/value3\*100;

plot1(value4,\"上漲佔比\");

#### 📄 上漲家數

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/大盤多空轉換點之探討系列一-上漲的股票有沒有200/

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 252頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

input:shortterm(5,\"期間\");

input:midterm(15,\"平均\");

value1=GetField(\"上漲家數\");

value2=lowest(value1,shortterm);

value3=average(value2,midterm);

plot1(value3,\"平均上漲家數\");

plot2(200,\"多\");

plot3(100,\"空\");

#### 📄 上漲家數佔比指標

{@type:indicator}

input:period1(5,\"短天期\");

input:period2(20,\"長天期\");

value1=GetField(\"上漲家數\");

value2=GetField(\"下跌家數\");

value3=value1+value2;

if value3 = 0 then

value4 = 0

else

value4=value1/value3\*100;

value5=average(value4,period1);

value6=average(value4,period2);

plot1(value5,\"上漲佔比短期平均\");

plot2(value6,\"上漲佔比長期平均\");

plot3(value5-value6,\"長短天期差\");

#### 📄 上漲量比重

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/盤上成交是否真的是重要指標/

}

if barfreq = \"Tick\" or barfreq = \"Min\" then

begin

value1=GetField(\"上漲量\");

end else begin

value1=GetField(\"上漲量\",\"D\");

end;

if volume\<\>0 then

value2=value1/volume;

plot1(average(value2,5),\"上漲量比重\");

#### 📄 主力買賣超佔市場成交量比

{@type:indicator}

{市場成交量定義

加權成交量 GetSymbolField(\"TSE.TW\", \"成交量\"):

https://www.twse.com.tw/zh/page/trading/exchange/MI_INDEX.html

總計(1\~15)欄位的成交金額(元)

上櫃成交量 GetSymbolField(\"OTC.TW\", \"成交量\"):

https://www.tpex.org.tw/web/stock/aftertrading/market_statistics/statistics.php?l=zh-tw

股票合計(1\~3)欄位的成交金額(元)

}

if barfreq = \"Tick\" or barfreq = \"Min\" then
raiseruntimeerror(\"只支援日線以上\");

value1 = GetSymbolField(\"TSE.TW\", \"主力買進金額\") -
GetSymbolField(\"TSE.TW\", \"主力賣出金額\")

\+ GetSymbolField(\"OTC.TW\", \"主力買進金額\") -
GetSymbolField(\"TSE.TW\", \"主力賣出金額\");

value2 = GetSymbolField(\"TSE.TW\", \"成交量\") +
GetSymbolField(\"OTC.TW\", \"成交量\");

if value2 = 0 then value3 = 0 else value3 = value1/value2\*100;

plot1(value3,\"佔比(%)\");

#### 📄 估波指標(Coppock Indicator)

{@type:indicator}

{ 一般適用於大盤月線資料 }

input:length1(14); setinputname(1, \"天期一\");

input:length2(11); setinputname(2, \"天期二\");

input:length3(10); setinputname(3, \"平均天期\");

variable:coppock(0);

Value1=rateofchange(close,length1);

Value2=rateofchange(close,length2);

coppock=xaverage(Value1+Value2,length3);

plot1(coppock,\"Coppock Indicator\");

#### 📄 作多意願指標

{@type:indicator}

input:length1(20,\"長天期\"),length2(9,\"短天期\");

variable:count1(0),x1(0);

count1=0;

for x1=1 to length2-1 begin

if high \< close\*1.01 then

count1=count1+1;

if open \> close\[1\]\*1.005 then

count1=count1+1;

if close \> close\[1\] and volume\>volume\[1\] then

count1=count1+1;

if GetField(\"外盤量\") \> GetField(\"內盤量\") then

count1=count1+1;

end;

value2=average(count1,length1);

value3=average(count1,length2);

plot1(value2,\"長期意願\");

plot2(value3,\"短期意願\");

#### 📄 內外盤量差

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/內外盤量比在預測大盤後市上的應用/

收錄於「三週學會程式交易：打造你的第一筆自動化交易」242頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

if barfreq = \"Tick\" or barfreq = \"Min\" then

begin

value1=GetField(\"內盤量\");//單位:元

value2=GetField(\"外盤量\");//單位:元

end else begin

value1=GetField(\"內盤量\",\"D\");//單位:元

value2=GetField(\"外盤量\",\"D\");//單位:元

end;

if volume \<\> 0 then begin

value3=value2/volume\*100;//外盤量比

value4=value1/volume\*100;//內盤量比

end else begin

value3=value3\[1\];

value4=value4\[1\];

end;

value5=average(value3,5);

value6=average(value4,5);

value7=value5-value6+5;

plot1(value7,\"內外盤量比差\");

#### 📄 內盤長短期累積量比值差

{@type:indicator}

input:length1(5,\"短天期\"),length2(20,\"長天期\");

variable:ac(0),ds(0),ac1(0),ds1(0);

if barfreq = \"Tick\" or barfreq = \"Min\" then

begin

value1=GetField(\"內盤量\");//單位:元

value2=GetField(\"外盤量\");//單位:元

end else begin

value1=GetField(\"內盤量\",\"D\");//單位:元

value2=GetField(\"外盤量\",\"D\");//單位:元

end;

value3=summation(value1,length1);

value4=summation(value2,length1);

value5=summation(value1,length2);

value6=summation(value2,length2);

value7=summation(volume,length1);

value8=summation(volume,length2);

ac=value4/value7\*100;//外盤短期積量比值

ds=value3/value7\*100;//內盤短期積量比值

ac1=value6/value8\*100;//外盤長期積量比值

ds1=value5/value8\*100;//內盤長期積量比值

value11=ds1-ds;

plot1(value11,\"內盤長短期積量比值差\");

#### 📄 反脆弱指標

{@type:indicator}

array:ValueArray\[21\](0);

valuearray\[1\]=GetSymbolField(\"1477.tw\",\"總市值\");

valuearray\[2\]=GetSymbolField(\"1536.tw\",\"總市值\");

valuearray\[3\]=GetSymbolField(\"1702.tw\",\"總市值\");

valuearray\[4\]=GetSymbolField(\"2231.tw\",\"總市值\");

valuearray\[5\]=GetSymbolField(\"2207.tw\",\"總市值\");

valuearray\[6\]=GetSymbolField(\"2355.tw\",\"總市值\");

valuearray\[7\]=GetSymbolField(\"2377.tw\",\"總市值\");

valuearray\[8\]=GetSymbolField(\"2379.tw\",\"總市值\");

valuearray\[9\]=GetSymbolField(\"2383.tw\",\"總市值\");

valuearray\[10\]=GetSymbolField(\"2492.tw\",\"總市值\");

valuearray\[11\]=GetSymbolField(\"2905.tw\",\"總市值\");

valuearray\[12\]=GetSymbolField(\"3023.tw\",\"總市值\");

valuearray\[13\]=GetSymbolField(\"3552.tw\",\"總市值\");

valuearray\[14\]=GetSymbolField(\"4938.tw\",\"總市值\");

valuearray\[15\]=GetSymbolField(\"4958.tw\",\"總市值\");

valuearray\[16\]=GetSymbolField(\"5347.tw\",\"總市值\");

valuearray\[17\]=GetSymbolField(\"5871.tw\",\"總市值\");

valuearray\[18\]=GetSymbolField(\"5904.tw\",\"總市值\");

valuearray\[19\]=GetSymbolField(\"8016.tw\",\"總市值\");

valuearray\[20\]=GetSymbolField(\"9910.tw\",\"總市值\");

valuearray\[21\]=GetSymbolField(\"9938.tw\",\"總市值\");

value1=array_sum(valuearray,1,21);

plot1(value1);

#### 📄 台指選倉P／C

{@type:indicator}

value1=getsymbolfield(\"txo00.tf\",\"買賣權未平倉量比率\");

plot1(value1,\"台指選倉P／C\");

#### 📄 噪音指標

{@type:indicator}

input:n1(5); setinputname(1,\"計算天期\");

input:n2(5); setinputname(2,\"移動平均天期\");

value1=absvalue(close-close\[n1-1\]);

value2=summation(range,n1);

if value1 \<\> 0 then

begin

value3 = value2 / value1;

value4 = average(value3,n2);

end;

plot1(value4,\"噪音指標\");

#### 📄 外資買賣超佔市場成交量比

{@type:indicator}

{市場成交量定義

加權成交量 GetSymbolField(\"TSE.TW\", \"成交量\"):

https://www.twse.com.tw/zh/page/trading/exchange/MI_INDEX.html

總計(1\~15)欄位的成交金額(元)

上櫃成交量 GetSymbolField(\"OTC.TW\", \"成交量\"):

https://www.tpex.org.tw/web/stock/aftertrading/market_statistics/statistics.php?l=zh-tw

股票合計(1\~3)欄位的成交金額(元)

}

if barfreq = \"Tick\" or barfreq = \"Min\" then
raiseruntimeerror(\"只支援日線以上\");

value1 = GetSymbolField(\"TSE.TW\", \"外資買賣超金額\") +
GetSymbolField(\"OTC.TW\", \"外資買賣超金額\");

value2 = GetSymbolField(\"TSE.TW\", \"成交量\") +
GetSymbolField(\"OTC.TW\", \"成交量\");

if value2 = 0 then value3 = 0 else value3 = value1/value2\*100;

plot1(value3,\"佔比(%)\");

#### 📄 多空點數指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/多空點數指標/

}

variable:i(0),Lscore(0),Sscore(0);

Lscore=0;

Sscore=0;

for i = 1 to 100 begin

if C\> H\[i\] then

Lscore += 1

else if C \< L\[i\] then

Sscore += 1;

end;

PLOT1(LSCORE-SSCORE,\"多空點數\");

#### 📄 大盤儀表板

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/進場點一目了然的大盤儀表板/

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 260頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

if barfreq \<\> \"D\" then raiseruntimeerror(\"不支援此頻率\");

condition1=false;

condition2=false;

condition3=false;

condition4=false;

condition5=false;

//==========OTC 佔大盤成交量比================

value1=GetSymbolField(\"tse.tw\",\"成交量\");

value2=GetSymbolField(\"otc.tw\",\"成交量\");

value3=value2/value1\*100;

value4=average(value3,5);

value5=low\*0.98;

if value4 crosses over 20 then

condition1=true;

if condition1 then

plot1(value5,\"OTC 進場訊號\");

//============內外盤量比差====================

value6=GetField(\"內盤量\");//單位:元

value7=GetField(\"外盤量\");//單位:元

value8=value7/volume\*100;//外盤量比

value9=value6/volume\*100;//內盤量比

value10=average(value8,5);

value11=average(value9,5);

value7=value10-value11+5;

if value7 crosses over 0 then

condition2=true;

if condition2 then

plot2(value5\*0.98,\"內外盤量比差\");

//===========上漲下跌家數 RSI 指標==============

input: \_TEXT1(\"===============\",\"上漲下跌家數RSI指標參數\");

input:period(10,\"RSI計算天數\");

value12=GetField(\"上漲家數\");

value13=GetField(\"下跌家數\");

value14=value12-value13;

value15=summation(value14,period);

value16=rsi(value15,period);

if value16 crosses over 50 then

condition3=true;

if condition3 then

plot3(value5\*0.97,\"上漲下跌家數 RSI\");

//===========上漲家數突破 200 檔================

value17=lowest(value12,5);

value18=average(value17,15);

if value18 crosses over 200 then

condition4=true;

if condition4=true then

plot4(value5\*0.96,\"上漲家數突破 200 家\");

//==========上漲下跌量指標=====================

input: \_TEXT2(\"===============\",\"上漲下跌量指標參數\");

input:p1(3,\"上漲下跌量平均天數\");

value19=GetField(\"上漲量\");

value20=GetField(\"下跌量\");

value21=average(value19,period);

value22=average(value20,period);

value23=value21-value22;

value24=average(value23,5);

if value24 crosses over 0 then

condition5=true;

if condition5=true then

plot5(value5\*0.95,\"上漲量突破下跌量\");

#### 📄 大盤六度空間切割法

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/多空六大階段指標/

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 259頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

var:m50(0),m200(0);

m50=average(close,50);

m200=average(close,200);

if close \> m50 and c\< m200 and m50\<m200

then value1=10

else value1=0;

if close \> m50 and c\> m200 and m50\<m200

then value2=20

else value2=0;

if close \> m50 and c\> m200 and m50 \> m200

then value3=30

else value3=0;

if close \< m50 and c\>m200 and m50\>m200

then value4=-10

else value4=0;

if close \< m50 and c \<m200

then value5=-20

else value5=0;

if close \< m50 and c \<m200 then value6=-30

else value6=0;

plot1(value1,\"復甦期\");

plot2(value2,\"收集期\");

plot3(value3,\"多頭\");

plot4(value4,\"警示期\");

plot5(value5,\"發散期\");

plot6(value6,\"空頭\");

#### 📄 大盤多空對策判斷分數

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/大盤多空對策訊號/

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 265頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

if barfreq \<\> \"D\" then raiseruntimeerror(\"僅支援日頻率\");

variable: XData(0),YData(0),ZData(0),Z(0),count(0);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

//每天的分數都先歸零

if date \<\> date\[1\] then

count=0;

//外資買超

XData = GetField(\"外資買賣超金額\")\[Z\];

if xdata \> 0 then

count=count+1;

//投信買超

YData = GetField(\"投信買賣超金額\")\[Z\];

if ydata \> 0 then

count=count+1;

//自營商買超

ZData = GetField(\"自營商買賣超金額\")\[Z\];

if zdata \> 0 then

count=count+1;

//上漲量超過一半

value6 = GetField(\"上漲量\");

if value6/volume \> 0.5 then

count=count+1;

//外盤量超過一半

value7 = GetField(\"外盤量\");

if value7/volume\>0.5 then

count=count+1;

//RSI多頭

value8=rsi(close,5);

value9=rsi(close,10);

if value8 \> value9 and value8 \< 90 then

count=count+1;

//MACD 多頭

variable:Dif_val(0), MACD_val(0), Osc_val(0);

MACD(Close, 12, 26, 9, Dif_val, MACD_val, Osc_val);

if osc_val \> 0 then

count=count+1;

//MTM 多頭

value10=mtm(10);

if value10 \> 0 then

count=count+1;

//KD多頭

variable:rsv1(0),k1(0),d1(0);

stochastic(9,3,3,rsv1,k1,d1);

if k1 \> d1 and k1 \< 80 then

count=count+1;

//+DI\>-DI

variable:pdi_value(0),ndi_value(0),adx_value(0);

DirectionMovement(14,pdi_value,ndi_value,adx_value);

if pdi_value \> ndi_value then

count=count+1;

//AR趨勢向上

value14=ar(26);

value15=linearregslope(value14,5);

if value15 \> 0 then

count=count+1;

//ACC大於零

value16=acc(10);

if value16 \> 0 then

count=count+1;

//TRIX多頭

value17=trix(close,9);

value18=trix(close,15);

if value17 \> value18 then

count=count+1;

//SAR多頭

value19=SAR(0.02, 0.02, 0.2);

if close \> value19 then

count=count+1;

//週線大於月線

if average(close,5) \> average(close,20) then

count=count+1;

//計算平均分數

value11=average(count,10);

plot1(value11,\"分數\");

Plot2(10,\"多\");

plot3(5,\"空\");

#### 📄 大盤多空指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/打造自己的大盤多空函數/

}

input:Length(7,\"計算天數\");

input:LowLimit(5,\"外資買超天數\");

plot1(tselsindex(Length,LowLimit));

#### 📄 委買委賣均張差額

{@type:indicator}

{

指標說明

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 246頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

input:period(10,\"天數\");

if barfreq = \"Tick\" or barfreq = \"Min\" then begin

value1=GetField(\"委買均\");

value2=GetField(\"委賣均\");

end else begin

value1=GetField(\"委買均\",\"D\");

value2=GetField(\"委賣均\",\"D\");

end;

value3=value1-value2;

value4=average(value3,period);

plot1(value4,\"委買賣均張差額的移動平均\");

#### 📄 實質買賣盤比指標

{@type:indicator}

input:length(5,\"期數\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"實質買盤比\");

value2=GetField(\"實質賣盤比\");

value3=average(value1,length)-80;

plot1(value3,\"實質買賣盤比\");

#### 📄 尼古斯指標

{@type:indicator}

input: length(30); setinputname(1, \"天期\");

value1=GetField(\"上漲家數\");

value2=GetField(\"下跌家數\");

value3=average(value1,length);

value4=average(value2,length);

if value4 \<\> 0 then value5=value3/value4;

plot1(value5, \"尼古斯指標\");

#### 📄 投信買賣超佔市場成交量比

{@type:indicator}

{市場成交量定義

加權成交量 GetSymbolField(\"TSE.TW\", \"成交量\"):

https://www.twse.com.tw/zh/page/trading/exchange/MI_INDEX.html

總計(1\~15)欄位的成交金額(元)

上櫃成交量 GetSymbolField(\"OTC.TW\", \"成交量\"):

https://www.tpex.org.tw/web/stock/aftertrading/market_statistics/statistics.php?l=zh-tw

股票合計(1\~3)欄位的成交金額(元)

}

if barfreq = \"Tick\" or barfreq = \"Min\" then
raiseruntimeerror(\"只支援日線以上\");

value1 = GetSymbolField(\"TSE.TW\", \"投信買賣超金額\") +
GetSymbolField(\"OTC.TW\", \"投信買賣超金額\");

value2 = GetSymbolField(\"TSE.TW\", \"成交量\") +
GetSymbolField(\"OTC.TW\", \"成交量\");

if value2 = 0 then value3 = 0 else value3 = value1/value2\*100;

plot1(value3,\"佔比(%)\");

#### 📄 本土天王平均

{@type:indicator}

array:ValueArray\[12\](0);

valuearray\[1\]=GetSymbolField(\"1216.tw\",\"收盤價\");

valuearray\[2\]=GetSymbolField(\"2201.tw\",\"收盤價\");

valuearray\[3\]=GetSymbolField(\"2412.tw\",\"收盤價\");

valuearray\[4\]=GetSymbolField(\"1707.tw\",\"收盤價\");

valuearray\[5\]=GetSymbolField(\"2207.tw\",\"收盤價\");

valuearray\[6\]=GetSymbolField(\"2905.tw\",\"收盤價\");

valuearray\[7\]=GetSymbolField(\"2912.tw\",\"收盤價\");

valuearray\[8\]=GetSymbolField(\"5530.tw\",\"收盤價\");

valuearray\[9\]=GetSymbolField(\"8454.tw\",\"收盤價\");

valuearray\[10\]=GetSymbolField(\"1507.tw\",\"收盤價\");

valuearray\[11\]=GetSymbolField(\"9933.tw\",\"收盤價\");

valuearray\[12\]=GetSymbolField(\"9941.tw\",\"收盤價\");

value1=array_sum(valuearray,1,12);

plot1(value1);

#### 📄 法人買賣超佔市場成交量比

{@type:indicator}

{市場成交量定義

加權成交量 GetSymbolField(\"TSE.TW\", \"成交量\"):

https://www.twse.com.tw/zh/page/trading/exchange/MI_INDEX.html

總計(1\~15)欄位的成交金額(元)

上櫃成交量 GetSymbolField(\"OTC.TW\", \"成交量\"):

https://www.tpex.org.tw/web/stock/aftertrading/market_statistics/statistics.php?l=zh-tw

股票合計(1\~3)欄位的成交金額(元)

}

if barfreq = \"Tick\" or barfreq = \"Min\" then
raiseruntimeerror(\"只支援日線以上\");

value1 = GetSymbolField(\"TSE.TW\", \"法人買賣超金額\") +
GetSymbolField(\"OTC.TW\", \"法人買賣超金額\");

value2 = GetSymbolField(\"TSE.TW\", \"成交量\") +
GetSymbolField(\"OTC.TW\", \"成交量\");

if value2 = 0 then value3 = 0 else value3 = value1/value2\*100;

plot1(value3,\"佔比(%)\");

#### 📄 法人買進賣出比重指標

{@type:indicator}

input:period(5,\"期數\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"法人買進比重\");

value2=GetField(\"法人賣出比重\");

value3=value1-value2;

value4=average(value3,period);

plot1(value4,\"法人買賣比重差額的移動平均\");

#### 📄 漲跌停家數

{@type:indicator}

value1=GetField(\"漲停家數\");

value2=GetField(\"跌停家數\");

plot1(value1,\"漲停家數\");

plot2(value2,\"跌停家數\");

#### 📄 當日沖銷張數

{@type:indicator}

input:length(5,\"期數\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"當日沖銷張數\");

value2=average(value1,length);

plot1(value2,\"當日沖銷張數的移動平均\");

#### 📄 移動平均線再平均指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/移動平均線再平均指標/

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 257頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

input: Period1(5,\"一次平均期數\");

input: Period2(5,\"二次平均期數\");

input: Period3(10,\"累計期數\");

value1=average(close,Period1);

value2=average(value1,Period2);

value3=value1-value2;

value4=summation(value3,Period3);

plot1(value4,\"多空\");

#### 📄 自營商買賣超佔市場成交量比

{@type:indicator}

{市場成交量定義

加權成交量 GetSymbolField(\"TSE.TW\", \"成交量\"):

https://www.twse.com.tw/zh/page/trading/exchange/MI_INDEX.html

總計(1\~15)欄位的成交金額(元)

上櫃成交量 GetSymbolField(\"OTC.TW\", \"成交量\"):

https://www.tpex.org.tw/web/stock/aftertrading/market_statistics/statistics.php?l=zh-tw

股票合計(1\~3)欄位的成交金額(元)

}

if barfreq = \"Tick\" or barfreq = \"Min\" then
raiseruntimeerror(\"只支援日線以上\");

value1 = GetSymbolField(\"TSE.TW\", \"自營商買賣超金額\") +
GetSymbolField(\"OTC.TW\", \"自營商買賣超金額\");

value2 = GetSymbolField(\"TSE.TW\", \"成交量\") +
GetSymbolField(\"OTC.TW\", \"成交量\");

if value2 = 0 then value3 = 0 else value3 = value1/value2\*100;

plot1(value3,\"佔比(%)\");

#### 📄 軍火商指數

{@type:indicator}

array:ValueArray\[6\](0);

valuearray\[1\]=GetSymbolField(\"LMT.US\",\"收盤價\");

valuearray\[2\]=GetSymbolField(\"BA.US\",\"收盤價\");

valuearray\[3\]=GetSymbolField(\"RTN.US\",\"收盤價\");

valuearray\[4\]=GetSymbolField(\"GD.US\",\"收盤價\");

valuearray\[5\]=GetSymbolField(\"NOC.US\",\"收盤價\");

valuearray\[6\]=GetSymbolField(\"UTX.US\",\"收盤價\");

value1=array_sum(valuearray,1,6);

plot1(value1);

#### 📄 開盤委買委賣差

{@type:indicator}

{

指標說明

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 245頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

input:length(5,\"天期\");

value1=GetField(\"開盤委買\", \"D\");

value2=GetField(\"開盤委賣\", \"D\");

value3=value1-value2;

value4=average(value3,length);

plot1(value4,\"開盤委買賣差之移動平均\");

#### 📄 麥克連震盪指標

{@type:indicator}

input:length1(19,\"短天期\"),length2(39,\"長天期\");

if barfreq = \"Tick\" or barfreq = \"Min\" then

begin

value1=GetField(\"上漲量\");

value2=getfield(\"下跌量\");

end else begin

value1=GetField(\"上漲量\",\"D\");

value2=getfield(\"下跌量\",\"D\");

end;

value3=value1-value2;

value4=Xaverage(value3,length1)-Xaverage(value3,length2);

plot1(value4,\"麥克連震盪指標\");

### 2.6 市場動能 (11 個)

#### 📄 台灣50KD多方家數

{@type:indicator}

{統計台灣50成分股內, 目前K \> D的家數

使用KD指標，資料期數為9，K值平滑期數為3，D值平滑期數為3。}

value1 = GetSymbolField(\"TSE50.SJ\",\"TW50KD多空家數\");

plot1(value1,\"台灣50KD多方家數\");

#### 📄 台灣50MTM多方家數

{@type:indicator}

{統計台灣50成分股內, Momentum(10) \> 0的家數.

Momentum(N) = 目前價格 - N筆資料前的Close。}

value1 = GetSymbolField(\"TSE50.SJ\",\"TW50MTM多空家數\");

plot1(value1,\"台灣50MTM多方家數\");

#### 📄 台灣50上昇趨勢家數

{@type:indicator}

{統計台灣50成分股, 趨勢向上的家數.

趨勢向上的定義是計算近6根K棒(含當前這一根K棒)的線性回歸線是否向上}

value1 = GetSymbolField(\"TSE50.SJ\",\"TW50上昇趨勢家數\");

plot1(value1,\"台灣50上昇趨勢家數\");

#### 📄 台灣50上漲家數

{@type:indicator}

{統計台灣50成分股，這一根K棒上漲的家數。

K棒上漲的定義為，目前收盤價 \> 前一根K棒的收盤價}

value1 = GetSymbolField(\"TSE50.SJ\",\"TW50價格上漲家數\");

plot1(value1,\"台灣50上漲家數\");

#### 📄 台灣50創新低家數

{@type:indicator}

{統計台灣50成分股, 最低價創近20期新低的家數。}

value1 = GetSymbolField(\"TSE50.SJ\",\"TW50創新低家數\");

plot1(value1,\"台灣50創新低家數\");

#### 📄 台灣50創新高家數

{@type:indicator}

{統計台灣50成分股，最高價創近20期新高的家數。}

value1 = GetSymbolField(\"TSE50.SJ\",\"TW50創新高家數\");

plot1(value1,\"台灣50創新高家數\");

#### 📄 台灣50均線多方家數

{@type:indicator}

{統計台灣50成分股內, 目前股價大於10期簡單移動均線之上的家數。}

value1 = GetSymbolField(\"TSE50.SJ\",\"TW50均線多空家數\");

plot1(value1,\"台灣50均線多方家數\");

#### 📄 台灣50大單成交次數

{@type:indicator}

{統計台灣50成分股, 近10分鐘(買進大單次數+買進特大單次數)的平均值}

value1 = GetSymbolField(\"TSE50.SJ\",\"TW50大單成交次數\");

plot1(value1,\"台灣50大單成交次數\");

#### 📄 台灣50大單買進金額

{@type:indicator}

{統計台灣50成分股，近10根K棒的買進大單金額平均值。

因為不跨日，所以開盤不足10根K棒時則依照開盤根棒數平均（跨K棒時送出前一根K棒的統計值）}

value1 = GetSymbolField(\"TSE50.SJ\",\"TW50大單買進金額\");

plot1(value1,\"台灣50大單買進金額（元）\");

#### 📄 台灣50大戶買賣力

{@type:indicator}

{統計台灣50成分股, 當分鐘大戶買賣力金額。

大戶買賣力為，買進(大單+特大單)-賣出(大單+特大單)}

value1 = GetSymbolField(\"TSE50.SJ\",\"TW50大戶買賣力\");

plot1(value1,\"台灣50大戶買賣力（元）\");

#### 📄 台灣50紅K家數

{@type:indicator}

{統計台灣50成分股內, 目前這根K棒是紅K棒的家數.

紅K棒的定義為，收盤價大於開盤價。}

plot1(GetSymbolField(\"TSE50.SJ\",\"TW50紅K家數\"),\"台灣50紅K家數\");

### 2.7 技術指標 (83 個)

#### 📄 %b指標

{@type:indicator}

input: Length(20); SetInputName(1, \"布林通道天數\");

input: BandRange(2);SetInputName(2, \"上下寬度\");

input: MALength(10);SetInputName(3, \"MA天期\");

variable: up(0), down(0), mid(0);

up = bollingerband(Close, Length, BandRange);

down = bollingerband(Close, Length, -1 \* BandRange);

if up - down = 0 then value1 = 0 else value1 = (close - down) \* 100 /
(up - down);

value2 = average(value1, MALength);

Plot1(value1, \"%b\");

Plot2(value2, \"%b平均\");

#### 📄 ADTM動態買賣氣指標

{@type:indicator}

input: length(23); setinputname(1, \"天期\");

input: period(8); setinputname(2, \"平均\");

variable:DTM(0),DBM(0),STM(0),SBM(0),ADTM(0),ADTMMA(0);

if open \> open\[1\] then

DTM = maxlist(high-open,open-open\[1\])

else

DTM = 0;

if open \< open\[1\] then

DBM = open-low

else

DBM = 0;

STM = Summation(DTM,length);

SBM = Summation(DBM,length);

if STM \> SBM then

ADTM = (STM-SBM)/STM

else

if STM \< SBM then

ADTM = (STM-SBM)/SBM

else

ADTM = 0;

ADTMMA = average(ADTM,period);

plot1(ADTM, \"ADTM\");

plot2(ADTMMA, \"ADTM移動平均\");

#### 📄 ASI(Accumulation Swing Index)振動升降指標

{@type:indicator}

input:length(10,\"si的累計長度\");

variable:si(0),asi(0);

value1=high-low;

value2=low-close\[1\];

value3=high-low\[1\];

value4=close\[1\]-open\[1\];

value5=absvalue(close-close\[1\]);

value6=absvalue(close-open);

value7=absvalue(close\[1\]-open\[1\]);

value8=(value5+0.5\*value6+value7);

switch(maxlist(value1,value2,value3)) begin

case value1:

value9=value1+0.5\*value2+0.25\*value4;

case value2:

value9=value2+0.5\*value1+0.25\*value4;

case value3:

value9=value3+0.25\*value4;

end;

value10=maxlist(value1,value2);

if value9\*value10\<\>0 then

si=50\*value8/value9\*value10/3

else

si=si\[1\];

asi+=si;

plot1(asi,\"ASI\");

#### 📄 Aroon

{@type:indicator}

input:length(25); setinputname(1, \"計算週期\");

variable: aroon_up(0), aroon_down(0), aroon_oscillator(0);

aroon_up = (length-nthhighestbar(1,high,length))/length\*100;

aroon_down = (length-nthlowestbar(1,low,length))/length\*100;

aroon_oscillator=aroon_up-aroon_down;

plot1(aroon_up,\"aroon_up\");

plot2(aroon_down,\"aroon_down\");

plot3(aroon_oscillator,\"aroon_oscillator\");

#### 📄 BB指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/％b指標/

}

input:

Length(20, \"天數\"),

UpperBand(2, \"上\"),

LowerBand(2, \"下\"),

pbLength(5, \"%B平均天數\");

variable: up(0), down(0), mid(0), bbandwidth(0), pb(0);

up = bollingerband(Close, Length, UpperBand);

down = bollingerband(Close, Length, -1 \* LowerBand);

mid = (up + down) / 2;

bbandwidth = 100 \* (up - down) / mid;

pb=(close-down)/(up-down);

value1=average(pb,pbLength);

plot1(pb,\"%b\");

plot2(value1,\"%b移動平均\");

#### 📄 BW MFI

{@type:indicator}

{

指標說明

Market Facilitation Index

}

if volume \<\> 0 then

value1=(high-low)/volume;

if value1\>value1\[1\] and volume\>volume\[1\] then begin

plot1(volume,\"綠燈\");

noplot(2);

noplot(3);

noplot(4);

end;

if value1\>value1\[1\] and volume\<=volume\[1\] then begin

plot2(volume,\"偽裝\");

noplot(1);

noplot(3);

noplot(4);

end;

if value1\<=value1\[1\] and volume\>volume\[1\] then begin

plot3(volume,\"蟄伏\");

noplot(1);

noplot(2);

noplot(4);

end;

if value1\<=value1\[1\] and volume\<=volume\[1\] then begin

plot4(volume,\"衰退\");

noplot(1);

noplot(2);

noplot(3);

end;

#### 📄 CMI市場波動指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/如何判斷現在是趨勢還是盤整-一個還在研究的課/

}

input:period(10,\"計算區間\");

value1=(close-close\[period-1\])/(highest(high,period)-lowest(low,period))\*100;

value2=absvalue(value1)-30;

value3=average(value2,3);

plot1(value3,\"市場波動指標\");

#### 📄 CMO(錢德動量擺盪指標)

{@type:indicator}

Input:length(10); setinputname(1, \"天期\");

variable: SU(0),SD(0);

if close \>= close\[1\] then

SU = CLOSE - CLOSE\[1\]

else

SU = 0;

if close \< close\[1\] then

SD = CLOSE\[1\] - CLOSE

else

SD = 0;

value1 = summation(SU,length);

value2 = summation(SD,length);

if value1+value2 \<\> 0 then value3 =
(value1-value2)/(value1+value2)\*100;

plot1(value3, \"CMO\");

#### 📄 CPC指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/自訂指標的撰寫技巧以q指標為例/

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 317頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

input:t1(10,\"計算累積價格變動的bar數\");

input:t2(5,\"短期平均天期\");

input:t3(20,\"長期平均天期\");

value1=close-close\[1\];//價格變化

value2=summation(value1,t1);//累積價格變化

value3=average(value2,t2);//短期平均

value4=average(value2,t3);//長期平均

plot1(value3,\"短期累積價格變化平均\");

plot2(value4,\"長期累積價格變化平均\");

#### 📄 CR指標

{@type:indicator}

input:Length(26,\"N日累積\");

variable:Upsum(0),Downsum(0),CR(0);

Upsum = summation(high - WeightedClose\[1\],Length);

Downsum = summation(WeightedClose\[1\] - low,Length);

if Downsum \<\> 0 then

CR = Upsum / Downsum \*100

else

CR = CR\[1\];

plot1(CR,\"CR(%)\");

#### 📄 Chaikin 蔡金波動性指標

{@type:indicator}

// Chaikin Volatility 指標

//

input: Length(10), LengthROC(12);

variable: \_chaikin(0);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

Value1 = XAverage(High - Low, Length);

if CurrentBar \>= LengthROC And Value1\[LengthROC\] \<\> 0 then

\_chaikin = 100 \* (Value1 - Value1\[LengthROC\]) / Value1\[LengthROC\]

else

\_chaikin = 0;

Plot1(\_chaikin, \"Chaikin\");

#### 📄 DBCD 異同離差乖離率

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/異同離差乖離率dbcd在單一國家股票型基金的應用/

}

input:

length1(10,\"短天期\"),

length2(20,\"長天期\"),

length3(14,\"平均天期\");

value1=bias(length1);

value2=bias(length2);

value3=value2-value1;

value4=average(value3,length3);

plot1(value4,\"DBCD\");

#### 📄 DMI

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/787/

}

input:length(10,\"期數\");

variable: pdi_value(0), ndi_value(0), adx_value(0);

DirectionMovement(Length, pdi_value, ndi_value, adx_value);

value1=pdi_value-ndi_value;

plot1(pdi_value,\"向上力量\");

plot2(ndi_value,\"向下力量\");

plot3(value1,\"多空力道差\");

#### 📄 EMA-SMA

{@type:indicator}

input:period(20,\"計算期間\");

value1=EMA(close,period);

value2=average(close,period);

if close\<\>0 then

value3=(value1-value2)/close\*100;

plot1(value3,\"EMA-SMA\");

#### 📄 Elder 多頭力道指標

{@type:indicator}

// Elder 多頭力道指標

//

input: Length(13);

SetInputName(1, \"天數\");

Value1 = High - XAverage(Close, Length);

Plot1(Value1, \"多頭\");

#### 📄 Elder 空頭力道指標

{@type:indicator}

// Elder 空頭力道指標

//

input: Length(13);

SetInputName(1, \"天數\");

Value1 = Low - XAverage(Close, Length);

Plot1(Value1, \"空頭\");

#### 📄 HV歷史波動率指標

{@type:indicator}

input:LENGTH1(6,\"短天期\"),LENGTH2(100,\"短天期\");

variable:HVS(0),HVL(0),HVindex(0);

value1=log(close/close\[1\]);

HVS=STANDARDDEV(value1,LENGTH1,1)\*100\*SQUAREROOT(252);

HVL=STANDARDDEV(VALUE1,LENGTH2,1)\*100\*SQUAREROOT(252);

HVindex=HVS/HVL;

plot1(hvindex,\"歷史波動率指標\");

#### 📄 IMI日內動能指標

{@type:indicator}

input:length(10); setinputname(1, \"天期\");

variable:up(0),dn(0),upi(0),dni(0),imi(0);

if close \> open then

up = close-open

else

up = 0;

if close \< open then

dn = open-close

else

dn = 0;

upi = summation(up,length);

dni = summation(dn,length);

if upi+dni = 0 then imi = 0 else imi = upi/(upi+dni)\*100;

plot1(imi, \"IMI\");

#### 📄 KO能量潮指標

{@type:indicator}

variable: kovolume(0);

value1=(close+high+low)/3;

if CurrentBar = 1 then

kovolume = 0

else begin

if value1 \> value1\[1\] then

kovolume = kovolume\[1\] + volume

else begin

if value1 \< value1\[1\] then

kovolume = kovolume\[1\] - volume

else

kovolume = kovolume\[1\];

end;

end;

Plot1(kovolume, \"KO能量潮指標\");

#### 📄 K棒衍生指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/雙k棒可以延伸的多空趨勢指標/

}

array:k\[22\](0);

if close\<\>0 then begin

//最近一日與前一日的多空力道總差額

k\[1\]=(open-open\[1\])/close;

k\[2\]=(high-high\[1\])/close;

k\[3\]=(low-low\[1\])/close;

k\[4\]=(close-close\[1\])/close;

//當日

k\[5\]=(high-low)/close;

k\[6\]=(high-close)/close;

k\[7\]=(high-open)/close;

k\[8\]=(open-low)/close;

k\[9\]=(close-open)/close;

k\[10\]=(close-low)/close;

k\[11\]=(open-high\[1\])/close;

k\[12\]=(open-low\[1\])/close;

k\[13\]=(open-close\[1\])/close;

k\[14\]=(high-open\[1\])/close;

k\[15\]=(high-low\[1\])/close;

k\[16\]=(high-close\[1\])/close;

k\[17\]=(low-open\[1\])/close;

k\[18\]=(low-high\[1\])/close;

k\[19\]=(low-close\[1\])/close;

k\[20\]=(close-open\[1\])/close;

k\[21\]=(close-high\[1\])/close;

k\[22\]=(close-low\[1\])/close;

end;

array: v1\[8\](0);

v1\[1\]=k\[1\]+k\[11\]+k\[12\]+k\[13\];//隔日開盤多空總力道

v1\[2\]=k\[1\]+k\[2\]+k\[3\]+k\[4\];//隔日多空總力道

v1\[3\]=k\[20\]+k\[21\]+k\[22\];//隔日收盤多空結果

v1\[4\]=k\[9\]+k\[10\]-k\[6\];//當日收盤多空結果

v1\[5\]=k\[14\]+k\[15\]+k\[16\];//多頭最大力量

v1\[6\]=(k\[17\]+k\[18\]+k\[19\])\*-1;//空頭最大力量

v1\[7\]=k\[7\]+k\[9\]+k\[10\];//當日多頭最大力量

v1\[8\]=k\[6\]+k\[8\]-k\[10\];//當日空頭最大力量

value1=v1\[1\]+v1\[2\]+v1\[3\]+v1\[4\];

value2=v1\[5\]+v1\[7\];

value3=v1\[6\]+v1\[8\];

plot1(average(value1,5),\"多空淨力\");

plot2(average(value2,5),\"多頭總力\");

plot3(average(value3,5),\"空頭總力\");

#### 📄 LRR線性迴歸反轉指標

{@type:indicator}

input:period(10,\"期數\");

variable:lrr(0);

value1=linearregslope(close,period);

if value1\>value1\[1\] then

lrr=1

else

lrr=-1;

plot1(lrr,\"線性迴歸反轉指標\");

#### 📄 MFO資金流震盪指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/大盤多空轉換點之探討系列三-mfo資金流震盪指標/

}

input:period(20,\"計算天期\");

if ((high-low\[1\])+(high\[1\]-low)) \<\> 0 then

value1=
((high-low\[1\])-(high\[1\]-low))/((high-low\[1\])+(high\[1\]-low))\*volume

else

value1=value1\[1\];

value2= summation(value1,period)/summation(volume,period);

plot1(value2,\"MFO資金流震盪指標\");

#### 📄 MF錢流指標

{@type:indicator}

INPUT:N(10,\"期數\");

variable: AP(0),tv(0),UTV(0),DTV(0),MF(0),UP(0),DN(0);

ap=(high+low+close)/3;

tv=ap\*volume;

if ap\>ap\[1\] then begin

utv=tv;

dtv=0;

end else begin

utv=0;

dtv=tv;

end;

up=UP\[1\]+(UTV-UP\[1\])/N;

DN=DN\[1\]+(DTV-DN\[1\])/N;

IF DN\<\>0 THEN

MF=100-(100/(1+UP/DN))

else

MF=MF\[1\];

PLOT1(MF,\"MF\");

#### 📄 Mass Index

{@type:indicator}

input: length1(9); setinputname(1, \"天期一\");

input: length2(25); setinputname(2, \"天期二\");

value1 = average(range,length1);

value2 = average(value1,length1);

if value2 = 0 then value3 = 0 else value3 = value1/value2;

value4 = summation(value3,length2);

plot1(value4,\"Mass Index\");

#### 📄 N日來漲幅較大天數

{@type:indicator}

{

指標說明

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 327頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

input:ratio(2,\"列入計算之漲幅下限\");

input:period(20,\"計算區間\");

input:period1(10,\"移動平均天數\");

if close\[1\]\<\>0 then

value1=(close-close\[1\])/close\[1\]\*100;

value2=countif(value1\>=ratio,period);

plot1(value2,\"漲幅大的天數\");

plot2(average(value2,period1),\"移動平均\");

#### 📄 N日內上漲天數

{@type:indicator}

input:length(20,\"期數\");

variable:count(0);

variable:x1(0);

count=countif(close\>close\[1\],length);

plot1(count,\"上漲天數\");

#### 📄 RunScore

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/Runscore指標/

}

input:QDate(20140630,\"起算日\");

//先設定一個季結束的日子

variable:RunScore(0),vs(0),i(0);

if date \> QDate then begin

if C\>C\[1\] then RunScore += 1;//收漲加1分

if H\>H\[1\] then RunScore += 1;//漲過昨高加1分

if C\>H\[1\] then RunScore += 1;//收過昨高加1分

if C\<C\[1\] then RunScore -= 1;//收跌扣1分

if L\<L\[1\] then RunScore -= 1;//破昨低扣1分

if C\<L\[1\] then RunScore -= 1;//收破昨低扣1分

vs += v;

i += 1;

end;

plot1( RunScore,\"漲跌分數\");

#### 📄 R平方

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/趨勢檢定器/

}

input:Length(20,\"計算期間\");

LinearReg(close, Length, 0, value1, value2, value3, value4);

//做收盤價20天線性回歸

{value1:斜率,value4:預期值}

value5=rsquare(close,value4,Length);//算收盤價與線性回歸值的R平方

plot1(value5,\"R平方\");

plot2(0.2,\"趨勢成形線\");

#### 📄 Stoller平均波幅通道

{@type:indicator}

input:

avlength(5,\"均線期數\"),

atrlength(15,\"ATR平均期數\"),

k(1.35,\"常數\");

variable:hband(0),lband(0);

hband=average(close,avlength)+average(truerange,atrlength)\*k;

lband=average(close,avlength)-average(truerange,atrlength)\*k;

plot1(hband,\"通道上限\");

plot2(close,\"收盤價\");

plot3(lband,\"通道下限\");

#### 📄 ZDZB築底指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/築底指標-2/

}

input:

period(125,\"計算期數\"),

length1(5,\"短MA期數\"),

length2(20,\"長MA期數\");

variable:zd(0),zdma1(0),zdma2(0);

zd=countif(close\>=close\[1\],period)/countif(close\<close\[1\],period);

zdma1=average(zd,length1);

zdma2=average(zd,length2);

plot1(zdma1,\"短天期築底指標\");

plot2(zdma2,\"長天期築底指標\");

plot3(1,\"多空分界\");

#### 📄 Zero Lag Heikin-Ashi

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/先進指標zero-lag-heikinashi/

}

input: Length(14,\"期數\");

variable:

price(0), haO(0), haC(0), haMax(0), haMin(0),

TEMA1(0), EMAValue1(0), DbEMAValue1(0),

TEMA2(0), EMAValue2(0), DbEMAValue2(0), ZeroLagHA(0);

price = (close+open+high+low)/4;

haO = (haO\[1\]+price)/2;

haMax = maxlist(high, haO);

haMin = minlist(low, haO);

haC = (price+haO+haMax+haMin)/4;

EMAValue1 = xaverage(haC, Length);

DbEMAValue1 = xaverage(EMAValue1, Length);

TEMA1 = 3\*EMAValue1-3\*DbEMAValue1+xaverage(DbEMAValue1, Length);

EMAValue2 = xaverage(TEMA1, Length);

DbEMAValue2 = xaverage(EMAValue2, Length);

TEMA2 = 3\*EMAValue2-3\*DbEMAValue2+xaverage(DbEMAValue2, Length);

ZeroLagHA = 2\*TEMA1-TEMA2;

plot1(ZeroLagHA, \"Zero Lag HeikinAshi\");

plot2(average(C,20),\"Average\");

#### 📄 adaptive price zone

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/adaptive-price-zone/

}

input:

Length(14,\"期數\"),

BandPct(2.0,\"通道寬度\");

variable: DSEMA(0), UpBand(0), DownBand(0), RangeEMA(0), period(0),
var0(0);

period = squareroot(Length);

DSEMA = xaverage(xaverage(close, period), period);

RangeEMA = xaverage(xaverage(high-low, period), period);

UpBand = DSEMA + BandPct\*RangeEMA;

DownBand = DSEMA - BandPct\*RangeEMA;

Plot1(UpBand, \"Upperband\");

Plot2(close, \"Close\");

Plot3(DownBand, \"BottomBand\");

#### 📄 ado聚散擺盪平均線

{@type:indicator}

input:period(10,\"移動平均線天期\");

value1=average(ado,period);

plot1(value1,\"ado聚散擺盪平均線\");

#### 📄 bandpass filter

{@type:indicator}

input:

period(20),

delta(0.1);

variable: price(0),gamma(0),alpha(0),beta(0),BP(0);

price=(h+l)/2;

beta=cosine(360/period);

gamma=1/cosine(720\*delta/period);

alpha=gamma-squareroot(gamma\*gamma-1);

BP=0.5\*(1-alpha)\*(price-price\[2\])+beta\*(1+alpha)\*BP\[1\]-alpha\*BP\[2\];

plot1(BP);

plot2(0);

#### 📄 bband當沖操作指標

{@type:indicator}

input:length(30,\"期數\");

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

variable:dayprofit(0),accprofit(0);

up1 = bollingerband(Close\[1\], Length, 2);

down1 = bollingerband(Close\[1\], Length, -2 );

if open\*1.01\>up1 then begin

dayprofit=open-close;

end else if down1\*1.01\>open then begin

dayprofit=close-open;

end else

dayprofit=0;

accprofit=accprofit\[1\]+dayprofit;

plot1(accprofit,\"累計獲利\");

#### 📄 coppock indicator

{@type:indicator}

variable:coppock(0);

value1=rateofchange(close,14);

value2=rateofchange(close,11);

value3=value1+value2;

value4=xaverage(value3,10);

plot1(value4,\"coppock indicator\");

#### 📄 demand index

{@type:indicator}

{

James Sibbet\'s Demand Index Indicator

The Demand Index combines price and volume in

such a way that it is often a leading indicator of

price change.

}

input: Length (10,\"期數\");

variable :

WtCRatio(1), VolRatio(1), VolAvg(Volume),

bu(1), sel(1), Sign1(+1),

WghtClose(Close), AvgTR(High - Low),

Constant(1), bures(1), selres(1),

TempDI(1), DMI(1);

If CurrentBar = 1 then

VolAvg = Average(Volume, Length);

WghtClose = (High + Low + Close + Close) \* 0.25;

AvgTR = Average (Highest (High, 2) - Lowest ( Low, 2), Length);

VolAvg = ((VolAvg \[1\] \* (Length - 1)) + Volume) / Length;

If WghtClose \<\> 0 and WghtClose\[1\] \<\> 0 and

AvgTR \<\> 0 and VolAvg \<\> 0 then Begin

WtCRatio = (WghtClose - WghtClose\[1\]) /
MinList(WghtClose,WghtClose\[1\]) ;

VolRatio = Volume / VolAvg;

Constant = ((WghtClose \* 3) /AvgTR) \* AbsValue (WtCRatio);

If Constant \> 88 then Constant = 88;

Constant = VolRatio / ExpValue (Constant);

If WtCRatio \> 0 then Begin

bu = VolRatio;

sel = Constant;

End Else Begin

bu = Constant;

sel = VolRatio;

End;

bures = ((bures \[1\] \* (Length - 1)) + bu) / Length;

selres = ((selres \[1\] \* (Length - 1)) + sel) / Length;

TempDI = +1;

If selres \> bures then Begin

Sign1 = -1;

If selres \<\> 0 then TempDI = bures / selres;

End Else Begin

Sign1 = +1;

If bures \<\> 0 then TempDI = selres / bures;

End;

TempDI = TempDI \* Sign1;

If TempDI \< 0 then

DMI = -1 - TempDI

else

DMI = +1 - TempDI ;

End;

Plot1(dmi);

#### 📄 ease of movement指標

{@type:indicator}

input:

length1(9,\"一次平滑期數\"),

length2(9,\"二次平滑期數\");

value1=(high+low)/2;

value2=value1-value1\[1\];

value3=volume/(high-low);

value4=value2/value3;

value5=average(value4,length1);

value6=average(value5,length2);

plot1(value5,\"EMV\");

plot2(value6,\"EMV-MA\");

#### 📄 empirical mode decomposition

{@type:indicator}

input:

period(20),

delta(0.1),

fraction(0.1);

variable:

price(0),gamma(0),alpha(0),beta(0),BP(0),

mean(0),peak(0),valley(0),avgpeak(0),avgvalley(0);

price=(h+l)/2;

beta=cosine(360/period);

gamma=1/cosine(720\*delta/period);

alpha=gamma-squareroot(gamma\*gamma-1);

BP=0.5\*(1-alpha)\*(price-price\[2\])+beta\*(1+alpha)\*BP\[1\]-alpha\*BP\[2\];

mean=average(bp,2\*period);

peak=peak\[1\];

valley=valley\[1\];

if bp\[1\]\>bp and bp\[1\]\>bp\[2\] then peak=bp\[1\];

if bp\[1\]\<bp and bp\[1\]\<bp\[2\] then valley=bp\[1\];

avgpeak=average(peak,50);

avgvalley=average(valley,50);

plot1(mean);

plot2(fraction\*avgpeak);

plot3(fraction\*avgvalley);

#### 📄 extracting the trend

{@type:indicator}

input:

period(20),

delta(0.1);

variable: price(0),gamma(0),alpha(0),beta(0),BP(0),trend(0);

price=(h+l)/2;

beta=cosine(360/period);

gamma=1/cosine(720\*delta/period);

alpha=gamma-squareroot(gamma\*gamma-1);

BP=0.5\*(1-alpha)\*(price-price\[2\])+beta\*(1+alpha)\*BP\[1\]-alpha\*BP\[2\];

trend=average(bp,2\*period);

plot1(trend);

plot2(0);

#### 📄 range trading指標

{@type:indicator}

value1=average(range,200);

value2=average(range,3);

value3=(value2-value1)/value1;

plot1(value3,\"長短天期range差\");

#### 📄 vortex indicator

{@type:indicator}

input: period(14,\"設定區間\");

variable:pvm(0);

variable:nvm(0);

pvm=absvalue(high-low\[1\]);

nvm=absvalue(low-high\[1\]);

value1=summation(pvm,period);

value2=summation(nvm,period);

value3=summation(truerange,period);

value4=value1/value3;

value5=value2/value3;

value6=value4-value5;

plot1(value6,\"vortex\");

#### 📄 上影線佔實體比例五日平均

{@type:indicator}

value1=average(upshadow,5);

plot1(value1,\"五日平均上影線佔實體比例\");

#### 📄 上漲下跌幅度強弱度指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/雲端策略中心精進版之34多頭轉強策略/

}

input:length(10,\"期數\");

variable: sumUp(0), sumDown(0), up(0), down(0),RS(0);

if CurrentBar = 1 then begin

sumUp = Average(maxlist(close - close\[1\], 0), length);

sumDown = Average(maxlist(close\[1\] - close, 0), length);

end else begin

up = maxlist(close - close\[1\], 0);

down = maxlist(close\[1\] - close, 0);

sumUp = sumUp\[1\] + (up - sumUp\[1\]) / length;

sumDown = sumDown\[1\] + (down - sumDown\[1\]) / length;

end;

if sumdown\<\>0 then rs=sumup/sumdown;

plot1(rs,\"強弱度\");

#### 📄 上漲下跌角度線

{@type:indicator}

input: periods(5, \"期數\");

Value1 = Angle(Date\[periods\], Date);

Plot1(Value1, \"角度\");

#### 📄 上漲天數指標

{@type:indicator}

input:count1(20);

input:count2(10);

value1=countif(close\>close\[1\],count1);

value2=countif(close\>close\[1\],count2);

value3=value1-value2;

plot1(value1);

plot2(value2);

plot3(value3);

#### 📄 主動買力

{@type:indicator}

input:p1(5,\"短天期\");

input:p2(20,\"長天期\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"主動買力\");

value2=average(value1,p1);

value3=average(value1,p2);

plot1(value2,\"主動買力短天期MA\");

plot2(value3,\"主動買力長天期MA\");

#### 📄 倉 put call ratio

{@type:indicator}

//台指選擇權現貨(TXO00.TF) 的 買賣權未平倉量比率

value1=GetSymbolField(\"TXO00.TF\", \"買賣權未平倉量比率\");

plot1(value1,\"put call ratio\");

#### 📄 價格震盪指標

{@type:indicator}

input: length1(5); setinputname(1, \"短天期\");

input: length2(20); setinputname(2, \"長天期\");

value1 = average(close, length1);

value2 = average(close, length2);

if value1 = 0 then value3 = 0 else value3 = 100 \* (value1 - value2) /
value1;

plot1(value3, \"OSCP\");

#### 📄 價量斜率指標

{@type:indicator}

value1=average(close,5);

value2=average(volume,5);

value3=linearregslope(value1,5);

value4=linearregslope(value2,5);

value5=value4-value3;

plot1(value3,\"價斜率\");

plot2(value4,\"量斜率\");

plot3(value5,\"斜率差\");

#### 📄 價量齊揚天數

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/從相對的角度尋找真正價量齊揚的股票/

}

input:sp(10,\"短計算區間\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable:count1(0) ;

value1=GetField(\"資金流向\");

value2=GetField(\"強弱指標\");

count1=countif(value2\>0and value1\>value1\[1\],sp);

value3=average(count1,5);

plot1(value3/SP\*100,\"短期價量齊揚天數\");

#### 📄 六合神拳指數

{@type:indicator}

input:length1(6,\"短天期RSI參數\");

input:length2(10,\"長天期RSI參數\");

input:length3(10,\"MTM天期\");

input:length4(10,\"DMI天期\");

variable:count(0);

count=0;

if RSI(Close, Length1) \> RSI(Close, Length2)

and rsi(close,length1)\<50 then

count=1;

if Momentum(Close, Length3) \> 0 then

count=count+1;

variable:pdi_value(0);

variable:ndi_value(0);

variable:adx_value(0);

directionmovement(length4,pdi_value,ndi_value,adx_value);

if pdi_value \> ndi_value then

count=count+1;

variable:rsv1(0),k1(0),d1(0);

stochastic(9,3,3,rsv1,k1,d1);

if k1 \> d1 then

count=count+1;

value1=average(volume,10);

if linearregslope(value1,8)\>0 then

count=count+1;

value2=average(close,8);

if linearregslope(value2,5)\>0 then

count=count+1;

plot1(count,\"分數\");

#### 📄 創新高天數減破底天數

{@type:indicator}

input:period(12,\"期數\");

value1=countif(low\<lowest(low\[1\],period),period);//近期創新低天數

value2=countif(high\>highest(high\[1\],period),period);//近期創新高天數

value3=value2-value1;

plot1(value3,\"天數差\");

plot2(3);

plot3(-3);

#### 📄 力度指標force index

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/這個盤接下來到底會不會大跌-建構專屬的大盤儀/

}

input:

length(10,\"短天期\"),

length1(30,\"長天期\");

variable:fis(0),fil(0);

fis=average(volume\*(close-close\[1\]),length);

fil=average(volume\*(close-close\[1\]),length1);

plot1(fis,\"短期力度\");

plot2(fil,\"長期力度\");

plot3(fis-fil,\"長短力度差\");

#### 📄 加速器指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/495/

}

variable:Xslope(0);

Xslope = linearregslope((H+L)/(H+L)\[20\],20);

plot1(Xslope,\"方向速度\" );

plot2(Xslope-Xslope\[1\],\"速度變化\");

#### 📄 加速指標

{@type:indicator}

input:period1(5,\"計算天期\");

input:period2(9,\"MA天期\");

variable:aspeed(0),dspeed(0),a1(0),d1(0),p1(0),ap1(0);

if close\>close\[1\] then

aspeed=(close-close\[1\])/close\*100

else

aspeed=0;

if close\<close\[1\] then

dspeed=(close\[1\]-close)/close\*100

else

dspeed=0;

a1=average(aspeed,period1);

d1=average(dspeed,period1);

p1=a1-d1;

ap1=average(p1,period2);

plot1(p1,\"加速度\");

plot2(ap1,\"移動平均\");

#### 📄 勁道指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/積極勁道指標/

}

input:day(13,\"期數\");

if barfreq = \"Tick\" or barfreq = \"Min\" then

begin

value1=GetField(\"外盤量\");//單位:元

value6=GetField(\"內盤量\");//單位:元

end else begin

value1=GetField(\"外盤量\",\"D\");//單位:元

value6=GetField(\"內盤量\",\"D\");//單位:元

end;

value2=volume\*(close-close\[1\]);

value8=average(volume,day);

if value6\<\>0 then

value7=(value1/value6)\*volume\*(close-close\[1\]);

value3=value7\*(close-close\[1\]);

value4=average(value2,day)/value8;

value5=average(value3,day)/value8;

plot1(value4,\"勁道指標\");

plot2(value5,\"積極勁道指標\");

#### 📄 動量指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/尋找趨勢是否成形的指標動量指標/

}

if barfreq = \"Tick\" or barfreq = \"Min\" then

begin

value1=GetField(\"內盤量\");//單位:元

value2=GetField(\"外盤量\");//單位:元

end else begin

value1=GetField(\"內盤量\",\"D\");//單位:元

value2=GetField(\"外盤量\",\"D\");//單位:元

end;

value3=(high+low)/2;//計算當天波動的平均價位

//質量就是內外盤差乘均價

if value2\>value1 then

value4=value3\*(value2-value1)

else

value4=value3\*(value1-value2);

if close\>=close\[1\] then begin //(方向是往上)

value5=(close-close\[1\])/close\[1\]\*value4;//質量乘以速度

value6=0;

end else begin//(方向是往下)

value5=0;

value6=(close\[1\]-close)/close\[1\]\*value4;

end;

value8=average(value5,2);

value9=average(value6,2);

value10=value8-value9;

plot1(value10,\"動能差\");

#### 📄 向上拉動與向下殺盤力道指標

{@type:indicator}

input:period(5,\"加權移動平均線天期\");

//當日向上拉動的力量

value1=(high-open)+(close-low);

//當日向下殺盤的力量

value2=(open-low)+(high-close);

if close\<\>0 then begin

//上拉力道

value3=average(value1,period)/close\*100;

//下殺力道

value4=xaverage(value2,period)/close\*100;

end;

value5=value3-value4;

plot1(value5,\"上拉下殺淨力道\");

#### 📄 外盤成交比例指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/外盤成交比例指標/

}

input:

short1(5,\"短期平均\"),

mid1(12,\"長期平均\");

if barfreq = \"Tick\" or barfreq = \"Min\" then

begin

value1=GetField(\"內盤量\");//單位:元

value2=GetField(\"外盤量\");//單位:元

end else begin

value1=GetField(\"內盤量\",\"D\");//單位:元

value2=GetField(\"外盤量\",\"D\");//單位:元

end;

value3=value1+value2;

if value3\<\>0 then

value4=value2/value3\*100;

value5=average(value4,short1);

value6=average(value4,mid1);

plot1(value5,\"短期均線\");

plot2(value6,\"長期均線\");

#### 📄 多方力道線

{@type:indicator}

input:

period1(10,\"計算期數\"),

period2(5,\"平滑期數\");

value1=summation(high-close,period1);//上檔賣壓

value2=summation(close-open,period1); //多空實績

value3=summation(close-low,period1);//下檔支撐

value4=summation(open-close\[1\],period1);//隔夜力道

if close\<\>0 then

value5=(value2+value3+value4-value1)/close;

value6=average(value5,period2);

plot1(value6,\"多方力道\");

#### 📄 多空判斷分數

{@type:indicator}

value1 = techscore;

plot1(value1, \"多空指標\");

plot2(3, \"低點\");

plot3(11, \"高點\");

#### 📄 多空力道指標

{@type:indicator}

input: length(5); setinputname(1, \"天期\");

Value1 = high - close;

Value2 = close - low;

Value3 = average(Value1,length);

Value4 = average(Value2,length);

plot1(Value4 - Value3, \"力道\");

#### 📄 多頭動能

{@type:indicator}

input:period(10,\"平均值天期\");

value1=high-close\[1\]+low-low\[1\];

value2=average(value1,period);

plot1(value2,\"多頭動能平均值\");

#### 📄 天羅地網線

{@type:indicator}

input:period(60,\"期數\");

value5=average(close,period);

value6=standarddev(close,period,1);

value7=value5+value6;

value8=value5+2\*value6;

value9=value5-value6;

value10=value5-2\*value6;

plot1(value8,\"+2SD\");

plot2(value7,\"+1SD\");

plot3(value5,\"MA\");

plot4(value9,\"-1SD\");

plot5(value10,\"-2SD\");

#### 📄 循環指標

{@type:indicator}

input:period(20);

input:delta(0.5);

input:fraction(0.1);

variable:price(0);

variable:alpha(0),beta(0),gamma(0),bp(0),i(0),mean(0),peak(0),valley(0),avgpeak(0),avgvalley(0);

price=(h+l)/2;

beta=cosine(360/period);

gamma=1/cosine(720\*delta/period);

alpha=gamma-squareroot(gamma\*gamma-1);

bp=0.5\*(1-alpha)\*(price-price\[2\])+beta\*(1+alpha)\*bp\[1\]-alpha\*bp\[2\];

mean=average(bp,2\*period);

peak=peak\[1\];

valley=valley\[1\];

if bp\[1\]\>bp and bp\[1\]\>bp\[2\] then peak=bp\[1\];

if bp\[1\]\<bp and bp\[1\]\<bp\[2\] then valley=bp\[1\];

avgpeak=average(peak,50);

avgvalley=average(valley,50);

plot1(mean);

#### 📄 月線與收盤價差

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/自訂指標/

}

value1=average(close,22);

value2=close-value1;

value3=average(value2,3);

plot1(value3,\"月線與收盤價差三日移動平均\");

plot2(0);

#### 📄 比大盤強的天數

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/股性系列之七-比大盤強的天數/

}

input:day(10,\"統計天數\");

input:period(20,\"平滑天數\");

if barfreq \<\> \"D\" then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"強弱指標\");

value2=countif(value1\>1,day);

value3=average(value2,period);

plot1(Value2,\"比大盤強的天數\");

plot2(value3,\"移動平均\");

#### 📄 比大盤強的天數趨勢斜率

{@type:indicator}

input:period(10,\"計算天期\");

if barfreq \<\> \"D\" then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"強弱指標\");

value2=countif(value1\>1,period);

value3=average(value2,period);

linearreg(value3,period,0,value4,value5,value6,value7);

plot1(value4,\"強度斜率\");

#### 📄 波動區間指標

{@type:indicator}

input:

short1(3,\"短期平均\"),

mid1(20,\"長期平均\");

value1=highest(high,5);

value2=lowest(low,5);

if value2 \<\> 0 then

value3=(value1-value2)/value2\*100;

value4=average(value3,short1);

value5=average(value3,mid1);

plot1(value4,\"短期平均區間\");

plot2(value5,\"長期平均區間\");

#### 📄 波動率指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/918/

}

value1 = 100\*(average(H/L-1,20)+standarddev(H/L-1,20,1)\*3);

value2 = value1- average(value1,10);

plot1(value1,\"波動指標\");

if value2\> 0 then plot2(value2,\"波動放大\");

if value2\<= 0 then plot3(value2,\"波動縮小\");

#### 📄 淨買賣力指標

{@type:indicator}

input: Period(20,\"期數\");

if high\<\>low and truerange \<\> 0 then begin

value1=((high-open)+(close-low))/truerange;

value2=((open-low)+(high-close))/truerange;

end else begin

value1=value1\[1\];

value2=value2\[1\];

end;

value3=value1-value2;

value4=average(value3,Period);

plot1(value4,\"平均淨買賣力\");

#### 📄 真實波動區間指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/股性系列之六真實波動區間/

}

input: Length1(3, \"短天數\");

input: Length2(20,\"長天數\");

value1 = Average(TrueRange, Length1);

value2 = Average(TrueRange, Length2);

Plot1(value1, \"短期ATR\");

plot2(value2, \"長期ATR\");

#### 📄 短線交易比例

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/短線過熱的指標/

}

input:p1(5,\"移動平均線天期\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"融資買進張數\");

value2=GetField(\"現股當沖張數\");

value3=GetField(\"資券互抵張數\");

value4=value1+value2+value3;

if volume\>0 then

value5=value4/volume;

value6=average(value5,p1);

plot1(value5,\"短線交易比例\");

plot2(value6,\"移動平均線\");

#### 📄 終極擺盪指標

{@type:indicator}

input:length1(7); setinputname(1, \"天期一\");

input:length2(14); setinputname(2, \"天期二\");

input:length3(28); setinputname(3, \"天期三\");

variable : ruo(0),uo(0),bp(0);

bp = close-truelow;

Value1=summation(bp,length1);

Value2=summation(bp,length2);

Value3=summation(bp,length3);

Value4=summation(truerange,length1);

Value5=summation(truerange,length2);

Value6=summation(truerange,length3);

ruo = (value1/value4)\*4+(value2/value5)\*2+(value3/value6);

uo= ruo / 7 \* 100;

plot1(uo, \"UO\");

#### 📄 線性迴歸斜率

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/尋找目前趨勢還向上的股票/

}

input:Length(20,\"計算期間\");

variable: \_Output(0);

LinearReg(close, Length, 0, value1, value2, value3, value4);

{value1:斜率,value4:預期值}

plot1(value1,\"線性迴歸斜率\");

#### 📄 股性綜合分數指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/把股性拿來作為過濾條件/

}

input:day(20);

input:ratio(10);

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable:count(0),x(0);

value1=GetField(\"總成交次數\",\"D\");

value2=average(value1,day);

value3=GetField(\"強弱指標\");

value5=GetField(\"外盤均量\");

value6=average(value5,day);

value7=GetField(\"主動買力\");

value8=average(value7,day);

value9=GetField(\"開盤委買\");

value10=average(value9,day);

value11=GetField(\"資金流向\");

value12=average(value11,day);

value13=countif(value3\>1,day);

value14=average(value13,day);//比大盤強天數

value16=GetField(\"法人買張\");

count=0;

if value1\>value2\*(1+ratio/100) then count=count+1;

//比大盤強的天數

if value13\>value14\*(1+ratio/100) then count=count+1;

if value5\>value6\*(1+ratio/100) then count=count+1;

if value7\>value8\*(1+ratio/100) then count=count+1;

if value9\>value10\*(1+ratio/100) then count=count+1;

//真實波動區間

if truerange\> average(truerange,20) then count=count+1;

//計算承接的力道

if truerange\<\>0 then begin

if close\<=open then

value15=(close-low)/truerange\*100

else

value15=(open-low)/truerange\*100;

end;

if value15 \> average(value15,day)\*(1+ratio/100) then count=count+1;

//法人買張佔成交量比例

if volume\<\>0 then value17=value16/volume\*100;

if value17\>average(value17,10)\*(1+ratio/100) then count=count+1;

if value11\>average(value11,10)\*(1+ratio/100) then count=count+1;

value18=countif(close\>=close\[1\]\*1.02,5);

//N日來漲幅較大的天數

if value18 \>= 2 then count=count+1;

value19=GetField(\"融資買進張數\");

value20=GetField(\"融券買進張數\");

value21=(value19+value20);

value22=average(value21,day);

//散戶作多指標

if value21\<value22\*0.9 then count=count+1;

plot1(average(count,3),\"股性綜合分數指標\");

plot2(3);

#### 📄 蔡金波動指標

{@type:indicator}

input:length(9,\"期數\");

variable:REMA(0),cv1(0);

if currentbar=1 then begin

cv1=0;

end else if range\<\>0 then begin

REMA=xaverage(range,length);

if rema\[length-1\]=0 then

cv1=cv1\[1\]

else

cv1=(REMA-REMA\[length-1\])/rema\[length-1\];

end;

plot1(cv1,\"波動率\");

#### 📄 變異數指標

{@type:indicator}

input:length1(10,\"短天期期別\");

input:length2(20,\"長天期期別\");

value1=varianceps(close,length1,1);

value2=varianceps(close,length2,1);

plot1(value1,\"短天期變異數\");

plot2(value2,\"長天期變異數\");

#### 📄 逢低承接的力道

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/短線止跌的訊號/

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 324頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

input:

short1(5,\"短期平均\"),

mid1(20,\"長期平均\");

if truerange\<\>0 then begin

if close\<=open then

value1=(close-low)/truerange\*100

else

value1=(open-low)/truerange\*100;

end;

value2=average(value1,short1);

value3=average(value2,mid1);

plot1(value2,\"短期均線\");

plot2(value3,\"長期均線\");

#### 📄 進攻力道線

{@type:indicator}

input:period(5,\"期別\");

value1=summationif(close\>close\[1\],high-close\[1\],period);

plot1(value1,\"進攻力道線\");

#### 📄 隨機漫步指標

{@type:indicator}

input:length(10); setinputname(1, \"天期\");

variable:RWIH(0),RWIL(0);

value1 = standarddev(close,length,1);

value2 = average(truerange,length);

RWIH = (high-low\[length-1\])/value2\*value1;

RWIL = (high\[length-1\]-low)/value2\*value1;

plot1(RWIH - RWIL, \"RWI\");

#### 📄 順勢指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/為自己的觀察名單標上交易訊號/

}

input:

length1(5,\"短期平均\"),

length2(10,\"長期平均\");

variable:bp1(0),abp1(0),abp2(0);

bp1=(close-close\[1\])/truerange\*100;

abp1=average(bp1,length1);

abp2=average(bp1,length2);

plot1(abp1,\"短期平均\");

plot2(abp2,\"長期平均\");

### 2.8 期權指標 (24 個)

#### 📄 Delta

{@type:indicator}

plot1(GetField(\"Delta\"),\"Delta\");

#### 📄 Gamma

{@type:indicator}

plot1(GetField(\"Gamma\"),\"Gamma\");

#### 📄 Theta

{@type:indicator}

plot1(GetField(\"Theta\"),\"Theta\");

#### 📄 Vega

{@type:indicator}

plot1(GetField(\"Vega\"),\"Vega\");

#### 📄 三大法人交易金額

{@type:indicator}

if symbolType\<\>3 and symbolType\<\>5 then
raiseRunTimeError(\"僅支援期權\");

if SymbolExchange \<\> \"TF\" then
raiseRunTimeError(\"僅支援台灣市場\");

if barFreq\<\>\"d\" then raiseRunTimeError(\"僅支援日線\");

value1 = getField(\"三大法人交易買進金額\");

value2 = getField(\"三大法人交易賣出金額\");

value3 = value1 - value2;

plot1(value1,\"三大法人交易買進金額\");

plot2(value2,\"三大法人交易賣出金額\");

plot3(value3,\"三大法人交易淨額\");

#### 📄 價內外

{@type:indicator}

variable:vRatio(0);

if symboltype \<\> 5 then

raiseruntimeerror(\"僅支援選擇權\");

vRatio =
iff(leftstr(getsymbolinfo(\"買賣權\"),1)=\"C\",1,-1)\*(100\*getsymbolfield(\"Underlying\",\"收盤價\")/getsymbolinfo(\"履約價\")-100);

plot1(vRatio,\"價內外%\");

#### 📄 價差

{@type:indicator}

condition999 = symbolexchange = \"TF\";//期貨

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TF\" and symboltype = 5;//選擇權

if (condition999 = false and condition994 = true) or symbolType = 5
//僅支援期貨

then raiseruntimeerror(\"不支援此商品\");

if symbolexchange = \"TF\" and symboltype = 3 then //期貨

value1 = GetSymbolField(\"Underlying\", \"收盤價\");

plot1(close-value1,\"價差\");

#### 📄 台指選Delta

{@type:indicator}

input:

iRate100(2,\"無風險利率%\"),

iVolity100(20,\"波動率%\"),

iHV(false, \"波動率\",
inputkind:=dict(\[\"標的20日歷史波動率\",true\],\[\"固定波動率\",false\]));

variable:vStrikePrice(0),vVolity100(0);

if instr(symbol,\".TF\") = 0 or leftstr(symbol,1) = \"F\" or
instr(symbol,\"TX\") = 0 then

raiseruntimeerror(\"僅支援台指選擇權\");

if iHV then

vVolity100 =
HVolatility(getsymbolfield(\"FITX\*1.TF\",\"收盤價\",\"D\"),20)

else

vVolity100 = iVolity100;

vStrikePrice = getsymbolinfo(\"履約價\");

value1 =
bsdelta(leftstr(getsymbolinfo(\"買賣權\"),1),getsymbolfield(\"FITX\*1.TF\",\"收盤價\"),vStrikePrice,daystoexpirationtf,iRate100,0,vVolity100);

plot1(value1,\"Delta\");

#### 📄 台指選IV

{@type:indicator}

input:

iRate100(2,\"無風險利率%\");

variable:vStrikePrice(0);

if instr(symbol,\".TF\") = 0 or leftstr(symbol,1) = \"F\" or
instr(symbol,\"TX\") = 0 then

raiseruntimeerror(\"僅支援台指選擇權\");

vStrikePrice = getsymbolinfo(\"履約價\");

value1 =
ivolatility(leftstr(getsymbolinfo(\"買賣權\"),1),getsymbolfield(\"FITX\*1.TF\",\"收盤價\"),vStrikePrice,daystoexpirationtf,iRate100,0,c);

plot1(value1,\"隱含波動率%\");

#### 📄 台股指數近月外資未平倉

{@type:indicator}

value1 = getsymbolfield(\"FITX\*1.TF\",\"外資買方未平倉口數\");

value2 = getsymbolfield(\"FITX\*1.TF\",\"外資賣方未平倉口數\");

value3 = value1 - value2;

plot1(value1,\"外資未平倉買口\");

plot2(value2,\"外資未平倉賣口\");

plot3(value3,\"外資未平倉淨口\");

#### 📄 台股指數近月投信未平倉

{@type:indicator}

value1 = getsymbolfield(\"FITX\*1.TF\",\"投信買方未平倉口數\");

value2 = getsymbolfield(\"FITX\*1.TF\",\"投信賣方未平倉口數\");

value3 = value1 - value2;

plot1(value1,\"投信未平倉買口\");

plot2(value2,\"投信未平倉賣口\");

plot3(value3,\"投信未平倉淨口\");

#### 📄 台股指數近月自營商未平倉

{@type:indicator}

value1 = getsymbolfield(\"FITX\*1.TF\",\"自營商買方未平倉口數\");

value2 = getsymbolfield(\"FITX\*1.TF\",\"自營商賣方未平倉口數\");

value3 = value1 - value2;

plot1(value1,\"自營商未平倉買口\");

plot2(value2,\"自營商未平倉賣口\");

plot3(value3,\"自營商未平倉淨口\");

#### 📄 外資交易金額

{@type:indicator}

if symbolType\<\>3 and symbolType\<\>5 then
raiseRunTimeError(\"僅支援期權\");

if SymbolExchange \<\> \"TF\" then
raiseRunTimeError(\"僅支援台灣市場\");

if barFreq\<\>\"d\" then raiseRunTimeError(\"僅支援日線\");

value1 = getField(\"外資交易買進金額\");

value2 = getField(\"外資交易賣出金額\");

value3 = value1 - value2;

plot1(value1,\"外資交易買進金額\");

plot2(value2,\"外資交易賣出金額\");

plot3(value3,\"外資交易淨額\");

#### 📄 外資期權動態

{@type:indicator}

input:length(3,\"期數\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"外資交易買口\");

value2=GetField(\"外資交易賣口\");

value3=GetField(\"外資買方未平倉口數\");

value4=GetField(\"外資賣方未平倉口數\");

value5=value1-value2;//外資今日淨買賣口數

plot1(value5,\"外資今日淨買賣口數\");

plot2(average(value5,length),\"移動平均\");

#### 📄 委買委賣張數

{@type:indicator}

{指標數值定義：\"口數差 = 委買口數 - 委賣口數\"

支援商品：大盤/期貨/選擇權}

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" then

raiseruntimeerror(\"僅支援分鐘與日頻率\");

if condition994 then begin//大盤

value1 = GetField(\"累計委買\");

value2 = GetField(\"累計委賣\");

value3 = GetField(\"累計委買\") - GetField(\"累計委賣\");

plot1(value3,\"委買委賣口數差\");

plot2(value1,\"委買口數\",checkbox:=0);

plot3(value2,\"委賣口數\",checkbox:=0);

setplotlabel(1,\"委買委賣張數差\");

setplotlabel(2,\"委買張數\");

setplotlabel(3,\"委賣張數\");

end else begin//期貨與選擇權

value1 = GetField(\"累計委買\");

value2 = GetField(\"累計委賣\");

value3 = GetField(\"累計委買\") - GetField(\"累計委賣\");

plot1(value3,\"委買委賣口數差\");

plot2(value1,\"委買口數\",checkbox:=0);

plot3(value2,\"委賣口數\",checkbox:=0);

setplotlabel(1,\"委買委賣口數差\");

setplotlabel(2,\"委買口數\");

setplotlabel(3,\"委賣口數\");

end;

#### 📄 委買委賣筆數

{@type:indicator}

{指標數值定義：(委買)筆數 = 交易所資料(開盤到目前累計(委買)筆數)

for 大盤, 委買委賣資料不含權證, 多一個成交筆數

支援商品：大盤/期貨/選擇權}

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" then

raiseruntimeerror(\"僅支援分鐘與日頻率\");

if condition994 then begin//大盤

value1 = GetField(\"累委買筆\");

value2 = GetField(\"累委賣筆\");

value3 = GetField(\"累委買筆\") - GetField(\"累委賣筆\");

value4 = GetField(\"累成交筆\");

plot1(value3,\"委買委賣筆數差\");

plot2(value1,\"委買筆數\",checkbox:=0);

plot3(value2,\"委賣筆數\",checkbox:=0);

plot4(value4,\"累成交筆\");

end else begin//期貨與選擇權

value1 = GetField(\"累委買筆\");

value2 = GetField(\"累委賣筆\");

value3 = GetField(\"累委買筆\") - GetField(\"累委賣筆\");

plot1(value3,\"委買委賣筆數差\");

plot2(value1,\"委買筆數\",checkbox:=0);

plot3(value2,\"委賣筆數\",checkbox:=0);

noplot(4);

end;

#### 📄 投信交易金額

{@type:indicator}

if symbolType\<\>3 and symbolType\<\>5 then
raiseRunTimeError(\"僅支援期權\");

if SymbolExchange \<\> \"TF\" then
raiseRunTimeError(\"僅支援台灣市場\");

if barFreq\<\>\"d\" then raiseRunTimeError(\"僅支援日線\");

value1 = getField(\"投信交易買進金額\");

value2 = getField(\"投信交易賣出金額\");

value3 = value1 - value2;

plot1(value1,\"投信交易買進金額\");

plot2(value2,\"投信交易賣出金額\");

plot3(value3,\"投信交易淨額\");

#### 📄 摩台近月未平倉

{@type:indicator}

value1 = getsymbolfield(\"STW\*1.SG\",\"未平倉\");

plot1(value1,\"摩台近月未平倉\");

#### 📄 期貨散戶多空比

{@type:indicator}

variable: OI_all(0), OI_small_bull(0), OI_small_bear(0),
OI_small_ratio(0), OI_big_ratio(0);

OI_all = getsymbolfield(\"FITX\*1.TF\",\"未平倉\",\"D\")

\+ getsymbolfield(\"FITX\*2.TF\",\"未平倉\",\"D\")

\+ getsymbolfield(\"FIMTX\*1.TF\",\"未平倉\",\"D\") \* 0.25

\+ getsymbolfield(\"FIMTX\*2.TF\",\"未平倉\",\"D\") \* 0.25;

OI_small_bull = OI_all -
getsymbolfield(\"FITX\*1.TF\",\"十大交易人未沖銷買口\",\"D\");

OI_small_bear = OI_all -
getsymbolfield(\"FITX\*1.TF\",\"十大交易人未沖銷賣口\",\"D\");

if OI_small_bull + OI_small_bear = 0 then

OI_small_ratio = 0

else

OI_small_ratio = 100 \* OI_small_bull / (OI_small_bull +
OI_small_bear) - 50;

plot1(OI_small_ratio,\"散戶\");

#### 📄 溢價率

{@type:indicator}

variable:vRatio(0);

if symboltype \<\> 5 then

raiseruntimeerror(\"僅支援選擇權\");

vRatio = 100 \* (

iff(leftstr(getsymbolinfo(\"買賣權\"),1)=\"C\",1,-1) \*
(getsymbolinfo(\"履約價\") -
getsymbolfield(\"Underlying\",\"收盤價\")) + close)

/getsymbolfield(\"Underlying\",\"收盤價\");

plot1(vRatio,\"溢價率%\");

#### 📄 自營商交易金額

{@type:indicator}

if symbolType\<\>3 and symbolType\<\>5 then
raiseRunTimeError(\"僅支援期權\");

if SymbolExchange \<\> \"TF\" then
raiseRunTimeError(\"僅支援台灣市場\");

if barFreq\<\>\"d\" then raiseRunTimeError(\"僅支援日線\");

value1 = getField(\"自營商交易買進金額\");

value2 = getField(\"自營商交易賣出金額\");

value3 = value1 - value2;

plot1(value1,\"自營商交易買進金額\");

plot2(value2,\"自營商交易賣出金額\");

plot3(value3,\"自營商交易淨額\");

#### 📄 買賣成交筆數

{@type:indicator}

{指標數值定義：\"委買委賣成筆差 = 委賣成交筆數 - 委買成交筆數\"

支援商品：期貨/選擇權}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" then

raiseruntimeerror(\"僅支援分鐘與日頻率\");

value1 = GetField(\"累買成筆\");

value2 = GetField(\"累賣成筆\");

value3 = GetField(\"累賣成筆\") - GetField(\"累買成筆\");

plot1(value3,\"委買委賣成筆差\");

plot2(value1,\"委買成筆\",checkbox:=0);

plot3(value2,\"委賣成筆\",checkbox:=0);

#### 📄 選擇權理論價

{@type:indicator}

input:

iRate100(2,\"無風險利率%\"),

iHV(20,\"標的歷史波動率計算期間\");

variable:vStrikePrice(0),vVolity100(0),vTTMdays(0);

if symboltype \<\> 5 then

raiseruntimeerror(\"僅支援選擇權\");

if iHV \> 0 then

vVolity100 =
HVolatility(getsymbolfield(\"Underlying\",\"收盤價\",\"D\"),iHV)

else

vVolity100 = 20;

vStrikePrice = getsymbolinfo(\"履約價\");

vTTMdays = DateDiff(GetSymbolInfo(\"到期日\"), Date) + 1;

value1 =
bsprice(leftstr(getsymbolinfo(\"買賣權\"),1),getsymbolfield(\"Underlying\",\"收盤價\"),vStrikePrice,vTTMdays,iRate100,0,vVolity100);

plot1(value1,\"理論價\");

#### 📄 隱含波動率

{@type:indicator}

input:

iRate100(2,\"無風險利率%\");

variable:vStrikePrice(0),vTTMdays(0);

if symboltype \<\> 5 then

raiseruntimeerror(\"僅支援選擇權\");

vStrikePrice = getsymbolinfo(\"履約價\");

vTTMdays = DateDiff(GetSymbolInfo(\"到期日\"), Date) + 1;

value1 =
ivolatility(leftstr(getsymbolinfo(\"買賣權\"),1),getsymbolfield(\"Underlying\",\"收盤價\"),vStrikePrice,vTTMdays,iRate100,0,c);

plot1(value1,\"隱含波動率%\");

### 2.9 籌碼指標 (34 個)

#### 📄 不明買盤指標

{@type:indicator}

input:period(5,\"期數\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"法人買張\");

value2=GetField(\"當日沖銷張數\");

value3=GetField(\"散戶買張\");

value4=volume-value1-value2-value3;

if volume \<\> 0 then

value5=value4/volume;

value6=average(value5,period);

plot1(value6,\"不明買盤比例\");

#### 📄 主力作多成本線

{@type:indicator}

input:period(40,\"期數\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"主力買張\");

value2=(o+h+l+c)/4;

value3=value1\*value2;//做多金額

if summation(value1,period)\<\>0 then

value4=summation(value3,period)/summation(value1,period);

plot1(value4,\"主力作多成本線\");

#### 📄 主力成本線

{@type:indicator}

{

籌碼指標。

支援日以上頻率。支援台股商品。

}

plot1(GetField(\"主力成本\"),\"主力成本線\");//系統估算值。計算主力持股成本。

#### 📄 主力累計買賣超

{@type:indicator}

input: Length(5); setinputname(1,\"計算天數\");

input:TXT(\"僅適用日線以上\"); setinputname(2,\"使用限制\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: \_buyTotal(0), volTotal(0), \_Ratio(0);

\_buyTotal = summation(GetField(\"主力買賣超張數\"), Length);

volTotal = summation(Volume, Length);

if volTotal \<\> 0 then

\_Ratio = \_buyTotal \* 100 / volTotal

else

\_Ratio = 0;

Plot1(\_buyTotal, \"累計買賣超\");

Plot2(\_Ratio, \"比例%\");

#### 📄 主力買超佔成交量比重

{@type:indicator}

input:length(5,\"期數\"),TXT(\"僅支援日線以上\");

var:\_strplot1(\"\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率，僅支援日線以上\");

value4=getField(\"主力買賣超張數\", \"D\");

if volume\<\>0 then

value5=(summation(value4,length)/summation(volume,length))\*100;

\_strplot1 = text(\"近 \",numToStr(length,0),\"
期，主力買超佔成交量比重\");

plot1(value5,\"主力買超佔成交量比重\");

setplotLabel(1,\_strplot1);

#### 📄 分公司交易家數差

{@type:indicator}

input:period1(22,\"MA天期\");

input:period2(10,\"差異MA天期\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

//狀況1.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量=0，則交易家數相關指標回傳0。

//狀況2.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量\<\>0，則交易家數相關指標正常運算。

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司交易家數\") and
GetField(\"成交量\") = 0 then value1 = 0 else
value1=GetField(\"分公司交易家數\");

value2=average(value1,period1);

value3=value1-value2;

value4=average(value3,period2);

plot1(value3,\"分公司家數差\");

plot2(value4,\"家數差移動平均線\");

#### 📄 分公司淨買賣超家數指標

{@type:indicator}

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

//狀況1.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量=0，則交易家數相關指標回傳0。

//狀況2.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量\<\>0，則交易家數相關指標正常運算。

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司淨買超金額家數\")
and GetField(\"成交量\") = 0 then value1 = 0 else value1 =
GetField(\"分公司淨買超金額家數\");

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司淨賣超金額家數\")
and GetField(\"成交量\") = 0 then value2 = 0 else value2 =
GetField(\"分公司淨賣超金額家數\");

value3=value2-value1;

plot1(value3,\"家數差\");

#### 📄 分公司買賣家數指標

{@type:indicator}

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

//狀況1.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量=0，則交易家數相關指標回傳0。

//狀況2.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量\<\>0，則交易家數相關指標正常運算。

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司買進家數\") and
GetField(\"成交量\") = 0 then value1 = 0 else
value1=GetField(\"分公司買進家數\");

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司賣出家數\") and
GetField(\"成交量\") = 0 then value2 = 0 else
value2=GetField(\"分公司賣出家數\");

value3=value2-value1;

plot1(value3,\"家數差\");

#### 📄 外資成本線

{@type:indicator}

{

籌碼指標。

支援日以上頻率。支援台股商品。

}

plot1(GetField(\"外資成本\"),\"外資成本線\");//系統估算值。計算外資持股成本。

#### 📄 外資換手比例

{@type:indicator}

input: Length(5); setinputname(1,\"計算天數\");

input:TXT(\"僅適用日線以上\"); setinputname(2,\"使用限制\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: \_buyTotal(0), volTotal(0);

\_buyTotal = summation(GetField(\"外資買張\") + GetField(\"外資賣張\"),
Length);

volTotal = summation(Volume \* 2, Length);

Plot1(\_buyTotal, \"換手張數\");

Plot2(\_buyTotal \* 100 / volTotal, \"比例%\");

#### 📄 外資累計買賣超

{@type:indicator}

input: Length(5); setinputname(1,\"計算天數\");

input:TXT(\"僅適用日線以上\"); setinputname(2,\"使用限制\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: \_buyTotal(0), volTotal(0), \_Ratio(0);

\_buyTotal = summation(GetField(\"外資買賣超\"), Length);

volTotal = summation(Volume, Length);

if volTotal \<\> 0 then

\_Ratio = \_buyTotal \* 100 / volTotal

else

\_Ratio = 0;

Plot1(\_buyTotal, \"累計買賣超\");

Plot2(\_Ratio, \"比例%\");

#### 📄 外資買超佔成交量比重

{@type:indicator}

input:length(5,\"期數\"),TXT(\"僅支援日線以上\");

var:\_strplot1(\"\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率，僅支援日線以上\");

value4=getField(\"外資買賣超張數\", \"D\");

if volume\<\>0 then

value5=(summation(value4,length)/summation(volume,length))\*100;

\_strplot1 = text(\"近 \",numToStr(length,0),\"
期，外資買超佔成交量比重\");

plot1(value5,\"外資買超佔成交量比重\");

setplotLabel(1,\_strplot1);

#### 📄 多空淨力場

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/自訂指標step-by-step/

}

input:sd(5,\"短天期\");

input:ld(20,\"長天期\");

variable:H1(0),L1(0),C1(0),NF(0),SNF(0),LNF(0),dd(0);

H1=HIGH-HIGH\[1\];

L1=LOW-LOW\[1\];

C1=CLOSE-CLOSE\[1\];

if truerange\<\>0 then begin

NF=(H1+L1)/truerange;

SNF=average(NF,sd);

LNF=average(NF,ld);

dd=SNF-LNF;

end;

plot1(dd,\"多空淨力\");

#### 📄 大戶買張比例

{@type:indicator}

input:period1(5,\"短移動平均線天期\");

input:period2(20,\"長移動平均線天期\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"主力買張\");

value2=GetField(\"實戶買張\");

value3=GetField(\"散戶買張\");

value4=GetField(\"控盤者買張\");

value5=GetField(\"法人買張\");

value6=value1+value2+value3+value4+value5;

//合計的買張數當分母，這有可能超出成交量

value7=value1+value4+value5;

//主力+法人+控盤者的買張合計作為大戶的買張

if value6\<\>0 then

value8=value7/value6\*100;

//計算大戶買張佔各方勢力買張的比例

value9=average(value8,period1)-average(value8,period2);

plot1(value9,\"大戶買張比例\");

#### 📄 實戶累計買賣超

{@type:indicator}

input: Length(5); setinputname(1,\"計算天數\");

input:TXT(\"僅適用日線以上\"); setinputname(2,\"使用限制\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: \_buyTotal(0), volTotal(0);

\_buyTotal = summation(GetField(\"實戶買賣超張數\"), Length);

volTotal = summation(Volume, Length);

Plot1(\_buyTotal, \"累計買賣超\");

Plot2(\_buyTotal \* 100 / volTotal, \"比例%\");

#### 📄 投信成本線

{@type:indicator}

{

籌碼指標。

支援日以上頻率。支援台股商品。

}

plot1(GetField(\"投信成本\"),\"投信成本線\");//系統估算值。計算投信持股成本。

#### 📄 投信累計買賣超

{@type:indicator}

input: Length(5); setinputname(1,\"計算天數\");

input:TXT(\"僅適用日線以上\"); setinputname(2,\"使用限制\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: \_buyTotal(0), volTotal(0);

\_buyTotal = summation(GetField(\"投信買賣超\"), Length);

volTotal = summation(Volume, Length);

Plot1(\_buyTotal, \"累計買賣超\");

Plot2(\_buyTotal \* 100 / volTotal, \"比例%\");

#### 📄 投信買超佔成交量比重

{@type:indicator}

input:length(5,\"期數\"),TXT(\"僅支援日線以上\");

var:\_strplot1(\"\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率，僅支援日線以上\");

value4=getField(\"投信買賣超張數\", \"D\");

if volume\<\>0 then

value5=(summation(value4,length)/summation(volume,length))\*100;

\_strplot1 = text(\"近 \",numToStr(length,0),\"
期，投信買超佔成交量比重\");

plot1(value5,\"投信買超佔成交量比重\");

setplotLabel(1,\_strplot1);

#### 📄 控盤者成本線

{@type:indicator}

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"控盤者成本線\");

plot1(value1,\"控盤者成本線\");

#### 📄 放空佔成交均量倍數

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/借券相關欄位在交易策略上的應用/

}

if barfreq \<\> \"D\" then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"借券餘額張數\",\"D\");

value2=GetField(\"融券餘額張數\",\"D\");

if volume\<\>0 then

value3=(value1+value2)/average(volume,20);

plot1(value3,\"放空佔成交均量倍數\");

#### 📄 散戶作多指標

{@type:indicator}

input:Period(10,\"MA期數\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"融資買進張數\");

value2=GetField(\"融券買進張數\");

if volume \<\> 0 then

value3=(value1+value2)/volume;

value4=average(value3,Period);

plot1(value4,\"散戶作多指標\");

#### 📄 散戶買進比例

{@type:indicator}

input:Period(5,\"MA期數\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"散戶買張\");

if volume\<\>0 then

value2=value1/volume\*100;

value3=average(value2,Period);

plot1(value3,\"散戶買進比例\");

#### 📄 散戶賣出比例

{@type:indicator}

input:Period(5,\"MA期數\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"散戶賣張\");

if volume\<\>0 then

value2=value1/volume\*100;

value3=average(value2,Period);

plot1(value3,\"散戶賣出比例\");

#### 📄 整體籌碼收集指標

{@type:indicator}

input:Period(5,\"MA期數\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"現股當沖張數\",\"D\");

value2=GetField(\"外資買賣超\",\"D\");

value3=GetField(\"投信買賣超\",\"D\");

value4=GetField(\"自營商買賣超\",\"D\");

value5=GetField(\"主力買賣超張數\",\"D\");

value6=GetField(\"融資增減張數\",\"D\");

value7=GetField(\"融券增減張數\",\"D\");

value8=volume-value1;//當日淨交易張數

value9=value2+value3+value4+value5-value6+value7;

//籌碼收集張數

if value8\<\>0 then

value10=value9/value8\*100

else

value10=value10\[1\];

value11=average(value10,Period);

plot1(value11,\"集中度\");

#### 📄 法人累計買賣超

{@type:indicator}

input: Length(5); setinputname(1,\"計算天數\");

input:TXT(\"僅適用日線以上\"); setinputname(2,\"使用限制\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: \_buyTotal(0), volTotal(0);

\_buyTotal = summation(GetField(\"法人買賣超張數\"), Length);

volTotal = summation(Volume, Length);

Plot1(\_buyTotal, \"累計買賣超\");

Plot2(\_buyTotal \* 100 / volTotal, \"比例%\");

#### 📄 法人買超佔成交量比重

{@type:indicator}

input:length(5,\"期數\"),TXT(\"僅支援日線以上\");

var:\_strplot1(\"\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率，僅支援日線以上\");

value4=getField(\"法人買賣超\", \"D\");

if volume\<\>0 then

value5=(summation(value4,length)/summation(volume,length))\*100;

\_strplot1 = text(\"近 \",numToStr(length,0),\"
期，法人買超佔成交量比重\");

plot1(value5,\"法人買超佔成交量比重\");

setplotLabel(1,\_strplot1);

#### 📄 法人買進及賣出比例

{@type:indicator}

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"外資買張\");

value2=GetField(\"外資賣張\");

value3=GetField(\"投信買張\");

value4=GetField(\"投信賣張\");

value5=value1+value3;

value6=value2+value4;

if volume \<\> 0 then begin

value7=value5/volume\*100;

value8=value6/volume\*100;

end;

plot1(value7,\"法人買進比例\");

plot2(value8,\"法人賣出比例\");

#### 📄 法人買進比例

{@type:indicator}

{

指標說明

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 326頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

input:length1(5,\"短天期均線天期\");

input:length2(20,\"長天期均線天期\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"法人買張\");

if volume\<\>0 then value2=value1/volume\*100;

//法人買張佔成交量比例

value3 = Average(value2,length1);

value4 = Average(value2,length2);

plot1(value3,\"短期均線\");

plot2(value4,\"長期均線\");

#### 📄 股東人數

{@type:indicator}

//說明：

//交易所公布的總持股人數。

//執行商品為股票時，支援「週」以上的頻率。

//執行商品為可轉債時，支援「月」以上的頻率。

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and (symboltype = 2 or symbolType = 1
or symboltype = 6);//個股+類股+可轉債

if condition998 = false //個股+興櫃+類股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if symboltype = 2 or symbolType = 1 then begin

if barFreq = \"D\" then

value1 = GetField(\"總持股人數\",\"W\")

else

value1 = GetField(\"總持股人數\");

end;

if symboltype = 6 then begin

if barFreq = \"D\" or barFreq = \"W\" then

value1 = GetField(\"總持股人數\",\"M\")

else

value1 = GetField(\"總持股人數\");

end;

plot1(value1,\"總持股人數\");

#### 📄 自營商成本線

{@type:indicator}

{

籌碼指標。

支援日以上頻率。支援台股商品。

}

plot1(GetField(\"自營商成本\"),\"自營商成本線\");//系統估算值。計算自營商持股成本。

#### 📄 自營商累計買賣超

{@type:indicator}

input: Length(5); setinputname(1,\"計算天數\");

input:TXT(\"僅適用日線以上\"); setinputname(2,\"使用限制\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable: \_buyTotal(0), volTotal(0);

\_buyTotal = summation(GetField(\"自營商買賣超\"), Length);

volTotal = summation(Volume, Length);

Plot1(\_buyTotal, \"累計買賣超\");

Plot2(\_buyTotal \* 100 / volTotal, \"比例%\");

#### 📄 自營商買超佔成交量比重

{@type:indicator}

input:length(5,\"期數\"),TXT(\"僅支援日線以上\");

var:\_strplot1(\"\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率，僅支援日線以上\");

value4=getField(\"自營商買賣超\", \"D\");

if volume\<\>0 then

value5=(summation(value4,length)/summation(volume,length))\*100;

\_strplot1 = text(\"近 \",numToStr(length,0),\"
期，自營商買超佔成交量比重\");

plot1(value5,\"自營商買超佔成交量比重\");

setplotLabel(1,\_strplot1);

#### 📄 融資累計張數

{@type:indicator}

input: Length(5); setinputname(1,\"計算天數\");

input:TXT(\"僅適用日線以上\"); setinputname(2,\"使用限制\");

variable: \_buyTotal(0), volTotal(0);

\_buyTotal = summation(GetField(\"融資增減張數\"), Length);

volTotal = summation(Volume, Length);

Plot1(\_buyTotal, \"累計增減\");

Plot2(\_buyTotal \* 100 / volTotal, \"比例%\");

#### 📄 資金流向

{@type:indicator}

{

指標說明

收錄於「三週學會程式交易：打造你的第一筆自動化交易」 327頁

https://www.ipci.com.tw/books_in.php?book_id=724

}

input:

short1(5,\"短期平均\"),

mid1(12,\"長期平均\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1=GetField(\"資金流向\");

value2=average(value1,20);

value3=value1-value2;

value4=average(value3,short1);

value5=average(value3,mid1);

plot1(value4,\"短期均線\");

plot2(value5,\"長期均線\");

### 2.10 籌碼高手 (53 個)

#### 📄 CB剩餘張數

{@type:indicator}

if SymbolType \<\> 6 then RaiseRunTimeError(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if barFreq = \"D\" then

value1 = getField(\"CB剩餘張數\",\"w\")

else

value1 = GetField(\"CB剩餘張數\");

plot1(value1,\"CB剩餘張數\");

#### 📄 CB轉換溢價率

{@type:indicator}

{

支援商品：可轉債商品。

支援頻率：分鐘以上的頻率。

繪圖序列1是「可轉債轉換溢價率」的線條。

}

if SymbolType \<\> 6 then RaiseRunTimeError(\"不支援此商品\");

if GetSymbolInfo(\"轉換價格\") \<\> 0 then //避免分母為0

value1 = (100 / GetSymbolInfo(\"轉換價格\")) \*
GetSymbolField(\"Underlying\", \"收盤價\");//轉換價值 = (100 / 轉換價格)
x 股票現價

if value1 \<\> 0 then

value2 = (close - value1)/value1;//轉換溢價率(%) = (CB價格 - 轉換價值) /
轉換價值

plot1(value2,\"轉換溢價率\");

#### 📄 三方買盤

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(GetField(\"散戶買張\"),\"散戶買進(張)\",axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

plot2(GetField(\"實戶買張\"),\"實戶買進(張)\",axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

plot3(GetField(\"控盤者買張\"),\"控盤者買進(張)\",axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

#### 📄 三方賣盤

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(GetField(\"散戶賣張\"),\"散戶賣出(張)\",axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

plot2(GetField(\"實戶賣張\"),\"實戶賣出(張)\",axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

plot3(GetField(\"控盤者賣張\"),\"控盤者賣出(張)\",axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

#### 📄 主力進出

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition997 = condition999 and (symboltype = 2 or symboltype =
4);//個股+權證+興櫃

if condition999 = false and condition994 = false//大盤, 個股, 權證,
興櫃, 類股指數

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Min\" then raiseruntimeerror(\"不支援此頻率\");

if condition994 then begin

value1 = GetField(\"主力買進金額\");

value2 = GetField(\"主力賣出金額\");

value3 = value1 - value2;

value4 = GetField(\"主力累計買賣超金額\");

plot2(value4,\"主力累計買賣超\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//line，axis1

setplotlabel(1,\"買賣超(元)\");

setplotlabel(2,\"主力累計買賣超(元)\");

setplotlabel(3,\"買進(元)\");

setplotlabel(4,\"賣出(元)\");

plot1(value3,\"買賣超\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//bar，axis2

plot3(value1,\"買進\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//line，axis2

plot4(value2,\"賣出\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//line，axis2

end else begin

if symbolexchange \<\> \"TE\" and symboltype \<\> 1 then begin

value1 = GetField(\"主力買張\");

value2 = GetField(\"主力賣張\");

end;

value3 = GetField(\"主力買賣超張數\");

plot2(GetField(\"主力持股\"),\"主力持股\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis1

setplotlabel(1,\"買賣超(張)\");

setplotlabel(2,\"主力持股(張)\");

setplotlabel(3,\"買進(張)\");

setplotlabel(4,\"賣出(張)\");

plot1(value3,\"買賣超\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//bar，axis2

if symbolexchange \<\> \"TE\" and symboltype \<\> 1 then begin

plot3(value1,\"買進\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis2

plot4(value2,\"賣出\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis2

end;

end;

#### 📄 借券

{@type:indicator}

//借券餘額市值公式參考：

//http://www.twse.com.tw/ch/trading/SBL/TWT72U/TWT72U.php

condition996 = symbolexchange = \"TW\" = true and symboltype = 2;//個股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

if condition994 = false and condition996 = false //大盤+個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if symboltype = 1 then begin

plot1(GetField(\"借券賣出餘額張數\"),\"借券賣出餘額(張)\",axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//單位：張

plot2(GetField(\"借券餘額張數\"),\"借券餘額(張)\",axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//單位：張

//plot3(GetField(\"借券餘額張數\")\*1000\*close,\"借券餘額市值(元)\",axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//單位：元，新增查價顯示 (繪圖形式-\>隱藏, 不畫圖)

end else begin

plot1(GetField(\"借券賣出餘額張數\"),\"借券賣出餘額(張)\",axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//單位：張

plot2(GetField(\"借券餘額張數\"),\"借券餘額(張)\",axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//單位：張

plot3(GetField(\"借券餘額張數\")\*1000\*close,\"借券餘額市值(元)\",axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//單位：元，新增查價顯示 (繪圖形式-\>隱藏, 不畫圖)

end;

#### 📄 借券賣出

{@type:indicator}

condition996 = symbolexchange = \"TW\" = true and symboltype = 2;//個股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

if condition994 = false and condition996 = false //大盤+個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if symboltype = 1 then begin

plot1(GetField(\"借券賣出餘額張數\"),\"借券賣出餘額(張)\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張

plot2(GetField(\"借券賣出張數\")+GetField(\"借券賣出庫存異動張數\"),\"差額(張)\",checkbox:=1,axis:=2);//增減bar，請RD加\"借券還券\"與\"借券調整\"

plot3(GetField(\"借券賣出張數\"),\"賣出(張)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張，新增查價顯示
(繪圖形式-\>隱藏, 不畫圖)

plot4(GetField(\"借券賣出庫存異動張數\"),\"還券(張)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//請RD加

end else begin

plot1(GetField(\"借券賣出餘額張數\"),\"借券賣出餘額(張)\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

plot2(GetField(\"借券賣出張數\")+GetField(\"借券賣出庫存異動張數\"),\"差額(張)\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);//增減bar，請RD加\"借券還券\"與\"借券調整\"

plot3(GetField(\"借券賣出張數\"),\"賣出(張)\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張，新增查價顯示
(繪圖形式-\>隱藏, 不畫圖)

plot4(GetField(\"借券賣出庫存異動張數\"),\"還券(張)\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);//請RD加

end;

#### 📄 借券餘額

{@type:indicator}

condition996 = symbolexchange = \"TW\" = true and symboltype = 2;//個股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

if condition994 = false and condition996 = false //大盤+個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if symboltype = 1 then begin

plot1(GetField(\"借券餘額張數\"),\"借券餘額(張)\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張

plot2(GetField(\"借券張數\") -
GetField(\"還券張數\"),\"差額(張)\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張

plot3(GetField(\"借券張數\"),\"借券(張)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張，新增查價顯示
(繪圖形式-\>隱藏, 不畫圖)

plot4(getfield(\"還券張數\"),\"還券(張)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張，新增查價顯示
(繪圖形式-\>隱藏, 不畫圖)

end else begin

plot1(GetField(\"借券餘額張數\"),\"借券餘額(張)\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

plot2(GetField(\"借券張數\") -
GetField(\"還券張數\"),\"差額(張)\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

plot3(GetField(\"借券張數\"),\"借券(張)\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張，新增查價顯示
(繪圖形式-\>隱藏, 不畫圖)

plot4(getfield(\"還券張數\"),\"還券(張)\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張，新增查價顯示
(繪圖形式-\>隱藏, 不畫圖)

end;

#### 📄 內部人持股

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃+類股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(0.01\*Getfield(\"內部人持股比例\",\"M\"),\"內部人持股比例\",axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//請RD加

plot2(Getfield(\"內部人持股張數\",\"M\"),\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

#### 📄 內部人持股異動

{@type:indicator}

{支援頻率：日、週、月}

{支援商品：美(股票)}

if barfreq \<\> \"d\" and barfreq \<\> \"w\" and barfreq \<\> \"m\" then
raiseruntimeerror(\"不支援此頻率\");

var:exchange(\"\");

exchange = GetSymbolInfo(\"交易所\");

if exchange \<\> \"NYSE\" and exchange \<\> \"NASDAQ\" and exchange \<\>
\"AMEX\" then raiseruntimeerror(\"僅支援美股\");

plot1(Getfield(\"內部人持股異動\"),\"內部人持股異動\",Checkbox:=1);//計算內部人的交易總股數

plot2(Getfield(\"內部人持股\"),\"內部人持股\",Checkbox:=0);//計算有持股異動的內部人總股數

#### 📄 分公司交易家數

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition997 = condition999 and (symboltype = 2 or symboltype =
4);//個股+權證+興櫃

if condition997 = false //個股+權證+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\"

then raiseruntimeerror(\"不支援此頻率\");

//狀況1.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量=0，則交易家數相關指標回傳0。

//狀況2.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量\<\>0，則交易家數相關指標正常運算。

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司交易家數\") and
GetField(\"成交量\") = 0 then value11 = 0 else value11 =
GetField(\"分公司交易家數\");

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司買進家數\") and
GetField(\"成交量\") = 0 then value21 = 0 else value21 =
GetField(\"分公司買進家數\");

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司賣出家數\") and
GetField(\"成交量\") = 0 then value31 = 0 else value31 =
GetField(\"分公司賣出家數\");

if GetField(\"市場總分點數\") \<\> 0 then value1 =
value11/GetField(\"市場總分點數\");

plot1(value11,\"交易家數\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：家

plot2(value1,\"參與率\",checkbox:=0,axis:=2,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot3(value21,\"買進家數\",checkbox:=0,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：家，可勾選畫圖選項
(參數設定)

plot4(value31,\"賣出家數\",checkbox:=0,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：家，可勾選畫圖選項
(參數設定)

#### 📄 分公司淨買賣金額家數

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition997 = condition999 and (symboltype = 2 or symboltype = 4 or
symbolType = 1);//個股+權證+興櫃+類股

if condition997 = false //個股+權證+興櫃+類股

then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\"

then raiseruntimeerror(\"不支援此頻率\");

//狀況1.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量=0，則交易家數相關指標回傳0。

//狀況2.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量\<\>0，則交易家數相關指標正常運算。

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司淨買超金額家數\")
and GetField(\"成交量\") = 0 then value1 = 0 else value1 =
GetField(\"分公司淨買超金額家數\");

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司淨賣超金額家數\")
and GetField(\"成交量\") = 0 then value2 = 0 else value2 =
GetField(\"分公司淨賣超金額家數\");

plot1(value2-value1,\"分公司淨買賣超金額家數差\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：家

plot2(value1,\"分公司淨買超金額家數\",checkbox:=0,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：家，可勾選畫圖選項
(參數設定)

plot3(value2,\"分公司淨賣超金額家數\",checkbox:=0,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：家，可勾選畫圖選項
(參數設定)

#### 📄 分公司買進賣出家數

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition992 = condition999 and (symbol \<\> \"TSE.TW\" and symbol \<\>
\"TWSE.FS\" and symbol \<\> \"OTC.TW\");//類股+個股+權證+興櫃

if condition992 = false //類股+個股+權證+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\"

then raiseruntimeerror(\"不支援此頻率\");

//狀況1.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量=0，則交易家數相關指標回傳0。

//狀況2.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量\<\>0，則交易家數相關指標正常運算。

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司買進家數\") and
GetField(\"成交量\") = 0 then value1 = 0 else value1 =
GetField(\"分公司買進家數\");

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司賣出家數\") and
GetField(\"成交量\") = 0 then value2 = 0 else value2 =
GetField(\"分公司賣出家數\");

plot1(value2-value1,\"家數差\",checkbox:=1,axis:=2);//單位：家

plot2(value1,\"買進\",checkbox:=0,axis:=1);//單位：家，可勾選畫圖選項
(參數設定)

plot3(value2,\"賣出\",checkbox:=0,axis:=1);//單位：家，可勾選畫圖選項
(參數設定)

#### 📄 券資比

{@type:indicator}

condition996 = symbolexchange = \"TW\" and symboltype = 2;//個股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TW\" and symboltype = 1;//類股

if condition994 =false and condition993 = false and condition996 = false
//大盤+類股+個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if symboltype = 1 then begin

plot1(0.01 \*
GetField(\"券資比\"),\"券資比\",axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//單位：

plot2(GetField(\"融券餘額張數\"),\"融券餘額\",axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張，新增查價顯示
(繪圖形式-\>隱藏, 不畫圖)

plot3(GetField(\"融資餘額\"),\"融資餘額\",axis:=12,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張，新增查價顯示
(繪圖形式-\>隱藏, 不畫圖)

end else begin

plot1(0.01 \*
GetField(\"券資比\"),\"券資比\",axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//單位：

plot2(GetField(\"融券餘額張數\"),\"融券餘額\",axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張，新增查價顯示
(繪圖形式-\>隱藏, 不畫圖)

plot3(GetField(\"融資餘額\"),\"融資餘額\",axis:=12,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張，新增查價顯示
(繪圖形式-\>隱藏, 不畫圖)

end;

#### 📄 吉尼系數

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(Getfield(\"吉尼係數\",\"D\"),\"吉尼係數\",axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd2);

//狀況1.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量=0，則交易家數相關指標回傳0。

//狀況2.：如果
K線日期與交易家數相關資料欄位日期不同，並且成交量\<\>0，則交易家數相關指標正常運算。

if getfieldDate(\"date\") \<\> getfieldDate(\"分公司交易家數\") and
GetField(\"成交量\") = 0 then value1 = 0 else
value1=GetField(\"分公司交易家數\");

plot2(value1,\"分公司交易家數\",axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：家

#### 📄 地緣券商買賣超

{@type:indicator}

condition999 = symbolexchange = \"TW\";//台股

if condition999 = false //個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\"

then raiseruntimeerror(\"不支援此頻率\");

value1 = GetField(\"地緣券商買賣超張數\");

value2 += value1;

plot1(value1,\"買賣超\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//bar，axis2

plot2(value2,\"地緣券商累計買賣超\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//line，axis1

#### 📄 外資

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TW\" and symboltype = 1;//類股

if condition999 = false and condition994 = false//大盤, 個股, 權證,
興櫃, 類股指數

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if condition994 then begin

value1 = GetField(\"外資買進金額\");

value2 = GetField(\"外資賣出金額\");

value3 = GetField(\"外資買賣超金額\");

value4 = value4 + GetField(\"外資買賣超金額\");

plot2(value4,\"外資累計買賣超\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis1

setplotlabel(1,\"買賣超(元)\");

setplotlabel(2,\"外資累計買賣超(元)\");

setplotlabel(3,\"買進(元)\");

setplotlabel(4,\"賣出(元)\");

plot1(value3,\"買賣超\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//bar，axis2

plot3(value1,\"買進\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

plot4(value2,\"賣出\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

end else

begin

if symbolexchange \<\> \"TE\" and condition993 = false and date \>=
20110106 then begin

value1 = GetField(\"外資買張\");

value2 = GetField(\"外資賣張\");

end;

value3 = GetField(\"外資買賣超張數\");

plot2(GetField(\"外資持股\"),\"外資持股\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis1

setplotlabel(1,\"買賣超(張)\");

setplotlabel(2,\"外資持股(張)\");

setplotlabel(3,\"買進(張)\");

setplotlabel(4,\"賣出(張)\");

if condition993 = false then begin

plot5(0.01\*GetField(\"外資持股比例\"),\"外資持股比例\",axis:=12,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

end;

plot1(value3,\"買賣超\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//bar，axis2

if symbolexchange \<\> \"TE\" and condition993 = false then begin

plot3(value1,\"買進\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis2

plot4(value2,\"賣出\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis2

end;

end;

#### 📄 外資持股比例

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(0.01\*GetField(\"外資持股比例\"),\"外資持股比例\",axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

#### 📄 大戶持股

{@type:indicator}

{由集保公司所提供的，「指定級距以上」的持股資料所計算}

input: \_input1(50,\"大戶標準\",inputkind:=
Dict(\[\"1\",1\],\[\"5\",5\],\[\"10\",10\],\[\"15\",15\],\[\"20\",20\],\[\"30\",30\],\[\"40\",40\],\[\"50\",50\],\[\"100\",100\],\[\"200\",200\],\[\"400\",400\],\[\"600\",600\],\[\"800\",800\],\[\"1000\",1000\]),quickedit:=true);

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and (symboltype = 2 or symbolType =
1);//個股+興櫃+類股

if condition998 = false //個股+興櫃+類股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

switch (\_input1)

begin

case 1:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=1);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=1);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=1);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=1);

value2 = Getfield(\"大戶持股張數\",param:=1);

value3 = Getfield(\"大戶持股人數\",param:=1);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 5:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=5);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=5);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=5);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=5);

value2 = Getfield(\"大戶持股張數\",param:=5);

value3 = Getfield(\"大戶持股人數\",param:=5);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 10:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=10);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=10);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=10);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=10);

value2 = Getfield(\"大戶持股張數\",param:=10);

value3 = Getfield(\"大戶持股人數\",param:=10);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 15:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=15);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=15);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=15);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=15);

value2 = Getfield(\"大戶持股張數\",param:=15);

value3 = Getfield(\"大戶持股人數\",param:=15);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 20:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=20);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=20);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=20);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=20);

value2 = Getfield(\"大戶持股張數\",param:=20);

value3 = Getfield(\"大戶持股人數\",param:=20);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 30:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=30);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=30);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=30);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=30);

value2 = Getfield(\"大戶持股張數\",param:=30);

value3 = Getfield(\"大戶持股人數\",param:=30);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 40:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=40);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=40);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=40);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=40);

value2 = Getfield(\"大戶持股張數\",param:=40);

value3 = Getfield(\"大戶持股人數\",param:=40);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 50:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=50);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=50);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=50);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=50);

value2 = Getfield(\"大戶持股張數\",param:=50);

value3 = Getfield(\"大戶持股人數\",param:=50);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 100:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=100);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=100);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=100);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=100);

value2 = Getfield(\"大戶持股張數\",param:=100);

value3 = Getfield(\"大戶持股人數\",param:=100);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 200:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=200);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=200);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=200);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=200);

value2 = Getfield(\"大戶持股張數\",param:=200);

value3 = Getfield(\"大戶持股人數\",param:=200);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 400:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=400);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=400);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=400);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=400);

value2 = Getfield(\"大戶持股張數\",param:=400);

value3 = Getfield(\"大戶持股人數\",param:=400);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 600:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=600);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=600);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=600);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=600);

value2 = Getfield(\"大戶持股張數\",param:=600);

value3 = Getfield(\"大戶持股人數\",param:=600);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 800:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=800);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=800);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=800);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=800);

value2 = Getfield(\"大戶持股張數\",param:=800);

value3 = Getfield(\"大戶持股人數\",param:=800);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

default:

if barFreq = \"D\" then begin

value1 = Getfield(\"大戶持股比例\",\"W\",param:=1000);

value2 = Getfield(\"大戶持股張數\",\"W\",param:=1000);

value3 = Getfield(\"大戶持股人數\",\"W\",param:=1000);

end else begin

value1 = Getfield(\"大戶持股比例\",param:=1000);

value2 = Getfield(\"大戶持股張數\",param:=1000);

value3 = Getfield(\"大戶持股人數\",param:=1000);

end;

plot1(0.01\*value1,\"大戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

end;

#### 📄 大盤法人比重

{@type:indicator}

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

if condition994 = false //大盤

then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\" and

barfreq \<\> \"W\" and barfreq \<\> \"AW\" and

barfreq \<\> \"M\" and barfreq \<\> \"AM\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(0.005\*(GetField(\"法人買進比重\")+GetField(\"法人賣出比重\")),\"交易比重\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(0.01\*GetField(\"法人買進比重\"),\"買進比重\",checkbox:=0,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot3(0.01\*GetField(\"法人賣出比重\"),\"賣出比重\",checkbox:=0,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

#### 📄 官股券商

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and (symboltype = 2 or symboltype =
1);//個股+興櫃+類股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

if condition994 =false and condition998 = false //大盤+個股+興櫃+類股

then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\"

then raiseruntimeerror(\"不支援此頻率\");

if condition994 then begin

value1 = GetField(\"官股券商買進金額\");

value2 = GetField(\"官股券商賣出金額\");

value3 = value1 - value2;

value4 = GetField(\"官股券商累計買賣超金額\");

setplotlabel(1,\"買賣超(元)\");

setplotlabel(2,\"累計買賣超(元)\");

setplotlabel(3,\"買進(元)\");

setplotlabel(4,\"賣出(元)\");

plot1(value3,\"買賣超\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//bar，axis2

plot1(value3,\"買賣超\"); //bar，axis2

plot2(value4,\"官股券商累計買賣超\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis1

plot3(value1,\"買進(元)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

plot4(value2,\"賣出(元)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

end else if condition994 = false then begin

value1 = GetField(\"官股券商買進金額\");

value2 = GetField(\"官股券商賣出金額\");

value3 = GetField(\"官股券商買賣超張數\");

value4 = value4 + value3;

setplotlabel(1,\"買賣超(張)\");

setplotlabel(2,\"累計買賣超(張)\");

setplotlabel(3,\"買進(張)\");

setplotlabel(4,\"賣出(張)\");

plot1(value3,\"買賣超(張)\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//bar，axis2

plot2(value4,\"官股券商累計買賣超(張)\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//line，axis1

plot3(value1,\"買進(張)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

plot4(value2,\"賣出(張)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

end;

#### 📄 實戶買賣盤

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1 = GetField(\"實戶買賣超張數\")+value1;

plot1(value1,\"累計買賣超(張)\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位:張

plot2(GetField(\"實戶買賣超張數\"),\"實戶買賣超(張)\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位:張

#### 📄 實質買賣盤比

{@type:indicator}

condition996 = symbolexchange = \"TW\" and symboltype = 2;//個股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TW\" and symboltype = 1;//類股

if condition994 =false and condition993 = false and condition996 = false
//大盤+類股+個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(0.01\*(GetField(\"實質買盤比\")-GetField(\"實質賣盤比\")),\"買賣差值\",checkbox:=1,axis:=2,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(0.01\*GetField(\"實質買盤比\"),\"買盤比\",checkbox:=0,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot3(0.01\*GetField(\"實質賣盤比\"),\"賣盤比\",checkbox:=0,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

#### 📄 庫藏股指標

{@type:indicator}

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\" or symbolType = 1;//大盤、類股

if condition994 = false //大盤、類股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(GetField(\"庫藏股申請總市值\")\*1000,\"申報總市值\",axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位:千元

plot2(GetField(\"庫藏股申請家數\"),\"申報家數\",checkbox:=0,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位:家

#### 📄 投信

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TW\" and symboltype = 1;//類股

if condition999 = false and condition994 = false//大盤, 個股, 權證,
興櫃, 類股指數

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if condition994 then begin

value1 = GetField(\"投信買進金額\");

value2 = GetField(\"投信賣出金額\");

value3 = GetField(\"投信買賣超金額\");

value4 = value4 + GetField(\"投信買賣超金額\");

plot2(value4,\"投信累計買賣超\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis1

setplotlabel(1,\"買賣超(元)\");

setplotlabel(2,\"投信累計買賣超(元)\");

setplotlabel(3,\"買進(元)\");

setplotlabel(4,\"賣出(元)\");

plot1(value3,\"買賣超\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//bar，axis2

plot3(value1,\"買進\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

plot4(value2,\"賣出\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

end else begin

if symbolexchange \<\> \"TE\" and condition993 = false then begin

value1 = GetField(\"投信買張\");

value2 = GetField(\"投信賣張\");

end;

value3 = GetField(\"投信買賣超張數\");

plot2(GetField(\"投信持股\"),\"投信持股\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis1

setplotlabel(1,\"買賣超(張)\");

setplotlabel(2,\"投信持股(張)\");

setplotlabel(3,\"買進(張)\");

setplotlabel(4,\"賣出(張)\");

if condition993 = false then begin

plot5(0.01\*GetField(\"投信持股比例\"),\"投信持股比例\",axis:=12,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

end;

plot1(value3,\"買賣超\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//bar，axis2

if symbolexchange \<\> \"TE\" and condition993 = false then begin

plot3(value1,\"買進\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis2

plot4(value2,\"賣出\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis2

end;

end;

#### 📄 投信持股比例

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(0.01\*GetField(\"投信持股比例\"),\"投信持股比例\",axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

#### 📄 控盤者主動買賣力

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(GetField(\"主動性交易比重\"),\"交易比重\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd2);

plot2(GetField(\"主動買力\"),\"主動買力\",checkbox:=0,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd2);

plot3(GetField(\"主動賣力\"),\"主動賣力\",checkbox:=0,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd2);

#### 📄 控盤者買賣盤

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1 = GetField(\"控盤者買賣超張數\")+value1;

plot1(value1,\"累計買賣超(張)\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位:張

plot2(GetField(\"控盤者買賣超張數\"),\"控盤者買賣超(張)\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位:張

#### 📄 散戶持股

{@type:indicator}

{由集保公司所提供的，「指定級距以下」的持股資料所計算}

input: \_input1(50,\"散戶標準\",inputkind:=
Dict(\[\"1\",1\],\[\"5\",5\],\[\"10\",10\],\[\"15\",15\],\[\"20\",20\],\[\"30\",30\],\[\"40\",40\],\[\"50\",50\],\[\"100\",100\],\[\"200\",200\],\[\"400\",400\],\[\"600\",600\],\[\"800\",800\],\[\"1000\",1000\]),quickedit:=true);

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and (symboltype = 2 or symbolType =
1);//個股+興櫃+類股

if condition998 = false //個股+興櫃+類股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

switch (\_input1)

begin

case 1:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=1);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=1);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=1);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=1);

value2 = Getfield(\"散戶持股張數\",param:=1);

value3 = Getfield(\"散戶持股人數\",param:=1);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 5:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=5);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=5);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=5);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=5);

value2 = Getfield(\"散戶持股張數\",param:=5);

value3 = Getfield(\"散戶持股人數\",param:=5);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 10:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=10);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=10);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=10);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=10);

value2 = Getfield(\"散戶持股張數\",param:=10);

value3 = Getfield(\"散戶持股人數\",param:=10);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 15:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=15);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=15);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=15);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=15);

value2 = Getfield(\"散戶持股張數\",param:=15);

value3 = Getfield(\"散戶持股人數\",param:=15);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 20:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=20);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=20);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=20);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=20);

value2 = Getfield(\"散戶持股張數\",param:=20);

value3 = Getfield(\"散戶持股人數\",param:=20);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 30:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=30);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=30);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=30);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=30);

value2 = Getfield(\"散戶持股張數\",param:=30);

value3 = Getfield(\"散戶持股人數\",param:=30);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 40:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=40);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=40);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=40);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=40);

value2 = Getfield(\"散戶持股張數\",param:=40);

value3 = Getfield(\"散戶持股人數\",param:=40);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 50:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=50);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=50);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=50);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=50);

value2 = Getfield(\"散戶持股張數\",param:=50);

value3 = Getfield(\"散戶持股人數\",param:=50);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 100:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=100);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=100);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=100);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=100);

value2 = Getfield(\"散戶持股張數\",param:=100);

value3 = Getfield(\"散戶持股人數\",param:=100);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 200:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=200);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=200);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=200);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=200);

value2 = Getfield(\"散戶持股張數\",param:=200);

value3 = Getfield(\"散戶持股人數\",param:=200);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 400:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=400);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=400);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=400);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=400);

value2 = Getfield(\"散戶持股張數\",param:=400);

value3 = Getfield(\"散戶持股人數\",param:=400);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 600:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=600);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=600);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=600);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=600);

value2 = Getfield(\"散戶持股張數\",param:=600);

value3 = Getfield(\"散戶持股人數\",param:=600);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

case 800:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=800);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=800);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=800);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=800);

value2 = Getfield(\"散戶持股張數\",param:=800);

value3 = Getfield(\"散戶持股人數\",param:=800);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

default:

if barFreq = \"D\" then begin

value1 = Getfield(\"散戶持股比例\",\"W\",param:=1000);

value2 = Getfield(\"散戶持股張數\",\"W\",param:=1000);

value3 = Getfield(\"散戶持股人數\",\"W\",param:=1000);

end else begin

value1 = Getfield(\"散戶持股比例\",param:=1000);

value2 = Getfield(\"散戶持股張數\",param:=1000);

value3 = Getfield(\"散戶持股人數\",param:=1000);

end;

plot1(0.01\*value1,\"散戶持股比例\",checkbox:=1,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot2(value2,\"持股張數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(value3,\"持股人數\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);

end;

#### 📄 散戶指標(量)

{@type:indicator}

condition996 = symbolexchange = \"TW\" and symboltype = 2;//個股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TW\" and symboltype = 1;//類股

//原始spec要求支援類股，6.30暫不支援，等DB補資料

//if condition994 =false and condition993 = false and condition996 =
false //大盤+類股+個股

if condition994 =false and condition996 = false //大盤+個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\"

then raiseruntimeerror(\"不支援此頻率\");

if condition994 then

value1 = GetField(\"累計成交\") - (GetField(\"資券互抵張數\") +
GetField(\"現股當沖張數\"))

else

value1 = volume - (GetField(\"資券互抵張數\") +
GetField(\"現股當沖張數\"));

value2 = GetField(\"融資買進張數\") + GetField(\"融券買進張數\");

value3 = GetField(\"融資賣出張數\") + GetField(\"融券賣出張數\");

if value1 \<\> 0 then begin

value4 = value2 / value1;

value5 = value3 / value1;

end else begin

value4 = 0;

value5 = 0;

end;

plot1(value4 -
value5,\"買賣差值\",checkbox:=1,axis:=2,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//單位：張

plot2(value4,\"買進\",checkbox:=0,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//單位：張

plot3(value5,\"賣出\",checkbox:=0,axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//單位：張

#### 📄 散戶買賣盤

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

value1 = GetField(\"散戶買賣超張數\")+value1;

plot1(value1,\"累計買賣超(張)\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位:張

plot2(GetField(\"散戶買賣超張數\"),\"散戶買賣超(張)\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位:張

#### 📄 本益比

{@type:indicator}

//支援商品：台(股票)、美(股票)、美(特別股）

value1 = GetField(\"本益比\");

if value1 \> 0 then begin

plot1(value1);

setplotLabel(1,\"PE\");

end

else begin

plot1(0);

setplotLabel(1,\"近4季EPS為負\");

end;

#### 📄 機構持股

{@type:indicator}

//資料更新頻率：季

//支援商品：美(股票)

if barfreq = \"Tick\" or barfreq = \"Min\" then
raiseruntimeerror(\"不支援此頻率\");

var:exchange(\"\");

exchange = GetSymbolInfo(\"交易所\");

if exchange \<\> \"NYSE\" and exchange \<\> \"NASDAQ\" and exchange \<\>
\"AMEX\" then raiseruntimeerror(\"僅支援美股\");

plot1(GetField(\"機構持股比重\",
\"Q\")/100,\"機構持股比重\",Checkbox:=1);//機購持股比重

plot2(GetField(\"機構持股\", \"Q\"),\"持股數值\",Checkbox:=0);//持股數值

#### 📄 殖利率

{@type:indicator}

//支援商品：台(股票)、台(ETF)、美(股票)、美(ETF)、美(特別股)。

value1 = GetField(\"殖利率\");

if value1 \> 0 then begin

plot1(value1/100);

setplotLabel(1,\"殖利率\");

end

else begin

plot1(0);

setplotLabel(1,\"無配息紀錄\");

end;

#### 📄 法人

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition997 = condition999 and (symboltype = 2 or symboltype =
4);//個股+權證+興櫃

if condition999 = false and condition994 = false//大盤, 個股, 權證,
興櫃, 類股指數

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if condition994 then begin

value1 = GetField(\"法人買進金額\");

value2 = GetField(\"法人賣出金額\");

value3 = GetField(\"法人買賣超金額\");

value4 = value4 + GetField(\"法人買賣超金額\");

plot2(value4,\"法人累計買賣超\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis1

setplotlabel(1,\"買賣超(元)\");

setplotlabel(2,\"法人累計買賣超(元)\");

setplotlabel(3,\"買進(元)\");

setplotlabel(4,\"賣出(元)\");

plot1(value3,\"買賣超\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//bar，axis2

plot3(value1,\"買進\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

plot4(value2,\"賣出\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

end else begin

if symbolexchange \<\> \"TE\" and symboltype \<\> 1 and date \>=
20110106 then begin

value1 = GetField(\"法人買張\");

value2 = GetField(\"法人賣張\");

end;

value3 = GetField(\"法人買賣超張數\");

plot2(GetField(\"法人持股\"),\"法人持股\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis1

setplotlabel(1,\"買賣超(張)\");

setplotlabel(2,\"法人持股(張)\");

setplotlabel(3,\"買進(張)\");

setplotlabel(4,\"賣出(張)\");

if symboltype \<\> 1 then

value5 = 0.01\*GetField(\"法人持股比例\");

plot5(value5,\"法人持股比例\",axis:=12,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot1(value3,\"買賣超\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//bar，axis2

if symbolexchange \<\> \"TE\" and symboltype \<\> 1 then begin

plot3(value1,\"買進\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis2

plot4(value2,\"賣出\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis2

end;

end;

#### 📄 法人持股比例

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(0.01\*GetField(\"法人持股比例\"),\"法人持股比例\",axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

#### 📄 營收

{@type:indicator}

Var:\_Sales(0);

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and (symboltype = 2 or symboltype =
1);//個股+興櫃+類股

if condition998 = false //個股+興櫃+類股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\" or barfreq = \"Q\" or barfreq
= \"H\" or barfreq = \"Y\"

then raiseruntimeerror(\"不支援此頻率\");

if GetField(\"月營收\",\"M\") \<\> 0 then

value1 = rateOfChange(GetField(\"月營收\",\"M\"),1) / 100;

if GetField(\"月營收\",\"M\")\[12\] \<\> 0 then

value2 = (GetField(\"月營收\",\"M\") - GetField(\"月營收\",\"M\")\[12\])
/ GetField(\"月營收\",\"M\")\[12\];

plot1(GetField(\"月營收\",\"M\")\*100000000,\"月營收\",axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sd2);

plot2(value1,\"月增率\",checkbox:=1,axis:=2,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot3(value2,\"年增率\",checkbox:=1,axis:=2,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

#### 📄 現股當沖金額

{@type:indicator}

condition996 = symbolexchange = \"TW\" and symboltype = 2;//個股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TW\" and symboltype = 1;//類股

if condition994 =false and condition993 = false and condition996 = false
//大盤+類股+個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if symboltype = 1 then begin

if volume \<\> 0 then

value1 =
(GetField(\"現股當沖買進金額\")+GetField(\"現股當沖賣出金額\"))/(volume\*2)

else

value1 = 0;

plot1(value1,\"當沖比率\",checkbox:=1,axis:=2,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//單位：％

plot2(GetField(\"現股當沖買進金額\"),\"買進\",checkbox:=0,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：元，可勾選畫圖選項
(參數設定)

plot3(GetField(\"現股當沖賣出金額\"),\"賣出\",checkbox:=0,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：元，可勾選畫圖選項
(參數設定)

end else begin

if GetField(\"成交金額(元)\") \<\> 0 then

value1 =
(GetField(\"現股當沖買進金額\")+GetField(\"現股當沖賣出金額\"))/(GetField(\"成交金額(元)\")\*2)

else

value1 = 0;

plot1(value1,\"當沖比率\",checkbox:=1,axis:=2,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//單位：％

plot2(GetField(\"現股當沖買進金額\"),\"買進\",checkbox:=0,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：元，可勾選畫圖選項
(參數設定)

plot3(GetField(\"現股當沖賣出金額\"),\"賣出\",checkbox:=0,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：元，可勾選畫圖選項
(參數設定)

end;

#### 📄 申報轉讓

{@type:indicator}

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TW\" and symboltype = 1;//類股

if condition994 =false and condition993 = false //大盤+類股

then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\" and

barfreq \<\> \"W\" and barfreq \<\> \"AW\" and

barfreq \<\> \"M\" and barfreq \<\> \"AM\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(Getfield(\"申報總市值\"),\"申報總市值\",axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot2(Getfield(\"申報家數\"),\"申報家數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot3(Getfield(\"申報人數\"),\"申報人數\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

#### 📄 當沖

{@type:indicator}

input: \_input1(1,\"計算方式\",inputkind:=
Dict(\[\"全部\",1\],\[\"資券互抵\",2\],\[\"現股當沖\",3\]),quickedit:=true);//1=全部（預設）、2=資券互抵、3=現股當沖

variable: dtVolume(0);

condition996 = symbolexchange = \"TW\" and symboltype = 2;//個股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TW\" and symboltype = 1;//類股

if condition994 =false and condition993 = false and condition996 = false
//大盤+類股+個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

switch (\_input1)

begin

case 2:

dtVolume = GetField(\"資券互抵張數\");

case 3:

dtVolume = GetField(\"現股當沖張數\");

default:

dtVolume = GetField(\"資券互抵張數\") + GetField(\"現股當沖張數\");

end;

if condition993 and not condition994 then

begin

switch (barfreq)

begin

case \"W\",\"AW\":

value1 = summation(GetField(\"內盤量\",\"D\") +
GetField(\"外盤量\",\"D\"),dayofweek(getfielddate(\"內盤量\",\"D\")));

case \"M\",\"AM\":

value1 = summation(GetField(\"內盤量\",\"D\") +
GetField(\"外盤量\",\"D\"),ceiling(dayofmonth(getfielddate(\"內盤量\",\"D\"))\*5/7));

case \"Q\":

value1 = summation(GetField(\"內盤量\",\"D\") +
GetField(\"外盤量\",\"D\"),mod(month(getfielddate(\"內盤量\",\"D\"))+2,3)\*22 +
ceiling(dayofmonth(getfielddate(\"內盤量\",\"D\"))\*5/7));

case \"H\":

value1 = summation(GetField(\"內盤量\",\"D\") +
GetField(\"外盤量\",\"D\"),mod(month(getfielddate(\"內盤量\",\"D\"))+5,6)\*22 +
dayofmonth(getfielddate(\"內盤量\",\"D\"))\*5/7);

case \"Y\":

value1 = summation(GetField(\"內盤量\",\"D\") +
GetField(\"外盤量\",\"D\"),mod(month(getfielddate(\"內盤量\",\"D\"))+11,12)\*22 +
dayofmonth(getfielddate(\"內盤量\",\"D\"))\*5/7);

default:

value1 = GetField(\"內盤量\",\"D\") + GetField(\"外盤量\",\"D\");

end;

end

else if condition994 then

begin

switch (barfreq)

begin

case \"W\",\"AW\":

value1 =
summation(GetField(\"累計成交\",\"D\"),dayofweek(getfielddate(\"累計成交\",\"D\")));

case \"M\",\"AM\":

value1 =
summation(GetField(\"累計成交\",\"D\"),ceiling(dayofmonth(getfielddate(\"累計成交\",\"D\"))\*5/7));

case \"Q\":

value1 =
summation(GetField(\"累計成交\",\"D\"),mod(month(getfielddate(\"累計成交\",\"D\"))+2,3)\*22 +
ceiling(dayofmonth(getfielddate(\"累計成交\",\"D\"))\*5/7));

case \"H\":

value1 =
summation(GetField(\"累計成交\",\"D\"),mod(month(getfielddate(\"累計成交\",\"D\"))+5,6)\*22 +
ceiling(dayofmonth(getfielddate(\"累計成交\",\"D\"))\*5/7));

case \"Y\":

value1 =
summation(GetField(\"累計成交\",\"D\"),mod(month(getfielddate(\"累計成交\",\"D\"))+11,12)\*22 +
ceiling(dayofmonth(getfielddate(\"累計成交\",\"D\"))\*5/7));

default:

value1 = GetField(\"累計成交\",\"D\");

end;

end

else

value1 = volume;

if value1 \<\> 0 then

value2 = dtVolume/value1

else

value2 = 0;

if symboltype = 1 then begin

plot1(dtVolume,\"當沖張數\",axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//單位：張

plot2(value2,\"當沖率\",axis:=2,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot3(GetField(\"資券互抵張數\"),\"資券互抵(張)\",ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

plot4(GetField(\"現股當沖張數\"),\"現股當沖(張)\",ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);

end else begin

plot1(dtVolume,\"當沖張數\",axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//單位：張

plot2(value2,\"當沖率\",axis:=2,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

plot3(GetField(\"資券互抵張數\"),\"資券互抵(張)\",ScaleLabel:=slfull,ScaleDecimal:=sd0);

plot4(GetField(\"現股當沖張數\"),\"現股當沖(張)\",ScaleLabel:=slfull,ScaleDecimal:=sd0);

end;

#### 📄 累計每股盈餘(發佈值)

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and (symboltype = 2 or symboltype =
1);//個股+興櫃+類股

if condition998 = false //個股+興櫃+類股

then raiseruntimeerror(\"不支援此商品\");

if GetField(\"累計每股盈餘(發佈值)\",\"Q\")\[4\] \<\> 0 then

value1 = (GetField(\"累計每股盈餘(發佈值)\",\"Q\") -
GetField(\"累計每股盈餘(發佈值)\",\"Q\")\[4\]) /
GetField(\"累計每股盈餘(發佈值)\",\"Q\")\[4\]\*100;

plot1(GetField(\"累計每股盈餘(發佈值)\",\"Q\"),\"累計每股盈餘(發佈值)\");

plot2(value1,\"年增率(%)\");

#### 📄 累計淨利(發佈值)

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and (symboltype = 2 or symboltype =
1);//個股+興櫃+類股

if condition998 = false //個股+興櫃+類股

then raiseruntimeerror(\"不支援此商品\");

if GetField(\"累計淨利(發佈值)\",\"Q\")\[4\] \<\> 0 then

value1 = (GetField(\"累計淨利(發佈值)\",\"Q\") -
GetField(\"累計淨利(發佈值)\",\"Q\")\[4\]) /
GetField(\"累計淨利(發佈值)\",\"Q\")\[4\]\*100;

plot1(GetField(\"累計淨利(發佈值)\",\"Q\"),\"累計淨利(發佈值)\");

plot2(value1,\"年增率(%)\");

#### 📄 綜合前十大券商

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and (symboltype = 2 or symboltype =
1);//個股+興櫃+類股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

if condition994 =false and condition998 = false //大盤+個股+興櫃+類股

then raiseruntimeerror(\"不支援此商品\");

//if condition994 = false //大盤

//then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\"

then raiseruntimeerror(\"不支援此頻率\");

if condition994 then begin

value1 = GetField(\"綜合前十大券商買進金額\");

value2 = GetField(\"綜合前十大券商賣出金額\");

value3 = value1 - value2;

value4 = GetField(\"綜合前十大券商累計買賣超金額\");

plot1(value3,\"買賣超\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//bar，axis2

plot2(value4,\"綜合前十大券商累計買賣超\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis1

plot3(value1,\"買進\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

plot4(value2,\"賣出\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

end else begin

value3 = GetField(\"綜合前十大券商買賣超張數\");

value4 = value4 + value3;

plot1(value3,\"買賣超\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//bar，axis2

plot2(value4,\"綜合前十大券商累計買賣超\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//line，axis1

end;

#### 📄 總持股人數

{@type:indicator}

//說明：

//交易所公布的總持股人數。

//執行商品為股票時，支援「週」以上的頻率。

//執行商品為可轉債時，支援「月」以上的頻率。

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and (symboltype = 2 or symbolType = 1
or symboltype = 6);//個股+類股+可轉債

if condition998 = false //個股+興櫃+類股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if symboltype = 2 or symbolType = 1 then begin

if barFreq = \"D\" then

value1 = GetField(\"總持股人數\",\"W\")

else

value1 = GetField(\"總持股人數\");

end;

if symboltype = 6 then begin

if barFreq = \"D\" or barFreq = \"W\" then

value1 = GetField(\"總持股人數\",\"M\")

else

value1 = GetField(\"總持股人數\");

end;

plot1(value1,\"總持股人數\");

#### 📄 自營商

{@type:indicator}

input: \_input1(1,\"自營商\",inputkind:=
Dict(\[\"全部\",1\],\[\"自行買賣\",2\],\[\"避險\",3\]),quickedit:=true);

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TW\" and symboltype = 1;//類股

if condition999 = false and condition994 = false//大盤, 個股, 權證,
興櫃, 類股指數

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if condition994 then begin

switch (\_input1)

begin

case 2:

value1 = GetField(\"自營商自行買賣買進金額\");

value2 = GetField(\"自營商自行買賣賣出金額\");

value3 = GetField(\"自營商自行買賣買賣超金額\");

value4 = value4 + GetField(\"自營商自行買賣買賣超金額\");

case 3:

value1 = GetField(\"自營商避險買進金額\");

value2 = GetField(\"自營商避險賣出金額\");

value3 = GetField(\"自營商避險買賣超金額\");

value4 = value4 + GetField(\"自營商避險買賣超金額\");

default:

value1 = GetField(\"自營商買進金額\");

value2 = GetField(\"自營商賣出金額\");

value3 = GetField(\"自營商買賣超金額\");

value4 = value4 + GetField(\"自營商買賣超金額\");

end;

plot2(value4,\"自營商累計買賣超\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis1

setplotlabel(1,\"買賣超(元)\");

setplotlabel(2,\"自營商累計買賣超(元)\");

setplotlabel(3,\"買進(元)\");

setplotlabel(4,\"賣出(元)\");

plot1(value3,\"買賣超\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//bar，axis2

plot3(value1,\"買進\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

plot4(value2,\"賣出\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);
//line，axis2

end else begin

switch (\_input1)

begin

case 2:

if symbolexchange \<\> \"TE\" and condition993 = false and date \>=
20110106 then begin

value1 = GetField(\"自營商自行買賣買張\");

value2 = GetField(\"自營商自行買賣賣張\");

end;

value3 = GetField(\"自營商自行買賣買賣超\");

case 3:

if symbolexchange \<\> \"TE\" and condition993 = false and date \>=
20110106 then begin

value1 = GetField(\"自營商避險買張\");

value2 = GetField(\"自營商避險賣張\");

end;

value3 = GetField(\"自營商避險買賣超\");

default:

if symbolexchange \<\> \"TE\" and condition993 = false and date \>=
20110106 then begin

value1 = GetField(\"自營商買張\");

value2 = GetField(\"自營商賣張\");

end;

value3 = GetField(\"自營商買賣超張數\");

end;

plot2(GetField(\"自營商持股\"),\"自營商持股\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis1

setplotlabel(1,\"買賣超(張)\");

setplotlabel(2,\"自營商持股(張)\");

setplotlabel(3,\"買進(張)\");

setplotlabel(4,\"賣出(張)\");

if condition993 = false then begin

plot5(0.01\*GetField(\"自營商持股比例\"),\"自營商持股比例\",axis:=12,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

end;

plot1(value3,\"買賣超\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//bar，axis2

if symbolexchange \<\> \"TE\" and condition993 = false then begin

plot3(value1,\"買進\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis2

plot4(value2,\"賣出\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);
//line，axis2

end;

end;

#### 📄 自營商持股比例

{@type:indicator}

condition999 = symbolexchange = \"TW\" or symbolexchange =
\"TE\";//台股+興櫃

condition998 = condition999 = true and symboltype = 2;//個股+興櫃

if condition998 = false //個股+興櫃

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(0.01\*GetField(\"自營商持股比例\"),\"自營商持股比例\",axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

#### 📄 融券

{@type:indicator}

condition996 = symbolexchange = \"TW\" and symboltype = 2;//個股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TW\" and symboltype = 1;//類股

condition991 = symbolexchange = \"SH\" and symboltype = 2;//滬股

condition990 = symbolexchange = \"SZ\" and symboltype = 2;//深股

if condition994 =false and condition993 = false and condition996 = false
//大盤+類股+個股

and condition991 = false and condition990 = false //陸股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if condition994 then begin

plot1(GetField(\"融券餘額張數\"),\"融券(張)\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張

plot2(GetField(\"融券增減張數\"),\"差額(張)\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張

plot3(GetField(\"融券買進張數\"),\"買進(張)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張，可勾選畫圖選項
(參數設定)

plot4(GetField(\"融券賣出張數\"),\"賣出(張)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張，可勾選畫圖選項
(參數設定)

plot5(GetField(\"現券償還張數\"),\"券償(張)\",checkbox:=0,axis:=12,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張，可勾選畫圖選項
(參數設定)

end else begin

plot1(GetField(\"融券餘額張數\"),\"融券(張)\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

plot2(GetField(\"融券增減張數\"),\"差額(張)\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

if condition996 then begin

value1 = GetField(\"融券買進張數\");

value2 = GetField(\"融券賣出張數\");

value3 = GetField(\"現券償還張數\");

end;

plot3(value1,\"買進(張)\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張，可勾選畫圖選項
(參數設定)

plot4(value2,\"賣出(張)\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張，可勾選畫圖選項
(參數設定)

plot5(value3,\"券償(張)\",checkbox:=0,axis:=12,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張，可勾選畫圖選項
(參數設定)

end;

if condition996 then

plot6(GetField(\"融券使用率\")\*0.01,\"使用率\",axis:=13,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//單位%隱藏，不畫圖，僅查價，缺欄位

#### 📄 融券使用率

{@type:indicator}

condition996 = symbolexchange = \"TW\" = true and symboltype = 2;//個股

if condition996 = false //個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(0.01 \*
GetField(\"融券使用率\"),\"融券使用率\",axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//請RD加

#### 📄 融資

{@type:indicator}

input: \_input1(1,\"大盤融資單位\",inputkind:=
Dict(\[\"金額\",1\],\[\"張數\",2\]));//1=金額、2=張數

condition996 = symbolexchange = \"TW\" and symboltype = 2;//個股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

condition993 = symbolexchange = \"TW\" and symboltype = 1;//類股

condition991 = symbolexchange = \"SH\" and symboltype = 2;//滬股

condition990 = symbolexchange = \"SZ\" and symboltype = 2;//深股

if condition994 =false and condition993 = false and condition996 = false
//大盤+類股+個股

and condition991 = false and condition990 = false //陸股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if condition994 and \_input1 = 1 then begin

plot1(GetField(\"融資餘額金額\"),\"融資(元)\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張

plot2(GetField(\"融資增減金額\"),\"差額(元)\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：張

plot3(GetField(\"融資買進金額\"),\"買進(元)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//可勾選畫圖選項
(參數設定)

plot4(GetField(\"融資賣出金額\"),\"賣出(元)\",checkbox:=0,axis:=11,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//可勾選畫圖選項
(參數設定)

plot5(GetField(\"現金償還張數\"),\"現償(張)\",checkbox:=0,axis:=12,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//可勾選畫圖選項
(參數設定)

setplotlabel(1,\"融資(元)\");

setplotlabel(2,\"差額(元)\");

setplotlabel(3,\"買進(元)\");

setplotlabel(4,\"賣出(元)\");

end else begin

plot1(GetField(\"融資餘額張數\"),\"融資(張)\",checkbox:=1,axis:=1,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

plot2(GetField(\"融資增減張數\"),\"差額(張)\",checkbox:=1,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

if condition996 then begin

value1 = GetField(\"融資買進張數\");

value2 = GetField(\"融資賣出張數\");

value3 = GetField(\"現金償還張數\");

end;

plot3(value1,\"買進(張)\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);//可勾選畫圖選項
(參數設定)

plot4(value2,\"賣出(張)\",checkbox:=0,axis:=11,ScaleLabel:=slfull,ScaleDecimal:=sd0);//可勾選畫圖選項
(參數設定)

plot5(value3,\"現償(張)\",checkbox:=0,axis:=12,ScaleLabel:=slfull,ScaleDecimal:=sd0);//可勾選畫圖選項
(參數設定)

setplotlabel(1,\"融資(張)\");

setplotlabel(2,\"差額(張)\");

setplotlabel(3,\"買進(張)\");

setplotlabel(4,\"賣出(張)\");

end;

if condition996 then

plot6(GetField(\"融資使用率\")\*0.01,\"使用率\",axis:=13,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//單位%，隱藏，不畫圖，僅查價

#### 📄 融資使用率

{@type:indicator}

condition996 = symbolexchange = \"TW\" = true and symboltype = 2;//個股

if condition996 = false //個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(GetField(\"融資使用率\")\*0.01,\"融資使用率\",axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);//單位%

#### 📄 融資維持率

{@type:indicator}

condition996 = symbolexchange = \"TW\" = true and symboltype = 2;//個股

condition994 = symbol = \"TSE.TW\" or symbol = \"TWSE.FS\" or symbol =
\"OTC.TW\";//大盤

if condition994 = false and condition996 = false //大盤+個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

plot1(GetField(\"融資維持率\")\*0.01,
\"融資維持率\",axis:=1,ScaleLabel:=slpercent,ScaleDecimal:=sd2);

//plot1(1, \"融資維持率\",checkbox:=1,axis:=1);

if symboltype = 1 then begin

plot2(GetField(\"融資增減金額\"),\"融資增減(元)\",checkbox:=0,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sdauto);//單位：元

setplotlabel(2,\"融資增減(元)\");

end else begin

plot2(GetField(\"融資增減張數\"),\"融資增減(張)\",checkbox:=0,axis:=2,ScaleLabel:=slfull,ScaleDecimal:=sd0);//單位：張

setplotlabel(2,\"融資增減(張)\");

end;

#### 📄 關聯券商買賣超

{@type:indicator}

condition999 = symbolexchange = \"TW\";//台股

condition998 = symbolType = 2;//股票

if condition999 = false or condition998 = false//個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\"

then raiseruntimeerror(\"不支援此頻率\");

value1 = GetField(\"關聯券商買賣超張數\");

value2 += value1;

plot1(value1,\"買賣超(張)\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//bar，axis2

plot2(value2,\"累計買賣超(張)\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//line，axis1

#### 📄 關鍵券商買賣超

{@type:indicator}

condition999 = symbolexchange = \"TW\";//台股

if condition999 = false //個股

then raiseruntimeerror(\"不支援此商品\");

if barfreq \<\> \"D\" and barfreq \<\> \"AD\"

then raiseruntimeerror(\"不支援此頻率\");

value1 = GetField(\"關鍵券商買賣超張數\");

value2 += value1;

plot1(value1,\"買賣超\",checkbox:=1,axis:=2,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//bar，axis2

plot2(value2,\"關鍵券商累計買賣超\",checkbox:=1,axis:=1,ScaleLabel:=sltypewy,ScaleDecimal:=sd0);
//line，axis1

### 2.11 財報指標 (25 個)

#### 📄 10年EPS預估之10倍本益比線

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

input:pe(10,\"合理本益比\");

var: \_EPSSum1(0), \_count1(0), \_EPSSum2(0), \_count2(0);

\_EPSSum1 = 0;

\_count1 = 0;

for value1 = 0 to 10 begin

if CheckField(\"每股稅後淨利(元)\", \"Y\")\[value1\] then begin

\_EPSSum1 += getField(\"每股稅後淨利(元)\", \"Y\")\[value1\];

\_count1 += 1;

//print(currentBar, date, getFielddate(\"每股稅後淨利(元)\",
\"Y\")\[value1\], getField(\"每股稅後淨利(元)\", \"Y\")\[value1\]);

end;

if \_count1 = 10 then break;

end;

\_EPSSum2 = 0;

\_count2 = 0;

for value1 = 0 to 5 begin

if CheckField(\"每股稅後淨利(元)\", \"Q\")\[value1\] then begin

\_EPSSum2 += getField(\"每股稅後淨利(元)\", \"Q\")\[value1\];

\_count2 += 1;

print(currentBar, date, getFielddate(\"每股稅後淨利(元)\",
\"Q\")\[value1\], getFielddate(\"每股稅後淨利(元)\", \"Q\")\[value1\]);

end;

if \_count2 = 4 then break;

end;

if \_count1 \> 0 then value3=((\_EPSSum1 / \_count1)+\_EPSSum2)/2;

value4=value3\*pe;

plot1(value4,\"10倍長期PE線\");

#### 📄 PB倍數線

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1 = getField(\"每股淨值(元)\", \"Q\", default := value1\[1\]);

input:ratio1(0.8);

input:ratio2(1);

input:ratio3(1.2);

input:ratio4(1.5);

input:ratio5(1.8);

if value1 \<\> 0 then value2 = close / value1;

plot1(value2\*ratio1, \"0.8倍\");

plot2(value2\*ratio2, \"1.0倍\");

plot3(value2\*ratio3, \"1.2倍\");

plot4(value2\*ratio4, \"1.5倍\");

plot5(value2\*ratio5, \"1.8倍\");

#### 📄 員工人數

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1 = getField(\"員工人數\", \"Q\", default:=value1\[1\]);

plot1(value1,\"員工人數\");

#### 📄 季營收年增率

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

if checkfield(\"營業收入淨額\", \"Q\")\[4\] and
checkField(\"營業收入淨額\", \"Q\") and getField(\"營業收入淨額\",
\"Q\")\[4\] \<\> 0 then

value1 = 100 \* (getField(\"營業收入淨額\", \"Q\") -
getField(\"營業收入淨額\", \"Q\")\[4\]) / getField(\"營業收入淨額\",
\"Q\")\[4\];

plot1(value1, \"季營收年增率\");

value2 = getField(\"營業收入淨額\", \"Q\", default := value2\[1\]);

plot2(value2, \"季營收(百萬)\");

#### 📄 年營收年增率

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

if CheckField(\"營業收入淨額\", \"Y\") and CheckField(\"營業收入淨額\",
\"Y\")\[1\] and getField(\"營業收入淨額\", \"Y\")\[1\] \<\> 0 then begin

value1 = (getField(\"營業收入淨額\", \"Y\") - getField(\"營業收入淨額\",
\"Y\")\[1\]) / getField(\"營業收入淨額\", \"Y\")\[1\] \* 100;

end;

plot1(value1, \"年營收年增率\");

value2=getField(\"營業收入淨額\", \"Y\", default := value2\[1\]);

plot2(value2,\"年營收(百萬)\");

#### 📄 應收帳款週轉率

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"應收帳款週轉率(次)\", \"Q\", default:= value1\[1\]);

plot1(value1,\"應收帳款週轉率(次)\");

#### 📄 月營收年增率

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"月營收年增率\", \"M\", default := value1\[1\]);

plot1(value1,\"月營收年增率\");

value2 = getfield(\"月營收\", \"M\", default:= value2\[1\]);

plot2(value2\*100, \"月營收(百萬)\");

#### 📄 月營收長期移動平均線

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

input:period(4,\"移動平均月份數\");

var: \_sum(0), \_count(0);

\_sum = 0;

\_count = 0;

for value1 = 0 to (period + 5) begin

if CheckField(\"月營收年增率\", \"M\")\[value1\] then begin

\_sum += getField(\"月營收年增率\", \"M\")\[value1\];

\_count += 1;

end;

if \_count = period then break;

end;

if \_count \> 0 then value1 = \_sum / \_count;

plot1(value1, \"月營收年增率移動平均\");

#### 📄 殖利率

{@type:indicator}

value1=getField(\"殖利率\", \"D\", default := value1\[1\]);

plot1(value1,\"殖利率\");

#### 📄 每股淨值

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"每股淨值(元)\", \"Q\", default := value1\[1\]);

plot1(value1,\"每股淨值(元)\");

#### 📄 每股營收

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

var: \_sum(0), \_count(0);

\_sum = 0;

\_count = 0;

for value1 = 0 to 17 begin

if checkfield(\"月營收\", \"M\")\[value1\] then begin

\_sum += getField(\"月營收\", \"M\")\[value1\];

\_count += 1;

end;

if \_count = 12 then break;

end;

value2 = getField(\"普通股股本\", \"Q\", default:= 0);

if value2 \<\> 0 then value3 = \_sum / value2 \* 10;

plot1(value3, \"每股營收(元)\");

#### 📄 流動比率

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"流動比率\", \"Q\", default := value1\[1\]);

plot1(value1,\"流動比率\");

#### 📄 營業利益率

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"營業利益率\", \"Q\", default := value1\[1\]);

plot1(value1,\"營業利益率\");

if checkfield(\"營業利益率\", \"Q\")\[4\] and checkField(\"營業利益率\",
\"Q\") and getField(\"營業利益率\", \"Q\")\[4\] \<\> 0 then

value2 = 100 \* (getField(\"營業利益率\", \"Q\") -
getField(\"營業利益率\", \"Q\")\[4\]) / getField(\"營業利益率\",
\"Q\")\[4\];

plot2(value2, \"營業利益率年增率\");

#### 📄 營業毛利率

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"營業毛利率\", \"Q\", default := value1\[1\]);

plot1(value1,\"營業毛利率\");

if checkfield(\"營業毛利率\", \"Q\")\[4\] and checkField(\"營業毛利率\",
\"Q\") and getField(\"營業毛利率\", \"Q\")\[4\] \<\> 0 then

value2 = 100 \* (getField(\"營業毛利率\", \"Q\") -
getField(\"營業毛利率\", \"Q\")\[4\]) / getField(\"營業毛利率\",
\"Q\")\[4\];

plot2(value2, \"營業毛利率年增率\");

#### 📄 盈轉佔股本比重

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"盈餘轉增資佔股本比重\", \"Y\", default:=value1\[1\]);

plot1(value1,\"盈餘轉增資佔股本比重\" );

#### 📄 研發費用

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"研發費用\", \"Q\", default:=value1\[1\]);

value2=getField(\"研發費用率\", \"Q\", default:=value2\[1\]);

plot1(value1,\"研發費用(百萬)\");

plot2(value2,\"研發費用率\");

#### 📄 稅前淨利率

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"稅前淨利率\", \"Q\", default := value1\[1\]);

plot1(value1,\"稅前淨利率\");

if checkfield(\"稅前淨利率\", \"Q\")\[4\] and checkField(\"稅前淨利率\",
\"Q\") and getField(\"稅前淨利率\", \"Q\")\[4\] \<\> 0 then

value2 = 100 \* (getField(\"稅前淨利率\", \"Q\") -
getField(\"稅前淨利率\", \"Q\")\[4\]) / getField(\"稅前淨利率\",
\"Q\")\[4\];

plot2(value2, \"稅前淨利率年增率\");

#### 📄 稅後淨利率

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"稅後淨利率\", \"Q\", default := value1\[1\]);

plot1(value1,\"稅後淨利率\");

if checkfield(\"稅後淨利率\", \"Q\")\[4\] and checkField(\"稅後淨利率\",
\"Q\") and getField(\"稅後淨利率\", \"Q\")\[4\] \<\> 0 then

value2 = 100 \* (getField(\"稅後淨利率\", \"Q\") -
getField(\"稅後淨利率\", \"Q\")\[4\]) / getField(\"稅後淨利率\",
\"Q\")\[4\];

plot2(value2, \"稅後淨利率年增率\");

#### 📄 自由現金流量

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

var: \_sum1(0), \_count1(0), \_sum2(0), \_count2(0);

\_sum1 = 0;

\_count1 = 0;

\_sum2 = 0;

\_count2 = 0;

for value1 = 0 to 5 begin

if checkField(\"自由現金流量\", \"Q\")\[value1\] then begin

\_sum1 += getField(\"自由現金流量\", \"Q\")\[value1\];

\_count1 += 1;

end;

if \_count1 = 4 then break;

end;

for value1 = 0 to 5 begin

if checkField(\"自由現金流量營收比\", \"Q\")\[value1\] then begin

\_sum2 += getField(\"自由現金流量營收比\", \"Q\")\[value1\];

\_count2 += 1;

end;

if \_count2 = 4 then break;

end;

if \_count1 \<\> 0 then value2 = \_sum1 / \_count1;

if \_count2 \<\> 0 then value3 = \_sum2 / \_count2;

plot1(value2,\"自由現金流量(百萬)\");

plot2(value3,\"自由現金流量營收比\");

#### 📄 行銷費用

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"推銷費用\", \"Q\", default := value1\[1\]);

value2=getField(\"銷售費用比\", \"Q\", default := value2\[1\]);

plot1(value1,\"推銷費用(百萬)\");

plot2(value2,\"銷售費用比\");

#### 📄 資本支出長期走勢

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

var: \_sum(0), \_count(0);

\_sum = 0;

\_count = 0;

for value1 = 0 to 5 begin

if checkField(\"資本支出金額\", \"Q\")\[value1\] then begin

\_sum += getField(\"資本支出金額\", \"Q\")\[value1\];

\_count += 1;

end;

if \_count = 4 then break;

end;

plot1(\_sum, \"資本支出(百萬)\");

#### 📄 速動比率

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1=getField(\"速動比率\", \"Q\", default := value1\[1\]);

plot1(value1,\"速動比率\");

#### 📄 預收款

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

value1 = GetField(\"預收款項\", \"Q\", default:= value1\[1\]);

if checkfield(\"預收款項\", \"Q\") and checkfield(\"預收款項\",
\"Q\")\[4\] and GetField(\"預收款項\", \"Q\")\[4\] \<\> 0 then

value2 = (GetField(\"預收款項\", \"Q\") - GetField(\"預收款項\",
\"Q\")\[4\]) / GetField(\"預收款項\", \"Q\")\[4\];

plot1(value1,\"預收款(百萬)\");

plot2(value2,\"預收款年增率\");

#### 📄 整體營收(執行商品)

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

group: \_symbolGroup();

var: \_sum(0), \_num(0);

\_symbolGroup = GetSymbolGroup(\"成分股\");

value1 = GroupSize(\_symbolGroup);

\_sum = 0;

\_num = 0;

for value2 = 1 to value1 begin

if CheckSymbolField(\_symbolGroup\[value2\], \"月營收\", \"M\") then
begin

\_sum += GetSymbolField(\_symbolGroup\[value2\], \"月營收\", \"M\");

\_num += 1;

end;

end;

plot1(\_sum);

SetPlotLabel(1, \"成分股月營收\");

plot2(\_num);

SetPlotLabel(2, \"有月營收家數\");

plot3(value1);

SetPlotLabel(3, \"成分股家數\");

#### 📄 整體營收(指定指數代碼)

{@type:indicator}

input: \_setalign(0, \"營收財報對位方式\",
inputkind:=dict(\[\"絕對對位\", 0\], \[\"公佈日對位\", 1\]), quickedit
:= True);

setalign(\"營收財報\", \_setalign);

input: \_index(\"I026010.TW\", \"指標代碼\");

group: \_symbolGroup();

var: \_sum(0), \_num(0);

\_symbolGroup = GetSymbolGroup(\_index, \"成分股\");

value1 = GroupSize(\_symbolGroup);

\_sum = 0;

\_num = 0;

for value2 = 1 to value1 begin

if CheckSymbolField(\_symbolGroup\[value2\], \"月營收\", \"M\") then
begin

\_sum += GetSymbolField(\_symbolGroup\[value2\], \"月營收\", \"M\");

\_num += 1;

end;

end;

plot1(\_sum);

SetPlotLabel(1, text(\_index, \"成分股月營收\"));

plot2(\_num);

SetPlotLabel(2, text(\_index, \"有月營收家數\"));

plot3(value1);

SetPlotLabel(3, text(\_index, \"成分股家數\"));

### 2.12 跨頻率指標 (12 個)

#### 📄 分鐘與日DMI-Osc

{@type:indicator}

// 跨頻率DMI-Osc指標，預設跨頻率為30分鐘

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率60分鐘，跨頻率計算30分鐘DMI-Osc技術指標。

//

input: Length(14, \"天數\"),

FreqType(\"30\", \"跨頻率週期\",
inputkind:=dict(\[\"1分鐘\",\"1\"\],\[\"5分鐘\",\"5\"\],\[\"10分鐘\",\"10\"\],\[\"15分鐘\",\"15\"\],\[\"30分鐘\",\"30\"\],\[\"60分鐘\",\"60\"\],\[\"日\",\"D\"\],\[\"還原日\",\"AD\"\]));

variable: pdi_value(0), ndi_value(0), adx_value(0);

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"此範例僅支援分鐘、日與還原日頻率\");

xfMin_DirectionMovement(FreqType, Length, pdi_value, ndi_value,
adx_value);

// 初始區波動較大, 先不繪出

//

if CurrentBar \< Length then

begin

pdi_value = 0;

ndi_value = 0;

adx_value = 0;

end;

Plot1(pdi_value - ndi_value, \"分鐘與日DMI-Osc\");

// 防呆，大頻率跨小頻率時，在線圖秀不支援

//

switch (FreqType)

begin

case \"1\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

if barinterval \<\> 1 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

setplotlabel(1, \"1分DMI-Osc\");

case \"5\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

setplotlabel(1, \"5分DMI-Osc\");

case \"10\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

setplotlabel(1, \"10分DMI-Osc\");

case \"15\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

setplotlabel(1, \"15分DMI-Osc\");

case \"30\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

setplotlabel(1, \"30分DMI-Osc\");

case \"60\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 and barinterval \<\> 45 and
barinterval \<\> 60 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

setplotlabel(1, \"60分DMI-Osc\");

case \"D\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於日\");

setplotlabel(1, \"日DMI-Osc\");

case \"AD\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於還原日\");

setplotlabel(1, \"還原日DMI-Osc\");

end;

#### 📄 分鐘與日DMI

{@type:indicator}

// 分頻率DMI指標，預設跨分頻率為30分鐘

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率60分鐘，跨頻率計算30分鐘DMI技術指標。

//

input: Length(14, \"天數\"),

FreqType(\"30\", \"跨頻率週期\",
inputkind:=dict(\[\"1分鐘\",\"1\"\],\[\"5分鐘\",\"5\"\],\[\"10分鐘\",\"10\"\],\[\"15分鐘\",\"15\"\],\[\"30分鐘\",\"30\"\],\[\"60分鐘\",\"60\"\],\[\"日\",\"D\"\],\[\"還原日\",\"AD\"\]));

variable: pdi_value(0), ndi_value(0), adx_value(0);

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"此範例僅支援分鐘、日與還原日頻率\");

xfMin_DirectionMovement(FreqType, Length, pdi_value, ndi_value,
adx_value);

// 初始區波動較大, 先不繪出

//

if CurrentBar \< Length then

begin

pdi_value = 0;

ndi_value = 0;

adx_value = 0;

end;

Plot1(pdi_value, \"分鐘與日+DI\");

Plot2(ndi_value, \"分鐘與日-DI\");

Plot3(adx_value, \"分鐘與日ADX\");

// 防呆，大頻率跨小頻率時，在線圖秀不支援

//

switch (FreqType)

begin

case \"1\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

if barinterval \<\> 1 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

setplotlabel(1, \"1分+DI\");

setplotlabel(2, \"1分-DI\");

setplotlabel(3, \"1分ADX\");

case \"5\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

setplotlabel(1, \"5分+DI\");

setplotlabel(2, \"5分-DI\");

setplotlabel(3, \"5分ADX\");

case \"10\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

setplotlabel(1, \"10分+DI\");

setplotlabel(2, \"10分-DI\");

setplotlabel(3, \"10分ADX\");

case \"15\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

setplotlabel(1, \"15分+DI\");

setplotlabel(2, \"15分-DI\");

setplotlabel(3, \"15分ADX\");

case \"30\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

setplotlabel(1, \"30分+DI\");

setplotlabel(2, \"30分-DI\");

setplotlabel(3, \"30分ADX\");

case \"60\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 and barinterval \<\> 45 and
barinterval \<\> 60 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

setplotlabel(1, \"60分+DI\");

setplotlabel(2, \"60分-DI\");

setplotlabel(3, \"60分ADX\");

case \"D\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於日\");

setplotlabel(1, \"日+DI\");

setplotlabel(2, \"日-DI\");

setplotlabel(3, \"日ADX\");

case \"AD\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於還原日\");

setplotlabel(1, \"還原日+DI\");

setplotlabel(2, \"還原日-DI\");

setplotlabel(3, \"還原日ADX\");

end;

#### 📄 分鐘與日KD

{@type:indicator}

// 跨頻率KD指標，預設跨頻率為30分

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率60分鐘，跨頻率計算30分鐘KD技術指標。

//

input: Length(9, \"天數\"), RSVt(3, \"RSVt權數\"), Kt(3, \"Kt權數\"),

FreqType(\"30\", \"跨頻率週期\",
inputkind:=dict(\[\"1分鐘\",\"1\"\],\[\"5分鐘\",\"5\"\],\[\"10分鐘\",\"10\"\],\[\"15分鐘\",\"15\"\],\[\"30分鐘\",\"30\"\],\[\"60分鐘\",\"60\"\],\[\"日\",\"D\"\],\[\"還原日\",\"AD\"\]));

variable: rsv(0), k(0), \_d(0);

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"此範例僅支援分鐘、日與還原日頻率\");

xfMin_stochastic(FreqType, Length, RSVt, Kt, rsv, k, \_d);

Plot1(k, \"分鐘與日K(%)\");

Plot2(\_d, \"分鐘與日D(%)\");

// 防呆，大頻率跨小頻率時，在線圖秀不支援

//

switch (FreqType)

begin

case \"1\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

if barinterval \<\> 1 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

setplotlabel(1, \"1分K(%)\");

setplotlabel(2, \"1分D(%)\");

case \"5\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

setplotlabel(1, \"5分K(%)\");

setplotlabel(2, \"5分D(%)\");

case \"10\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

setplotlabel(1, \"10分K(%)\");

setplotlabel(2, \"10分D(%)\");

case \"15\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

setplotlabel(1, \"15分K(%)\");

setplotlabel(2, \"15分D(%)\");

case \"30\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

setplotlabel(1, \"30分K(%)\");

setplotlabel(2, \"30分D(%)\");

case \"60\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 and barinterval \<\> 45 and
barinterval \<\> 60 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

setplotlabel(1, \"60分K(%)\");

setplotlabel(2, \"60分D(%)\");

case \"D\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於日\");

setplotlabel(1, \"日K(%)\");

setplotlabel(2, \"日D(%)\");

case \"AD\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於還原日\");

setplotlabel(1, \"還原日K(%)\");

setplotlabel(2, \"還原日D(%)\");

end;

#### 📄 分鐘與日MACD

{@type:indicator}

// 跨頻率MACD指標，預設跨頻率為30分

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率60分鐘，跨頻率計算30分鐘MACD技術指標。

//

input: FastLength(12, \"DIF短天數\"), SlowLength(26, \"DIF長天數\"),
MACDLength(9, \"MACD天數\"),

FreqType(\"30\", \"跨頻率週期\",
inputkind:=dict(\[\"1分鐘\",\"1\"\],\[\"5分鐘\",\"5\"\],\[\"10分鐘\",\"10\"\],\[\"15分鐘\",\"15\"\],\[\"30分鐘\",\"30\"\],\[\"60分鐘\",\"60\"\],\[\"日\",\"D\"\],\[\"還原日\",\"AD\"\]));

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"此範例僅支援分鐘、日與還原日頻率\");

xfMin_macd(FreqType,xfMin_weightedclose(FreqType),FastLength,SlowLength,MACDLength,value1,value2,value3);

// 前面區段資料變動較大, 先不繪出

//

if CurrentBar \<= SlowLength then

begin

Value1 = 0;

Value2 = 0;

Value3 = 0;

end;

Plot1(Value1, \"分鐘與日DIF\");

Plot2(Value2, \"分鐘與日MACD\");

Plot3(Value3, \"分鐘與日Osc\");

// 防呆，大頻率跨小頻率時，在線圖秀不支援

//

switch (FreqType)

begin

case \"1\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

if barinterval \<\> 1 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

setplotlabel(1, \"1分DIF\");

setplotlabel(2, \"1分MACD\");

setplotlabel(3, \"1分Osc\");

case \"5\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

setplotlabel(1, \"5分DIF\");

setplotlabel(2, \"5分MACD\");

setplotlabel(3, \"5分Osc\");

case \"10\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

setplotlabel(1, \"10分DIF\");

setplotlabel(2, \"10分MACD\");

setplotlabel(3, \"10分Osc\");

case \"15\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

setplotlabel(1, \"15分DIF\");

setplotlabel(2, \"15分MACD\");

setplotlabel(3, \"15分Osc\");

case \"30\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

setplotlabel(1, \"30分DIF\");

setplotlabel(2, \"30分MACD\");

setplotlabel(3, \"30分Osc\");

case \"60\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 and barinterval \<\> 45 and
barinterval \<\> 60 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

setplotlabel(1, \"60分DIF\");

setplotlabel(2, \"60分MACD\");

setplotlabel(3, \"60分Osc\");

case \"D\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於日\");

setplotlabel(1, \"日DIF\");

setplotlabel(2, \"日MACD\");

setplotlabel(3, \"日Osc\");

case \"AD\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於還原日\");

setplotlabel(1, \"還原日DIF\");

setplotlabel(2, \"還原日MACD\");

setplotlabel(3, \"還原日Osc\");

end;

#### 📄 分鐘與日RSI

{@type:indicator}

// 跨頻率RSI指標，預設跨頻率為30分

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率60分鐘，跨頻率計算30分鐘RSI技術指標。

//

input: Length1(6, \"天數一\"), Length2(12, \"天數二\"),

FreqType(\"30\", \"跨頻率週期\",
inputkind:=dict(\[\"1分鐘\",\"1\"\],\[\"5分鐘\",\"5\"\],\[\"10分鐘\",\"10\"\],\[\"15分鐘\",\"15\"\],\[\"30分鐘\",\"30\"\],\[\"60分鐘\",\"60\"\],\[\"日\",\"D\"\],\[\"還原日\",\"AD\"\]));

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"此範例僅支援分鐘、日與還原日頻率\");

// 因 Getfield
第二個參數不支援動態變數字串，故使用以下語法表達跨分鐘頻率的RSI

// 防呆，大頻率跨小頻率時，在線圖秀不支援

//

switch (FreqType)

begin

case \"1\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

if barinterval \<\> 1 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

value1 = xfMin_RSI(\"1\", GetField(\"Close\",\"1\"), Length1);

value2 = xfMin_RSI(\"1\", GetField(\"Close\",\"1\"), Length2);

Plot1(value1, \"分鐘與日RSI1\");

Plot2(value2, \"分鐘與日RSI2\");

setplotlabel(1, \"1分RSI\");

setplotlabel(2, \"1分RSI\");

case \"5\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

value1 = xfMin_RSI(\"5\", GetField(\"Close\",\"5\"), Length1);

value2 = xfMin_RSI(\"5\", GetField(\"Close\",\"5\"), Length2);

Plot1(value1, \"分鐘與日RSI1\");

Plot2(value2, \"分鐘與日RSI2\");

setplotlabel(1, \"5分RSI\");

setplotlabel(2, \"5分RSI\");

case \"10\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

value1 = xfMin_RSI(\"10\", GetField(\"Close\",\"10\"), Length1);

value2 = xfMin_RSI(\"10\", GetField(\"Close\",\"10\"), Length2);

Plot1(value1, \"分鐘與日RSI1\");

Plot2(value2, \"分鐘與日RSI2\");

setplotlabel(1, \"10分RSI\");

setplotlabel(2, \"10分RSI\");

case \"15\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

value1 = xfMin_RSI(\"15\", GetField(\"Close\",\"15\"), Length1);

value2 = xfMin_RSI(\"15\", GetField(\"Close\",\"15\"), Length2);

Plot1(value1, \"分鐘與日RSI1\");

Plot2(value2, \"分鐘與日RSI2\");

setplotlabel(1, \"15分RSI\");

setplotlabel(2, \"15分RSI\");

case \"30\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

value1 = xfMin_RSI(\"30\", GetField(\"Close\",\"30\"), Length1);

value2 = xfMin_RSI(\"30\", GetField(\"Close\",\"30\"), Length2);

Plot1(value1, \"分鐘與日RSI1\");

Plot2(value2, \"分鐘與日RSI2\");

setplotlabel(1, \"30分RSI\");

setplotlabel(2, \"30分RSI\");

case \"60\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 and barinterval \<\> 45 and
barinterval \<\> 60 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

value1 = xfMin_RSI(\"60\", GetField(\"Close\",\"60\"), Length1);

value2 = xfMin_RSI(\"60\", GetField(\"Close\",\"60\"), Length2);

Plot1(value1, \"分鐘與日RSI1\");

Plot2(value2, \"分鐘與日RSI2\");

setplotlabel(1, \"60分RSI\");

setplotlabel(2, \"60分RSI\");

case \"D\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於日\");

value1 = xfMin_RSI(\"D\", GetField(\"Close\",\"D\"), Length1);

value2 = xfMin_RSI(\"D\", GetField(\"Close\",\"D\"), Length2);

Plot1(value1, \"分鐘與日RSI1\");

Plot2(value2, \"分鐘與日RSI2\");

setplotlabel(1, \"日RSI\");

setplotlabel(2, \"日RSI\");

case \"AD\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於還原日\");

value1 = xfMin_RSI(\"AD\", GetField(\"Close\",\"AD\"), Length1);

value2 = xfMin_RSI(\"AD\", GetField(\"Close\",\"AD\"), Length2);

Plot1(value1, \"分鐘與日RSI1\");

Plot2(value2, \"分鐘與日RSI2\");

setplotlabel(1, \"還原日RSI\");

setplotlabel(2, \"還原日RSI\");

end;

#### 📄 分鐘與日威廉指標

{@type:indicator}

// 跨頻率威廉指標，預設跨頻率為30分

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率60分鐘，跨頻率計算30分鐘威廉技術指標。

//

input:

Length1(14, \"天數一\"), Length2(28, \"天數二\"), Length3(42,
\"天數三\"),

FreqType(\"30\", \"跨頻率週期\",
inputkind:=dict(\[\"1分鐘\",\"1\"\],\[\"5分鐘\",\"5\"\],\[\"10分鐘\",\"10\"\],\[\"15分鐘\",\"15\"\],\[\"30分鐘\",\"30\"\],\[\"60分鐘\",\"60\"\],\[\"日\",\"D\"\],\[\"還原日\",\"AD\"\]));

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"此範例僅支援分鐘、日與還原日頻率\");

value1 = xfMin_PercentR(FreqType, Length1) - 100;

value2 = xfMin_PercentR(FreqType, Length2) - 100;

value3 = xfMin_PercentR(FreqType, Length3) - 100;

Plot1(value1, \"分鐘與日威廉指標1\");

Plot2(value2, \"分鐘與日威廉指標2\");

Plot3(value3, \"分鐘與日威廉指標3\");

// 防呆，大頻率跨小頻率時，在線圖秀不支援

//

switch (FreqType)

begin

case \"1\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

if barinterval \<\> 1 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於1分鐘\");

setplotlabel(1, \"1分威廉指標1\");

setplotlabel(2, \"1分威廉指標2\");

setplotlabel(3, \"1分威廉指標3\");

case \"5\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於5分鐘\");

setplotlabel(1, \"5分威廉指標1\");

setplotlabel(2, \"5分威廉指標2\");

setplotlabel(3, \"5分威廉指標3\");

case \"10\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於10分鐘\");

setplotlabel(1, \"10分威廉指標1\");

setplotlabel(2, \"10分威廉指標2\");

setplotlabel(3, \"10分威廉指標3\");

case \"15\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於15分鐘\");

setplotlabel(1, \"15分威廉指標1\");

setplotlabel(2, \"15分威廉指標2\");

setplotlabel(3, \"15分威廉指標3\");

case \"30\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於30分鐘\");

setplotlabel(1, \"30分威廉指標1\");

setplotlabel(2, \"30分威廉指標2\");

setplotlabel(3, \"30分威廉指標3\");

case \"60\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

if barinterval \<\> 1 and barinterval \<\> 2 and barinterval \<\> 3 and
barinterval \<\> 5 and barinterval \<\> 10 and barinterval \<\> 15 and
barinterval \<\> 20 and barinterval \<\> 30 and barinterval \<\> 45 and
barinterval \<\> 60 then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於60分鐘\");

setplotlabel(1, \"60分威廉指標1\");

setplotlabel(2, \"60分威廉指標2\");

setplotlabel(3, \"60分威廉指標3\");

case \"D\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於日\");

setplotlabel(1, \"日威廉指標1\");

setplotlabel(2, \"日威廉指標2\");

setplotlabel(3, \"日威廉指標3\");

case \"AD\":

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"AD\" then
raiseruntimeerror(\"不支援大頻率跨小頻率：主頻率大於還原日\");

setplotlabel(1, \"還原日威廉指標1\");

setplotlabel(2, \"還原日威廉指標2\");

setplotlabel(3, \"還原日威廉指標3\");

end;

#### 📄 週DMI-Osc

{@type:indicator}

// 跨頻率週DMI-Osc指標

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率週資料，跨頻率計算日DMI-Osc技術指標。

//

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"W\" and barfreq \<\> \"AD\" and barfreq \<\> \"AW\"
then raiseruntimeerror(\"不支援大頻率跨小頻率\");

input: Length( 14 );

variable: pdi_value(0), ndi_value(0), adx_value(0);

SetInputName(1, \"天數\");

xf_DirectionMovement(\"W\", Length, pdi_value, ndi_value, adx_value);

// 初始區波動較大, 先不繪出

//

if CurrentBar \< Length then

begin

pdi_value = 0;

ndi_value = 0;

adx_value = 0;

end;

Plot1(pdi_value - ndi_value, \"週DMI-Osc\");

#### 📄 週DMI

{@type:indicator}

// 跨頻率週DMI指標

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率週資料，跨頻率計算日DMI技術指標。

//

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"W\" and barfreq \<\> \"AD\" and barfreq \<\> \"AW\"
then raiseruntimeerror(\"不支援大頻率跨小頻率\");

input: Length(14);

variable: pdi_value(0), ndi_value(0), adx_value(0);

SetInputName(1, \"天數\");

xf_DirectionMovement(\"W\", Length, pdi_value, ndi_value, adx_value);

// 初始區波動較大, 先不繪出

//

if CurrentBar \< Length then

begin

pdi_value = 0;

ndi_value = 0;

adx_value = 0;

end;

Plot1(pdi_value, \"週+DI\");

Plot2(ndi_value, \"週-DI\");

Plot3(adx_value, \"週ADX\");

#### 📄 週KD

{@type:indicator}

// 跨頻率週KD指標

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率週資料，跨頻率計算日KD技術指標。

//

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"W\" and barfreq \<\> \"AD\" and barfreq \<\> \"AW\"
then raiseruntimeerror(\"不支援大頻率跨小頻率\");

input: Length(5), RSVt(3), Kt(3);

variable: rsv(0), k(0), \_d(0);

SetInputName(1, \"天數\");

SetInputName(2, \"RSVt權數\");

SetInputName(3, \"Kt權數\");

xf_stochastic(\"W\", Length, RSVt, Kt, rsv, k, \_d);

Plot1(k, \"週K(%)\");

Plot2(\_d, \"週D(%)\");

#### 📄 週MACD

{@type:indicator}

// 跨頻率週MACD指標

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率週資料，跨頻率計算日MACD技術指標。

//

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"W\" and barfreq \<\> \"AD\" and barfreq \<\> \"AW\"
then raiseruntimeerror(\"不支援大頻率跨小頻率\");

input: FastLength(12), SlowLength(26), MACDLength(9);

SetInputName(1, \"DIF短天數\");

SetInputName(2, \"DIF長天數\");

SetInputName(3, \"MACD天數\");

xf_macd(\"W\",xf_weightedclose(\"W\"),FastLength,SlowLength,MACDLength,value1,value2,value3);

// 前面區段資料變動較大, 先不繪出

//

if CurrentBar \<= SlowLength then

begin

Value1 = 0;

Value2 = 0;

Value3 = 0;

end;

Plot1(Value1, \"週DIF\");

Plot2(Value2, \"週MACD\");

Plot3(Value3, \"週Osc\");

#### 📄 週RSI

{@type:indicator}

// 跨頻率週RSI指標

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率週資料，跨頻率計算日RSI技術指標。

//

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"W\" and barfreq \<\> \"AD\" and barfreq \<\> \"AW\"
then raiseruntimeerror(\"不支援大頻率跨小頻率\");

input: Length1(6), Length2(12);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

Plot1(xf_RSI(\"W\", GetField(\"Close\",\"W\"), Length1), \"週RSI1\");

Plot2(xf_RSI(\"W\", GetField(\"Close\",\"W\"), Length2), \"週RSI2\");

#### 📄 週威廉指標

{@type:indicator}

// 跨頻率週威廉指標

// 不支援大頻率跨小頻率，例如：

// 不支援主頻率週資料，跨頻率計算日威廉技術指標。

//

if barfreq \<\> \"Tick\" and barfreq \<\> \"Min\" and barfreq \<\> \"D\"
and barfreq \<\> \"W\" and barfreq \<\> \"AD\" and barfreq \<\> \"AW\"
then raiseruntimeerror(\"不支援大頻率跨小頻率\");

input:

Length1(14, \"天數一\"),

Length2(28, \"天數二\"),

Length3(42, \"天數三\");

value1 = xf_PercentR(\"W\", Length1) - 100;

value2 = xf_PercentR(\"W\", Length2) - 100;

value3 = xf_PercentR(\"W\", Length3) - 100;

Plot1(value1, \"週威廉指標1\");

Plot2(value2, \"週威廉指標2\");

Plot3(value3, \"週威廉指標3\");

### 2.13 量能指標 (16 個)

#### 📄 BBI多空指數

{@type:indicator}

input:

a1(3,\"第一根均線天期\"),

a2(6,\"第二根均線天期\"),

a3(12,\"第三根均線天期\"),

a4(24,\"第四根均線天期\");

variable:BBI(0);

BBI=(average(close,a1)+average(close,a2)+average(close,a3)+average(close,a4))/4;

plot1(close-bbi,\"多空線\");

#### 📄 DKX多空線

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/dkx多空線/

}

input:length(10,\"MA期數\");

variable:MID(0),midsum(0),DKX(0),DKXMA(0),r1(0);

MID=(close\*3+open+high+low)/6;

DKX=WMA(MID,20);

dkxma=average(dkx,length);

plot1(close,\"收盤價\");

plot2(dkxma,\"多空線的移動平均線\");

#### 📄 KO成交量擺盪指標

{@type:indicator}

Input: length1(34); setinputname(1, \"短天期\");

Input: length2(55); setinputname(2, \"長天期\");

Input: length3(13); setinputname(3, \"平均天期\");

variable: kovolume(0), tp(0), ko(0), koaverage(0);

tp =(close+high+low)/3;

if tp \>= tp\[1\] then

kovolume = volume

else

kovolume = -volume;

ko = average(kovolume, length1) - average(kovolume, length2);

koaverage = average(ko, length3);

Plot1(ko, \"KO\");

Plot2(koaverage, \"平均\");

#### 📄 VSTD成交量標準差

{@type:indicator}

input:Period(22,\"期數\");

variable:VSTD(0);

VSTD=standarddev(VOLUME,Period,1);

PLOT1(VSTD,\"VSTD\");

#### 📄 WVAD威廉變異離散量

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/wvad威廉變異離散量/

}

input:length(5,\"期數\");

variable:wvad(0);

value1=close-open;

value2=high-low;

if high\<\>low then

value3=value1/value2\*volume

else

value3=value3\[1\];

wvad=summation(value3,length);

plot1(wvad,\"威廉變異離散量\");

#### 📄 上昇趨勢分數

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/上昇趨勢分數/

}

input:length(10,\"期數\");

variable: count1(0),count2(0),count3(0),count4(0),x1(0);

count1=0;

count2=0;

count3=0;

count4=0;

for x1=0 to length-1

if h\[x1\]\>h\[x1+1\] then count1=count1+1;

for x1=0 to length-1

if o\[x1\]\>o\[x1+1\] then count2=count2+1;

for x1=0 to length-1

if low\[x1\]\>low\[x1+1\] then count3=count3+1;

for x1=0 to length-1

if close\[x1\]\>close\[x1+1\] then count4=count4+1;

value1=count1+count2+count3+count4;

value2=value1-20;

plot1(value2,\"趨勢分數\");

#### 📄 交易活躍度指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/交易異常活躍指標/

}

input:day(66,\"移動平均天數\");

input:ratio(10,\"超出均值比率\");

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

variable:count(0);

value3=GetField(\"強弱指標\");

value4=average(value3,day);

value5=GetField(\"外盤均量\");

value6=average(value5,day);

value7=GetField(\"主動買力\");

value8=average(value7,day);

value9=GetField(\"開盤委買\");

value10=average(value9,day);

count=0;

if value3\>=value4\*(1+ratio/100) then

count=count+1;

if value5\>=value6\*(1+ratio/100) then

count=count+1;

if value7\>=value8\*(1+ratio/100) then

count=count+1;

if value9=value10\*(1+ratio/100) then

count=count+1;

value11=average(count,5);

plot1(value11,\"交易活躍度指標\");

#### 📄 修正式價量指標

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/修正式價量指標vptvolume-price-trend/

}

input:day(5,\"移動平均線天數\");

variable:tvp(0),mpc(0);

mpc=(open+high+low+close)/4;

if mpc\[1\]\<\>0 then

tvp=tvp\[1\]+(mpc-mpc\[1\])/mpc\[1\]\*volume

else

tvp=tvp\[1\];

plot1(tvp,\"修正型價量指標\");

#### 📄 四大力道線

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/改良版的移動平均線四大力道線/

}

input:period(10,\"天期參數\");

value1=summation(high-close,period);//上檔賣壓

value2=summation(close-open,period); //多空實績

value3=summation(close-low,period);//下檔支撐

value4=summation(open-close\[1\],period);//隔夜力道

if close\<\>0 then

value5=(value2+value3+value4-value1)/close;

plot1(value5,\"四大力道線\");

#### 📄 外盤量bband

{@type:indicator}

{

指標說明

https://www.xq.com.tw/xstrader/外盤量異常突出的買進策略/

}

input:length(20,\"期數\");

variable:bv(0),bva(0);

if volume\<\>0 then

bv=GetField(\"外盤量\")/volume\*100;

bva=average(bv,3);

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 = bollingerband(bva, Length, 1);

down1 = bollingerband(bva, Length, -1 );

mid1 = (up1 + down1) / 2;

if mid1\<\>0 then

bbandwidth = 100 \* (up1 - down1) / mid1;

plot1(up1, \"UB\");

plot2(bva, \"外盤量佔比\");

plot3(down1, \"LB\");

plot4(bbandwidth, \"BW\");

#### 📄 成交量擺盪指標

{@type:indicator}

Input: length1(5); setinputname(1, \"短天期\");

Input: length2(20); setinputname(2, \"長天期\");

Value1 = Average(Volume, length1);

Value2 = Average(Volume, length2);

if value1 = 0 then value3 = 0 else Value3 = (Value1 - Value2) \* 100 /
Value1;

Plot1(Value3, \"OSCV\");

#### 📄 當日成交密度

{@type:indicator}

variable:II(0);

if high-low\<\>0 and volume\<\>0 then

II=(2\*CLOSE-HIGH-LOW)/(HIGH-LOW)\*VOLUME;

PLOT1(average(II,5),\"成交密度\");

#### 📄 當日成交總筆數

{@type:indicator}

input:p1(5,\"短天期\");

input:p2(20,\"長天期\");

value1=GetField(\"總成交次數\");

value2=average(value1,p1);

value3=average(value2,p2);

plot1(value2,\"成交筆數短期均線\");

plot2(value3,\"成交筆數長期均線\");

#### 📄 累積量

{@type:indicator}

variable:tv(0);//當日累積量

if date\<\>date\[1\] then

tv=volume

else

tv=tv\[1\]+volume;

plot1(tv,\"累積量\");

#### 📄 週轉率

{@type:indicator}

if barfreq = \"Tick\" or barfreq = \"Min\"

then raiseruntimeerror(\"不支援此頻率\");

if GetField(\"發行張數(張)\") \<\> 0 then begin

value1 = volume / GetField(\"發行張數(張)\") \* 100;

plot1(value1,\"週轉率(%)\");

end else

noplot(1);

#### 📄 量比

{@type:indicator}

{量比公式 = 估計量 / 昨量

當量比 \> 1時表示量是放大的, 數值越大表示越強

支援商品：台(股票)}

if barfreq \<\> \"Min\" and barfreq \<\> \"D\" then

raiseruntimeerror(\"僅支援分鐘與日頻率\");

value1 = GetField(\"量比\");

plot1(value1, \"量比\");

plot2(1, \"基準線\");

## 3. 🔔 警示 (359 個腳本)

> 各類交易場景的即時警示腳本，涵蓋當沖、波段、籌碼監控等

### 3.1 !語法範例 (13 個)

#### 📄 1.基本語法

{@type:sensor}

//基本語法共有以下幾個元素

//1.宣告參數

//2.宣告變數

//3.引用時間序列的回傳值﹙包括開高低收成交量等﹚

//4.運用函數

//5.條件判斷：例如使用cross over這樣的關係因子

//6.設定警示條件：if.. then ret=1;

//在這邊我們用一個警示來示範這幾個基本語法的使用方式。

//=================範例：平均漲跌幅變大========================================

//1.宣告參數：利用input宣告輸入的參數。

//宣告後的參數，可以直接在警示中進場數值的調整，而不需要調整腳本內容

input:shortlength(5),longlength(20);

//參數的名稱，可以用setinputname來指定中文的說明

//指定後再設定警示參數時，就可以直接看到中文，而非參數英文名稱

//我們在這邊故意只指定第一個參數的中文名，讓大家看看效果

setinputname(1,\"短天期\");

//2.宣告變數，利用variable

//這是宣告一個變數叫xi，其初始值為0

variable:xi(0);

variable:yi(0);

//3.引用時間序列的回傳值﹙包括開高低收成交量等﹚

//系統也提供value1\~value99共99個不必宣告就可直接用的變數名稱

value1=close-close\[1\];//close\[1\]代表前一天收盤價

//4.運用函數

//透過absvalue這個函數取close-close\[1\]的絕對值

value2=absvalue(value1);

//指定變數值的計算公式，計算漲跌幅

yi=value2/close;

//透過average這個函數計算數列的平均值

value3=average(yi,longlength);//計算長期平均漲跌幅

value4=average(yi,shortlength);//計算短期平均漲跌幅

//5.條件判斷：例如使用cross over這樣的關係因子

//6.設定警示條件：if.. then ret=1;

//最後設定警示條件，當短期平均漲跌幅與長期平均漲跌幅黃金交叉時，觸發警示

if value4 crosses over value3

then ret=1;

#### 📄 2.getfield

{@type:sensor}

//除了一般K線的開高低收量之外，還可以透過getfield這樣的指令取得其他商品相關資訊

//例如可以讓使用者把台股特有的外資買賣超的資料拿來語法中運算

//只要在編輯器上打getfield就會列出可以使用的資料供user點選

//一樣可以透過\[n\]的方式來回傳前第n根的數值

//===========範例：外資連續多日買超超過1億元的語法==============================

//1.宣告參數：利用input宣告輸入的參數。

input:periods(3);//連續買超天數，預設是最近三天

input:last(10000);//單日最低買超金額，單位是萬元

//2.宣告變數，利用variable

variable:xi(1);

variable:count(0);

//4.運用函數

//利用getfield取得外資買賣超資料

value1=Getfield(\"外資買賣超\");//取得今日外資買賣超的值，單位是張數

value1=Getfield(\"外資買賣超\")\[1\];//取得昨日外資買賣超的值，單位是張數

value2=close\*value1/10;//收盤價\*張數為買超金額，再將單位調整成萬元

//今日盤中時,交易所並不會即時公告融資融券外資買賣超等籌碼資料

//須等到交易所公告資後後才能正確取得今日籌碼詳細資訊

//逐日計算是否滿足最低單日買超金額

for xi=1 to periods

begin

if value2\[xi\]\>last//單日外資買超超過最低要求數值

then count=count+1;

end;

//6.設定警示條件：if.. then ret=1;

if count=periods and
close/close\[1\]\<1.01//count=periods代表連續n日無一日不符合條件

then ret=1;

#### 📄 3.getquote

{@type:sensor}

//第三個範例，我們示範如何利用盤中即時數據﹙委買、委賣、內盤量、外盤量等等﹚來製作警示

//使用者可以透過\"getquote\"來取得這些數據

//只要在編輯器上打getquote就可以直接挑選所提供的欄位

//=====================範例：外盤漲停=======================================

//4.運用函數

//利用getfield取得買進價、賣出價及漲停價

value1=GetQuote(\"Ask\");//賣出價

value2=GetQuote(\"DailyUplimit\");//漲停價

value3=GetQuote(\"Bid\");//買進價

//可以用q_來取代GetQuote完成快速引用

//6.設定警示條件：if.. then ret=1;

//賣出價=漲停價 且買進價跟賣出價相差不超過0.5%

if value1=value2 and value1/value2\<=1.005

then ret=1;

#### 📄 4.if..then..else

{@type:sensor}

//if 條件1成立 then 動作1;

//這是常用的語法，代表滿足條件1時，執行動作1

//if 條件1成立 then 動作1 else 動作2;

//這是完整的語法，除了定義滿足條件1時，執行動作1外，還定義了不滿足條件1時，需執行動作2

//=====================範例：跳空上漲超過2%=======================================

//例如我們在股價跳空上漲超過2%時希望電腦可以通知我們，我們可以編寫腳本如下：

//1.宣告參數：利用input宣告輸入的參數。

input:percent(2);//宣告一個參數叫percent，預設值為2

variable:count(0);//宣告一個叫count的變數，初始值是0

//if 條件1成立 then 動作1;

//當出現2%跳空時，變數count等於1

if open \>= high\[1\]\*(1+percent/100)

then count=1; //只到這裡，這敘述最後必須加\";\"

//if 條件1成立 then 動作1 else 動作2;

//當count等於1時，觸發警示；count不等於1時，不觸發警示

if count=1

then ret=1 //有else時，這邊的敘述結束時就不必加上\";\"

else

ret=0;

//6.設定警示條件：if.. then ret=1;

//上面的句子可以簡化如下

if open \>= high\[1\]\* (1+percent/100)

then ret=1;

#### 📄 5.if..begin..end..then

{@type:sensor}

//當我們的條件需要多行敘述才能完成時，

//可以用begin..end來標示。

//=====================範例：累積漲幅達X%並且今日跳空開高超過Y%=======================================

//例如若要找出前N日漲幅超過X%且今天跳空開高超過Y%的股票

//1.宣告參數：利用input宣告輸入的參數。

input:N(3);//前N日

input:X(10);//前n日漲幅%

input:\_Y(4);//缺口大小%

if open\>high\[1\] then //跳空開高

//用begin來呈現if 之後要執行的不只一件的事情

begin

value1=(1-close\[1\]/close\[N\])\*100;//計算前N天的漲幅

value2=(open-high\[1\])/close\*100;//計算跳空缺口的大小

end;

//最後用end來宣告if之後要執行程式的結束

//6.設定警示條件：if.. then ret=1;

if value1\>=X and value2\>=\_Y

then ret=1;

#### 📄 6.condition條件的交集

{@type:sensor}

//就像value1\~value99是系統內建變數，其回傳值是一個數值

//condition1\~condition99是系統內建回傳true或false邏輯值的變數名稱

//於是我們在口語上的如果\~而且\~就通知我，這樣的語法很容易用這個方式來撰寫

//========範例：融資餘額前十天大減超過2000張且減幅超過兩成===================

//1.宣告參數：利用input宣告輸入的參數。

input: range1(2000);

input: percent(0.2);

condition1=false;//將condition1設成false狀態，一旦符合條件才轉成true

//4.運用函數

//利用getfield取得外資買賣超資料

value1=getfield(\"融資餘額張數\")\[1\];

value2=getfield(\"融資餘額張數\")\[10\];

if value2-value1\>range1 and
(value2-value1)/value2\>percent//計算融資增減張數

then condition1=true;//融資餘額前十天大減超過2000張且減幅超過兩成

//6.設定警示條件：if.. then ret=1;

//多重條件交易才觸發警示

if condition1 and average(close,20)/close\[1\]\>1.05 and
q_ask\>open//近20天跌幅超過5%且現在外盤超過開盤價

then ret=1;

#### 📄 7.0date(日期)的用法

{@type:sensor}

//系統用date來表示每根bar的日期，其回傳值為yyyymmdd，例如2013年3月20日為20130320

//=========================範例：大單買進========================

//1.宣告參數：利用input宣告輸入的參數。

input: atVolume(100); //最少要求的量

input: LaTime(10); //至少要有幾次

//2.宣告變數，利用variable

value1=GetField(\"內外盤\",\"Tick\");//內外盤標記 內盤為-1 外盤為1

variable: Xtime(0);//計數器

variable: intrabarpersist XDate(0);

//3.引用時間序列的回傳值﹙包括開高低收成交量等﹚

//日期函數應用

if Date \> XDate then Xtime =0; //開盤那根要歸0次數

XDate = Date;

if q_tickvolume \> atVolume and value1\>0 then Xtime=Xtime+1;
//外盤且單量夠大就加1次

//6.設定警示條件：if.. then ret=1;

if Xtime \> LaTime then ret=1;

#### 📄 7.1time(時間)的用法

{@type:sensor}

//系統用time來代表時間，顯示格式為hhmmss

//===========範例：開盤前三根K線都是陽線======================

//3.引用時間序列的回傳值﹙包括開高低收成交量等﹚

//時間函數應用

if time=091500 //時間是九點十五分

and close\>close\[1\] and close\>open

and close\[1\]\>close\[2\] and close\[1\]\>open\[1\]

and close\[2\]\>close\[3\] and close\[2\]\>open\[2\]

then ret=1;

#### 📄 8.0常用函數

{@type:sensor}

//函數是用來協助語法快速運算的功能

//===========範例：均線糾結======================

//1.宣告參數：利用input宣告輸入的參數。

input:shortLen(5),midLen(10),longLen(20),percent(0.02);

//4.運用函數

//透過average這個函數計算數列的平均值

value1=average(close,shortLen);//短期移動平均

value2=average(close,midLen);//中期移動平均

value3=average(close,longLen);//長期移動平均

value4=value1-value2;

value5=value2-value3;

value6=value1-value3;

//6.設定警示條件：if.. then ret=1;

if absvalue(value4)/close\<percent

and absvalue(value5)/close\<percent

and absvalue(value6)/close\<percent

and close crosses above maxlist(value1,value2,value3)

then ret=1;

#### 📄 9.0for(迴圈)的用法

{@type:sensor}

//迴圈是用來重複執行多次相同的敘述句

//==============================範例：開盤五分鐘創三次新高======================

variable: n(0);

variable: count(0);

if Barinterval=1 and barfreq =\"Min\" then Begin //適用於1分鐘線

//執行迴圈，檢查過去五分鐘高點過前高的次數

if time = 90500 then begin

for n=1 to 5
begin//以下的陳述(到end;為止)，n=1執行一次，n=2執行一次，一直到n=5

if high\[n\]\>high\[n-1\]

then count=count+1;

end;

end;

//設定警示條件：if.. then ret=1;

if count\>=3

then ret=1;

end;

#### 📄 9.1switch\...case

{@type:sensor}

//透過switch..case的語法，可以在一個變數的數值不一樣時，往不同的流程進行

//例如要計算外資過去十天買超超過七天時，可以運用以下的語法來寫腳本

//==============================範例：外資近日買超天數比例======================

//1.宣告參數：利用input宣告輸入的參數。

input:day(10);//過去幾天

input:ratio(0.7);//外資買超的天數佔多少比例

//2.宣告變數，利用variable

value1=GetField(\"Fdifference\");//外資買賣超

variable:count(0);

variable:xi(0);

for xi= 1 to day

begin

//============================================

switch(value1\[xi\])

begin

case \>0:

count=count+1;

case \<0:

count=count;

case 0:

count=count;

end;//所有case都表達完之後，最後必須加end;來表示各種數值選項已結束

//============================================

end;

//6.設定警示條件：if.. then ret=1;

if day\<\>0 and count/day\>=ratio

then ret=1;

#### 📄 9.2while(一直算到條件不符合)

{@type:sensor}

//還有另一種迴圈是while，會一直執行到條件不符合

//請小心不要造成無法跳出的無窮迴圈

//==============================範例：開盤五分鐘創三次新高﹙改用while迴圈﹚======================

variable: n(0);

variable: count(0);

if Barinterval=1 and barfreq =\"Min\" then Begin //適用於1分鐘線

//執行迴圈，檢查過去五分鐘高點過前高的次數

if time = 90500 then begin

n = 1;

while n \<= 5
begin//以下的陳述(到end;為止)，n=1執行一次，n=2執行一次，一直到n=5

if high\[n\]\>high\[n-1\]

then count=count+1;

n = n + 1;

end;

end;

//設定警示條件：if.. then ret=1;

if count\>=3

then ret=1;

end;

#### 📄 陣列例子

{@type:sensor}

//陣列可以用來存放多個相同屬性的變數值，而不需重複宣告

//2.宣告變數，利用variable

variable: i(0); //用來做迴圈的

//宣告陣列，名稱ValueArray，內含100個元素，索引值從0到99，初始值為0

array:ValueArray\[99\](0);

//利用迴圈將陣列的每個元素填入對應的值，

//例如：把過去1\~99的High指到ValueArray裡

//使得 ValueArray\[1\] =High\[1\] ,ValueArray\[2\] =High\[2\],

// ValueArray\[3\] =High\[3\] \... ValueArray\[99\] =High\[99\]

for i = 1 to 99

begin

ValueArray\[i\] = High\[i\] ;

end;

//陣列可以透過內建函數做運算

//如果要全部加總

value1 = Array_Sum(ValueArray,1,99);

//或是從第 7個加到第20個

value1 = Array_Sum(ValueArray,7,20);

//6.設定警示條件：if.. then ret=1;

if value1 \>= close \* 14

then ret=1;

### 3.2 1.籌碼監控 (17 個)

#### 📄 主力切入見真章

{@type:sensor}

input: pastDays(3); setinputname(1,\"近期天數\");

input: UpRatio(3.5); setinputname(2, \"上漲幅度(%)\");

input: \_buyAmount(3000); setinputname(3,\"累積金額(萬)\");

input:TXT(\"僅適用日線\"); setinputname(4,\"使用限制\");

variable: SumForce(0);

variable:intrabarpersist tickcounter(0);

settotalbar(pastdays + 3);

if BarFreq \<\> \"D\" then return;

if close \> close\[1\]\*(1 + UpRatio/100) then

begin

// 過去N日 主力買賣超的成交金額的總和

//

SumForce = Summation((AvgPrice \* GetField(\"主力買賣超張數\")/10)\[1\],
pastDays);

if SumForce \> \_buyAmount then ret =1;

end;

#### 📄 主力認賠再追賣

{@type:sensor}

input:TXT(\"僅適用日線\"); setinputname(1,\"使用限制\");

variable: pastDays(10);

settotalbar(15);

if BarFreq \<\> \"D\" then return;

if close \< lowest(low\[1\] ,pastDays) and

volume \> volume\[1\]\*0.5 and

GetField(\"主力買賣超張數\")\[1\] \< average(volume\[1\],pastDays)/-7
and

Summation(GetField(\"主力買賣超張數\")\[2\],pastDays) \>
Average(volume\[2\],pastDays)/7

then ret =1;

#### 📄 券增價漲再推升

{@type:sensor}

input: pastDays(10); setinputname(1,\"近期天數\");

input: UpRatio(3.5); setinputname(2, \"上漲幅度(%)\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

settotalbar(pastdays + 3);

if BarFreq \<\> \"D\" then return;

if close \> high\[1\] and close \> close\[1\]\*(1 + UpRatio/100) and

Getfield(\"融券餘額張數\")\[1\] =
highest(Getfield(\"融券餘額張數\")\[1\] ,pastDays)

then ret=1;

#### 📄 外資增持收新高

{@type:sensor}

input: pastDays(3); setinputname(1,\"近期天數\");

input: \_buyAmount(3000); setinputname(2,\"累積金額(萬)\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

variable: SumForce(0);

settotalbar(pastdays + 3);

if BarFreq \<\> \"D\" then return;

if close \> highest(high\[1\],pastDays) then

begin

// 過去N日外資買超金額

//

SumForce = Summation((AvgPrice \* GetField(\"外資買賣超\")/10)\[1\],
pastDays);

if SumForce \> \_buyAmount then ret =1;

end;

#### 📄 外資拉抬上攻

{@type:sensor}

input: pastDays(3); setinputname(1,\"計算天數\");

input: \_BuyRatio(25); setinputname(2,\"買超佔比例(%)\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

variable: SumForce(0);

variable: SumTotalVolume(0);

settotalbar(pastdays + 3);

if BarFreq \<\> \"D\" then return;

if Close \> High\[1\] then

begin

SumTotalVolume = Summation(volume\[1\], pastDays);

SumForce = Summation(GetField(\"外資買賣超\")\[1\], pastDays);

if SumForce \> SumTotalVolume \* \_BuyRatio / 100 then ret =1;

end;

#### 📄 外資換手再創高

{@type:sensor}

Input: Percent(30); SetInputName(1, \"外資換手比重(%)\");

input:TXT(\"僅適用日線\"); setinputname(2,\"使用限制\");

variable:FB(0); FB=GetField(\"外資買張\")\[1\];

variable:FS(0); FS=GetField(\"外資賣張\")\[1\];

settotalbar(5);

if BarFreq \<\> \"D\" then return;

if close \> high\[1\] and FB-FS \> 0 and (FB+FS) \> 2 \* volume\[1\] \*
Percent / 100 then ret=1;

#### 📄 實戶潛進終抬頭

{@type:sensor}

input: pastDays(3); setinputname(1,\"計算天數\");

input: \_BuyRatio(20); setinputname(2,\"買超佔比例(%)\");

input: length(20); setinputname(3, \"整理期間\");

input:TXT(\"僅適用日線\"); setinputname(4,\"使用限制\");

variable: MonthLine(0); //現在的整理期間位置

variable: SumForce(0);

variable: SumTotalVolume(0);

variable: counter(0);

settotalbar(pastdays + 3);

MonthLine = average(close\[1\],length);

if BarFreq \<\> \"D\" then return;

if Close crosses over MonthLine then

begin

counter = summationif(close\[1\] \< MonthLine, 1, pastDays);

if counter = pastDays then

begin

// 最近一段時間在月線底下的吃貨量

SumForce = summationif(close\[1\] \< MonthLine,
GetField(\"實戶買賣超張數\")\[1\], pastDays);

SumTotalVolume = Summationif(close\[1\] \< MonthLine, Volume\[1\],
pastDays);

if SumForce \> SumTotalVolume \* \_BuyRatio / 100 then ret =1;

end;

end;

#### 📄 投信加持卻遇襲

{@type:sensor}

Input: pastDays(5); setinputname(1, \"計算天數\");

Input: \_buyAmount(1000); setinputname(2, \"買超張數\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

variable: SumForce(0);

settotalbar(pastdays + 3);

if BarFreq \<\> \"D\" then return;

if close \< lowest(low\[1\], pastdays) then

begin

sumForce = Summation(GetField(\"投信買賣超\")\[1\], pastDays);

if sumForce \> \_buyAmount then ret=1;

end;

#### 📄 投信存股連拉升

{@type:sensor}

input: HoldRatio(50); setinputname(1,\"投信持股比例下限(%)\");

input: Length(25); setinputname(2, \"持股檢查區間\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

settotalbar(Length + 3);

if BarFreq \<\> \"D\" then return;

if GetField(\"投信持股比例\")\[1\]\> holdratio and

GetField(\"投信持股比例\")\[1\]=highest(GetField(\"投信持股比例\")\[1\],
Length) and

close \> close\[1\] and close\[1\] \> close\[2\] and close\[2\] \>
close\[3\]

then ret =1;

#### 📄 投信拉抬上攻

{@type:sensor}

input: pastDays(3); setinputname(1,\"計算天數\");

input: \_BuyRatio(25); setinputname(2,\"買超佔比例(%)\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

variable: SumForce(0);

variable: SumTotalVolume(0);

settotalbar(pastDays + 3);

if BarFreq \<\> \"D\" then return;

if Close \> High\[1\] then

begin

SumForce = Summation(GetField(\"投信買賣超\")\[1\], pastDays);

sumTotalVolume = Summation(Volume\[1\], pastDays);

if SumForce \> SumTotalVolume \* \_BuyRatio/100 then ret =1;

end;

#### 📄 散戶下車股價漲

{@type:sensor}

input:TXT(\"僅適用日線\"); setinputname(1,\"使用限制\");

settotalbar(3);

if BarFreq \<\> \"D\" then return;

if close \> high\[1\] and

GetField(\"散戶買賣超張數\")\[1\] \< volume\[1\] \* -0.1 then ret=1;

#### 📄 散戶撿到出貨後創低

{@type:sensor}

input: ChangeKshares(1000); setinputname(1,\"主力出貨張數\");

input:TXT(\"僅適用日線\"); setinputname(2,\"使用限制\");

settotalbar(3);

if BarFreq \<\> \"D\" then return;

if close \< low\[1\] and

GetField(\"主力買賣超張數\")\[1\] \< ChangeKshares\*-1 and

GetField(\"散戶買賣超張數\")\[1\] \> ChangeKshares

then ret=1;

#### 📄 法人主攻漲升

{@type:sensor}

input: pastDays(3); setinputname(1,\"計算天數\");

input: \_BuyRatio(25); setinputname(2,\"買超佔比例(%)\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

variable: SumForce(0);

variable: SumTotalVolume(0);

settotalbar(pastDays + 3);

if BarFreq \<\> \"D\" then return;

if Close \> High\[1\] and close\[1\] \> close\[2\] then

begin

SumForce = Summation(

(GetField(\"外資買賣超\")+GetField(\"自營商買賣超\")+GetField(\"投信買賣超\"))\[1\],

pastDays);

SumTotalVolume = Summation(Volume\[1\], pastDays);

if SumForce \> SumTotalVolume \* \_BuyRatio / 100 then ret =1;

end;

#### 📄 自營商增持收新高

{@type:sensor}

input: pastDays(3); setinputname(1,\"近期天數\");

input: \_buyAmount(3000); setinputname(2,\"累積金額(萬)\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

variable: SumForce(0);

if BarFreq \<\> \"D\" then return;

if close \> highest(high\[1\],pastDays) then

begin

SumForce = Summation((AvgPrice \* GetField(\"自營商買賣超\")/10)\[1\],
pastDays);

if SumForce \> \_buyAmount then ret =1;

end;

#### 📄 自營商拉抬上攻

{@type:sensor}

input: pastDays(3); setinputname(1,\"計算天數\");

input: \_BuyRatio(25); setinputname(2,\"買超佔比例(%)\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

variable: SumForce(0);

variable: SumTotalVolume(0);

settotalbar(pastDays + 3);

if BarFreq \<\> \"D\" then return;

if Close \> High\[1\] then

begin

SumForce = Summation(GetField(\"自營商買賣超\")\[1\], pastDays);

SumTotalVolume = Summation(Volume\[1\], pastDays);

if SumForce \> SumTotalVolume \* \_BuyRatio / 100 then ret =1;

end;

#### 📄 融資追捧戰新高

{@type:sensor}

input: pastDays(10); setinputname(1,\"計算天數\");

input:TXT(\"僅適用日線\"); setinputname(2,\"使用限制\");

settotalbar(pastDays + 3);

if BarFreq \<\> \"D\" then return;

if Getfield(\"融資餘額張數\")\[1\] =
highest(Getfield(\"融資餘額張數\")\[1\] ,pastDays) and

close \>= highest(high\[1\],pastDays)

then ret=1;

#### 📄 連日外盤攻擊創新高

{@type:sensor}

input:TXT(\"僅適用日線\"); setinputname(1,\"使用限制\");

settotalbar(3);

if BarFreq \<\> \"D\" then return;

if Close \> maxlist(high\[1\],high\[2\]) and
GetField(\"內盤量\",\"D\")\>0 and GetField(\"外盤量\") \>
GetField(\"內盤量\",\"D\") \* 1.2 then

begin

if TrueAll(Getfield(\"外盤量\")\[1\] \> 1.1 \*
Getfield(\"內盤量\")\[1\], 3) then ret=1;

end;

### 3.3 2.市場常用語 (23 個)

#### 📄 N期內創新高次數

{@type:sensor}

input:Length(10); setinputname(1,\"N期內\");

input:mNewHighTimes(3); setinputname(2,\"創M次以上新高\");

variable: la(Length-1); //日數與參數調整

variable: QHigh(0); Qhigh=high\[la\]; //含當根K棒 最左邊第一筆資料起算

variable: \_outputdays(0);　　\_outputdays=0; //每跟K要歸0

variable: i(0); //迴圈用數

settotalbar(Length + 3);

for i = 1 to la begin

if ( high\[la-i\] \> QHigh ) then

begin

\_outputdays+=1;　　

　QHigh = high\[la-i\];

end;

end;

if high = QHigh and \_outputdays \>= mNewHighTimes then ret=1;

#### 📄 N期內破底次數

{@type:sensor}

input:Length(10); setinputname(1,\"n期內\");

input:mNewLowTimes(3); setinputname(2,\"創幾次以上新低\");

variable: la(Length-1); //日數與參數調整

variable: QLow(0); QLow=Low\[la\]; //含當根K棒 最左邊第一筆資料起算

variable: \_outputdays(0);　　\_outputdays=0; //每跟K要歸0

variable: i(0); //迴圈用數

settotalbar(Length + 3);

for i = 1 to la begin

if ( Low\[la-i\] \< QLow ) then

begin

\_outputdays+=1;　　

　QLow = Low\[la-i\];

end;

end;

if Low = QLow and \_outputdays \>= mNewLowTimes then ret=1;

#### 📄 今日多方表態

{@type:sensor}

{三次到頂而破}

variable:CaliPrice(0),peakIndex(0),MaxPeak(0);

Array:peakDate\[50\](0),peakPrice\[50\](0),LongTrendPercent\[50\](0);

CaliPrice = (High\[0\]+Low\[0\]+Close\[0\])/3;

if CaliPrice\[2\] = MaxList(CaliPrice
,CaliPrice\[1\],CaliPrice\[2\],CaliPrice\[3\],CaliPrice\[4\]) and
High\[2\] \> CaliPrice\[4\]\*1.02 and High\[2\] \> CaliPrice\[0\]\*1.02
then begin

peakDate\[peakIndex\] = Date\[2\];peakPrice\[peakIndex\] = High\[2\];

if peakIndex = 0 then LongTrendPercent\[peakIndex\] = ( High\[2\]/
Close\[2+20\]-1)\*100;

if peakIndex \> 0 and DateDiff(date,peakDate\[peakIndex-1\]) \>5 then
LongTrendPercent\[peakIndex\] = ( High\[2\]/ Close\[2+20\]-1)\*100;

peakIndex+=1;

end;

if Date=CurrentDate and Close \> Open then begin

if peakIndex \>2 and Absvalue(peakPrice\[peakIndex-1\]/
peakPrice\[peakIndex-2\]-1 )\< 0.01 and DateDiff(Date,
peakDate\[peakIndex-1\])\>20 then condition1 =true ;

if condition1 and Close\*1.065 \> highest(high\[1\],100) and

minlist(low\[100\],low\[99\],low\[98\],low\[97\],low\[96\]) =
Lowest(Low,100) and

peakIndex \>3 and LongTrendPercent\[peakIndex-2\] \>20 and

Absvalue( peakPrice\[peakIndex-1\]/ peakPrice\[peakIndex-2\]-1 )\< 0.01
and

DateDiff( peakDate\[peakIndex-2\] ,peakDate\[peakIndex-3\]) \> 20 and

DateDiff( peakDate\[peakIndex-1\] ,peakDate\[peakIndex-2\]) \> 5 and

Date \< DateAdd(peakDate\[peakIndex-1\],\"D\",20)

then begin

MaxPeak =MaxList(peakPrice\[peakIndex-1\],peakPrice\[peakIndex-2\]);

if Close \> MaxPeak\*1.005 and C\>O then ret=1;

end;

end;

{激烈波動}

if Date =currentdate then begin

variable:STDEV(standarddev(volume\[1\],19,1)\*3);

if C\>O and Volume\*GetField(\"均價\") \> 30000{仟元} and Close \>
High\*0.99 and high = highest(high,20) and
highest(high\[1\],19)/lowest(Low\[1\],19) - 1 \<0.065 and

TrueAll(ABSValue(high\[1\]/low\[1\]-1)\<0.04,15) and Volume \>
average(Volume\[1\],19)+STDEV then ret=1;

end;

{波段初漲}

variable:hHigh(0),pC(0),iHigh(0),iLow(10000),iDate(0),eLow(10000);

if DateDiff(currentdate,date) \< 93 then begin

eLow = minlist(low,elow);

if DateDiff(currentdate,date) \>=90 then begin iHigh =high; iDate= Date;
value1=open; end;

hHigh = maxlist(high,hHigh);

if eLow = Low then hHigh = low;

if hHigh \> iHigh then begin

if C\>O and iHigh\<\> iLow and close\> eLow\*1.08 and
DateDiff(Date,iDate)\> 30 and v\>500 then ret=1;

iHigh =hHigh;iLOw = hHigh;iDate =Date;

end else iLow =minlist(Low,iLow);

end;

{突破均線極度糾結}

variable:VSTDEV(1000000),PSTDEV(1000),AVG1(0),AVG2(0),AVG3(0),AVG4(0);

AVG1 = average(close,5);AVG2 = average(close,10);AVG3 =
average(close,20);AVG4 = average(close,60);

if Date = currentdate then begin

VSTDEV=standarddev(volume\[1\],19,1)\*3;

PSTDEV=standarddev(H\[1\]-L\[1\],19,1)\*3;

if volume \< average(Volume\[1\],19)+VSTDEV or (C-O)/(H-L) \< 0.7 then
return;

if C\>O and Close \> maxlist(AVG1,AVG2,AVG3,AVG4) and C \> L +PSTDEV and
TrueAll( H\[1\]/L\[1\]-1 \< 0.07,20) and

TrueAll(maxlist(AVG1,AVG2,AVG3,AVG4)/Maxlist(
Minlist(AVG1,AVG2,AVG3,AVG4),0.01)-1 \< 0.035,20) then ret=1;

end;

#### 📄 今日資券籌碼分析

{@type:sensor}

variable:i(1);

if Currenttime \> 220000 or Currenttime \< 083000 then i=0;

settotalbar(3);

if GetField(\"成交金額\")\[i\]\>10000000 and
GetField(\"融資使用率\")\[i+1\] \> 0 and

(GetField(\"融資使用率\")\[i\]/GetField(\"融資使用率\")\[i+1\]-1)\*100
\* (C\[i\]/C\[i+1\]-1)\*100 \>40

then ret=1;

if C\[i\] \> C\[i+2\]\*1.1 and
(GetField(\"融券增減張數\")\[i\]\*C\[i\])\> 10000 then ret=1;

#### 📄 分鐘暴量n%

{@type:sensor}

input:percent(100); setinputname(1,\"量增比例%\");

input:Length(200); setinputname(2,\"均量期數\");

input:XLimit(True); setinputname(3,\"限制最低觸發門檻\");

input:atVolume(500); setinputname(4,\"最低觸發張數\");

input:TXT(\"建議使用分鐘線\"); setinputname(5,\"使用說明\");

variable: AvgVolume(0);

settotalbar(Length + 3);

AvgVolume=Average(volume,Length);

if XLimit then

begin

if Volume \> atVolume and volume \> AvgVolume \*(1+ percent/100) then
ret=1;

end

else

begin

if Volume \> Volume\[1\] and volume \> AvgVolume \*(1+ percent/100) then
ret=1;

end;

#### 📄 外盤漲停

{@type:sensor}

settotalbar(3);

if GetField(\"漲停價\", \"D\") = q_Ask and close \<\>
GetField(\"漲停價\", \"D\") then ret=1;

#### 📄 多次觸底而破

{@type:sensor}

input:HitTimes(3); setinputname(1,\"設定觸底次數\");

input:RangeRatio(1); setinputname(2,\"設定底部區範圍寬度%\");

input:Length(20); setinputname(3,\"計算期數\");

settotalbar(Length + 3);

variable: theLow(0); theLow = lowest(low\[1\],Length);
//找到過去期間的最低點

variable: LowUpperBound(0); LowUpperBound = theLow
\*(100+RangeRatio)/100; // 設為瓶頸區間上界

variable: TouchRangeTimes(0); TouchRangeTimes=0;
//期間中進入瓶頸區間的低點次數,每根K棒要歸0

variable: ix(0);

for ix = length-1 downto 1

begin

if Low\[ix\] \< LowUpperBound then TouchRangeTimes +=1; //回算在此區間中
進去瓶頸區的次數

end;

if TouchRangeTimes \>= HitTimes and (q_bid \<theLow or close \< theLow)
then ret=1;

#### 📄 大單敲進

{@type:sensor}

input: atVolume(100); setinputname(1,\"大單門檻\");

input: LaTime(10); setinputname(2,\"大單筆數\");

input:TXT(\"須逐筆洗價\"); setinputname(3,\"使用限制\");

settotalbar(3);

variable: intrabarpersist Xtime(0);//計數器

variable: intrabarpersist Volumestamp(0);

variable: intrabarpersist XDate(0);

Volumestamp =GetField(\"Volume\", \"D\");

if Date \> XDate or Volumestamp = Volumestamp\[1\] then Xtime =0;
//開盤那根要歸0次數

XDate = Date;

if GetField(\"Volume\", \"Tick\") \> atVolume and
GetField(\"內外盤\",\"Tick\")=1 then Xtime+=1; //量夠大就加1次

if Xtime \> LaTime then

begin

ret=1;

Xtime=0;

end;

#### 📄 急拉

{@type:sensor}

input:P1(1.5); setinputname(1,\"急拉幅度%\");

settotalbar(3);

IF close \> close\[1\]\*(1+P1/100) and close=high and
volume\>volume\[1\]

then ret=1;

#### 📄 急殺

{@type:sensor}

input:P1(1.5); setinputname(1,\"急殺幅度%\");

settotalbar(3);

IF close \< close\[1\]\*(1-P1/100) and close=Low and volume\>volume\[1\]

then ret=1;

#### 📄 拉尾盤

{@type:sensor}

input:Ratio(1); setinputname(1,\"拉尾盤幅度%\");

input:tTime(130000); setinputname(2,\"尾盤切算時間%\");

input:TXT(\"限用5分鐘以下\"); setinputname(3,\"使用限制\");

if barfreq \<\> \"Min\" or barinterval \> 5 then return;

settotalbar(3);

variable:fPrice(0); if date\<\>date\[1\] then fPrice=0;

if time \< tTime then fPrice = Close else

if Close \> fPrice\*(1+Ratio/100) and time \>= tTime and fPrice\>0

then RET=1;

#### 📄 殺尾盤

{@type:sensor}

input:TXT(\"限用10分鐘以下\"); setinputname(1,\"使用限制\");

settotalbar(3);

variable:KeyPrice(0);

if Date\> date\[1\] then KeyPrice = 0; // 換日的話則重新定義KeyPrice

if time\>132000 and KeyPrice = 0 then KeyPrice =close;

if KeyPrice \> 0 and close \<= KeyPrice
\*0.99//時間超過13:20分且十分鐘跌幅超過1%

then ret=1;

#### 📄 當日上漲n%

{@type:sensor}

input:percent(1.5); setinputname(1,\"當日上漲幅度%\");

settotalbar(3);

variable:WorkTrue(true);

if WorkTrue and currenttime \<= TimeAdd(time,\"M\",1) and

Close \> GetField(\"RefPrice\", \"D\") \* (1+ Percent/100) then

begin

Ret=1;

WorkTrue =false;

end;

if WorkTrue =false and Close \< GetField(\"RefPrice\", \"D\") \* (1+
Percent/100) then WorkTrue =true;

#### 📄 盤中多方警示

{@type:sensor}

settotalbar(20);

array:intrabarpersist Trigger\[20\](True);

Array: intrabarpersist MK\[330,6\](0),intrabarpersist MD\[7\](1);
{Time,Open,High,Low,Close,Volume}

variable:intrabarpersist BI(1),OT(090000){開盤時間},MF{KBbar頻率}(1);

if CurrentTime \< TimeAdd(OT,\"M\",BI\*MF) then

begin

MD\[2\]=MaxList(MD\[2\],C); MD\[3\]=MinList(MD\[3\],C);MD\[4\]=C;
MD\[7\]+=q_TickVolume;

if BI =1 then begin MD\[1\]=GetField(\"Open\",
\"D\");MD\[2\]=GetField(\"High\", \"D\");MD\[3\]=GetField(\"Low\",
\"D\") ;end;

end else begin

MK\[BI,0\]=TimeAdd(OT,\"M\",BI-1);MK\[BI,1\]=MD\[1\];MK\[BI,2\]=MD\[2\];MK\[BI,3\]=
MD\[3\];MK\[BI,4\]= MD\[4\];MK\[BI,5\]=GetField(\"Volume\",
\"D\")-q_TickVolume-MD\[5\];

BI+=1; MD\[1\]=C;MD\[2\]=C;MD\[3\]=C;MD\[4\]=C;
MD\[5\]=GetField(\"Volume\", \"D\")-q_TickVolume; MD\[7\]=q_TickVolume;

end;

array:intrabarpersist Q1\[100,3\](90000),intrabarpersist
Q2\[10,3\](90000),intrabarpersist QI\[5,5\](0); QI\[1,4\] = 99;
QI\[2,4\] = 9;

variable:QD(1);

for QD = 1 to 2

begin

if QI\[QD,1\] \< QI\[QD,4\] then QI\[QD,1\]+=1 else QI\[QD,1\]=0;

if QI\[QD,1\] =0 then QI\[QD,2\]=QI\[QD,4\] else
QI\[QD,2\]=QI\[QD,2\]-1;

if QI\[QD,1\] =QI\[QD,4\] then QI\[QD,3\]=0 else
QI\[QD,3\]=QI\[QD,1\]+1;

end;

Q1\[QI\[1,1\],0\] = currenttime;Q1\[QI\[1,1\],1\] =
Close;Q1\[QI\[1,1\],2\] = q_TickVolume;

Q2\[QI\[2,1\],0\] = currenttime;Q2\[QI\[2,1\],1\] =
Close;Q2\[QI\[2,1\],2\] = q_TickVolume;

{=============}

variable:TA1(-1),TA2(-1),AVGX(10000);

if Date = currentdate then begin

if TA1 = -1 then TA1 = Countif( GetField(\"融資增減張數\")\[1\]\<0,10);

variable: forceratio(0);

if V\[1\] \> 0 then forceratio =
GetField(\"主力買賣超張數\")\[1\]/V\[1\] else forceratio =
forceratio\[1\];

if TA2 = -1 then TA2 = Summation(forceratio,10);

if AVGX =10000 then AVGX = Average(Close,5);{五日}

end;

{=============}

{開盤處理融資追繳後的反彈}

if Trigger\[19\] then if currenttime \< 093000 and Close \> Low \*1.02
and Close \> Open and V \> V\[1\]\*0.6 and
TA1=10{融資增減張數之減少天數}

and Low = Lowest(Low,20) and Low \< Highest(high,20)\*0.7 then begin
ret=1; trigger\[19\]=false; end;

if h \> highest(h\[1\],8) and v \< highest(v\[1\],18)\*BI/135 then
return;

{過濾}

if Close = GetField(\"漲停價\", \"D\") or Close \<
highest(high,10)\*0.95 or GetField(\"均價\")\*GetField(\"Volume\",
\"D\") \< 10000{仟元}

or Close \< GetField(\"Volume\", \"D\")\*0.985 or Date \<currentdate

or Close \> AVGX\*1.25 or Close \> C\[5\]\*1.25 then return;

{1.1分鐘線爆量上漲}

if Trigger\[1\] then if MD\[7\] \> (V\[1\]+V)/(270+BI)\*3 and Close \>
MD\[1\]\*1.01 then begin ret=1; trigger\[1\]=false; end;

{2.5分鐘線3連陽}

if Trigger\[2\] then if BI \>= 15 and MK\[BI,4\]\> MK\[BI-4,1\] and
MK\[BI-5,4\]\> MK\[BI-9,1\] and MK\[BI-10,4\] \> MK\[BI-14,1\] then
begin ret=1; trigger\[2\]=false; end;

{3.連日盤整後急拉}

if Trigger\[3\] then if Close \> Q2\[QI\[2,3\],1\]\*1.015 and
TimeDiff(currenttime, Q2\[QI\[2,3\],0\],\"M\") \<5 and
TrueAll(absvalue(high\[1\]/low\[1\]-1) \< 0.03,10) then begin ret=1;
trigger\[3\]=false; end;

{4.主動性買盤大增} variable: AvgOutSideVol(averageIF( close \>
close\[1\] ,volume,15));

if Trigger\[4\] then if GetField(\"外盤量\", \"D\") \>
AvgOutSideVol\*1.5 then begin ret=1; trigger\[4\]=false; end;

{5.多頭波動表態}
variable:STDEV(standarddev(High\[1\]-Low\[1\],15,1)\*3);

if Trigger\[5\] then if q_PriceChangeRatio \>3{%} and
Volume\*GetField(\"均價\") \> 30000{仟元} and High \> Low +
average(High\[1\]-Low\[1\],15)+STDEV then begin ret=1;
trigger\[5\]=false; end;

{6.多方放量待起漲} variable:VSTDEV(standarddev(volume,15,1)\*3);

if Trigger\[6\] then if q_PriceChangeRatio\>2{%} and volume \>
average(volume\[1\],15)+3\*VSTDEV and close \>
highest(high\[1\],15)\*0.965 then begin ret=1; trigger\[6\]=false; end;

{7.連日強攻再滾量攻高}

if Trigger\[7\] then if BI\>3 and Close \> High\[1\] and
(MK\[BI,5\]+MK\[BI-1,5\]+MK\[BI-2,5\])\*GetField(\"均價\") \>
10000{仟元} and CountIF(high\>high\[1\],10) \> 7 then begin ret=1;
trigger\[7\]=false; end;

{8.10個1分鐘階梯連漲} variable:Steps(true);

if Trigger\[8\] then if BI\>10 then begin for QD=0 to 9 begin Steps =
Steps and (MK\[BI-QD,4\]\>MK\[BI-1-QD,4\]); end; if Steps then begin
ret=1; trigger\[8\]=false; end; ;end;

{9.多方人氣急增}

if Trigger\[9\] then if BI\>4 and q_PriceChangeRatio \> 2{%} and
MK\[BI,4\]\> MK\[BI-1,1\] and MK\[BI-1,4\]\> MK\[BI-3,1\] and (TimeDiff(
currenttime, Q1\[QI\[1,3\],0\],\"S\")- TimeDiff(currenttime,
Q2\[QI\[2,3\],0\],\"S\"))/90 \> TimeDiff(currenttime,
Q2\[QI\[2,3\],0\],\"S\")\*3/10 then begin ret=1; trigger\[9\]=false;
end;

{10.主力決心作價}

if Trigger\[10\] then if V\*GetField(\"均價\")\> 30000{仟元} and
TA2{\"主力買賣超張數\"} \> 0.33 and high= Highest(High,10) then begin
ret=1; trigger\[10\]=false; end;

{11.開盤快速急攻}

if Trigger\[11\] then if CurrentTime \< 091500 and q_PriceChangeRatio
\>2{%} and Volume\*GetField(\"均價\") \> 30000{仟元} and high
=Highest(High,15) and High \> Low\[1\] +
average(High\[1\]-Low\[1\],15)+STDEV then begin ret=1;
trigger\[11\]=false; end;

{12.2%門前急拉}

if Trigger\[12\] then if Q2\[QI\[2,1\],1\] \< GetField(\"RefPrice\",
\"D\") \*1.02 and close \>= GetField(\"RefPrice\", \"D\") \*1.02 and
Close \* q_TickVolume \>500{仟元} and Close \> Q2\[QI\[2,3\],1\]\*1.01
and timediff(Currenttime,Q2\[QI\[2,3\],0\],\"M\")\< 3{分鐘} then begin
ret=1; trigger\[12\]=false; end; {3分鐘內快速拉升}

{13.下殺後反彈過今高}

if Trigger\[13\] then if Close \> GetField(\"RefPrice\", \"D\") and
Close \> GetField(\"Open\", \"D\") and Close = GetField(\"Volume\",
\"D\") and Close \>= GetField(\"Low\", \"D\")\*1.02 then begin ret=1;
trigger\[13\]=false; end;

{14.帶量衝新高}

if Trigger\[14\] then if Close = GetField(\"Volume\", \"D\") and Close
\> highest(H\[1\],20) and Close\*q_TickVolume \> 3000 then begin ret=1;
trigger\[14\]=false; end;

{15.開盤15分鐘一路向上不回頭} variable:Counter(0);

if Trigger\[15\] then If BI =15 then for QD =0 to 13 if MK\[BI-QD,4\] \>
MK\[BI-1-QD,4\] then Counter+=1; if Counter \> 12 then begin ret=1;
trigger\[15\]=false; end;

#### 📄 突破上切線

{@type:sensor}

input:Length(20); setinputname(1,\"上切計算期數\");

input:Rate(50); setinputname(2,\"陡增率\");

settotalbar(Length + 3);

variable: Factor(0);

Factor = 100/Close\[Length\];

if close \> open and close \> highest(high\[1\],Length) and

(linearregslope(high\*Factor,3)
-linearregslope(high\*Factor,Length))\>Rate\*0.01

then ret=1;

#### 📄 翻紅

{@type:sensor}

settotalbar(7);

if close crosses over close\[1\]

then ret=1;

#### 📄 翻黑

{@type:sensor}

settotalbar(7);

if close crosses under close\[1\]

then ret=1;

#### 📄 資減券增

{@type:sensor}

input:x1(300);setinputname(1,\"融資減少張\");

input:x2(200);setinputname(2,\"融券增加張\");

input:x3(10); setinputname(3,\"全計佔成交量比例%\");

input: Type(1); setinputname(4,\"最新資料：0=今日、1=昨日\");

input: TXT1(\"僅適用日線\"); setinputname(5,\"使用限制\");

input: TXT2(\"盤中無當日資券資料\");
setinputname(6,\"建議使用單次洗價模式\");

settotalbar(3);

value1=GetField(\"融資增減張數\")\[Type\];//融資增減張數

value2=GetField(\"融券增減張數\")\[Type\];//融券增減張數

if value1 \<-x1 and

value2 \> x2 and

(value2-value1)/volume\[Type\]\>x3/100

then ret=1;

#### 📄 近日多方火力集中

{@type:sensor}

settotalbar(10);

variable:CDay(3);

variable:i(1),XData(0),XDataAmount(0),XAmount(0),XV(0),XPrice(0),Trigger(False);

if Currenttime \> 170000 or Currenttime \< 083000 then i=0;

Trigger=False;

XAmount =Summation(GetField(\"成交金額\")\[i\],CDay);XV =
Summation(V\[i\],CDay);XPrice = XAmount/XV/1000;

XDataAmount = Summation(GetField(\"主力買賣超張數\")\[i\],CDay)/XV; if
XDataAmount\>0.2 and trueall( XDataAmount\[1\]\<0.1,5) then
Trigger=true;

XDataAmount = Summation(GetField(\"實戶買賣超張數\")\[i\],CDay)/XV; if
XDataAmount\>0.25 and trueall( XDataAmount\[1\]\<0.1,5) then
Trigger=true;

XDataAmount = Summation(GetField(\"控盤者買賣超張數\")\[i\],CDay)/XV; if
XDataAmount\>0.25 and trueall( XDataAmount\[1\]\<0.1,5) then
Trigger=true;

if C\[i\]\> XPrice and V\>300 and Trigger then ret=1;

variable:iHigh(0),iDate(0);

if high \> iHigh then begin iHigh= high;iDate= Date; end;

if DateDiff(Date,iDate) \>30 and C \> iHigh \*0.935 and C\<iHigh and

(Summation(GetField(\"外資買賣超\")\[i\]\*XPrice,CDay) \> 30000 or

Summation(GetField(\"投信買賣超\")\[i\]\*XPrice,CDay) \> 30000 or

Summation(GetField(\"自營商買賣超\")\[i\]\*XPrice,CDay) \> 30000)

then ret=1;

#### 📄 連日量縮下跌

{@type:sensor}

input:percent(4);setinputname(1,\"累計下跌幅度%\");

input:ratio(20); setinputname(2,\"量縮幅度%\");

input:Length(3);setinputname(3,\"持續期數\");

settotalbar(Length + 3);

if close\[Length-1\] \> Close \* (1+percent/100) and

volume\[Length-1\] \> Volume\* (1+ratio/100) and

TrueAll(Close \< Close\[1\] ,Length-1)

then ret=1;

#### 📄 開低走高

{@type:sensor}

input:OpenGap(1); setinputname(1,\"開低幅度%\");

input:uppercent(1);setinputname(2,\"從最低點反彈上揚幅度%\");

settotalbar(3);

if GetField(\"Low\", \"D\") = GetField(\"Open\", \"D\") and

GetField(\"Open\", \"D\") \< GetField(\"RefPrice\", \"D\") \* (1-
OpenGap/100) and

q_Last \> GetField(\"Low\", \"D\") \* (1+uppercent/100)

then ret=1;

#### 📄 開高走低

{@type:sensor}

input:OpenGap(1); setinputname(1,\"開高幅度%\");

input:Downpercent(1);setinputname(2,\"從最高點回檔下跌幅度%\");

settotalbar(3);

if GetField(\"High\", \"D\") = GetField(\"Open\", \"D\") and

GetField(\"Open\", \"D\") \> GetField(\"RefPrice\", \"D\") \* (1+
OpenGap/100) and

Close \< GetField(\"High\", \"D\") \* (1 - Downpercent/100)

then ret=1;

#### 📄 高點回檔n%

{@type:sensor}

input:Length(20); setinputname(1,\"尋找高點期數\");

input:percent(7); setinputname(2,\"自高點回檔幅度%\");

settotalbar(Length + 3);

if close \< highest(high,Length)\*(1- percent/100) then Ret=1;

### 3.4 3.出場常用警示 (38 個)

#### 📄 DMI賣出訊號

{@type:sensor}

input:Length(14); setinputname(1,\"計算期數\");

variable: pdi(0), ndi(0), adx_value(0);

settotalbar(maxlist(Length,6) \* 13 + 8);

DirectionMovement(Length, pdi, ndi, adx_value);

if pdi\<pdi\[1\] and ndi\>ndi\[1\] and ndi crosses over pdi

then ret=1;

#### 📄 KD高檔死亡交叉

{@type:sensor}

input: Length(9), RSVt(3), Kt(3), HighBound(75);

SetTotalBar(maxlist(Length,6) \* 3 + 8);

SetInputName(1, \"計算期數\");

SetInputName(2, \"RSVt權數\");

SetInputName(3, \"Kt權數\");

setInputName(4, \"高檔區\");

variable: rsv(0), k(0), \_d(0);

Stochastic(Length, RSVt, Kt, rsv, k, \_d);

if k\>HighBound and k crosses under \_d

then ret=1;

#### 📄 MACD出現賣出訊號

{@type:sensor}

input: FastLength(12), SlowLength(26), MACDLength(9);

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 3 + 8);

SetInputName(1, \"DIF短期期數\");

SetInputName(2, \"DIF長期期數\");

SetInputName(3, \"MACD天數\");

variable: difValue(0), macdValue(0), oscValue(0);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

Ret = oscValue Crosses Below 0;

#### 📄 MTM轉負

{@type:sensor}

input: Length(10); SetInputName(1, \"期數\");

settotalbar(maxlist(Length,6) + 8);

if momentum(close,Length) crosses under 0 then ret=1;

#### 📄 OBV退潮

{@type:sensor}

input:Length(15); setinputname(1,\"計算期數\");

variable: OBVolume(0);

settotalbar(10);

value1 = close-close\[1\];

if close\<\> close\[1\] then

OBVolume += Volume\*(value1)/absvalue(value1);

if close\<highest(high,Length) and

OBVolume\[2\]=highest(OBVolume,Length) and

OBVolume=lowest(OBVolume,3)

then ret=1;

#### 📄 RSI高檔死亡交叉

{@type:sensor}

input: Length1(6); SetInputName(1, \"短期期數\");

input: Length2(12); SetInputName(2, \"長期期數\");

input: HighBound(75); SetInputName(3, \"高檔區\");

settotalbar(maxlist(Length1,Length2,6) \* 8 + 8);

value1=RSI(close,Length1);

value2=RSI(close,Length2);

if value1 crosses under value2 and value1\>HighBound

then ret=1;

#### 📄 一舉跌破多根均線

{@type:sensor}

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: midlength(10); setinputname(2,\"中期均線期數\");

input: Longlength(20); setinputname(3,\"長期均線期數\");

setbarback(maxlist(shortlength,midlength,Longlength,6)+8);

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

shortaverage = Average(close,shortlength);

midaverage = Average(close,midlength) ;

Longaverage = Average(close,Longlength);

if close crosses under shortaverage and

close crosses under midaverage and

close crosses under Longaverage

then ret=1;

#### 📄 一黑破n紅

{@type:sensor}

input:Length(3); setinputname(1,\"計算期數\");

settotalbar(Length + 3);

if high=highest(high\[1\],Length) and close\<lowest(low\[1\],Length)

then ret=1;

#### 📄 三長上影線

{@type:sensor}

input: Percent(1.5); setinputname(1,\"上影線佔股價絕對百分比\");

settotalbar(5);

condition1 = (high- maxlist(open,close)) \> absvalue(open-close)\*3;

condition2 = high \> maxlist(open, close) \* (100 + Percent)/100;

if trueall( condition1 and condition2, 3) then ret=1;

#### 📄 主力出貨

{@type:sensor}

input:RatioThre(1.5); setinputname(1,\"下跌量上漲量比\");

settotalbar(8);

variable: upvolume(0);//累計上漲量

variable: downvolume(0);//累計下跌量

variable: uprange(0);//累計上漲值

variable: downrange(0);//累計下跌值

variable: DUratio(0);//下跌量上漲量比

if date\[1\] \<\> date then

begin

downvolume =0; upvolume =0;

uprange =0; downrange=0;

if close \> open then

begin

upvolume = volume;

uprange = close -open;

end

else

if close \< open then

begin

downvolume = volume;

downrange = open -close;

end

else

if close \< close\[1\] then

begin

downvolume = volume;

downrange = close\[1\] -close;

end

else

if close \> close\[1\] then

begin

upvolume = volume;

uprange = close -close\[1\];

end;

end;//如果前一個跟Bar跟目前的bar日期不同 今天第一根起算

if date\[1\] = date then //還在同一天

begin

if close \> close\[1\] then

begin

upvolume += volume;

uprange += close -close\[1\];

end

else

if close \< close\[1\] then

begin

downvolume += volume;

downrange += close\[1\] -close;

end;

if upvolume \> 0 then DUratio = downvolume/upvolume else DUratio=1;

end;

if DUratio crosses over RatioThre and uprange crosses under downrange
then ret=1;

#### 📄 主力賣超

{@type:sensor}

input:PastDays(3); setinputname(1,\"計算天數\");

input:summ(2000);setinputname(2,\"合計賣超張數門檻\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

settotalbar(PastDays + 3);

if Barfreq = \"D\" and close\< close\[1\] and

summation(GetField(\"LeaderDifference\")\[1\],PastDays) \<= summ\*-1
then ret=1;

#### 📄 乖離過大

{@type:sensor}

input:Length(200); setinputname(1,\"計算期數\");

input:Ratio(70); setinputname(2,\"正向乖離門檻%\");

settotalbar(Length + 3);

if close/average(close,Length)\>= 1+Ratio/100

then ret=1;

#### 📄 分鐘線九連黑

{@type:sensor}

Input: Length(9); SetInputName(1, \"連續筆數\");

settotalbar(Length + 3);

if Barfreq =\"Min\" then

if trueall(close \< open,Length) then ret=1;

#### 📄 多日價量背離

{@type:sensor}

input:Length(5); setinputname(1,\"計算期數\");

input:times(3);setinputname(2,\"價量背離次數\");

input:TXT(\"建議使用日線\"); setinputname(3,\"使用說明\");

variable:count(0);

settotalbar(Length + 3);

count = CountIf(close \> close\[1\] and volume \< volume\[1\], Length);

if count \> times then

ret = 1;

#### 📄 大黑棒

{@type:sensor}

input:Percent(4); setinputname(1,\"實體K棒為股價絕對百分比\");

settotalbar(3);

if open/close \>= 1 + Percent/100 //實體(開盤-收盤)

then ret=1;

#### 📄 天價留上影線後未開高

{@type:sensor}

input:Length(20); setinputname(1,\"設定波段天數\");

input:P1(2); setinputname(2,\"設定高檔壓回百分比\");

input:P2(0.5); setinputname(3,\"當日開高基準百分比\");

input:P3(0.5); setinputname(4,\"上影線佔價格幅度%\");

input:TXT(\"建議使用日線\"); setinputname(5,\"使用說明\");

settotalbar(3);

setbarback(Length);

if open - close\[1\] \<P2/100\*close\[1\] and

high\[1\]=highest(high,Length) and

(high\[1\]-close\[1\])\>= P1/100 \*close\[1\] and

high\[1\] \> maxlist(open\[1\], close\[1\]) \*(1+P3/100)

then ret=1;

#### 📄 天量後價量未再創新高

{@type:sensor}

input:XLength(60); setinputname(1,\"長期大量計算期數\");

input:Length(3); setinputname(2,\"自高點回檔天數\");

input:TXT(\"建議使用日線\"); setinputname(3,\"使用說明\");

variable: PriceHighBar(0),VolumeHighBar(0);

settotalbar(XLength + 3);

extremes(high,Length,1,value1,PriceHighBar);

extremes(volume,XLength,1,value1,VolumeHighBar);

if (PriceHighBar =Length-1) and VolumeHighBar=Length-1 then

ret=1;

#### 📄 川上三鴉

{@type:sensor}

settotalbar(3);

if TrueAll((open-close) \> (high-low) \* 0.5 and close \<close\[1\],3)
then ret=1;

#### 📄 巨量長黑

{@type:sensor}

input:Amount(10000); setinputname(1,\"依頻率設定巨量門檻\");

settotalbar(3);

if open \> Close \* 1.025//實體

and close\[1\] \> Close \* 1.035 //較前一日大跌

and volume \>=amount

then ret=1;

#### 📄 投信外資都賣超

{@type:sensor}

input:TXT(\"僅適用日線\"); setinputname(1,\"使用限制\");

settotalbar(3);

if Barfreq \<\> \"D\" then return;

if Open \< Close\[1\] and Close \< Close\[1\] and

GetField(\"外資買賣超\")\[1\]\<0 and GetField(\"投信買賣超\")\[1\]\<0

then ret=1;

#### 📄 散戶買單比例太高且走低

{@type:sensor}

input:ratio(20); setinputname(1,\"散戶買單比例%\");

input:TXT(\"須逐筆洗價\"); setinputname(2,\"使用限制\");

//單筆外盤成交值低於五十萬元稱為散單 //內外盤:內盤-1 外盤1

variable: intrabarpersist ACount(0);

variable: intrabarpersist TimeStamp(0);

settotalbar(3);

if barfreq =\"Min\" and currentdate = date then //分鐘線在今天時

begin

TimeStamp =currenttime;

if TimeStamp = TimeStamp\[1\] then ACount=0;

if TimeStamp\[1\] \<= time then // 盤中開啟 or 換Bar第一個進價

begin

if GetField(\"內外盤\",\"Tick\") \> 0 and GetField(\"Volume\", \"Tick\")
\*Close \<=500 then

ACount = GetField(\"Volume\", \"Tick\") \*Close

else

ACount=0;

end

else

begin

if GetField(\"內外盤\",\"Tick\") \> 0 and GetField(\"Volume\", \"Tick\")
\*Close \<=500 then ACount+= GetField(\"Volume\", \"Tick\") \*Close;

end;

if ACount \>= Ratio/100 \* volume\*close and

Close \< GetField(\"RefPrice\", \"D\")\*0.985 and GetField(\"High\",
\"D\") \< GetField(\"RefPrice\", \"D\")\*1.005 then ret=1;

end;

if barfreq =\"D\" then

begin

if Date \<\> currentdate then Acount=0;

if GetField(\"內外盤\",\"Tick\") \> 0 and GetField(\"Volume\", \"Tick\")
\*Close \<=500 then ACount+= GetField(\"Volume\", \"Tick\") \*Close;

if ACount \>= Ratio/100 \* GetField(\"Volume\", \"D\") \*
GetField(\"均價\") and

Close \< GetField(\"RefPrice\", \"D\")\*0.985 and GetField(\"High\",
\"D\") \< GetField(\"RefPrice\", \"D\")\*1.005 then ret=1;

end;

#### 📄 海龜出場法則

{@type:sensor}

input:Length(10); setinputname(1,\"近N週期數\");

input:TXT(\"僅適用日線\"); setinputname(2,\"使用限制\");

settotalbar((Length + 3)\*5);

if barfreq \<\> \"D\" and barfreq \<\> \"AD\" then Return;

if close \< lowest(getfield(\"low\",\"W\")\[1\],Length)//近n週最低價

then ret=1;

#### 📄 盤中直線下跌

{@type:sensor}

input:SlopeThre(2); setinputname(1,\"下降坡度\[2\~15越大跌越快\]\");

input:Length(5); setinputname(2,\"計算期數\");

settotalbar(Length + 3);

variable:KBarOfDay(0),tOpen(100); KBarOfDay+=1;

if date\<\>date\[1\] then begin KBarOfDay=1; tOpen =Open; end;

if Length \< KBarOfDay and currentbar \> maxbarsback and

Linearregslope(Low/tOpen\*1000,Length) \< SlopeThre\*-1 then

ret=1;

#### 📄 竭盡缺口

{@type:sensor}

input:Length(50); setinputname(1,\"計算漲幅的區間\");

input:Ratio(30); setinputname(2,\"區間累計上漲幅度%\");

input:OpenGapRatio(2); setinputname(3,\"今日跳空上漲幅度%\");

input:TXT(\"建議使用日線\"); setinputname(4,\"使用說明\");

settotalbar(Length + 3);

if close / lowest(close,Length) \>= 1+Ratio/100//區間漲幅夠大

and open\[1\]\>close\[2\] //前一日已跳空

and open/close\[1\] \>= 1+OpenGapRatio/100 //今天又跳空

then ret=1;

#### 📄 股價跌破走平後的高壓電線

{@type:sensor}

input:Ratio(10); setinputname(1,\"高壓電線幅度%\");

input:Length(5); setinputname(2,\"計算走平期數\");

settotalbar(Length + 8);

setbarback(72);

variable: Factor(0);Factor = 100/Close;

if absvalue(linearregslope(avgprice\[1\]\*Factor,Length))\<=0.1 and
//走平

close crosses under ((average(close,30)+average(close,72))/2 )\*
(1+Ratio\*0.01)

then ret=1;

#### 📄 股價震盪變大且收最低

{@type:sensor}

input:Length(5);setinputname(1,\"計算震盪幅度的區間期數\");

input:BaseLength(20);setinputname(2,\"震盪幅度計算區間\");

input:Ratio(50);setinputname(3,\"震盪放大百分比%\");

settotalbar(8);

setbackbar(maxlist(Length,BaseLength));

value1=highest(high,Length)-lowest(low,Length);

value2=average(value1,BaseLength);

if value1 crosses over value2 \*(1+ratio/100) and close=low

then ret=1;

#### 📄 資增券減還收黑

{@type:sensor}

input:V1(1000); setinputname(1,\"融資增加張數\");

input:V2(500); setinputname(2,\"融券減少張數\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

settotalbar(3);

if BarFreq \<\> \"D\" then return;

if close \< close\[1\] and

GetField(\"融資增減張數\")\[1\] \> V1 and

GetField(\"融券增減張數\")\[1\] \< V2\*-1

then ret=1;

#### 📄 跌破n日低點

{@type:sensor}

input:Length(20); setinputname(1,\"計算期數\");

settotalbar(Length + 3);

if close \< lowest(low\[1\],Length) then ret=1;

#### 📄 跌破上升趨勢線

{@type:sensor}

input:Length(10); setinputname(1,\"上升趨勢計算期數\");

input:\_Angle(30); setinputname(2,\"上升趨勢角度\");

settotalbar(Length + 3);

variable: TrendAngle(0);

variable: TrendAngleDelta(0);

if Close\< Close\[1\] and Close\[1\] \<Close\[2\] and Close\[Length\]\>0
then begin

linearreg((high/Close\[Length\]-1)\*100,Length,0,value1,TrendAngle,value3,value4);

TrendAngleDelta =TrendAngle-TrendAngle\[1\];

IF TrendAngleDelta-TrendAngleDelta\[1\] \< -10 and close
\>Close\[Length\] THEN RET=1;

end;

#### 📄 跌破均線

{@type:sensor}

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: midlength(10); setinputname(2,\"中期均線期數\");

input: Longlength(20); setinputname(3,\"長期均線期數\");

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

settotalbar(3);

setbarback(maxlist(shortlength,midlength,Longlength));

shortaverage=Average(close,shortlength);

midaverage=Average(close,midlength) ;

Longaverage = Average(close,Longlength);

if open \> maxlist(shortaverage, midaverage, longaverage) and

close \< minlist(shortaverage, midaverage, longaverage)

then ret=1;

#### 📄 跳空下跌再破底

{@type:sensor}

//分鐘線

input:Gapratio(1.5);setinputname(1,\"跳空下跌百分比%\");

input:TXT(\"僅適用分鐘線\"); setinputname(2,\"使用限制\");

settotalbar(5);

if barfreq\<\>\"Min\" then return;

if Close \< close\[1\] and Close \< GetField(\"Open\", \"D\") then

if GetField(\"Open\", \"D\") \< GetField(\"RefPrice\",
\"D\")\*(100-Gapratio)/100 then ret=1;

#### 📄 連續n日開高走低收最低

{@type:sensor}

input:Length(2); setinputname(1,\"計算期數\");

settotalbar(Length + 3);

if Trueall( Open \> Close\[1\]\*1.005 and Close\<open and close = low ,
Length) then ret=1;

#### 📄 階梯式下跌

{@type:sensor}

input:TXT(\"5分鐘線以下\"); setinputname(1,\"使用限制\");

settotalbar(13);

if barfreq\<\> \"Min\" or barinterval \> 5 then return;

switch (barinterval)

begin

case 1,2,5:

if time =091000 and TrueAll(open=high and close=low and close\<
close\[1\],10/barinterval) then ret=1;

break;

case 3:

if time =090900 and TrueAll(open=high and close=low and close\<
close\[1\],3) then ret=1;

break;

end;

#### 📄 高檔出現吊人線

{@type:sensor}

settotalbar(33);

if Close \< Close\[1\] then begin

condition1 =

open = High and close \< open and

(high -low) \> 2 \*(high\[1\]-low\[1\]) and

(close-low) \> (open-close) \*2;

condition2= close\[1\] \> highest(High,30)\*0.98;
//昨日收盤價接近三十日高點

if condition1 and condition2 then ret=1;

end;

#### 📄 高檔出現黑暗之星

{@type:sensor}

input:Length(10); setinputname(1,\"計算期數\");

settotalbar(Length + 3);

if (open-close)\>= open \*0.025 then //最近一根是長黑棒

begin

value1 = highest(high,length);

value2 = lowest(low,length);

if value1 = value2 then return;

value3 = (value1-close)/(value1-value2)\*100;

condition1 = value3 \< 10; //接近近n日高點

condition2 = (close\[2\]-open\[2\])/open\[2\]\>=0.03;//一根長陽線

condition3 = open\[1\]\>close\[1\] and
(high\[1\]-low\[1\])\<=close\[1\]\*0.02

and close\[1\]\>close\[2\] - 0.5\*(close\[1\]-open\[1\]) ;
//一根小黑棒且未形成覆蓋線

if condition1 and condition2 and condition3 then ret=1;

end;

#### 📄 高檔覆蓋線

{@type:sensor}

input: Length(10); setinputname(1,\"計算期數\");

settotalbar(3);

setbarback(maxlist(Length,42));

value1 = PercentR(14) - 100;

value2 = PercentR(28) - 100;

value3 = PercentR(42) - 100;

if value1= 0 and value2=0 and value3 =0 then
//用威廉指標來表示股價在高檔

begin

variable: HighPoint(0),LowPoint(0),RatioThre(0);

HighPoint = highest(high,length);

LowPoint = Lowest(Low,length);

if HighPoint \> LowPoint then

RatioThre=(HighPoint-close)/(HighPoint-LowPoint)\*100

else

RatioThre=999;

if RatioThre\<10 and

close\<open and

close\[1\]\>open\[1\] and

close\<close\[1\]-1/2\*(close\[1\]-open\[1\])

then ret=1;

end;

#### 📄 高檔量縮收黑

{@type:sensor}

input:DownPercent(4); setinputname(1,\"當期下跌幅度\");

input:Ratio(20); setinputname(2,\"量縮程度%\");

input:TieDays(3); setinputname(3,\"量縮持續期數\");

input:UpTrendDays(20); setinputname(4,\"累計上漲期數\");

input:RaisingRatio(20);setinputname(5,\"累計上漲幅度\");

settotalbar(3);

setbarback(UpTrendDays+TieDays);

if Close\[TieDays\] \> close\[UpTrendDays+TieDays-1\] \*
(1+RaisingRatio/100) then

begin

if Close\< high\[TieDays\] \* (1 - DownPercent/100) and

volume\[TieDays\] \> volume \*(1+Ratio/100)

then ret=1;

end;

#### 📄 高檔雙死亡交叉

{@type:sensor}

//近三天內ma及macd都發生過死亡交叉

input: FastLength(12); SetInputName(1, \"DIF短期期數\");

input: SlowLength(26); SetInputName(2, \"DIF長期期數\");

input: MACDLength(9); SetInputName(3, \"MACD期數\");

input: Shortlength(5); setinputname(4,\"短期均線期數\");

input: Longlength(10); setinputname(5,\"長期均線期數\");

input: Length(20); setinputname(6,\"設定波段區間\");

input: Ratio(20); setinputname(7,\"設波段上漲幅度\");

input: ReactRatio(5); setinputname(8,\"距波段高點的跌幅\");

input:TXT(\"建議使用日線\"); setinputname(9,\"使用說明\");

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 3 + 11);

if close \>= lowest(close,Length)\* (1+ Ratio/100) and

close \>= (1-ReactRatio/100)\*highest(close,Length) then

begin

variable: price(0);

price = WeightedClose();

Value1 = XAverage(price, FastLength) - XAverage(price, SlowLength);//DIF

Value2 = XAverage( Value1, MACDLength ) ;//MACD

Value3 = Value1 - Value2 ;//OSC

{===============================================================}

value4=average(close,5);

value5=average(close,10);

value6=value4-value5;

{===============================================================}

condition1 = TrueAny( value3 crosses under 0 ,3);

condition2 = TrueAny( value6 crosses under 0 ,3);

if condition1 and condition2

then ret=1;

end;

### 3.5 A股用語 (11 個)

#### 📄 九陰白骨爪

{@type:sensor}

// 連續9筆K線收黑

//

settotalbar(10);

Ret = TrueAll(close \< open, 9);

#### 📄 九陽神功

{@type:sensor}

// 連續9筆上漲

settotalbar(10);

Ret = TrueAll(Close \> Close\[1\], 9);

#### 📄 出水芙蓉

{@type:sensor}

{股價長期低於季線 今日帶量突破季線 \[僅適用日線\] }

input:Length(66); setinputname(1,\"計算期間\[僅日線有效\]\");

input:downLength(100); setinputname(2,\"長期低於季線的天數\");

input:ratio(25); setinputname(3,\"突破量超過均量百分比(%)\");

input:VLength(20); setinputname(4,\"突破幾日均量\");

input:TXT(\"僅適用日線\"); setinputname(5,\"使用限制\");

settotalbar(downLength + 8);

setbarback(maxlist(Length + vLength));

if barfreq \<\> \"D\" then return;

value1=average(close,Length);//季線值

value2=average(volume,VLength);//均量值

condition1 = TrueAll(high\[1\] \< value1\[1\], downLength);

if condition1 and close crosses over value1 and volume \> value2\*
(100+ratio)/100

then ret=1;

#### 📄 回頭高飛

{@type:sensor}

//開高5%以上，拉回又再拉漲停

settotalbar(3);

condition1 = (Close = GetField(\"漲停價\", \"D\"));

condition2 = (GetField(\"Open\", \"D\") \> GetField(\"RefPrice\", \"D\")
\*1.05);

condition3 = (GetField(\"Low\", \"D\") \< GetField(\"Open\", \"D\"));

condition4 = close \> close\[1\];

if condition1 and condition2 and condition3 and condition4 then ret=1;

#### 📄 斷頭鍘刀

{@type:sensor}

input:ShortLength(5); setinputname(1,\"短期均線期數\");

input:MidLength(20); setinputname(2,\"中期均線期數\");

input:LongLength(60); setinputname(3,\"長期均線期數\");

settotalbar(8);

setbarback(maxlist(ShortLength,MidLength,LongLength));

value1=average(close,ShortLength);

value2=average(close,MidLength);

value3=average(close,LongLength);

if close crosses below value1 and

close crosses below value2 and

close crosses below value3

then ret=1;

#### 📄 死蜘蛛

{@type:sensor}

input:ShortLength(5); setinputname(1,\"短期均線期數\");

input:MidLength(20); setinputname(2,\"中期均線期數\");

input:LongLength(60); setinputname(3,\"長期均線期數\");

settotalbar(3);

setbarback(maxlist(ShortLength,MidLength,LongLength));

value1=average(close,ShortLength);

value2=average(close,MidLength);

value3=average(close,LongLength);

condition1 = value1\>close;

condition2 = close\[1\]\>value3;

value4=maxlist(value1,value2,value3);

value5=minlist(value1,value2,value3);

value6=(value4-value5)/value4;

condition3 = value6\<0.02;

if condition1 and condition2 and condition3 then ret=1;

#### 📄 殺跌波型

{@type:sensor}

//黑三兵

input:TXT(\"請使用1分鐘線\"); setinputname(1,\"使用方法\");

settotalbar(5);

if ( open - close ) \> (high -low) \* 0.75 and

( open\[1\] - close\[1\] ) \> (high\[1\] -low\[1\]) \* 0.75 and

( open\[2\] - close\[2\] ) \> (high\[2\] -low\[2\]) \* 0.75 and

close \< close\[1\] and close\[1\] \< close\[2\]

then ret=1;

#### 📄 池塘底

{@type:sensor}

input:Length(40); setinputname(1,\"計算期數\");

input:inter(10); setinputname(2,\"選擇過去某一期\");

settotalbar(8);

setbarback(maxlist(Length,inter));

value1=absvalue(close-close\[inter\]);

value2=value1/close;

value3=average(value2,length);//本日收盤價與前第inter日之收盤價之差的移動平均

value4=average(volume,20);

condition1 = value3\<0.01;

condition2 = close crosses above highest(high\[1\],length) ;

condition3 = volume/value4\>1.2;

if condition1 and condition2 and condition3 then ret=1;

#### 📄 瀑布波型

{@type:sensor}

settotalbar(3);

setbarback(30);

if close\[1\] \> lowest(close,30) \* 1.2 and

(high-low)\> close \* 0.035 and

(close-low)\> close \* 0.01

then ret=1;

#### 📄 火箭攻擊

{@type:sensor}

settotalbar(3);

IF CLOSE \>= CLOSE\[1\] \* 1.015 and close=high and volume\>volume\[1\]

then ret=1;

#### 📄 螞蟻功

{@type:sensor}

//延著均線前進

input:Length(10); setinputname(1,\"均線計算期數\");

input:Length1(5); setinputname(2,\"沿均線前進的期數\");

input:Ratio(2); setinputname(3,\"沿均線的範圍定義%\");

settotalbar(maxlist(Length,Length1) + 3);

variable:x(0);

variable:count(0); count=0;

value1=average(close,Length);

for x=Length-1 downto 0

begin

if value1\[x\] \>= close\[x\] and value1\[x\]\*100 \<= (100+ratio)
\*Close

then count += 1;

end;

if count \>= Length1 then ret=1;

### 3.6 ETF策略 (21 個)

#### 📄 BBand翻多

{@type:sensor}

input:Length(20,\"天數\");

input:Up(1,\"上\");

input:Down(1,\"下\");

input:Threshold(1,\"觸發標準\");

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 = bollingerband(Close, Length, absvalue(Up));

down1 = bollingerband(Close, Length, -1 \* absvalue(Down));

mid1 = (up1 + down1) / 2;

bbandwidth = 100 \* (up1 - down1) / mid1;

if bbandwidth crosses above Threshold then ret = 1;

#### 📄 ETF乖離反轉作多買進訊號

{@type:sensor}

input:Length(20); setinputname(1,\"計算期數\");

input:Ratio(21); setinputname(2,\"乖離%\");

variable:KPrice(0);

if close/average(close,Length)\<= 1-Ratio/100 then KPrice = H;

if Close crosses over KPrice

then ret=1 ;

#### 📄 KO買進訊號

{@type:sensor}

Input: Length1(34, \"短天期\");

Input: Length2(55, \"長天期\");

variable: ko(0);

ko = callfunction(\"KO成交量擺盪指標\", Length1, Length2);

value1=average(ko,3);

value2=average(ko,13);

if value1 crosses over value2

and linearregangle(close,5)\>20

then ret=1;

#### 📄 KST趨勢確認策略

{@type:sensor}

variable:kst(0);

kst=callfunction(\"KST確認指標\");

if kst crosses over -50 then ret=1;

#### 📄 OBV買進訊號

{@type:sensor}

variable: obvolume(0);

if CurrentBar = 1 then

obvolume = 0

else begin

if close \> close\[1\] then

obvolume = obvolume\[1\] + volume

else begin

if close \< close\[1\] then

obvolume = obvolume\[1\] - volume

else

obvolume = obvolume\[1\];

end;

end;

value1=average(obvolume,20);

if obvolume crosses over value1\*1.3 then ret=1;

#### 📄 Q指標買進訊號

{@type:sensor}

input:t1(10,\"計算累積價格變動的bar數\");

input:t2(5,\"計算價格累積變化量移動平均的期別\");

input:t3(20,\"計算雜訊的移動平均期別\");

variable:Qindicator(0);

Qindicator=callfunction(\"Q指標\",t1,t2,t3);

if linearregangle(Qindicator,5)\>40

and barslast(linearregangle(Qindicator,5)\>45)\[1\]\>20

then ret=1;

#### 📄 三下影線反轉直上買進訊號

{@type:sensor}

input: Percent(0.5,\"下影線佔股價絕對百分比\");

variable:Kprice(0),OCDate(0);

condition1 = (minlist(open,close)-Low) \> absvalue(open-close)\*2;

condition2 = minlist(open, close) \> low\* (100 + Percent)/100;

if trueall( condition1 and condition2, 3) then begin

OCDate = Date;

Kprice = average(H,3);

end;

if DateDiff(Date,OCDate) \<3 and Close crosses over Kprice then ret = 1;

#### 📄 中長線均線糾結後突破

{@type:sensor}

input: Shortlength(10,\"短期均線期數\");

input: Midlength(20,\"中期均線期數\");

input: Longlength(40,\"長期均線期數\");

input: Percent(2,\"均線糾結區間%\");

input:
Volpercent(20,\"放量幅度%\");//帶量突破的量是超過最長期的均量多少%

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

if volume \> average(volume,Longlength) \* (1 + volpercent \* 0.01) and
volume \> 1000 then

begin

shortaverage = average(close,Shortlength);

midaverage = average(close,Midlength);

Longaverage = average(close,Longlength);

value2= maxlist(shortaverage,midaverage,Longaverage );

value3= minlist(shortaverage,midaverage,Longaverage );

if close crosses over value2

and (value2-value3)\*100 \< Percent\*close

then ret=1;

end;

#### 📄 基金投資大跌後的止跌訊號

{@type:sensor}

if (open\[2\] - close\[2\] ) \> (high\[2\] -low\[2\]) \* 0.75

//前前期出黑K棒

and close\[2\] \< close\[3\]-(high\[3\]-low\[3\])

//跌勢擴大

and ( close - open ) \> (high -low) \* 0.75

//當期收紅K棒

and close\> close\[2\]

//收復黑棒收盤價

and close\[1\] \<= close\[2\] and close\[1\] \< open

//前低收盤為三期低點

and close\[40\] \> close\[1\]\*1.05

//近四十日跌幅超過5%

then ret=1;

#### 📄 大盤MFI多頭

{@type:sensor}

if TSEMFI=1

then ret=1;

#### 📄 大碗底

{@type:sensor}

value1=lowestbar(low,100);

value2=lowest(low,100);

value3=highestbar(high,100);

value4=highest(high,100);

if value4\>value2\*1.15

and value3-value1\>15

then begin

if value1\>15

and value2\*1.05\>close\[1\]

and close\>close\[1\]\*1.01

and volume\>average(volume\[1\],15)\*1.2

then ret=1;

end;

#### 📄 大跌三成之後

{@type:sensor}

input:n(30,\"下跌幅度\");

input:period(60,\"計算天數\");

if close\*(1+n/100) \< close\[period-1\] then ret=1;

#### 📄 大跌後均線黃金交叉

{@type:sensor}

Input: Length1(5, \"短天期\");

Input: Length2(20, \"長天期\");

value1=highest(high,100);

if value1 \> close\*1.2

and average(close,Length1) crosses over average(close,Length2)

then ret=1;

#### 📄 大跌後的價量背離

{@type:sensor}

input:period(10,\"計算天數\");

input:times(5,\"背離次數\");

if close\[1\]\*1.2\<close\[40\] //大跌

and countif(c\>c\[1\] xor v\>v\[1\],period) \>= times
//價漲量縮、價跌量增

and close=highest(close,period) //收近期最高

then ret=1;

#### 📄 月KD高檔鈍化且日KD黃金交叉

{@type:sensor}

input: Length_D(9, \"日KD期間\");

input: Length_M(5, \"月KD期間\");

variable:rsv_d(0),kk_d(0),dd_d(0);

variable:rsv_M(0),kk_M(0),dd_M(0);

stochastic(Length_D, 3, 3, rsv_d, kk_d, dd_d);

xf_stochastic(\"M\", Length_M, 3, 3, rsv_m, kk_m, dd_m);

if xf_getvalue(\"M\", kk_m, 1) \>= 85 and kk_d crosses over dd_d then
ret=1;

#### 📄 烏龜進場法則

{@type:sensor}

if average(close,3) crosses above average(close,55)

and volume\> average(volume,5)

and atr(3) \> atr(20)

then ret=1;

#### 📄 理專DBCD交易法則

{@type:sensor}

input:length1(10,\"短天期\"),length2(20,\"長天期\"),length3(14,\"平滑天期\");

input:Threshold(-2,\"觸發標準\");

value1=bias(length1);

value2=bias(length2);

value3=value2-value1;

value4=average(value3,length3);

if value4 crosses over Threshold

then ret=1;

#### 📄 理專之雙KD向上

{@type:sensor}

input: Length_D(9, \"日KD期間\");

input: Length_W(5, \"周KD期間\");

variable:rsv_d(0),kk_d(0),dd_d(0);

variable:rsv_w(0),kk_w(0),dd_w(0);

stochastic(Length_D, 3, 3, rsv_d, kk_d, dd_d);

xf_stochastic(\"W\", Length_W, 3, 3, rsv_w, kk_w, dd_w);

condition1 = kk_d crosses above dd_d; // 日KD crosses over

condition2 = xf_GetBoolean(\"W\",xf_crossover(\"W\", kk_w, dd_w),1); //
周KD crosses over

condition3 = kk_d \<= 30; // 日K 低檔

condition4 = xf_getvalue(\"W\", kk_w, 1) \<= 50; // 周K 低檔

ret = condition1 and condition2 and condition3 and condition4;

#### 📄 趨勢翻多

{@type:sensor}

input:Length(20,\"計算期間\");

LinearReg(close, Length, 0, value1, value2, value3, value4);

//做收盤價20天線性回歸

//value1:斜率、value4:預期值

value5=rsquare(close,value4,20);//算收盤價與線性回歸值的R平方

if value1\>0 and value1\[1\]\<0 and value5\>0.2 then ret=1;

#### 📄 週線二連紅之後

{@type:sensor}

if rateofchange(close,2)\[1\]\>0

and rateofchange(close,2)\[2\]\>0

and close\<close\[2\]\*1.07

and close\[10\]\>close\*1.15

then ret=1;

#### 📄 週線反轉法則

{@type:sensor}

input:rate1(5,\"先前週線漲幅\");

input:rate2(3,\"本週低點跌幅\");

input:TXT(\"僅適用日線\",\"使用限制\");

settotalbar(20);

if
getfield(\"high\",\"W\")\[2\]\>=getfield(\"close\",\"W\")\[3\]\*(1+rate1/100)

and low \< getfield(\"close\",\"W\")\[1\]\*(1-rate2/100)

then ret=1;

### 3.7 價量指標 (34 個)

#### 📄 今日高點回跌

{@type:sensor}

input:HighBound(2); setinputname(1,\"高點幅度%\");

input:Reaction(1); setinputname(2,\"回檔預警幅度%\");

settotalbar(3);

if GetField(\"High\", \"D\") \> GetField(\"RefPrice\",
\"D\")\*(1+0.01\*HighBound) and

Close \<= GetField(\"High\", \"D\")\*(1-0.01\*Reaction) then

ret = 1;

#### 📄 價創近期新低量創新高

{@type:sensor}

input: Price(close); setinputname(1,\"比較價別\");

input: Length(20); setinputname(2,\"近期期數\");

settotalbar(3);

setbarback(Length);

if Price \< lowest(low\[1\] ,Length) and

volume \> highest(volume\[1\],length) then ret=1;

#### 📄 價量同創近期新低

{@type:sensor}

input: Price(close); setinputname(1,\"比較價別\");

input: Length(20); setinputname(2,\"近期期數\");

settotalbar(3);

setbarback(Length);

if Price \< lowest(low\[1\] ,Length) and

volume \< lowest(volume\[1\],length) then ret=1;

#### 📄 價量同創近期新高

{@type:sensor}

input: Price(close); setinputname(1,\"比較價別\");

input: Length(20); setinputname(2,\"近期期數\");

settotalbar(3);

setbarback(Length);

if Price \> highest(high\[1\] ,Length) and

volume \> highest(volume\[1\],length) then ret=1;

#### 📄 即將漲停

{@type:sensor}

input: Percent(1); setinputname(1,\"距離漲停百分比\");

settotalbar(3);

if close \> GetField(\"漲停價\", \"D\")\*(1-Percent/100) then ret =1;

#### 📄 即將跌停

{@type:sensor}

input: Percent(1); setinputname(1,\"距離跌停百分比\");

settotalbar(3);

if close \< GetField(\"跌停價\", \"D\")\*(1+Percent/100) then ret =1;

#### 📄 多方人氣表態

{@type:sensor}

settotalbar(3);

if Close \> highD(1) and GetField(\"Volume\", \"D\")\>
GetField(\"Volume\", \"D\")\[1\] then ret=1;

#### 📄 帶量上影線

{@type:sensor}

settotalbar(5);

if high - maxlist(open,close) \> absvalue(open-close)\*2 and

Volume \> maxlist(volume\[1\],volume\[2\],volume\[3\]) then ret=1;

#### 📄 帶量下影線

{@type:sensor}

settotalbar(5);

if minlist(open,close) - low \> absvalue(open-close)\*2 and

Volume \> Maxlist(volume\[1\],volume\[2\],volume\[3\]) then ret=1;

#### 📄 成交量突破N倍均量

{@type:sensor}

input: length(20); setinputname(1,\"均量期數\");

input: VolumeXtime(3); setinputname(2,\"量增倍數\");

settotalbar(3);

setbarback(Length);

if volume \> Average( volume\[1\],length)\* VolumeXtime then ret=1;

#### 📄 成交量突破均量

{@type:sensor}

input: length(20); setinputname(1,\"均量期數\");

input: confirmVolume(500); setinputname(2,\"突破均量張數\");

settotalbar(3);

setbarback(Length);

if volume \> Average( volume\[1\],length) +confirmVolume then ret=1;

#### 📄 步步高升

{@type:sensor}

settotalbar(3);

if volume \> volume\[1\] and

volume\[1\] \> volume\[2\] and

close \> close\[1\] and

close\[1\] \> close\[2\] and

close \> open and

close\[1\] \> open\[1\] and

close\[2\] \> open\[2\]

then ret=1;

#### 📄 漲停回頭

{@type:sensor}

settotalbar(3);

If Close\[1\] = GetField(\"漲停價\", \"D\") And q_Last \<
GetField(\"漲停價\", \"D\") Then ret = 1;

#### 📄 漲停鎖住

{@type:sensor}

settotalbar(3);

If Close = GetField(\"漲停價\", \"D\") And q_AskSize \<=0 Then ret = 1;

#### 📄 爆量長紅

{@type:sensor}

settotalbar(8);

if volume \> Average(volume\[1\],5) \*3 and

( close - open ) \>( high -low ) \* 0.75 and

close \> open + (high\[1\]- low\[1\])

then ret=1;

#### 📄 爆量長黑

{@type:sensor}

settotalbar(8);

if volume \> Average(volume\[1\],5) \*3 and

( open - close ) \>( high -low ) \* 0.75 and

open \> close + (high\[1\]- low\[1\])

then ret=1;

#### 📄 當日時段區間價突破

{@type:sensor}

input:initialtime(090000); setinputname(1,\"起算時間HHmmss\");

input:timeline(100000); setinputname(2,\"截止時間HHmmss\");

input:CloseAtHigh(false); setinputname(3,\"收盤價亦須創新高\");

input:TXT1(\"限用分鐘線\"); setinputname(4,\"使用限制\");

settotalbar(50);

if barfreq\<\> \"Min\" then return;

variable: intervalhigh(0);

if date \<\> date\[1\] then intervalhigh = 0;

if time \>= initialtime and time \<= timeline then

begin

intervalhigh = maxlist(high,intervalhigh);

end;

if time \> timeline then

begin

if CloseAtHigh then

Ret = IFF(close \> intervalhigh, 1, 0)

else

Ret = IFF(high \> intervalhigh, 1, 0);

end;

#### 📄 當日時段區間價跌破

{@type:sensor}

input:initialtime(090000); setinputname(1,\"起算時間HHmmss\");

input:timeline(100000); setinputname(2,\"截止時間HHmmss\");

input:CloseAtLow(false); setinputname(3,\"收盤價亦須創新低\");

input:TXT1(\"限用分鐘線\"); setinputname(4,\"使用限制\");

settotalbar(50);

if barfreq\<\> \"Min\" then return;

variable: intervallow(99999999);

if date \<\> date\[1\] then intervallow = 99999999;

if time \>= initialtime and time \<= timeline then

begin

intervallow = minlist(low,intervallow);

end;

if time \>timeline then

begin

if CloseAtLow then

Ret = IFF(close \< intervallow, 1, 0)

else

Ret = IFF(low \< intervallow, 1, 0);

end;

#### 📄 當日漲幅預警

{@type:sensor}

input:AlertChangeRatio(3); setinputname(1,\"預警幅度%\");

settotalbar(3);

If q_PriceChangeRatio \> AlertChangeRatio Then ret = 1;

#### 📄 當日跌幅預警

{@type:sensor}

input:AlertChangeRatio(3); setinputname(1,\"預警幅度%\");

settotalbar(3);

If q_PriceChangeRatio \< AlertChangeRatio\*-1 Then ret = 1;

#### 📄 當日量突破

{@type:sensor}

input:initialtime(090000); setinputname(1,\"起算時間HHmmss\");

input:timeline(100000); setinputname(2,\"截止時間HHmmss\");

settotalbar(50);

variable: intervalhighv(0);

variable: keyprice(0);

if date \<\> date\[1\] then intervalhighv =0 ;

if time \>= initialtime and time \<= timeline then

begin

intervalhighv = maxlist(volume,intervalhighv );

keyprice =close;

end;

if volume \> intervalhighv and time \>timeline and

close \> keyprice and close\>=open then ret=1;

#### 📄 當日量跌破

{@type:sensor}

input:initialtime(090000); setinputname(1,\"起算時間HHmmss\");

input:timeline(100000); setinputname(2,\"截止時間HHmmss\");

settotalbar(50);

variable: intervalhighv(0);

variable: keyprice(0);

if date \<\> date\[1\] then intervalhighv =0 ;

if time \>= initialtime and time \<= timeline then

begin

intervalhighv = maxlist(volume,intervalhighv );

keyprice =close;

end;

if volume \> intervalhighv and time \>timeline and

close \< keyprice and close\>=open then ret=1;

#### 📄 當日開盤跳空開低

{@type:sensor}

input: UseQuote(True); setinputname(1,\"使用即時價欄位\");

input: Gap(1.5); setinputname(2,\"跳空百分比(%)\");

settotalbar(3);

if UseQuote then

Ret = IFF(100\*(GetField(\"RefPrice\", \"D\") -GetField(\"Open\",
\"D\")) \> GetField(\"RefPrice\", \"D\")\*Gap, 1, 0)

else

Ret = IFF(date \<\> date\[1\] and 100\*(close\[1\] -open) \>
close\[1\]\*Gap, 1, 0);

#### 📄 當日開盤跳空開高

{@type:sensor}

input: UseQuote(True); setinputname(1,\"使用即時價欄位\");

input: Gap(1.5); setinputname(2,\"跳空百分比(%)\");

settotalbar(3);

if UseQuote then

Ret = IFF(100\*(GetField(\"Open\", \"D\") -GetField(\"RefPrice\",
\"D\")) \> GetField(\"RefPrice\", \"D\")\*Gap, 1, 0)

else

Ret = IFF(date \<\> date\[1\] and 100\*(open - close\[1\]) \>
close\[1\]\*Gap, 1, 0);

#### 📄 當期成交量倍增

{@type:sensor}

input: VolumeXtime(3); setinputname(1,\"量增倍數\");

settotalbar(3);

if volume \> volume\[1\] \* VolumeXtime then ret=1;

#### 📄 空頭部隊進攻

{@type:sensor}

settotalbar(25);

if low \< lowD(1) and GetField(\"Volume\", \"D\")\> GetField(\"Volume\",
\"D\")\[1\] then ret=1;

#### 📄 股價創近期新低

{@type:sensor}

input: Price(close); setinputname(1,\"比較價別\");

input: Length(20); setinputname(2,\"近期期數\");

settotalbar(3);

setbarback(Length);

if Price \< Lowest(Low\[1\] ,Length) then ret=1;

#### 📄 股價創近期新高

{@type:sensor}

input: Price(close); setinputname(1,\"比較價別\");

input: Length(20); setinputname(2,\"近期期數\");

settotalbar(3);

setbarback(Length);

if Price \> highest(high\[1\] ,Length) then ret=1;

#### 📄 跌停回頭

{@type:sensor}

settotalbar(3);

If Close\[1\] = GetField(\"跌停價\", \"D\") And Close\>
GetField(\"跌停價\", \"D\") Then ret = 1;

#### 📄 跌停鎖住

{@type:sensor}

settotalbar(3);

If Close = GetField(\"跌停價\", \"D\") And q_bidsize \<=0 Then ret = 1;

#### 📄 跌跌不休

{@type:sensor}

settotalbar(5);

if volume \> volume\[1\] and

volume\[1\] \> volume\[2\] and

close \< close\[1\] and

close\[1\] \< close\[2\] and

close \< open and

close\[1\] \< open\[1\] and

close\[2\] \< open\[2\]

then ret=1;

#### 📄 連續期間上漲

{@type:sensor}

input:Length(3); setinputname(1,\"連續上漲期數\");

settotalbar(Length + 3);

If TrueAll(Close \> Close\[1\],Length) then ret=1;

#### 📄 連續期間下跌

{@type:sensor}

input:Length(3); setinputname(1,\"連續下跌期數\");

settotalbar(Length + 3);

If TrueAll(Close \< Close\[1\],Length) then ret=1;

#### 📄 開高帶量走低

{@type:sensor}

Input: AmountThre(2000); setinputname(1,\"開高量(萬)\");

variable: initialAmount(0);

variable: intrabarpersist XDate(0);

settotalbar(25);

if Date \> XDate then

begin

XDate = Date;

initialAmount = (High+low)/2 \* volume/10; //計算K棒成交金額

if Open \> Close\[1\] and

(open - close) \> (high -low) \* 0.75 and

initialAmount \> AmountThre then ret = 1;

end;

### 3.8 出場訊號 (3 個)

#### 📄 emprical指標賣出訊號

{@type:sensor}

input:period(20),delta(0.1),fraction(0.1);

variable:
price(0),gamma(0),alpha(0),beta(0),BP(0),mean(0),peak(0),valley(0)

,avgpeak(0),avgvalley(0);

price=(h+l)/2;

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

beta=cosine(360/period);

gamma=1/cosine(720\*delta/period);

alpha=gamma-squareroot(gamma\*gamma-1);

BP=0.5\*(1-alpha)\*(price-price\[2\])

+beta\*(1+alpha)\*BP\[1\]-alpha\*BP\[2\];

mean=average(bp,2\*period);

peak=peak\[1\];

valley=valley\[1\];

if bp\[1\]\>bp and bp\[1\]\>bp\[2\] then peak=bp\[1\];

if bp\[1\]\<bp and bp\[1\]\<bp\[2\] then valley=bp\[1\];

avgpeak=average(peak,50);

avgvalley=average(valley,50);

value1=GetField(\"主力買賣超張數\")\[Z\];

if mean crosses under avgpeak

and trueall(value1\<0,3)

then ret=1;

#### 📄 近幾日總是收黑K

{@type:sensor}

if countif(close\<open,7)\>=5

//過去七天有五天以上收黑

and lowest(close,90)\*1.4\<close

//過去九十天漲幅超過四成

and lowest(close,10)\*1.2\<close

//過去十天有急拉過

and volume\*1.2\<average(volume,20)

//成交量低於二十日均量的兩成

then ret=1;

#### 📄 開盤委賣暴增

{@type:sensor}

if close\>close\[90\]\*1.3 then begin

//先前有一定的漲幅

value1=GetField(\"開盤委買\",\"D\");

value2=GetField(\"開盤委賣\",\"D\");

value3=value2-value1;

if trueall(absvalue(value3\[1\])\<250,10)

//近十日開盤委買與開盤委賣張數差不多

and value3\>=500

//今日開盤委賣比開盤委買多出500張以上

and close\<close\[1\]

//收盤比前一日下跌

and close\<low\*1.01

//收盤接近當日最低價

then ret=1;

end;

### 3.9 技術分析 (65 個)

#### 📄 45度切線突破

{@type:sensor}

input: period(20,\"計算區間\");

value1=rateofchange(close,period);

//計算區間漲跌幅

value2=arctangent(value1/period\*100);

//計算上漲的角度

if value2 crosses over 45

then ret=1;

#### 📄 ADX形成上昇趨勢

{@type:sensor}

input: Length(14, \"期數\"), Threshold(25, \"穿越值\");

variable: pdi_value(0), ndi_value(0), adx_value(0);

settotalbar(maxlist(Length,6) \* 13 + 8);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

DirectionMovement(Length, pdi_value, ndi_value, adx_value);

value1=GetField(\"主力買賣超張數\")\[Z\];

if tselsindex(10,8)\[Z\]=1

and value1\>300

and adx_value Crosses Above Threshold

then ret=1;

#### 📄 ADX趨勢成形

{@type:sensor}

// ADX趨勢成形

//

input: Length(14), Threshold(25);

variable: pdi_value(0), ndi_value(0), adx_value(0);

settotalbar(maxlist(Length,6) \* 13 + 8);

SetInputName(1, \"期數\");

SetInputName(2, \"穿越值\");

DirectionMovement(Length, pdi_value, ndi_value, adx_value);

Ret = adx_value Crosses Above Threshold;

#### 📄 ATR通道突破策略

{@type:sensor}

input:period(20,\"計算truerange的區間\");

value1=average(truerange,period);

value2=average(close,period)+2\*value1;

if close crosses over value2 then ret=1;

#### 📄 CCI超買

{@type:sensor}

// CCI超買

//

Input: Length(14), AvgLength(9), Overbought(100);

Variable: cciValue(0), cciMAValue(0);

SetTotalBar(maxlist(AvgLength + Length + 1,6) + 11);

SetInputName(1, \"期數\");

SetInputName(2, \"平滑期數\");

SetInputName(3, \"超買值\");

cciValue = CommodityChannel(Length);

cciMAValue = Average(cciValue, AvgLength);

Ret = cciMAValue Crosses Above OverBought;

#### 📄 CCI超賣

{@type:sensor}

// CCI超賣

//

Input: Length(14), AvgLength(9), OverSold(-100);

Variable: cciValue(0), cciMAValue(0);

SetTotalBar(maxlist(AvgLength + Length + 1,6) + 11);

SetInputName(1, \"期數\");

SetInputName(2, \"平滑期數\");

SetInputName(3, \"超賣值\");

cciValue = CommodityChannel(Length);

cciMAValue = Average(cciValue, AvgLength);

Ret = cciMAValue Crosses Below OverSold;

#### 📄 DIF-MACD由正轉負

{@type:sensor}

// DIF-MACD翻負

//

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: difValue(0), macdValue(0), oscValue(0);

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 3 + 8);

SetInputName(1, \"DIF短期期數\");

SetInputName(2, \"DIF長期期數\");

SetInputName(3, \"MACD期數\");

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

Ret = oscValue Crosses Below 0;

#### 📄 DIF-MACD由負轉正

{@type:sensor}

// DIF-MACD翻正

//

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: difValue(0), macdValue(0), oscValue(0);

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 3 + 8);

SetInputName(1, \"DIF短期期數\");

SetInputName(2, \"DIF長期期數\");

SetInputName(3, \"MACD期數\");

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

Ret = oscValue Crosses Above 0;

#### 📄 DIF-MACD轉正買進訊號

{@type:sensor}

{L.J.R. Sep.2014}

// DIF-MACD翻正

//

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: difValue(0), macdValue(0), oscValue(0);

SetInputName(1, \"DIF短期期數\");

SetInputName(2, \"DIF長期期數\");

SetInputName(3, \"MACD期數\");

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

value1=GetField(\"主力買賣超張數\")\[Z\];

if oscValue Crosses Above 0

and trueall(value1\>300,3)

and tselsindex(10,8)\[Z\]=1

then ret=1;

#### 📄 MACD死亡交叉

{@type:sensor}

// MACD 死亡交叉 (dif向下穿越macd)

//

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: difValue(0), macdValue(0), oscValue(0);

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 3 + 8);

SetInputName(1, \"DIF短期期數\");

SetInputName(2, \"DIF長期期數\");

SetInputName(3, \"MACD期數\");

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

Ret = difValue Crosses Below macdValue;

#### 📄 MACD黃金交叉

{@type:sensor}

// MACD 黃金交叉 (dif向上穿越macd)

//

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: difValue(0), macdValue(0), oscValue(0);

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 3 + 8);

SetInputName(1, \"DIF短期期數\");

SetInputName(2, \"DIF長期期數\");

SetInputName(3, \"MACD期數\");

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

Ret = difValue Crosses Above macdValue;

#### 📄 MFO資金流震盪指標

{@type:sensor}

input:period(20,\"計算天期\");

if range \<\> 0 and range\[1\] \<\> 0 then

value1=
((high-low\[1\])-(high\[1\]-low))/((high-low\[1\])+(high\[1\]-low))\*volume;

if summation(volume,period) \<\> 0 then

value2= summation(value1,period)/summation(volume,period);

if value2 crosses over -0.5 then ret=1;

#### 📄 MTM往上穿過0

{@type:sensor}

// MTM往上穿越0軸

//

Input: Length(10);

settotalbar(maxlist(Length,6) + 8);

SetInputName(1, \"期數\");

Ret = Momentum(Close, Length) Crosses Above 0;

#### 📄 MTM突破零且投信買超

{@type:sensor}

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

if momentum(close,10) crosses over 0

and GetField(\"投信買賣超\")\[Z\]\>1000

then ret=1;

#### 📄 MTM背離

{@type:sensor}

value1=momentum(close,10);

if linearregslope(close,6)\<0

and linearregslope(value1,6)\>0

and close\*1.2\<close\[20\]

then ret=1;

#### 📄 MTM跌破0

{@type:sensor}

// MTM往下跌破0軸

//

Input: Length(10);

settotalbar(maxlist(Length,6) + 8);

SetInputName(1, \"期數\");

Ret = Momentum(Close, Length) Crosses Below 0;

#### 📄 Pivot Point短多策略

{@type:sensor}

variable:pivot(0);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

pivot=(high+low+close)/3;

value1=2\*pivot-low;

if close=value1

and tselsindex(10,6)\[Z\]=1

and volume\>=1000

then ret=1;

#### 📄 RSI低檔背離

{@type:sensor}

// RSI由下往上, 與價格趨勢背離

//

Input: RSILength(6), Threshold(20), Region(5);

variable: rsiValue(0);

settotalbar(maxlist(RSILength,6) \* 8 + 8);

SetInputName(1, \"期數\");

SetInputName(2, \"低檔值\");

SetInputName(3, \"日期區間\");

RSIValue = RSI(Close, RSILength);

If RSIValue Crosses Above Threshold and

RSIValue \>= Highest(RSIValue, Region) and

Close \<= Lowest(Close, Region) then

Ret = 1;

#### 📄 RSI死亡交叉

{@type:sensor}

// RSI短天期往下穿越長天期

//

input: ShortLength(6), LongLength(12);

settotalbar(maxlist(ShortLength,6) \* 8 + 8);

SetInputName(1, \"短期期數\");

SetInputName(2, \"長期期數\");

Ret = RSI(Close, ShortLength) Crosses Below RSI(Close, LongLength);

#### 📄 RSI背離

{@type:sensor}

value1=rsi(close,12);

if linearregslope(close,6)\<0

and linearregslope(value1,6)\>0

and close\*1.2\<close\[20\]

then ret=1;

#### 📄 RSI高檔背離

{@type:sensor}

// RSI由高檔區往下, 與價格趨勢背離

//

Input: RSILength(6), Threshold(80), Region(5);

variable: rsiValue(0);

settotalbar(maxlist(RSILength,6) \* 8 + 8);

SetInputName(1, \"期數\");

SetInputName(2, \"高檔值\");

SetInputName(3, \"日期區間\");

RSIValue = RSI(Close, RSILength);

If RSIValue Crosses Below Threshold and

RSIValue \< Lowest(RSIValue, Region) and

Close \>= Highest(Close, Region) then

Ret = 1;

#### 📄 RSI黃金交叉

{@type:sensor}

// RSI短天期往上穿越長天期

//

input: ShortLength(6), LongLength(12);

settotalbar(maxlist(ShortLength,LongLength,6) \* 8 + 8);

SetInputName(1, \"短期期數\");

SetInputName(2, \"長期期數\");

Ret = RSI(Close, ShortLength) Crosses Above RSI(Close, LongLength);

#### 📄 U型底

{@type:sensor}

input:in1(20,\"底部期數下限\"),in2(0.5,\"標準差放寬倍數\"),in3(20,\"連續下降趨勢天數\");

variable:KP(0),HSV(0);

value1=standarddev(weightedclose,10,2);//計算一定期數標準差

value2=average(value1,250)\*in2;//計算一年標準差

value3=average(C,5);//MA5

value4=average(C,10);//MA10

value5=average(C,20);//MA20

if value1 crosses over value2 //若標準差向上跨越一年平均標準差

then begin

KP=0;

HSV=0;

end;

if value1\>=value2//在連續變動趨勢中

then begin

if value1\>HSV then HSV=value1;//尋找標準差最大點

if HSV\<\>HSV\[1\] then KP=C;//將標準差最大的點之收盤價視為關鍵價

end;

condition2=value1\<value2;//標準差小於年均標準差

condition3=trueall(condition2,in1);//連續20期

condition4=value4\<value4\[1\];//MA10為下降趨勢

condition5=trueall(condition4,in3);//連續下降20期

condition7=trueall(not condition4,in3);//連續20期不下降

if not condition5 and condition5\[1\] then condition6=true;//若連續下降

if C crosses over KP and condition3 and
trueall(condition6,round(in3/2,0))

//若收盤價突破關鍵價且期間內標準差小於年均且下降趨勢結束一段時間

then begin

condition6=false;

ret=1;//買進

end;

#### 📄 WVAD買進訊號

{@type:sensor}

//ETF 作多 40天後出場

input:length(14);

variable:wvad(0);

value1=close-open;

value2=high-low;

if high\<\>low

then value3=value1/value2\*volume

else

value3=value3\[1\];

wvad=summation(value3,length);

if wvad\<0

and linearregslope(wvad,5)\>0

and linearregslope(wvad,15)\<0

and linearregslope(close,20)\<0

and GetSymbolField(\"tse.tw\",\"收盤價\",\"W\")

\>average(GetSymbolField(\"tse.tw\",\"收盤價\",\"W\"),13)

then ret=1;

#### 📄 三連陽過前年最高點

{@type:sensor}

//全部 持有二十天

input:period(500,\"創n日新高\");

settotalbar(period);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

value1=GetField(\"強弱指標\",\"D\")\[Z\];

value2=GetField(\"主力買賣超張數\")\[Z\];

if close crosses over highest(close\[1\],period)

and trueall(close\>close\[1\],3)

and trueall(value2\>0,3)

and tselsindex(10,6)\[Z\]=1

then ret=1;

#### 📄 上昇趨勢確立

{@type:sensor}

//市值適中的股票 20天出場

input:Length(20); //\"計算期間\"

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

LinearReg(close, Length, 0, value1, value2, value3, value4);

//做收盤價20天線性回歸

{value1:斜率,value4:預期值}

value5=rsquare(close,value4,20);//算收盤價與線性回歸值的R平方

value6=GetField(\"主力買賣超張數\")\[Z\];

if value1\> 0 and value5 crosses over 0.2

and trueall(value6\>100,3)

and tselsindex(10,8)\[Z\]=1

then ret=1;

#### 📄 下跌後的吊人線

{@type:sensor}

condition1=false;

condition2=false;

condition3=false;

if high\<= maxlist(open, close)\*1.01

//條件1:小紅小黑且上影線很小

then condition1=true;

if (close-low)\> (open-close)\*2 and (close-low)\>close\*0.02

//條件2:下影線為實體兩倍以上

then condition2=true;

if highest(high,30)\>close\[1\]\*1.4

//條件3:近30日來最高點到昨天跌幅超過40%

then condition3=true;

{結果判斷}

IF condition1

and condition2

and condition3

and average(volume,100)\>1000

//只計算有量的股票

then ret=1;

#### 📄 下降趨勢突破

{@type:sensor}

input:in1(70,\"計算區間\"),in2(false,\"嚴格模式\");

//尋找不同區間大小下目測所認為的高點。

value1=highest(H,in1);//找出一定區間的高點

if value1\>value1\[1\] then value2=value1;

//如果高點變高則保留高點，這樣做的原因是可以找到一波下降之後的高點

condition1 = value2=value2\[1\];

//條件:保留之高點維持(階梯的平台)

condition2 = trueall(condition1,in1);

//在計算區間內高點都沒有變

if condition2 and not condition2\[1\]

then begin

value6=value5;

value5=value4;

value4=value3;

value3=value2;

end;

condition3 =

value3-value2\<value4-value3

and value4-value3\<value5-value4

and (value5-value4\<value6-value5 or not in2)//嚴格模式多判斷一階

and value3-value2\>0

;//平台的高度一階比一階低

if condition3\[1\] and not condition3 then ret=1;

//此秩序被打破時進場

#### 📄 中小型股趨勢成型

{@type:sensor}

// ADX趨勢成形

// 用有量的中小型股，5%停利，5%停損

if GetSymbolField(\"tse.tw\",\"收盤價\")

\> average(GetSymbolField(\"tse.tw\",\"收盤價\"),10)

//大盤OK

then begin

input: Length(14,\"期數\"), Threshold(25,\"穿越值\");

variable: pdi_value(0), ndi_value(0), adx_value(0);

DirectionMovement(Length, pdi_value, ndi_value, adx_value);

if adx_value Crosses Above Threshold

//adx趨勢成形

and pdi_value\>ndi_value

//+DI\>-DI

and close \<close\[30\]

then ret=1;

end;

#### 📄 主力押大注

{@type:sensor}

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

value1=GetField(\"主力買賣超張數\")\[Z\];

if value1=highest(value1,120)

and trueall(value1\>0,3)

and volume\>500

and close\>close\[1\]\*1.03

then ret=1;

#### 📄 主力收集完開始拉

{@type:sensor}

//中小型股，持股20天

//漲幅3%以上

//爆大量，且一般而言會是月均量1倍以上

//主力近1日買超要相對過去的買超有成長。

//買進家數小於賣出家數

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

value1=GetField(\"分公司買進家數\",\"D\")\[Z\];

value2=GetField(\"分公司賣出家數\",\"D\")\[Z\];

value3=GetField(\"主力買賣超張數\")\[Z\];

if close\>close\[1\]\*1.03

and value3\>average(value3,20)

and value1\<value2

and volume \>2\*average(volume,20)

and tselsindex(10,8)\[Z\]=1

then ret=1;

#### 📄 主力累計買超比例過門檻

{@type:sensor}

//作多 中小型股 持有二十天

input: Length(5); setinputname(1,\"計算天數\");

input:TXT(\"僅適用日線以上\"); setinputname(2,\"使用限制\");

input:limit1(20);

setinputname(3,\"買超佔成交量比例\");

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

variable: b1(0), v1(0),ratio(0);

b1 = summation(GetField(\"主力買賣超張數\")\[Z\], Length);

v1 = summation(Volume, Length);

ratio=b1/v1\*100;

value1=GetField(\"主力買賣超張數\")\[Z\];

if v1\<\>0

then

begin

if ratio\>=limit1 and average(volume,20)\>1000

and trueall(value1\>100,3)

and tselsindex(10,6)\[Z\]=1

then ret=1;

end;

#### 📄 乖離反轉作多買進訊號

{@type:sensor}

//用週線 四週後出場

input:Length(20,\"計算期數\");

input:Ratio(21,\"乖離%\");

input:TXT(\"僅適用日線\",\"使用限制\");

settotalbar((Length+10)\*5);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

variable:KPrice(0);

if close \<= average(getfield(\"close\",\"W\"),Length) \* (1-Ratio/100)
then KPrice = getfield(\"high\",\"W\");

value1=GetField(\"投信買賣超\")\[Z\];

value2=value1\*close\*1000;

if countif(value2\>1000000,3)\>2

and close\>KPrice and getfield(\"close\",\"W\")\[1\] \<
xf_getvalue(\"W\",KPrice,1)

then ret=1 ;

#### 📄 價值股創近年新高

{@type:sensor}

if close crosses over highest(close\[1\],220)

then ret=1;

#### 📄 共振策略

{@type:sensor}

input: shortlength(5,\"短期均線期數\");

input: midlength(20,\"中期均線期數\");

input: Longlength(60,\"長期均線期數\");

input: Percent(5,\"均線糾結區間%\");

input: XLen(6,\"均線糾結期數\");

variable:sv(0),mv(0),lv(0);

sv = average(close,shortlength);

mv = average(close,midlength);

lv = average(close,Longlength);

variable: avgh(0),avgl(0),avghlp(0);

AvgH = maxlist(sv,mv,lv );

AvgL = minlist(sv,mv,lv );

if AvgL \> 0 then AvgHLp = 100\*AvgH/AvgL -100;

input: Length1(14 , \"威廉指標計算天數\");

value1 = PercentR(Length1);

if trueAll(AvgHLp \< Percent,XLen)

and value1\>80

and close\>close\[1\]\*1.025

then ret=1;

#### 📄 布林通道超買訊號

{@type:sensor}

// 布林通道超買訊號

//

Input: Length(20), UpperBand(2);

settotalbar(Length + 3);

SetInputName(1, \"期數\");

SetInputName(2, \"通道上緣\");

Ret = High \>= bollingerband(Close, Length, UpperBand);

#### 📄 布林通道超賣訊號

{@type:sensor}

// 布林通道超賣訊號

//

Input: Length(20), LowerBand(2);

settotalbar(Length + 3);

SetInputName(1, \"期數\");

SetInputName(2, \"通道下緣\");

Ret = Low \<= bollingerband(Close, Length, -1 \* LowerBand);

#### 📄 帶量突破均線

{@type:sensor}

// 帶量突破均線

//

input: Length(10), VolFactor(2);

settotalbar(3);

setbarback(Length);

SetInputName(1, \"期數\");

SetInputName(2, \"成交量放大倍數\");

if close \> Average(close, Length) and close\[1\] \< Average(close,
Length) and

volume \> Average(volume, Length) \* VolFactor

then ret=1;

#### 📄 帶量跌破均線

{@type:sensor}

// 帶量跌破均線

//

input: Length(10), VolFactor(2);

settotalbar(3);

setbarback(Length);

SetInputName(1, \"期數\");

SetInputName(2, \"成交量放大倍數\");

if close \< Average(close, Length) and close\[1\] \> Average(close,
Length) and

volume \> Average(volume, Length) \* VolFactor

then ret=1;

#### 📄 底部出大量

{@type:sensor}

input:period(60);

if close=lowest(close,period)

and volume=highest(volume,period)

then ret=1;

#### 📄 找起漲點的策略

{@type:sensor}

Input: Length(20, \"期數\");

input: UpperBand(2, \"通道上緣\");

input: lowerband(-2,\"通道下緣\");

variable:Kprice(0);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

value1= bollingerband(Close, Length, UpperBand);

value2= bollingerband(Close, Length, lowerBand);

value3=value1-value2;

value4=average(close,20);

if linearregslope(value4,5)\>0

and value3\>average(value3,20)\*1.3

and close\[1\] crosses over value1

and close\>value1

and tselsindex(10,6)\[Z\] = 1

then ret=1;

#### 📄 投信天天買 股價天天小漲

{@type:sensor}

//中小型股 持有二十天

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

value1=GetField(\"投信買賣超\")\[Z\];

value2=GetField(\"主力買賣超張數\")\[Z\];

input:day(8);

if countif(value1\>0,day)\>=7

//八天裡至少七天投信買超

and countif(close\>close\[1\],day)\>=5

//八天裡至少五天上漲

and average(volume,10)\<2000

and trueall(value2\>0,3)

and tselsindex(10,8)\[Z\]=1

then ret=1;

#### 📄 投信近幾日買超比例高的

{@type:sensor}

input: pastDays(5); setinputname(1,\"計算天數\");

input: \_BuyRatio(10); setinputname(2,\"買超佔比例(%)\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

variable: SumForce(0);

variable: SumTotalVolume(0);

if BarFreq \<\> \"D\" then return;

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

value1=GetField(\"主力買賣超張數\")\[Z\];

SumForce = Summation(GetField(\"投信買賣超\")\[Z\], pastDays);

sumTotalVolume = Summation(Volume, pastDays);

if SumForce \> SumTotalVolume \* \_BuyRatio/100

and tselsindex(10,8)\[Z\]=1

then ret =1;

#### 📄 景氣循環股操作法

{@type:sensor}

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: midlength(10); setinputname(2,\"中期均線期數\");

input: Longlength(20); setinputname(3,\"長期均線期數\");

input: Percent(2); setinputname(4,\"均線糾結區間%\");

input: Volpercent(40);
setinputname(5,\"放量幅度%\");//帶量突破的量是超過最長期的均量多少%

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

variable:Kprice(0);

if volume \> average(volume,Longlength) \* (1 + volpercent \* 0.01) then

begin

shortaverage = average(close,shortlength);

midaverage = average(close,midlength);

Longaverage = average(close,Longlength);

if Close crosses over maxlist(shortaverage,midaverage,Longaverage) then

begin

value1= absvalue(shortaverage -midaverage);

value2= absvalue(midaverage -Longaverage);

value3= absvalue(Longaverage -shortaverage);

if maxlist(value1,value2,value3)\*100 \< Percent\*Close then Kprice=H;

end;

end;

if C crosses above Kprice

//and tselsindex(10,8)=1

then ret=1;

#### 📄 波動放大

{@type:sensor}

// 波動放大

//

input: Length(20), Percent(7);

settotalbar(3);

setbarback(Length);

SetInputName(1, \"期數\");

SetInputName(2, \"波動幅度%\");

Ret = Highest(High, Length) / Lowest(Low, Length) -1 \> Percent\*0.01;

#### 📄 波動縮小

{@type:sensor}

// 波動縮小

//

input: Length(20), Percent(7);

settotalbar(3);

setbarback(Length);

SetInputName(1, \"期數\");

SetInputName(2, \"波動幅度%\");

Ret = Highest(High, Length) / Lowest(Low, Length) -1 \< Percent\*0.01;

#### 📄 漲幅警示

{@type:sensor}

input: Length(5), Percent(3);

settotalbar(3);

setbarback(Length);

SetInputName(1, \"計算期數\");

SetInputName(2, \"累計上漲幅度(%)\");

Ret = Rateofchange(Close, Length) \> Percent;

#### 📄 潛龍昇天

{@type:sensor}

input:StartDate(20150301);

input:LowMonth(3);

if currentbar =1 and date \< startdate then
raiseruntimeerror(\"日期不夠遠\");

variable:iHigh(0); iHigh=maxlist(iHigh,H);

variable:iLow(100000); iLow=minlist(iLow,L);

variable:hitlow(0),hitlowdate(0);

if iLow = Low then //觸低次觸與最後一次觸低日期

begin

hitlow+=1;

hitlowdate =date;

end;

if DateAdd(hitlowdate,\"M\",1) \< Date
and//如果自觸低點那天三個月後都沒有再觸低

iHigh/iLow \< 1.3 and //波動在三成以內

iHigh = High then

//來到設定日期以來最高點

ret =1;

#### 📄 盤整後跳空走高

{@type:sensor}

//中小型股 停損停利都是5%

input:period(20,\"盤整區間\");

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

value1=highest(high\[1\],period);

value2=lowest(low\[1\],period);

if value1\<value2\*1.05

and open \> high\[1\]\*1.025

and tselsindex(10,7)\[Z\]=1

then ret=1;

#### 📄 短期均線突破長期均線

{@type:sensor}

input: Shortlength(5); setinputname(1,\"短期均線期數\");

input: Longlength(20); setinputname(2,\"長期均線期數\");

settotalbar(8);

setbarback(maxlist(Shortlength,Longlength,6));

If Average(Close,Shortlength) crosses over Average(Close,Longlength)
then Ret=1;

#### 📄 短期均線跌破長期均線

{@type:sensor}

input: Shortlength(5); setinputname(1,\"短期均線期數\");

input: Longlength(20); setinputname(2,\"長期均線期數\");

settotalbar(8);

setbarback(maxlist(Shortlength,Longlength,6));

If Average(Close,Shortlength) crosses under Average(Close,Longlength)
then Ret=1;

#### 📄 突破投信成本線

{@type:sensor}

//小型股

input: pastDays(3); setinputname(1,\"計算天數\");

input: \_BuyRatio(10); setinputname(2,\"買超佔比例(%)\");

variable: SumAm(0),SumForce(0),
SumTotalVolume(0),APrice(0),AVGP(0),Kprice(0),QDate(0);

if V\[1\] \<\> 0 then

APrice = GetField(\"成交金額\")\[1\] / V\[1\]/1000;

SumAm = Summation(GetField(\"投信買賣超\")\[1\]\*APrice, pastDays);

SumForce = Summation(GetField(\"投信買賣超\")\[1\], pastDays);

sumTotalVolume = Summation(Volume\[1\], pastDays);

if SumAm \> 30000 and SumForce \> SumTotalVolume \* \_BuyRatio/100 then

begin

Kprice =highest(avgprice,pastDays);

QDate=Date;

end;

if DateDiff(Date,QDate) \< pastDays+5 and C \> Kprice and C\[1\] \<
Kprice then ret=1;

#### 📄 第一次站上20週均線

{@type:sensor}

if barfreq\<\>\"W\" then return;

if close crosses over average(close,20)

and barslast(close crosses over average(close,20))\[1\]

\>20

then ret=1;

#### 📄 股價穿越突破三均線

{@type:sensor}

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: midlength(10); setinputname(2,\"中期均線期數\");

input: Longlength(20); setinputname(3,\"長期均線期數\");

settotalbar(3);

setbarback(maxlist(shortlength,midlength,Longlength));

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

shortaverage=Average(close,shortlength);

midaverage=Average(close,midlength) ;

Longaverage = Average(close,Longlength);

if close \> maxlist(shortaverage, midaverage, longaverage) and

open \< minlist(shortaverage, midaverage, longaverage)

then ret=1;

#### 📄 股價穿越突破單均線

{@type:sensor}

input: length(5); setinputname(1,\"均線期數\");

input: Price(Close); setinputname(2,\"價格別\");

settotalbar(3);

setbarback(length);

variable: avgValue(0);

avgValue = Average(Price,length);

if close \> avgValue and open \< avgValue then ret=1;

#### 📄 股價穿越突破雙均線

{@type:sensor}

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: Longlength(20); setinputname(2,\"長期均線期數\");

settotalbar(3);

setbarback(maxlist(shortlength,Longlength));

variable: Longaverage(0);

variable: shortaverage(0);

Longaverage = Average(close,Longlength);

shortaverage=Average(close,shortlength) ;

if close \> maxlist(shortaverage, longaverage) and

open \< minlist(shortaverage, longaverage)

then ret=1;

#### 📄 股價穿越跌破三均線

{@type:sensor}

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: midlength(10); setinputname(2,\"中期均線期數\");

input: Longlength(20); setinputname(3,\"長期均線期數\");

settotalbar(3);

setbarback(maxlist(shortlength,midlength,Longlength));

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

shortaverage=Average(close,shortlength);

midaverage=Average(close,midlength) ;

Longaverage = Average(close,Longlength);

if open \> maxlist(shortaverage, midaverage, longaverage) and

close \< minlist(shortaverage, midaverage, longaverage)

then ret=1;

#### 📄 股價穿越跌破單均線

{@type:sensor}

input: length(5); setinputname(1,\"均線期數\");

input: Price(Close);setinputname(2,\"價格別\");

settotalbar(3);

setbarback(length);

variable: avgValue(0);

avgValue = Average(Price,length);

if close \< avgValue and open \> avgValue then ret=1;

#### 📄 股價穿越跌破雙均線

{@type:sensor}

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: Longlength(20); setinputname(2,\"長期均線期數\");

settotalbar(3);

setbarback(maxlist(shortlength,Longlength));

variable: Longaverage(0);

variable: shortaverage(0);

Longaverage = Average(close,Longlength);

shortaverage=Average(close,shortlength) ;

if open \> maxlist(shortaverage, longaverage) and

close \< minlist(shortaverage, longaverage)

then ret=1;

#### 📄 股價轉趨活躍

{@type:sensor}

//小型股

input:day(66);

input:ratio(10);

variable:count(0);

setinputname(1,\"移動平均天數\");

setinputname(2,\"超出均值比率\");

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

value1=GetField(\"總成交次數\");

value2=average(value1,day);

value3=GetField(\"強弱指標\")\[Z\];

value4=average(value3,day);

value5=GetField(\"外盤均量\")\[Z\];

value6=average(value5,day);

value7=GetField(\"主動買力\")\[Z\];

value8=average(value7,day);

value9=GetField(\"開盤委買\");

value10=average(value9,day);

count=0;

if value1\>=value2\*(1+ratio/100)

then count=count+1;

if value3\>=value4\*(1+ratio/100)

then count=count+1;

if value5\>=value6\*(1+ratio/100)

then count=count+1;

if value7\>=value8\*(1+ratio/100)

then count=count+1;

if value9=value10\*(1+ratio/100)

then count=count+1;

value11=average(count,5);

value12=average(count,20);

if value11 crosses over value12

and value12\<2.2

and highest(close,20)\<lowest(close,20)\*1.1

and tselsindex(10,8)\[Z\]=1

and GetField(\"主力買賣超張數\")\[Z\]\>100

then ret=1;

#### 📄 跌幅警示

{@type:sensor}

input: Length(5), Percent(3);

settotalbar(3);

setbarback(length);

SetInputName(1, \"計算期數\");

SetInputName(2, \"累計下跌幅度(%)\");

Ret = RateOfChange(Close, Length) \< -1 \* Percent;

#### 📄 進入上昇趨勢

{@type:sensor}

//高ROE股持有20天

input:period(12);

value1=countif(low\<lowest(low\[1\],period),period);

value2=countif(high\>highest(high\[1\],period),period);

value3=value2-value1;

if average(GetSymbolField(\"tse.tw\",\"收盤價\",\"D\"),5)

\> average(GetSymbolField(\"tse.tw\",\"收盤價\",\"D\"),20)

then begin

if value3 crosses over 4

then ret=1;

end;

#### 📄 過去N日有多日跳空且未拉回

{@type:sensor}

//中小型股 停損停利都是5%

input:day(5,\"過去N日\");

input:lowlimit(2,\"符合條件天數\");

input:period(20,\"盤整區間\");

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

value1=highest(high\[day\],period);

value2=lowest(low\[day\],period);

if value1\<value2\*1.05

and countif(high\>high\[1\]

and low\>low\[1\],day)\>=lowlimit

and tselsindex(10,8)\[Z\]=1

then ret=1;

#### 📄 野百合的春天

{@type:sensor}

//獲利穩定的公司 20天後出場

settotalbar(700);

if getsymbolfield(\"tse.tw\",\"收盤價\")

\> average(getsymbolfield(\"tse.tw\",\"收盤價\"),10)

then begin

value4=GetField(\"總市值\");

value5=average(value4,600);

if value4\[1\]\<value5\[1\]\*0.7

and close=highest(close,10)

then ret=1;

end;

#### 📄 開始有人問津

{@type:sensor}

if average(truerange/close,20)\*100\<3

and truerange crosses over average(truerange,20)\*1.2

and average(volume,30)\<600

and close\>close\[1\]\*1.025

and close\<30

then ret=1;

### 3.10 抄底策略 (5 個)

#### 📄 大跌後均線糾結後上漲

{@type:sensor}

input: s1(5,\"短期均線期數\");

input: s2(10,\"中期均線期數\");

input: s3(20,\"長期均線期數\");

input: Percent(2,\"均線糾結區間%\");

input:
Volpercent(25,\"放量幅度%\");//帶量突破的量是超過最長期的均量多少%

variable: Shortaverage(0);

variable: Midaverage(0);

variable: Longaverage(0);

if volume \> average(volume,s3) \* (1 + volpercent \* 0.01)

//放量25%

and lowest(volume,s3)\<1000

//區間最低量小於一千張

and volume\>2000

//今日成交量突破2000張

then begin

Shortaverage = average(close,s1);

Midaverage = average(close,s2);

Longaverage = average(close,s3);

value1= maxlist(Shortaverage,Midaverage,Longaverage) -
minlist(Shortaverage,Midaverage,Longaverage);

if value1\*100 \< Percent\*Close

and linearregangle(value1,5)\<10

//均線糾結在一起

and close\*1.3\<close\[40\]

//最近四十個交易日跌了超過三成

then ret=1;

end;

#### 📄 大跌後的低檔五連陽

{@type:sensor}

if trueall(close\>open,5)

and close\*1.4\<close\[90\]

then ret=1;

#### 📄 大跌後的連續跳空上漲

{@type:sensor}

if close\*1.5\<close\[40\]

//過去四十個交易日跌了超過四成

and countif(open \> close\[1\],5)\>=3

//過去五天有三天以上開盤比前一天收盤高

and GetSymbolField(\"tse.tw\",\"收盤價\",\"D\")

\>average(GetSymbolField(\"tse.tw\",\"收盤價\",\"D\"),10)

//指數位於十日均線之上

and average(volume,5)\>2000

//五日均量大於2000張

then ret=1;

#### 📄 底部確認

{@type:sensor}

input:period(200,\"天數\");

variable: ld(0),hd(0),ldb(0),hdb(0),count(0),x1(0);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

count=0;

ld=lowest(low,period);

ldb=lowestbar(low,period);

hd=highest(high,period);

hdb=highestbar(high,period);

x1=GetField(\"總市值\",\"D\")\[Z\];//單位：億

if hdb\>ldb and hd\>ld\*1.4 and ld\>=ld\[1\] and x1\>20 then begin

//股價大跌後

value1=countif((close-open)/open\>1.5,ldb);

//自最低點以來的中長紅K棒數

if value1\>=ldb/5 then count=count+1;

value2=summationif(close\>close\[1\],volume,ldb);

//自最低點以來的上漲量

value3=summationif(close\<close\[1\],volume,ldb);

//自最低點以來的下跌量

if value2\>2\*value3 then count=count+1;

value4=nthlowestbar(2,low,ldb);

//第二個低點的k棒位置

value5=nthlowestbar(3,low,ldb);

//第三個低點的K棒位置

value6=nthlowestbar(4,low,ldb);

//第四個低點的K棒位置

if value4\>value5 and value5\>value6 then count=count+1;

value7=countif(absvalue(close\[1\]/close-1)/close\[1\]\*100\<1 and
close\<close\[1\],ldb);

//自低點以來的小黑棒K棒數

if value7\>0.5\*countif(close\<close\[1\],ldb) then count=count+1;

//小黑k棒佔下跌k棒超過一半

value8=countif(close\>low\*1.01,ldb);

//自低點以來的長下影線天數

if value8 \>=ldb/5 then count=count+1;

value9=countif(close=high,ldb);

//自低點以來收最高的天數

if value9\>=ldb/5 then count=count+1;

if ldb\>=5 then count=count+1;

end;

if count\[1\]\>2 and count crosses over 5 then ret=1;

#### 📄 跌深後的反彈

{@type:sensor}

input:ratio(10,\"近十日最小下跌幅度\");

if open\*1.025\<close\[1\]//開盤重挫

and close\>open //收盤比開盤高

and close\*(1+ratio/100)\<close\[9\]

//近十日跌幅超過N%

and low\*1.01\<open

//開低後又殺低

then ret=1;

### 3.11 期權策略 (2 個)

#### 📄 快到期了還是價內

{@type:sensor}

if q_IOofMoney\>0

and datediff(GetSymbolInfo(\"到期日\"),date)\<10

and datediff(GetSymbolInfo(\"到期日\"),date)\>0

then ret=1;

#### 📄 期指短打

{@type:sensor}

if barfreq\<\>\"Min\" or barinterval\<\>1 then
raiseruntimeerror(\"頻率請用1分K\");

variable:l1(0),l2(0),l3(0),l4(0),l5(0),l6(0),l7(0),l8(0),l9(0),l10(0),x(0),i(0),
base(0);

variable:day(3);

if GetField(\"日期\",\"Tick\") \<\> currentdate then return;

if time = 091500 then begin

base = GetField(\"收盤價\",\"Tick\"); // 基準點

x = 0;

for i=1 to day

x=highd(i)-lowd(i)+x;

value4=x/day;

l1=base+value4\*0.191;

l2=base+value4\*0.382;

l3=base+value4\*0.5;

l4=base+value4\*0.618;

l5=base+value4\*0.809;

l6=base-value4\*0.191;

l7=base-value4\*0.382;

l8=base-value4\*0.5;

l9=base-value4\*0.618;

l10=base-value4\*0.809;

end;

if base \<\> 0 then begin

if GetField(\"收盤價\",\"Tick\") crosses over base+6 then begin

ret=1;

retmsg=\"作多第一口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses over base+12 then begin

ret=1;

retmsg=\"作多第二口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses over base+18 then begin

ret=1;

retmsg=\"作多第三口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses over base+24 then begin

ret=1;

retmsg=\"作多第四口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses over base+30 then begin

ret=1;

retmsg=\"作多第五口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses over base+36 then begin

ret=1;

retmsg=\"作多第六口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses under value3-6 then begin

ret=1;

retmsg=\"作空第一口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses under value3-12 then begin

ret=1;

retmsg=\"作空第二口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses under value3-18 then begin

ret=1;

retmsg=\"作空第三口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses under value3-24 then begin

ret=1;

retmsg=\"作空第四口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses under value3-30 then begin

ret=1;

retmsg=\"作空第五口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses under value3-36 then begin

ret=1;

retmsg=\"作空第六口\";

end;

if GetField(\"收盤價\",\"Tick\") crosses over l1

or GetField(\"收盤價\",\"Tick\") crosses over l2

or GetField(\"收盤價\",\"Tick\") crosses over l3

or GetField(\"收盤價\",\"Tick\") crosses over l4

or GetField(\"收盤價\",\"Tick\") crosses over l5

then begin

ret=1;

retmsg=\"50秒後請自動平倉\";

end;

if GetField(\"收盤價\",\"Tick\") crosses under l6

or GetField(\"收盤價\",\"Tick\") crosses under l7

or GetField(\"收盤價\",\"Tick\") crosses under l8

or GetField(\"收盤價\",\"Tick\") crosses under l9

or GetField(\"收盤價\",\"Tick\") crosses under l10

then begin

ret=1;

retmsg=\"50秒後請自動平倉\";

end;

end;

print(date,time,GetField(\"日期\",\"Tick\"),GetField(\"時間\",\"Tick\"),GetField(\"收盤價\",\"Tick\"),l1);

### 3.12 波段操作型 (34 個)

#### 📄 60分鐘線九連陽

{@type:sensor}

input:TXT(\"僅適用60分鐘線\"); setinputname(1,\"使用限制\");

settotalbar(10);

if barfreq\<\> \"Min\" or barinterval \<\> 60 then return;

if TrueAll(Close \> Close\[1\] and Close \> Open ,9) then Ret=1;

#### 📄 SAR買進訊號

{@type:sensor}

input:AFIncrement(0.02); setinputname(1,\"加速因子\");

input:AFMax(0.2); setinputname(2,\"加速因子最大值\");

settotalbar(100);

variable:

sarValue(0);

sarValue = SAR(AFIncrement, AFIncrement, AFMax);

if close crosses over sarValue then ret = 1;

#### 📄 休息後風雲再起

{@type:sensor}

settotalbar(5);

condition1 = Close\[3\] \> low\[3\]\* 1.01;

condition2 = close\[2\] \> open\[2\] \* 1.01 and open\[2\]\>close\[3\];

condition3 = close\[1\] \< close\[2\] and high\[1\] \< close\[1\]\*
1.005;

condition4 = close \> close\[1\] \* 1.01;

if condition1 and condition2 and condition3 and condition4 then ret=1;

#### 📄 低PB股的逆襲

{@type:sensor}

if GetSymbolField(\"tse.tw\",\"收盤價\") \>
average(GetSymbolField(\"tse.tw\",\"收盤價\"),10)

then begin

if close\<12

and H = highest(H,20)

and close\<lowest(low,20)\*1.07

and highest(h,40)\>close\*1.1

then ret=1;

end;

#### 📄 低檔連n日拉尾盤

{@type:sensor}

input:Length(3); setinputname(1,\"拉尾盤日數\");

input:Ratio(1); setinputname(2,\"拉尾盤幅度%\");

input:closetime(132500); setinputname(3,\"尾盤前時間\");

input:ratiotoLow(7);
setinputname(4,\"低檔起算漲幅%\");//距離區間最低價多少%

input:daystoLow(5);
setinputname(5,\"距離最低價天數\");//輸入區間最低價的區間是幾天

input:TXT1(\"最高算5天\"); setinputname(6,\"拉尾盤日數使用限制\");

input:TXT2(\"限用5分鐘\"); setinputname(7,\"頻率限制\");

settotalbar(3);

setbarback(300);

if barfreq \<\> \"Min\" or barinterval \<\> 5 or Length\>5 or daystoLow
\>5 then return;

variable:i(0);

variable:TodayBars(270/barinterval);

if close \>= lowest(close,daystoLow \* TodayBars) \*( 1 +
ratiotoLow\*0.01) then return;

if time \>= closetime then

begin

for i = 0 to Length-1

begin

// 判斷是否拉尾盤

if close\[TodayBars\*i\] \<= close\[TodayBars\*i+1\] \* (1+ Ratio/100)
then return;

end;

ret=1;

end;

#### 📄 反常必有妖

{@type:sensor}

input:TXT(\"僅適用60分鐘\"); setinputname(1,\"使用限制\");

settotalbar(30);

if barinterval \<\> 60 or barfreq\<\> \"Min\" then return;

if Close \> close\[1\] \* 1.02 then

begin

value2=average(truerange,30);

value3=average(truerange,3);

if truerange\>value3 and value3\>value2 then ret=1;

end;

#### 📄 均線多頭排列

{@type:sensor}

input: shortlength(5,\"短期均線期數\");

input: midlength(10,\"中期均線期數\");

input: Longlength(20,\"長期均線期數\");

input: SuperLong(60,\"超長期均線期數\");

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

variable: SuperLongaverage(0);

settotalbar(3);

setbarback(maxlist(shortlength,midlength,Longlength,SuperLong));

if Close \> close\[1\] then

begin

shortaverage=Average(close,shortlength);

midaverage=Average(close,midlength) ;

Longaverage = Average(close,Longlength);

SuperLongaverage = Average(close,SuperLong);

if close\>shortaverage and

shortaverage\>midaverage and

midaverage\>Longaverage and

Longaverage\>SuperLongaverage

then ret=1;

end;

#### 📄 外盤買氣轉強

{@type:sensor}

input:short1(5,\"短期平均\"),mid1(20,\"長期平均\");

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

value1=GetField(\"內盤量\");//內盤量

value2=GetField(\"外盤量\");//外盤量

value3=value1+value2;

if value3\<\>0 then value4=value2/value3\*100;

//外盤比重

value5=average(value4,short1);

value6=average(value4,mid1);

if close\*1.4\<close\[90\]

and value5 crosses above value6

and value4\>60

and average(volume,100)\>1000

and tselsindex(10,6)\[Z\]=1

then ret=1;

#### 📄 多次到底而破

{@type:sensor}

input:day(100,\"計算區間\");

input:band1(4,\"三高點之高低價差\");

value1=nthlowest(1,low\[1\],day);

value2=nthlowest(3,low\[1\],day);

value4=nthlowestbar(1,low,day);

value5=nthlowestbar(3,low,day);

value6=nthlowestbar(5,low,day);

value7=absvalue(value4-value6);

value8=absvalue(value5-value6);

value9=absvalue(value4-value5);

condition1=false;

if value7\>3 and value8\>3 and value9\>3

then condition1=true;

value3=(value1-value2)/value2;

if value3\<=band1/100

and close crosses under value1

and volume\>2000

and condition1

then ret=1;

#### 📄 多次到頂而突破

{@type:sensor}

input:HitTimes(3,\"設定觸頂次數\");

input:RangeRatio(1,\"設定頭部區範圍寬度%\");

input:Length(20,\"計算期數\");

settotalbar(300);

setbarback(100);

variable: theHigh(0);

variable: HighLowerBound(0);

variable: TouchRangeTimes(0);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

theHigh = Highest(High\[1\],Length); //找到過去區間的最高點

HighLowerBound = theHigh \*(100-RangeRatio)/100; // 設為瓶頸區間上界

//回算在此區間中 進去瓶頸區的次數

TouchRangeTimes = CountIF(High\[1\] \> HighLowerBound, Length);

if TouchRangeTimes \>= HitTimes

and close \> theHigh

and close\[50\]\*1.2 \< close\[20\]

and tselsindex(10,6)\[Z\]=1

then ret=1;

#### 📄 帶量突破糾結的均線

{@type:sensor}

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: midlength(10); setinputname(2,\"中期均線期數\");

input: Longlength(20); setinputname(3,\"長期均線期數\");

input: Percent(2); setinputname(4,\"均線糾結區間%\");

input: Volpercent(25);
setinputname(5,\"放量幅度%\");//帶量突破的量是超過最長期的均量多少%

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

settotalbar(8);

setbarback(maxlist(shortlength,midlength,Longlength));

if volume \> average(volume,Longlength) \* (1 + volpercent \* 0.01) then

begin

shortaverage = average(close,shortlength);

midaverage = average(close,midlength);

Longaverage = average(close,Longlength);

if Close crosses over maxlist(shortaverage,midaverage,Longaverage) then

begin

value1= absvalue(shortaverage -midaverage);

value2= absvalue(midaverage -Longaverage);

value3= absvalue(Longaverage -shortaverage);

if maxlist(value1,value2,value3)\*100 \< Percent\*Close then ret=1;

end;

end;

#### 📄 帶量衝破季線

{@type:sensor}

//股價長期低於季線

//帶量突破季線

input: PriceLength(66); setinputname(1,\"季線計算期數\");

input: BelowLength(66); setinputname(2,\"低於季線期數\");

input: VolLength(20); setinputname(3,\"均量期數\");

input: Volpercent(20); setinputname(4,\"量增幅度%\");

input:TXT(\"建議使用日線\"); setinputname(5,\"使用說明\");

settotalbar(BelowLength + 8);

setbarback(maxlist(PriceLength,VolLength));

variable: PriceAverage(0); PriceAverage= average(Close,PriceLength);

if Close crosses over PriceAverage and

volume \> Average(volume\[1\],VolLength)\* (1+Volpercent/100) and

trueall(close\[1\] \< PriceAverage\[1\], BelowLength-1) then

ret = 1;

#### 📄 平均量黃金交叉

{@type:sensor}

input: shortlength(5); setinputname(1,\"短均量期數\");

input: Longlength(22); setinputname(2,\"長均量期數\");

settotalbar(8);

setbarback(maxlist(shortlength,Longlength));

variable: Longaverage(0);

variable: shortaverage(0);

Longaverage = Average(volume,Longlength);

shortaverage=Average(volume,shortlength) ;

if shortaverage crosses over Longaverage then ret=1;

#### 📄 抗跌

{@type:sensor}

settotalbar(3);

if open\>open\[1\] and open \< 1.005\*low then ret=1;

#### 📄 暴量剛起漲

{@type:sensor}

input: Length(20); setinputname(1,\"計算期數\");

input: VLength(10); setinputname(2,\"均量期數\");

input: volpercent(50); setinputname(3,\"爆量增幅%\");

input: Rate(5); setinputname(4,\"離低點幅度%\");

settotalbar(3);

setbarback(maxlist(Length,VLength));

if Close \> Close\[1\] and

Volume \>= average(volume,VLength) \*(1+ volpercent/100) and

Close \<= lowest(close,Length) \* (1+Rate/100)

then ret=1;

#### 📄 月線連兩個月收紅的小型股

{@type:sensor}

input:TXT(\"僅適用日線\",\"使用限制\");

settotalbar(120);

if GetField(\"總市值\",\"D\")\<2000000000 //單位是元

and close\<40

and getfield(\"close\",\"M\")\[1\]\>getfield(\"close\",\"M\")\[2\]

and getfield(\"close\",\"M\")\[2\]\>getfield(\"close\",\"M\")\[3\]

then ret=1;

#### 📄 沖擊底部

{@type:sensor}

input:BarPercent(75); setinputname(1,\"當期回升比例\");

settotalbar(3);

if q_Ask \> Close\[1\] and high\[1\] \> high\[2\] and low\[1\] \>
low\[2\] and close\[1\] \> close\[2\] then

if TrueAll( (close\[1\]-low\[1\])\>(high\[1\]-low\[1\])\*BarPercent/100
,2) then ret=1;

#### 📄 沿均線前進

{@type:sensor}

//沿著均線前進

input:Length(10); setinputname(1,\"計算期數\");

input:FollowLength(5); setinputname(2,\"貼近均線期數\");

input:Ratio(2);setinputname(3,\"沿均線通道幅度%\");

input:LongShort(0);setinputname(4,\"觸發:創新高1,創新低-1,不指定0\");

settotalbar(FollowLength + 3);

setbarback(Length);

condition1= false;

switch(LongShort)

begin

case =1:

condition1 = close \> highest(high\[1\],Length);

case -1:

condition1 = close \< lowest(low\[1\],Length);

case 0:

condition1=true;

end;

If Condition1 and

TrueAll(absvalue(close-average(close,Length))\<
Close\*Ratio/100,FollowLength)

then Ret=1;

#### 📄 法人作多股

{@type:sensor}

input: ForceType(1); setinputname(1,\"1:外資 2:投信 3:自營\");

input: Atleast(1000); setinputname(2,\"最少買超張數\");

input:TXT(\"須逐筆洗價\"); setinputname(3,\"使用限制:日線\");

settotalbar(3);

if barfreq \<\> \"D\" then return;

variable: ForcePush(0);

Switch ( ForceType )

Begin

Case 1: ForcePush =Getfield(\"外資買賣超\")\[1\];

Case 2: ForcePush =Getfield(\"投信買賣超\")\[1\];

Case 3: ForcePush =Getfield(\"自營商買賣超\")\[1\];

End;

if volume \> volume\[1\] then

begin

condition1 = ( close\[1\]-open\[1\] \> 0.75 \*high\[1\]-low\[1\] ) and
//長紅棒

(high\[1\] -low\[1\]) \> 2 \*( high\[2\]-low\[2\]);

if condition1 and q_Ask \> highest(high\[1\],3) and ForcePush \>Atleast
then ret=1;

end;

#### 📄 法人爭下車

{@type:sensor}

input: ForceType(1); setinputname(1,\"法人：0=合計 1=外資 2=投信
3=自營商\");

input: Periods(20); setinputname(2,\"計算期間\");

input: Percent(5); setinputname(3,\"持股減少幅度%\");

input: Type(1); setinputname(4,\"使用資料：0=今日、1=昨日\");

input: TXT(\"僅適用日線逐筆洗價\"); setinputname(5,\"盤中使用限制\");

input: TXT2(\"盤中無當日即時法人買賣資料\");
setinputname(6,\"建議使用單次洗價模式\");

variable: ForcePush(0);

settotalbar(Periods + 3);

if BarFreq \<\> \"D\" or absvalue(Type) \> 1 then return;

Switch ( ForceType )

Begin

Case 1:

ForcePush = Getfield(\"外資持股\")\[Type\];

Case 2:

ForcePush = Getfield(\"投信持股\")\[Type\];

Case 3:

ForcePush = Getfield(\"自營商持股\")\[Type\];

default:

ForcePush =
Getfield(\"外資持股\")\[Type\]+Getfield(\"投信持股\")\[Type\]+Getfield(\"自營商持股\")\[Type\];

End;

if currentbar \<= Periods then return;

if Close \< Close\[1\] and

ForcePush\[Type\] \< ForcePush\[Periods+Type\] \* (1 - Percent \* 0.01)

then

ret = 1;

#### 📄 法人累計買超超過N張

{@type:sensor}

input: ForceType(1); setinputname(1,\"法人：0=合計 1=外資 2=投信
3=自營商\");

input: Periods(20); setinputname(2,\"計算期間\");

input: Size(3000); setinputname(3,\"累計買超張數\");

input: Type(1); setinputname(4,\"使用資料：0=今日 1=昨日\");

input: TXT1(\"僅適用日線\"); setinputname(5,\"使用限制\");

input: TXT2(\"盤中無當日法人資料\");
setinputname(6,\"建議使用單次洗價模式\");

settotalbar(Periods + 3);

if barfreq \<\> \"D\" then return;

variable: ForcePush(0);

if Type = 0 then value1 = 0 else value1 = 1;

Switch ( ForceType )

Begin

Case 1:

ForcePush = Getfield(\"外資持股\")\[value1\];

Case 2:

ForcePush = Getfield(\"投信持股\")\[value1\];

Case 3:

ForcePush = Getfield(\"自營商持股\")\[value1\];

default:

ForcePush =
Getfield(\"外資持股\")\[value1\]+Getfield(\"投信持股\")\[value1\]+Getfield(\"自營商持股\")\[value1\];

End;

if currentbar \<= Periods then return;

if ForcePush\[value1\] - ForcePush\[Periods+value1\] \>= Size then
ret=1;

#### 📄 波幅縮小後的突破

{@type:sensor}

input:period2(4); setinputname(1,\"短期期數\");

input:period1(12); setinputname(2,\"長期期數\");

input:ratio(2); setinputname(3, \"漲幅%\");

input:TXT(\"建議使用5分鐘\"); setinputname(4,\"使用說明\");

settotalbar(3);

setbarback(maxlist(period1,period2));

if close \> close\[1\] \* (1 + ratio\*0.01) then

begin

value1=average(truerange,period1);

value2=average(truerange,period2);

if value1\>value2 and value2 \< close\* 0.02 then ret=1;

end;

#### 📄 海龜進場法則

{@type:sensor}

input:Length(10); setinputname(1,\"近N週期數\");

input:TXT(\"僅適用日線\"); setinputname(2,\"使用限制\");

settotalbar((Length + 3)\*5);

if barfreq \<\> \"D\" and barfreq \<\> \"AD\" then Return;

if close \> highest(getfield(\"High\",\"W\")\[1\],Length)//近n週最高價

then ret=1;

#### 📄 盤整後噴出

{@type:sensor}

input:Length(30); setinputname(1, \"計算期間\");

input:percent(2.5); setinputname(2, \"設定盤整區間%\");

settotalbar(9);

setbarback(Length);

value1=highest(high\[1\],Length);

value2=lowest(low\[1\],Length);

if close crosses above value1

and value1 \< value2 \*( 1 + percent \* 0.01)
//最近幾根bar的收盤價高點與低點差不到N%

then ret=1;

#### 📄 突破下降趨勢線

{@type:sensor}

input:Length(20); setinputname(1,\"下降趨勢計算期數\");

input:Rate(150); setinputname(2,\"反轉率%\");

variable: Factor(0);

settotalbar(Length + 3);

Factor = 100/Close\[Length\];

value1 = linearregslope(high\*Factor,Length);

value2 = linearregslope(high\*Factor,3);

if close \> open and close \< close\[length\] and value1 \< 0 and
value2-value1 \> Rate\*0.01 then ret=1;

#### 📄 突破糾結均線

{@type:sensor}

input: shortlength(5,\"短期均線期數\");

input: midlength(10,\"中期均線期數\");

input: Longlength(20,\"長期均線期數\");

input: Percent(5,\"均線糾結區間%\");

input: XLen(20,\"均線糾結期數\");

input: Volpercent(25,\"放量幅度%\");
//帶量突破的量是超過最長期的均量多少%

variable: Shortaverage(0),Midaverage(0),Longaverage(0);

variable: AvgHLp(0),AvgH(0),AvgL(0);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

Shortaverage = average(close,shortlength);

Midaverage = average(close,midlength);

Longaverage = average(close,Longlength);

AvgH = maxlist(Shortaverage,Midaverage,Longaverage);

AvgL = minlist(Shortaverage,Midaverage,Longaverage);

if AvgL \> 0 then AvgHLp = 100\*AvgH/AvgL -100;

condition1 = trueAll(AvgHLp \< Percent,XLen);

condition2 = V \> average(V\[1\],XLen)\*(1+Volpercent/100) ;

condition3 = C \> AvgH \*(1.02) and H \> highest(H\[1\],XLen);

condition4 = average(volume\[1\], 5) \>= 1000;

if condition1

and condition2

and condition3

and condition4

and tselsindex(10,6)\[Z\]=1

then ret=1;

#### 📄 自營商獨自偏好

{@type:sensor}

input:Length(20); setinputname(1,\"計算日數\");

input:\_BuyRatio(5); setinputname(2,\"買超佔比%\");

input:TXT(\"僅適用日線\"); setinputname(3,\"使用限制\");

settotalbar(3);

setbarback(Length);

if barfreq \<\> \"D\" then return;

variable: SumForce(0);

variable: SumTotalVolume(0);

variable: OtherForce(0);

SumForce = Summation(GetField(\"自營商買賣超\")\[1\], Length);

SumTotalVolume = Summation(Volume\[1\], Length);

OtherForce = Summation(GetField(\"外資買賣超\")\[1\] +
GetField(\"投信買賣超\")\[1\], Length);

if SumForce \> SumTotalVolume \*\_BuyRatio and SumForce \> OtherForce
then ret =1;

#### 📄 藍籌股RSI低檔背離

{@type:sensor}

input: Periods(50); setinputname(1,\"計算期間\");

input: Length(6); setinputname(2,\"RSI\");

input: LowFilter(25); setinputname(3,\"RSI低檔區\");

settotalbar(maxlist(Periods,maxlist(Length,6) \* 8) + 3);

variable: rsivalue(0);

condition1 = false;

condition2 = false;

condition3 = false;

condition4 = false;

rsivalue = RSI(Close,Length);

value1 = highestbar(high,Periods);//轉折高點距離

value2 = lowestbar(low,Periods);//轉折低點距離

if value2 = 0 //今日為創新低的第二隻腳

then condition1 = true

else return;

if rsivalue \<= LowFilter //RSI位於低檔區

then condition2 = true

else return;

if value2\[value1\] + value1 \< Periods //在計算區間內存在第一隻腳

then condition3 = true

else return;

if rsivalue\[value2\[value1\] + value1\] \< rsivalue //RSI不再創新低

then condition4 = true

else return;

if condition1 and condition2 and condition3 and condition4

then ret = 1;

#### 📄 調整型均線黃金交叉

{@type:sensor}

input:Length(6); setinputname(1,\"起始期數\");

input:TLength(20); setinputname(2,\"終止期數\");

input:AddLength(1); setinputname(3,\"期數調整項\");

input:TuneRatio(3); setinputname(4,\"調整係數\");

settotalbar(TLength + 8);

variable: AvgTR(0);

if Length \>= TLength then return;

AvgTR = average(TrueRange,Length);

value2 = intportion( (TLength -Length)/ AddLength);

for value1 = Length to TLength

begin

if mod( value1 ,AddLength) = 0 or value1 =TLength then

begin

if (AvgTR \> Close \* TuneRatio\*0.01 ) then

begin

AvgTR = average(TrueRange,value1);

value3 = value1;

end;

end;

end;

if close crosses over average(close\[1\] ,value3) then ret=1;

#### 📄 貪婪指數太高

{@type:sensor}

input:RSILength(5); setinputname(1,\"強弱計算期數\");

input:CLength(5); setinputname(2,\"比價期數\");

input:VLength(20); setinputname(3,\"量計算期數\");

input:Raise(20); setinputname(4,\"累計上揚幅度%\");

input: TXT1(\"僅適用日線\"); setinputname(5,\"使用限制\");

variable : MTRatio(0),CloseRatio(0),AVGV(0);

if barfreq \<\> \"D\" then return;

if close \> lowest(low,VLength) \* (1+Raise/100) then

begin

MTRatio=getfield(\"融資增減張數\")\[1\]/volume\[1\];

CloseRatio = close/close\[CLength\];

AVGV = volume\[1\]/average(volume\[1\],VLength);

value1 =
RSI(MTRatio,RSILength)+RSI(CloseRatio,RSILength)+RSI(AVGV,RSILength);

if RSI(value1,RSILength) \>75 then ret=1;

end;

#### 📄 進入上漲軌道

{@type:sensor}

input:period(12,\"期數\");

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

value1=countif(low\<lowest(low\[1\],period),period);

value2=countif(high\>highest(high\[1\],period),period);

value3=value2-value1;

if value3 crosses over 4

and tselsindex(10,6)\[Z\]=1

then ret=1;

#### 📄 長波段回升

{@type:sensor}

input: Length1(30); setinputname(1,\"落底天數\");

input: Size1(2000); setinputname(2,\"量縮張數\");

input: Length2(20); setinputname(3,\"籌碼沉澱天數\");

input: Size2(1000); setinputname(4,\"籌碼清洗張數\");

input: Ratio(10); setinputname(5,\"融資使用率%\");

input: Percent(3); setinputname(6,\"今日漲幅%\");

input: Type(1); setinputname(7,\"融資資料：0=今日 1=昨日\");

input: TXT1(\"僅適用日線\"); setinputname(8,\"使用限制\");

input: TXT2(\"盤中無當日融資資料\");
setinputname(9,\"建議使用單次洗價模式\");

settotalbar(maxlist(Length1,Length2) + 3);

variable:newlowcount(0);

if barfreq \<\> \"D\" or (currenttime \< 133000 and Type=0) then return;

if Type = 0 then value1 = 0 else value1 = 1;

condition1=false;

condition2=false;

condition3=false;

condition4=false;

if close/close\[1\] \> 1 + Percent \* 0.01 //今日強勢股

then condition1=true

else return;

if average(volume,Length1) \< Size1//長期乏人問津

then condition2=true

else return;

if trueany( Low \< Low\[1\],length1) then return;//多日未破底

value2=GetField(\"Pomremain\")\[value1\];//融資餘額

value3=GetField(\"Pomusingratio\")\[value1\];//融資使用率

if value2\[Length2\]-value2 \> Size2 and value3 \< Ratio \*
0.01//籌碼長期沈澱

then condition3 = true

else return;

if average(truerange,5)\>average(truerange,10)//短線波動幅度開始變大

then condition4 = true

else return;

if condition1 and condition2 and condition3 and condition4

then ret=1;

#### 📄 雙KD向上

{@type:sensor}

input: Length_D(9, \"日KD期間\");

input: Length_W(5, \"周KD期間\");

variable:rsv_d(0),kk_d(0),dd_d(0);

variable:rsv_w(0),kk_w(0),dd_w(0);

stochastic(Length_D, 3, 3, rsv_d, kk_d, dd_d);

xf_stochastic(\"W\", Length_W, 3, 3, rsv_w, kk_w, dd_w);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

condition1 = kk_d crosses above dd_d; // 日KD crosses over

condition2 = xf_GetBoolean(\"W\",xf_crossover(\"W\", kk_w, dd_w),1); //
周KD crosses over

condition3 = average(volume\[1\], 5) \>= 1000;

condition4 = kk_d\[1\] \<= 30; // 日K 低檔

condition5 = xf_getvalue(\"W\", kk_w, 1) \<= 50; // 周K 低檔

// 成交量判斷

Condition6 = Average(Volume\[1\], 100) \>= 1000;

if condition1

and condition2

and condition3

and condition4

and condition5

and condition6

and tselsindex(10,6)\[Z\]=1

then ret=1;

#### 📄 領先大盤創200日新高

{@type:sensor}

input:period(200,\"計算創新高區間\");

settotalBar(period\*2);

value1 = GetSymbolField(\"tse.tw\",\"收盤價\");

value2 = highest(value1,period);//大盤區間高點

value3 = barslast(close=highest(close,period));

if value1\<value2//大盤未過新高

and close=highest(close,period)//股價創新高

and value3\[1\]\>100

and
GetSymbolField(\"tse.tw\",\"收盤價\")\>average(GetSymbolField(\"tse.tw\",\"收盤價\"),10)

and average(volume,100)\>1000

then ret=1;

### 3.13 當沖交易型 (32 個)

#### 📄 一分鐘K三連紅

{@type:sensor}

if barfreq \<\> \"Min\" or Barinterval \<\>1 then
RaiseRuntimeError(\"請設定頻率為1分鐘\");

variable:BarNumberOfToday(0);

if Date \<\> Date\[1\] then

BarNumberOfToday=1

else

BarNumberOfToday+=1;{記錄今天的Bar數}

if barnumberoftoday=3 then begin

//今天第三根1分鐘K，也就是開盤第三分鐘

if trueall(close\>=close\[1\],3)

//連三根K棒都是紅棒

and volume\>average(volume\[1\],3)\*2

//成交量是過去三根量平均量的兩倍以上

and close=highd(0)

//收最高

then ret=1;

end;

#### 📄 主動性買盤大增

{@type:sensor}

input:Length(20); setinputname(1,\"調整型外盤均量計算期數\");

input:Ratio(50); setinputname(2,\"外盤量增幅度%\");

input:TXT(\"僅適用60分鐘線\"); setinputname(3,\"使用限制\");

settotalbar(3);

setbarback(Length);

if barfreq\<\> \"Min\" or barinterval \<\> 60 then return;

variable: AvgOutSideVol(0),DayOSV(0);

DayOSV = GetQuote(\"當日外盤量\");

AvgOutSideVol = averageIF( close \> close\[1\] ,volume,Length);

switch(time)

begin

case 90000:

if C\>O and DayOSV \> AvgOutSideVol \*(1+ Ratio/100) then ret=1;

case 100000:

if C\>O and DayOSV/2 \> AvgOutSideVol \*(1+ Ratio/100) then ret=1;

case 110000:

if C\>O and DayOSV/3 \> AvgOutSideVol \*(1+ Ratio/100) then ret=1;

case 120000:

if C\>O and DayOSV/4 \> AvgOutSideVol \*(1+ Ratio/100) then ret=1;

end;

#### 📄 五分鐘K狹幅整理後帶量破

{@type:sensor}

input:Length(100,\"計算期數\");

input:Ratio(0.5,\"突破幅度%\");

input:RRatio(1.5,\"盤整區間幅度%\");

input:TXT1(\"僅適用5分鐘線\",\"使用限制\");

settotalbar(3);

setbarback(Length);

if barfreq\<\> \"Min\" or barinterval \<\> 5 then return;

variable: RangeHigh(0);

variable: RangeLow(0);

RangeHigh=highest(close\[1\],length);

RangeLow=lowest(close\[1\],length);

if RangeHigh\[1\] \< RangeLow\[1\] \* (1+ RRatio/100) then begin

if Close crosses over RangeHigh\*(1+Ratio/100)

and volume\>average(volume,length)\*1.5

and trueall(GetField(\"成交量\",\"D\")\>500,10)

and countif(GetField(\"主力買賣超張數\",\"D\")\[1\]\>0,10)\>=7

and
GetSymbolField(\"tse.tw\",\"收盤價\",\"D\")\>GetSymbolField(\"tse.tw\",\"收盤價\",\"D\")\[1\]

and
GetSymbolField(\"tse.tw\",\"收盤價\",\"D\")\>average(GetSymbolField(\"tse.tw\",\"收盤價\",\"D\"),5)

then ret=1;

end;

#### 📄 五分鐘線整理後突破

{@type:sensor}

input:Length(20); setinputname(1,\"計算期數\");

input:Ratio(0.5); setinputname(2,\"突破幅度%\");

input:RRatio(1.5); setinputname(3,\"盤整區間幅度%\");

input:TXT1(\"僅適用5分鐘線\"); setinputname(4,\"使用限制\");

settotalbar(3);

setbarback(Length);

if barfreq\<\> \"Min\" or barinterval \<\> 5 then return;

variable: RangeHigh(0);

variable: RangeLow(0);

RangeHigh=highest(close\[1\],length);

RangeLow=lowest(close\[1\],length);

if Close \> RangeHigh\*(1+Ratio/100) then

if RangeHigh \< RangeLow \* (1+ RRatio/100) then ret=1;

#### 📄 即將鎖第一根漲停

{@type:sensor}

input:Length(20); setinputname(1,\"過去無漲停期數\");

input:Ratio(1); setinputname(2,\"差幾%漲停\");

input:TXT(\"請用日線逐筆洗價\"); setinputname(3,\"使用限制\");

settotalbar(Length + 3);

if BarFreq = \"D\" then

if Close \> GetField(\"漲停價\", \"D\")\*(1- Ratio/100) then

if TrueAll(close\[1\] \< Close\[2\]\*1.068,Length) then ret=1;

#### 📄 多次到頂而破

{@type:sensor}

input:HitTimes(3); setinputname(1,\"設定觸頂次數\");

input:RangeRatio(1); setinputname(2,\"設定頭部區範圍寬度%\");

input:Length(20); setinputname(3,\"計算期數\");

settotalbar(Length + 3);

variable: theHigh(0); theHigh = Highest(High\[1\],Length);
//找到過去其間的最高點

variable: HighLowerBound(0); HighLowerBound = theHigh
\*(100-RangeRatio)/100; // 設為瓶頸區間上界

variable: TouchRangeTimes(0);
//期間中進入瓶頸區間的低點次數,每跟K棒要歸0

//回算在此區間中 進去瓶頸區的次數

TouchRangeTimes = CountIF(High\[1\] \> HighLowerBound, Length);

if TouchRangeTimes \>= HitTimes and ( q_ask\> theHigh or close \>
theHigh) then ret=1;

#### 📄 斷頭後的止跌

{@type:sensor}

input:Length(4); setinputname(1,\"比較N天前融資張數\");

input:DVOL(3000); setinputname(2,\"比N天前融資減少張數\");

input:TXT1(\"僅適用日線\"); setinputname(3,\"使用限制\");

input:TXT2(\"建議使用逐筆洗價\"); setinputname(4,\"盤中使用說明\");

settotalbar(3);

setbarback(Length);

if barfreq = \"D\" and

Close \> Close\[1\] and

Close\[Length\] \> Close \* 1.1 and

GetField(\"融資餘額張數\")\[Length\] - GetField(\"融資餘額張數\")\[1\]
\> DVOL

then ret=1;

#### 📄 會打開的跌停

{@type:sensor}

settotalbar(605);

if q_ask=GetField(\"跌停價\", \"D\") and

q_bestasksize1\<1500 and

(closeD(2)-close)\>0.07\*Close

then ret=1;

#### 📄 漲停量縮不下來

{@type:sensor}

input: lastvolume1(2000); setinputname(1,\"漲停期間放量張數\");

input: lastvolume2(10000); setinputname(2,\"當日總成交量上限\");

input:TXT1(\"需使用逐筆洗價\"); setinputname(3,\"使用限制\");

settotalbar(3);

variable: UPLVol(0);

if Date \<\> Date\[1\] then UPLVol = 0;

if Close =GetField(\"漲停價\", \"D\") then

begin

UPLVol += GetField(\"Volume\", \"Tick\");

if q_BestBidSize1 \<lastvolume1 and

GetField(\"Volume\", \"D\") \>lastvolume2 and

UPLVol \> lastvolume1

then RET=1;

end;

#### 📄 火箭後拉回

{@type:sensor}

input:TXT1(\"僅適用1分鐘線\"); setinputname(1,\"使用限制\");

settotalbar(3);

if barfreq =\"Min\" and barinterval =1 and

close\[1\]/close\[2\]\>1.015 and //上個1分鐘線單分鐘拉超過1.5%

GetField(\"High\", \"D\") \> high and //高不過高

Close \< GetField(\"High\", \"D\")\*0.99 and //自高檔回1%

Close \> Low\[1\]

then ret=1;

#### 📄 當日累計量突破

{@type:sensor}

input:VolumeThre(1000); setinputname(1,\"突破量門檻\");

input:AmountThre(1000); setinputname(2,\"突破成交值金額門檻(萬)\");

settotalbar(3);

if GetField(\"Volume\", \"D\") \> VolumeThre or
GetField(\"均價\")\*GetField(\"Volume\", \"D\")/10 \> AmountThre then
ret=1;

#### 📄 當沖一號

{@type:sensor}

if barfreq \<\>\"Min\" or barinterval\<\> 1 then
raiseruntimeerror(\"歹勢，本腳本只適用於1分鐘線\");

variable:count(0);

if date\<\>date\[1\] then count=0;

count=count+1;

if GetField(\"開盤價\",\"D\")\> GetField(\"收盤價\",\"D\")\[1\]\*1.025

and count\>20

and lowest(low\[1\],count-1)\*1.015\>highest(high\[1\],count-1)

and close =highest(high,count)

then ret=1;

#### 📄 當沖二號(空)

{@type:sensor}

if barfreq \<\>\"Min\" or barinterval\<\> 1

then raiseruntimeerror(\"歹勢，本腳本只適用於1分鐘線\");

variable:count(0);

if date\<\>date\[1\] then count=0;

count=count+1;

if GetField(\"開盤價\",\"D\")\*1.025\< GetField(\"收盤價\",\"D\")\[1\]

and count\>10

and lowest(low\[1\],count-1)\*1.015\>highest(high\[1\],count-1)

and close =lowest(low,count)

then ret=1;

#### 📄 盤中突破區間

{@type:sensor}

input: timeline(100000); setinputname(1,\"時間切算點\");

input:TXT1(\"限用分鐘線\"); setinputname(2,\"使用限制\");

input:TXT2(\"高點自開盤起算\"); setinputname(3,\"使用說明\");

settotalbar(3);

if barfreq\<\> \"Min\" then return;

variable:RangeHigh(0);

if date \<\> date\[1\] then RangeHigh = 0;

if Time \< timeline then RangeHigh = maxlist(RangeHigh,high)

else if time \>= timeline and RangeHigh \> 0 and Close \>
RangeHigh\*1.005 then ret=1 ;

#### 📄 突破波動範圍

{@type:sensor}

input:Length(20); setinputname(1,\"高低計算期數\");

settotalbar(3);

setbarback(Length);

variable:HighLow(0);

HighLow=high-low;

if C\>highest(H\[1\],Length) \*1.005 and
HighLow\>highest(HighLow\[1\],Length) then ret=1;

#### 📄 賣壓很輕

{@type:sensor}

input:rate(20);setinputname(1,\"當日內盤量佔總成交比例%\");

settotalbar(8);

if {內盤量}GetField(\"內盤量\", \"D\") \< GetField(\"Volume\",
\"D\")\*(Rate/100) and Countif(close\< close\[1\],5) \< 3

then ret=1;

#### 📄 跌停一直在成交

{@type:sensor}

input: lastvolume1(2000); setinputname(1,\"跌停期間放量張數\");

input: lastvolume2(10000); setinputname(2,\"當日總成交量上限\");

input:TXT1(\"需使用逐筆洗價\"); setinputname(3,\"使用限制\");

settotalbar(3);

variable: DNLVol(0);

if Date \<\> Date\[1\] then DNLVol = 0;

if Close = GetField(\"跌停價\", \"D\") then

begin

DNLVol += GetField(\"Volume\", \"Tick\");

if q_BestAskSize1 \<lastvolume1 and

GetField(\"Volume\", \"D\") \>lastvolume2 and

DNLVol \> lastvolume1

then RET=1;

end;

#### 📄 近期持續強勢股階梯式上漲

{@type:sensor}

if barfreq\<\> \"Min\"and barinterval\<\> 5 then
raiseruntimeerror(\"本腳本只限五分鐘線\");

condition1 = GetSymbolField(\"tse.tw\",\"收盤價\",\"D\") \>
average(GetSymbolField(\"tse.tw\",\"收盤價\",\"D\"),10);

//多頭市場

condition2 = GetSymbolField(\"tse.tw\",\"收盤價\",\"D\") /
GetSymbolField(\"tse.tw\",\"收盤價\",\"D\")\[2\]+0.01

\< GetField(\"收盤價\",\"D\")/GetField(\"收盤價\",\"D\")\[2\];

//前兩日比大盤明顯走強

condition3 = GetField(\"收盤價\",\"D\")\[1\]
\<GetField(\"收盤價\",\"D\")\[10\]\*1.07;

//近十日沒有漲的太兇

condition4 = Average(GetField(\"Volume\", \"D\")\[1\], 100) \>= 1000;

if condition1 and condition2 and condition3 and condition4 then begin

if time=091500

and trueall(close\>close\[1\],3)

//開盤三根五分鐘線都是紅棒

and average(volume,3)\>average(volume,20)\*1.3

//開盤的量能明顯增加

and GetField(\"收盤價\",\"D\")\[1\]\<GetField(\"收盤價\",\"D\")\[2\]

then ret=1;

end;

#### 📄 連續五分鐘一路走高

{@type:sensor}

input:TXT1(\"僅適用1分鐘線\"); setinputname(1,\"使用限制\");

settotalbar(8);

if barfreq = \"Min\" and barinterval = 1 and

TrueAll(close \>Close\[1\] ,5) then ret=1;

#### 📄 開低不反彈再創新低

{@type:sensor}

if barfreq \<\>\"Min\" or barinterval\<\> 1 then
raiseruntimeerror(\"本腳本只適用於1分鐘線\");

variable:count(0);

if date\<\>date\[1\] then count=0;

count=count+1;

if GetField(\"開盤價\",\"D\")\*1.025\< GetField(\"收盤價\",\"D\")\[1\]

and count\>10

and lowest(low\[1\],count-1)\*1.015\>highest(high\[1\],count-1)

and close =lowest(low,count)

then ret=1;

#### 📄 開大跌後未再探底

{@type:sensor}

input:ratio(4); setinputname(1,\"開低幅度%\");

input:ratio1(0.5); setinputname(2,\"開低後回升幅度%\");

settotalbar(3);

if GetField(\"Open\", \"D\") \< GetField(\"RefPrice\", \"D\") \* (1
-Ratio/100) and

GetField(\"Open\", \"D\") \>= GetField(\"Low\", \"D\") and

(GetField(\"Open\", \"D\")- GetField(\"Low\", \"D\"))\< Close \* Ratio1
and

Close \> GetField(\"Open\", \"D\") \* (1 + Ratio1/100)

then ret=1;

#### 📄 開盤三連陽

{@type:sensor}

input:TXT(\"僅適用60分鐘線以內\"); setinputname(1,\"使用限制\");

settotalbar(5);

if barfreq = \"Min\" and barinterval \<= 60 and

(time\[2\] = 84500 or time\[2\] = 90000) and

Close \> Close\[1\] and Close\[1\] \> Close\[2\] and

Close\[2\] \> Open\[2\]

then ret=1;

#### 📄 開盤五分鐘K線三連陽

{@type:sensor}

input:TXT1(\"僅適用5分鐘線\"); setinputname(1,\"使用限制\");

input:TXT2(\"開盤前3根K棒\"); setinputname(2,\"使用說明:判斷規則\");

settotalbar(5);

if barfreq\<\> \"Min\" or barinterval \<\> 5 then return;

variable:KBarOfDay(0); KBarOfDay+=1; if date\<\>date\[1\] then
KBarOfDay=1;

if Date = CurrentDate and

(time\[2\] = 90000 or time\[2\] = 84500) and

KBarOfDay = 3 and

Close\[2\] \> Open\[2\] and

TrueAll(Close \> Open and Close \> Close\[1\] ,2) then Ret=1;

#### 📄 開盤五分鐘三創新高

{@type:sensor}

input: volumeRatio(0.1, \"分鐘量暴量比例\");

input: changeRatio(3, \"最近3日最大上漲幅度\");

input: averageVolume(1000, \"5日均量\");

variable:KBarOfDay(0), BreakHigh(false);

KBarOfDay+=1;

if date\<\>date\[1\] then begin

KBarOfDay=1;

BreakHigh = false;

end;

condition1 = KBarOfDay = 6;

//一分鐘線每天的第六根

condition2 = Countif(High \> High\[1\] and Close \> Close\[1\] ,5) \>=3;

//近五根裡至少三根最高價比前一根高且收盤比前一根高

if KBarOfDay = 1

and close \> getfield(\"close\", \"d\")\[1\]

then BreakHigh = true;

//開高

value1 = average(GetField(\"Volume\", \"D\")\[1\], 5);

//五日均量

condition3 = value1 \> averageVolume;

//五日均量大於某張數

value2 = rateofchange(GetField(\"Close\", \"D\")\[1\], 3);

condition4 = AbsValue(value2) \< changeRatio;

//前三日漲帳幅小於一定標準

condition5 = summation(volume, 5) \> value1 \* volumeRatio;

//前五根一分鐘線成交量的合計大於五日均量某個比例

condition6 =
GetSymbolField(\"TSE.TW\",\"收盤價\",\"D\")\>average(GetSymbolField(\"TSE.TW\",\"收盤價\",\"D\"),10);

//大盤屬於多頭結構

if condition1 and condition2 and condition3

and Condition4 and Condition5 and condition6

and BreakHigh

then ret=1;

#### 📄 開盤五分鐘創三新低

{@type:sensor}

input:TXT(\"僅適用1分鐘線\"); setinputname(1,\"使用限制\");

settotalbar(8);

variable:KBarOfDay(0); KBarOfDay+=1; if date\<\>date\[1\] then
KBarOfDay=1;

if barfreq = \"Min\" and barinterval = 1 and Date = CurrentDate and

KBarOfDay = 6 and

Countif(Low \< Low\[1\] and Close \< Close\[1\] ,5) \>=3 then Ret=1;

#### 📄 開盤五分鐘創三新高

{@type:sensor}

input:TXT(\"僅適用1分鐘線\"); setinputname(1,\"使用限制\");

settotalbar(8);

variable:KBarOfDay(0); KBarOfDay+=1; if date\<\>date\[1\] then
KBarOfDay=1;

if barfreq\<\> \"Min\" and barinterval = 1 and Date = CurrentDate and

KBarOfDay = 6 and

Countif(High \> High\[1\] and Close \> Close\[1\] ,5) \>=3 then Ret=1;

#### 📄 開盤反轉買進訊號

{@type:sensor}

variable: \_BarIndex(0), \_Open(0), \_Low(0), \_High(0), \_Volume(0);

if getsymbolfield(\"tse.tw\",\"收盤價\") \>
average(getsymbolfield(\"tse.tw\",\"收盤價\"),10) then begin

if Date \<\> Date\[1\] then begin

\_BarIndex = 1;

\_Open = Open;

\_Low = Low;

\_High = High;

\_Volume = Volume;

end else begin

\_Low = minlist(\_Low, Low);

\_High = maxlist(\_High, High);

\_Volume = \_Volume + Volume;

\_BarIndex = \_BarIndex + 1;

end;

Condition1 = GetField(\"Open\", \"D\") \< GetField(\"Close\",
\"D\")\[1\];

//開低

Condition2 = Close \> \_Low \* 1.02 and
close\>GetField(\"收盤價\",\"D\")\[1\];

//收盤比當天低點收高2%且突破前一日高點

Condition3 = Close\*1.2 \< GetField(\"Close\", \"D\")\[20\]

//近二十日跌幅超過兩成

and close\*1.07\<getfield(\"close\",\"D\")\[10\];

//近十日跌幅超過7%

Condition4 = Time \< 93000;

//時間在九點半之前

Condition5 = Average(GetField(\"Volume\", \"D\")\[1\], 5) \>= 1000;

//五日均量大於1000張

Condition6 = \_Volume \> GetField(\"Volume\", \"D\")\[1\] \* 0.2;

//今日迄今的量大於過去五日均量的兩成

if Condition1 And Condition2 And Condition3 And Condition4 And
Condition5 And Condition6

then ret = 1;

end;

#### 📄 開盤委買暴增

{@type:sensor}

input:iVOL(1000); setinputname(1,\"開盤委買賣差張\");

input:Ratio(10); setinputname(2,\"開盤委買力道比\");

input:TXT1(\"適用1分鐘\"); setinputname(3,\"使用限制\");

input:TXT2(\"僅開盤第1分鐘洗價\"); setinputname(4,\"使用說明\");

settotalbar(300);

if barfreq =\"Min\" and barinterval =1 and Date= Currentdate and

Time =90000 and GetQuote(\"總委買\") - GetQuote(\"總委賣\") \>iVOL and

GetQuote(\"總委買\") / summation(volume\[1\],270) \> Ratio

then ret=1;

#### 📄 開盤暴量

{@type:sensor}

input:Vtimes(3); setinputname(1,\"爆量倍數\");

input:atVolume(100); setinputname(2,\"暴量門檻張數\");

input:TXT1(\"僅適用1分鐘\"); setinputname(3,\"使用限制\");

input:TXT2(\"盤中可用\"); setinputname(4,\"使用說明:建議日內單次觸發\");

settotalbar(300);

if barfreq \<\> \"Min\" or Barinterval \<\> 1 then return;

variable: OpenVolume(0), OpenVolumeDate(0);

if CurrentBar = 1 then

begin

// 找到當日第一筆分鐘K線的成交量

//

variable: idx(0);

idx = 0;

while date\[idx\] = date

begin

OpenVolume = Volume\[idx\];

OpenVolumeDate = date\[idx\];

idx = idx + 1;

end;

end

else

if Date \<\> OpenVolumeDate then

begin

// 開盤量為換日後的第一筆分鐘K線的成交量

OpenVolumeDate = Date;

OpenVolume = Volume;

end;

if CurrentDate = OpenVolumeDate And

OpenVolume \> AtVolume And

OpenVolume \> GetQuote(\"昨量\")/270 \* Vtimes then ret=1;

#### 📄 開高不拉回後再創新高

{@type:sensor}

if barfreq \<\>\"Min\" or barinterval\<\> 1 then
raiseruntimeerror(\"歹勢，本腳本只適用於1分鐘線\");

variable:count(0);

if date\<\>date\[1\] then count=0;

count=count+1;

if GetField(\"開盤價\",\"D\")\> GetField(\"收盤價\",\"D\")\[1\]\*1.025

and count\>5

and lowest(low\[1\],count-1)\*1.015\>highest(high\[1\],count-1)

and close =highest(high,count)

then ret=1;

#### 📄 開高後不拉回

{@type:sensor}

input:Ratio(2.5); setinputname(1,\"開高幅度%\");

input:aRatio(1); setinputname(2,\"拉回度%上限\");

input:TXT(\"僅適用於15分鐘以內\"); setinputname(3,\"使用限制\");

settotalbar(3);

if barfreq =\"Min\" and barinterval \<=15 and time \<= 091500 and

GetField(\"Open\", \"D\") \> GetField(\"RefPrice\", \"D\")
\*(1+Ratio/100) and

Close \> GetField(\"High\", \"D\")\* (1- aRatio/100)

then ret=1;

#### 📄 階梯式上漲

{@type:sensor}

input:TXT1(\"僅適用1分鐘線\"); setinputname(1,\"使用限制\");

input:TXT2(\"只於9:10判斷\"); setinputname(2,\"使用說明\");

settotalbar(12);

if barfreq = \"Min\" and barinterval = 1 and time =91000 and

TrueAll(close \>Close\[1\] ,10) then ret=1;

### 3.14 盤中常用 (5 個)

#### 📄 1分鐘K開盤暴量三連陽

{@type:sensor}

if barfreq \<\> \"Min\" or Barinterval \<\>1 then
RaiseRuntimeError(\"請設定頻率為1分鐘\");

variable:BarNumberOfToday(0);

if Date \<\> Date\[1\] then

BarNumberOfToday=1

else

BarNumberOfToday+=1;{記錄今天的Bar數}

if barnumberoftoday=3 then begin

//今天第三根1分鐘K，也就是開盤第三分鐘

if trueall(close\>=close\[1\],3)

//連三根K棒都是紅棒

and volume\>average(volume\[1\],3)\*2

//成交量是過去三根量平均量的兩倍以上

and close=highd(0)

//收最高

then ret=1;

end;

#### 📄 大單敲進

{@type:sensor}

input: atVolume(50,\"大單門檻\");

input: LaTime(10,\"大單筆數\");

input: TXT(\"須逐筆洗價\",\"使用限制\");

settotalbar(3);

variable: intrabarpersist Xtime(0);

//計數器

variable: intrabarpersist Volumestamp(0);

Volumestamp =GetField(\"Volume\", \"D\");

if time \< time\[1\]

or Volumestamp = Volumestamp\[1\]

then Xtime =0; //開盤那根要歸0次數

if GetField(\"Volume\", \"Tick\") \> atVolume

//單筆tick成交量超過大單門檻

and GetField(\"內外盤\",\"Tick\")=1

//外盤成交

then Xtime+=1;

//量夠大就加1次

if Xtime \> LaTime then begin

ret=1;

Xtime=0;

end;

#### 📄 盤中委買遠大於委賣

{@type:sensor}

input:v1(2000,\"委買五檔總金額(萬)\");

input:v2(500,\"委賣五檔總金額(萬)\");

input:v3(1500,\"委買委賣總差額(萬)\");

input:v4(400,\"單一價位委買金額下限\");

input:v5(100,\"單一價位委賣金額上限\");

variable:bidtv(0),asktv(0),tb(0),ta(0),b1(0),b2(0),b3(0),b4(0),b5(0),s1(0),s2(0),s3(0),s4(0),s5(0);

condition1=false;

condition2=false;

condition3=false;

bidtv=q_SumBidSize;//總委買

asktv=q_SumAskSize;//總委賣

value1=q_BestBidSize1;//委買一

value2=q_BestBidSize2;

value3=q_bestbidsize3;

value4=q_bestbidsize4;

value5=q_bestbidsize5;

value6=q_bestasksize1;//委賣一

value7=q_bestasksize2;

value8=q_bestasksize3;

value9=q_bestasksize4;

value10=q_bestasksize5;

tb=bidtv\*close/10;

ta=asktv\*close/10;

if tb\>v1 and ta\<v2 and tb-ta\>v3

then condition1=true;

b1=value1\*close/10;

b2=value2\*close/10;

b3=value3\*close/10;

b4=value4\*close/10;

b5=value5\*close/10;

s1=value6\*close/10;

s2=value7\*close/10;

s3=value8\*close/10;

s4=value9\*close/10;

s5=value10\*close/10;

if minlist(b1,b2,b3,b4,b5)\>v4

then condition2=true;

if maxlist(s1,s2,s3,s4,s5)\<v5

then condition3=true;

if close\<\>GetField(\"漲停價\", \"D\") then begin

if condition1

or (condition2 and condition3)

then ret=1;

end;

#### 📄 開盤跳空上漲N%且有量

{@type:sensor}

if open \>=close\[1\]\*1.03

and volume\*close\>300000

then ret=1;

#### 📄 預估量破均量

{@type:sensor}

value1=GetField(\"內盤量\", \"D\");//當日內盤量

value2=GetField(\"外盤量\", \"D\");//當日外盤量

if GetField(\"估計量\") \> average(volume\[1\],10)\*1.3

and value2\>value1

then ret=1;

### 3.15 短線操作型 (23 個)

#### 📄 一小時線長期盤整後突破

{@type:sensor}

//盤整後噴出

input: Periods(20); setinputname(1,\"計算期數\");

input: Ratio(3);setinputname(2,\"近期波動幅度%\");

input: Direction(1);setinputname(3,\"方向:1突破 -1跌破\");

input: TXT1(\"僅適用60分鐘\"); setinputname(4,\"使用限制\");

settotalbar(3);

setbarback(Periods);

condition1 = false;

if (highest(high\[1\],Periods-1) -
lowest(low\[1\],Periods-1))/close\[1\] \<= ratio\*0.01

then condition1=true//近期波動在?%以內

else return;

if condition1 and Direction \> 0 and high = highest(high, Periods)

then ret=1;//盤整後往上突破

if condition1 and Direction \< 0 and low = lowest(low, Periods)

then ret=1;//盤整後往下跌破

#### 📄 一黑破三紅

{@type:sensor}

input:periods(20);setinputname(1,\"計算期數(最小為5)\");

input:ratio(20);setinputname(2,\"累計漲幅%\");

settotalbar(5);

setbarback(Periods);

variable:x(0);

if periods \< 5 then return;

condition1=false;

condition2=false;

condition3=false;

if (high\[1\] - low\[periods-1\])/low\[periods-1\] \>= ratio\*0.01

then condition1=true//近n日漲幅超過?%

else return;

if high\>highest(high\[1\],3) and c\<lowest(low\[1\],3)

then condition2=true//開盤是四日來新高但收盤比三日前低點低

else return;

//前二天每天比前一天上漲且連續三天收紅棒

condition3 = TrueAll(c\[1\]\>c\[2\], 2) and

TrueAll(open\[1\]\<close\[1\], 3);

if condition1 and condition2 and condition3

then ret=1;

#### 📄 三根長下影線

{@type:sensor}

input: Percent(1.5); setinputname(1,\"下影線佔股價絕對百分比\");

settotalbar(5);

condition1 = (minlist(open,close)-low) \> absvalue(open-close)\*3;

condition2 = minlist(open,close) \> low \* (100 + Percent)/100;

if trueall( condition1 and condition2, 3) then ret=1;

#### 📄 中小型股整理結束

{@type:sensor}

input: Periods(20); setinputname(1,\"計算期數\");

input: Ratio(3);setinputname(2,\"近期波動幅度%\");

settotalbar(300);

setbarback(50);

condition1 = false;

if (highest(high\[1\],Periods-1) - lowest(low\[1\],Periods-1)) \<=
ratio\*0.01\*close\[1\]

then condition1=true//近期波動在?%以內

else return;

if condition1

and high = highest(high, Periods)

and
GetSymbolField(\"tse.tw\",\"收盤價\")\>average(GetSymbolField(\"tse.tw\",\"收盤價\"),10)

and
average(GetSymbolField(\"tse.tw\",\"收盤價\"),5)\>average(GetSymbolField(\"tse.tw\",\"收盤價\"),20)

then ret=1;//盤整後往上突破

#### 📄 主力慢慢收集籌碼後攻堅

{@type:sensor}

input:period(10,\"籌碼計算天期\");

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

Value1=GetField(\"分公司買進家數\",\"D\")\[Z\];

value2=GetField(\"分公司賣出家數\",\"D\")\[Z\];

value3=(value2-value1);

//賣出的家數比買進家數多的部份

value4=average(close,5);

//五日移動平均

if countif(value3\>30, period)/period \>0.7

and linearregslope(value4,5)\>0

and Average(Volume\[1\], 100) \>= 500

and tselsindex(10,7)\[Z\]=1

then ret=1;

#### 📄 加速趕底中

{@type:sensor}

settotalbar(210);

if Close\[4\] \> Close \*1.07 and

TrueAll (truerange/Close \> 0.02,3) and

Close \< Highest(high,200) \*0.7

then Ret=1;

{自高檔回跌三成且近5期收低7%以上,近3期每期波動至少有2%}

#### 📄 外資買超但只開平高盤

{@type:sensor}

input: Atleast(1000); setinputname(1,\"外資買超張數\");

input: Gap(2); setinputname(2,\"平盤幅度%\");

input:TXT1(\"僅適用日線\"); setinputname(3,\"使用限制\");

input:TXT2(\"需逐筆洗價\"); setinputname(4,\"使用說明:選日內單次觸發\");

settotalbar(3);

if BarFreq = \"D\" and Getfield(\"外資買賣超\")\[1\] \> Atleast and

GetField(\"Open\", \"D\") \< GetField(\"RefPrice\", \"D\") \*(1+Gap/100)
and

GetField(\"Open\", \"D\") \> GetField(\"RefPrice\", \"D\")

then ret=1;

#### 📄 外資連日大買超，股價未開高

{@type:sensor}

input:Periods(3); setinputname(1,\"外資連續買超天數\");

input:Atleast(10000); setinputname(2,\"每日買超金額(萬元)\");

input:Gap(1); setinputname(3,\"開盤幅度%\");

input:TXT1(\"僅適用日線\"); setinputname(4,\"使用限制\");

input:TXT2(\"需逐筆洗價\"); setinputname(5,\"使用說明:選日內單次觸發\");

settotalbar(3);

setbarback(Periods);

if BarFreq = \"D\" and

Trueall( Getfield(\"外資買賣超\")\[1\]\*Close\*0.1 \> Atleast ,Periods)
and

GetField(\"Open\", \"D\") \< GetField(\"RefPrice\", \"D\") \*(1+Gap/100)

then ret=1;

#### 📄 外資連續買超n天

{@type:sensor}

input:Periods(5); setinputname(1,\"外資連續買超天數\");

input:TXT1(\"僅適用日線\"); setinputname(2,\"使用限制\");

settotalbar(3);

setbarback(Periods);

if BarFreq \<\> \"D\" then return;

Ret = TrueAll(GetField(\"外資買賣超\")\[1\] \> 0, Periods);

#### 📄 投信初介入

{@type:sensor}

input: day(30, \"投信交易期間\");

if GetSymbolField(\"TSE.TW\",\"收盤價\") \>
average(GetSymbolField(\"TSE.TW\",\"收盤價\"),10)

and Average(Volume\[1\], 100) \>= 1000

then begin

value1 = summation(GetField(\"投信買賣超\")\[1\], day);

value2 = summation(volume\[2\], day);

condition1 = value1 \< value2 \* 0.02;

//先前投信不怎麼買這檔股票

if getfielddate(\"投信買賣超\") \<\> date then

value99 = GetField(\"投信買賣超\")\[1\]

else

value99 = GetField(\"投信買賣超\");

condition2 = value99\>= volume\[1\] \* 0.15;

//投信開始較大買超

condition3 = H \> H\[1\];

//買了股價有往上攻

condition4 = C \> C\[1\];

//今天收盤有往上走

condition5=close\<close\[10\]\*1.05;

condition6=GetSymbolField(\"TSE.TW\",\"收盤價\") \>
average(GetSymbolField(\"TSE.TW\",\"收盤價\"),10);

if condition1

and condition2

and condition3

and condition4

and condition5

and condition6

then ret=1;

end;

#### 📄 投信外資同步進場

{@type:sensor}

input:Fboughts(100); setinputname(1,\"外資買超張數\");

input:Sboughts(100); setinputname(2,\"投信買超張數\");

input:TXT1(\"僅適用日線\"); setinputname(3,\"使用限制\");

settotalbar(3);

if BarFreq \<\> \"D\" then return;

if GetField(\"外資買賣超\")\[1\]\>Fboughts and
GetField(\"投信買賣超\")\[1\]\>Sboughts

then ret=1;

#### 📄 投信搶買的股票

{@type:sensor}

input: miniratio(10); setinputname(1,\"投信買進佔今日總量%\");

input: lv(2000); setinputname(2,\"投信持股張數上限\");

input: holdratio(10); setinputname(3,\"投信持股比例上限%\");

input:TXT1(\"僅適用日線\"); setinputname(4,\"使用限制\");

input:TXT2(\"需選用逐筆洗價\"); setinputname(5,\"使用說明\");

settotalbar(3);

if BarFreq \<\> \"D\" then return;

//1.中小型股

//2.原來庫存低

//3.今天買進張數超過成交量的一成

//4.收今天最高

value1=GetField(\"Stotalbuy\")\[1\];//投信買張

value2=GetField(\"Ssharesheld\")\[1\];//投信持股

value3=GetField(\"Ssharesheldratio\")\[1\];//投信持股比例

if close \> high\[1\] and close\[1\]=high\[1\] and //昨天收高 今日再漲

value1 \> volume\[1\] \* miniratio\*0.01 and
//昨日買進張數超過成交量的一成

value2 \< lv and //原來庫存低

value3 \< holdratio //原來庫存低

then ret=1;

#### 📄 投信殺完之跌深反彈

{@type:sensor}

input:day(5); setinputname(1,\"投信連續賣超天數\");

input:ratio(60);setinputname(2,\"合計賣超減持幅度%\");

input:TXT1(\"僅適用日線\"); setinputname(3,\"使用限制\");

input:TXT2(\"須逐筆洗價\"); setinputname(4,\"使用說明\");

settotalbar(day + 3);

if close\>open and close\[3\] \> close\[1\] \* 1.1 and BarFreq =\"D\"
then

begin

if TrueAll(GetField(\"Sdifference\")\[1\] \<0,day) and

GetField(\"Ssharesheld\")\[1\] \< GetField(\"Ssharesheld\")\[Day+1\] \*
(1- Ratio/100)

then ret=1;

end;

#### 📄 投信買張超過成交量一成

{@type:sensor}

input: Ratio(10); setinputname(1,\"投信持股%\");

input: Gap(2.5); setinputname(2,\"開盤不漲過幅度%\");

input:TXT1(\"僅適用日線\"); setinputname(3,\"使用限制\");

input:TXT2(\"須逐筆洗價\"); setinputname(4,\"使用說明\");

settotalbar(3);

if BarFreq \<\> \"D\" or currenttime \> 90500 then return;

value1=GetField(\"Stotalbuy\")\[1\];//投信買張

value2=GetField(\"Ssharesheldratio\")\[1\];//投信持股比例

if value2\<Ratio and value1/volume\[1\]\>0.1 and close \< close\[1\]
\*(1 + Gap \* 0.01)

then ret=1;

#### 📄 投信連日大買超，股價未開高

{@type:sensor}

input:Periods(3); setinputname(1,\"投信連續買超天數\");

input:Atleast(10000); setinputname(2,\"每日買超金額(萬元)\");

input:Gap(1); setinputname(3,\"開盤幅度%\");

input:TXT1(\"僅適用日線\"); setinputname(4,\"使用限制\");

input:TXT2(\"需逐筆洗價\"); setinputname(5,\"使用說明:選日內單次觸發\");

settotalbar(Periods + 3);

if BarFreq = \"D\" and

Trueall( Getfield(\"投信買賣超\")\[1\]\*Close\*0.1 \> Atleast ,Periods)
and

GetField(\"Open\", \"D\") \< GetField(\"RefPrice\", \"D\") \*(1+Gap/100)

then ret=1;

#### 📄 漲勢加速的股票

{@type:sensor}

input:day2(5,\"近期\");

input:day1(10,\"中期\");

if angle(date\[day1\],date\[day2\])\>0

and angle(date\[day2\],date)\>angle(date\[day1\],date\[day2\])

and angle(date\[day2\],date)\>25

and GetSymbolField(\"tse.tw\",\"收盤價\",\"W\")

\>average(GetSymbolField(\"tse.tw\",\"收盤價\",\"W\"),13)

then ret=1;

#### 📄 炒高後沒有量

{@type:sensor}

input: Periods(120); setinputname(1,\"計算期數\");

input: Ratio(50);setinputname(2,\"期間漲幅%\");

input: Sizes(2000);setinputname(3,\"五日均量量縮張數\");

input:TXT1(\"僅適用日線\"); setinputname(4,\"使用限制\");

input:TXT2(\"需選用逐筆洗價\"); setinputname(5,\"使用說明\");

settotalbar(3);

setbarback(Periods);

if BarFreq = \"D\" and currenttime\>130000 and

getfield(\"融資餘額張數\")\[1\] \> 2000 and //昨日融資餘額多於2000張

getfield(\"融券餘額張數\")\[1\] \< 2000 and //昨日融券餘額少於2000張

close \>= close\[Periods\] \*(1 + Ratio\*0.01) and
//過去半年漲幅超過五成

average(volume\[1\],5) \< Sizes and //五日均量低於N張

GetQuote(\"DailyVolume\")\< 500 and //當日總量

GetQuote(\"OutSize\") \< GetQuote(\"DailyVolume\")\*0.5
//當日外盤量小於總量一半

then ret=1;

#### 📄 短線轉強

{@type:sensor}

input:day(66,\"移動平均天數\");

input:ratio(30,\"超出均值比率\");

variable:count(0);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if currenttime \> 180000

or currenttime \< 083000 then

Z =0

else

Z=1;

value1=GetField(\"法人買張\")\[Z\]; value2=average(value1,day);

value3=GetField(\"強弱指標\")\[Z\]; value4=average(value3,day);

value5=GetField(\"外盤均量\")\[Z\]; value6=average(value5,day);

value7=GetField(\"主動買力\")\[Z\]; value8=average(value7,day);

value9=GetField(\"開盤委買\"); value10=average(value9,day);

count=0;

if value1\>=value2\*(1+ratio/100) then count=count+1;

if value3\>=value4\*(1+ratio/100) then count=count+1;

if value5\>=value6\*(1+ratio/100) then count=count+1;

if value7\>=value8\*(1+ratio/100) then count=count+1;

if value9\>=value10\*(1+ratio/100) then count=count+1;

if count\>=4 and close\<lowest(close,day)\*1.1

and
GetSymbolField(\"tse.tw\",\"收盤價\",\"D\")\>average(GetSymbolField(\"tse.tw\",\"收盤價\",\"D\"),10)

and average(volume,200)\>2000

then ret=1;

#### 📄 突破繼續型態

{@type:sensor}

input:Length(20); setinputname(1,\"下降趨勢計算期數\");

input:Rate(150); setinputname(2,\"反轉率%\");

variable: Factor(0);

settotalbar(Length + 3);

Factor = 100/Close\[Length\];

if close \> open and close \< close\[length\] then

begin

value1 = linearregslope(high\*Factor,Length);

value2 = linearregslope(high\*Factor,3);

if value1 \< 0 and value2-value1 \> Rate\*0.01 then ret=1;

end;

#### 📄 站上五根bar高點

{@type:sensor}

settotalbar(5);

if close \> highest(High\[1\],4)

then ret=1;

#### 📄 第一根漲停

{@type:sensor}

input: Periods(5); setinputname(1,\"N天內第一根漲停\");

input: Size(1500); setinputname(2,\"漲停委賣張數\");

settotalbar(Periods + 3);

if Periods \< 1 then return;

if q_ask=GetField(\"漲停價\", \"D\") and q_bestasksize1\<Size then

begin

for value1 = 1 to Periods

begin

if closeD(value1-1) \> closeD(value1) \* 1.065 then return;

end;

ret=1;

end;

#### 📄 籌碼由發散轉收集

{@type:sensor}

input: Length_D(9, \"日KD期間\");

input: Length_W(5, \"周KD期間\");

variable:rsv_d(0),kk_d(0),dd_d(0);

variable:rsv_w(0),kk_w(0),dd_w(0);

SetTotalBar(maxlist(Length_D,6) \* 3);

//透過Z的時間安排來決定現在用的是那一根Bar的資料

variable: Z(0);

if GetFieldDate(\"主力買賣超張數\") \<\> 0 then

Z=0

else

Z=1;

condition1=false;

value1=GetField(\"現股當沖張數\",\"D\")\[Z\];

value2=GetField(\"外資買賣超\",\"D\")\[Z\];

value3=GetField(\"投信買賣超\",\"D\")\[Z\];

value4=GetField(\"自營商買賣超\",\"D\")\[Z\];

value5=GetField(\"主力買賣超張數\",\"D\")\[Z\];

value6=GetField(\"融資增減張數\",\"D\")\[Z\];

value7=GetField(\"融券增減張數\",\"D\")\[Z\];

value8=volume-value1;//當日淨交易張數

value9=value2+value3+value4+value5-value6+value7;

//籌碼收集張數

if TSELSindex(10,5)\[Z\]=1 then begin

if value8\<\>0 then

value10=value9/value8\*100

else

value10=value10\[1\];

value11=average(value10,10);

if value11 crosses over 10 then condition1=true;

stochastic(Length_D, 3, 3, rsv_d, kk_d, dd_d);

xf_stochastic(\"W\", Length_W, 3, 3, rsv_w, kk_w, dd_w);

condition2 = kk_d crosses above dd_d; // 日KD crosses over

condition3 = xf_GetBoolean(\"W\",xf_crossover(\"W\", kk_w, dd_w),1); //
周KD crosses over

condition4 = kk_d\[1\] \<= 30; // 日K 低檔

condition5 = xf_getvalue(\"W\", kk_w, 1) \<= 50; // 周K 低檔

if condition1 and condition2 and condition3 and condition4 and
condition5

then ret = 1;

end;

#### 📄 除權前的逆襲

{@type:sensor}

input:Ratio(5); setinputname(1,\"逆襲上漲幅度%\");

input:TXT1(\"僅適用日線\"); setinputname(2,\"使用限制\");

input:TXT2(\"需選用逐筆洗價\"); setinputname(3,\"使用說明\");

settotalbar(5);

if BarFreq = \"D\" and Close \> Close\[2\] \*(1+Ratio/100) and

Close \> Close\[1\] and Close\[1\] \> Close\[2\]

then

begin

if GetField(\"融券餘額張數\")\[1\] = 0 and
GetField(\"融券餘額張數\")\[2\] = 0 and

GetField(\"融資餘額張數\")\[1\] \>0 {推測是除權前停券} then ret=1;

end;

### 3.16 酒田戰法 (30 個)

#### 📄 三長下影線

{@type:sensor}

input: Percent(1.5); setinputname(1,\"下影線佔股價絕對百分比\");

settotalbar(5);

condition1 = (minlist(open,close)-Low) \> absvalue(open-close)\*3;

condition2 = minlist(open, close) \> low\* (100 + Percent)/100;

if trueall( condition1 and condition2, 3) then ret=1;

#### 📄 三黑鴨

{@type:sensor}

{

\[檔名:\] 三黑鴨 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 連三黑K棒

}

settotalbar(5);

{判斷狀況}

condition1= ( open - close ) \> (high -low) \* 0.75 ;//狀況1: 當期黑K棒

condition2= ( open\[1\] - close\[1\] ) \> (high\[1\] -low\[1\]) \* 0.75
;//狀況2: 前期黑K棒

condition3= ( open\[2\] - close\[2\] ) \> (high\[2\] -low\[2\]) \* 0.75
;//狀況3: 前前期黑K棒

condition4= close \< close\[1\] and close\[1\] \< close\[2\] ;//狀況4:
連續下跌

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 倒狀鎚子

{@type:sensor}

{

\[檔名:\] 倒狀鎚子 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 前期收長黑K棒 今期開低試圖上攻後收上影線短紅棒

}

settotalbar(5);

{判斷狀況}

condition1= ( open\[1\] - close\[1\] ) \>(high\[1\] -low\[1\]) \* 0.75
;//狀況1: 前期出長黑K棒

condition2= close\[1\] \< close\[2\] - (high\[2\]-low\[2\]) ;//狀況2:
前期呈波動放大下跌

condition3= close \> open and (high -close)\> (close-open) \*2 ;//狀況3:
收紅上影線

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

#### 📄 內困三日翻紅

{@type:sensor}

{

\[檔名:\] 內困三日翻紅 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 黑K棒後內包前期短紅棒 當期再以紅棒突破黑棒開盤價

}

settotalbar(5);

{判斷狀況}

condition1= ( open\[2\] - close\[2\] ) \>(high\[2\] -low\[2\]) \* 0.75
;//狀況1: 實體下跌K棒

condition2= ( close\[1\] - open\[1\] ) \>(high\[1\] -low\[1\]) \* 0.75
;//狀況2: 實體上漲K棒

condition3= high\[1\] \< high\[2\] and low\[1\] \> low\[2\] ;//狀況3:
前期內包於前前期

condition4= ( close - open ) \> 0.75 \*(high -low) ;//狀況4:
當期實體上漲K棒

condition5= close \> open\[2\] ;//狀況5: 現價突破前前期開盤價

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

and condition5

THEN RET=1;

#### 📄 內困三日翻黑

{@type:sensor}

{

\[檔名:\] 內困三日翻黑 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 前兩期為長紅棒後包黑K棒 當期往下跌破紅棒開盤價

}

settotalbar(5);

{判斷狀況}

condition1= close\[2\] \> open\[2\] + high\[3\]-low\[3\] ;//狀況1:
前前期長紅棒

condition2= high\[2\] \< high\[3\] and low\[2\] \> low\[3\] ;//狀況2:
前期內包黑K棒

condition3= open \>= close\[1\] and close \< open\[2\] ;//狀況3:
開平高跌破三日低點

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

#### 📄 十字線

{@type:sensor}

{

\[檔名:\] 十字線 \[資料夾:\] 酒田戰法 \[適用方向\] 不指定

\[說明:\] K棒收十字線

}

settotalbar(5);

{判斷狀況}

condition1= close =open ;//狀況1: 開盤價等於收盤價

condition2= high\>open ;//狀況2: 有漲

condition3= low\<open ;//狀況3: 有跌

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

#### 📄 吊人

{@type:sensor}

{

\[檔名:\] 吊人 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 短黑棒留長下影線

}

settotalbar(5);

{判斷狀況}

condition1= open = High and close \< open ;//狀況1: 開高收低留黑棒

condition2= (high -low) \> 2 \*(high\[1\]-low\[1\]) ;//狀況2: 波動倍增

condition3= (close-low)\> (open-close) \*2 ;//狀況3:
下影線為實體兩倍以上

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

#### 📄 多頭三星

{@type:sensor}

{

\[檔名:\] 多頭三星 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 近三期開高低收皆呈Ｖ形排列

}

settotalbar(5);

{判斷狀況}

condition1= open\> open\[1\] and open\[2\]\>open\[1\] ;//狀況1:
開盤價排列

condition2= high\> high\[1\] and high\[2\]\>high\[1\] ;//狀況2:
最高價排列

condition3= low\> low\[1\] and low\[2\]\>low\[1\] ;//狀況3: 最低價排列

condition4= close\> close\[1\] and close\[2\]\>close\[1\] ;//狀況4:
收盤價排列

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 多頭吞噬

{@type:sensor}

{

\[檔名:\] 多頭吞噬 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 前期收短黑K棒 當期開低走高拉出長紅棒 波動率放大 穿過昨高

}

settotalbar(5);

{判斷狀況}

condition1= ( open\[1\] - close\[1\] ) \>(high\[1\] -low\[1\])\*0.75
;//狀況1: 前期出黑K棒

condition2= ( close - open ) \>(high -low) \* 0.75 ;//狀況2: 當期紅棒

condition3= high \> high\[1\] ;//狀況3: 高過昨高

condition4= open\<low\[1\] ;//狀況4: 開低破昨低

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 多頭執帶

{@type:sensor}

{

\[檔名:\] 多頭執帶 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 開在最低點一路走高收在最高點附近的K棒

}

settotalbar(5);

{判斷狀況}

condition1= close\>open ;//狀況1:

condition2= (Close-Open)\>(high-low)\*0.9 ;//狀況2:

condition3= Close\>Close\[1\]+high\[1\]-low\[1\] ;//狀況3:

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

#### 📄 多頭母子

{@type:sensor}

{

\[檔名:\] 多頭母子 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 前期收長黑K棒 今期開高小幅收紅不過昨高

}

settotalbar(5);

{判斷狀況}

condition1= ( open\[1\] - close\[1\] ) \>(high\[1\] -low\[1\])\*0.75
;//狀況1: 前期出長黑K棒

condition2= close\[1\] \< close\[2\] - high\[2\]-low\[2\] ;//狀況2:
前期呈波動放大下跌

condition3= ( close - open ) \>(high -low) \* 0.75 ;//狀況3: 當期紅棒

condition4= high \< high\[1\] ;//狀況4: 高不過昨高

condition5= low\>low\[1\] ;//狀況5: 低不破昨低

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

and condition5

THEN RET=1;

#### 📄 多頭遭遇

{@type:sensor}

{

\[檔名:\] 多頭遭遇 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 前期收黑K棒 當期開低走高紅棒嘗試反攻昨收

}

settotalbar(5);

{判斷狀況}

condition1= (open\[1\] - close\[1\] ) \>(high\[1\] -low\[1\]) \* 0.75
;//狀況1: 前期出黑K棒

condition2= close\[1\] \< close\[2\] ;//狀況2: 前期收跌

condition3= ( close - open ) \>(high -low) \* 0.75 ;//狀況3: 當期收紅K棒

condition4= open \< close\[1\] and close \< close\[1\] ;//狀況4:
開低且收跌

condition5= low \< low\[1\] ;//狀況5: 破前期低點

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

and condition5

THEN RET=1;

#### 📄 夜星

{@type:sensor}

{

\[檔名:\] 夜星 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 紅棒後 開高走低守平盤

}

settotalbar(5);

{判斷狀況}

condition1= ( close\[2\] - open\[2\] ) \> (high\[2\] -low\[2\]) \* 0.75
;//狀況1: 前前期實體紅棒

condition2= close\[2\] \> close\[3\] + (high\[3\]-low\[3\]) ;//狀況2:
前前期波動放大

condition3= low\[1\] \> high\[2\] and close\[1\]\>open\[1\] ;//狀況3:
前期高開收紅

condition4= open \< close\[1\] and close \< open - (high\[1\]-low\[1\])
;//狀況4: 當期開低收黑K棒

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 帶量倒狀鎚子

{@type:sensor}

{

\[檔名:\] 倒狀鎚子 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 前期收長黑K棒 今期開低試圖上攻後收上影線短紅棒

}

settotalbar(5);

{判斷狀況}

condition1= ( open\[1\] - close\[1\] ) \>(high\[1\] -low\[1\]) \* 0.75
;//狀況1: 前期出長黑K棒

condition2= close\[1\] \< close\[2\] - (high\[2\]-low\[2\]) ;//狀況2:
前期呈波動放大下跌

condition3= close \> open and (high -close)\> (close-open) \*2 ;//狀況3:
收紅上影線

condition4 = Volume \> Volume\[1\]; ;//狀況4: 帶量

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 帶量吊人

{@type:sensor}

{

\[檔名:\] 帶量吊人 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 短黑棒留長下影線 量倍增

}

settotalbar(5);

{判斷狀況}

condition1= open = High and close \< open ;//狀況1: 開高收低留黑棒

condition2= (high -low) \> 2 \*(high\[1\]-low\[1\]) ;//狀況2: 波動倍增

condition3= (close-low)\> (open-close) \*2 ;//狀況3:
下影線為實體兩倍以上

condition4= Volume \> Volume\[1\] ;//狀況4:

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 帶量多頭吞噬

{@type:sensor}

{

\[檔名:\] 多頭吞噬 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 前期收短黑K棒 當期開低走高拉出長紅棒 波動率放大 穿過昨高

}

settotalbar(5);

{判斷狀況}

condition1= ( open\[1\] - close\[1\] ) \>(high\[1\] -low\[1\])\*0.75
;//狀況1: 前期出黑K棒

condition2= ( close - open ) \>(high -low) \* 0.75 ;//狀況2: 當期紅棒

condition3= high \> high\[1\] ;//狀況3: 高過昨高

condition4= open\<low\[1\] ;//狀況4: 開低破昨低

condition5= Volume \> Volume\[1\]\*2 ;//狀況5:

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

and condition5

THEN RET=1;

#### 📄 帶量多頭執帶

{@type:sensor}

{

\[檔名:\] 帶量多頭執帶 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 開在最低點一路走高收在最高點附近的K棒 衝出倍增量

}

settotalbar(5);

{判斷狀況}

condition1= close\>open ;//狀況1:

condition2= (Close-Open)\>(high-low)\*0.9 ;//狀況2:

condition3= Close\>Close\[1\]+high\[1\]-low\[1\] ;//狀況3:

condition4= Volume \> Volume\[1\]\*2 ;//狀況4:

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 帶量空頭執帶

{@type:sensor}

{

\[檔名:\] 帶量空頭執帶 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 量倍增長黑棒

}

settotalbar(5);

{判斷狀況}

condition1= ( open - close ) \> (high -low) \* 0.8 ;//狀況1: 實體黑K棒

condition2= close \< close\[1\] - (high\[1\]-low\[1\]) ;//狀況2:
波動向下放大

condition3= Volume \> Volume\[1\]\*2 ;//狀況3:

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

#### 📄 帶量鎚頭

{@type:sensor}

{

\[檔名:\] 帶量鎚頭 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 開盤後下跌試底,盤中拉升上攻後,收在高點留下下影線 衝出倍增量

}

settotalbar(5);

{判斷狀況}

condition1= close \>=high and close \> open ;//狀況1: 收高

condition2= (high -low) \> 2 \*(high\[1\]-low\[1\]) ;//狀況2: 波動放大

condition3= (open-low) \> (close - open) \*2 ;//狀況3: 長下影線

condition4= Volume \> Volume\[1\]\*2 ;//狀況4: 當期量倍增

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 晨星

{@type:sensor}

{

\[檔名:\] 晨星 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 前前期收長黑K棒 前期再開低震盪收短紅棒後
當期開高紅棒反攻起跌點

}

settotalbar(5);

{判斷狀況}

condition1= ( open\[2\] - close\[2\] ) \>(high\[2\] -low\[2\]) \* 0.75
;//狀況1: 前前期出黑K棒

condition2= close\[2\] \< close\[3\]-(high\[3\]-low\[3\]) ;//狀況2:
跌勢擴大

condition3= ( close - open ) \>(high -low) \* 0.75 ;//狀況3: 當期收紅K棒

condition4= close\> close\[2\] ;//狀況4: 收復黑棒收盤價

condition5= close\[1\] \<= close\[2\] and close\[1\] \< open ;//狀況5:
前低收盤為三期低點

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

and condition5

THEN RET=1;

#### 📄 空頭三星

{@type:sensor}

{

\[檔名:\] 空頭三星 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 開高低收A型排列

}

settotalbar(5);

{判斷狀況}

condition1= open\[1\] \> open\[2\] and open\[1\] \> open ;//狀況1:
開盤價A型

condition2= high\[1\] \> high\[2\] and high\[1\] \> high ;//狀況2:
最高價A型

condition3= low\[1\] \> low\[2\] and low\[1\] \> low ;//狀況3: 最低價A型

condition4= close\[1\] \> close\[2\] and close\[1\] \> close ;//狀況4:
收盤價A型

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 空頭吞噬

{@type:sensor}

{

\[檔名:\] 空頭吞噬 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 紅棒後 開高下跌破昨低收長黑K棒

}

settotalbar(5);

{判斷狀況}

condition1= ( close\[1\] - open\[1\] ) \> (high\[1\] -low\[1\]) \* 0.5
;//狀況1: 前期實體紅棒

condition2= high-low \>( high\[1\]-low\[1\])\*2 ;//狀況2: 當期波動倍曾

condition3= ( open - close )\>(high -low) \* 0.75 ;//狀況3: 當期黑K棒

condition4= open \> close\[1\] and close \< low\[1\] ;//狀況4:
開高下跌破昨低

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 空頭執帶

{@type:sensor}

{

\[檔名:\] 空頭執帶 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 長黑棒

}

settotalbar(5);

{判斷狀況}

condition1= ( open - close ) \> (high -low) \* 0.8 ;//狀況1: 實體黑K棒

condition2= close \< close\[1\] - (high\[1\]-low\[1\]) ;//狀況2:
波動向下放大

{結果判斷}

IF

condition1

and condition2

THEN RET=1;

#### 📄 空頭母子

{@type:sensor}

{

\[檔名:\] 空頭母子 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 長紅棒後 內包短黑K

}

settotalbar(5);

{判斷狀況}

condition1= ( close\[1\] - open\[1\] ) \> (high\[1\] -low\[1\]) \* 0.8
;//狀況1: 前期實體紅棒

condition2= close\[1\]\> close\[2\] + high\[2\]-low\[2\] ;//狀況2:
前期波動向上放大

condition3= ( open - close )\>(high -low) \* 0.5 ;//狀況3: 當期黑K棒

condition4= high\[1\] \> high and low\[1\] \< Low ;//狀況4: 高不過高
低不過低 內包K棒

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 空頭流星

{@type:sensor}

{

\[檔名:\] 空頭流星 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 紅棒後 跳空開高收黑棒上影線

}

settotalbar(5);

{判斷狀況}

condition1= open \> close\[1\] and close \< open ;//狀況1: 開高且收黑

condition2= ( close\[1\] - open\[1\] ) \>(high\[1\] -low\[1\]) \* 0.75
;//狀況2: 前期收實體紅K棒

condition3= close\[1\]\> close\[2\] ;//狀況3: 當期收漲

condition4= (high - open ) \> (open-close) \* 2 ;//狀況4: 留長上影線

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

THEN RET=1;

#### 📄 空頭遭遇

{@type:sensor}

{

\[檔名:\] 空頭遭遇 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 紅棒後 開高走低守平盤

}

settotalbar(5);

{判斷狀況}

condition1= ( close\[1\] - open\[1\] ) \> (high\[1\] -low\[1\]) \* 0.5
;//狀況1: 前期實體紅棒

condition2= ( open - close ) \> (high -low) \* 0.5 ;//狀況2:
當期實體黑棒

condition3= open \> high\[1\] and close \> close\[1\] ;//狀況3:
開過昨高收守平盤

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

#### 📄 紅三兵

{@type:sensor}

{

\[檔名:\] 紅三兵 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 連續三根上漲實體K棒

}

settotalbar(5);

{判斷狀況}

condition1= ( close - open ) \>(high -low) \* 0.75 ;//狀況1: 實體上漲K棒

condition2= ( close\[1\] - open\[1\] ) \>(high\[1\] -low\[1\]) \* 0.75
;//狀況2: 實體上漲K棒

condition3= ( close\[2\] - open\[2\] ) \>(high\[2\] -low\[2\]) \* 0.75
;//狀況3: 實體上漲K棒

condition4= close \> close\[1\] ;//狀況4: 上漲

condition5= close\[1\] \> close\[2\] ;//狀況5: 上漲

{結果判斷}

IF

condition1

and condition2

and condition3

and condition4

and condition5

THEN RET=1;

#### 📄 蜻蜓十字

{@type:sensor}

{

\[檔名:\] 蜻蜓十字 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] T形線

}

settotalbar(5);

{判斷狀況}

condition1= close\>=open and open\>=high ;//狀況1: 開收高同價

condition2= (high-low)\> close \*0.01 ;//狀況2: 波動大於1%

{結果判斷}

IF

condition1

and condition2

THEN RET=1;

#### 📄 鎚頭

{@type:sensor}

{

\[檔名:\] 鎚頭 \[資料夾:\] 酒田戰法 \[適用方向\] 多

\[說明:\] 開盤後下跌試底,盤中拉升上攻後,收在高點留下下影線

}

settotalbar(5);

{判斷狀況}

condition1= close \>=high and close \> open ;//狀況1: 收高

condition2= (high -low) \> 2 \*(high\[1\]-low\[1\]) ;//狀況2: 波動放大

condition3= (open-low) \> (close - open) \*2 ;//狀況3: 長下影線

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

#### 📄 長腳十字星

{@type:sensor}

{

\[檔名:\] 長腳十字星 \[資料夾:\] 酒田戰法 \[適用方向\] 空

\[說明:\] 大波動十字線

}

settotalbar(5);

{判斷狀況}

condition1= close\>=open and open\>=close ;//狀況1: 開收同價

condition2= (high-low)\> close \*0.015 ;//狀況2: 波動大於1.5%

{結果判斷}

IF

condition1

and condition2

THEN RET=1;

### 3.17 長線投資 (3 個)

#### 📄 多頭趨勢已然確立

{@type:sensor}

input:CountMonth(6,\"計算月數\");

input:LSP(25,\"多空切換百分比\");

variable:pHigh(0),pLow(100000);

if CurrentDate \< DateAdd(Date,\"M\",CountMonth) then begin

pHigh = maxlist(h,pHigh);

pLow = minlist(l,pLow);

end else begin

pHigh = C;

pLow = C;

end;

value1= pHigh-(pHigh-pLow)\*LSP/100;

if close\>value1

and close\[1\]\<value1\[1\]

then ret=1;

#### 📄 大跌後的定存股標的

{@type:sensor}

input:Length(200,\"尋找高點期數\");

input:percent(38.2,\"自高點回檔幅度%\");

if close \< highest(high,Length)\*(1- percent/100) then Ret=1;

#### 📄 獲利穩定的公司來到市值低位區

{@type:sensor}

settotalbar(700);

if getsymbolfield(\"tse.tw\",\"收盤價\") \>
average(getsymbolfield(\"tse.tw\",\"收盤價\"),10) then begin

value4=GetField(\"總市值\");

value5=average(value4,600);

if value4\[1\]\<value5\[1\]\*0.7

and close=highest(close,10)

then ret=1;

end;

## 4. 🔍 選股 (324 個腳本)

> 依據技術面、籌碼面、基本面等條件的選股腳本

### 4.1 00.語法範例 (19 個)

#### 📄 EPS連續N季成長

{@type:filter}

input:N(4); SetInputName(1, \"期別\");

SetTotalBar(3);

if TrueAll(GetField(\"EPS\",\"Q\") \> GetField(\"EPS\",\"Q\")\[1\],N)
then ret=1;

SetOutputName1(\"EPS(元)(季)\");

OutputField1(GetField(\"EPS\",\"Q\"));

#### 📄 EPS連續N季衰退

{@type:filter}

input:N(4); SetInputName(1, \"期別\");

SetTotalBar(3);

if TrueAll(GetField(\"EPS\",\"Q\") \< GetField(\"EPS\",\"Q\")\[1\],N)
then ret=1;

SetOutputName1(\"EPS(元)(季)\");

OutputField1(GetField(\"EPS\",\"Q\"));

#### 📄 EPS連續N季都大於X元

{@type:filter}

input:N(4); setinputname(1, \"期別\");

input:X(1); setinputname(2, \"元\");

SetTotalBar(3);

if TrueAll(GetField(\"EPS\", \"Q\") \> X,N) then ret=1;

SetOutputName1(\"EPS(元)(季)\");

OutputField1(GetField(\"EPS\", \"Q\"));

#### 📄 EPS連續N季都小於X元

{@type:filter}

input:N(4); setinputname(1, \"期別\");

input:X(0); setinputname(2, \"元\");

SetTotalBar(3);

if TrueAll(GetField(\"EPS\", \"Q\") \< X,N) then ret=1;

SetOutputName1(\"EPS(元)(季)\");

OutputField1(GetField(\"EPS\", \"Q\"));

#### 📄 EPS連續N年都大於X元

{@type:filter}

input:N(4); setinputname(1, \"期別\");

input:X(1); setinputname(2, \"元\");

SetTotalBar(3);

if TrueAll(GetField(\"EPS\", \"Y\") \> X,N) then ret=1;

SetOutputName1(\"EPS(元)(年)\");

OutputField1(GetField(\"EPS\", \"Y\"));

#### 📄 EPS連續N年都小於X元

{@type:filter}

input:N(4); setinputname(1, \"期別\");

input:X(0); setinputname(2, \"元\");

SetTotalBar(3);

if TrueAll(GetField(\"EPS\", \"Y\") \< X,N) then ret=1;

SetOutputName1(\"EPS(元)(年)\");

OutputField1(GetField(\"EPS\", \"Y\"));

#### 📄 N期股價趨勢向上

{@type:filter}

input: Period(10); SetInputName(1, \"期別\");

settotalbar(3);

Condition1 = rateofchange(close, period) \>= Period;

Condition2 = close \> close\[Period/2\];

Condition3 = close \> average(close, period);

ret = condition1 and condition2 and condition3;

#### 📄 N期股價趨勢向下

{@type:filter}

input: Period(10); SetInputName(1, \"期別\");

settotalbar(3);

Condition1 = rateofchange(close, period) \<= -1 \* Period;

Condition2 = close \< close\[Period/2\];

Condition3 = close \< average(close, period);

ret = condition1 and condition2 and condition3;

#### 📄 \_基本範例

{@type:filter}

// 選股範例程式

//

//
使用GetField來取得欄位的數值。請按F7或從「編輯」\|「插入欄位」選項內啟動插入欄位的畫面。

// GetField函數的第一個參數是欄位名稱，例如 \"每股稅後淨利(元)\"，

// GetField函數的第二個參數是欄位的期別，例如
\"Q\"代表季資料，\"M\"代表月資料,\"Y\"代表年資料。

//

Value1 = GetField(\"每股稅後淨利(元)\",\"Q\");

//
如果GetField函數的第二個參數省略的話，則系統會根據執行這個腳本時所設定的頻率來決定

//
資料的期別。請務必注意引用腳本時必須設定正確的頻率，否則可能會遇到執行錯誤的情形。

//

Value2 = GetField(\"每股稅後淨利(元)\");

// 可以使用任何XSScript的語法來做運算，如果股票符合預期的話請設定Ret =
1，以下面一行為例

// 這個腳本會選到最新一年每股稅後淨利 \> 5元的股票

//

Ret = GetField(\"每股稅後淨利(元)\",\"Y\") \> 5;

// ＊＊　在這個目錄內有更多的程式範本可以參考　＊＊

//

#### 📄 收盤價近N期漲幅大於X%以上

{@type:filter}

input:N(10); SetInputName(1, \"期別\");

input:X(5); SetInputName(2, \"漲幅%\");

SetTotalBar(3);

Value1 = RateOfChange(GetField(\"收盤價\"),N);

if Value1 \> X then ret=1;

SetOutputName1(\"近期漲幅%\");

OutputField1(Value1);

#### 📄 收盤價近N期跌幅大於X%以上

{@type:filter}

input:N(10); SetInputName(1, \"期別\");

input:X(5); SetInputName(2, \"跌幅%\");

SetTotalBar(3);

Value1 = RateOfChange(GetField(\"收盤價\"),N);

if Value1 \< -1 \* X then ret=1;

SetOutputName1(\"近期跌幅%\");

OutputField1(Value1);

#### 📄 最近4季EPS合計大於X元

{@type:filter}

input:X(5); SetInputName(1, \"元\");

variable: N(4);

SetTotalBar(3);

Value1 = Summation(GetField(\"EPS\",\"Q\"),N);

if Value1 \> X then ret=1;

SetOutputName1(\"EPS合計\");

OutputField1(Value1);

#### 📄 最近4季EPS合計小於X元

{@type:filter}

input:X(0); SetInputName(1, \"元\");

variable: N(4);

SetTotalBar(3);

Value1 = Summation(GetField(\"EPS\",\"Q\"),N);

if Value1 \< X then ret=1;

SetOutputName1(\"EPS合計\");

OutputField1(Value1);

#### 📄 月營收創N期新低

{@type:filter}

input:N(13); setinputname(1, \"期別\");

SetTotalBar(3);

if GetField(\"月營收\", \"M\") \<= Lowest(GetField(\"月營收\", \"M\"),N)
then ret=1;

SetOutputName1(\"月營收\");

OutputField1(GetField(\"月營收\", \"M\"));

#### 📄 月營收創N期新高

{@type:filter}

input:N(13); setinputname(1, \"期別\");

SetTotalBar(3);

if GetField(\"月營收\", \"M\") \>= Highest(GetField(\"月營收\",
\"M\"),N) then ret=1;

SetOutputName1(\"月營收\");

OutputField1(GetField(\"月營收\", \"M\"));

#### 📄 本益比小於X倍

{@type:filter}

Input: X(10); SetInputName(1, \"本益比(倍)\");

settotalbar(3);

Value1 = GetField(\"本益比\", \"D\");

if Value1 \< X then Ret = 1;

SetOutputName1(\"本益比(倍)\");

outputfield1(Value1);

#### 📄 股價大於近N期平均

{@type:filter}

input:N(5); setinputname(1, \"期別\");

SetTotalBar(3);

Value1 = Average(GetField(\"Close\"),N);

if GetField(\"Close\") \> Average(GetField(\"Close\"),N) then ret=1;

SetOutputName1(\"均價\");

outputfield1(Value1);

#### 📄 股價小於近N期平均

{@type:filter}

input:N(5); setinputname(1, \"期別\");

SetTotalBar(3);

Value1 = Average(GetField(\"Close\"),N);

if GetField(\"Close\") \< Value1 then ret=1;

SetOutputName1(\"均價\");

outputfield1(Value1);

#### 📄 週轉率大於X%

{@type:filter}

Input: X(5); SetInputName(1, \"週轉率%\");

settotalbar(3);

Value1 = GetField(\"週轉率\",\"D\");

if Value1 \> X then Ret = 1;

SetOutputName1(\"週轉率%\");

outputfield1(Value1);

### 4.2 01.常用過濾條件 (7 個)

#### 📄 股本篩選

{@type:filter}

input:MinCapital(10);

input:MaxCapital(50);

SetInputName(1, \"最小股本(億)\");

SetInputName(2, \"最大股本(億)\");

SetTotalBar(3);

Value1 = GetField(\"最新股本\");

// 介於兩者之間

Ret = Value1 \>= MinCapital and Value1 \<= MaxCapital;

#### 📄 股票名稱不含F股

{@type:filter}

variable:sn(\"\");

sn=symbolname;

if instr(sn,\"F\")=0

and instr(sn,\"Y\")=0 then ret=1;

outputfield(1,sn,0,\"symbolname\");

#### 📄 過濾低價股票

{@type:filter}

input:PriceLimit(5);

SetInputName(1, \"最小股價\");

SetTotalBar(3);

Ret = close \> PriceLimit;

#### 📄 過濾低成交量股票

{@type:filter}

input:Length(5);

input:VolumeLimit(500);

SetInputName(1, \"均量天期\");

SetInputName(2, \"最小均量\");

SetTotalBar(3);

Value1 = Average(volume, Length);

Ret = Value1 \> VolumeLimit;

SetOutputName1(\"成交均量\");

OutputField1(Value1);

#### 📄 過濾冷門股票

{@type:filter}

input:PriceLimit(5),Length(5), VolumeLimit(500);

SetInputName(1, \"最小股價\");

SetInputName(2, \"均量天期\");

SetInputName(3, \"最小均量\");

SetTotalBar(3);

Value1 = Average(volume,Length);

if close \> PriceLimit and Value1 \> VolumeLimit Then

ret = 1;

#### 📄 過濾小型股票

{@type:filter}

input:MinCapital(10); // 股本(億)

SetInputName(1, \"最小股本(億)\");

SetTotalBar(3);

Ret = GetField(\"最新股本\") \> MinCapital;

#### 📄 過濾沒賺錢的股票

{@type:filter}

// 過去四季每股盈餘加總必須 \> 0

//

SetTotalbar(3);

Value1 = summation(GetField(\"EPS\",\"Q\"), 4);

Ret = Value1 \> 0;

### 4.3 02.基本技術指標 (24 個)

#### 📄 BBand出現買進訊號

{@type:filter}

input:length(20);

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 = bollingerband(Close, Length, 1);

down1 = bollingerband(Close, Length, -1 );

mid1 = (up1 + down1) / 2;

bbandwidth = 100 \* (up1 - down1) / mid1;

if bbandwidth crosses above 5 and close \> up1 and close\> up1\[1\]

and average(close,20)\>average(close,20)\[1\]

then ret=1;

#### 📄 CCI超買

{@type:filter}

// CCI超買

//

Input: Length(14), AvgLength(9), OverBought(100);

Variable: cciValue(0), cciMAValue(0);

SetTotalBar(maxlist(AvgLength + Length + 1,6) + 3);

SetInputName(1, \"期數\");

SetInputName(2, \"平滑期數\");

SetInputName(3, \"超買值\");

cciValue = CommodityChannel(Length);

cciMAValue = Average(cciValue, AvgLength);

Condition1 = cciMAValue Crosses Over OverBought;

If condition1 then ret = 1;

SetOutputName1(\"CCI\");

OutputField1(cciValue);

#### 📄 CCI超賣

{@type:filter}

// CCI超賣

//

Input: Length(14), AvgLength(9), OverSold(-100);

Variable: cciValue(0), cciMAValue(0);

SetTotalBar(maxlist(AvgLength + Length + 1,6) + 3);

SetInputName(1, \"期數\");

SetInputName(2, \"平滑期數\");

SetInputName(3, \"超賣值\");

cciValue = CommodityChannel(Length);

cciMAValue = Average(cciValue, AvgLength);

Condition1 = cciMAValue Crosses Below OverSold;

If condition1 then ret = 1;

SetOutputName1(\"CCI\");

OutputField1(cciValue);

#### 📄 KD死亡交叉

{@type:filter}

// KD指標, K值由上往下穿越D值

//

input: Length(9), RSVt(3), Kt(3);

variable: rsv(0), k(0), \_d(0);

SetTotalBar(maxlist(Length,6) \* 3);

SetInputName(1, \"天數\");

SetInputName(2, \"RSVt權數\");

SetInputName(3, \"Kt權數\");

Stochastic(Length, RSVt, Kt, rsv, k, \_d);

Ret = k crosses below \_d;

#### 📄 KD黃金交叉

{@type:filter}

// KD指標, K值由下往上穿越D值

//

input: Length(9), RSVt(3), Kt(3);

variable: rsv(0), k(0), \_d(0);

SetTotalBar(maxlist(Length,6) \* 3);

SetInputName(1, \"天數\");

SetInputName(2, \"RSVt權數\");

SetInputName(3, \"Kt權數\");

Stochastic(Length, RSVt, Kt, rsv, k, \_d);

Ret = k crosses above \_d;

#### 📄 MACD死亡交叉

{@type:filter}

// MACD 死亡交叉 (dif向下穿越macd)

//

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: difValue(0), macdValue(0), oscValue(0);

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 4);

SetInputName(1, \"DIF短期期數\");

SetInputName(2, \"DIF長期期數\");

SetInputName(3, \"MACD期數\");

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

Ret = difValue Crosses Below macdValue;

#### 📄 MACD黃金交叉

{@type:filter}

// MACD 黃金交叉 (dif向上穿越macd)

//

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: difValue(0), macdValue(0), oscValue(0);

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 4);

SetInputName(1, \"DIF短期期數\");

SetInputName(2, \"DIF長期期數\");

SetInputName(3, \"MACD期數\");

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

Ret = difValue Crosses Above macdValue;

#### 📄 MTM穿越0

{@type:filter}

// MTM往上穿越0軸

//

Input: Length(10);

SetInputName(1, \"期數\");

settotalbar(maxlist(Length,6));

Ret = Momentum(Close, Length) Crosses Above 0;

#### 📄 MTM跌破0

{@type:filter}

// MTM往下跌破0軸

//

Input: Length(10);

SetInputName(1, \"期數\");

settotalbar(maxlist(Length,6));

Ret = Momentum(Close, Length) Crosses Below 0;

#### 📄 RSI低檔背離

{@type:filter}

// RSI由下往上, 與價格趨勢背離

Input: RSILength(6, \"期數\"), Threshold(20, \"低檔值\"), Region(5,
\"日期區間\");

variable: rsiValue(0);

settotalbar(RSILength \* 9);

setbackBar(RSILength);

RSIValue = RSI(Close, RSILength);

If RSIValue Crosses Above Threshold and

RSIValue = Highest(RSIValue, Region) and

LinearRegSlope(close,Region) \< 0 then

Ret = 1;

outputfield1(RSIValue,\"RSI\");

#### 📄 RSI死亡交叉

{@type:filter}

// RSI短天期往下穿越長天期

//

input: ShortLength(6), LongLength(12);

settotalbar(maxlist(ShortLength,LongLength,6) \* 9);

SetInputName(1, \"短期期數\");

SetInputName(2, \"長期期數\");

Ret = RSI(Close, ShortLength) Crosses Below RSI(Close, LongLength);

#### 📄 RSI高檔背離

{@type:filter}

// RSI由高檔區往下, 與價格趨勢背離

Input: RSILength(6, \"期數\"), Threshold(80, \"高檔值\"), Region(5,
\"日期區間\");

variable: rsiValue(0);

settotalbar(RSILength \* 9);

setbackBar(RSILength);

RSIValue = RSI(Close, RSILength);

If RSIValue Crosses Below Threshold and

RSIValue = Lowest(RSIValue, Region) and

LinearRegSlope(close,Region) \> 0 then

Ret = 1;

outputfield1(RSIValue,\"RSI\");

#### 📄 RSI黃金交叉

{@type:filter}

// RSI短天期往上穿越長天期

//

input: ShortLength(6), LongLength(12);

settotalbar(maxlist(ShortLength,LongLength,6) \* 9);

SetInputName(1, \"短期期數\");

SetInputName(2, \"長期期數\");

Ret = RSI(Close, ShortLength) Crosses Above RSI(Close, LongLength);

#### 📄 均線多頭排列

{@type:filter}

input:Leng1(5),Leng2(20),Leng3(60);

variable: ma1(0), ma2(0), ma3(0);

SetInputName(1,\"短均線\");

SetInputName(2,\"中均線\");

SetInputName(3,\"長均線\");

settotalbar(3);

ma1 = average(close, Leng1);

ma2 = average(close, Leng2);

ma3 = average(close, Leng3);

condition1 = close \> ma1;

condition2 = ma1 \> ma2;

condition3 = ma2 \> ma3;

if condition1 and condition2 and condition3 then

ret = 1;

SetOutputName1(\"短均線\");

OutputField1(ma1);

SetOutputName2(\"中均線\");

OutputField2(ma2);

SetOutputName3(\"長均線\");

OutputField3(ma3);

#### 📄 均線空頭排列

{@type:filter}

input:Leng1(5),Leng2(20),Leng3(60);

variable: ma1(0), ma2(0), ma3(0);

SetInputName(1,\"短均線\");

SetInputName(2,\"中均線\");

SetInputName(3,\"長均線\");

settotalbar(3);

ma1 = average(close, Leng1);

ma2 = average(close, Leng2);

ma3 = average(close, Leng3);

condition1 = close \< ma1;

condition2 = ma1 \< ma2;

condition3 = ma2 \< ma3;

if condition1 and condition2 and condition3 then

ret = 1;

SetOutputName1(\"短均線\");

OutputField1(ma1);

SetOutputName2(\"中均線\");

OutputField2(ma2);

SetOutputName3(\"長均線\");

OutputField3(ma3);

#### 📄 布林通道超買

{@type:filter}

// 布林通道超買訊號

//

Input: Length(20), UpperBand(2);

SetInputName(1, \"期數\");

SetInputName(2, \"通道上緣\");

settotalbar(3);

Ret = High \>= bollingerband(Close, Length, UpperBand);

#### 📄 布林通道超賣

{@type:filter}

// 布林通道超賣訊號

//

Input: Length(20), LowerBand(2);

SetInputName(1, \"期數\");

SetInputName(2, \"通道下緣\");

settotalbar(3);

Ret = Low \<= bollingerband(Close, Length, -1 \* LowerBand);

#### 📄 帶量突破均線

{@type:filter}

// 帶量突破均線

//

input: Length(10), VolFactor(2);

SetInputName(1, \"期數\");

SetInputName(2, \"成交量放大倍數\");

settotalbar(3);

if close \> Average(close, Length) and close\[1\] \< Average(close,
Length) and

volume \> Average(volume\[1\], Length) \* VolFactor

then ret=1;

#### 📄 成交量放大

{@type:filter}

input: Length(5), VolFactor(2);

SetInputName(1, \"均量區間\");

SetInputName(2, \"放大倍數\");

settotalbar(3);

Ret = Volume \> Average(Volume\[1\], Length) \* VolFactor;

#### 📄 短期均線穿越長期均線

{@type:filter}

input: Shortlength(5); setinputname(1,\"短期均線期數\");

input: Longlength(20); setinputname(2,\"長期均線期數\");

settotalbar(3);

If Average(Close,Shortlength) crosses over Average(Close,Longlength)
then Ret=1;

#### 📄 短期均線跌破長期均線

{@type:filter}

input: Shortlength(5); setinputname(1,\"短期均線期數\");

input: Longlength(20); setinputname(2,\"長期均線期數\");

settotalbar(3);

If Average(Close,Shortlength) crosses under Average(Close,Longlength)
then Ret=1;

#### 📄 跌破糾結均線

{@type:filter}

setbarfreq(\"AD\");

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: midlength(10); setinputname(2,\"中期均線期數\");

input: Longlength(20); setinputname(3,\"長期均線期數\");

input: Percent(5); setinputname(4,\"均線糾結區間%\");

input: XLen(20); setinputname(5,\"均線糾結期數\");

input: Volpercent(25);
setinputname(6,\"放量幅度%\");//帶量突破的量是超過最長期的均量多少%

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

variable: AvgHLp(0),AvgH(0),AvgL(0);

shortaverage = average(close,shortlength);

midaverage = average(close,midlength);

Longaverage = average(close,Longlength);

AvgH = maxlist(shortaverage,midaverage,Longaverage);

AvgL = minlist(shortaverage,midaverage,Longaverage);

if AvgL \> 0 then AvgHLp = 100\*AvgH/AvgL -100;

condition1 = trueAll(AvgHLp \< Percent,XLen);

condition2 = V \> average(V\[1\],XLen)\*(1+Volpercent/100) ;

condition3 = average(Volume\[1\], 5) \>= 2000;

condition4 = C \< AvgL \*(0.98) and L \< lowest(L\[1\],XLen);

ret = condition1 and condition2 and condition3 and condition4;

outputfield(1,AvgH,2,\"均線上緣\", order := -1);

outputfield(2,AvgL,2,\"均線下緣\");

#### 📄 週KD低檔黃金交叉

{@type:filter}

// KD指標, K值由下往上穿越D值

//

input: Length(9), RSVt(3), Kt(3);

variable: rsv(0), k(0), \_d(0);

SetInputName(1, \"天數\");

SetInputName(2, \"RSVt權數\");

SetInputName(3, \"Kt權數\");

Stochastic(Length, RSVt, Kt, rsv, k, \_d);

Ret = k crosses above \_d and k\<30;

#### 📄 週線月線黃金交叉且站穩

{@type:filter}

setbarfreq(\"AD\");

value1=average(close,5);

value2=average(close,20);

if value1\[3\] crosses over value2\[3\]

and trueall(close\>close\[1\]and close\>value1,5)

then ret=1 ;

outputfield(1,value1,2,\"週線\", order := -1);

outputfield(2,value2,2,\"月線\");

### 4.4 03.進階技術分析 (24 個)

#### 📄 KD與均線同步出現買進訊號

{@type:filter}

input: Length(60, \"均線期間\");

variable:rsv1(0),k1(0),d1(0);

stochastic(9,3,3,rsv1,k1,d1);

// K線黃金交叉

condition1 = k1 crosses over d1;

condition2 = close crosses over average(close,Length) or close\[1\]
crosses over average(close\[1\],Length);

// 確認有一定的成交量

condition3 = average(volume,20) \> 1000;

ret = condition1 and condition2 and condition3;

outputfield(1,average(close,Length),2,\"60日均線\", order := -1);

#### 📄 K棒突破布林值上緣

{@type:filter}

Input:

Length(20, \"期數\"),

UpperBand(2, \"通道上緣\");

settotalbar(3);

Ret = close \>= bollingerband(Close, Length, UpperBand);

#### 📄 RSI黃金交叉且股價非盤整

{@type:filter}

input:n1(6); setinputname(1,\"RSI短期天數\");

input:n2(12); setinputname(2,\"RSI長期天數\");

input:n3(4); setinputname(3,\"盤整期間創新高次數\");

settotalbar(maxlist(n1,n2,6) \* 9);

value2 = highdays(n2);

if rsi(close,n1) crosses over rsi(close,n2) and

rsi(close,n1) \< 50 and

value2 \>= n3

then ret=1;

#### 📄 佔大盤成交量比開始上昇

{@type:filter}

value1=GetField(\"佔全市場成交量比\",\"D\");

SetTotalBar(5);

if value1\[4\]=lowest(value1,5) and

value1=highest(value1,5) and

close crosses above average(close,5)

then ret=1;

SetOutputName1(\"佔全市場成交量比(%)\");

OutputField1(value1);

#### 📄 冷門股出量

{@type:filter}

input:limit1(700); setinputname(1,\"均量上限\");

input:limit2(1000); setinputname(2,\"突破量\");

SetTotalBar(3);

value1 = average(volume,5);

if value1 \< limit1 and volume \> limit2 and High \> close\[1\] and
volume \> volume\[1\]

then ret=1;

#### 📄 外盤成交變多

{@type:filter}

input:shortPeriod(5); setinputname(1,\"短期平均\");

input:midPeriod(12); setinputname(2,\"長期平均\");

input:minVolume(2000); setinputname(3,\"成交量門檻\");

variable:

sVolume(0),

bVolume(0),

ratio(0),

ratioAvgShort(0),

ratioAvgLong(0);

SetTotalBar(MaxList(shortPeriod, midPeriod) + 3);

sVolume = GetField(\"內盤量\", \"D\");//內盤量

bVolume = GetField(\"外盤量\", \"D\"); //外盤量

if sVolume + bVolume \<\> 0 then

ratio = bVolume / (sVolume + bVolume) \* 100

else

ratio = 50;

ratioAvgShort = average(ratio,shortPeriod);

ratioAvgLong = average(ratio,midPeriod);

if

volume \> minVolume and

ratioAvgShort \< 40 and

ratioAvgLong \< 40 and

absvalue(ratioAvgShort-ratioAvgLong) \< 10 and

ratioAvgShort crosses above ratioAvgLong

then

ret=1;

#### 📄 多指標都出現買進訊號

{@type:filter}

settotalbar(120);

//=========計算RSI======================

Input:rsilength(6); Setinputname(1,\"設定RSI計算天期\");

input:rsilimit(50); Setinputname(2,\"設定RSI要突破的限制\");

Value1=rsi(close,rsilength);//計算RSI的值

//==========計算威廉指標==================

input: rLength(3); SetInputName(3, \"設定威廉指標天期\");

input: rLimit(-50); SetInputName(4, \"設定威廉指標的限制\");

value2 = PercentR(rLength) - 100;

//============計算DMI=======================

input: dmiLength(10); setinputname(5,\"設定DMI天期\");

variable: pdi_value(0), ndi_value(0), adx_value(0);

DirectionMovement(dmiLength, pdi_value, ndi_value, adx_value);

value4=pdi_value;

//============純粹只是想確認本週股價都沒有跌破前週低==============

condition1 = GetField(\"Low\", \"W\") \> GetField(\"Low\", \"W\")\[1\];

//============ XQ: tt指標==========================================

input: Length(10); SetInputName(6, \"設定tt指標計算期數\");

variable: kk(0), qu(0), qd(0), qf(0), tt(0);

qf = 0;

qu = 0;

qd = 0;

for kk = 1 to length

begin

if close\[(kk - 1)\] \> close\[kk\] then

qu = qu + Volume\[(kk - 1)\]

else

begin

if close\[(kk - 1)\] \< close\[kk\] then

qd = qd + Volume\[(kk - 1)\]

else { close\[(kk - 1)\] = close\[kk\] }

qf = qf + Volume\[(kk - 1)\];

end;

end;

if (qd + qf/2) \<\> 0 then

tt = 100 \* (qu + qf/2) /(qd + qf/2)

else

tt = 1000;

value5=tt;

//==================設定警示條件====================================

if value1 \> rsilimit

and value2 \> rLimit

and condition1 = true

and value4 \> 0

and value5 \> 800

then ret=1;

#### 📄 多空分數翻昇

{@type:filter}

// 計算技術指標分數序列, 判斷指標分數是否翻轉

//

settotalbar(168);

value1 = techscore();

value2 = average(value1, 10);

if value2 crosses above 5 then ret = 1;

#### 📄 多空分數轉空

{@type:filter}

// 計算技術指標分數序列, 判斷指標分數是否翻轉

//

settotalbar(168);

value1 = techscore();

value2 = average(value1, 10);

if value2 crosses under 10 then ret = 1;

#### 📄 天量後價量未再創新高

{@type:filter}

input:XLength(60); setinputname(1,\"長期大量計算期數\");

input:Length(3); setinputname(2,\"超過n日價量未再創新高\");

variable: PriceHighBar(0),VolumeHighBar(0);

settotalbar(3);

VolumeHighBar = highestbar(volume, XLength);

PriceHighBar = highestbar(high, Length);

// 近日內成交量創新高, 可是價格沒有創新高

//

if VolumeHighBar \> 0 and

VolumeHighBar \<= Length and

PriceHighBar = VolumeHighBar then

ret = 1;

#### 📄 布林帶寬大於N%

{@type:filter}

input:

Length(20, \"天數\"),

UpperBand(2, \"上\"),

LowerBand(2, \"下\"),

BBW(80,\"N\");

variable:

bbandwidth(0);

bbandwidth = bollingerbandwidth(Close, Length, UpperBand, LowerBand);

if bbandwidth \>= BBW then ret=1;

outputfield(1,bbandwidth,2,\"布林帶寬\");

#### 📄 布林帶寬小於N%

{@type:filter}

input:

Length(20, \"天數\"),

UpperBand(2, \"上\"),

LowerBand(2, \"下\"),

BBW(20,\"N\");

variable:

bbandwidth(0);

bbandwidth = bollingerbandwidth(Close, Length, UpperBand, LowerBand);

if bbandwidth \<= BBW then ret=1;

outputfield(1,bbandwidth,2,\"布林帶寬\");

#### 📄 帶量突破均線後未拉回

{@type:filter}

input:day(5); setinputname(1,\"幾天內未站回\");

input:length(10); setinputname(2,\"移動平均線期別\");

input:percent(20); setinputname(3,\"突破當日成交量超過均量多少%\");

SetTotalBar(3);

value1=average(close,length);

value2=average(volume,length);

if close\[day-1\] crosses over average(close\[day-1\], length) and

volume\[day-1\] \> average(volume\[day-1\], length) \* (1+percent/100)
and

volume \> 1000

then

begin

variable: keyprice(0);

keyprice = average(close\[day-1\], length);

if trueall(close \> keyprice, day-1) then ret = 1;

end;

#### 📄 底部越來越高且資金流入的蓄勢股

{@type:filter}

input:r1(7); setinputname(1,\"近來漲幅上限%\");

SetTotalBar(8);

value1 = RateOfChange(close, 12);

value2 = lowest(low,3);

value3 = lowest(low,8);

value4 = lowest(low,13);

condition1=false;

condition2=false;

if

value1 \< r1 and

value2 \> value3 and

value3 \> value4 and

close = highest(close,13)

then

condition1=true;

Value5=average(GetField(\"佔全市場成交量比\",\"D\"),13);

if linearregslope(Value5,5) \> 0

then condition2=true;

if condition1 and condition2

then ret=1;

#### 📄 波動幅度開始變大

{@type:filter}

input: Length(20); SetInputName(1, \"計算區間\");

input: VolLimit(1000); SetInputName(2, \"成交量限制\");

value1 = truerange();

value2 = highest(value1,Length);

SetTotalBar(Length + 3);

if

value1 \> value2\[1\] and

value1 \> value1\[1\] and

close \* 1.01 \> high and

close \> close\[1\] and

volume \> VolLimit

then ret=1;

#### 📄 盤整後跌破

{@type:filter}

input:length(20); setinputname(1, \"計算期間\");

input:percent(7); setinputname(2, \"設定盤整區間%\");

SetTotalBar(3);

value1 = highest(high\[1\],length);

value2 = lowest(low\[1\],length);

if

close crosses under value2 and

value1 \< value2 \*( 1 + percent \* 0.01)
//最近幾根bar的收盤價高點與低點差不到N%

then ret=1;

#### 📄 突破糾結均線

{@type:filter}

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: midlength(10); setinputname(2,\"中期均線期數\");

input: Longlength(20); setinputname(3,\"長期均線期數\");

input: Percent(2); setinputname(4,\"均線糾結區間%\");

input: Volpercent(25);
setinputname(5,\"放量幅度%\");//帶量突破的量是超過最長期的均量多少%

input: VolLimit(2000); setinputname(6,\"最小成交量\");

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

variable: maxaverage(0);

shortaverage = average(close,shortlength);

midaverage = average(close,midlength);

Longaverage = average(close,Longlength);

maxaverage = maxlist(shortaverage,midaverage,Longaverage);

SetTotalBar(8);

if

volume \> average(volume,Longlength) \* (1 + volpercent \* 0.01) and

volume \> VolLimit and

Close crosses over maxaverage

then

begin

value1= absvalue(shortaverage -midaverage);

value2= absvalue(midaverage -Longaverage);

value3= absvalue(Longaverage -shortaverage);

if maxlist(value1,value2,value3)\*100 \< Percent\*Close then ret=1;

end;

#### 📄 築底指標出現買進訊號

{@type:filter}

input: period(125); setinputname(1, \"計算區間長度\");

input: length1(5); setinputname(2, \"短天期\");

input: length2(20); setinputname(3, \"長天期\");

variable:zd(0),zdma1(0),zdma2(0);

SetTotalBar(Period + 8);

zd = countif(close\>=close\[1\],period) /
countif(close\<close\[1\],period);

zdma1 = average(zd,length1);

zdma2 = average(zd,length2);

if zdma1\<1 and zdma2\<1 and zdma1 crosses above zdma2

then ret=1;

#### 📄 股價下跌而外盤量佔比上升

{@type:filter}

input:period(20); setinputname(1,\"計算天期\");

settotalbar(period \* 2 + 3);

value1 = GetField(\"外盤量\");//日的外盤量

if volume \<\> 0 then

value2 = value1 / volume

else

value2 = 0;

value3 = average(value2, period);

if linearregslope(value3,period) \> 0 and

linearregslope(close,period) \< 0 and

volume \> 1000

then ret=1;

#### 📄 股價蠢蠢欲動

{@type:filter}

SetTotalBar(23);

value1=truerange();

value2=highest(value1,20);

if value1 \> value2\[1\] and

value1 \> value1\[1\] and

close\*1.01 \> high and

close \> close\[1\]

then ret=1;

#### 📄 股價跌破走跌後的高壓電線

{@type:filter}

SetTotalBar(8);

value1 = (average(close,30) + average(close,72)) / 2; //地心引力線

value2 = value1\*1.2;//高壓電線

value3 = linearregslope(value2,5);

if absvalue(value3) \<= 0.1 and close crosses under value1

then ret=1;

#### 📄 趨勢成形

{@type:filter}

// ADX趨勢成形

//

input: Length(14), Threshold(25);

variable: pdi_value(0), ndi_value(0), adx_value(0);

SetTotalBar(Length\*11);

SetInputName(1, \"期數\");

SetInputName(2, \"穿越值\");

DirectionMovement(Length, pdi_value, ndi_value, adx_value);

if adx_value Crosses Above Threshold and close=high

then ret=1;

#### 📄 跌破均線後站不回

{@type:filter}

input:day(3); setinputname(1,\"幾天內未站回\");

input:length(20); setinputname(2,\"移動平均線期別\");

settotalbar(length + 3);

if close\[day-1\] crosses under average(close\[day-1\], length) then

begin

variable: keyprice(0);

keyprice = average(close\[day-1\], length);

if trueall(close \< keyprice, day-1) then ret = 1;

end;

#### 📄 雙KD向上

{@type:filter}

setbarfreq(\"AD\");

input: Length_D(9, \"日KD期間\");

input: Length_W(5, \"周KD期間\");

variable:rsv_d(0),kk_d(0),dd_d(0);

variable:rsv_w(0),kk_w(0),dd_w(0);

stochastic(Length_D, 3, 3, rsv_d, kk_d, dd_d);

xf_stochastic(\"W\", Length_W, 3, 3, rsv_w, kk_w, dd_w);

condition1 = kk_d crosses above dd_d; // 日KD crosses over

condition2 = xf_crossover(\"W\", kk_w, dd_w); // 周KD crosses over

condition3 = average(volume\[1\], 5) \>= 1000;

condition4 = kk_d\[1\] \<= 30; // 日K 低檔

condition5 = xf_getvalue(\"W\", kk_w, 1) \<= 50; // 周K 低檔

ret = condition1 and condition2 and condition3 and condition4 and
condition5;

outputfield(1,kk_d,2,\"日K值\");

outputfield(2,kk_w,2,\"週K值\", order := -1);

### 4.5 04.價量選股 (40 個)

#### 📄 M日內連續N日上漲

{@type:filter}

input:day(11);

input:m1(3);

setinputname(1,\"計算天期\");

setinputname(2,\"連續上漲天數\");

variable:x(0),count(0);

count=0;

for x=0 to day-m1

begin

if close\[x\]\>close\[x+1\]

and close\[x+1\]\>close\[x+2\]

and close\[x+2\]\>close\[x+3\]

then count=count+1;

end;

if count\>=1

then ret=1;

#### 📄 N年來漲了M倍的公司

{@type:filter}

input:y1(10,\"計算的年數\");

input:ratio(800,\"上漲的倍數%\");

value1=rateofchange(GetField(\"收盤價\",\"AM\"),y1\*12);

if value1\>=ratio

then ret=1;

#### 📄 五日週轉率大於二十日週轉率

{@type:filter}

if turnoverrate(5)\>turnoverrate(20)

then ret=1;

outputfield(1,turnoverrate(5),1,\"5日平均週轉率\");

outputfield(2,turnoverrate(20),1,\"20日平均週轉率\");

#### 📄 今收破昨高

{@type:filter}

if close\>=high\[1\]

then ret=1;

#### 📄 修正式價量指標黃金交叉

{@type:filter}

setbarfreq(\"AD\");

input:day(10, \"移動平均線天數\");

variable:tvp(0),mpc(0);

mpc=(open+high+low+close)/4;

if mpc\[1\]\<\>0

then tvp=tvp\[1\]+(mpc-mpc\[1\])/mpc\[1\]\*volume

else tvp=tvp\[1\];

value1=average(tvp,day);

If tvp crosses over value1 and volume\>1000

and tvp\>value1\*1.05

then ret=1;

outputfield(1,average(c,day),2,\"10日線\", order := -1);

#### 📄 價量同步創N期新高

{@type:filter}

input:period(100,\"計算天數\");

value1=highest(high,period);

value2=highest(volume,period);

if high=value1 and volume=value2

then ret=1;

#### 📄 創最低總市值

{@type:filter}

input:period(36,\"計算的月份數\");

setbarfreq(\"M\");

if GetField(\"總市值\",\"M\")=lowest(GetField(\"總市值\",\"M\"),period)

then ret=1;

#### 📄 創百日來新高但距離低點不太遠

{@type:filter}

//說明：今天的收盤價創百日來的收盤價新高，但是收盤價距離低點不太遠

input:day(100); setinputname(1,\"計算區間\");

input:percents(14); setinputname(2,\"距離區間最低點漲幅\");

SetTotalBar(3);

value1 = lowest(close, day);

if close=highest(close,day) and value1 \* (1 + percents/100) \>= close

then ret=1;

#### 📄 區間內股價創新高天數達一定水準

{@type:filter}

input:period(10,\"計算區間\");

input:lowlimit(3,\"附合條件的最低次數\");

if countif(high=highest(high,20),period)\>=lowlimit

then ret=1;

#### 📄 多日價量背離後跌破

{@type:filter}

setbarfreq(\"AD\");

input:Length(5, \"計算期數\");

input:times(3, \"價量背離次數\");

input:Dist(20, \"距離\");

variable:count(0),KPrice(0),hDate(0);

count = CountIf(close \> close\[1\] and volume \< volume\[1\], Length);

if count \> times then begin

hDate=Date;

Kprice = lowest(l,length);

end;

Condition1 = Close crosses below Kprice;

Condition2 = DateDiff(Date,hdate) \< Dist;

Ret = Condition1 And Condition2;

outputfield(1,Kprice,2,\"關卡價\", order := -1);

#### 📄 多次到底而跌破

{@type:filter}

setbarfreq(\"AD\");

input:HitTimes(3,\"設定觸底次數\");

input:RangeRatio(1,\"設定底部區範圍寬度%\");

input:Length(20,\"計算期數\");

variable: theLow(0);

variable: LowUpperBound(0);

variable: TouchRangeTimes(0);

//找到過去期間的最低點

theLow = lowest(low\[1\],Length);

// 設為瓶頸區間上界

LowUpperBound = theLow \*(100+RangeRatio)/100;

//期間中進入瓶頸區間的低點次數,每根K棒要歸0

TouchRangeTimes = CountIF(Low\[1\] \< LowUpperBound, Length);

Condition1 = TouchRangeTimes \>= HitTimes;

Condition2 = close \< theLow;

Condition3 = Average(Volume, 5) \>= 1000;

Ret = Condition1 And Condition2 And Condition3;

outputfield(1, theLow, 2, \"區間低點\", order := -1);

#### 📄 多頭轉強

{@type:filter}

setbarfreq(\"AD\");

input:length(10, \"天期\");

variable: sumUp(0), sumDown(0), up(0), down(0),RS(0);

if CurrentBar = 1 then begin

sumUp = Average(maxlist(close - close\[1\], 0), length);

sumDown = Average(maxlist(close\[1\] - close, 0), length);

end else begin

up = maxlist(close - close\[1\], 0);

down = maxlist(close\[1\] - close, 0);

sumUp = sumUp\[1\] + (up - sumUp\[1\]) / length;

sumDown = sumDown\[1\] + (down - sumDown\[1\]) / length;

end;

if sumdown\<\>0

then rs=sumup/sumdown;

if rs crosses over 4

and close\<close\[3\]\*1.06

//最近3日漲幅小於6%

and Average(Volume\[1\], 100) \>= 500

//成交量判斷

then ret=1;

outputfield(1, nthlowest(1,low\[1\],length), 2, \"區間低點\", order :=
-1);

#### 📄 大漲股

{@type:filter}

condition1=false;

condition2=false;

condition3=false;

//先把簡單的價量條件全部放在condition1

if highest(high,3)\<lowest(low,3)\*1.15

//區間震盪小於15%

and close\>5

//股價大於5元

and close\<200

//股價小於5元

and volume\>300

//當日成交量大於300張

and high=highest(high,2)

//創兩日來新高

and close\>close\[1\]\*1.02

//最近一日上漲超過2%

then condition1=true;

//用condition2來處理月線斜率大於0.4

value1=average(close,20);

//先算出月線

value2=linearregslope(value1,10);

//算出季線這十天的斜率

if value2\>0.4 then condition2=true;

//月線斜率要大於0.4

//處理布林帶寬

input:length(20,\"計算天期\");

input:width(35,\"帶寬%\");

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 = bollingerband(Close, Length, 1);

down1 = bollingerband(Close, Length, -1 );

mid1 = (up1 + down1) / 2;

bbandwidth = 100 \* (up1 - down1) / mid1;

if bbandwidth \<width

then condition3=true;

ret=condition1 and condition2 and condition3;

#### 📄 大跌後的急拉

{@type:filter}

setbarfreq(\"AD\");

value1=barslast(close\>=close\[1\]\*1.07);

if value1\[1\]\>50

//超過50天沒有單日上漲超過7%

and value1=0

//今天上漲超過7%

and average(volume,100)\>500

and volume\>1000

and close\[1\]\*1.25\<close\[30\]

//過去三十天跌幅超過25%

then ret=1;

outputfield(1,lowest(L,50),2,\"前波低點\", order := -1);

#### 📄 底部愈墊愈高且資金流入的蓄勢股

{@type:filter}

input:r1(7,\"近來漲幅上限%\");

value1 = RateOfChange(close, 12);

value2 = lowest(low,3);

value3 = lowest(low,8);

value4 = lowest(low,13);

condition1=false;

condition2=false;

if

value1 \< r1 and

value2 \> value3 and

value3 \> value4 and

close = highest(close,13)

then

condition1=true;

Value5=average(GetField(\"佔全市場成交量比\",\"D\"),13);

if linearregslope(Value5,5) \> 0

then condition2=true;

if condition1 and condition2

then ret=1;

outputfield(1,value2,2,\"前波低點\", order := -1);

#### 📄 收盤價創N日來新高

{@type:filter}

input:period(100,\"計算天數\");

if close=highest(close,period)

then ret=1;

value2=GetField(\"總市值\",\"D\");

outputfield(1,value2,0,\"總市值\");

#### 📄 收盤價收N日來新低

{@type:filter}

input:period(100);

setinputname(1,\"計算天數\");

value1=LOWEST(LOW,period);

if LOW=value1

then ret=1;

#### 📄 昨天成交量不到2000張今天已超過2000張

{@type:filter}

if volume\[1\]\<2000

and volume\>2000

and close=highest(close,20)

then ret=1;

#### 📄 曾經一個月漲超過兩成的股票

{@type:filter}

setbarfreq(\"M\");

settotalbar(12);

if close\>close\[1\]\*1.2 then

begin

ret=1;

outputfield(1,intportion(date\*0.01),0,\"上漲的月份\");

end;

#### 📄 最近N日漲跌幅小於M%

{@type:filter}

input:period(10,\"計算區間\");

input:ratio(10,\"最低漲跌幅\");

value1 = rateofchange(close,period-1);

if value1 \< ratio then ret=1;

outputfield(1,value1,1,\"區間漲跌幅\");

#### 📄 有一定成交值且過去三日漲幅小

{@type:filter}

input:b1(1.5,\"三日漲幅上限\");

if volume\*close\>=30000

and close\<=close\[2\]\*(1+b1/100)

then ret=1;

#### 📄 波動幅度開始變大且往上攻

{@type:filter}

SetBarFreq(\"AD\");

input: Length(20, \"計算區間\");

input: VolLimit(1000, \"成交量限制\");

value1 = truerange();

value2 = highest(value1,Length);

SetTotalBar(Length + 3);

if

value1 \> value2\[1\] and

value1 \> value1\[1\] and

close \* 1.01 \> high and

close \> close\[1\] and

volume \> VolLimit

then ret=1;

outputfield(1,close\[1\],2,\"前波低點\", order := -1);

#### 📄 波段漲幅不大，近N日有過漲停的

{@type:filter}

input:day(10,\"計算區間\");

value1=GetField(\"漲停價\",\"D\");

if trueany(close=value1,day)

//近十日有一天漲停

and close\<close\[30\]\*1.2

//近三十日漲幅不到兩成

then ret=1;

#### 📄 漲勢加速

{@type:filter}

setbarfreq(\"AD\");

variable:aspeed(0),dspeed(0),a1(0),d1(0),p1(0),ap1(0);

if close\>close\[1\] then aspeed=(close-close\[1\])/close\*100

else aspeed=0;

if close\<close\[1\] then dspeed=(close\[1\]-close)/close\*100

else dspeed=0;

a1=average(aspeed,5);

d1=average(dspeed,5);

p1=a1-d1;

ap1=average(p1,9);

if p1 crosses over ap1

and rsi(close,6)\<=75

and close\*1.3\<close\[30\]

then ret=1;

outputfield(1, nthlowest(1,low\[1\],9), 2, \"近期低點\", order := -1);

#### 📄 漲勢成形

{@type:filter}

Value1=linearregslope(close,3);

value2=linearregslope(close,5);

value3=linearregslope(close,20);

settotalbar(23);

if

value1 \> value2 and

value2 \> value3 and

value1 \> value1\[1\] and

value1\[1\] \> value1\[2\] and

value1 \> 0.3 and

value3\[2\] \< 0.1 and

value3 \> 0

then ret=1;

#### 📄 漲勢變強

{@type:filter}

input: Length(100); setinputname(1,\"計算期數\");

input: RRatio(100); setinputname(2,\"盤漲最大漲幅%\");

settotalbar(3);

variable: Scores(0);

if Close \> Open and Close \> Close\[2\]\*1.07
{紅棒且累計三天漲幅大於7%}

and Close \< Close\[Length\]\*(1+RRatio/100) {累計漲幅不超過%}

then

begin

scores = countif(close \> close\[1\], length);

If scores \>= Length / 2 then ret=1;

end;

#### 📄 漲多後跌破頭部

{@type:filter}

input:ratio(50);

input:period(100);

setinputname(1,\"波段漲幅\");

condition1=false;

value1=highestbar(close,period);//波段最高價距今幾根bar

value2=lowest(close\[1\],value1);

if value1\>5 and close\>close\[100\]\*(1+ratio/100)

and close crosses under value2

then ret=1;

#### 📄 炒高後無量反轉下跌

{@type:filter}

setbarfreq(\"AD\");

input: Periods(150,\"計算期數\");

input: Ratio(20,\"期間漲幅%\");

if close \< close\[4\]

and close\*1.1\>highest(close,periods)

//離最高不到一成

and close \>= close\[Periods\] \*(1 + Ratio\*0.01)

//過去半年漲幅超過五成

and average(volume\[1\],5)\*1.5 \< average(volume\[1\],20)

//最近幾天成交量大幅縮小

then ret=1;

outputfield(1,highest(close,periods),2,\"波段高點\", order := -1);

#### 📄 無量變有量

{@type:filter}

input:v1(1000,\"前一期成交量\");

input:v2(1000,\"最新期成交量\");

if trueall(volume\[1\]\<=v1,10) and volume\>v2

then ret=1;

#### 📄 特定日期迄今漲跌幅超過一定幅度

{@type:filter}

input:startdate(20160203);

input:ratio(15,\"漲幅下限\");

value1=getbaroffset(startdate);

value2=rateofchange(close,value1);

if value2\>ratio

then ret=1;

outputfield(1,value2,1,\"區間漲跌幅\");

outputfield(2,GetField(\"股價淨值比\",\"D\"),2,\"股價淨值比\");

outputfield(3,GetField(\"月營收年增率\",\"M\"),2,\"月營收年增率\");

outputfield(4,GetField(\"本益比\",\"D\"),1,\"本益比\");

#### 📄 盤整N日後突破

{@type:filter}

input:period(20,\"盤整的天數\");

input:ratio(5,\"盤整的最大波動範圍\");

if highest(close,period)\[1\]\<lowest(close,period)\[1\]\*(1+ratio/100)

and close \> highest(close,period)\[1\]

and volume \>average(volume,period)

and volume\>2000

then ret=1;

#### 📄 站在五十二週高點之上

{@type:filter}

value1=GetField(\"最高價\",\"w\");

value2=highest(value1\[1\],52);

if close\>value2 then ret=1;

#### 📄 總市值跌到歷年低點

{@type:filter}

setbarfreq(\"Y\");

settotalbar(8);

value1=GetField(\"總市值\",\"Y\");

value2=lowest(value1,8);

if value1\<value2\*1.1

then ret=1;

#### 📄 股價超過N日未再破底

{@type:filter}

input:period(30);

input:day(10);

setinputname(1,\"計算期間\");

setinputname(2,\"未破底天數\");

value1=lowestbar(low,period);

if value1\>day

then ret=1;

#### 📄 行業轉強個股也轉強

{@type:filter}

input:period(20,\"計算區間\");

setbarfreq(\"D\");

settotalbar(20);

value1=GetField(\"同業股價指標\",\"D\");

value2=GetField(\"佔全市場成交量比\",\"D\");

if value1=highest(value1,period)

and value2=highest(value2,period)

then ret=1;

#### 📄 跌到52週低點之下

{@type:filter}

setbarfreq(\"W\");

if close\<lowest(low\[1\],52) then ret=1;

#### 📄 週線二連紅

{@type:filter}

SetBarFreq(\"AW\");

if rateofchange(close,2)\[1\]\>0 and rateofchange(close,2)\[2\]\>0

and close\<close\[2\]\*1.07

and close\[10\]\>close\*1.2

then ret=1;

outputfield(1,close\[2\],2,\"前波低點\", order := -1);

#### 📄 過去M日有N日HHLL

{@type:filter}

input:days(5,\"計算天期\");

input:occurrence(2, \"發生次數\");

condition1= high\>high\[1\] and low\>low\[1\] ;

value1=countif(condition1,days);

if value1\>=occurrence then ret=1;

#### 📄 過去N日價穩量縮

{@type:filter}

input:days(10,\"計算期間\");

input:vhilimit(1000,\"量的上限\");

input:philimit(5,\"價格波動上限\");

setbarfreq(\"D\");

settotalbar(days);

value1=highest(high,days);

value2=lowest(low,days);

value3=(value1-value2)/value2\*100;

if trueall(volume\<vhilimit,days)

and trueall(value3\<philimit,days)

then ret=1;

#### 📄 量價背離

{@type:filter}

input:length(10); setinputname(1,\"計算區間\");

settotalbar(length + 3);

value1 = average(close,length);

value2 = average(volume,length);

value3 = linearregslope(value1,length);

value4 = linearregslope(value2,length);

if value2 \> 1000 and value3 \< 0 and value4 \> 0

then ret=1;

### 4.6 05.型態選股 (18 個)

#### 📄 三次到頂而破

{@type:filter}

input: BoxRangePercents(7); setinputname(1,\"定義整理區間幅度\");

input: HighAreaPercents(1.5); setinputname(2,\"定義區間高檔範圍\");

variable: BoxHigh(0);

variable:period(10),MaxPeriod(40);

period = 10;

while period \< Maxperiod and

highest(high\[1\],period) \< lowest(low\[1\],period)
\*(1+BoxRangePercents/100)

begin period +=1; end;

if period \< MaxPeriod then

begin

BoxHigh = highest(High\[1\],period); {區間高點}

if Close \> BoxHigh and {突破整理區間高點}

NthHighest(3,High\[1\],period) \> BoxHigh\*(1-HighAreaPercents/100)

{昨天以前第3個高點也在高檔區間,即曾經攻高3次}

then ret=1;

end;

#### 📄 上昇旗形

{@type:filter}

setbarfreq(\"AD\");

input:period(20,\"計算區間\");

value2=nthhighest(1,high\[1\],period);//最高價

value3=nthhighest(2,high\[1\],period);//第二高價

value4=nthhighest(3,high\[1\],period);//第三高價

value5=nthhighestbar(1,high\[1\],period);//最高價距今幾根bar

value6=nthhighestbar(2,high\[1\],period);//第二高價距今幾根bar

value7=nthhighestbar(3,high\[1\],period);//第三高價距今幾根bar

condition1=false;

condition2=false;

if value6-value5\>3 and value7-value6\>3

then condition1=true;//三個高點沒有連在一起，且是愈來愈高

if maxlist(value2,value3,value4)\<minlist(value2,value3,value4)\*1.07

then condition2=true;//三個高點沒有差多少

if condition1 and condition2

and close crosses over value2

and close\[period\]\*1.05\<value2

then ret=1;

outputfield(1, value2, 2, \"前波高點\", order := -1);

#### 📄 下跌後的吊人線

{@type:filter}

setbarfreq(\"AD\");

condition1=false;

condition2=false;

condition3=false;

if high\<= maxlist(open, close)\*1.01

//狀況1:小紅小黑且上影線很小

then condition1=true;

if (close-low)\> absvalue(open-close)\*2 and (close-low)\>close\*0.02

//狀況2:下影線為實體兩倍以上

then condition2=true;

if highest(high,30)\>close\[1\]\*1.4

//狀況3:近30日來最高點到昨天跌幅超過40%

then condition3=true;

{結果判斷}

IF

condition1

and condition2

and condition3

THEN RET=1;

outputfield(1,high,2,\"K棒高點\", order := -1);

#### 📄 下降趨勢改變

{@type:filter}

input:Length(20); setinputname(1,\"下降趨勢計算期數\");

input:VolLimit(1000); setinputname(2,\"突破量\");

variable: kk(0);

settotalbar(maxlist(length, 5) + 3);

If CurrentBar = 1 then

kk = 0

else

kk = kk\[1\] + (close - close\[1\])/close\[1\] \* Volume;

value1 = linearregslope(kk, Length);

value2 = linearregslope(kk, 5);

IF value1 \< 0 and value2 \> 0 AND VOLUME \> VolLimit then ret=1;

#### 📄 下降趨勢明確

{@type:filter}

input:Length(20,\"期間\"); //\"計算期間\"

settotalbar(20);

LinearReg(close, Length, 0, value1, value2, value3, value4);

//做收盤價20天線性回歸

{value1:斜率,value4:預期值}

value5=rsquare(close,value4,20);

//算收盤價與線性回歸值的R平方

if value1\<0 and value5\>0.2

then ret=1;

#### 📄 做M頭的股票

{@type:filter}

input:day(60,\"計算區間\");//設定計算區間

input:GP(30,\"波段漲幅下限\");//設定波段漲幅下限，單位是%

input:pc(2,\"M頭兩高點價差上限\");//設定M頭兩高點價差上限，單位是%

input:rg(30,\"波段低點到高點的最少天數\");//波段低點到高點的最少天數

input:bc(4,\"M谷底距離頭部最低跌幅\");//M谷底距離頭部最低跌幅，單位是%

value1=highest(high,day);//找出波段最高點

value2=lowest(low,day);//找出波段最低點

value3=nthhighest(2,high,day);//波段第二高點

value4=nthhighestbar(1,high,day);//最高價在距今第幾根bar

value5=nthlowestbar(1,low,day);//最低價在距今第幾根bar

value6=nthhighestbar(2,high,day);//第二價在距今第幾根bar

value7=lowest(low,maxlist(value4,value6));//從第一個M頭以來的最低點

value8=nthlowestbar(1,low,maxlist(value4,value6));//谷底距今第幾根bar

condition1=false;

condition2=false;

condition3=false;

condition4=false;

if value1\>value2\*(1+gp/100) then condition1=true;//波段漲幅超過30%

if value5\>maxlist(value4,value6)+rg then condition2=true;//低點在圖左邊

if value1\<=value3\*(1+pc/100) then
condition3=true;//兩個高點之間的價差不大

if value8\>minlist(value4,value6) and value8\<minlist(value4,value6)

then condition4=true;//谷底在兩頭之間

if condition1 and condition2 and condition3 and condition4

then ret=1;

#### 📄 在上昇趨勢中的股票

{@type:filter}

input:Length(20,\"期間\"); //\"計算期間\"

settotalbar(20);

LinearReg(close, Length, 0, value1, value2, value3, value4);

//做收盤價20天線性回歸

{value1:斜率,value4:預期值}

value5=rsquare(close,value4,20);

//算收盤價與線性回歸值的R平方

if value1\>0 and value5\>0.2

then ret=1;

#### 📄 平台整理後突破

{@type:filter}

setbarfreq(\"AD\");

input:Period(20, \"平台區間\");

input:ratio(10, \"整理幅度(%)\");

input:ratio1(3,\"各高點(低點)間的差異幅度\");

variable:h1(0),h2(0),L1(0),L2(0);

h1=nthhighest(1,high\[1\],period);

h2=nthhighest(4,high\[1\],period);

l1=nthlowest(1,low\[1\],period);

l2=nthlowest(4,low\[1\],period);

if (h1-l1)/l1\<=ratio/100

and (h1-h2)/h2\<=ratio1/100

and (l2-l1)/l1\<=ratio1/100

and close crosses over h1

and close\[period+30\]\*1.1\<h1

and volume\> average(volume,period)

then ret=1;

outputfield(1, h1, 2, \"區間高點\", order := -1);

#### 📄 平台整理後跌破

{@type:filter}

setbarfreq(\"AD\");

input:Period(15, \"平台區間\");

input:ratio(7, \"整理幅度(%)\");

input:ratio1(2,\"各高點(低點)間的差異幅度\");

variable:h1(0),h2(0),L1(0),L2(0);

h1=nthhighest(1,high\[1\],period);

h2=nthhighest(4,high\[1\],period);

l1=nthlowest(1,low\[1\],period);

l2=nthlowest(4,low\[1\],period);

if (h1-l1)/l1\<=ratio/100

and (h1-h2)/h2\<=ratio1/100

and (l2-l1)/l1\<=ratio1/100

and close crosses below l1

and close\[period+30\]\>l1\*1.1

then ret=1;

outputfield(1, l1, 2, \"區間低點\", order := -1);

#### 📄 突破下降旗型

{@type:filter}

input: Length(100); Setinputname(1, \"區間\");

input: UpRatio(2); SetInputName(2, \"當日上漲幅度%\");

input: VolLimit(300); SetInputName(3, \"當日成交量下限\");

variable: hDate(date),day(0),KeyPrice(0),HighPrice(0);

settotalbar(Length + 3);

if high = highest(high,Length) then hDate = date;

day = datediff(date,hdate);

if day =0 and day\[1\] \> 0 then KeyPrice = Close;

if day \>0 and day\[1\] = 0 then HighPrice = High;

if KeyPrice \> 0 and HighPrice \> 0 and day \> 2 and day \<= Length / 2
and

Close \> Open \* (1 + 0.01 \* UpRatio) and

Close \>= highest(High,3) and

volume \> VolLimit and

Close \> KeyPrice and

Close \< HighPrice

then ret=1;

#### 📄 突破整理格局

{@type:filter}

input:limit1(7); setinputname(1,\"定義整理的區間幅度\");

input:limit2(2); setinputname(2,\"定義三個頂點間的差距\");

input:rangemax(30); setinputname(3,\"整理區間最長日期限制\");

input:vollimit(500); setinputname(4,\"突破時成交量最小值\");

variable: period(0);

SetTotalBar(rangemax + 3);

period = 5;

repeat

begin

value1=simplehighest(high\[1\],period);

value2=simplelowest(low\[1\],period);

period=period+1;

end;

until period \>= rangemax or (value1 \> value2 \* (1 + limit1/100));

if period \< rangemax

then

begin

value3=nthhighest(1, high\[1\], period);

value4=nthhighest(3, high\[1\], period);

if value3 \<= value4 \* (1 + limit2/100) and

close crosses over value3 and

volume \> vollimit

then ret=1;

end;

#### 📄 突破箱型

{@type:filter}

input:period(20);

input:rangeratio(10);

variable:h1(0),h2(0),l1(0),l2(0),hd1(0),hd2(0),ld1(0),ld2(0);

h1=nthhighest(1,high,period);

h2=nthhighest(2,high,period);

l1=nthlowest(1,low,period);

l2=nthlowest(2,low,period);

hd1=nthhighestbar(1,high,period);

hd2=nthhighestbar(2,high,period);

ld1=nthlowestbar(1,low,period);

ld2=nthlowestbar(2,low,period);

if absvalue(hd1\[1\]-hd2\[1\])\>=4 and absvalue(ld1\[1\]-ld2\[1\])\>=4

and h1\[1\]-h2\[1\]\<=h1\[1\]\*0.02

and l2\[1\]-l1\[1\]\<=l1\[1\]\*0.02

and h1\[1\]\<=l1\[1\]\*(1+rangeratio/100)

then begin

if close crosses over h1\[1\]

and volume \>=average(volume,period)\*1.3

then ret=1;

end;

#### 📄 突破繼續型態

{@type:filter}

setbarfreq(\"AD\");

variable:iHigh(0); iHigh=maxlist(iHigh,H);

variable:iLow(100000); iLow=minlist(iLow,L);

variable:hitlow(0),hitlowdate(0);

//觸低次觸與最後一次觸低日期

if iLow = Low then begin

hitlow+=1;

hitlowdate =date;

end;

if DateAdd(hitlowdate,\"M\",2) \< Date
and//如果自觸低點那天1個月後都沒有再觸低

iHigh/iLow \< 1.3 and //波動在三成以內

iHigh = High

//來到設定日期以來最高點

then ret =1;

outputfield(1, highest(high\[1\],100), 2, \"前波高點\", order := -1);

#### 📄 突破股票箱

{@type:filter}

input:length(12); setinputname(1, \"股票箱區間長度\");

input:boxrange(10); setinputname(2, \"箱區高低範圍(%)\");

settotalbar(3);

value1=NthHighest(1,high,length);

value3=nthhighest(3,high,length);

value4=Nthlowest(1,low,length);

value5=nthlowest(3,low,length);

if

value1\[1\] \<= 1.03 \* value3\[1\] and

value5\[1\] \<= 1.03 \* value4\[1\] and

value1\[1\] \<= (1 + 0.01 \* boxrange) \* value4\[1\] and

close \> value1\[1\]

then ret=1;

#### 📄 跌勢後的內困三日翻紅

{@type:filter}

setbarfreq(\"AD\");

If close\[4\]=lowest(close,20)

and close\[4\]\*1.2\<=close\[24\]

and open\[3\]\>close\[3\]\*0.01

And close\[2\]\>open\[2\]\*0.01

And close\[1\]\>open\[1\]\*0.01

And close\>high\[4\]

and volume\>average(volume,5)

and average(volume,100)\>=1000

Then

ret=1;

outputfield(1,close\[4\],2,\"前波低點\", order := -1);

#### 📄 近期漲幅不大

{@type:filter}

input:period(20,\"計算區間\");

input:ratio(7,\"最低漲跌幅\");

if close\[period-1\]\<\>0

and (close/close\[period-1\]-1)\*100\<ratio

then ret=1;

outputfield(1,GetField(\"法說會日期\"),0,\"法說會日期\", order := -1);

#### 📄 長時間未破底後創新高

{@type:filter}

setbarfreq(\"AD\");

input:period(90,\"未破底區間\");

input:percent(25,\"盤整區間漲幅上限\");

condition1=false;

condition2=false;

value1=lowest(low,period);

if value1=low\[period-1\]

then condition1=true;

if highest(high\[1\],period)\<=value1\*(1+percent/100)

then condition2=true;

if condition1 and condition2 and close crosses over
highest(close\[1\],period)

then ret=1;

outputfield(1,value1,2,\"前波低點\", order := -1);

#### 📄 長紅

{@type:filter}

if close\>=open\*1.035

then ret=1;

### 4.7 06.籌碼選股 (57 個)

#### 📄 N日以來投信曾大買過

{@type:filter}

input:period(250,\"計算期間\");

input:days(5,\"計算買進的天數\");

input:amount(3000,\"大買的最低張數\");

setbarfreq(\"D\");

settotalbar(period+days);

value1=GetField(\"投信買張\");

value2=summation(value1,days);

if countif(value2\>=amount,period)\>=1

then ret=1;

#### 📄 N日內三大法人曾同步買超

{@type:filter}

input:days(20,\"計算天期\");

setbarfreq(\"D\");

settotalbar(days+1);

value1=GetField(\"外資買賣超\",\"D\");

value2=GetField(\"投信買賣超\",\"D\");

value3=GetField(\"自營商自行買賣買賣超\",\"D\");

condition1=value1\>0 and value2\>0 and value3\>0;

if barslast(condition1)\<days

then ret=1;

#### 📄 不明買盤介入

{@type:filter}

input:period(5); setinputname(1,\"均線期間\");

input:ratio(30); setinputname(2,\"不明買盤比重%\");

settotalbar(period + 7);

value1=GetField(\"法人買張\",\"D\");

value2=GetField(\"資券互抵張數\",\"D\");

value3=GetField(\"散戶買張\",\"D\");

value4=volume - value1 - value2 - value3;

value5=value4\*100/volume; // 不明買盤的比重

value6=average(value5,period);

if value6 crosses over ratio

then ret=1;

SetOutputName1(\"不明買盤比重(%)\");

OutputField1(value5);

#### 📄 主力偷偷調節後下殺

{@type:filter}

setbarfreq(\"AD\");

input:period(10,\"籌碼計算天期\");

Value1=GetField(\"分公司買進家數\",\"D\");

value2=GetField(\"分公司賣出家數\",\"D\");

value3=(value1-value2);

//買進家數減去賣出家數，代表籌碼發散的情況

value4=average(close,5);

//計算發散程度的五日移動平均

if period\<\>0 then begin

if countif(value3\>10, period)/period \>0.6

//區間裡超過六成以上的日子主力都是站在出貨那一邊

and linearregslope(value4,5)\>0

//發散程度之五日移動平均線短期趨勢是向上

then ret=1;

end;

outputfield(1, countif(value3\>10, period), 0, \"出貨天數\", order :=
1);

#### 📄 主力公司派可能出貨中

{@type:filter}

input:Period(5); setinputname(1,\"近期偏弱期間\");

input:Rate1(1000); setinputname(2,\"法人及散戶合計賣出上限\");

input:Rate2(5000); setinputname(3,\"成交量下限\");

input:Ratio(1); setinputname(4,\"接近低點幅度\");

SetTotalBar(3);

if Close \< Close\[Period\] and {近期股價累計為下跌}

Close \< Lowest(Low,Period)\* (1+Ratio/100) and {接近期間低點}

Average(Volume,Period) \> Rate2 {偏弱期間均量大於成交量下限}

then

begin

value1= GetField(\"法人持股\",\"D\") -
GetField(\"法人持股\",\"D\")\[Period\]; {期間法人累計買賣超}

value2= GetField(\"融資餘額張數\",\"D\") -
GetField(\"融資餘額張數\",\"D\")\[Period\] ; {期間融資累計增減}

value3= GetField(\"融券餘額張數\",\"D\") -
GetField(\"融券餘額張數\",\"D\")\[Period\];{期間融券累計增減}

if value1 + value2 -value3 \> Rate1 \* -1 then ret=1;

end;

#### 📄 主力慢慢收集籌碼後攻堅

{@type:filter}

setbarfreq(\"AD\");

input:period(10,\"籌碼計算天期\");

Value1=GetField(\"分公司買進家數\",\"D\");

value2=GetField(\"分公司賣出家數\",\"D\");

value3=(value2-value1);

//賣出的家數比買進家數多的部份

value4=average(close,5);

if period\<\>0 then begin

if countif(value3\>30, period)/period \>0.7

then ret=1;

end;

outputfield(1, countif(value3\>30, period), 0, \"進貨天數\", order :=
1);

#### 📄 主力發動股

{@type:filter}

//成交量 連續 3 日遞減

//股價 \> 20日均線 10%

if volume\<volume\[1\]

and volume\[1\]\<volume\[2\]

and close\>average(close,20)\*1.1

then ret=1;

#### 📄 主力買超超過門檻

{@type:filter}

input: Length(5); setinputname(1,\"計算天數\");

input: limit1(20); setinputname(2,\"買超佔成交量比例\");

variable: r1(0), volTotal(0),ratio(0);

SetTotalBar(3);

r1 = summation(GetField(\"主力買賣超張數\"), Length);

volTotal = summation(Volume, Length);

if voltotal\<\>0 then

begin

ratio = r1 / voltotal \* 100;

if ratio \>= limit1 and average(volume,20) \> 500 then ret=1;

setoutputname1(\"主力買賣超比重(%)\");

outputfield1(ratio);

end;

#### 📄 主力長期收集

{@type:filter}

input:period(60,\"計算區間\");

setbarfreq(\"D\");

settotalbar(period);

value1=GetField(\"分公司買進家數\",\"D\");

value2=GetField(\"分公司賣出家數\",\"D\");

condition1=false;

if countif(value1\<value2,period)\>period/2

then condition1=true;

if condition1

and close\>open\*1.035

and GetField(\"主力買賣超張數\",\"D\")\>0

and summation(GetField(\"主力買賣超張數\",\"D\"),5)\>0

and summation(GetField(\"主力買賣超張數\",\"D\"),20)\>0

and summation(GetField(\"主力買賣超張數\",\"D\"),60)\>0

and summation(GetField(\"主力買賣超張數\",\"D\"),120)\>0

then ret=1;

#### 📄 主流股蓄勢待發

{@type:filter}

input:days(10);

input: FastLength(12, \"DIF短期期數\"), SlowLength(26, \"DIF長期期數\"),
MACDLength(9, \"MACD期數\");

variable: difValue(0), macdValue(0), oscValue(0),Kprice(0);

settotalbar(100);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

if absvalue((average(close,20)-close)/close)\*100\<2

and absvalue((average(close,60)-close)/close)\*100\<2

and close=highest(close,days)

and macdvalue\>macdvalue\[1\]

and macdvalue\>0

and difvalue\>0

then ret=1;

#### 📄 交易家數暴增

{@type:filter}

value1=GetField(\"分公司交易家數\",\"D\");

value2=highest(GetField(\"分公司交易家數\",\"D\")\[1\],20);

if value1-value2\>150

then ret=1;

#### 📄 借券增

{@type:filter}

input:lowlimit(200,\"借券增加張數\");

input:days(3,\"計算天數\");

setbarfreq(\"D\");

settotalbar(3);

value1=GetField(\"借券賣出餘額張數\",\"D\")-GetField(\"借券賣出餘額張數\",\"D\")\[days\];//借券賣出餘額張數增加數

if value1\>=lowlimit

then ret=1;

outputfield(1,value1,\"借券賣出餘額張數增加數\");

#### 📄 借券賣出餘額張數大減

{@type:filter}

input: amount(1000); setinputname(1, \"減少張數\");

SetTotalBar(3);

value1 = GetField(\"借券賣出餘額張數\");

if value1\[1\] - value1 \> amount

then ret=1;

setoutputname1(\"借券賣出減少張數\");

outputfield1(value1\[1\] - value1);

#### 📄 再跌就有斷頭賣壓的股票

{@type:filter}

setbarfreq(\"AD\");

input:period(30, \"波段天期\");

value2=nthhighestbar(1,close,period);//波段高點在第幾根Bar

if GetField(\"融資餘額張數\",\"D\")\>average(volume,5)

//融資餘額大於五日均量

and GetField(\"融資餘額張數\",\"D\")\[value2\]\>10000

//融資餘額大於一萬張

and GetField(\"融資餘額張數\",\"D\")\[value2\]\>10000

//最高點時融資餘額也大於一萬張

and close\*1.2\<=close\[value2\]//波段跌幅超過兩成

then ret=1;

#### 📄 券增價漲

{@type:filter}

input: Length(10); setinputname(1,\"近期天數\");

input: UpRatio(3.5); setinputname(2, \"上漲幅度(%)\");

settotalbar(3);

if RateOfChange(Close, 1) \>= UpRatio and

Getfield(\"融券餘額張數\") \> 0 and

Getfield(\"融券餘額張數\") = highest(Getfield(\"融券餘額張數\"), Length)

then ret=1;

SetOutputName1(\"融券餘額張數\");

OutputField1(Getfield(\"融券餘額張數\"));

#### 📄 券補力道超過一定值

{@type:filter}

value1=GetField(\"融券餘額張數\",\"D\");

input:lowlimit(100,\"券補力道下限\");

if value1/average(volume,5)\*100\>lowlimit

then ret=1;

#### 📄 千張大戶增加而散戶減少

{@type:filter}

setbarfreq(\"W\");

settotalbar(3);

condition1 =
GetField(\"大戶持股人數\",\"W\",param:=1000)\>GetField(\"大戶持股人數\",\"W\",param:=1000)\[1\];

condition2 =
GetField(\"散戶持股人數\",\"W\",param:=400)\<GetField(\"散戶持股人數\",\"W\",param:=400)\[1\];

if condition1 and condition2 then ret=1;

outputfield(1,GetField(\"大戶持股人數\",\"W\",param:=1000),0,\"本週大戶人數\");

outputfield(2,GetField(\"大戶持股人數\",\"W\",param:=1000)\[1\],0,\"上週大戶人數\");

outputfield(3,GetField(\"大戶持股人數\",\"W\",param:=1000)-GetField(\"大戶持股人數\",\"W\",param:=1000)\[1\],0,\"大戶增加數\");

outputfield(4,GetField(\"散戶持股人數\",\"W\",param:=400),0,\"本週散戶人數\");

outputfield(5,GetField(\"散戶持股人數\",\"W\",param:=400)\[1\],0,\"上週散戶人數\");

outputfield(6,GetField(\"散戶持股人數\",\"W\",param:=400)-GetField(\"散戶持股人數\",\"W\",param:=400)\[1\],0,\"散戶減少數\");

#### 📄 千張大戶增持

{@type:filter}

input: ratio(10, \"增加比例%\");

setbarfreq(\"W\");

settotalbar(3);

if GetField(\"大戶持股比例\",\"W\",param:=1000) \>
(GetField(\"大戶持股比例\",\"W\",param:=1000)\[1\] \* (1 + ratio/100))
then ret=1;

outputfield(1, GetField(\"大戶持股比例\",\"W\",param:=1000), 2,
\"大戶比例\");

outputfield(2, GetField(\"大戶持股比例\",\"W\",param:=1000)\[1\], 2,
\"大戶比例\[1\]\");

#### 📄 千張大戶減少而散戶增加

{@type:filter}

setbarfreq(\"W\");

settotalbar(3);

condition1 =
GetField(\"大戶持股人數\",\"W\",param:=1000)\<GetField(\"大戶持股人數\",\"W\",param:=1000)\[1\];

condition2 =
GetField(\"散戶持股人數\",\"W\",param:=400)\>GetField(\"散戶持股人數\",\"W\",param:=400)\[1\];

if condition1 and condition2 then ret=1;

outputfield(1,GetField(\"大戶持股人數\",\"W\",param:=1000),0,\"本週大戶人數\");

outputfield(2,GetField(\"大戶持股人數\",\"W\",param:=1000)\[1\],0,\"上週大戶人數\");

outputfield(3,GetField(\"大戶持股人數\",\"W\",param:=1000)-GetField(\"大戶持股人數\",\"W\",param:=1000)\[1\],0,\"大戶減少數\");

outputfield(4,GetField(\"散戶持股人數\",\"W\",param:=400),0,\"本週散戶人數\");

outputfield(5,GetField(\"散戶持股人數\",\"W\",param:=400)\[1\],0,\"上週散戶人數\");

outputfield(6,GetField(\"散戶持股人數\",\"W\",param:=400)-GetField(\"散戶持股人數\",\"W\",param:=400)\[1\],0,\"散戶增加數\");

#### 📄 增資股即將出籠

{@type:filter}

setbarfreq(\"AD\");

value1=GetField(\"現增新股上市日\");

value2=GetField(\"現增比率\");//每千股可認股數

value3=GetField(\"現增價格\");

value4=GetField(\"融券餘額張數\",\"D\");

value5=GetField(\"普通股股本\",\"Q\");//單位:億

if value1\>date and datediff(value1,date)\<10//增資股快上市了

and value5\*10000\*value2/1000\>2000//增資張數大於5000張

and value4\[30\]\>value4-1000//近一個月融券增加沒有超過1000張

and value3\*1.1\<close//股價仍比現增價格高超過一成

then ret=1;

outputfield(1,value1,0,\"新股上市日\", order := -1);

outputfield(2,value2,2,\"現增比率\");

outputfield(3,close-value3,2,\"現增價差\");

#### 📄 外資完全不碰的股票有人在收籌碼

{@type:filter}

input: period(5); setinputname(1, \"計算期間\");

input: investorLimit(2000); setinputname(2, \"外資持股上限\");

input: ratio(50); setinputname(3, \"主力買張比重(%)\");

input: volLimit(500); setinputname(4, \"成交均量下限\");

SetTotalBar(3);

// 主力買張比重

value1 = summation(GetField(\"主力買張\",\"D\"), period);

value2 = summation(volume, period);

value3 = value1 / value2 \* 100;

if GetField(\"外資持股\",\"D\") \< investorLimit and value3 \> ratio and
value2 \> volLimit \* period

then ret=1;

SetOutputName1(\"主力買張比重(%)\");

OutputField1(value3);

#### 📄 外資拉抬

{@type:filter}

input: Length(10); setinputname(1,\"計算天數\");

input: UpRatio(3.5); setinputname(2, \"上漲幅度(%)\");

input: VolumeRatio(5); setinputname(3, \"買超佔比例(%)\");

variable: SumForce(0);

variable: SumTotalVolume(0);

settotalbar(3);

if RateOfChange(Close, 1) \>= UpRatio then

begin

SumTotalVolume = Summation(volume, Length);

SumForce = Summation(GetField(\"外資買賣超\"), Length);

if SumForce \> SumTotalVolume \* VolumeRatio / 100 then ret =1;

end;

SetOutputName1(\"外資累計買超張數\");

OutputField1(SumForce);

#### 📄 外資由空翻多

{@type:filter}

setbarfreq(\"D\");

settotalbar(3);

if summation(GetField(\"外資買賣超\",\"D\"),20)\<0

and trueall(GetField(\"外資買賣超\",\"D\")\>200,3)

then ret=1;

#### 📄 外資買超後隔天會漲的機率很高的股票

{@type:filter}

input:n(500,\"樣本數\");

settotalbar(n);

value1=GetField(\"外資買賣超\",\"D\");

variable:x1(0),y(0),c1(0),c2(0),c3(0);

if value1\[1\]\>200

then begin

x1=1;

c1=c1+1;

//外資買超的次數

end

else x1=0;

if close\>open

then begin

y=1;

c2=c2+1;

//上漲的次數

end

else y=0;

if value1\[1\]\>200

and close\>open

then c3=c3+1;

//上漲且外資買超的次數

value2=c1/n; //外資買超的機率

value3=c2/n; //上漲的機率

value4=c3/c2;//收紅且外資買超的機率

value5=value4\*value3/value2;

if countif(value1\[1\]\>200,n)\>20

then ret=1;

outputfield(1,value5\*100,0,\"外資前一日買超隔天收高的機率\");

outputfield(2,c1,0,\"上漲次數\");

outputfield(3,c2,\"外資買超次數\");

outputfield(4,c3,0,\"上漲且外資買超\");

#### 📄 大跌後法人散戶清浮額

{@type:filter}

input:period(10); setinputname(1,\"計算跌幅區間\");

input:percent1(10); setinputname(2,\"區間最小跌幅\");

settotalbar(3);

value1=GetField(\"法人買賣超張數\");

value2=GetField(\"融資增減張數\");

if close\[period-1\] \>= close\*(1+percent1/100) and

value1 \< 0 and

value2 \< 0 and

close \> close\[1\]

then ret=1;

#### 📄 官股買超比重

{@type:filter}

input: lowlimit(30, \"官股買超比重(%)\");

value1 = getfield(\"官股券商買賣超張數\", \"D\");

if value1 \> 0 then begin

value2 = value1 \* 100 / volume;

if value2 \>= lowlimit then ret=1;

end;

#### 📄 投信從空手到開始佈局

{@type:filter}

input: r1(500); setinputname(1,\"先前買超上限張數\");

input: r2(5000); setinputname(2,\"近一日買超金額下限(萬元)\");

input: length(20); setinputname(3,\"投信布局天數\");

setTotalBar(3);

if trueall(GetField(\"投信買賣超\",\"D\")\[1\] \< r1, length) and

GetField(\"投信買賣超\",\"D\") \* close \> r2 \* 10

then ret=1;

SetOutputName1(\"投信買賣超(張)\");

OutputField1(GetField(\"投信買賣超\",\"D\"));

#### 📄 投信拉抬

{@type:filter}

input: Length(10); setinputname(1,\"計算天數\");

input: UpRatio(3.5); setinputname(2, \"上漲幅度(%)\");

input: VolumeRatio(5); setinputname(3, \"買超佔比例(%)\");

variable: SumForce(0);

variable: SumTotalVolume(0);

settotalbar(3);

if RateOfChange(Close, 1) \>= UpRatio then

begin

SumTotalVolume = Summation(volume, Length);

SumForce = Summation(GetField(\"投信買賣超\"), Length);

if SumForce \> SumTotalVolume \* VolumeRatio / 100 then ret =1;

end;

SetOutputName1(\"投信累計買超張數\");

OutputField1(SumForce);

#### 📄 投信持股從無到有

{@type:filter}

input: v1(2000); setinputname(1, \"投信估計持股上限(張)\");

input: v2(300); setinputname(2, \"近一日買賣超(張)\");

value1=GetField(\"投信持股\",\"D\");

value2=GetField(\"投信買賣超\",\"D\");

if value1 \< v1 and value2 \> v2

then ret=1;

SetOutputName1(\"投信買賣超(張)\");

OutputField1(value2);

#### 📄 投信掃貨

{@type:filter}

input: pastDays(5); setinputname(1,\"計算天數\");

input: \_BuyRatio(10); setinputname(2,\"買超佔比例(%)\");

variable: SumForce(0);

variable: SumTotalVolume(0);

SetTotalBar(3);

SumForce = Summation(GetField(\"投信買賣超\"), pastDays);

sumTotalVolume = Summation(Volume, pastDays);

value1 = SumForce / SumTotalVolume \* 100;

if value1 \> \_BuyRatio then ret =1;

SetOutputName1(\"買超佔比例(%)\");

OutputField1(value1);

#### 📄 投信爭買的小型成長股

{@type:filter}

input: miniratio(10); setinputname(1,\"投信買進佔今日總量%\");

input: lv(5000); setinputname(2,\"投信持股張數上限\");

input: holdratio(10); setinputname(3,\"投信持股比例上限%\");

SetTotalBar(3);

value1=GetField(\"投信買張\"); //投信買張

value2=GetField(\"投信持股\"); //投信持股

value3=GetField(\"投信持股比例\"); //投信持股比例

if

value1 \> volume \* miniratio\*0.01 and //買進張數/成交量 \>= minratio

value2 \< lv and //原來庫存低

value3 \< holdratio and //原來庫存低

GetField(\"公司類別\",\"M\") = \"小型股\" //小型股

then ret=1;

SetOutputName1(\"投信買張\");

OutputField1(value1);

#### 📄 投信第一天大買進

{@type:filter}

value1=GetField(\"最新股本\");//單位:億

value2=GetField(\"投信買張\",\"D\");

value3=value2\*close/10; //單位:萬}

condition1=value3\>200 and value1\<80;

condition2=filter(condition1,5);

if condition2

then ret=1;

#### 📄 散戶買進比例上揚

{@type:filter}

Input: r1(50); setinputname(1, \"散戶買進比例下限(%)\");

Input: r2(500); setinputname(2, \"五日均量下限(張)\");

SetTotalBar(28);

value1=GetField(\"散戶買張\");

value2=value1/volume\*100; // 散戶買張比例

value3=average(value2,5); // 短期散戶比例

value4=average(value2,20); // 長期散戶比例

if value2 \> r1 and

value3 crosses above value4 and

average(volume,5) \> r2

then ret=1;

SetOutputName1(\"散戶買進比例(%)\");

OutputField1(value2);

#### 📄 斷頭後的止跌

{@type:filter}

input:Length(4); setinputname(1,\"計算區間\");

input:DVOL(3000); setinputname(2,\"區間融資減少張數\");

input:R1(30); setinputname(3,\"區間跌幅(%)\");

SetTotalBar(3);

if Close \> Close\[1\] and

RateOfChange(Close, Length) \< -1 \* R1 and

GetField(\"融資餘額張數\")\[Length\] - GetField(\"融資餘額張數\") \>
DVOL

then ret=1;

#### 📄 法人主力敢買又敢拉的股票

{@type:filter}

value1=GetField(\"法人買賣超張數\");

value2=GetField(\"主力買賣超張數\");

value3=value1+value2;

value4=GetField(\"內外盤比\",\"D\");//外盤量/內盤量\*100

condition1=false;

condition2=false;

condition3=false;

if countif(value3\>300,5)\>=4 or countif(value3\>300,4)\>=3

then condition1=true;

if value3\>volume\*0.3 and value4\>50

then condition2=true;

if high\<=close\*1.02

then condition3=true;

if condition1 and condition2 and condition3

then ret=1;

#### 📄 法人大出籌碼

{@type:filter}

input:r1(45);

setinputname(1,\"法人賣出佔成交量比例下限%\");

value1=GetField(\"外資賣張\",\"D\");

value2=GetField(\"投信賣張\",\"D\");

value3=GetField(\"自營商賣張\",\"D\");

if volume\<\>0 then

value4=(value1+value2+value3)/volume;

if value4\*100\>r1

then ret=1;

#### 📄 法人大買而股價尚未發動

{@type:filter}

input:day(10); setinputname(1,\"連續買超天數\");

input:amount(100); setinputname(2,\"每日至少買超張數(張)\");

input:percent1(3); setinputname(3,\"漲幅上限(%)\");

SetTotalBar(3);

if trueall(GetField(\"法人買賣超張數\") \> amount, day) and

RateOfChange(Close, day) \< percent1

then ret=1;

#### 📄 法人淨買超比例高

{@type:filter}

input:ratio(30); setinputname(1,\"比例下限(%)\");

input:period(3); setinputname(2,\"計算區間\");

input:volLimit(1000); setinputname(3,\"成交量下限(張)\");

settotalbar(3);

value1 = Summation(Volume - GetField(\"資券互抵張數\"), period);

value2 = Summation(GetField(\"法人買賣超張數\"), period);

value3 = value2 / value1 \* 100;

if value3 \> ratio and volume \> volLimit then

ret = 1;

SetOutputName1(\"近日法人淨買超比例(%)\");

OutputField1(value3);

#### 📄 法人買超

{@type:filter}

input: Length(10); setinputname(1,\"計算天數\");

input: UpRatio(3.5); setinputname(2, \"上漲幅度(%)\");

input: VolumeRatio(5); setinputname(3, \"買超佔比例(%)\");

variable: SumForce(0);

variable: SumTotalVolume(0);

settotalbar(3);

if RateOfChange(Close, 1) \>= UpRatio then

begin

SumTotalVolume = Summation(volume, Length);

SumForce = Summation(GetField(\"法人買賣超張數\"), Length);

if SumForce \> SumTotalVolume \* VolumeRatio / 100 then ret =1;

end;

SetOutputName1(\"三大法人累計買超張數\");

OutputField1(SumForce);

#### 📄 法人買超減融資佔成交量比重增加

{@type:filter}

input: r1(15); setinputname(1,\"籌碼收集比例(%)\");

input: volLimit(1000); setinputname(2,\"成交量下限(張)\");

settotalbar(3);

value1 = (GetField(\"法人買賣超張數\") - GetField(\"融資買進張數\")) /
Volume \* 100;

if value1 \> r1 and volume \> volLimit then

ret = 1;

setoutputname1(\"法人籌碼收集比例(%)\");

outputfield1(value1);

#### 📄 法人買進佔成交量超過25%

{@type:filter}

input:r1(45);

setinputname(1,\"法人買進佔成交量比例下限%\");

value1=GetField(\"外資買張\",\"D\");

value2=GetField(\"投信買張\",\"D\");

value3=GetField(\"自營商買張\",\"D\");

if volume\<\>0 then

value4=(value1+value2+value3)/volume;

if value4\*100\>r1

then ret=1;

#### 📄 法人逢低買超破億元

{@type:filter}

input:day(5,\"計算期別\");

input:lowlimit(1,\"單位:億元\");

setbarfreq(\"D\");

settotalbar(day);

value1=GetField(\"法人買賣超張數\",\"D\");

value2=summation(value1,day);

value3=value1\*value2/10000;

if value3\>=1

and close\*1.1\<close\[30\]

then ret=1;

#### 📄 法人連續買進達一定標準

{@type:filter}

input:day(5); setinputname(1,\"計算天數\");

input:ratio1(40); setinputname(2,\"法人買進張數比例下限(%)\");

input:times(2); setinputname(3,\"達標天數\");

input:volLimit(500); setinputname(4,\"最小成交均量\");

SetTotalBar(day + 3);

value1 = (GetField(\"外資買張\") + GetField(\"投信買張\"))/Volume \*
100;

value2 = countif(value1 \> ratio1, day);

if value2 \>= times and average(volume, day) \> volLimit then

ret = 1;

SetOutputName1(\"近日法人買進比例(%)\");

OutputField1(value1);

#### 📄 流通在外股數不多

{@type:filter}

value1=GetField(\"最新股本\");//單位:億

value2=GetField(\"董監持股佔股本比例\",\"D\");

value3=GetField(\"法人持股比例\",\"D\");

if value1\*(1-value2/100-value3/100)\<50

then ret=1;

#### 📄 籌碼安定比率

{@type:filter}

input:r1(60); setinputname(1,\"投信外資及董監合計持股比例下限(%)\");

SetTotalBar(3);

value1=GetField(\"投信持股比例\",\"D\");

value2=GetField(\"外資持股比例\",\"D\");

value3=GetField(\"董監持股佔股本比例\",\"D\");

value4=value1+value2+value3;

if value4 \> r1

then ret=1;

#### 📄 籌碼從散戶手裡被收集

{@type:filter}

input:ratio(200); setinputname(1,\"控盤者買張除以散戶買張的比例(%)\");

input:volLimit(2000); setinputname(2,\"成交量下限(張)\");

settotalbar(3);

value1=GetField(\"控盤者買張\");

value2=GetField(\"散戶買張\");

value3=value1/value2 \* 100;

if volume \> volLimit and value3 \> ratio and value3\[1\] \> ratio

then ret=1;

#### 📄 籌碼被發散

{@type:filter}

setbarfreq(\"AD\");

input:period(10, \"天期\");

value1=GetField(\"分公司賣出家數\");

value2=GetField(\"分公司買進家數\");

if linearregslope(value1,period)\<0

//賣出的家數愈來愈少

and linearregslope(value2,period)\>0

//買進的家數愈來愈多

and value2\>300

and close\>close\[period\]\*1.05

//但這段期間股價在漲

and close\>close\[1\]\*1.025

//今天又漲超過2.5%

then ret=1;

outputfield(1,value2,0,\"買進家數\", order := 1);

outputfield(2,value1,0,\"賣出家數\");

#### 📄 籌碼集中度超過兩成的股票

{@type:filter}

input:day(10,\"天數\");

input:ratio(20,\"最低百分比\");

setbarfreq(\"D\");

settotalbar(day+3);

value1=GetField(\"主力買賣超張數\",\"D\");

if volume\<\>0 then

value2=summation(value1,day)/summation(volume,day)\*100;

if value2\>=ratio then

ret=1;

outputfield(1,value2,0,\"籌碼集中度\");

#### 📄 股價突破外資成本線

{@type:filter}

Input: period(20, \"期間(天)\");

variable: avg_b(0);

setbarfreq(\"D\");

settotalbar(period+7);

if GetField(\"Volume\") \> 0 then

Value5 =
GetField(\"外資買張\")\*GetField(\"成交金額\")\*100000/GetField(\"Volume\")

else

Value5 = 0;

Value1 = summation(Value5, period);

Value2 = summation(GetField(\"外資買張\"), period);

if Value2 \> 0 then avg_b = Value1 / Value2;

if close cross over avg_b then ret=1;

#### 📄 股價突破投信成本線

{@type:filter}

Input: period(20, \"期間(天)\");

variable: avg_b(0);

settotalbar(period + 5);

if GetField(\"Volume\") \> 0 then

Value5 =
GetField(\"投信買張\")\*GetField(\"成交金額(元)\")/(GetField(\"Volume\")\*1000)

else

Value5 = 0;

Value1 = summation(Value5, period);

Value2 = summation(GetField(\"投信買張\"), period);

if Value2 \> 0 and Value2 \<\> Value2\[1\] then avg_b = Value1 / Value2;

if close cross over avg_b then ret=1;

#### 📄 自營商拉抬

{@type:filter}

//

//

input: Length(10); setinputname(1,\"計算天數\");

input: UpRatio(3.5); setinputname(2, \"上漲幅度(%)\");

input: VolumeRatio(5); setinputname(3, \"買超佔比例(%)\");

variable: SumForce(0);

variable: SumTotalVolume(0);

settotalbar(3);

if RateOfChange(Close, 1) \>= UpRatio then

begin

SumTotalVolume = Summation(volume, Length);

SumForce = Summation(GetField(\"自營商買賣超\"), Length);

if SumForce \> SumTotalVolume \* VolumeRatio / 100 then ret =1;

end;

SetOutputName1(\"自營商累計買超張數\");

OutputField1(SumForce);

#### 📄 融資大減後轉強

{@type:filter}

input: period(80); setinputname(1, \"計算區間\");

input: v1(3000); setinputname(2, \"融資減少張數\");

SetTotalBar(3);

value1 = highestbar(close,period);

value2 = GetField(\"融資餘額張數\")\[value1\] -
GetField(\"融資餘額張數\");

if value2 \> v1 and

trueall(close \> close\[1\],3)

then ret=1;

SetOutputName1(\"融資減少張數\");

OutputField1(value2);

#### 📄 融資追捧

{@type:filter}

input: Length(10); setinputname(1,\"近期天數\");

input: UpRatio(3.5); setinputname(2, \"上漲幅度(%)\");

settotalbar(3);

if RateOfChange(Close, 1) \>= UpRatio and

Getfield(\"融資餘額張數\") \> 0 and

Getfield(\"融資餘額張數\") = highest(Getfield(\"融資餘額張數\"), Length)

then ret=1;

SetOutputName1(\"融資餘額張數\");

OutputField1(Getfield(\"融資餘額張數\"));

#### 📄 近N日主力合計買超大於M張

{@type:filter}

value1=GetField(\"主力買賣超張數\",\"D\");

input:days(5,\"計算天期\");

input:lowmit(200,\"買超最低張數\");

if summation(value1,days)\>=lowmit

then ret=1;

#### 📄 連續兩日籌碼在收集

{@type:filter}

value1=GetField(\"分公司買進家數\",\"D\");

value2=GetField(\"分公司賣出家數\",\"D\");

value3=value2-value1;

if trueall(value3\>30,2)

then ret=1;

#### 📄 連續大戶進散戶出

{@type:filter}

input: periods(3, \"連續期別\");

setbarfreq(\"W\");

settotalbar(periods+2);

condition1 = trueall(getfield(\"大戶持股比例\", \"W\", param:=1000) \>
getfield(\"大戶持股比例\", \"W\", param:=1000)\[1\], periods);

condition2 = trueall(getfield(\"散戶持股比例\", \"W\", param:=400) \<
getfield(\"散戶持股比例\", \"W\", param:=400)\[1\], periods);

ret= condition1 and condition2;

outputfield(1, getfield(\"大戶持股比例\", \"W\", param:=1000), 2,
\"大戶比例\");

outputfield(2, getfield(\"散戶持股比例\", \"W\", param:=400), 2,
\"散戶比例\");

#### 📄 集保張數減少中

{@type:filter}

input: n(3); setinputname(1, \"計算期間(週)\");

input: Amount(1000); setinputname(2, \"減少張數(張)\");

SetTotalBar(3);

// 單位=萬張

Value1 = (GetField(\"集保張數\",\"W\")\[n\] -
GetField(\"集保張數\",\"W\")) \* 10000;

if Value1 \> Amount then

ret = 1;

setoutputname1(\"減少張數(張)\");

OutputField1(Value1);

### 4.8 07.月營收選股 (18 個)

#### 📄 可預期的營收成長股

{@type:filter}

// 找出過去幾年這個月的營收都會成長的股票

//

input: years(3, \"過去N年\");

input: growrate(10, \"YOY成長%\");

variable: mm(0);

variable: count(0);

variable: idx(0);

settotalbar(1);

// 最新一期營收月份

//

mm = Month(getfielddate(\"月營收\", \"M\"));

// 下一期營收月份

mm = mm + 1;

if mm \> 12 then mm = 1;

while count \< years begin

if Month(getfielddate(\"月營收\", \"M\")\[idx\]) = mm then begin

// 看同月份的營收YOY是否符合標準, 不符合的話就不用再找了

if getfield(\"月營收年增率\", \"M\")\[idx\] \< growrate then return;

count = count + 1;

end;

idx = idx + 1;

end;

ret = 1;

#### 📄 旺季不旺

{@type:filter}

input:r1(5,\"過去幾年月營收單月成長幅度下限%\");

setbarfreq(\"M\");

settotalbar(3);

value1=GetField(\"月營收月增率\",\"M\");

value2=GetField(\"月營收月增率\",\"M\")\[12\];

value3=GetField(\"月營收月增率\",\"M\")\[24\];

value4=GetField(\"月營收月增率\",\"M\")\[36\];

value5=(value2+value3+value4)/3;

if value2 \> r1 and value3 \> r1 and value4 \> r1 and value1 \< value5

then ret=1;

#### 📄 最近三個月營收明顯成長

{@type:filter}

settotalbar(3);

value1=GetField(\"月營收月增率\",\"M\");

value2=GetField(\"月營收年增率\",\"M\");

condition1=false;

condition2=false;

if average(value1,3)\>10 and average(value2,3)\>10

and value1\>value1\[1\]

and value2\>value2\[1\]

then condition1=true;

if trueall(value1\>5 and value2\>5,3)

then condition2=true;

if condition1 and condition2 then ret=1;

outputfield(1,value1,1,\"月營收月增率\");

outputfield(2,value1\[1\],1,\"上個月營收月增率\");

outputfield(3,value2,1,\"月營收年增率\");

outputfield(4,value2\[1\],1,\"上個月營收年增率\");

#### 📄 月營收YOYN月移動平均大於X

{@type:filter}

input:lowlimit(10,\"年增率下限\");

input:period(12,\"移動平均線的期別\");

if average(GetField(\"月營收年增率\",\"M\"),period) \>= lowlimit

then ret=1;

#### 📄 月營收出現死亡交叉

{@type:filter}

input:shortterm(4);

input:longterm(12);

setinputname(1,\"短期均線\");

setinputname(2,\"長期均線\");

if average(GetField(\"月營收\",\"M\"),shortterm)\*1.1

\< average(GetField(\"月營收\",\"M\"),longterm)

then ret=1;

#### 📄 月營收創新低

{@type:filter}

input:period(36, \"期別\");

settotalbar(period + 5);

value1=GetField(\"月營收\",\"M\");

value2=lowest(GetField(\"月營收\",\"M\"),period);

if value1=value2

and value1\[1\]=value2\[1\]

then ret=1;

outputfield(1, value1,2,\"月營收(億)\", order := 1);

#### 📄 月營收創新高股價離高點有些距離

{@type:filter}

value1=highest(getfield(\"月營收\",\"M\"),48);

value2=highest(GetField(\"總市值\",\"D\"),500);

if getfield(\"月營收\",\"M\")=value1

and value2\>GetField(\"總市值\",\"D\")\*1.2

then ret=1;

#### 📄 月營收大成長的公司

{@type:filter}

input:lowlimit(20);//單位:%

variable:FEPS(0);

setinputname(1,\"成長百分比\");

value1=GetField(\"月營收\",\"M\");//億

value2=GetField(\"營業利益率\",\"Q\");

value3=value1\*12\*value2/100;

value4=GetField(\"最新股本\");//億

FEPS=value3/value4\*10;

if feps\<\>0 then value5=close/feps;

condition1 = value5\<12 and value5\>0;

value6=GetField(\"月營收月增率\",\"M\");

value7=GetField(\"月營收年增率\",\"M\");

condition2 = value6\>=lowlimit and value7\>=lowlimit and value6\[1\]\>0;

if condition1 and condition2 then ret=1;

setoutputname1(\"用月營收預估的本業EPS\");

outputfield1(FEPS);

setoutputname2(\"用月營收預估的本益比\");

outputfield2(value5);

#### 📄 月營收年增率移動平均黃金交叉

{@type:filter}

value1=GetField(\"月營收年增率\",\"M\");

if average(value1,4) crosses over average(value1,12)

and value1 \> 0

then ret=1;

outputfield(1,value1,2,\"月營收年增率%\", order := 1);

#### 📄 月營收成長動能加快

{@type:filter}

setbarfreq(\"M\");

value1=average(GetField(\"月營收年增率\",\"M\"),3);

//月營收年增率三個月平均

value2=average(GetField(\"月營收年增率\",\"M\"),12);

//月營收年增率十二個月平均

if value1 crosses over value2

//黃金交叉

and value1\>5

and value1-value2\>5

and value2\>=1

then ret=1;

outputfield(1,value1,0,\"3個月平均\");

outputfield(2,value2,0,\"12個月平均\");

outputfield(3,(close-close\[1\])/close\[1\]\*100,1,\"本月漲跌幅\");

#### 📄 營收再起飛

{@type:filter}

//input:TXT(\"僅適用月線\"); setinputname(1,\"使用限制\");

setbarfreq(\"M\");

If barfreq \<\> \"M\" then raiseruntimeerror(\"頻率設定有誤\");

settotalbar(23);

value1=GetField(\"月營收年增率\",\"M\");

value2=average(GetField(\"月營收年增率\",\"M\"), 3);

value3=linearregslope(value2,20);

value4=linearregslope(value2,5);

if value3 \< 0 and value4 crosses above 0

then ret=1;

#### 📄 營收年增率由負轉正，且至少連續3個月

{@type:filter}

value1=GetField(\"月營收年增率\",\"M\");

input:period(3);

if trueall(value1\>0,period) and value1\[3\]\<0

then ret=1;

#### 📄 營收月增率優於平均

{@type:filter}

value1=GetField(\"月營收月增率\",\"M\");

value2=average(GetField(\"月營收月增率\",\"M\"),36);

if value1\>10

and value1\>value2\*1.3

then ret=1;

#### 📄 營收月增率比歷年突出

{@type:filter}

input:r1(5);
setinputname(1,\"月營收月增幅與過往三年的數字增加百分比(%)\");

//input:TXT(\"僅適用月線\"); setinputname(2,\"使用限制\");

setbarfreq(\"M\");

If barfreq \<\> \"M\" then raiseruntimeerror(\"頻率設定有誤\");

value1 = GetField(\"月營收月增率\",\"M\");

value2 = average(GetField(\"月營收月增率\",\"M\"),3);

value3 = average(GetField(\"月營收月增率\",\"M\")\[12\],3);

value4 = average(GetField(\"月營收月增率\",\"M\")\[24\],3);

value5 = average(GetField(\"月營收月增率\",\"M\")\[36\],3);

value6 = (value3 + value4 + value5) / 3;

if (value2 - value6) \> r1 then

ret = 1;

SetOutputName1(\"近3月月營收增幅平均\");

OutputField1(value2);

#### 📄 營收高於預期

{@type:filter}

input: r1(10); setinputname(1, \"月營收年增率增加幅度下限(%)\");

//input:TXT(\"僅適用月線\"); setinputname(2,\"使用限制\");

setbarfreq(\"M\");

If barfreq \<\> \"M\" then raiseruntimeerror(\"頻率設定有誤\");

settotalbar(3);

value1=GetField(\"月營收年增率\",\"M\");

value2=average(GetField(\"月營收年增率\",\"M\")\[1\],3);

if value1-value2 \> r1

then ret=1;

setoutputname1(\"月營收年增率(%)\");

outputfield1(value1);

#### 📄 營運趨緩

{@type:filter}

input: months(24); setinputname(1, \"月營收計算期間(月)\");

input: quarters(16);setinputname(2, \"營業毛利率計算期間(季)\");

settotalbar(3);

value1=GetField(\"月營收年增率\",\"M\");

value2=GetField(\"營業毛利率\",\"Q\");

if value1 = lowest(GetField(\"月營收年增率\",\"M\"), months) and

value2 = lowest(GetField(\"營業毛利率\",\"Q\"), quarters) then

ret = 1;

#### 📄 累計月營收年增率連續N月成長

{@type:filter}

input:period(6,\"計算區間\");

settotalbar(period+1);

value1=GetField(\"累計營收年增率\",\"M\");

if trueall(value1\>value1\[1\],period)

then ret=1;

#### 📄 累計營收年增率黃金交叉

{@type:filter}

value1=GetField(\"累計營收年增率\",\"M\");

input: r1(3),r2(12);

setinputname(1,\"短天期\");

setinputname(2,\"長天期\");

if average(value1,r1) crosses over average(value1,r2)+5

and value1\>10

then ret=1;

### 4.9 08.財報選股 (74 個)

#### 📄 N年平均盈餘本益比

{@type:filter}

input:r1(10); setinputname(1,\"本益比上限\");

input:years(8); setinputname(2,\"計算期間(年)\");

settotalbar(3);

value1=GetField(\"最新股本\"); //單位=億元

value2=GetField(\"本期稅後淨利\",\"Y\"); //單位=百萬元

value3=average(GetField(\"本期稅後淨利\",\"Y\"), years); //稅後淨利平均

value4=value3/(value1\*10); //每股盈餘

value6=GetField(\"收盤價\",\"D\");

if value4 \> 0 then

begin

value5 = GetField(\"收盤價\",\"D\") / value4;

if value5 \< r1 then ret = 1;

SetOutputName1(\"平均盈餘本益比\");

OutputField1(value5);

end;

#### 📄 N年累計營業利益市值比

{@type:filter}

input:r1(50); setinputname(1,\"累計營業利益佔總市值比例(%)\");

input:years(10); setinputname(2,\"計算期間(年)\");

settotalbar(3);

value1=GetField(\"總市值\",\"D\"); //單位億

value2=summation(GetField(\"營業利益\",\"y\"),years);

value3=value2/value1; //單位=百分比

if value3 \< r1

then ret=1;

setoutputname1(\"累計營業利益佔市值比例(%)\");

outputfield1(value3);

#### 📄 PB來到近年來低點

{@type:filter}

input:r1(10); setinputname(1,\"PB距離N個月來低點只剩N%\");

input:r2(60); setinputname(2,\"N個月以來\");

//input:TXT(\"僅適用月資料\"); setinputname(3,\"使用限制\");

setbarfreq(\"M\");

if barfreq \<\> \"M\" then raiseruntimeerror(\"頻率錯誤\");

settotalbar(3);

value1=GetField(\"股價淨值比\",\"M\");

value2=lowest(GetField(\"股價淨值比\",\"M\"),r2);

value3=average(GetField(\"股價淨值比\",\"M\"),r2);

if value1 \< value3 and value1 \< value2\*(1+r1/100)

then ret=1;

setoutputname1(\"股價淨值比\");

outputfield1(value1);

#### 📄 PEG指標

{@type:filter}

input:r1(1); setinputname(1,\"PEG上限\");

settotalbar(3);

// PEG指標

//

value1 = GetField(\"本益比\",\"D\");

value2 = GetField(\"月營收年增率\",\"M\");

if value1 \> 0 and value2 \> 0 and value1 / value2 \< r1 then

ret=1;

SetOutputName1(\"PEG指標\");

OutputField1(value1 / value2);

#### 📄 ROE漸入佳境

{@type:filter}

value1=GetField(\"股東權益報酬率\",\"Q\");

if
GetField(\"股東權益報酬率\",\"Q\")\>GetField(\"股東權益報酬率\",\"Q\")\[1\]

and
GetField(\"股東權益報酬率\",\"Q\")\>GetField(\"股東權益報酬率\",\"Q\")\[4\]

then ret=1;

#### 📄 上一季本業賺錢

{@type:filter}

value1=GetField(\"營業利益率\",\"Q\");

if value1\>0

then ret=1;

#### 📄 上市股可以發行權證的流動性條件

{@type:filter}

{

1\. 市值超過100億元

2\. (a or b)

a\. 最近3個月成交股數佔已發行股份總額比例達20%以上。

b\. 最近三個月月平均成交股數達1億股以上。

3\. 最近期經會計師查核或核閱之財務報告無虧損

}

settotalbar(3);

// 近三個月成交股數佔以發行股份比例

//

Value1 = Summation(GetField(\"成交量\", \"M\"), 3) \* 100 /
(GetField(\"發行張數\",\"D\") \* 10000);

// 最近三個月月平均成交股數

//

Value2 = Average(GetField(\"成交量\", \"M\"), 3) \* 1000;

if GetField(\"總市值\",\"D\") \>= 100 and

(Value1 \>= 20 or Value2 \>= 10000000) and

GetField(\"每股稅後淨利(元)\",\"Q\") \> 0

then

Ret = 1;

#### 📄 上櫃股可以發行權證的流動性條件

{@type:filter}

{

1\. 市值超過40億元

2\. (a or b)

a\. 最近3個月成交股數佔已發行股份總額比例達10%以上。

b\. 最近三個月月平均成交股數達3000萬股以上。

3\. 最近期經會計師查核或核閱之財務報告無虧損

}

settotalbar(3);

// 近三個月成交股數佔以發行股份比例

//

Value1 = Summation(GetField(\"成交量\", \"M\"), 3) \* 100 /
(GetField(\"發行張數\",\"D\") \* 10000);

// 最近三個月月平均成交股數

//

Value2 = Average(GetField(\"成交量\", \"M\"), 3) \* 1000;

if GetField(\"總市值\",\"D\") \>= 40 and

(Value1 \> 10 or Value2 \> 3000000) and

GetField(\"每股稅後淨利(元)\",\"Q\") \> 0

then

Ret = 1;

#### 📄 五年內有至少三年營收成長

{@type:filter}

value1=GetField(\"營業收入淨額\",\"Y\");

value2=value1-value1\[1\];

if countif(value2\>0,5)\>=3

then ret=1;

#### 📄 企業價值除以自由現金流的倍數低於一水準

{@type:filter}

input: t1(4,\"倍數\");

setbarfreq(\"Q\");

settotalbar(4);

value1=GetField(\"企業價值\",\"Q\");//單位百萬

value2=GetField(\"來自營運之現金流量\",\"Q\");//單位百萬

value3=GetField(\"資本支出金額\",\"Q\");//單位百萬

value4=GetField(\"所得稅費用\",\"Q\");//單位百萬

value5=GetField(\"利息支出\",\"Q\");//單位百萬

value6=value2-value3-value4-value5;

//自由現金流量 = 營運現金流量 - 資本支出 - 利息 - 稅金

value7=summation(value6,4);

//最近四期現金流量

if value1\<t1\*value7 then ret=1;

outputfield(1,value1,0,\"企業價值\");

outputfield(2,value7,0,\"近四季自由現金流合計\");

#### 📄 低修正型股價淨值比

{@type:filter}

input:r1(1); setinputname(1,\"股價淨值比上限\");

SetTotalBar(3);

value1 = average(GetField(\"營業利益成長率\", \"Y\"), 6); //
近六年平均營業利益成長率

value2 = GetField(\"每股淨值(元)\",\"Q\") \* (1 + value1/100); //
修正後每股淨值

value3 = close / value2; // 修正後股價淨值比

if 0 \< value3 and value3 \< r1

then ret=1;

SetOutputName1(\"修正後股價淨值比\");

OutputField1(value3);

#### 📄 公司官僚化

{@type:filter}

// 連續4期\[管理費用/營業收入淨額的比例\]成長

//

//input:TXT(\"僅適用季資料\"); setinputname(1,\"使用限制\");

setbarfreq(\"Q\");

if barfreq \<\> \"Q\" then raiseruntimeerror(\"頻率錯誤\");

settotalbar(3);

Ret = TrueAll(

GetField(\"管理費用\",\"Q\")/GetField(\"營業收入淨額\",\"Q\") \>

GetField(\"管理費用\",\"Q\")\[1\]/GetField(\"營業收入淨額\",\"Q\")\[1\],
4);

#### 📄 公司連續N年獲利大於X億

{@type:filter}

input:lowlimit(1,\",金額下單位億元\");

input:period(10,\"連續年度數\");

value1=GetField(\"本期稅後淨利\",\"Y\");//單位百萬

if trueall(value1\>lowlimit\*100,period)

then ret=1;

#### 📄 利息支出佔股本比例

{@type:filter}

input:r1(5); setinputname(1,\"利息支出佔股本比例(%)\");

settotalbar(3);

value1=GetField(\"最新股本\"); //單位億

value2=GetField(\"利息支出\",\"Y\"); //單位百萬

value3=value2/(value1\*100) \* 100;

if value3 \> r1

then ret=1;

SetOutputName1(\"利息支出佔股本比例(%)\");

OutputField1(value3);

#### 📄 即將董監改選

{@type:filter}

input: day(180); setinputname(1, \"距離董監改選日期(天)\");

settotalbar(3);

// 董監每三年得改選一次

//

variable: lastdate(0), diff(0), years_3(0);

lastdate = GetField(\"董監事就任日期\");

diff = datediff(currentdate, lastdate);

years_3 = 365\*3;

OutputField(1,lastdate,\"董監事就任日期\");

OutputField(2,diff,\"改選天數\");

ret = diff \< years_3 and diff \> years_3 - day;

#### 📄 可能由虧轉盈

{@type:filter}

// 計算最新一期月營收的日期(mm=月份)

//

variable: mm(0);

mm = datevalue(getfielddate(\"月營收\",\"M\"),\"M\");

setbarfreq(\"M\");

// 預估最新一季的季營收(單位=億)

//

if mm=1 or mm=4 or mm=7 or mm=10

then value1=GetField(\"月營收\",\"M\") \* 3;

if mm=2 or mm=5 or mm=8 or mm=11

then value1=GetField(\"月營收\",\"M\") \* 2 +
GetField(\"月營收\",\"M\")\[1\];

if mm=3 or mm=6 or mm=9 or mm=12

then
value1=GetField(\"月營收\",\"M\")+GetField(\"月營收\",\"M\")\[1\]+GetField(\"月營收\",\"M\")\[2\];

// 預估獲利(單位=百萬) = 季營收 \* 毛利率 - 營業費用

//

value2 = value1 \* GetField(\"營業毛利率\",\"Q\") -
GetField(\"營業費用\",\"Q\");

if GetField(\"營業利益\",\"Q\")\<0

and value2\>0

then ret=1;

outputfield(1,value2 / 100,2,\"預估單季本業獲利(億)\");

outputfield(2,GetField(\"營業利益\",\"Q\"),0,\"最近一季營業利益\");

#### 📄 固定資產佔股本比率低於N%

{@type:filter}

input:r1(10,\"固定資產佔股本比例(單位%)\");

value1=GetField(\"最新股本\");//單位億

value2=GetField(\"固定資產\",\"Q\");

value3=value2/(value1\*100);

if value3\<r1/100

then ret=1;

#### 📄 季營收連N季YOY正成長

{@type:filter}

input:n(12,\"期數(單位:季)\");

setbarfreq(\"Q\");

settotalbar(n+4);

value1=GetField(\"營業收入淨額\",\"Q\");//單位:百萬

if trueall(value1\>value1\[4\],n)

then ret=1;

#### 📄 市值研發費用比

{@type:filter}

input:n(5); setinputname(1,\"研發費用市值比\");

settotalbar(3);

value1=GetField(\"總市值\"); // 單位=億

value2=GetField(\"研發費用\",\"Y\"); // 單位=百萬

value3=value2 / value1; // %

if value3 \> n

then ret=1;

SetOutputName1(\"研發費用市值比\");

OutputField1(value3);

#### 📄 帳上現金少

{@type:filter}

input:r1(50); setinputname(1,\"帳上現金(單位:百萬元)\");

settotalbar(3);

value1=GetField(\"現金及約當現金\",\"Q\");

if value1 \< r1

then ret=1;

SetOutputName1(\"帳上現金(百萬)\");

OutputField1(value1);

#### 📄 年營收成長率超過一定比例

{@type:filter}

setbarfreq(\"Y\");

settotalbar(5);

value1=GetField(\"營收成長率\",\"Y\");

value2=average(value1,5);

if trueall(value1\>0,5) and value2\>=25

then ret=1;

OutputField(1,value1,\"年度營收成長率\");

OutputField(2,value2,\"五年平均營收成長率\");

#### 📄 最新一季可能虧錢的公司

{@type:filter}

setbarfreq(\"M\");

value1=GetField(\"月營收\",\"M\");//單位:億

value2=value1\[2\]+value1\[3\]+value1\[4\];

value3=GetField(\"營業毛利率\",\"Q\");

value4=GetField(\"營業費用\",\"Q\");//單位:百萬

if value2\*value3/100-value4/100\<0

then ret=1;

#### 📄 最近五年ROE平均高於某值

{@type:filter}

input:r1(15,\"平均報酬率\");

if average(GetField(\"股東權益報酬率\",\"Y\"),5)\>r1

then ret=1;

outputfield(1,GetField(\"股東權益報酬率\",\"Y\"),1,\"最近一年\");

outputfield(2,GetField(\"股東權益報酬率\",\"Y\")\[1\],1,\"前一年\");

outputfield(3,GetField(\"股東權益報酬率\",\"Y\")\[2\],1,\"前兩年\");

outputfield(4,GetField(\"股東權益報酬率\",\"Y\")\[3\],1,\"前三年\");

outputfield(5,GetField(\"股東權益報酬率\",\"Y\")\[4\],1,\"前四年\");

outputfield(6,average(GetField(\"股東權益報酬率\",\"Y\"),5),1,\"平均\");

#### 📄 最近幾季存貨增加的比營收還快

{@type:filter}

input:r1(4 ,\"存貨比營收成長率大的連續季數\");

setbarfreq(\"Q\");

settotalbar(r1+2);

value1=GetField(\"營業收入淨額\",\"Q\");

value2=GetField(\"存貨\",\"Q\");

value3=rateofchange(value1,1);

value4=rateofchange(value2,1);

value5=value4-value3;

if trueall(value5\>0,r1)

and trueall(value5-value5\[1\]\>0,r1)

then ret=1;

#### 📄 本業可能轉虧為盈

{@type:filter}

SetTotalbar(3);

// 計算最新一期月營收的日期(mm=月份)

//

variable: mm(0);

mm = datevalue(getfielddate(\"月營收\",\"M\"),\"M\");

// 預估最新一季的季營收(單位=億)

//

if mm=1 or mm=4 or mm=7 or mm=10

then value1=GetField(\"月營收\",\"M\") \* 3;

if mm=2 or mm=5 or mm=8 or mm=11

then value1=GetField(\"月營收\",\"M\") \* 2 +
GetField(\"月營收\",\"M\")\[1\];

if mm=3 or mm=6 or mm=9 or mm=12

then
value1=GetField(\"月營收\",\"M\")+GetField(\"月營收\",\"M\")\[1\]+GetField(\"月營收\",\"M\")\[2\];

// 預估獲利(單位=百萬) = 季營收 \* 毛利率 - 營業費用

//

value2 = value1 \* GetField(\"營業毛利率\",\"Q\") -
GetField(\"營業費用\",\"Q\");

if value2 \> 0 and GetField(\"營業利益\",\"Q\") \< 0 then

ret = 1;

SetOutputName1(\"預估單季營收(億)\");

OutputField1(value1);

SetOutputName2(\"預估單季本業獲利(億)\");

OutputField2(value2 / 100);

#### 📄 本業推估本益比低於N

{@type:filter}

input:epsl(15,\"預估本益比上限\");

value3= summation(GetField(\"營業利益\",\"Q\"),4); //單位百萬;

value4= GetField(\"最新股本\");//單位億;

value5= value3/(value4\*10);//每股預估EPS

if value5\>0 and close/value5\<=epsl

then ret=1;

outputfield(1,close/value5,1,\"預估本益比\", order := 1);

#### 📄 本業獲利佔八成以上

{@type:filter}

value1=GetField(\"營業利益\",\"Q\");//單位百萬

value2=GetField(\"稅前淨利\",\"Q\");//單位百萬

if value2\>0

then begin

if value1/value2\*100\>80

then ret=1;

end;

#### 📄 每年本業都獲利且趨勢向上

{@type:filter}

input:lm(200,\"年營業利益下限\");

settotalbar(5);

value1=GetField(\"營業利益\",\"Y\");//百萬

if trueall(value1\>lm,5)

//週去五年都賺超過一億

and linearregslope(value1,5)\>0

//五年的營業利益趨勢往上

then ret=1;

#### 📄 每股來自營運現金流量

{@type:filter}

input:r1(25); setinputname(1,\"來自營運的現金流量佔股本比率下限%\");

settotalbar(3);

value1=GetField(\"最新股本\"); // 單位=億

value2=GetField(\"來自營運之現金流量\",\"Q\"); // 單位=百萬

value3=value2/value1; // 單位=%

if value3 \> r1

then ret=1;

setoutputname1(\"來自營運的現金流量佔股本比率(%)\");

outputfield1(value3);

#### 📄 毛利沒掉營收成長費用減少

{@type:filter}

input:ratio(10,\"毛利率單季衰退幅度上限\");

input:period1(10,\"計算的期間，單位是季\");

input:period2(5,\"計算的季別\");

input:count(2,\"符合條件之最低次數\");

setbarfreq(\"Q\");

settotalbar(maxlist(period1,period2)+1);

value1=GetField(\"營業毛利率\",\"Q\");

value2=GetField(\"營業收入淨額\",\"Q\");//單位百萬

value3=GetField(\"營業費用\",\"Q\");//單位百萬

if trueall(value1\>value1\[1\]\*(1-ratio/100),period1)

and countif(value2\>value2\[1\]and value3\<value3\[1\],period2)\>=count

then ret=1;

#### 📄 毛利率上昇月營收成長

{@type:filter}

value1=GetField(\"月營收月增率\",\"M\");

value2=GetField(\"營業毛利率\",\"Q\");

if value1\>value1\[1\]

and value2\>value2\[1\]

then ret=1;

#### 📄 毛利率沒掉的兇

{@type:filter}

input:ratio(10,\"毛利率單季衰退幅度上限\");

input:period(10,\"計算的期間，單位是季\");

value1=GetField(\"營業毛利率\",\"Q\");

if trueall(value1\>value1\[1\]\*(1-ratio/100),period)

then ret=1;

#### 📄 法定盈餘公積已提足，配股能力提昇

{@type:filter}

value1=GetField(\"法定盈餘公積\",\"Q\"); //百萬

value2=GetField(\"最新股本\"); //億

value3=GetField(\"本期稅後淨利\",\"Q\"); //百萬

// 稅後淨利 + 法定盈餘公積 \> 股本

//

if value1 + value3 \> value2\*100

then ret=1;

#### 📄 流動資產市值比

{@type:filter}

input:r1(12); setinputname(1,\"流動資產市值比下限%\");

settotalbar(3);

value1=GetField(\"流動資產\",\"Q\"); // 單位=百萬

value2=GetField(\"總市值\",\"D\"); // 單位=億

value3=value1/value2; // 單位=%

if value3 \< r1

then ret=1;

setoutputname1(\"流動資產市值比%\");

outputfield1(value3);

#### 📄 流動資產減負債超過市值N成

{@type:filter}

input:ratio(80,\"佔總市值百分比%\");

if
(GetField(\"流動資產\",\"Q\")-GetField(\"負債總額\",\"Q\"))\*100\>GetField(\"總市值\",\"D\")\*ratio/100

then ret=1;

#### 📄 流動資產減負債超過總市值N成

{@type:filter}

input:ratio(80,\"比率下限\");

value1=GetField(\"流動資產\",\"Q\");//單位百萬

value2=GetField(\"負債總額\",\"Q\");//單位百萬

value3=GetField(\"總市值\",\"D\");//單位億

if (value1-value2)\>=value3\*ratio

then ret=1;

#### 📄 淡季不淡

{@type:filter}

input:r1(5); setinputname(1,\"過去幾年月營收單月衰退幅度下限(%)\");

input:r2(0); setinputname(2,\"最近一個月營收月增率下限(%)\");

//input:TXT(\"僅適用月線\"); setinputname(3,\"使用限制\");

setbarfreq(\"M\");

If barfreq \<\> \"M\" then raiseruntimeerror(\"頻率設定有誤\");

settotalbar(3);

value1=GetField(\"月營收月增率\",\"M\");

value2=GetField(\"月營收月增率\",\"M\")\[12\];

value3=GetField(\"月營收月增率\",\"M\")\[24\];

value4=GetField(\"月營收月增率\",\"M\")\[36\];

if value2 \< -r1 and value3 \< -r1 and value4 \< -r1 and value1 \> r2

then ret=1;

#### 📄 營收上昇費用降低

{@type:filter}

input:period(5,\"計算的季別\");

input:count(2,\"符合條件之最低次數\");

setbarfreq(\"Q\");

settotalbar(period+1);

value1=GetField(\"營業收入淨額\",\"Q\");//單位百萬

value2=GetField(\"營業費用\",\"Q\");//單位百萬

if countif(value1\>value1\[1\] and value2\<value2\[1\],period)\>=count

then ret=1;

#### 📄 營收市值比位於歷史低檔

{@type:filter}

input:period(60,\"計算月數\");

input:ratio(10,\"距離低點幅度\");

setbarfreq(\"M\");

settotalbar(period);

value1=GetField(\"總市值\",\"M\");//單位:億元

value2=GetField(\"月營收\",\"M\");//單位:億元

if value2\<\>0 then

value3=value1/value2

else

value3=0;

if value3\<lowest(value3,period)\*(1+ratio/100)

//總市值營收比值距離過去一段時間最低點沒有差多遠

and value3\>0

then ret=1;

outputfield(1,value3,2,\"總市值/月營收\");

outputfield(2,lowest(value3,period),2,\"期間最低值\");

outputfield(3,value3/lowest(value3,period),2,\"兩者的比率\");

#### 📄 營業利益均線向上

{@type:filter}

setbarfreq(\"Q\");

settotalbar(10);

value1=GetField(\"營業利益\",\"Q\");

if linearregslope(average(value1,5),5)\>0

then ret=1;

#### 📄 營業利益率不曾大幅下滑

{@type:filter}

input:r1(5, \"營業利益率QOQ最大衰退幅度\");

input:p1(5, \"計算的季期數\");

SetTotalBar(p1 + 4);

value1=GetField(\"營業利益率\",\"Q\");

if trueall(value1\*(1+r1/100)\>value1\[1\],p1)

then ret=1;

#### 📄 營業外收入愈來愈高

{@type:filter}

settotalbar(3);

if trueall(GetField(\"營業外收入合計\",\"Y\") \>
GetField(\"營業外收入合計\",\"Y\")\[1\], 3)

then ret=1;

#### 📄 營益率由負轉正且持續上揚

{@type:filter}

settotalbar(3);

if

GetField(\"營業利益率\",\"Q\")\[2\]\<0 and

GetField(\"營業利益率\",\"Q\")\[1\]\>0 and

GetField(\"營業利益率\",\"Q\") \> GetField(\"營業利益率\",\"Q\")\[1\]
and

GetField(\"月營收月增率\",\"M\") \> 0 and

GetField(\"月營收月增率\",\"M\")\[1\] \>0

then ret=1;

#### 📄 營運現金流大於稅後盈餘

{@type:filter}

settotalbar(3);

value1=GetField(\"來自營運之現金流量\",\"Q\");

value2=GetField(\"本期稅後淨利\",\"Q\");

if value1 \> value2

then ret=1;

#### 📄 獲利穩定的公司

{@type:filter}

setbarfreq(\"Y\");

settotalbar(5);

value1=GetField(\"每股稅後淨利(元)\",\"Y\");

if trueall(value1\>=2,5)//過去五年每年都賺超過兩元

and highest(value1,5)\<lowest(value1,5)\*1.5//獲利的高低差距在忍受範圍

then ret=1;

outputfield(1,highest(value1,5),1,\"最高EPS\");

outputfield(2,lowest(value1,5),1,\"最低EPS\");

#### 📄 獲利追不上固定資本支出

{@type:filter}

input:r1(3); setinputname(1,\"連續幾年資本支出增加的速度比稅後淨利高\");

//input:TXT(\"僅適用年資料\"); setinputname(2,\"使用限制\");

setbarfreq(\"Y\");

if barfreq \<\> \"Y\" then raiseruntimeerror(\"頻率錯誤\");

settotalbar(3);

if trueall(

GetField(\"本期稅後淨利\",\"Y\") - GetField(\"本期稅後淨利\",\"Y\")\[1\]
\<

GetField(\"固定資產\",\"Y\") - GetField(\"固定資產\",\"Y\")\[1\],

r1)

then ret=1;

#### 📄 現增佔比低

{@type:filter}

value1=GetField(\"現金增資佔股本比重\",\"Y\");

if value1\<20

then ret=1;

#### 📄 現金不少但股價淨值比低

{@type:filter}

input:r1(0,\"來自營運之現金流量下限\");

input:r2(10,\"現金及約當現金單位億元\");

input:r3(0.8,\"股價淨值比上限\");

value1=GetField(\"來自營運之現金流量\",\"Q\");

value2=GetField(\"現金及約當現金\",\"Q\");

value3=GetField(\"股價淨值比\",\"D\");

if value1\>r1

and value2/100\>r2

and value3\<r3

then ret=1;

#### 📄 現金佔總市值比例

{@type:filter}

input: r1(50); setinputname(1,\"現金佔總市值比例%\");

settotalbar(3);

value1=GetField(\"現金及約當現金\",\"Q\"); // 單位=百萬

value2=GetField(\"總市值\",\"D\"); // 單位=億

value3=value1/value2; // 單位=%

if value3 \> r1 then ret=1;

SetoutputName1(\"現金佔總市值比例%\");

OutputField1(value3);

#### 📄 現金很多的公司

{@type:filter}

input: lowlimit(10,\"償債後現金及短投最少金額\");

value1=GetField(\"現金及約當現金\",\"Q\");//單位百萬

value2=GetField(\"短期投資\",\"Q\");//單位百萬

value3=GetField(\"短期借款\",\"Q\");//單位百萬

value4=(value1+value2-value3)/100;//單位億之現金及短期投資合計金額

if value4\>=lowlimit

then ret=1;

outputfield(1,value4,\"償債後現金及短投金額(億)\");

#### 📄 現金總市值比

{@type:filter}

value1=GetField(\"現金及約當現金\",\"Q\");//單位百萬

value2=GetField(\"短期投資\",\"Q\");//單位百萬

value3=(value1+value2)/100;//單位億之現金及短期投資合計金額

value4=GetField(\"總市值\",\"D\");//單位:億

if value4\<\>0

then value5=value3/value4;//現金總市值比;

if value5\>0.7 and value3\>3
//現金總市值比大於0.7且現金及短投合計超過3億

then ret=1;

outputfield(1, value5, 1, \"現金總市值比\", order := 1);

#### 📄 總市值接近歷史低點

{@type:filter}

input: r1(5); setinputname(1, \"接近低點幅度(%)\");

//input:TXT(\"僅適用月資料\"); setinputname(2,\"使用限制\");

setbarfreq(\"M\");

if barfreq \<\> \"M\" then raiseruntimeerror(\"頻率錯誤\");

settotalbar(3);

value1=GetField(\"總市值\",\"M\");

value2=nthlowest(1,GetField(\"總市值\",\"M\"),48);

value3=nthlowest(1,GetField(\"總市值\",\"M\"),24);

if absvalue(value2-value3)\*100 / value3 \< r1

then

begin

if (value1-value2) \* 100 / value2 \< r1 and

(value1-value3) \* 100 / value3 \< r1

then

ret=1;

end;

SetOutputName1(\"最近市值(億)\");

OutputField1(value1);

#### 📄 考慮成長率的股利回推合理股價

{@type:filter}

input:r(6,\"年預期報酬率單位%\");

variable: s1(0);

value1=average(GetField(\"現金股利\",\"Y\"),5);

if lowest(GetField(\"現金股利\",\"Y\")\[1\],3)\>0 then

s1=lowest(rateofchange(GetField(\"現金股利\",\"Y\"),1),3);

if value1\>1 and r\>s1 and s1\>0then begin

value2=value1/(r-s1)\*100;

if close\<\>0 then

value3=(value2-close)/close\*100;

if value3\>10

and GetField(\"現金股利\",\"Y\")\>GetField(\"現金股利\",\"Y\")\[1\]

then ret=1;

outputfield(1,value1,1,\"平均現金股利\");

outputfield(2,s1,1,\"近年最低股利成長率\");

end;

#### 📄 股價低於N年平均股利的N倍

{@type:filter}

input:N1(5);

input:N2(16);

setinputname(1,\"股利平均的年數\");

setinputname(2,\"股利的倍數\");

value1=GetField(\"股利合計\",\"Y\");

value2=average(value1,N1);

if close\<value2\*N2

then ret=1;

#### 📄 股息配發率超過一定比率

{@type:filter}

input:ratio(60,\"股息配發率%\");

value1=GetField(\"每股稅後淨利(元)\",\"Y\");

value2=GetField(\"現金股利\",\"Y\");

if value1\>0

then value3=value2/value1\*100;//股息配發率

if trueall(value3\>ratio,3) then ret=1;

#### 📄 股本膨脹營收獲利跟不上

{@type:filter}

//input:TXT(\"僅適用年資料\"); setinputname(1,\"使用限制\");

setbarfreq(\"Y\");

if barfreq \<\> \"Y\" then raiseruntimeerror(\"頻率錯誤\");

settotalbar(4);

value1 = RateOfChange(GetField(\"普通股股本\",\"Y\"), 1);

value2 = RateOfChange(GetField(\"營業收入淨額\",\"Y\"), 1);

value3 = GetField(\"營業利益成長率\",\"Y\");

if

value1 \> value2 and

value1 \> value3 and

value1\[1\] \> value2\[1\] and

value1\[1\] \> value3\[1\]

then

ret = 1;

#### 📄 股東權益報酬率高且穩定

{@type:filter}

input:years(5); setinputname(1,\"評估期間(年)\");

input:r1(15); setinputname(2,\"ROE下限(%)\");

input:r2(3); setinputname(3,\"ROE最大差異(%)\");

input:fx(\"資料頻率\"); SetInputName(4, \"使用限制:請選擇年頻率\");

if barfreq \<\> \"Y\" then raiseruntimeerror(\"頻率錯誤\");

settotalbar(3);

value1=GetField(\"股東權益報酬率\",\"Y\");

value2=lowest(GetField(\"股東權益報酬率\",\"Y\"), years);

value3=highest(GetField(\"股東權益報酬率\",\"Y\"), years);

if (value3 - value2) \< r2 and value2 \> r1

then ret=1;

setoutputname1(\"ROE(%)\");

outputfield1(value1);

#### 📄 股魚選股策略

{@type:filter}

value1=GetField(\"營業利益\",\"Q\");//單位百萬

value2=GetField(\"稅前淨利\",\"Q\");//單位百萬

value3=GetField(\"來自營運之現金流量\",\"Q\");//單位百萬

value4=GetField(\"資本支出金額\",\"Q\");//單位百萬

value5=GetField(\"利息支出\",\"Q\");//單位百萬

value6=GetField(\"所得稅費用\",\"Q\");//單位百萬

condition1=false;

condition2=false;

condition3=false;

if value2\>0 then begin

if value1/value2\*100\>80

then condition1=true; //本業獲利佔八成以上

end;

if value3-value4-value5-value6\>0 //自由現金流量大於零

then condition2=true;

value7=GetField(\"利息保障倍數\",\"Y\");

value8=GetField(\"股東權益報酬率\",\"Y\");//單位%

value9=GetField(\"營業利益率\",\"Q\");//單位%

value10=GetField(\"本益比\",\"D\");

value11=GetField(\"殖利率\",\"D\");

value12=GetField(\"每股淨值(元)\",\"Q\");

value13=value12\*value8/8;//獲利能力比率

if value7\>20 and value8\>8 and value9\>0 and value10\<12 and value11\>6
and close\<value13

then condition3=true;

if condition1 and condition2 and condition3

then ret=1;

outputfield(1,GetField(\"股東權益報酬率\",\"Y\"),2,\"ROE\");

outputfield(2,GetField(\"殖利率\",\"D\"),2,\"殖利率\", order := 1);

#### 📄 葛拉罕的選股兩標準

{@type:filter}

value1=summation(GetField(\"本期稅後淨利\",\"Q\"),4);//單位:百萬

value2=GetField(\"負債總額\",\"Q\");

value3=GetField(\"資產總額\",\"Q\");

value4=GetField(\"總市值\",\"D\");//單位:億

if value4\<value1\*7/100

and value3\>value2\*2

then ret=1;

outputfield(1,value1/100,0,\"近四季獲利(億)\");

outputfield(2,value1/100\*7,0,\"獲利的七倍(億)\");

outputfield(3,value4,0,\"總市值\");

outputfield(4,value2,0,\"負債\");

outputfield(5,value3,0,\"資產\");

#### 📄 說好的好業績一直沒有來

{@type:filter}

input: r1(5); setinputname(1, \"月營收月增率上限(%)\");

input: r2(30); setinputname(2, \"預估本益比下限\");

settotalbar(3);

value1 = 4 \* GetField(\"每股稅後淨利(元)\",\"Q\"); // 預估每股盈餘(年)

if value1 \> 0 then

value2 = close / value1 //本益比

else

value2 = 0;

if value2 \> r2 and

trueall(GetField(\"月營收月增率\",\"M\") \< r1, 3)

then ret = 1;

setoutputname1(\"預估每股盈餘(元)\");

outputfield1(value1);

#### 📄 資產報酬率達到一定的水準且沒有明顯下滑

{@type:filter}

value1=GetField(\"資產報酬率\",\"Q\");

value2=average(value1,4);

value3=linearregslope(value2,5);

if value3\>0

then ret=1;

#### 📄 近N年EPS成長率平均大於X%

{@type:filter}

input: N(5), X(10);

setbarfreq(\"Y\");

setinputname(1, \"期別\");

setinputname(2, \"平均EPS成長率(%)\");

SetTotalBar(N+3);

Value1 = Average(RateOfChange(GetField(\"每股稅後淨利(元)\",\"Y\"), 1),
N);

Ret = Value1 \> X;

SetOutputName1(\"平均EPS成長率(%)\");

OutputField1(Value1);

#### 📄 近五年至少有一年營業利益超過五億

{@type:filter}

input:years(5,\"期間\");

setbarfreq(\"Y\");

settotalbar(5);

value1=GetField(\"營業利益\",\"Y\");//單位: 百萬

if highest(value1,years)\>=500

then ret=1;

#### 📄 近四季EPS合計大於N元

{@type:filter}

input:n1(3);

setinputname(1,\"每股稅後淨利最低標準\");

value1=GetField(\"每股稅後淨利(元)\",\"Q\");

value2=summation(value1,4);

if value2\>=n1

then ret=1;

#### 📄 近期有大額資本支出

{@type:filter}

input:period(20,\"計算N季\");

input:lm(30,\"比均值增加的幅度\");

input:cm(500,\"單季資本支出金額下限\");

settotalbar(period+1);

value1=GetField(\"資本支出金額\",\"Q\");//單位: 百萬

value2=GetField(\"資本支出營收比\",\"Q\");//單位：%

value3=average(value1,period);

value4=average(value2,period);

if value1\>cm//資本支出超過一定金額

and value1\>value3\*(1+lm/100)

and value2\>value4\*(1+lm/100)

then ret=1;

#### 📄 過去三年來自營運的現金流量都大於零

{@type:filter}

value1=GetField(\"來自營運之現金流量\",\"Y\");

if trueall(value1\>0,3)

then ret=1;

#### 📄 預估殖利率高的

{@type:filter}

value1=GetField(\"營業利益\",\"Q\");//單位:百萬

value2=GetField(\"月營收\",\"M\");//單位:億

value3=GetField(\"營業利益率\",\"Q\");

value4=SUMMATION(GETFIELD(\"月營收\",\"M\"),3);//近三個月營收

value5=value4\*value3/100;

//用最近一期營益率去估算的最近一季營業利益

value6=SUMMATION(GetField(\"營業利益\",\"Q\"),3)+value5\*100;

//前三季營業利益加上最近一季預估營業利益

value8=GetField(\"最新股本\");//單位億

value9=value6/(value8\*100)\*10;

//估算出來的EPS

value10=value9/close\*100;

//eps/股價\*100: 預估殖利率

if value10\>10 and value3\>0 and close\>10

then ret=1;

outputfield(1,value10,1,\"殖利率\");

outputfield(2,value9,1,\"預估EPS\");

#### 📄 預期報酬率高的公司

{@type:filter}

input: tp(150,\"最低目標預期報酬率\");

value1=GetField(\"累計營收年增率\",\"M\");

value2=GetField(\"月營收\",\"M\");//單位:億

value3=GetField(\"營業毛利率\",\"Q\");

value4=GetField(\"營業費用\",\"Q\");//單位百萬

value5=GetField(\"加權平均股本\",\"Q\");//單位億

{用月營收\*毛利率-季營業費用/3來當單月本業獲利，

乘12當未來一年的本業獲利除以股本為預估的未來一年EPS}

value6=((value2\*value3/100-value4/300)\*12/(value5))\*10;

//未來一年預估EPS\*累計營收年增率為目標價

//但若累計營收年增率不到10就以10倍本益比來算目標價

if value1\>10 and value1\<20 then value7=value6\*value1

else if value1\>=20 then value7=value6\*20

else value7=value6\*10;

//用預估EPS乘上累計營收成長率當成目標價

if close\<\>0

then value8=((value7-close)/close)\*100;

if GetField(\"月營收月增率\",\"M\")\<30 and
GetField(\"月營收年增率\",\"M\")\<50

then begin

if value8 \> tp then ret=1;

outputfield(1,value8,\"預期報酬率\");

outputfield(2,value7,\"目標價\");

outputfield(3,value6,\"預估EPS\");

outputfield(4,value2,\"最近月營收(億)\");

outputfield(5,value3,\"毛利率\");

outputfield(6,value4,\"季營業費用(百萬)\");

outputfield(7,value5,\"加權股本(億)\");

end;

#### 📄 高F_Score的股票

{@type:filter}

setbarfreq(\"Q\");

settotalbar(5);

variable:score(0);

value1=GetField(\"資產報酬率\",\"Q\");

value2=GetField(\"來自營運之現金流量\",\"Q\");//單位百萬

value3=GetField(\"本期稅後淨利\",\"Q\");//單位百萬

value5=GetField(\"負債比率\",\"Q\");

value6=GetField(\"流動比率\",\"Q\");

value7=GetField(\"現金增資佔股本比重\",\"y\");

value8=GetField(\"營業毛利率\",\"Q\");

value9=GetField(\"總資產週轉率(次)\",\"Q\");

if date\<\>date\[1\] then score=0;

if value1\>0 then score=score+1;

if value1-value1\[3\]\>0 then score=score+1;

if value2\>0 then score=score+1;

if value3\>value2 then score=score+1;

if value5\<value5\[3\] then score=score+1;

if value6\>value6\[3\] then score=score+1;

if value7\<=value7\[3\] then score=score+1;

if value8\>value8\[3\] then score=score+1;

if value9\>value9\[3\] then score=score+1;

if score\>=8

then ret=1;

#### 📄 高毛利低獲利營收暴衝

{@type:filter}

input:

smr(5,\"月營收月增率\"),

syr(10,\"月營收年增率\"),

gr(45,\"營業毛利率\"),

epsy(1,\"年EPS\"),

epsq(0.5,\"季EPS\");

value1=GetField(\"月營收月增率\",\"M\");

value2=GetField(\"月營收年增率\",\"M\");

value3=GetField(\"營業毛利率\",\"Q\");

if value1\> smr //月營收月增率大於10%

and value2\> syr//月營收年增率大於10%

and value3\>= gr//毛利率大於45%

and GetField(\"每股稅後淨利(元)\",\"Y\")\<epsy//最近一年稅後EPS小於1

and GetField(\"每股稅後淨利(元)\",\"Q\")\<epsq//最近一季稅後EPS小於0.5

and GetField(\"每股營業額(元)\",\"Y\")\>10//每股年營收大於10

then ret=1;

#### 📄 高現金報酬率

{@type:filter}

input:r1(5); setinputname(1,\"現金報酬率下限(%)\");

settotalbar(3);

// 自由現金流

//

value1 = GetField(\"來自營運之現金流量\",\"Q\") -
(GetField(\"固定資產\",\"Q\") - GetField(\"固定資產\",\"Q\")\[1\]);

// 淨利息費用

value2=GetField(\"利息支出\",\"Q\") - GetField(\"利息收入\",\"Q\");

// 現金報酬率(%)

//

value3 = (value1 + value2) / GetField(\"企業價值\",\"Q\") \* 100;

if value3 \> r1 then ret = 1;

SetOutputName1(\"現金報酬率(%)\");

OutputField1(value3);

#### 📄 高現金股利政策且營運仍佳

{@type:filter}

input:peratio(17,\"本益比上限倍數\");

input:ratio(60,\"現金股利佔股利之比重下限\");

input:epsl(2,\"預估本益EPS下限\");

input:rate1(5,\"累計營收成長率下限\");

value1=GetField(\"累計營收年增率\",\"M\");//單位%

value2=GetField(\"現金股利佔股利比重\",\"Y\");

value3=GetField(\"營業利益\",\"Q\");//單位百萬;

value4=GetField(\"最新股本\");//單位億;

value5=summation(value3,4)/(value4\*10);//每股預估EPS

if value1\>=rate1 //本業持續成長

and value2\>=ratio //主要以現金股利為主

and value5\>=EPSl //每股推估本業獲利高

and value5/close\<=peratio //本益比低

then ret=1;

#### 📄 高護城河

{@type:filter}

condition1=false;

condition2=false;

condition3=false;

if trueall(GetField(\"營業毛利率\",\"Y\") \>=10,5)

then condition1=true;

if trueall(GetField(\"來自營運之現金流量\",\"Y\")\>100,5)

then condition2=true;

if trueall(GetField(\"股東權益報酬率\",\"Y\")\>20,5)

then condition3=true;

if condition1 and condition2 and condition3

then ret=1;

outputfield(1,GetField(\"營業毛利率\",\"Y\"),2,\"營業毛利率%\", order :=
1);

#### 📄 高護城河的公司

{@type:filter}

condition1=false;

condition2=false;

condition3=false;

//每年毛利率都大於10%

if trueall(GetField(\"營業毛利率\",\"Y\")\>=10,4) then condition1=true;

//每年來自營運的現金流量都大於1億

if trueall(GetField(\"來自營運之現金流量\",\"Y\")\>100,4) then
condition2=true;

//股東權益報酬率大於15%

if trueall(GetField(\"股東權益報酬率\",\"Y\")\>15,4) then
condition3=true;

if condition1 and condition2 and condition3

then ret=1;

### 4.10 09.時機操作 (7 個)

#### 📄 即將進入季節性多頭

{@type:filter}

setbarfreq(\"AM\");

settotalbar(3);

array:m1\[7\](0);

variable:x(0),count(0),avgup(0);

avgup = 0;

for x=1 to 7 begin

m1\[x\]=(close\[12\*x-1\]-close\[12\*x\])/close\[12\*x\];

end;

count=0;

for x=1 to 7 begin

if m1\[x\]\>0.02 then begin

count=count+1;

avgup=avgup+m1\[x\];

end;

end;

if count\>=6 and close\>5

and average(volume,20)\>10000

then ret=1;

#### 📄 即將進入季節性空頭

{@type:filter}

setbarfreq(\"AM\");

settotalbar(3);

array:m1\[7\](0);

variable:x(0),count(0),avgdn(0);

avgdn=0;

for x=1 to 7 begin

m1\[x\]=(close\[12\*x-1\]-close\[12\*x\])/close\[12\*x\];

end;

count=0;

for x=1 to 7 begin

if m1\[x\]\<-0.02 then begin

count=count+1;

avgdn=avgdn+m1\[x\];

end;

end;

if count\>=6 and close\>10

and average(volume,20)\>20000

then ret=1;

#### 📄 可能有填權行情的股票

{@type:filter}

value1=GetField(\"除權日期\");

value2=GetField(\"每股稅後淨利(元)\",\"Y\");

if value1\>date

and datediff(value1,date)\<5

//除權後五天內

and trueall(close\<close\[1\]\*1.02,3)

//除權前後未大漲

and value2\>=2

//每股稅後淨利大於2元

then ret=1;

outputfield(1,value1,0,\"今年度除權日\");

#### 📄 台幣升值受災股

{@type:filter}

value1=GetField(\"每股營業額(元)\",\"Y\");

value2=GetField(\"外銷比率\",\"Y\");

if value1\>20 and value2\>90

//每股營收超過20且外銷比率超過九成

then ret=1;

outputfield(1,value1,0,\"每股營收\");

outputfield(2,value2,0,\"外銷比率\");

#### 📄 投信可能會作帳的股票

{@type:filter}

setbarfreq(\"AD\");

settotalbar(50);

input:r1(50,\"股本上限單位億\");

input:day(30,\"天期\");

input:r2(15,\"區間買超天數\");

input:r3(5000,\"區間合計買超張數\");

input:r4(30,\"漲幅上限\");

value1=GetField(\"投信買張\",\"D\");

value2=GetField(\"最新股本\");//單位:億

condition1=false;

condition2=false;

condition3=false;

if value2\<r1

then condition1=true;//股本小於50億元

value3=countif(value1\>50,day);

if value3\>=r2

then condition2=true;//近30天裡有超過15天買超

if summation(value1,day)\>r3

then condition3=true;//近30天合計買超超過5000張

if condition1 and condition2 and condition3

and close\<close\[day-1\]\*(1+r4/100)

then ret=1;

outputfield(1,summation(value1,day),0,\"投信累計買進\", order := 1);

#### 📄 旺季來臨前

{@type:filter}

settotalbar(40);

variable:W1(0),W2(0),W3(0),F1(0),F2(0),F3(0);

value1=GetField(\"月營收\",\"M\");//單位:億元

W1=(value1\[12\]+value1\[13\]+value1\[14\])/3;

W2=(value1\[24\]+value1\[25\]+value1\[26\])/3;

W3=(value1\[36\]+value1\[37\]+value1\[38\])/3;

F1=(value1\[11\]+value1\[10\]+value1\[9\])/3;

F2=(value1\[23\]+value1\[22\]+value1\[21\])/3;

F3=(value1\[35\]+value1\[34\]+value1\[33\])/3;

if F1\>=W1\*1.25 and F2\>=W2\*1.25 and F3\>=W3\*1.25

then ret=1;

#### 📄 長期都填權的股票

{@type:filter}

input:N(5);

if getfield(\"除權息日期\") = date then

begin

value1 = date;

value2 = c\[1\];

value3 = currentbar;

end;

if value1 \> 0

AND currentbar - value3 = N - 1

AND c \> value2

then

begin

value4 = date;

value5 = c;

condition1 = true;

end;

if condition1 then ret=1;

outputfield(1,value1,0,\"除權息日期\");

outputfield(2,value2,2,\"除權息前一天收盤\");

outputfield(4,value4,0,\"N天後日期\");

outputfield(5,value5,2,\"N天後收盤\");

### 4.11 10.價值投資 (12 個)

#### 📄 PB跌到歷年低點區且低於0.8

{@type:filter}

value1=GetField(\"股價淨值比\",\"Y\");

value2=lowest(value1,4);

if value1\<value2\*1.3 and value1\<=0.8

then ret=1;

outputfield(1, GetField(\"股價淨值比\",\"Y\"),2, \"PB比\", order := -1);

#### 📄 低PB股的逆襲

{@type:filter}

if close\<15

and H = highest(H,20)

and close\<lowest(low,20)\*1.07

and highest(h,40)\>close\*1.1

then ret=1;

outputfield(1, GetField(\"股價淨值比\",\"D\"),2, \"PB比\", order := 1);

#### 📄 低本益比低PB高殖利率

{@type:filter}

{本益比小於 15 倍 股價淨值比小於 2 倍 殖利率大於 3%}

if GetField(\"本益比\",\"D\") \< 10 and

GetField(\"股價淨值比\",\"D\") \<1.5 and

GetField(\"殖利率\",\"D\") \> 3 and

GetField(\"營收成長率\",\"Q\") \>0

then ret=1;

#### 📄 低預估本益比攻勢發動

{@type:filter}

value1=GetField(\"月營收\",\"M\");//單位:億元

value2=GetField(\"稅後淨利率\",\"Q\");

value3=GetField(\"最新股本\");//單位:億元

if value3\<\>0 then

value6=(value1\*value2\*12)/(value3\*10);//單月營收推估的本業EPS

if value6\<\>0 then

value7=close/value6;

value4=GetField(\"總市值\");

value5=average(GetField(\"總市值\"),600);

if value4\<value5\*0.7

and close=highest(close,10)

then ret=1;

outputfield(1,value7,2,\"推估本益比\", order := -1);

#### 📄 價值雪球股

{@type:filter}

if GetField(\"本益比\",\"D\") \< 15 and

GetField(\"股價淨值比\",\"D\") \<2 and

GetField(\"殖利率\",\"D\") \> 3 and

GetField(\"營收成長率\",\"Q\") \>0 and

GetField(\"營業利益\",\"Q\") \>GetField(\"營業利益\",\"Q\")\[1\] and

C \> Lowest(L,255) + (highest(h,255)-Lowest(L,255))\*0.5

then ret=1;

outputfield(1,GetField(\"本益比\",\"D\"),1,\"本益比\");

outputfield(2,GetField(\"股價淨值比\",\"D\"),1,\"PB比\");

outputfield(3,GetField(\"殖利率\",\"D\"),2, \"殖利率\", order := 1);

#### 📄 新一代金牌定存股

{@type:filter}

input:lowlimit(5,\"年度獲利下限(億)\");

value1=GetField(\"本期稅後淨利\",\"Y\");//單位:百萬

value2=lowest(value1,5);//五年獲利低點

value3=average(value1,5);//五年來平均獲利

if value1/100\> lowlimit//獲利超過年度獲利下限

and value1/100\<50//獲利沒有超過五十億元

and value1\>value1\[1\]\*0.9

and value1\[1\]\>value1\[2\]\*0.9//年度獲利連續兩年未衰退超過一成

and value2\*1.3\>value3

//五年來獲利最差的時候比平均值沒有掉超過三成

then ret=1;

outputfield(1, value1/100, 1, \"稅後淨利(億)\", order := 1);

#### 📄 月營收推估出的低本益比股

{@type:filter}

input:peraito(10,\"預估本益比上限\");

value1=GetField(\"月營收\",\"M\");//單位:億元

value3=GetField(\"本期稅後淨利\",\"Q\");//單位百萬

value4=GetField(\"營業利益率\",\"Q\");

value5=GetField(\"最新股本\");//單位:億元

condition1=false;

condition2=false;

if value5\<\>0 then

value6=(value1\*value4\*12)/(value5\*100)\*10;//單月營收推估的本業EPS

if value6\<\>0 then

value7=close/value6;

if value7\<peraito and value7\>0 and value3\>200

then ret=1;

outputfield(1,value7,0,\"推估本益比\", order := -1);

outputfield(2,value6,2,\"推估EPS\");

outputfield(3,value1,2,\"月營收\");

outputfield(4,value4,2,\"營業利益率\");

outputfield(5,value5,2,\"最新股本\");

#### 📄 本業推估本益比低於N

{@type:filter}

input:peuplimit(15,\"預估本益比上限\");

value3= summation(GetField(\"營業利益\",\"Q\"),4); //單位百萬;

value4= GetField(\"最新股本\");//單位億;

value5= value3/(value4\*10);//每股預估EPS

if value5\>0 and close/value5\<=peuplimit

then ret=1;

#### 📄 每股流動資產遠大於股價

{@type:filter}

input:percent(20);

setinputname(1,\"每股易變現資產與股價間的落差比\");

value1=GetField(\"現金及約當現金\",\"Q\");//百萬;

value2=GetField(\"短期投資\",\"Q\");//百萬

value3=GetField(\"應收帳款及票據\",\"Q\");//百萬

value4=GetField(\"長期投資\",\"Q\");//百萬

value5=GetField(\"負債總額\",\"Q\");//百萬

value6=GetField(\"最新股本\");//單位: 億

value7=(value1+value2+value3+value4-value5)/(value6\*10);

if value7\>close\*(1+percent/100)

then ret=1;

#### 📄 營運現金流量的持續積累

{@type:filter}

input:ratio(50,
\"比例\");//總市值減去淨值是十年營運現金流的的多少百分比, 單位是%

var: nv(0);

value1=GetField(\"來自營運之現金流量\",\"q\");//單位百萬

value2=GetField(\"總市值\",\"D\");//單位億

value3=summation(value1,8);//最近八季的營運現金流總和

value4=value3\*5;//以最近兩年來推未來十年營運現金流總和

nv=GetField(\"股東權益總額\",\"Q\");//單位百萬

if value2\*100-nv\<value4\*ratio/100

then ret=1;

outputfield(1, 100\*value2/value4,1, \"市值/現金流\", order := -1);

#### 📄 股價距離合理價值很遠

{@type:filter}

variable: idx(0), t(0);

input:r1(3, \"假設未來十年營業利益年成長率\");

input:r2(2, \"未來十年平均年利率\");

input:r3(100, \"未來獲利折現合計淨值與市價比\");

// 計算未來10年的營業利益折現值

value1=GetField(\"營業利益\",\"Y\"); //單位:百萬

value2=GetField(\"最新股本\"); //單位:億

value3=GetField(\"每股淨值(元)\",\"y\");

value11 =
maxlist(GetField(\"營業利益\",\"Y\"),GetField(\"營業利益\",\"Y\")\[1\],GetField(\"營業利益\",\"Y\")\[2\],GetField(\"營業利益\",\"Y\")\[3\],GetField(\"營業利益\",\"Y\")\[4\]);

value12 =
minlist(GetField(\"營業利益\",\"Y\"),GetField(\"營業利益\",\"Y\")\[1\],GetField(\"營業利益\",\"Y\")\[2\],GetField(\"營業利益\",\"Y\")\[3\],GetField(\"營業利益\",\"Y\")\[4\]);

if trueall(value1\>0,5) and (value11-value12)/value11\<0.5 then begin

t = 0;

for idx =1 to 10 begin

t = t + value1 \* power(1+r1/100,idx)/power(1+r2/100,idx);

end;

// t=百萬,value2=億,換成每股

value5 = t / value2 / 100;

value6=close/(value3+value5);

if value6\<r3/100

then ret=1;

end;

outputfield(1, value5, 2, \"估算每股營業利益\");

outputfield(2, value6, 1, \"市價/淨值比\", order := -1);

#### 📄 跌不下去的高殖利率股

{@type:filter}

input:N(20, \"天期\");

condition1 = L = Lowest(L,N);

condition2 = H = Highest(H,N);

if condition2

//股價創區間以來高點

and TrueAll(Condition1=false,N)

//這段區間都未破底

and close\<close\[N-1\]\*1.05

and volume\>600

//區間股價漲幅不大

then ret=1;

outputfield(1, GetField(\"股東權益報酬率\",\"Q\"),2, \"股東權益%\",
order := 1);

outputfield(2, GetField(\"現金股利\",\"Y\"),2, \"現金股利\");

### 4.12 11.選股機器人 (24 個)

#### 📄 上游價格指標趨勢向上

{@type:filter}

input: Period(20, \"天期\");

Condition1 = rateofchange(GetField(\"上游股價指標\"), period) \>=
Period;

Condition2 = GetField(\"上游股價指標\") \>
GetField(\"上游股價指標\")\[Period/2\];

Condition3 = GetField(\"上游股價指標\") \>
average(GetField(\"上游股價指標\"), period);

ret = condition1 and condition2 and condition3;

outputfield(1,rateofchange(GetField(\"上游股價指標\",\"D\"),period),2,\"上游漲幅%\",
order := 1);

#### 📄 下游價格指標趨勢向上

{@type:filter}

input: Period(20, \"天期\");

Condition1 = rateofchange(GetField(\"下游股價指標\"), period) \>=
Period;

Condition2 = GetField(\"下游股價指標\") \>
GetField(\"下游股價指標\")\[Period/2\];

Condition3 = GetField(\"下游股價指標\") \>
average(GetField(\"下游股價指標\"), period);

ret = condition1 and condition2 and condition3;

outputfield(1,rateofchange(GetField(\"下游股價指標\",\"D\"),Period),2,\"下游漲幅%\",
order := 1);

#### 📄 中小型股整理結束

{@type:filter}

setbarfreq(\"AD\");

//盤整後噴出

input: Periods(20,\"計算期數\");

input: Ratio(3,\"近期波動幅度%\");

input: Direction(1,\"方向:1突破 -1跌破\");

condition1 = false;

if (highest(high\[1\],Periods-1) -
lowest(low\[1\],Periods-1))/close\[1\] \<= ratio\*0.01

then condition1=true//近期波動在?%以內

else return;

if condition1 and Direction \> 0 and high = highest(high, Periods)

and close\>close\[1\]\*1.02

then ret=1;//盤整後往上突破

outputfield(1,highest(high\[1\],Periods-1),2,\"整理區高點\", order :=
-1);

#### 📄 創百日新高但距低點不遠

{@type:filter}

//說明：今天的收盤價創百日的收盤價新高，但收盤價距離區間低點不遠

input:day(200,\"計算區間\");

input:day1(20,\"短線漲幅計算區間\");

input:percents(10,\"距離區間最低點漲幅\");

value1=lowest(close,day1);

if close=highest(close,day)

and value1\*(1+percents/100)\>=close

and close \>= value1\*1.05

and volume \>= average(volume\[1\], 5)

then ret=1;

outputfield(1, value1, 2, \"區間低點\", order := -1);

#### 📄 可能由盈轉虧

{@type:filter}

// 計算最新一期月營收的日期(mm=月份)

//

variable: mm(0);

mm = datevalue(getfielddate(\"月營收\",\"M\"),\"M\");

// 預估最新一季的季營收(單位=億)

//

if mm=1 or mm=4 or mm=7 or mm=10

then value1=GetField(\"月營收\",\"M\") \* 3;

if mm=2 or mm=5 or mm=8 or mm=11

then value1=GetField(\"月營收\",\"M\") \* 2 +
GetField(\"月營收\",\"M\")\[1\];

if mm=3 or mm=6 or mm=9 or mm=12

then
value1=GetField(\"月營收\",\"M\")+GetField(\"月營收\",\"M\")\[1\]+GetField(\"月營收\",\"M\")\[2\];

// 預估獲利(單位=百萬) = 季營收 \* 毛利率 - 營業費用

//

value2 = value1 \* GetField(\"營業毛利率\",\"Q\") -
GetField(\"營業費用\",\"Q\");

ret = 1;

outputfield(1,value2 / 100,2,\"預估單季本業獲利(億)\", order := 1);

#### 📄 可能轉虧為盈

{@type:filter}

// 計算最新一期月營收的日期(mm=月份)

//

variable: mm(0);

mm = datevalue(getfielddate(\"月營收\",\"M\"),\"M\");

// 預估最新一季的季營收(單位=億)

//

if mm=1 or mm=4 or mm=7 or mm=10

then value1=GetField(\"月營收\",\"M\") \* 3;

if mm=2 or mm=5 or mm=8 or mm=11

then value1=GetField(\"月營收\",\"M\") \* 2 +
GetField(\"月營收\",\"M\")\[1\];

if mm=3 or mm=6 or mm=9 or mm=12

then
value1=GetField(\"月營收\",\"M\")+GetField(\"月營收\",\"M\")\[1\]+GetField(\"月營收\",\"M\")\[2\];

// 預估獲利(單位=百萬) = 季營收 \* 毛利率 - 營業費用

//

value2 = value1 \* GetField(\"營業毛利率\",\"Q\") -
GetField(\"營業費用\",\"Q\");

if value2 \> 0 and GetField(\"營業利益\",\"Q\") \< 0 then

ret = 1;

outputfield(1,value1,2,\"預估單季營收(億)\", order := 1);

outputfield(2, value2 / 100,2, \"預估單季本業獲利(億)\");

#### 📄 外資先前沒買，突然連買三天

{@type:filter}

setbarfreq(\"AD\");

input: \_period(20, \"期間\");

input: \_ratio(5, \"買超占成交比重\");

condition1 = trueall(GetField(\"外資買賣超\",\"D\")\[3\]=0, \_period);

condition2 =
trueall(GetField(\"外資買賣超\",\"D\")\*100/volume\>=\_ratio,3);

if condition1 and condition2

then ret=1;

value1 = Summation(GetField(\"外資買賣超\",\"D\"), 3) /
Summation(Volume, 3) \* 100;

outputfield(1,value1,2,\"外資買超%\", order := 1);

#### 📄 多次到頂而破

{@type:filter}

setbarfreq(\"AD\");

input:HitTimes(3,\"設定觸頂次數\");

input:RangeRatio(2,\"設定頭部區範圍寬度%\");

input:Length(60,\"計算期數\");

variable: theHigh(0);

variable: HighLowerBound(0);

variable: TouchRangeTimes(0);

//找到過去其間的最高點

theHigh = Highest(High\[1\],Length);

value1=highestbar(high\[1\],length);

// 設為瓶頸區間上界

HighLowerBound = theHigh \*(100-RangeRatio)/100;

//回算在此區間中 進去瓶頸區的次數

TouchRangeTimes = CountIF(High\[1\] \> HighLowerBound, Length-value1);

Condition1 = TouchRangeTimes \>= HitTimes;

Condition2 = close \> theHigh;

Condition3 = close\[length\]\*1.2\<thehigh;

condition4=false;

if Condition1 and Condition2 and condition3

then condition4=true;

if barslast(condition4=true)=1

then ret=1;

outputfield(1, theHigh, 2, \"區間高點\", order := -1);

#### 📄 多頭下起漲前的籌碼收集

{@type:filter}

setbarfreq(\"AD\");

value1=GetField(\"分公司買進家數\");

value2=GetField(\"分公司賣出家數\");

value3=value2-value1;

value4=countif(value3\>20,10);

if value4\>6 and close\[30\]\>close\*1.1

then ret=1;

outputfield(1,value1,0,\"買進家數\", order := -1);

outputfield(2,value2,0,\"賣出家數\");

#### 📄 天價上影線賣出訊號

{@type:filter}

setbarfreq(\"AD\");

variable:Kprice(0);

if H \> O\*1.03 and C \<O and H = highest(H,255) then Kprice = L;

condition1 = c crosses below Kprice;

condition2 = average(volume\[1\], 5) \>= 500;

ret = condition1 and condition2;

outputfield(1,Kprice,2,\"關卡價\", order := -1);

#### 📄 投信初介入

{@type:filter}

setbarfreq(\"AD\");

input: day(30, \"投信交易期間\");

value1 = summation(GetField(\"投信買賣超\")\[1\], day);

value2 = summation(volume\[2\], day);

condition1 = value1 \< value2 \* 0.02;

//先前投信不怎麼買這檔股票

condition2 = GetField(\"投信買賣超\")\>= volume\[1\] \* 0.15;

//投信開始較大買超

condition3 = H \> H\[1\];

//買了股價有往上攻

condition4 = C \> C\[1\];

//今天收盤有往上走

condition5=close\<close\[10\]\*1.05;

RET = condition1 and condition2 and condition3 and condition4 and
condition5;

outputfield(1,GetField(\"投信買賣超\",\"D\"),0,\"投信買超\", order :=
1);

#### 📄 投信掃貨

{@type:filter}

input: pastDays(5, \"計算天數\");

input: \_BuyRatio(10, \"買超佔比例(%)\");

variable: SumForce(0);

variable: SumTotalVolume(0);

SumForce = Summation(GetField(\"投信買賣超\"), pastDays);

sumTotalVolume = Summation(Volume, pastDays);

value1 = SumForce / SumTotalVolume \* 100;

if value1 \> \_BuyRatio then ret =1;

outputfield(1,value1,2,\"投信買超%\", order := 1);

#### 📄 投信第一天大買

{@type:filter}

setbarfreq(\"AD\");

input: v1(500, \"投信估計持股上限(張)\");

value1=GetField(\"投信持股\",\"D\");

value2=GetField(\"投信買賣超\",\"D\");

if value1 \< v1 and value2 \> VOLUME\*0.2

then ret=1;

outputfield(1,GetField(\"投信買賣超\",\"D\"),0,\"投信買超\", order :=
1);

#### 📄 月營收年增率移動平均黃金交叉b

{@type:filter}

value1=GetField(\"月營收年增率\",\"M\");

if average(value1,4) crosses over average(value1,12)

and value1 \> 0

then ret=1;

outputfield(1,value1,2,\"月營收年增率%\", order := 1);

#### 📄 殺過頭

{@type:filter}

setbarfreq(\"AD\");

input:day(5,\"短期天數\");

input:period(20,\"波段天數\");

input:r1(20,\"波段最低跌幅\");

input:r2(10,\"短期最低跌幅\");

input:r3(2,\"本日急拉幅度\");

input:v1(1000,\"成交量下限\");

condition1=false;

condition2=false;

condition3=false;

if highest(high,period)\>=close\[1\]\*(1+r1/100)

then condition1=true;

if highest(high,day)\>=close\[1\]\*(1+r2/100)

then condition2=true;

if close\>=close\[1\]\*(1+r3/100) and v1\>=1000

then condition3=true;

if condition1 and condition2 and condition3

then ret=1;

outputfield(1,lowest(low,period),2,\"前波低點\", order := -1);

#### 📄 毛利率創一年新高

{@type:filter}

value1=GetField(\"營業毛利率\",\"Q\");

if value1=highest(value1,12)

then ret=1;

#### 📄 毛利率沒掉的兇

{@type:filter}

input:ratio(10,\"毛利率單季衰退幅度上限\");

input:period(10,\"計算的期間，單位是季\");

value1=GetField(\"營業毛利率\",\"Q\");

if trueall(value1\>value1\[1\]\*(1-ratio/100),period)

then ret=1;

#### 📄 烏龜交易法則之買進訊號

{@type:filter}

setbarfreq(\"AD\");

condition1=false;

condition2=false;

if high=highest(high,100)and barslast(high=highest(high,100))\[1\]\>100

then condition1=true;

//創百日新高且上一次發生時是在100個交易日之前

if average(volume\[1\], 5) \>= 1000

then condition2=true;

//五日移動平均量大於千張

if condition1 and condition2

then ret=1;

outputfield(1,highest(high,100),2,\"突破高點\", order := -1);

#### 📄 烏龜交易法則之賣出訊號

{@type:filter}

setbarfreq(\"AD\");

condition1=false;

condition2=false;

if L=lowest(L,100)and barslast(L=lowest(L,100))\[1\]\>100

then condition1=true;

//創百日新低且上一次發生時是在100個交易日之前

if average(volume\[1\], 5) \>= 1000

then condition2=true;

//五日移動平均量大於千張

if condition1 and condition2

then ret=1;

outputfield(1,lowest(L,100),2,\"跌破低點\", order := -1);

#### 📄 突破糾結均線

{@type:filter}

setbarfreq(\"AD\");

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: midlength(10); setinputname(2,\"中期均線期數\");

input: Longlength(20); setinputname(3,\"長期均線期數\");

input: Percent(5); setinputname(4,\"均線糾結區間%\");

input: XLen(20); setinputname(5,\"均線糾結期數\");

input: Volpercent(25);
setinputname(6,\"放量幅度%\");//帶量突破的量是超過最長期的均量多少%

variable: shortaverage(0);

variable: midaverage(0);

variable: Longaverage(0);

variable: AvgHLp(0),AvgH(0),AvgL(0);

shortaverage = average(close,shortlength);

midaverage = average(close,midlength);

Longaverage = average(close,Longlength);

AvgH = maxlist(shortaverage,midaverage,Longaverage);

AvgL = minlist(shortaverage,midaverage,Longaverage);

if AvgL \> 0 then AvgHLp = 100\*AvgH/AvgL -100;

condition1 = trueAll(AvgHLp \< Percent,XLen);

condition2 = V \> average(V\[1\],XLen)\*(1+Volpercent/100) ;

condition3 = C \> AvgH \*(1.02) and H \> highest(H\[1\],XLen);

condition4 = average(volume\[1\], 5) \>= 1000;

ret = condition1 and condition2 and condition3 and condition4;

outputfield(1,AvgH,2,\"均線上緣\", order := -1);

outputfield(2,AvgL,2,\"均線下緣\");

#### 📄 總市值位於歷史低檔區

{@type:filter}

setbarfreq(\"AD\");

input:period(1250,\"計算天數\");

input:ratio(10,\"距離低點幅度\");

value1=GetField(\"總市值\");

value2=lowest(GetField(\"總市值\"),period);

if value1\<value2\*(1+ratio/100)

//總市值距離過去一段時間最低點沒有差多遠

then begin

if close=highest(close,20)

and close\<close\[19\]\*1.07

and close crosses over average(close,20)

and close\<=15

then ret=1;

end;

outputfield(1, value1, 2, \"總市值(億)\", order := -1);

#### 📄 股價領先大盤創新高

{@type:filter}

input: Length(20, \"布林通道天數\");

input: BandRange(2, \"上下寬度\");

variable: up(0);

Condition1 = GetSymbolField(\"TSE.TW\",\"收盤價\",\"D\") \>
average(GetSymbolField(\"TSE.TW\",\"收盤價\",\"D\"),10);

Condition2 = average(GetSymbolField(\"TSE.TW\",\"收盤價\",\"D\"),5) \>
average(GetSymbolField(\"TSE.TW\",\"收盤價\",\"D\"),20);

value1=close/GetSymbolField(\"TSE.TW\",\"收盤價\",\"D\");

up = bollingerband(value1, Length, BandRange);

Condition3 = TrueAll(value1 \>= up, 3);

// 成交量判斷

Condition99 = Average(Volume\[1\], 100) \>= 1000;

if Condition1 And Condition2 And Condition3 And Condition99 then ret=1;

outputfield(1, rateofchange(c,5), 2, \"5日漲幅%\", order := 1);

outputfield(2,
rateofchange(GetSymbolField(\"TSE.TW\",\"收盤價\",\"D\"),5), 2,
\"大盤5日漲幅%\");

#### 📄 週轉率高點買進

{@type:filter}

setbarfreq(\"AD\");

value1=GetField(\"成交金額\");

value2=GetField(\"總成交次數\",\"D\");

if value2\>0 then value3=value1/value2;

if value3=highest(value3,200)

and close\>close\[1\]\*1.025

and close\[2\]\<close\[12\]\*1.05

and volume\>2000

then ret=1;

outputfield(1, GetField(\"週轉率\",\"D\"), 2, \"週轉率%\", order := 1);

#### 📄 除權後的填權行情

{@type:filter}

if close\[1\]\*1.1\<close\[20\]

and close\>close\[1\]\*1.025

and volume\>average(volume,20)

then ret=1;

value1=getbaroffset(dateadd(GetField(\"除權息日期\"),\"D\",-1));

outputfield(1,close\[value1\],2,\"除權參考價\");

outputfield(2,-RateOfChange(c,value1),2,\"貼權率%\", order := 1);

## 5. 🤖 自動交易 (64 個腳本)

> 自動下單、出場、Algo 策略委託等交易語法範例

### 5.1 0-基本語法 (12 個)

#### 📄 01-SetPosition

{@type:autotrade}

{

Position代表的是這個商品在這個策略內的'預期部位', Position是一個整數,
可以大於0, 也可以小於0.

\*\*請注意: 一個交易策略內可以跑多個商品，每個商品的Position是獨立的\*\*

當我們想要執行交易時, 就呼叫SetPosition這一個函數,
傳入我們預期的部位(同時也可以傳入委託價格).

腳本開始執行時, 商品的Position預設數值是0, 當我們想要買進時,
就透過SetPosition把Position變大, 想要賣出時, 就透過

SetPosition把Position變小.

系統收到了SetPosition()的呼叫之後, 就會依照目前的Position,
目前委託/成交的執行狀態, 決定如何送單, 來讓你的策略可以達到(成交)

這個新的預期的部位.

SetPosition()可以接受兩個參數:

第一個參數是預期的部位,

第二個參數是委託的價格, 這個參數如果不傳的話,
則會採用策略的預設買進/賣出價格

請看以下範例

}

{

把部位(Position)變成1, 如果原先部位是0的話, 則等於買進1張

第二個參數(委託價格)如果不傳的話, 則使用策略設定內的預設價格

}

SetPosition(1);

{

第二個參數可以傳入價格, MARKET是系統保留字,
代表是\'市價\'(期貨的話則會是\'範圍市價\')

}

SetPosition(1, MARKET);

{

也可以傳入K棒的價格, 例如Close

}

SetPosition(1, Close);

{

也可以傳入數值運算式

}

SetPosition(1, Close + 1.0);

{

也可以傳入絕對值, 例如100.0

}

SetPosition(1, 100.0);

{

支援檔位換算功能(AddSpread),

AddSpread(Close, 1)表示是Close價格往上加1檔, AddSpread(Close,
2)表示加2檔

AddSpread(Close, -1)表示是Close價格往下減1檔

AddSpread也可以用在警示腳本, 以及指標腳本

}

SetPosition(1, AddSpread(Close, 1));

{

Position也可以是負的, 如果原先部位是0的話, 則等於賣出1張

}

SetPosition(-1);

{

除了可以SetPosition之外, 也可以讀到目前的Position

SetPosition(Position+1)表示是加碼1張

}

value1 = Position;

SetPosition(Position+1);

{

SetPosition的價格如果不符合商品的交易規則的話, 系統會自動轉換,

例如: 如果超過漲停價, 則只會送出漲停價,

例如: 如果不符合跳動點的話, 則會自動轉換到符合跳動點價格

}

SetPosition(1, 123.1); { 如果是買進台積電的話, 則會送出委託價格=123元 }

#### 📄 02-SetPosition範例#1(多單1口)

{@type:autotrade}

{

範例:

當發生做多情境時, 買進1口

做多後發生出場情境時, 多單出場(變成空手)

}

var:

long_condition(false), { 是否做多 }

exit_long_condition(false); { 是否多單出場 }

{

Position=0時判斷是否要做多,

Position=1時判斷是否要出場

}

if Position = 0 and long_condition then SetPosition(1);

if Position = 1 and exit_long_condition then SetPosition(0);

#### 📄 02-SetPosition範例#2(空單1口)

{@type:autotrade}

{

範例:

當發生做空情境時, 賣出1口(做空)

做空後發生出場情境時, 空單出場(變成空手)

}

var:

short_condition(false), { 是否做空 }

exit_short_condition(false); { 是否空單出場 }

{

Position=0時判斷是否要做空,

Position=-1時判斷是否要回補

}

if Position = 0 and short_condition then SetPosition(-1);

if Position = -1 and exit_short_condition then SetPosition(0);

#### 📄 02-SetPosition範例#3(多單1口+空單1口)

{@type:autotrade}

{

範例

當發生做多情境時, 把部位變成做多1口(如果此時是空手的話, 買進1口,
如果此時是做空1口的話, 回補這一口,同時買進1口)

當發生做空情境時, 把部位變成做空1口(如果此時是空手的話, 賣出1口,
如果此時是做多1口的話, 賣出這一口,同時做空1口)

做多後發生出場情境時, 多單出場(變成空手)

做空後發生出場情境時, 空單出場(變成空手)

這個是範例#1跟範例#2的綜合體,
可是包含了部位翻轉的邏輯(Position可能從-1變成1, 或是從1變成-1)

}

var:

long_condition(false), { 是否做多 }

exit_long_condition(false), { 是否多單出場 }

short_condition(false), { 是否做空 }

exit_short_condition(false); { 是否空單出場 }

if Position \<\> 1 and long_condition then begin

{ 如果符合做多情境(long_condition), 則把部位變成1 (可能是0-\>1 or
-1-\>1) }

SetPosition(1);

end else if Position \<\> -1 and short_condition then begin

{ 如果符合做空情境(short_condition), 則把部位變成-1 (可能是0-\>-1 or
1-\>-1) }

SetPosition(-1);

end else if Position = 1 and exit_long_condition then begin

{ 如果已經做多, 且發生多方出場情形時(exit_long_condition), 則把部位變成0
}

SetPosition(0);

end else if Position = -1 and exit_short_condition then begin

{ 如果已經做空, 且發生空方出場情形時(exit_short_condition),
則把部位變成0 }

SetPosition(0);

end;

#### 📄 03-Filled

{@type:autotrade}

{

Filled是Position的另外一個朋友, 代表這個策略內/這個執行商品的成交部位

假設剛開始執行時, 腳本的Position是0的話, 此時Filled也會是0

接下來當腳本執行SetPosition(1)後, 會送出一筆買進1張的委託

如果此時尚未成交的話, Position會等於1, 可是Filled會等於0

如果這一筆委託單成交的話, 則Position會等於1, Filled也會等於1

如果腳本內想要判斷目前成交狀態的話, 就可以透過讀取Filled這個變數來判斷.

}

{ 以下假設策略啟動時商品的Postion = 0 }

if Position = 1 and Filled = 0 then begin

{ 已經送出一筆買進1張的委託, 可是還沒有成交}

end;

if Position = 1 and Filled = 1 then begin

{ 已經送出一筆買進1張的委託, 而且這一筆委託已經成交 }

end;

if Position = -1 and Filled = 0 then begin

{ 已經送出一筆賣出1張的委託, 可是還沒有成交 }

end;

if Position = -1 and Filled = -1 then begin

{ 已經送出一筆賣出1張的委託, 而且這一筆委託已經成交 }

{ Filled跟Position一樣, 可能會大於0, 也可能會小於0 }

end;

#### 📄 04-SetPosition範例#4(追價)

{@type:autotrade}

{

範例: 透過Filled來判斷是否需要追價

當發生做多情境時, 買進1口

如果發生出場情境時, 多單出場(變成空手)

如果買進委託沒有成交的話, 則追價

}

{

當腳本呼叫SetPosition的話, 系統會依照目前委託/成交的情形,
決定如何送出委託單.

以下情境假設一開始執行時Position = 0.

情境#1

腳本呼叫SetPosition(1)時, 系統送出一筆買進1口的委託單

經過一段時間後, 腳本呼叫SetPosition(0), 此時會發生以下的情形

\- 如果剛剛那一筆委託單已經成交(Position=1, Filled=1),
接下來SetPosition(0), 就會送出一筆賣出1口的委託

\- 如果剛剛那一筆委託單還沒有成交(Position=1, Filled=0),
接下來SetPosition(0), 就會\*\*刪除買進的那一筆委託\*\*

(這樣子的話, 使用者的部位就剛好是0)

情境#2

腳本呼叫SetPosition(1)時, 系統送出一筆買進1口的委託單

經過一段時間後, 腳本又呼叫SetPosition(1), 此時會發生以下的情形

\- 如果剛剛那一筆委託單已經成交(Position=1, Filled=1),
接下來SetPosition(1), 不會送出任何委託

\- 如果剛剛那一筆委託單還沒有成交(Position=1, Filled=0),
接下來SetPosition(1), 系統會執行以下的邏輯

\- 如果新的SetPosition(1)的委託價格跟先前的委託價格\*\*不一樣\*\*的話,
則刪除剛剛的委託,

然後送出一筆買進1口的委託單(使用新的委託價格)

\- 如果新的SetPosition(1)的委託價格跟先前的委託價格一樣的話,
則不會做任何動作

情境#3

腳本呼叫SetPosition(2)時, 送出一筆買進2口的委託單

經過一段時間後, 腳本又呼叫SetPosition(3), 此時會發生以下的情形

\- 如果剛剛那一筆委託單已經完全成交(Position=2, Filled=2)

\- 接下來SetPosition(3), 就會送出一筆買進1口的委託

\- 如果剛剛那一筆委託單都沒有成交(Position=2, Filled=0)

\- 接下來SetPosition(3), 就會刪除先前的委託, 然後送出一筆買進3口的委託

\- 如果剛剛那一筆委託單部分成交(Position=2, Filled=1)

\- 接下來SetPosition(3), 就會刪除先前的委託, 然後送出一筆買進2口的委託

小結:

如果Position跟Filled一樣的話, 這個表示先前送出的委託都已經完全成交,
或是已經被取消.

此時如果收到新的SetPosition()的話,
系統的動作是送出一筆買進或是賣出的委託

如果Position跟Filled不一樣的話,
這個表示目前應該有一筆\[尚未完全成交的委託\],
如果此時收到新的SetPosition()的話,

系統會先刪除目前這一筆委託, 確認這一筆委託的成交數量之後,
再依照新的需求決定如何送單.

}

var:

long_condition(false), { 是否做多 }

exit_long_condition(false); { 是否多單出場 }

if Position = 0 and long_condition then begin

{ 如果目前是空手, 且符合做多情境(long_condition), 則以目前收盤價買進1口,
}

SetPosition(1, Close);

end else if Position = 1 and exit_long_condition then begin

SetPosition(0);

{ 多單出場: 如果已經買到了, 就賣出剛剛買到的1口, 如果還沒有買到,
就取消買進的委託單 }

end else if Position = 1 and Filled = 0 then begin

{ 如果已經送出買進委託, 可是還沒有成交的話, 則追價(系統會刪除先前委託,
然後再送出買進1張) }

SetPosition(1, Close);

{ 為了確保委託單排隊的順序, 如果新的委託價跟先前委託價格一樣的話,
系統就不會執行委託異動的動作 }

end;

#### 📄 04-SetPosition範例#5(加碼)

{@type:autotrade}

{

範例: 透過Filled來判斷是否要加碼

當發生做多情境時, 買進1口

買進成交後, 如果發生加碼情境時, 再買進1口,

如果發生出場情境時, 多單出場(變成空手, 部位=0)

}

var:

long_condition(false), { 是否做多 }

raise_long_condition(false), { 是否多單加碼 }

exit_long_condition(false); { 是否多單出場 }

if Position = 0 and long_condition then begin

{ 目前Position=0, 而且發生做多情境, 買進1口 }

SetPosition(1);

end else if Position \<\> 0 and exit_long_condition then begin

{ 已經買進, 而且發生多單出場情境, 賣出所有部位 }

{ 請注意, Position可能是1 or 2, 所以用 \<\> 0 來判斷 }

SetPosition(0);

end else if Position = 1 and Filled = 1 and raise_long_condition then
begin

{ 已經買進1口, 而且也成交了, 此時發生加碼情境, 所以再買進1口}

SetPosition(2);

{ 也可以寫成 SetPosition(position + 1) }

end;

#### 📄 05-FilledAvgPrice以及停損停利範例

{@type:autotrade}

{

除了可以使用Filled來知道目前的成交部位之外,

也可以透過FilledAvgPrice這個函數來取得目前\"未平倉\"部位的成本

}

{

範例: 多單1口進場後, +1.5%停利, -1.5%停損

}

var:

long_condition(false); { 是否做多 }

if Position = 0 and long_condition then SetPosition(1);

if Position = 1 and Filled = 1 then begin

{ 多單已經買進1口 }

{ 計算損益% }

var: plratio(0);

{

請注意: 不管Filled是大於0還是小於0,
FilledAvgPrice的數值都是\'正數\'(\>0)

}

plratio = 100 \* (Close - FilledAvgPrice) / FilledAvgPrice;

if plratio \>= 1.5 then SetPosition(0); { 停利 }

if plratio \<= -1.5 then SetPosition(0); { 停損 }

end;

{

目前計算未平倉成本的方式是採用\*\*先進先出的沖銷方式\*\*來計算,
以下是沖銷順序的範例:

範例#1

假設策略執行過程總共產生三筆成交, 依照時間先後順序, 資料分別為

\- 第一筆: 買進1張, 成交價100元,

\- 第二筆: 買進1張, 成交價102元,

\- 第三筆: 賣出1張, 成交價101元

在第一筆成交時, Filled = 1, FilledAvgPrice = 100

在第二筆成交時, Filled = 2, FilledAvgPrice = (100 + 102) / 2 = 101

在第三筆成交時, Filled = 1, FilledAvgPrice = 102 (第三筆-1沖銷第一筆+1,
所以未平倉剩下第二筆1張, 未平倉成本=102)

範例#2

假設策略執行過程總共產生四筆成交, 依照時間先後順序, 資料分別為

\- 第一筆: 買進2張, 成交價100元,

\- 第二筆: 買進2張, 成交價101元,

\- 第三筆: 買進2張, 成交價102元,

\- 第四筆: 賣出3張, 成交價101元,

在第一筆成交時, Filled = 2, FilledAvgPrice = 100

在第二筆成交時, Filled = 4, FilledAvgPrice = (100\*2 + 101\*2) / 4 =
100.5

在第三筆成交時, Filled = 6, FilledAvgPrice = (100\*2 + 101\*2 + 102\*2)
/ 6 = 101

在第四筆成交時, Filled = 3, FilledAvgPrice = (101\*1 + 102 \* 2) / 3 =
101.66666

(第一筆成交的2張被沖銷, 第二筆成交的1張被沖銷)

}

#### 📄 06-FilledRecord函數

{@type:autotrade}

{

除了Filled跟FilledAvgPirce之外, 系統也提供FilledRecord相關的函數,
讓腳本可以取得每一筆成交的詳細資料

}

{

FilledRecordCount: 取得商品執行迄今的成交筆數

請注意:

成交筆數會對應到真實的交易紀錄, 例如買進5張, 如果分三次成交,
分別成交2張, 2張, 1張,

那麼FilledRecordCount會是3

}

value1 = FilledRecordCount; { 回傳成交筆數 }

{

取得成交筆數之後, 就可以一筆一筆把成交紀錄資料讀出來

FilledRecordDate(n): 回傳第n筆成交紀錄的日期, 格式是YYYYMMDD,
例如20200727 (2020年7月27日)

FilledRecordTime(n): 回傳第n筆成交紀錄的時間, 格式是HHMMSS, 例如103000
(10點30分0秒)

FilledRecordBS(n): 回傳第n筆成交紀錄的買賣別, 買進的話是1, 賣出的話是-1

FilledRecordPrice(n):回傳第n筆成交紀錄的成交價格,
請注意這個數值的正負跟買進/賣出無關(以台股來說都會 \> 0)

FilledRecordQty(n): 回傳第n筆成交紀錄的成交數量,
請注意不管是買進或是賣出, 這個數值都是 \> 0的整數

FilledRecordIsRealtime(n): 回傳第n筆成交紀錄是否是在即時區間成交的,
如果是的話回傳1, 否則回傳0

n的範圍從1到FilledRecordCount

}

var: idx(0);

for idx = 1 to FilledRecordCount begin

value2 = FilledRecordDate(idx);

value3 = FilledRecordTime(idx);

value4 = FilledRecordBS(idx);

value5 = FilledRecordPrice(idx);

value6 = FilledRecordQty(idx);

value7 = FilledRecordIsRealtime(idx);

end;

#### 📄 07-Position跟Filled的異動時機點

{@type:autotrade}

{

系統在什麼時候會更新Position以及Filled ?

系統洗價(執行腳本)的邏輯如下:

\- 當成交價異動時(逐筆洗價)或是K棒完成時(非逐筆洗價)執行腳本,

\- 要執行腳本前, 先決定當時的Position以及Filled的數值,

\- 執行腳本的邏輯,

\- 如果執行時腳本呼叫SetPosition的話,
則紀錄\"第一次\"呼叫SetPosition的狀態,

\- 接下來腳本如果又呼叫其他的SetPosition的話, 則\[不予理會\],
也就是說洗價過程內如果腳本呼叫了

很多個SetPosition的話, 系統只會執行第一個,

\- 在洗價過程內, Position跟Filled的數值都會維持不變,
就算洗價到一半時突然收到成交的話, Filled也不會更動(不然的話腳本的計算

邏輯可能會因為Filled的異動而亂掉)

\- 等到腳本洗價完畢, 依照委託/執行的狀態, 決定要如何送單,

\- 同時也會更新Position的數值(所以下一次洗價時Position的數值會異動)

\- 如果在下一次洗價前收到任何成交的話,
也會更新Filled的數值(所以下一次洗價時Filled的數值會是洗價前的成交狀態)

}

{

範例#1: 說明多個SetPosition時的執行邏輯, 以及Position何時異動

}

if currentbar = 1 then begin

print(Position); { 印出 0 }

SetPosition(1); { 這是第一次呼叫的SetPosition(), 系統會執行這一個 }

print(Position); { 印出 0, 要等到下一次洗價時Position才會變成1 }

SetPosition(2); { 這次呼叫會被忽略, 因為line#33已經呼叫了SetPosition() }

print(Position); { 印出 0, 要等到下一次洗價時Position才會變成1 }

end else if currentbar = 2 then begin

print(Position); { 印出 1,
因為currentbar=1的時候執行了line#33的SetPosition(1) }

SetPosition(2); { 這是這一次洗價第一次呼叫的SetPosition(),
系統會執行這一個 }

print(Position); { 印出 1, 要等到下一次洗價時Position才會變成2 }

end;

{

範例#2: 因為每一次洗價只會執行一個SetPosition,
所以如果系統希望可以依照不同情境決定部位的數量, 那該怎麼設計 ?

}

var: long_condition(false), strong_condition(false);

{

如果long_condition成立時買1張,

如果strong_condition成立時就買2張

}

// 寫法#1 =\> 有問題!! 如果long_condition跟strong_condition都成立時,
只會買1張

//

if long_condition then SetPosition(1);

if strong_condition then SetPosition(2);

// 寫法#2 =\> OK, 因為會先判斷strong_condition(買比較多的先判斷,
設計時要小心先後順序)

//

if strong_condition then SetPosition(2);

if long_condition then SetPosition(1);

// 寫法#3 =\> OK(推薦) 依照不同情形計算預期部位,
最後再一次呼叫SetPosition

//

if long_condition then value1 = 1;

if strong_condition then value1 = 2;

if value1 \<\> 0 then SetPosition(value1);

#### 📄 08-Alert

{@type:autotrade}

{

Alert語法

在交易腳本內也可以透過Alert語法產生\'通知\'.

}

var: alert_condition(false); { 何時通知 }

if alert_condition then begin

{ 呼叫Alert函數, 傳入要通知的訊息 }

alert(\"這是我想要顯示的通知訊息\");

{ 也可以一次傳入多個參數, 系統會把這些參數串連成一個字串,
用空白字元來分隔 }

alert(\"目前Bar時間=\", FormatTime(\"HH:mm\", Time));

end;

{

Alert的通知會出現在以下的畫面內

a\. 自動交易中心, 策略執行記錄內(類別為警示)

b\. 即時監控畫面(請記得來源要勾選\'自動交易\')

c\. 警示提示視窗(請記得來源要勾選\'自動交易\')

如果自動交易策略啟動推播的話, Alert也會傳送到手機端

}

#### 📄 09-CancelAllOrders

{@type:autotrade}

{

此為 CancelAllOrders 的範例腳本

腳本將會在啟動時直接下出委託價為跌停價的買進委託
(只會委託一次)，若委託未成交的話則在N分鐘以後刪除委託。

需注意會依照策略設定和商品洗價而有所差異，並不一定會準時在N分鐘後刪除

}

Input: \_n(5, \"幾分鐘後刪除委託\");

if \_n \< 0 then RaiseRunTimeError(\"設定分鐘需要大於0\");

var: IntraBarPersist \_time(0);

//啟動後進入交易指令可執行的區間後下單並計算出場時間

Once(Position = 0 and Filled = 0 and GetInfo(\"TradeMode\") = 1) begin

SetPosition(1, GetField(\"跌停價\", \"D\"), label:=\"跌停價買進委託\");

\_time = TimeAdd(CurrentTime, \"M\", \_n);

end;

//當洗價時

if CurrentTime \> \_time and Position \<\> Filled then
CancelAllOrders(label:=\"刪除跌停價買進委託\");

### 5.2 1-常用下單方式 (10 個)

#### 📄 01-市價交易

{@type:autotrade}

{

市價交易

}

var: long_condition(false); { 進場買進作多 }

var: exit_long_condition(false); { 多單出場 }

{

範例:

均線穿越時以市價買進1張

均線跌破時以市價賣出(1張)

}

long_condition = Average(Close, 5) cross over Average(Close, 20);

exit_long_condition = Average(Close, 5) cross under Average(Close, 20);

if Position = 0 and long_condition then begin

SetPosition(1, MARKET); { 以市價買進 }

end;

if Position = 1 and exit_long_condition then begin

SetPosition(0, MARKET); { 以市價賣出 }

end;

#### 📄 02-金額換算

{@type:autotrade}

{

以金額計算交易數量

}

input: ordersize_w(10, \"每筆交易金額(萬)\");

{

範例:

均線穿越時以指定金額換算張數買進

均線跌破時以市價賣出全部數量

}

var: long_condition(false); { 進場買進作多 }

var: exit_long_condition(false); { 多單出場 }

long_condition = Average(Close, 5) cross over Average(Close, 20);

exit_long_condition = Average(Close, 5) cross under Average(Close, 20);

if Position = 0 and long_condition then begin

var: order_price(0); { 預期委託價格 }

var: order_qty(0); { 換算後數量 }

order_price = AddSpread(Close, 1);

order_qty = (ordersize_w \* 10000) / (order_price \* 1000);

{ 計算出來的數值如果不是整數, 傳入SetPosition時會自動捨去小數位數 }

{ 例如 SetPosition(2.5) 執行時會被轉成 SetPosition(2) }

SetPosition(order_qty, order_price); { 以指定價格買入指定數量 }

end;

if Position \<\> 0 and exit_long_condition then begin

SetPosition(0, MARKET); { 以市價賣出全部數量 }

end;

#### 📄 03-全部賣出

{@type:autotrade}

{

多單全部賣出

}

var: long_condition(false); { 進場買進作多 }

var: exit_long_condition(false); { 多單全部出場 }

{

範例:

多單進場: 每次遇到均線穿越或是連續上漲3筆時就買進1張(可以買進很多張,
沒有限制)

均線跌破時賣出全部

}

long_condition =

Average(Close, 5) cross over Average(Close, 20) or

TrueAll(Close \> Close\[1\], 3);

exit_long_condition = Average(Close, 5) cross under Average(Close, 20);

if long_condition then begin

SetPosition(Position + 1); { 多單+1: 使用預設買進價格 }

{ SetPosition(Position+1)的意思就是比目前部位多買1筆 }

{ 也可以使用 Buy(1), 代表多單加碼1張 }

end;

if Position \> 0 and exit_long_condition then begin

SetPosition(0); { 多單全部出場: 把Position調成0, 使用預設賣出價格 }

end;

#### 📄 04-全部回補

{@type:autotrade}

{

空單全部回補

}

var: short_condition(false); { 進場賣出做空 }

var: exit_short_condition(false); { 空單全部回補 }

{

範例:

空單做空: 每次遇到均線跌破或是連續下跌3筆時就賣出1張(可以做空很多張,
沒有限制)

均線穿越時回補全部空單

}

short_condition =

Average(Close, 5) cross under Average(Close, 20) or

TrueAll(Close \< Close\[1\], 3);

exit_short_condition = Average(Close, 5) cross over Average(Close, 20);

if short_condition then begin

SetPosition(Position - 1); { 空單+1: 使用預設賣出價格 }

{ SetPosition(Position-1)的意思就是比目前部位多賣1筆 }

{ 也可以使用Short(1), 代表空單加碼1張 }

end;

if Position \< 0 and exit_short_condition then begin

SetPosition(0); { 空單全部回補: 把Position調成0, 使用預設買進價格 }

end;

#### 📄 05-多單減碼

{@type:autotrade}

{

多單減碼

}

var: add_one_condition(false); { 多單加碼1張 }

var: reduce_one_condition(false); { 多單減碼1張}

var: exit_long_condition(false); { 多單全部出場 }

{

範例:

多單進場: 每次連續上漲3筆時就買進1張(可以買進很多張, 沒有限制)

多單減碼: 每次連續下跌3筆時就減碼1張(最多減碼到0)

均線跌破時賣出全部

}

add_one_condition = TrueAll(Close \> Close\[1\], 3);

reduce_one_condition = TrueAll(Close \< Close\[1\], 3);

exit_long_condition = Average(Close, 5) cross under Average(Close, 20);

if add_one_condition then begin

Buy(1); { 多單+1: 使用預設買進價格 }

end;

if Position \> 0 then begin

{ 請注意: 因為可能同時會符合多單出場以及多單減碼的情形,
所以邏輯上要依照優先順序檢查. }

if exit_long_condition then begin

SetPosition(0); { 多單全部出場: 把Position調成0, 使用預設賣出價格 }

end else if reduce_one_condition then begin

Sell(1); { 多單賣出1張, 使用預設的賣出價格 }

end;

end;

#### 📄 06-空單減碼

{@type:autotrade}

{

空單減碼

}

var: short_one_condition(false); { 空單加碼1張 }

var: reduce_one_condition(false); { 空單減碼(回補)1張}

var: exit_short_condition(false); { 空單全部回補 }

{

範例:

空單進場: 每次連續下跌3筆時就賣出1張(可以賣出很多張, 沒有限制)

空單減碼: 每次連續上漲3筆時就減碼(回補)1張(最多減碼到0)

均線穿越時回補全部

}

short_one_condition = TrueAll(Close \< Close\[1\], 3);

reduce_one_condition = TrueAll(Close \> Close\[1\], 3);

exit_short_condition = Average(Close, 5) cross over Average(Close, 20);

if short_one_condition then begin

Short(1); { 空單+1: 使用預設賣出價格 }

end;

if Position \< 0 then begin

{ 請注意: 因為可能同時會符合空單出場以及空單減碼的情形,
所以邏輯上要依照優先順序檢查. }

if exit_short_condition then begin

SetPosition(0); { 空單全部出場: 把Position調成0, 使用預設買進價格 }

end else if reduce_one_condition then begin

Cover(1); { 空單回補1張, 使用預設的買進價格 }

end;

end;

#### 📄 07-多單加碼

{@type:autotrade}

{

多單加碼

}

var: long_condition(false); { 進場買進作多 }

var: add_one_condition(false); { 多單加碼1張 }

var: exit_long_condition(false); { 多單全部出場 }

{

範例:

多單進場: 均線穿越做多1張(部位最多=1)

多單加碼: 如果已經做多, 又連續上漲3筆, 則加碼1張

均線跌破時賣出全部

}

long_condition = Average(Close, 5) cross over Average(Close, 20);

add_one_condition = TrueAll(Close \> Close\[1\], 3);

exit_long_condition = Average(Close, 5) cross under Average(Close, 20);

if Position = 0 and long_condition then begin

SetPosition(1); { 多單1張: 使用預設買進價格 }

end;

if Position = 1 and add_one_condition then begin

SetPosition(2); { 加碼1張變成2張 }

end;

if Position \> 0 and exit_long_condition then begin

SetPosition(0); { 多單全部出場: 把Position調成0, 使用預設賣出價格 }

end;

#### 📄 08-空單加碼

{@type:autotrade}

{

多單加碼

}

var: short_condition(false); { 做空進場 }

var: add_one_condition(false); { 空單加碼1張 }

var: exit_short_condition(false); { 空單全部出場 }

{

範例:

空單進場: 均線跌破時做空1張(部位最多=-1)

空單加碼: 如果已經做空, 又連續下跌3筆, 則加碼1張

均線突破時全部回補

}

short_condition = Average(Close, 5) cross under Average(Close, 20);

add_one_condition = TrueAll(Close \< Close\[1\], 3);

exit_short_condition = Average(Close, 5) cross over Average(Close, 20);

if Position = 0 and short_condition then begin

SetPosition(-1); { 空單1張: 使用預設賣出價格 }

end;

if Position = -1 and add_one_condition then begin

SetPosition(-2); { 空單加碼1張變成-2 }

end;

if Position \< 0 and exit_short_condition then begin

SetPosition(0); { 空單全部出場: 把Position調成0, 使用預設買進價格 }

end;

#### 📄 09-刪單

{@type:autotrade}

{

刪除尚未完全成交的委託

}

var: long_condition(false); { 進場買進作多 }

var: exit_long_condition(false);{ 多單全部出場 }

{

範例:

均線穿越時以長天期的均線價格買進1張

如果等了三根K棒都沒有成交則取消委託

均線跌破時多單全部平倉

}

value1 = Average(Close, 5);

value2 = Average(Close, 20);

long_condition = value1 cross over value2;

exit_long_condition = value1 cross under value2;

if Position = 0 and long_condition then begin

SetPosition(1, value2); { 以20日均線的價格買進 }

end;

if Position = 1 and exit_long_condition then begin

SetPosition(0); { 多單全部平倉 }

end else if Position = 1 and TrueAll(Position \<\> Filled, 3) then begin

{

送出買進委託後, Position = 1, 如果成交了, Filled = 1,

Position \<\> Filled 在這裡則代表著委託已經送出, 可是還沒有成交,

Position, Filled, 跟value1, value2, Close一樣, 都是一個\"序列\",

所以Position\[1\]是上一根K棒最後的Position,
Filled\[1\]是上一根K棒最後的Filled,

所以TrueAll(Position \<\> Filled, 3) 代表著連續三根K棒都沒有成交

}

SetPosition(0); { 取消買進的委託 }

end;

#### 📄 10-改價

{@type:autotrade}

{

修改尚未完全成交的委託的價格

}

var: long_condition(false); { 進場買進作多 }

var: exit_long_condition(false);{ 多單全部出場 }

{

範例:

均線穿越時以短天期的均線價格買進1張

如果等了三根K棒都沒有成交則以目前的市場價格追價

均線跌破時多單全部平倉

}

value1 = Average(Close, 5);

value2 = Average(Close, 20);

long_condition = value1 cross over value2;

exit_long_condition = value1 cross under value2;

if Position = 0 and long_condition then begin

SetPosition(1, value1); { 以5日均線的價格買進 }

end;

if Position = 1 and exit_long_condition then begin

SetPosition(0); { 多單全部平倉 }

end else if Position = 1 and TrueAll(Position \<\> Filled, 3) then begin

{

送出買進委託後, Position = 1, 如果成交了, Filled = 1,

Position \<\> Filled 在這裡則代表著委託已經送出, 可是還沒有成交,

Position, Filled, 跟value1, value2, Close一樣, 都是一個\"序列\",

所以Position\[1\]是上一根K棒最後的Position,
Filled\[1\]是上一根K棒最後的Filled,

所以TrueAll(Position \<\> Filled, 3) 代表著連續三根K棒都沒有成交

}

SetPosition(1, Close); { 修改委託價格為目前成交價 }

end;

### 5.3 2-下單出場方式 (9 個)

#### 📄 01-收盤前平倉

{@type:autotrade}

{

收盤前平倉

}

input: exit_period(2, \"收盤前N分鐘平倉\");

var: long_condition(false); { 進場買進作多 }

var: exit_long_condition(false); { 多單出場 }

var: market_close_condition(false); { 是否已經進入收盤階段 }

{

範例:

均線穿越時買進1張

均線跌破時賣出

進場後如果連續下跌3筆時賣出

收盤前N分鐘如果還有部位的話賣出(當日部位一定歸0)

}

long_condition = Average(Close, 5) cross over Average(Close, 20);

exit_long_condition = Average(Close, 5) cross under Average(Close, 20);

{ 判斷是否已經進入收盤階段 }

market_close_condition = EnterMarketCloseTime(exit_period);

if Position = 0 and long_condition and not market_close_condition then
begin

SetPosition(1); { 買進1張: 請注意如果接近收盤時間, 則不進場 }

end else if Position = 1 and exit_long_condition then begin

SetPosition(0); { 出場 }

end else if Position = 1 and market_close_condition then begin

SetPosition(0); { 進入收盤階段: 出場 }

end;

#### 📄 02-多單固定停利停損(點)

{@type:autotrade}

{

多單停損(點)

}

input: profit_point(10, \"停利(點)\");

input: loss_point(10, \"停損(點)\");

var: long_condition(false); { 進場買進作多 }

{

範例:

均線穿越時以市價買進1張

以成交價為基礎, 設定固定的停損/停利價格, 觸及時出場

}

long_condition = Average(Close, 5) cross over Average(Close, 20);

if Position = 0 and long_condition then begin

SetPosition(1, MARKET); { 以市價買進 }

end;

if Position = 1 and Filled = 1 then begin

{ 依照成本價格設定停損/停利 }

if profit_point \> 0 and Close \>= FilledAvgPrice + profit_point then
begin

{ 停利 }

SetPosition(0);

end else if loss_point \> 0 and Close \<= FilledAvgPrice - loss_point
then begin

{ 停損 }

SetPosition(0);

end;

end;

#### 📄 03-空單固定停利停損(點)

{@type:autotrade}

{

空單停損(點)

}

input: profit_point(10, \"停利(點)\");

input: loss_point(10, \"停損(點)\");

var: short_condition(false); { 進場做空 }

{

範例:

均線跌破時以市價賣出1張做空

以成交價為基礎, 設定固定的停損/停利價格, 觸及時出場

}

short_condition = Average(Close, 5) cross under Average(Close, 20);

if Position = 0 and short_condition then begin

SetPosition(-1, MARKET); { 以市價賣出 }

end;

if Position = -1 and Filled = -1 then begin

{ 依照成本價格設定停損/停利: 請注意當作空時, 判斷是否獲利的方向要改變 }

if profit_point \> 0 and Close \<= FilledAvgPrice - profit_point then
begin

{ 停利 }

SetPosition(0);

end else if loss_point \> 0 and Close \>= FilledAvgPrice + loss_point
then begin

{ 停損 }

SetPosition(0);

end;

end;

#### 📄 04-多單固定停利停損(%)

{@type:autotrade}

{

多單停損(%)

}

input: profit_percent(2, \"停利(%)\");

input: loss_percent(2, \"停損(%)\");

var: long_condition(false); { 進場買進作多 }

{

範例:

均線穿越時以市價買進1張

以成交價為基礎, 設定固定的停損/停利價格, 觸及時出場

}

long_condition = Average(Close, 5) cross over Average(Close, 20);

if Position = 0 and long_condition then begin

SetPosition(1, MARKET); { 以市價買進 }

end;

if Position = 1 and Filled = 1 then begin

{ 依照成本價格設定停損/停利 }

if profit_percent \> 0 and Close \>=
FilledAvgPrice\*(1+0.01\*profit_percent) then begin

{ 停利 }

SetPosition(0);

end else if loss_percent \> 0 and Close \<=
FilledAvgPrice\*(1-0.01\*loss_percent) then begin

{ 停損 }

SetPosition(0);

end;

end;

#### 📄 05-空單固定停利停損(%)

{@type:autotrade}

{

空單停損(%)

}

input: profit_percent(2, \"停利(%)\");

input: loss_percent(2, \"停損(%)\");

var: short_condition(false); { 進場做空 }

{

範例:

均線跌破時以市價賣出1張做空

以成交價為基礎, 設定固定的停損/停利價格, 觸及時出場

}

short_condition = Average(Close, 5) cross under Average(Close, 20);

if Position = 0 and short_condition then begin

SetPosition(-1, MARKET); { 以市價賣出 }

end;

if Position = -1 and Filled = -1 then begin

{ 依照成本價格設定停損/停利: 請注意當作空時, 判斷是否獲利的方向要改變 }

if profit_percent \> 0 and Close \<=
FilledAvgPrice\*(1-0.01\*profit_percent) then begin

{ 停利 }

SetPosition(0);

end else if loss_percent \> 0 and Close \>=
FilledAvgPrice\*(1+0.01\*loss_percent) then begin

{ 停損 }

SetPosition(0);

end;

end;

#### 📄 06-多單移動停損(點)

{@type:autotrade}

{

多單移動停損(點)

設定停損點, 跟停利點(如果不設定停利的話請把profit_point設定成0)

價格碰觸到停損/停利點時出場

如果價格上漲時, 停損點會跟著上漲

}

input: profit_point(10, \"停利(點)\");

input: loss_point(10, \"停損(點)\");

var: long_condition(false); { 進場買進作多 }

{

範例:

均線穿越時買進1張

以成交價為基礎, 設定固定停利以及移動停損

}

if loss_point = 0 then raiseruntimeerror(\"請設定停損(點)\");

long_condition = Average(Close, 5) cross over Average(Close, 20);

if Position = 0 and long_condition then begin

SetPosition(1); { 買進1張 }

end;

if Position = 1 and Filled = 1 then begin

{ 依照成本價格設定停損/停利 }

var: intrabarpersist stoploss_point(0);

{ 計算停損價格 }

if stoploss_point = 0 then begin

stoploss_point = FilledAvgPrice - loss_point;

end;

{ 如果價格上漲的話, 則往上挪動停損價格. 停損價格只會越來越高 }

if Close \> FilledAvgPrice then begin

if Close - loss_point \> stoploss_point then begin

stoploss_point = Close - loss_point;

end;

end;

if profit_point \> 0 and Close \>= FilledAvgPrice + profit_point then
begin

{ 停利 }

SetPosition(0);

stoploss_point = 0;

end else if Close \<= stoploss_point then begin

{ 停損 }

SetPosition(0);

stoploss_point = 0;

end;

end;

#### 📄 07-空單移動停損(點)

{@type:autotrade}

{

空單移動停損(點)

設定停損點, 跟停利點(如果不設定停利的話請把profit_point設定成0)

價格碰觸到停損/停利點時出場

如果價格下跌時, 停損點會跟著下跌

}

input: profit_point(10, \"停利(點)\");

input: loss_point(10, \"停損(點)\");

var: short_condition(false); { 進場做空 }

{

範例:

均線跌破時做空賣出1張

以成交價為基礎, 設定固定停利以及移動停損

}

if loss_point = 0 then raiseruntimeerror(\"請設定停損(點)\");

short_condition = Average(Close, 5) cross under Average(Close, 20);

if Position = 0 and short_condition then begin

SetPosition(-1); { 做空賣出1張 }

end;

if Position = -1 and Filled = -1 then begin

{ 依照成本價格設定停損/停利 }

var: intrabarpersist stoploss_point(0);

{ 計算停損價格 }

if stoploss_point = 0 then begin

stoploss_point = FilledAvgPrice + loss_point;

end;

{ 如果價格下跌的話, 則往下挪動停損價格. 停損價格只會越來越低 }

if Close \< FilledAvgPrice then begin

if Close + loss_point \< stoploss_point then begin

stoploss_point = Close + loss_point;

end;

end;

if profit_point \> 0 and Close \<= FilledAvgPrice - profit_point then
begin

{ 停利 }

SetPosition(0);

stoploss_point = 0;

end else if Close \>= stoploss_point then begin

{ 停損 }

SetPosition(0);

stoploss_point = 0;

end;

end;

#### 📄 08-多單移動停利(點)

{@type:autotrade}

{

多單移動停利(點)

設定停損點(如果不設定的話, 請把loss_point設定成0), 以及停利點,
跟回跌點數

價格下跌到停損時出場

價格上漲到停利點後啟動移動停利, 如果價格繼續上漲, 則繼續持有,
如果價格回檔超過回跌點數時, 則停利出場

}

input: profit_point(10, \"停利(點)\");

input: profit_drawback_point(5, \"停利回跌(點)\");

input: loss_point(10, \"停損(點)\");

var: long_condition(false); { 進場買進作多 }

{

範例:

均線穿越時買進1張

以成交價為基礎, 設定固定停損以及移動停利

}

if profit_point = 0 then raiseruntimeerror(\"請設定停利(點)\");

if profit_drawback_point = 0 then
raiseruntimeerror(\"請設定停利回跌(點)\");

if profit_drawback_point \> profit_point then
raiseruntimeerror(\"停利(點)需大於停利回跌(點)\");

long_condition = Average(Close, 5) cross over Average(Close, 20);

if Position = 0 and long_condition then begin

SetPosition(1); { 買進1張 }

end;

if Position = 1 and Filled = 1 then begin

var: intrabarpersist max_profit_point(0); { 啟動停利後最大獲利點 }

if loss_point \> 0 and Close \<= FilledAvgPrice - loss_point then begin

{ 停損 }

SetPosition(0);

max_profit_point = 0;

end else begin

{ 判斷是否要啟動停利 }

if max_profit_point = 0 and Close \>= FilledAvgPrice + profit_point then
begin

max_profit_point = Close;

end;

if max_profit_point \<\> 0 then begin

if Close \<= max_profit_point - profit_drawback_point then begin

{ 停利 }

SetPosition(0);

max_profit_point = 0;

end else if Close \> max_profit_point then begin

{ 移動最大獲利點 }

max_profit_point = Close;

end;

end;

end;

end;

#### 📄 09-空單移動停利(點)

{@type:autotrade}

{

空單移動停利(點)

設定停損點(如果不設定的話, 請把loss_point設定成0), 以及停利點,
跟回跌點數

價格上漲到停損時出場

價格下跌停利點後啟動移動停利, 如果價格繼續下跌, 則繼續持有,
如果價格回檔超過回跌點數時, 則停利出場

}

input: profit_point(10, \"停利(點)\");

input: profit_drawback_point(5, \"停利回跌(點)\");

input: loss_point(10, \"停損(點)\");

var: short_condition(false); { 進場買空 }

{

範例:

均線跌破時做空賣出1張

以成交價為基礎, 設定固定停損以及移動停利

}

if profit_point = 0 then raiseruntimeerror(\"請設定停利(點)\");

if profit_drawback_point = 0 then
raiseruntimeerror(\"請設定停利回跌(點)\");

if profit_drawback_point \> profit_point then
raiseruntimeerror(\"停利(點)需大於停利回跌(點)\");

short_condition = Average(Close, 5) cross under Average(Close, 20);

if Position = 0 and short_condition then begin

SetPosition(-1); { 做空賣出1張 }

end;

if Position = -1 and Filled = -1 then begin

var: intrabarpersist max_profit_point(0); { 啟動停利後最大獲利點 }

if loss_point \> 0 and Close \>= FilledAvgPrice + loss_point then begin

{ 停損 }

SetPosition(0);

max_profit_point = 0;

end else begin

{ 判斷是否要啟動停利 }

if max_profit_point = 0 and Close \<= FilledAvgPrice - profit_point then
begin

max_profit_point = Close;

end;

if max_profit_point \<\> 0 then begin

if Close \>= max_profit_point + profit_drawback_point then begin

{ 停利 }

SetPosition(0);

max_profit_point = 0;

end else if Close \< max_profit_point then begin

{ 移動最大獲利點 }

max_profit_point = Close;

end;

end;

end;

end;

### 5.4 3-Algo策略委託 (5 個)

#### 📄 01-定時定量交易

{@type:autotrade}

{

定時定量: 每隔多久送出一筆委託, 下多少筆之後就停止

輸入參數:

\- 下單間隔 (order_interval: 每隔幾(秒)送出一筆委託)

\- 下單數量 (order_qty: 每一筆委託的數量)

\- 買賣方向 (order_bs: 1=買進, -1=賣出)

\- 委託筆數 (order_count: 總共要送出幾筆)

}

input: order_interval(60, \"下單間隔(秒)\");

input: order_qty(1, \"每次下單數量\");

input: order_bs(1, \"買賣方向\", inputKind:=Dict(\[\"買進\", 1\],
\[\"賣出\", -1\]));

input: order_count(10, \"下單筆數\");

{

範例:

策略一啟動就啟動定時定量交易, 全部送完就停止

}

var: intrabarpersist exec_order_started(false);

var: intrabarpersist exec_order_lasttime(0);

var: intrabarpersist exec_order_count(0);

if not exec_order_started and GetInfo(\"TradeMode\") = 1 then begin

exec_order_started = true; { 啟動定時定量委託 }

exec_order_count = 0;

exec_order_lasttime = 0;

end;

{ 定時定量的執行邏輯 }

if exec_order_started and exec_order_count \< order_count then begin

if exec_order_lasttime = 0 or TimeDiff(CurrentTime, exec_order_lasttime,
\"S\") \>= order_interval then begin

{ 執行委託 }

Print(\"order_bs=\", order_bs, \"order_qty=\", order_qty);

SetPosition(position + order_bs \* order_qty); { TODO: 請填入委託價格 }

exec_order_count = exec_order_count + 1;

exec_order_lasttime = CurrentTime;

end;

end;

#### 📄 02-時間權重交易(TWAP)

{@type:autotrade}

{

時間權重(TWAP): 類似定時定量交易,
差異是傳入的是執行委託總時間以及委託總數量,
由腳本自己反推算委託間隔/每次委託數量.

輸入參數:

\- 下單總時間 (order_duration: 在未來的幾(秒)內要執行完畢)

\- 下單總數量 (order_totalqty: 委託的總數量)

\- 買賣方向 (order_bs: 1=買進, -1=賣出)

把預期委託數量平均分配在指定的時間範圍內,
例如指定在未來的60分鐘內買進100張

}

input: order_duration(3600, \"委託區間(秒)\");

input: order_totalqty(100, \"總委託數量\");

input: order_bs(1, \"買賣方向\", inputKind:=Dict(\[\"買進\", 1\],
\[\"賣出\", -1\]));

{

範例:

策略一啟動就啟動定時定量交易, 全部送完就停止

}

var: intrabarpersist exec_order_started(false);

var: intrabarpersist exec_order_starttime(0);

var: intrabarpersist exec_order_startposition(0);

var: intrabarpersist exec_order_endposition(0);

if not exec_order_started and GetInfo(\"TradeMode\") = 1 then begin

exec_order_started = true; { 啟動定時定量委託 }

exec_order_starttime = CurrentTime;

exec_order_startposition = Position;

exec_order_endposition = Position + order_bs \* order_totalqty;

end;

{ 時間權重的執行邏輯 }

if exec_order_started and Position \<\> exec_order_endposition then
begin

var: duration(0), target_position(0);

duration = TimeDiff(CurrentTime, exec_order_starttime, \"S\");

target_position = order_bs \* Floor(order_totalqty \* duration /
order_duration) + exec_order_startposition;

if Position \<\> target_position then begin

SetPosition(target_position); { TODO: 請填入委託價格 }

end;

end;

#### 📄 03-分量權重交易(VWAP)

{@type:autotrade}

{

分量權重(VWAP): 把預期委託數量依照歷史成交量分布,
在指定的時間範圍送出內, 預期成交均價可以接近歷史均價

輸入參數:

\- 統計天數 (vwap_days: 決定要用前幾天的成交量統計)

\- 開始交易時間 (start_hhmm: 交易開始時間, 格式為hhmm, 例如0905,
表示從09:05開始進行交易)

\- 結束交易時間 (end_hhmm: 交易結束時間, 格式為hhmm, 例如1300,
表示交易到1300就停止)

\- 交易數量 (order_totalqty: 預計交易的數量)

\- 交易方向 (order_bs: 1=買進, -1=賣出)

執行邏輯:

\-
策略起動時根據vwap_days統計出每分鐘的成交數量分佈比例(從09:00\~13:30),

\- 依照指定的交易區間(start_hhmm \~ end_hhmm), 以及預期交易數量,
決定每分鐘的委託數量,

\- 舉例

\- start_hhmm = 09:10, end_hhmm = 10:00

\- 依照歷史統計, 09:10的成交量=1%, 09:11的成交量=0.8%, ..
09:59的成交量=1.5%

\- 假設order_totalqty = 500, 則

\- 在09:11(09:10結束時), 送出500 \* 1% / (1% + 0.8% + .. + 1.5%),

\- 在09:12(09:11結束時), 送出500 \* 0.8% / (1% + 0.8% + .. + 1.5%),

\- 在10:00(09:59結束時), 送出500 \* 1.5% / (1% + 0.8% + .. + 1.5%),

\- 也就是說, 在指定時間範圍內, 依照歷史成交量的分佈, 每分鐘送出委託,

}

input: vwap_days(1, \"用前N日的資料來計算成交量分佈\");

input: start_hhmm(0905, \"分鐘起點(HHMM)\");

input: end_hhmm(1000, \"分鐘終點(HHMM)\");

input: order_totalqty(1000, \"總委託數量\");

input: order_bs(1, \"買賣方向\", inputKind:=Dict(\[\"買進\", 1\],
\[\"賣出\", -1\]));

if start_hhmm \>= end_hhmm then raiseruntimeerror(\"開始時間必須 \<
結束時間\");

{ 請確認Backbar有足夠的空間可以讀入vwap_days的資料 }

var: intrabarpersist vwap_started(false);

var: intrabarpersist vwap_base_position(0);

var: intrabarpersist vwap_time_index(0);

array: intrabarpersist vwap_dist\[\](0); // N日統計分佈,
總共有total_minute格, 每一格是到目前為止的百分比

var: intrabarpersist vwap_totalminutes(0);

var: intrabarpersist start_hhmmss(0), intrabarpersist end_hhmmss(0);

var: start_condition(false); { 啟動定時定量委託 }

if not vwap_started and GetInfo(\"TradeMode\") = 1 then begin

// 如果使用者指定 09:01 \~ 10:00, 因為分K是標在時間起點,

// 所以我們要統計的是09:01 \~ 09:59這些分K的成交量分佈
(所以end_hhmm會-1分鐘)

start_hhmmss = start_hhmm \* 100;

end_hhmmss = TimeAdd(end_hhmm \* 100, \"M\", -1);

CalcVWAPDistribution(vwap_days, start_hhmmss, end_hhmmss, vwap_dist);

vwap_totalminutes = Array_GetMaxIndex(vwap_dist);

vwap_started = true;

vwap_base_position = Position;

vwap_time_index = 0;

end;

{ VWAP的執行邏輯 }

if vwap_started and Position \<\> vwap_base_position + order_bs \*
order_totalqty then begin

if CurrentTime \>= start_hhmmss then begin

{ 計算目前時間是開始時間後的第幾分鐘 }

value1 = IntPortion(TimeDiff(CurrentTime, start_hhmmss, \"M\"));

if value1 \> vwap_time_index then begin

{ 預期的成交量比例 = vwap_dist\[value1\] }

if value1 \>= vwap_totalminutes then

value2 = 100 { 超過時間 =\> 100% }

else

value2 = vwap_dist\[value1\];

value3 = value2 \* order_totalqty \* order_bs / 100;

if Position \<\> vwap_base_position + value3 then begin

{ 送出委託單 }

SetPosition(vwap_base_position + value3); { TODO: 請填入委託價格 }

end;

vwap_time_index = value1;

end;

end;

end;

#### 📄 04-網格交易

{@type:autotrade}

{

網格交易: 每當價格跌破一個網格時就買進, 上漲一個網格時則賣出

輸入參數:

\- 網格間隔 (grid_gap: 定義網格的間距)

\- 網格數目 (grid_maxcount: 往上/往下分別設定的網格數目)

\- 停損點 (stoploss_point: 當價格超過停損點時, 執行停損.
停損點通常布置在最大網格之外)

執行邏輯:

\- 系統啟動時, 以當時的價格為中心點,

\- 當市價下跌超過一個網格時, 買進1張,

\- 當市價上漲超過一個網格時, 賣出1張, 也就是低買高賣,

\- 如果市價上漲/下跌超過最大網格數目時, 就暫停交易,

\- 如果價格持續上漲/下跌, 當超過停損點的話, 則全部平倉停損
(通常停損點會設定在最大網格數目之外)

舉例:

\- 每格100點

\- 共3格

\- 停損點=500

如果在10000點時啟動, 那麼

\- 當價格跌破9900時買進1口, 接下來如果漲回10000時賣出1口,

\- 如果沒有漲回10000, 而是繼續跌到9800時, 則再買進1口
(漲回9900時則賣出1口),

\- 如果持續下跌, 每100點就買進1口, 可是最低就到9700(3格=300點),
再往下跌就不買了,

\- 如果很不幸的, 一直往下跌, 那麼當跌破9500時(10000-500=停損點),
則全部停損,

\- 同理, 如果價格一開始就往上走, 例如漲到10100點時, 就賣出1口,
如果跌回10000點, 則買進1口,

\- 如果繼續上漲, 到了10200點時, 再賣出1口 (跌回10100時則買進1口),

\- 如果很不幸的, 一直往上漲, 那麼當漲到10500時(10000+500=停損點),
則全部停損,

\- 交易邏輯是低買高賣, 預期價格會在區間震盪,
賺取價格在網格之間穿越時的買賣差額

Note: 以下程式碼假設商品一開始的部位 = 0

}

input: grid_gap(20, \"每格點數\");

input: grid_maxcount(3, \"最多格數\");

input: stoploss_point(100, \"停損(點)\");

{

範例:

策略一啟動就以當時收盤價為基礎啟動網格交易, 一直跑到停損點觸發為止

}

var: intrabarpersist grid_started(false); { 開始網格交易 }

var: intrabarpersist grid_base(0); { 網格中心點:
如果不是0的話表示已經啟動 }

var: intrabarpersist grid_current_base(0); { 目前的網格中心點:
依照價格移動 }

var: intrabarpersist grid_current_ord(0); { 目前的網格的編號, 正中央=0,
往上=1, 2, 3, 往下=-1,-2,-3}

var: intrabarpersist grid_buycount(0); { 進入網格後的買進數量合計 }

var: intrabarpersist grid_sellcount(0); { 進入網格後的賣出數量合計,
用buycount/sellcount可以估算目前損益(每個買賣賺一個grid) }

if not grid_started and GetInfo(\"TradeMode\") = 1 then begin

grid_started = true;

grid_base = Close;

grid_current_base = Close;

grid_current_ord = 0;

grid_buycount = 0;

grid_sellcount = 0;

Print(\"=\>啟動網格中心點:\", numtostr(grid_current_base, 0));

end;

{ 網格交易邏輯 }

if grid_base \<\> 0 then begin

if Close \>= grid_base + stoploss_point or Close \<= grid_base -
stoploss_point then begin

SetPosition(0, label:=\"網格:停損出場\"); { 全部平倉,
停止網格交易(TODO:請填入委託價格) }

grid_base = 0; { 停止網格交易 }

end else begin

{

比對目前價格與current_grid_base, 看價格是否穿越網格跳過幾格

請注意以下的邏輯有處理一次跳過多格的情形

}

if Close \>= grid_current_base + grid_gap then begin

value1 = grid_current_ord + IntPortion((Close - grid_current_base) /
grid_gap);

if value1 \>= grid_maxcount then value1 = grid_maxcount;

value1 = value1 - grid_current_ord; { 往上移動的格數 }

if value1 \> 0 then begin

{ 往上移動網格 }

grid_current_base = grid_current_base + value1 \* grid_gap;

grid_current_ord = grid_current_ord + value1;

grid_sellcount = grid_sellcount + value1;

SetPosition(Position - value1, label:=\"網格:上漲賣出\"); { 賣出
(TODO:請填入委託價格) }

end;

end else if Close \<= grid_current_base - grid_gap then begin

value1 = grid_current_ord - IntPortion((grid_current_base - Close) /
grid_gap);

if value1 \<= -1 \* grid_maxcount then value1 = -1 \* grid_maxcount;

value1 = grid_current_ord - value1; { 往下移動的格數 }

if value1 \> 0 then begin

{ 往下移動網格 }

grid_current_base = grid_current_base - value1 \* grid_gap;

grid_current_ord = grid_current_ord - value1;

grid_buycount = grid_buycount + value1;

SetPosition(Position + value1, label:=\"網格:下跌買進\"); { 買進
(TODO:請填入委託價格) }

end;

end;

end;

end;

#### 📄 05-冰山委託單(Iceberg)

{@type:autotrade}

{

冰山單(Iceberg): 把要買進的數量分批低掛

輸入參數:

\- 最高價格 (ice_maxprice: 當市價超過這個價格時, 就暫停交易)

\- 委託價差 (ice_below: 目前市價=X時, 委託價格=X-ice_below(for buying),
也就是低買的價格位置, 目前是定義成絕對值)

\- 委託方向 (ice_bs: 1=買進, -1=賣出)

\- 委託總數量 (ice_totalqty: 預期總成交數量)

\- 每次委託數量 (ice_batchqty: 每一次委託單的大小)

執行邏輯(for買進)

\- 當目前價格 = X時, 如果X \<= ice_maxprice, 送出一筆委託單, 價格 = X -
ice_below, 數量 = ice_batchqty,

\- 如果成交的話, 依照目前的價格送出下一筆委託單,

\- 如果目前的價格Y \>= X + 2 \* ice_below, and Y \<= ice_maxprice,
則取消剩餘委託, 用目前的市場價格重新送出

\- Buy the dip =\> 低接

Note: 以下程式碼假設商品一開始的部位 = 0

}

input: ice_maxprice(14000, \"最高價格\");

input: ice_below(10, \"委託單價差\");

input: ice_bs(1, \"買賣方向\", inputKind:=Dict(\[\"買進\", 1\],
\[\"賣出\", -1\]));

input: ice_totalqty(100, \"總委託數量\");

input: ice_batchqty(10, \"每次委託數量\");

var: intrabarpersist ice_lastorderprice(0); // 最後一次委託價格

var: intrabarpersist ice_started(false); // 已經啟動Iceberg交易

if not ice_started and GetInfo(\"TradeMode\") = 1 then begin

ice_started = true;

ice_lastorderprice = 0;

end;

{ 冰山交易邏輯 }

if ice_started and Filled \<\> ice_bs \* ice_totalqty then begin

{ 如果目前市場價格超過最大值, 則不處理. 已經送出的委託就維持不動 }

if (ice_bs = 1 and Close \> ice_maxprice) or

(ice_bs = -1 and Close \< ice_maxprice) then

return;

if Position = 0 then begin

{ 送出第一次委託 }

ice_lastorderprice = Close - ice_bs \* ice_below;

SetPosition(ice_bs \* ice_batchqty, ice_lastorderprice);

end else if Position = Filled then begin

{ 送出下一批次委託 }

ice_lastorderprice = Close - ice_bs \* ice_below;

SetPosition(Position + ice_bs \* ice_batchqty, ice_lastorderprice);

end else if ice_bs = 1 and Close \> ice_lastorderprice + 2 \* ice_below
then begin

{ 價格移動, 追價 }

ice_lastorderprice = Close - ice_bs \* ice_below;

SetPosition(Position, ice_lastorderprice);

end else if ice_bs = -1 and Close \< ice_lastorderprice - 2 \* ice_below
then begin

{ 價格移動, 追價 }

ice_lastorderprice = Close - ice_bs \* ice_below;

SetPosition(Position, ice_lastorderprice);

end;

end;

### 5.5 常見技術分析 (28 個)

#### 📄 ATR觸發上通道

{@type:autotrade}

// 宣告參數

input:period(20,\"計算TrueRange的區間\"),N(2,\"N倍通道\");

// 資料讀取筆數設定

settotalbar(period + 3);

value1=average(truerange,period);

value2=average(close,period);

value3=value2+N\*value1;

value4=value2-N\*value1;

// 多方進場策略：向上突破上通道。出場策略：向下跌破下通道。

if close crosses over value3 then setposition(1);

if close crosses below value4 then setposition(0);

#### 📄 DIF-MACD從負翻正

{@type:autotrade}

// 宣告參數

input: FastLength(12, \"DIF短期期數\"), SlowLength(26, \"DIF長期期數\"),
MACDLength(9, \"MACD期數\");

variable: difValue(0), macdValue(0), oscValue(0);

// 資料讀取筆數設定

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 3 + 8);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

// 多方進場策略：DIF-MACD由負轉正。出場策略：DIF-MACD由正轉負。

if oscValue Crosses Above 0 then setposition(1);

if oscValue Crosses below 0 then setposition(0);

#### 📄 DIF黃金交叉MACD

{@type:autotrade}

// 需告參數

input: FastLength(12, \"DIF短期期數\"), SlowLength(26, \"DIF長期期數\"),
MACDLength(9, \"MACD期數\");

variable: difValue(0), macdValue(0), oscValue(0);

// 資料讀取筆數設定

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 3 + 8);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

// 多方進場策略：DIF黃金交叉MACD；出場策略：DIF死亡交叉MACD

if difValue Crosses Above macdValue then setposition(1);

if difValue Crosses below macdValue then setposition(0);

#### 📄 KD低檔黃金交叉

{@type:autotrade}

// 宣告參數

input: Length(9, \"計算期數\"), RSVt(3, \"RSVt權數\"), Kt(3,
\"Kt權數\"), LowBound(25, \"低檔區\"), HighBound(75, \"高檔區\");

variable: \_rsv(0), \_k(0), \_d(0);

// 資料讀取筆數設定

SetTotalBar(maxlist(Length,6) \* 3 + 8);

Stochastic(Length, RSVt, Kt, \_rsv, \_k, \_d);

// 多方進場策略：K在低檔區由下往上突破D值。出場策略：K由上往下穿越D值。

if \_k \< LowBound and \_k crosses above \_d then setposition(1);

if \_k \> HighBound and \_k crosses under \_d then setposition(0);

#### 📄 MTM黃金交叉0

{@type:autotrade}

// 宣告參數

Input: Length(10, \"期數\");

// 資料讀取筆數設定

settotalbar(maxlist(Length,6) + 8);

// 多方進場策略：MTM黃金交叉0軸；出場策略：MTM死亡交叉0軸

if Momentum(Close, Length) Crosses Above 0 then setposition(1);

if Momentum(Close, Length) Crosses below 0 then setposition(0);

#### 📄 RSI低檔價格背離

{@type:autotrade}

// 宣告參數

Input: RSILength(10, \"RSI期數\"), \_LThreshold(20, \"低檔值\"),
\_HThreshold(80, \"高檔值\");

variable: rsiValue(0),RSI_linearregslope(0),Close_linearregslope(0);

// 資料讀取筆數設定

settotalbar(maxlist(RSILength,6) \* 8 + 8);

if RSILength \< 5 then raiseruntimeerror(\"計算期別請超過五期\");

RSIValue = RSI(Close, RSILength);

RSI_linearregslope = linearregslope(RSIValue, RSILength);

Close_linearregslope = linearregslope(Close, RSILength);

//
多方進場策略：RSI由下往上突破低檔區，且價格趨勢背離。出場策略：RSI由上往下穿越高檔區，且價格趨勢背離。

if RSIValue Crosses Above \_LThreshold and RSI_linearregslope \> 0 and
Close_linearregslope \< 0 then setposition(1);

if RSIValue Crosses Below \_HThreshold and RSI_linearregslope \< 0 and
Close_linearregslope \> 0 then setposition(0);

#### 📄 均線黃金交叉

{@type:autotrade}

// 宣告參數

input: Shortlength(5,\"短期均線期數\"), Longlength(20,\"長期均線期數\");

// 資料讀取筆數設定

settotalbar(8);

setbarback(maxlist(Shortlength,Longlength,6));

//
多方進場策略：短期均線「黃金」交叉長期均線。出場策略：長期均線「死亡」交叉短期均線。

if Average(Close,Shortlength) Cross Above Average(Close,Longlength) then
setposition(1);

if Average(Close,Shortlength) Cross Below Average(Close,Longlength) then
setposition(0);

#### 📄 布林通道觸碰下軌

{@type:autotrade}

// 宣告參數

Input: Length(20, \"期數\"), UpperBand(2, \"通道上緣\"), LowerBand(2,
\"通道下緣\");

variable: mid(0), up(0), down(0);

// 資料讀取筆數設定

settotalbar(Length + 3);

up = bollingerband(Close, Length, UpperBand);

down = bollingerband(Close, Length, -1 \* LowerBand);

mid = (up + down) / 2;

//
多方包寧傑通道進場策略：最低價觸碰下軌道。出場策略：最高價觸碰上軌道。

if low cross under down then setposition(1);

if high cross over up then setposition(0);

#### 📄 帶量黃金交叉均線

{@type:autotrade}

// 宣告參數

input: Length(10, \"期數\"), VolFactor(2, \"成交量放大倍數\");

var: avgP(0), avgVol(0);

// 設定資料讀取筆數

settotalbar(3);

setbarback(Length);

avgP = Average(close, Length);

avgVol = Average(volume, Length);

// 多方進場策略：帶量黃金交叉均線；出場策略：帶量死亡交叉均線。

if close cross above avgP and volume \> avgVol \* VolFactor then
setposition(1);

if close cross below avgP and volume \> avgVol \* VolFactor then
setposition(0);

#### 📄 平滑CCI超賣

{@type:autotrade}

// 宣告變數

Input: Length(14, \"期數\"), AvgLength(9, \"平滑期數\"), OverSold(-100,
\"超賣值\");

Variable: cciValue(0), cciMAValue(0);

// 資料讀取筆數設定

SetTotalBar(maxlist(AvgLength + Length + 1,6) + 11);

cciValue = CommodityChannel(Length);

cciMAValue = Average(cciValue, AvgLength);

//
多方進場策略：平滑CCI死亡交叉超賣值。出場策略：平滑CCI黃金交叉超賣值。

if cciMAValue Crosses Below OverSold then setposition(1);

if cciMAValue Crosses above OverSold then setposition(0);

#### 📄 短期RSI黃金交叉長期RSI

{@type:autotrade}

// 宣告參數

input: ShortLength(6, \"短期期數\"), LongLength(12, \"長期期數\");

var:RSI_Short(0), RSI_Long(0);

// 設定資料讀取筆數

settotalbar(maxlist(ShortLength,LongLength,6) \* 8 + 8);

RSI_Short=RSI(Close, ShortLength);

RSI_Long=RSI(Close, LongLength);

//多方進場策略：短期RSI黃金交叉長期RSI；出場策略：短期RSI死亡交叉長期RSI

if RSI_Short Crosses Above RSI_Long then setposition(1);

if RSI_Short Crosses below RSI_Long then setposition(0);

#### 📄 股價黃金交叉三均線

{@type:autotrade}

// 宣告參數

input: shortlength(5,\"短期均線期數\"), midlength(10,\"中期均線期數\"),
Longlength(20,\"長期均線期數\");

variable: shortaverage(0), midaverage(0), Longaverage(0);

// 資料讀取筆數設定

settotalbar(3);

setbarback(maxlist(shortlength,midlength,Longlength));

shortaverage=Average(close,shortlength);

midaverage=Average(close,midlength) ;

Longaverage=Average(close,Longlength);

// 多方進場策略：收盤價黃金交叉三均線。出場策略：收盤價死亡交叉三均線。

if close cross above maxlist(shortaverage, midaverage, longaverage) then
setposition(1);

if close cross below minlist(shortaverage, midaverage, longaverage) then
setposition(0);

#### 📄 股價黃金交叉單均線

{@type:autotrade}

// 宣告參數

input: length(5,\"均線期數\");

variable: avgValue(0);

// 資料讀取筆數設定

settotalbar(3);

setbarback(length);

avgValue = Average(close,length);

// 多方進場策略：收盤價黃金交叉均線。出場策略：收盤價死亡交叉均線。

if close cross above avgValue then setposition(1);

if close cross below avgValue then setposition(0);

#### 📄 股價黃金交叉雙均線

{@type:autotrade}

// 宣告參數

input: shortlength(5,\"短期均線期數\"), Longlength(20,\"長期均線期數\");

variable: Longaverage(0), shortaverage(0);

// 資料讀取筆數設定

settotalbar(3);

setbarback(maxlist(shortlength,Longlength));

Longaverage = Average(close,Longlength);

shortaverage= Average(close,shortlength);

// 多方進場策略：收盤價黃金交叉雙均線。出場策略：收盤價死亡交叉雙均線。

if close cross above maxlist(shortaverage, longaverage) then
setposition(1);

if close cross below minlist(shortaverage, longaverage) then
setposition(0);

#### 📄 ATR觸發下通道

{@type:autotrade}

// 宣告參數

input:period(20,\"計算TrueRange的區間\"),N(2,\"N倍通道\");

// 資料讀取筆數設定

settotalbar(period + 3);

value1=average(truerange,period);

value2=average(close,period);

value3=value2+N\*value1;

value4=value2-N\*value1;

// 空方進場策略：向下跌破下通道。出場策略：向上突破上通道。

if close crosses below value4 then setposition(-1);

if close crosses over value3 then setposition(0);

#### 📄 DIF-MACD從正翻負

{@type:autotrade}

// 宣告參數

input: FastLength(12, \"DIF短期期數\"), SlowLength(26, \"DIF長期期數\"),
MACDLength(9, \"MACD期數\");

variable: difValue(0), macdValue(0), oscValue(0);

// 資料讀取筆數設定

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 3 + 8);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

// 空方進場策略：DIF-MACD由正轉負。出場策略：DIF-MACD由負轉正。

if oscValue Crosses below 0 then setposition(-1);

if oscValue Crosses Above 0 then setposition(0);

#### 📄 DIF死亡交叉MACD

{@type:autotrade}

// 需告參數

input: FastLength(12, \"DIF短期期數\"), SlowLength(26, \"DIF長期期數\"),
MACDLength(9, \"MACD期數\");

variable: difValue(0), macdValue(0), oscValue(0);

// 資料讀取筆數設定

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) \* 3 + 8);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

// 空方進場策略：DIF死亡交叉MACD；出場策略：DIF黃金交叉MACD

if difValue Crosses below macdValue then setposition(-1);

if difValue Crosses Above macdValue then setposition(0);

#### 📄 KD低檔死亡交叉

{@type:autotrade}

// 宣告參數

input: Length(9, \"計算期數\"), RSVt(3, \"RSVt權數\"), Kt(3,
\"Kt權數\"), LowBound(25, \"低檔區\"), HighBound(75, \"高檔區\");

variable: \_rsv(0), \_k(0), \_d(0);

// 資料讀取筆數設定

SetTotalBar(maxlist(Length,6) \* 3 + 8);

Stochastic(Length, RSVt, Kt, \_rsv, \_k, \_d);

// 空方進場策略：K在高檔區由上往下穿越D值。出場策略：K由下往上突破D值。

if \_k \> HighBound and \_k crosses under \_d then setposition(-1);

if \_k \< LowBound and \_k crosses above \_d then setposition(0);

#### 📄 MTM死亡交叉0

{@type:autotrade}

// 宣告參數

Input: Length(10, \"期數\");

// 資料讀取筆數設定

settotalbar(maxlist(Length,6) + 8);

// 空方進場策略：MTM死亡交叉0軸；出場策略：MTM黃金交叉0軸

if Momentum(Close, Length) Crosses below 0 then setposition(-1);

if Momentum(Close, Length) Crosses Above 0 then setposition(0);

#### 📄 RSI高檔價格背離

{@type:autotrade}

// 宣告參數

Input: RSILength(10, \"RSI期數\"), \_LThreshold(20, \"低檔值\"),
\_HThreshold(80, \"高檔值\");

variable: rsiValue(0),RSI_linearregslope(0),Close_linearregslope(0);

// 資料讀取筆數設定

settotalbar(maxlist(RSILength,6) \* 8 + 8);

if RSILength \< 5 then raiseruntimeerror(\"計算期別請超過五期\");

RSIValue = RSI(Close, RSILength);

RSI_linearregslope = linearregslope(RSIValue, RSILength);

Close_linearregslope = linearregslope(Close, RSILength);

//
空方進場策略：RSI由上往下穿越高檔區，且價格趨勢背離。出場策略：RSI由下往上突破低檔區，且價格趨勢背離。

if RSIValue Crosses Below \_HThreshold and RSI_linearregslope \< 0 and
Close_linearregslope \> 0 then setposition(-1);

if RSIValue Crosses Above \_LThreshold and RSI_linearregslope \> 0 and
Close_linearregslope \< 0 then setposition(0);

#### 📄 均線死亡交叉

{@type:autotrade}

// 宣告參數

input: Shortlength(5,\"短期均線期數\"), Longlength(20,\"長期均線期數\");

// 資料讀取筆數設定

settotalbar(8);

setbarback(maxlist(Shortlength,Longlength,6));

//
空方進場策略：長期均線「死亡」交叉短期均線。出場策略：短期均線「黃金」交叉長期均線。

if Average(Close,Shortlength) Cross Below Average(Close,Longlength) then
setposition(-1);

if Average(Close,Shortlength) Cross Above Average(Close,Longlength) then
setposition(0);

#### 📄 布林通道觸碰上軌

{@type:autotrade}

// 宣告參數

Input: Length(20, \"期數\"), UpperBand(2, \"通道上緣\"), LowerBand(2,
\"通道下緣\");

variable: mid(0), up(0), down(0);

// 資料讀取筆數設定

settotalbar(Length + 3);

up = bollingerband(Close, Length, UpperBand);

down = bollingerband(Close, Length, -1 \* LowerBand);

mid = (up + down) / 2;

//
空方包寧傑通道進場策略：最高價觸碰上軌道。出場策略：最低價觸碰下軌道。

if high cross over up then setposition(-1);

if low cross under down then setposition(0);

#### 📄 帶量死亡交叉均線

{@type:autotrade}

// 宣告參數

input: Length(10, \"期數\"), VolFactor(2, \"成交量放大倍數\");

var: avgP(0), avgVol(0);

// 設定資料讀取筆數

settotalbar(3);

setbarback(Length);

avgP = Average(close, Length);

avgVol = Average(volume, Length);

// 空方進場策略：帶量死亡交叉均線；出場策略：帶量黃金交叉均線。

if close cross below avgP and volume \> avgVol \* VolFactor then
setposition(-1);

if close cross above avgP and volume \> avgVol \* VolFactor then
setposition(0);

#### 📄 平滑CCI超買

{@type:autotrade}

// 宣告變數

Input: Length(14, \"期數\"), AvgLength(9, \"平滑期數\"), OverSold(100,
\"超買值\");

Variable: cciValue(0), cciMAValue(0);

// 資料讀取筆數設定

SetTotalBar(maxlist(AvgLength + Length + 1,6) + 11);

cciValue = CommodityChannel(Length);

cciMAValue = Average(cciValue, AvgLength);

//
空方進場策略：平滑CCI黃金交叉超賣值。出場策略：平滑CCI死亡交叉超賣值。

if cciMAValue Crosses above OverSold then setposition(-1);

if cciMAValue Crosses Below OverSold then setposition(0);

#### 📄 短期RSI死亡交叉長期RSI

{@type:autotrade}

// 宣告參數

input: ShortLength(6, \"短期期數\"), LongLength(12, \"長期期數\");

var:RSI_Short(0), RSI_Long(0);

// 設定資料讀取筆數

settotalbar(maxlist(ShortLength,LongLength,6) \* 8 + 8);

RSI_Short=RSI(Close, ShortLength);

RSI_Long=RSI(Close, LongLength);

//
空方進場策略：短期RSI死亡交叉長期RSI；出場策略：短期RSI黃金交叉長期RSI

if RSI_Short Crosses below RSI_Long then setposition(-1);

if RSI_Short Crosses above RSI_Long then setposition(0);

#### 📄 股價死亡交叉三均線

{@type:autotrade}

// 宣告參數

input: shortlength(5,\"短期均線期數\"), midlength(10,\"中期均線期數\"),
Longlength(20,\"長期均線期數\");

variable: shortaverage(0), midaverage(0), Longaverage(0);

// 資料讀取筆數設定

settotalbar(3);

setbarback(maxlist(shortlength,midlength,Longlength));

shortaverage=Average(close,shortlength);

midaverage=Average(close,midlength) ;

Longaverage=Average(close,Longlength);

// 空方進場策略：收盤價死亡交叉三均線。出場策略：收盤價黃金交叉三均線。

if close cross below minlist(shortaverage, midaverage, longaverage) then
setposition(-1);

if close cross above maxlist(shortaverage, midaverage, longaverage) then
setposition(0);

#### 📄 股價死亡交叉單均線

{@type:autotrade}

// 宣告參數

input: length(5,\"均線期數\");

variable: avgValue(0);

// 資料讀取筆數設定

settotalbar(3);

setbarback(length);

avgValue = Average(close,length);

// 空方進場策略：收盤價死亡交叉均線。出場策略：收盤價黃金交叉均線。

if close cross below avgValue then setposition(-1);

if close cross above avgValue then setposition(0);

#### 📄 股價死亡交叉雙均線

{@type:autotrade}

// 宣告參數

input: shortlength(5,\"短期均線期數\"), Longlength(20,\"長期均線期數\");

variable: Longaverage(0), shortaverage(0);

// 資料讀取筆數設定

settotalbar(3);

setbarback(maxlist(shortlength,Longlength));

Longaverage = Average(close,Longlength);

shortaverage= Average(close,shortlength);

// 空方進場策略：收盤價死亡交叉雙均線。出場策略：收盤價黃金交叉雙均線。

if close cross below minlist(shortaverage, longaverage) then
setposition(-1);

if close cross above maxlist(shortaverage, longaverage) then
setposition(0);

> 📖 語法規範請參閱：XScript_官方語法與核心說明文件.md
>
> 📝 實戰範例請參閱：XScript_實戰範例寶典.md
>
> 🔗
> 原始碼來源：[[https://github.com/sysjust-xq/XScript_Preset]{.underline}](https://github.com/sysjust-xq/XScript_Preset)
