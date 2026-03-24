# XScript 實戰範例寶典（上）

> 自動整理自
> [[https://www.xq.com.tw/xstrader/]{.underline}](https://www.xq.com.tw/xstrader/)
> 本冊收錄場景 1～619（共 619 段程式碼）

## 場景 1：XQ量化交易平台學習地圖 --- 在XQ量化平台裡，如果你要寫收最高就市價買進一張，可以像下面這麼寫：

> 來源：[[XQ量化交易平台學習地圖]{.underline}](https://www.xq.com.tw/xstrader/xslearnmap/)
> 說明：在XQ量化平台裡，如果你要寫收最高就市價買進一張，可以像下面這麼寫：

if close=high then setposition(1,market);

## 場景 2：XQ量化交易平台學習地圖 --- 有了對XQ語法的基本認識之後，我們來舉個實例

> 來源：[[XQ量化交易平台學習地圖]{.underline}](https://www.xq.com.tw/xstrader/xslearnmap/)
> 說明：有了對XQ語法的基本認識之後，我們來舉個實例

if close\*1.4\<close\[90\]

//過去90天股價跌了超過四成

and close\*1.2\<close\[20\]

//過去20天股價跌了超過兩成

then begin

if close\[1\]\*1.05\<close\[2\]

//前一天跌了超過5%

and close\>1.05\*close\[1\]

//最近一個交易日漲了超過5%

then ret=1;

end;

## 場景 3：XQ量化交易平台學習地圖

> 來源：[[XQ量化交易平台學習地圖]{.underline}](https://www.xq.com.tw/xstrader/xslearnmap/)
> 說明：以下是對應的寫法：

value1=GetField(\"外資買賣超\");

value2=GetField(\"外資持股比例\");

if value2\>20

and trueall(value1\>1000,3)

then ret=1;

## 場景 4：XQ量化交易平台學習地圖 --- 例如可以像下面的寫法：

> 來源：[[XQ量化交易平台學習地圖]{.underline}](https://www.xq.com.tw/xstrader/xslearnmap/)
> 說明：例如可以像下面的寫法：

value1=GetField(\"關鍵券商買賣超張數\",\"D\")\[1\];

if trueall(value1\>200,3)

then ret=1;

## 場景 5：XQ量化交易平台學習地圖 --- getquote跟getfield最大的差別在於，getquote取得的是最新的特定欄位的值，所以不能用中括號來呼收前N期的值，因為getquote取得的就是當\...

> 來源：[[XQ量化交易平台學習地圖]{.underline}](https://www.xq.com.tw/xstrader/xslearnmap/)
> 說明：getquote跟getfield最大的差別在於，getquote取得的是最新的特定欄位的值，所以不能用中括號來呼收前N期的值，因為getquote取得的就是當下的數據，舉個例子：

condition1=false;

condition2=false;

value1= q_SumBidSize;//總委買張數

value2=q_SumAskSize;//總委賣張數

if value1-value2\>1000

and value2\<500

then condition1=true;

value3=q_InSize;//內盤量

value4=q_OutSize;//外盤量

if value4\>1000

and value4/value3\>1.5

then condition2=true;

if condition1 or condition2 then

ret=1;

## 場景 6：XQ量化交易平台學習地圖 --- 如果有一段程式，我們常會用到，那麼就可以把它寫成函數，之後每次要用到這段程式，只要用函數來寫就可以了。例如我們最常用的移動平均值，是把特定期間的某個值加總後去除\...

> 來源：[[XQ量化交易平台學習地圖]{.underline}](https://www.xq.com.tw/xstrader/xslearnmap/)
> 說明：如果有一段程式，我們常會用到，那麼就可以把它寫成函數，之後每次要用到這段程式，只要用函數來寫就可以了。例如我們最常用的移動平均值，是把特定期間的某個值加總後去除以期數，所以XQ就把它寫成一個系統內建的函數如下：

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

if Length \> 0 then

Average = Summation(thePrice, Length) / Length

else

Average =0;

## 場景 7：用XQ+Gemini寫策略雷達

> 來源：[[用XQ+Gemini寫策略雷達]{.underline}](https://www.xq.com.tw/xstrader/%e7%94%a8xqgemini%e5%af%ab%e7%ad%96%e7%95%a5%e9%9b%b7%e9%81%94/)

// 策略名稱：尾盤沉寂爆發與創高突破雷達

// 策略類型：策略雷達 (請設定於 1分鐘線 或 Tick 頻率執行)

SetTotalBar(30); // 確保有足夠天數計算過去 20 天的日線漲跌幅

var:

refPrice(0), dailyHigh(0), dailyVol(0), pastMaxGain(0),

isTimeMatch(false), isHighestPrice(false), isGainMatch(false),
isVolMatch(false), isQuietPast(false);

// ==========================================

// 1. 時間濾網：下午 1:20 (13:20:00) 之後

// ==========================================

// 實務上通常設定為大於等於該時間，確保 1:20 之後只要觸發條件就通知

if Time \>= 132000 then

isTimeMatch = true

else

isTimeMatch = false;

// ==========================================

// 2. 當日價量條件：漲幅 \> 3% 且 累積成交量 \> 2000張

// ==========================================

refPrice = GetField(\"參考價\", \"D\");

dailyVol = GetField(\"成交量\", \"D\");

// 防呆機制：確保參考價大於 0 才計算漲幅，避免新股或異常資料報錯

if refPrice \> 0 and (Close - refPrice) / refPrice \* 100 \> 3.0 then

isGainMatch = true

else

isGainMatch = false;

if dailyVol \> 2000 then

isVolMatch = true

else

isVolMatch = false;

// ==========================================

// 3. 創高條件：目前股價等於當日最高價

// ==========================================

dailyHigh = GetField(\"最高價\", \"D\");

// 盤中即時價格等於今日最高價 (強勢表態)

if Close = dailyHigh then

isHighestPrice = true

else

isHighestPrice = false;

// ==========================================

// 4. 籌碼沉澱條件：過去 20 天從來沒有單日漲超過 2%

// ==========================================

// 抓取過去 20 天 (從昨天 \[1\] 開始往前算) 的最大單日漲幅

pastMaxGain = Highest(GetField(\"漲跌幅\", \"D\")\[1\], 20);

if pastMaxGain \<= 2.0 then

isQuietPast = true

else

isQuietPast = false;

// ==========================================

// 綜合篩選與觸發

// ==========================================

if isTimeMatch and isGainMatch and isVolMatch and isHighestPrice and
isQuietPast then

begin

ret = 1;

// 雷達觸發時，推播顯示輔助判斷欄位

outputfield1((Close - refPrice) / refPrice \* 100, \"今日漲幅(%)\");

outputfield2(dailyVol, \"今日累積總量\");

outputfield3(pastMaxGain, \"近20日最大漲幅(%)\");

end;

## 場景 8：用XQ+Gemini寫策略雷達

> 來源：[[用XQ+Gemini寫策略雷達]{.underline}](https://www.xq.com.tw/xstrader/%e7%94%a8xqgemini%e5%af%ab%e7%ad%96%e7%95%a5%e9%9b%b7%e9%81%94/)
> 說明：於是它重寫了一個腳本

// 策略名稱：尾盤沉寂爆發與創高突破雷達 (警示腳本專用版)

// 執行頻率：1分鐘線 或 Tick

var:

refPrc(0), highToday(0), volToday(0), gainToday(0),

i(0), pastGain(0),

isTimeMatch(false), isHighestPrice(false), isGainMatch(false),
isVolMatch(false), isQuietPast(true);

// ==========================================

// 1. 時間濾網：下午 1:20 (13:20:00) 之後

// ==========================================

if Time \>= 132000 then

isTimeMatch = true

else

isTimeMatch = false;

// ==========================================

// 2. 當日價量條件：漲幅 \> 3% 且 累積成交量 \> 2000張

// ==========================================

refPrc = GetField(\"參考價\", \"D\");

volToday = GetField(\"成交量\", \"D\");

// 手動計算今日漲幅

if refPrc \> 0 then

gainToday = (Close - refPrc) / refPrc \* 100

else

gainToday = 0;

if gainToday \> 3.0 then

isGainMatch = true

else

isGainMatch = false;

if volToday \> 2000 then

isVolMatch = true

else

isVolMatch = false;

// ==========================================

// 3. 創高條件：目前股價等於當日最高價

// ==========================================

highToday = GetField(\"最高價\", \"D\");

if Close = highToday then

isHighestPrice = true

else

isHighestPrice = false;

// ==========================================

// 4. 籌碼沉澱條件：過去 20 天從來沒有單日漲超過 2%

// ==========================================

// 警示腳本無「漲跌幅」欄位，需利用日線收盤價迴圈手動計算

isQuietPast = true; // 預設為沉寂，只要抓到一天漲幅過大就判定失敗

for i = 1 to 20 begin

// 計算過去第 i 天的漲幅：(第i天收盤 - 第i+1天收盤) / 第i+1天收盤 \* 100

if GetField(\"收盤價\", \"D\")\[i+1\] \> 0 then begin

pastGain = (GetField(\"收盤價\", \"D\")\[i\] - GetField(\"收盤價\",
\"D\")\[i+1\]) / GetField(\"收盤價\", \"D\")\[i+1\] \* 100;

// 若過去20天內有任何一天單日漲幅大於 2%，則不符合沉寂條件

if pastGain \> 2.0 then

isQuietPast = false;

end;

end;

// ==========================================

// 綜合篩選與觸發

// ==========================================

if isTimeMatch and isGainMatch and isVolMatch and isHighestPrice and
isQuietPast then

begin

ret = 1;

// 警示腳本專屬推播語法：利用 retmsg 將即時數據推送到手機或電腦通知

retmsg = \"尾盤突擊！量:\" + NumToStr(volToday, 0) + \"張, 漲幅:\" +
NumToStr(gainToday, 2) + \"%\";

end;

## 場景 9：給Gemini的預先Prompt --- 抓取加權指數或特定商品數據作大盤濾網時，必須使用

> 來源：[[給Gemini的預先Prompt]{.underline}](https://www.xq.com.tw/xstrader/%e7%b5%a6gemini%e7%9a%84%e9%a0%90%e5%85%88prompt/)
> 說明：抓取加權指數或特定商品數據作大盤濾網時，必須使用

GetSymbolField(\"TSE.TW\", \"Close\", \"D\")

## 場景 10：XQ+Gemini Text to Code 流程說明 --- 在左方的關鍵字搜尋欄打入欄位的名稱，右邊會有正確的用法，到編輯器去修改成正確的字句，例如這個例子裡，董監持股比例%應該改成董監持股佔股本比例

> 來源：[[XQ+Gemini Text to Code
> 流程說明]{.underline}](https://www.xq.com.tw/xstrader/xqgemini-text-to-code-%e6%b5%81%e7%a8%8b%e8%aa%aa%e6%98%8e/)
> 說明：在左方的關鍵字搜尋欄打入欄位的名稱，右邊會有正確的用法，到編輯器去修改成正確的字句，例如這個例子裡，董監持股比例%應該改成董監持股佔股本比例

【老司機踩坑經驗談】： 有時候 Gemini
會自己發明名詞，我們就要動手把「董監持股比例%」改成標準的「董監持股佔股本比例」。
另外還有幾個超級經典的除錯必考題：在 XScript
的世界裡，判斷相等的等號只用單一個 =，絕對不能寫成程式語言常用的
==！而且財報欄位必須一字不差，例如看到 GetField(\"每股稅後淨利\",
\"Q\")，記得要精準修正為 GetField(\"每股稅後淨利(元)\",
\"Q\")。把這些小毛病改完後再按一次編譯，看到成功的畫面那瞬間，真的會想歡呼！

## 場景 11：威廉·歐尼爾 --- 我把CANSLIM的作法請Gemine寫成一個選股策略，它給的腳本如下

> 來源：[[威廉·歐尼爾]{.underline}](https://www.xq.com.tw/xstrader/%e5%a8%81%e5%bb%89%c2%b7%e6%ad%90%e5%b0%bc%e7%88%be/)
> 說明：我把CANSLIM的作法請Gemine寫成一個選股策略，它給的腳本如下

// 策略名稱：William O\'Neil CAN SLIM 成長動能選股

// 策略類型：成長股/動能突破/基本面與技術面混合

SetTotalBar(260); // 確保有足夠的 K 棒計算 200 日均線、52
週高點與年度財報

var:

idxClose(0), idxMa50(0), isMarketBullish(false),

epsCurrQ(0), epsPastQ(0), epsYoY(0),

salesCurrQ(0), salesPastQ(0), salesYoY(0),

epsCurrY(0), epsPast3Y(0), epsCagr3Y(0),

roe(0),

high252(0), isNearNewHigh(false),

avgVol50(0), isVolumeSurge(false),

ma10(0), ma50(0), ma200(0), isLeader(false),

instHoldCurr(0), instHoldPast(0), isInstBuying(false);

// ==========================================

// M: 市場方向 (Market Direction)

// ==========================================

// 歐尼爾鐵律：只在確認的上升趨勢中買進股票。以大盤站上 50MA
為基礎濾網。

idxClose = GetSymbolField(\"TSE.TW\", \"收盤價\", \"D\");

idxMa50 = Average(idxClose, 50);

if idxClose \> idxMa50 then

isMarketBullish = true

else

isMarketBullish = false;

condition1 = isMarketBullish = true;

// ==========================================

// C: 當季盈餘與營收 (Current Earnings)

// ==========================================

// 當季 EPS YoY \>= 20%，且營收 YoY \>= 25% (確保獲利來自本業高速擴張)

epsCurrQ = GetField(\"每股稅後淨利(元)\", \"Q\");

epsPastQ = GetField(\"每股稅後淨利(元)\", \"Q\")\[4\];

if epsPastQ \> 0 then

epsYoY = (epsCurrQ - epsPastQ) / epsPastQ \* 100

else

epsYoY = 0;

salesCurrQ = GetField(\"營業收入淨額\", \"Q\");

salesPastQ = GetField(\"營業收入淨額\", \"Q\")\[4\];

if salesPastQ \> 0 then

salesYoY = (salesCurrQ - salesPastQ) / salesPastQ \* 100

else

salesYoY = 0;

condition2 = epsYoY \>= 20.0 and salesYoY \>= 25.0;

// ==========================================

// A: 年度盈餘 (Annual Earnings)

// ==========================================

// 過去 3 年 EPS CAGR \>= 25% (此處以簡單年化代替)，且 ROE \>= 17%

epsCurrY = GetField(\"每股稅後淨利(元)\", \"Y\");

epsPast3Y = GetField(\"每股稅後淨利(元)\", \"Y\")\[3\];

if epsPast3Y \> 0 then

epsCagr3Y = ((epsCurrY - epsPast3Y) / epsPast3Y) \* 100 / 3

else

epsCagr3Y = 0;

roe = GetField(\"股東權益報酬率\", \"Y\");

condition3 = epsCagr3Y \>= 25.0 and roe \>= 17.0;

// ==========================================

// N: 新高價 (New Highs)

// ==========================================

// 股價位於 52 週新高的 15% 範圍內 (蓄勢待發的樞紐點附近)

high252 = Highest(High\[1\], 252);

if Close \>= (high252 \* 0.85) then

isNearNewHigh = true

else

isNearNewHigh = false;

condition4 = isNearNewHigh = true;

// ==========================================

// S: 供給與需求 (Supply and Demand)

// ==========================================

// 突破時成交量需高於 50 日均量的 40% (即 1.4 倍)，並加上基本流動性過濾

avgVol50 = Average(Volume\[1\], 50);

if Volume \> (avgVol50 \* 1.4) then

isVolumeSurge = true

else

isVolumeSurge = false;

condition5 = isVolumeSurge = true and avgVol50 \> 1000;

// ==========================================

// L: 領導股 (Leader)

// ==========================================

// 股價必須站上 10日、50日及 200日均線，呈現完美的強勢多頭排列

ma10 = Average(Close, 10);

ma50 = Average(Close, 50);

ma200 = Average(Close, 200);

if Close \> ma10 and Close \> ma50 and Close \> ma200 then

isLeader = true

else

isLeader = false;

condition6 = isLeader = true;

// ==========================================

// I: 機構認同度 (Institutional Sponsorship)

// ==========================================

// 投信近 20 日持股比例呈現上升趨勢，確認有 Smart Money 正在進場護航

instHoldCurr = GetField(\"投信持股比例\", \"D\");

instHoldPast = GetField(\"投信持股比例\", \"D\")\[20\];

if instHoldCurr \> instHoldPast then

isInstBuying = true

else

isInstBuying = false;

condition7 = isInstBuying = true;

// ==========================================

// 綜合篩選與輸出

// ==========================================

if condition1 and condition2 and condition3 and condition4 and
condition5 and condition6 and condition7 then

begin

ret = 1;

// 輸出欄位供選股後檢視與排序

outputfield1(epsYoY, \"單季EPS YoY(%)\");

outputfield2(salesYoY, \"單季營收 YoY(%)\");

outputfield3(roe, \"ROE(%)\");

end;

## 場景 12：查·德里豪斯的動能投資之道 --- 一、盈餘驚喜：最近一季EPS超越前一季或去年同期20%以上，代表公司營運出現顯著改善。二、營收動能：近三個月營收年增率持續為正且逐月加速，確認成長趨勢正在強化。\...

> 來源：[[查·德里豪斯的動能投資之道]{.underline}](https://www.xq.com.tw/xstrader/%e6%9f%a5%c2%b7%e5%be%b7%e9%87%8c%e8%b1%aa%e6%96%af%e7%9a%84%e5%8b%95%e8%83%bd%e6%8a%95%e8%b3%87%e4%b9%8b%e9%81%93/)
> 說明：一、盈餘驚喜：最近一季EPS超越前一季或去年同期20%以上，代表公司營運出現顯著改善。二、營收動能：近三個月營收年增率持續為正且逐月加速，確認成長趨勢正在強化。三、股價趨勢：股價站上所有短中長期均線（5日、20日、60日均線多頭排列），且近20日曾創下52週新高。四、相對強度：近三個月股價漲幅排名市場前20%，確認為市場中的領先者。五、成交量確認：近5日平均成交量較前20日平均成交量放大50%以上\...

// 腳本名稱：Driehaus 盈餘驚喜動能模型

// 資料頻率：日 (結合季/月財報)

// ================= 第一階段：全市場相對強度排序 =================

// 條件四：近三個月股價漲幅排名市場前20%

rank RS_Rank begin

// 計算近 60 日 (約三個月) 的價格漲幅

retval = RateOfChange(Close, 60);

end;

// ================= 第二階段：個股條件篩選 =================

// \-\-- 條件一：盈餘驚喜 (EPS超越前一季或去年同期20%以上) \-\--

var: eps_q0(0), eps_q1(0), eps_q4(0);

eps_q0 = GetField(\"每股稅後淨利(元)\", \"Q\");

eps_q1 = GetField(\"每股稅後淨利(元)\", \"Q\")\[1\];

eps_q4 = GetField(\"每股稅後淨利(元)\", \"Q\")\[4\];

condition1 = false;

if eps_q0 \> 0 then begin

if (eps_q1 \> 0 and (eps_q0 - eps_q1) / eps_q1 \>= 0.2) or

(eps_q4 \> 0 and (eps_q0 - eps_q4) / eps_q4 \>= 0.2) then

condition1 = true;

end;

// \-\-- 條件二：營收動能 (近三個月營收年增率持續為正且逐月加速) \-\--

var: rev_yoy_0(0), rev_yoy_1(0), rev_yoy_2(0);

rev_yoy_0 = GetField(\"月營收年增率\", \"M\");

rev_yoy_1 = GetField(\"月營收年增率\", \"M\")\[1\];

rev_yoy_2 = GetField(\"月營收年增率\", \"M\")\[2\];

condition2 = (rev_yoy_0 \> rev_yoy_1) and (rev_yoy_1 \> rev_yoy_2) and
(rev_yoy_2 \> 0);

// \-\-- 條件三：股價趨勢 (均線多頭排列，且近20日曾創下52週新高) \-\--

var: ma5(0), ma20(0), ma60(0);

var: is_bull_aligned(false), is_new_high(false);

ma5 = Average(Close, 5);

ma20 = Average(Close, 20);

ma60 = Average(Close, 60);

is_bull_aligned = (Close \> ma5) and (ma5 \> ma20) and (ma20 \> ma60);

// 52週新高約等於 250 個交易日最高價

if Highest(High, 20) = Highest(High, 250) then is_new_high = true;

condition3 = is_bull_aligned and is_new_high;

// \-\-- 條件四：相對強度 (市場前20%) \-\--

// 假設台股具流動性的上市櫃股票約 1700 檔，前 20% 大約是排名前 340 名

condition4 = RS_Rank.pos \<= 340;

// \-\-- 條件五：成交量確認 (近5日均量較前20日放大50%以上) \-\--

var: vol5(0), vol20(0);

vol5 = Average(Volume, 5);

vol20 = Average(Volume, 20);

condition5 = vol5 \>= (vol20 \* 1.5) and vol20 \> 500; // 加入 \>500
張避免冷門股雜訊

// ================= 綜合輸出 =================

if condition1 and condition2 and condition3 and condition4 and
condition5 then begin

ret = 1;

// 輸出動能與基本面指標供介面排序觀察

outputField1(RS_Rank.pos, \"三個月漲幅排名\");

outputField2(eps_q0, \"最新單季EPS\");

outputField3(rev_yoy_0, \"近月營收YoY(%)\");

outputField4(vol5, \"5日均量\");

end;

## 場景 13：德懷特·安德森\~景氣循環股之王 --- 我用他的邏輯，簡單的寫了一個景氣循環股的篩選腳本

> 來源：[[德懷特·安德森\~景氣循環股之王]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%b7%e6%87%b7%e7%89%b9%c2%b7%e5%ae%89%e5%be%b7%e6%a3%ae%e6%99%af%e6%b0%a3%e5%be%aa%e7%92%b0%e8%82%a1%e4%b9%8b%e7%8e%8b/)
> 說明：我用他的邏輯，簡單的寫了一個景氣循環股的篩選腳本

// 策略名稱：安德森資本週期與基本面選股策略

// 說明：專為 XQ
平台設計，篩選資本支出受限、資產負債表強健且具備長線價格動能的標的。

// 條件 1：資本週期與供應面限制 (Capex/Depreciation \< 1.0)

// 邏輯：資本支出 愈來愈小，代表企業擴產停滯，長期有助於供給收縮

value1 = GetField(\"資本支出金額\", \"Y\");

condition1 = GetField(\"資本支出金額\", \"Y\")
\<GetField(\"資本支出金額\", \"Y\")\[1\]

and GetField(\"資本支出金額\", \"Y\")\[1\]\<GetField(\"資本支出金額\",
\"Y\")\[2\];

// 條件 2：微觀基本面防禦力 (負債比率較低)

// 邏輯：確保公司資產負債表強健，能撐過週期底部
(此處以負債比率小於同業或絕對值 50% 為例)

value3 = GetField(\"負債比率\", \"Q\");

condition2 = value3 \< 50;

// 條件 3：價格動能確認 (避免價值陷阱)

// 邏輯：股價需站上 200 日移動平均線，作為商品/個股動能轉強的確認指標

value4 = Average(Close, 200);

condition3 = Close \> value4;

// 綜合判斷與選股輸出

if condition1 and condition2 and condition3 then

begin

ret = 1;

// 輸出輔助資訊，方便後續在選股戰情室或儀表板中進行排序與多因子權重評估

outputField1(value3, \"負債比率(%)\");

end;

## 場景 14：Foster Friess的動態的評分系統（Scoring System）。 --- 我根據他的精神，寫了一個適合台股的動態評分系統，分數的比重如下

> 來源：[[Foster Friess的動態的評分系統（Scoring
> System）。]{.underline}](https://www.xq.com.tw/xstrader/foster-friess%e7%9a%84%e5%8b%95%e6%85%8b%e7%9a%84%e8%a9%95%e5%88%86%e7%b3%bb%e7%b5%b1%ef%bc%88scoring-system%ef%bc%89%e3%80%82/)
> 說明：我根據他的精神，寫了一個適合台股的動態評分系統，分數的比重如下

// 腳本名稱：Friess 動態替換多因子模型 (全市場排行)

// 資料頻率：日

rank FriessScore begin

// ================= 0. 基本流動性過濾 =================

// 排除股價低於10元或近5日均量低於500張的冷門股，避免籌碼分數失真

if Average(Volume, 5) \< 500 or Close \< 10 then

retval = 0

else begin

var: score1(0), score2(0), score3(0), score4(0);

// ================= 因子1：營收驚喜 (權重 40%) =================

// 邏輯：本月營收年增率，減去「過去6個月平均年增率」

var: rev_yoy(0), rev_avg(0), surprise(0);

rev_yoy = GetField(\"月營收年增率\", \"M\");

rev_avg = Average(GetField(\"月營收年增率\", \"M\")\[1\], 6);

surprise = rev_yoy - rev_avg;

// 正規化：大於等於 50% 拿滿分 100，小於等於 0 拿 0 分

if surprise \>= 50 then score1 = 100

else if surprise \<= 0 then score1 = 0

else score1 = surprise \* 2;

// ================= 因子2：盈餘成長 (權重 30%) =================

// 邏輯：單季稅後淨利年增率

var: earn_yoy(0);

earn_yoy = GetField(\"稅後淨利成長率\", \"Q\");

// 正規化：大於等於 100% 拿滿分 100，小於等於 0 拿 0 分

if earn_yoy \>= 100 then score2 = 100

else if earn_yoy \<= 0 then score2 = 0

else score2 = earn_yoy;

// ================= 因子3：法人籌碼動能 (權重 20%) =================

// 邏輯：近 5 日 (外資買賣超 + 投信買賣超) 佔總成交量的比例

var: inst_net(0), vol_sum(0), inst_ratio(0);

inst_net = Summation(GetField(\"外資買賣超\", \"D\") +
GetField(\"投信買賣超\", \"D\"), 5);

vol_sum = Summation(Volume, 5);

if vol_sum \> 0 then inst_ratio = (inst_net / vol_sum) \* 100 else
inst_ratio = 0;

// 正規化：買超佔總量大於等於 10% 拿滿分 100，賣超或沒買拿 0 分

if inst_ratio \>= 10 then score3 = 100

else if inst_ratio \<= 0 then score3 = 0

else score3 = inst_ratio \* 10;

// ================= 因子4：價格動能 (權重 10%) =================

// 邏輯：近 20 日 (約一個月) 漲跌幅

var: mom(0);

mom = RateOfChange(Close, 20);

// 正規化：月漲幅大於等於 30% 拿滿分 100，下跌拿 0 分

if mom \>= 30 then score4 = 100

else if mom \<= 0 then score4 = 0

else score4 = mom \* 3.33;

// ================= 計算加權總分 =================

retval = (score1 \* 0.4) + (score2 \* 0.3) + (score3 \* 0.2) + (score4
\* 0.1);

end;

end;

// ================= 主執行區：篩選與輸出 =================

// 找出全市場多因子綜合評分前 50 名的股票 (作為動態替換的「板凳候選人」)

if FriessScore.pos \<= 50 and FriessScore.value \> 0 then begin

ret = 1;

outputField1(FriessScore.pos, \" Friess 排名\");

outputField2(FriessScore.value, \" 綜合總分\");

// 輸出原始數據，方便在 XQ 介面直接肉眼驗證各因子的強度

outputField3(GetField(\"月營收年增率\", \"M\") -
Average(GetField(\"月營收年增率\", \"M\")\[1\], 6), \"營收驚喜(%)\");

outputField4(GetField(\"稅後淨利成長率\", \"Q\"), \"淨利 YoY(%)\");

// 計算並輸出法人買超佔比

var: out_inst_net(0), out_vol(0);

out_inst_net = Summation(GetField(\"外資買賣超\", \"D\") +
GetField(\"投信買賣超\", \"D\"), 5);

out_vol = Summation(Volume, 5);

if out_vol \> 0 then

outputField5((out_inst_net / out_vol) \* 100, \"法人買佔比(%)\")

else

outputField5(0, \"法人買佔比(%)\");

end;

## 場景 15：彼得提爾的選股邏輯 --- 根據上述的想法，我寫了一個腳本如下

> 來源：[[彼得提爾的選股邏輯]{.underline}](https://www.xq.com.tw/xstrader/%e5%bd%bc%e5%be%97%e6%8f%90%e7%88%be%e7%9a%84%e9%81%b8%e8%82%a1%e9%82%8f%e8%bc%af/)
> 說明：根據上述的想法，我寫了一個腳本如下

// 腳本名稱：提爾「從零到一」壟斷獨角獸濾網

// 資料頻率：日 (結合季財報與月營收)

// \-\-- 參數設定 \-\--

input: Margin_Threshold(40, \"毛利率門檻(%) -\> 尋找定價權與壟斷力\");

input: RD_Ratio_Threshold(8, \"研發費用率門檻(%) -\>
尋找極致的技術壁壘\");

input: Rev_Growth(20, \"近三月營收年增率(%) -\>
尋找網路效應與掠奪式成長\");

input: RuleOf40_Limit(40, \"4.Rule of 40 下限\");

input: Insider_Limit(5, \"5.董監持股下限(%)\");

input: PEG_Limit(2.0, \"7.PEG上限\");

// \-\-- 條件一：絕對的定價權 (高毛利) \-\--

value1 = GetField(\"營業毛利率\", \"Q\");

condition1 = value1 \>= Margin_Threshold;

// \-\-- 條件二：深厚的技術壁壘 (高研發投入) \-\--

// 計算「研發費用率」：營業研發費用 / 營業收入淨額

value2 = GetField(\"研發費用\", \"Q\");

value3 = GetField(\"營業收入淨額\", \"Q\");

value4 = 0;

condition2 = false;

if value3 \> 0 then begin

value4 = (value2 / value3) \* 100;

// 研發投入佔比必須高於設定門檻

if value4 \>= RD_Ratio_Threshold then condition2 = true;

end;

// \-\-- 條件三：網路效應與規模化 (高速且持續的營收成長) \-\--

// 使用近三個月的平均營收年增率，過濾掉單月入帳的雜訊

value5 = Average(GetField(\"月營收年增率\", \"M\"), 3);

condition3 = value5 \>= Rev_Growth;

// \-\-- 條件四：動能確認 (處於擴張期) \-\--

// 確保目前的月營收具備創新高的規模，而非正在衰退的過氣產業

condition4 = GetField(\"月營收\", \"M\") = Highest(GetField(\"月營收\",
\"M\"), 12);

// 條件五： Rule of 40 與 PEG 估值保護

value8 = GetField(\"營業利益率\", \"Q\");

value9 = GetField(\"本益比\", \"D\");

value10 = GetField(\"稅後淨利成長率\", \"Q\"); //
單季淨利成長率，用於計算PEG

// 計算 Rule of 40 (營收成長率 + 營業利益率)

value6= value5 + value8;

// 計算 PEG (本益成長比)

// 若本益比或淨利成長率為負，賦予極大值以排除

var:peg(0);

if value9 \> 0 and value10 \> 0 then

peg = value9 / value10

else

peg = 999;

condition5 = value6 \>= RuleOf40_Limit; // SaaS/軟體股核心健康指標

condition6 = peg \<= PEG_Limit; // 成長未被極度透支

// \-\-- 綜合篩選與輸出 \-\--

if condition1 and condition2 and condition3 and condition4

and condition5 and condition6 then begin

ret = 1;

outputField1(value1, \"營業毛利率(%)\");

outputField2(value4, \"研發費用率(%)\");

outputField3(value5, \"近3月營收成長(%)\");

end;

## 場景 16：Trend Intensity Index (TII 趨勢強度指標)

> 來源：[[趨勢強度指標]{.underline}](https://www.xq.com.tw/xstrader/%e8%b6%a8%e5%8b%a2%e5%bc%b7%e5%ba%a6%e6%8c%87%e6%a8%99/)
> 說明：這段腳本忠實還原了 M.H. Pee 的 TII
> 算法，並使用了Average來處理長期均線與乖離的累加。

// 指標名稱：Trend Intensity Index (TII 趨勢強度指標)

// 理論基礎：M.H. Pee

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input:

Long_Period(22, \"長期均線週期(基準線)\"),

Smooth_Period(10, \"乖離累加週期(平滑線)\");

Variable:

ValueMA(0), Dev(0),

TodayPosDev(0), TodayNegDev(0), // 新增：單純記錄當根 K 線的正/負乖離

SumPosDev(0), SumNegDev(0),

TII(0);

// 1. 確保有足夠的 K 線數據

if CurrentBar \< Long_Period then return;

// 2. 計算市場長期價值基準線 (SMA)

ValueMA = Average(Close, Long_Period);

// 3. 計算每日價格與均線的「乖離 (Deviation)」

Dev = Close - ValueMA;

// 4. 將當根 K 線的乖離，嚴格分流到正負變數中

// 不在此處進行加總，只做數值分離

if Dev \> 0 then begin

TodayPosDev = Dev;

TodayNegDev = 0;

end else if Dev \< 0 then begin

TodayPosDev = 0;

TodayNegDev = AbsValue(Dev);

end else begin

TodayPosDev = 0;

TodayNegDev = 0;

end;

// 5. 在條件式之外，無條件對過去 N 天的數列進行滾動加總

// 這樣 Summation 函數每天都會確實讀取到陣列的新值

SumPosDev = Summation(TodayPosDev, Smooth_Period);

SumNegDev = Summation(TodayNegDev, Smooth_Period);

// 6. 計算 TII 最終數值

if (SumPosDev + SumNegDev) \<\> 0 then

TII = (SumPosDev / (SumPosDev + SumNegDev)) \* 100

else

TII = 50;

// 7. 繪圖輸出

Plot1(TII, \"TII 強度指數\");

Plot2(50, \"多空分水嶺(中軸)\");

Plot3(80, \" 信念強勁\");

Plot4(20, \"信念崩塌\");

## 場景 17：Elder-Ray Index (艾爾德射線 / 牛熊力量指標)

> 來源：[[Elder-Ray
> Index]{.underline}](https://www.xq.com.tw/xstrader/elder-ray-index/)
> 說明：為了在系統中創造最強烈的視覺對比，這段腳本將 Bull Power 與 Bear
> Power
> 繪製在同一個副圖中，並利用零軸上下的柱狀圖顏色漸層，讓「多空角力」的動態變化一目了然。

// 指標名稱：Elder-Ray Index (艾爾德射線 / 牛熊力量指標)

// 理論基礎：Dr. Alexander Elder

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: Length(13, \"EMA 計算週期\");

Variable: ValueEMA(0), BullPower(0), BearPower(0);

// 1. 計算市場價值共識 (13 日 EMA)

ValueEMA = XAverage(Close, Length);

// 2. 計算多頭力量與空頭力量

// Bull Power：最高價與 EMA 的距離

BullPower = High - ValueEMA;

// Bear Power：最低價與 EMA 的距離

BearPower = Low - ValueEMA;

// 3. 繪圖輸出 (建議在系統設定中，將 Plot1 與 Plot2 皆設為「柱狀圖」)

Plot1(BullPower, \"多頭力量(Bull)\");

Plot2(BearPower, \"空頭力量(Bear)\");

Plot3(0, \"價值共識(零軸)\");

## 場景 18：Sentiment Zone Oscillator (SZO 情緒區間震盪指標)

> 來源：[[SZO情緒指數]{.underline}](https://www.xq.com.tw/xstrader/szo%e6%83%85%e7%b7%92%e6%8c%87%e6%95%b8/)
> 說明：3. XScript (XQ 語法) 完整指標腳本

// 指標名稱：Sentiment Zone Oscillator (SZO 情緒區間震盪指標)

// 理論基礎：Walid Khalil (行為金融學)

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: Length(14, \"計算週期\");

Variable: SP(0), EMA1(0), EMA2(0), EMA3(0), SZO(0);

// 1. 計算每日情緒定位 (Sentiment Position)

if Close \> Close\[1\] then

SP = 1

else if Close \< Close\[1\] then

SP = -1

else

SP = 0;

// 2. 計算三重指數移動平均 (VALUE1) 進行極致平滑

// XQ 的 XAverage 函數即為 EMA (Exponential Moving Average)

EMA1 = XAverage(SP, Length);

EMA2 = XAverage(EMA1, Length);

EMA3 = XAverage(EMA2, Length);

// VALUE1 核心公式：3 \* EMA1 - 3 \* EMA2 + EMA3

VALUE1 = (3 \* EMA1) - (3 \* EMA2) + EMA3;

// 3. 計算 SZO 最終數值 (標準化至 -100 \~ +100)

SZO = 100 \* VALUE1;

// 4. 繪圖輸出

Plot1(SZO, \"SZO 情緒指數\");

Plot2(0, \"零軸 (多空分水嶺)\");

// 繪製極端情緒警戒線

Plot3(50, \"極度貪婪區 (+50)\");

Plot4(-50, \"極度恐懼區 (-50)\");

## 場景 19：個股恐慌指數 (Williams VIX Fix - 現代改良版)

> 來源：[[WVIXF]{.underline}](https://www.xq.com.tw/xstrader/wvixf/)
> 說明：3. XScript的對應腳本

// 指標名稱：個股恐慌指數 (Williams VIX Fix - 現代改良版)

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input:

Period(22, \"尋找最高價週期\"),

BBLength(20, \"布林通道週期\"),

BBMult(2.0, \"標準差倍數\");

Variable:

HighestClose(0), WVIXF(0),

Wvixf_MA(0), Wvixf_Std(0), Wvixf_Upper(0);

// 1. 找出過去 N 天的最高收盤價

HighestClose = Highest(Close, Period);

// 2. 計算 VIX Fix 核心公式 (當下低點距離最高收盤價的回撤百分比)

if HighestClose \> 0 then

WVIXF = ((HighestClose - Low) / HighestClose) \* 100

else

WVIXF = 0;

// 3. 建立動態極端閾值 (計算 WVIXF 的布林上軌)

Wvixf_MA = Average(WVIXF, BBLength);

Wvixf_Std = StandardDev(WVIXF, BBLength, 1);

Wvixf_Upper = Wvixf_MA + (BBMult \* Wvixf_Std);

// 4. 繪圖輸出

// 建議在 XQ 系統中，將 Plot1 樣式設定為「柱狀圖」

Plot1(WVIXF, \"WVIXF 恐慌指數\");

Plot2(Wvixf_Upper, \"極度恐慌閾值(上軌)\");

## 場景 20：斯坦利·德魯肯米勒 (Stanley F. Druckenmiller)的投資哲學

> 來源：[[斯坦利·德魯肯米勒 (Stanley F.
> Druckenmiller)的投資哲學]{.underline}](https://www.xq.com.tw/xstrader/%e6%96%af%e5%9d%a6%e5%88%a9%c2%b7%e5%be%b7%e9%ad%af%e8%82%af%e7%b1%b3%e5%8b%92-stanley-f-druckenmiller%e7%9a%84%e6%8a%95%e8%b3%87%e5%93%b2%e5%ad%b8/)
> 說明：成功後的腳本如下

// 腳本名稱：轉型迷霧淘金 (低本益比 + 研發爆增)

// 資料頻率：日

// 參數設定

input: PE_Length(750, \"本益比歷史區間(天，預設約3年)\");

input: PE_Threshold(1.2, \"歷史低位容忍倍數(1.2=距最低點20%內)\");

input: RD_Growth(30, \"近兩季研發費用年增率門檻(%)\");

// \-\-- 條件一：本益比處於歷史低位 \-\--

value1 = GetField(\"本益比\", \"D\");

value2 = Lowest(value1\[1\], PE_Length); // 過去N天的最低本益比

// 確保本益比為正值(排除虧損)，且目前本益比接近歷史最低點

condition1 = value1 \> 0 and value1 \<= (value2 \* PE_Threshold);

// \-\-- 條件二：近兩季研發費用異常暴增 \-\--

// 取得研發費用 (以季為頻率)

value3 = GetField(\"研發費用\", \"Q\"); // 最近一季

value4 = GetField(\"研發費用\", \"Q\")\[1\]; // 前一季

value5 = GetField(\"研發費用\", \"Q\")\[4\]; // 去年同期 (最近一季)

value6 = GetField(\"研發費用\", \"Q\")\[5\]; // 去年同期 (前一季)

condition2 = false;

// 確保去年同期的研發費用大於0，避免分母為零的運算錯誤

if (value5 + value6) \> 0 then begin

// 計算近兩季研發費用總和的年成長率

value7 = ((value3 + value4) - (value5 + value6)) / (value5 + value6) \*
100;

// 若成長率突破門檻，則觸發條件

if value7 \>= RD_Growth then condition2 = true;

end;

// \-\-- 綜合篩選與輸出 \-\--

if condition1 and condition2 then begin

ret = 1;

outputField1(value1, \"目前本益比\");

outputField2(value7, \"近兩季研發年增率(%)\");

outputField3(value3 + value4, \"近兩季研發總額(百萬)\");

end;

## 場景 21：VSA (Volume Spread Analysis, 量價分析) 中的 「無供應 (No Supply)」 --- 根據這樣的想法，寫出來的腳本如下

> 來源：[[VSA (Volume Spread Analysis, 量價分析) 中的 「無供應 (No
> Supply)」]{.underline}](https://www.xq.com.tw/xstrader/25109-2/)
> 說明：根據這樣的想法，寫出來的腳本如下

// 指標/選股名稱：VSA 威科夫無供應 (No Supply) 偵測

// 邏輯：尋找賣壓枯竭的 K 線

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Variable: Spread(0), AvgSpread(0);

Variable: IsDownBar(False), IsNarrow(False), IsLowVol(False);

Variable: IsNoSupply(False);

// 1. 定義波幅 (Spread)

Spread = High - Low;

AvgSpread = Average(Spread, 20); // 過去 20 天的平均波幅

// 2. 條件 A：這是一根下跌的 K 線 (或收在相對低點)

IsDownBar = Close \< Close\[1\];

// 3. 條件 B：波幅必須小於近期平均 (窄幅震盪，代表沒有強烈拋售動能)

if Spread \> 0 then

IsNarrow = Spread \< (AvgSpread \* 0.8)

else

IsNarrow = False;

// 4. 條件 C：成交量必須「顯著萎縮」(通常定義為低於前兩根 K 線)

IsLowVol = Volume \< Volume\[1\] and Volume \< Volume\[2\];

// 5. 綜合判斷：觸發威科夫「無供應」訊號

IsNoSupply = IsDownBar and IsNarrow and IsLowVol;

// 6. 繪圖與視覺化提示

if IsNoSupply then begin

// 在 K 線下方畫一個向上的綠色箭頭或標記

Plot1(Low \* 0.97, \"No Supply\");

end;

## 場景 22：WaveTrend Oscillator (WT 波浪趨勢指標)

> 來源：[[WaveTrend
> Oscillator]{.underline}](https://www.xq.com.tw/xstrader/wavetrend-oscillator/)
> 說明：運算步驟拆解：

// 指標名稱：WaveTrend Oscillator (WT 波浪趨勢指標)

// 理論基礎：LazyBear

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input:

ChannelLen(10, \"通道計算週期(n1)\"),

AverageLen(21, \"平滑計算週期(n2)\");

Variable:

ap(0), esa(0), d(0), ci(0),

wt1(0), wt2(0);

// 1. 計算典型價格 (Typical Price)

ap = (High + Low + Close) / 3;

// 2. 計算典型價格的指數移動平均 (EMA)

esa = XAverage(ap, ChannelLen);

// 3. 計算絕對偏差的 EMA (量化波動厚度)

d = XAverage(AbsValue(ap - esa), ChannelLen);

// 4. 計算通道指數 (常規化處理)

// 乘以 0.015 是為了將絕大多數數值壓縮到 -100 \~ +100 之間

if d \> 0 then

ci = (ap - esa) / (0.015 \* d)

else

ci = 0;

// 5. 計算 WT1 (主線) 與 WT2 (訊號線)

wt1 = XAverage(ci, AverageLen);

wt2 = Average(wt1, 4); // 訊號線通常固定取 4 週期 SMA

// 6. 繪圖輸出

Plot1(wt1, \"WT1 (主線)\");

Plot2(wt2, \"WT2 (訊號線)\");

// 繪製極值參考線

Plot3(60, \"超買線\");

Plot4(53, \"警戒天花板\"); // 輔助觀察線

Plot5(-60, \"超賣線\");

Plot6(-53, \"警戒地板\"); // 輔助觀察線

Plot7(0, \"多空分水嶺\");

## 場景 23：QQE (Quantitative Qualitative Estimation)

> 來源：[[QQE]{.underline}](https://www.xq.com.tw/xstrader/qqe/)
> 說明：２．對應指標腳本

// 指標名稱：QQE (Quantitative Qualitative Estimation)

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input:

RSILen(14, \"RSI週期\"),

SF(5, \"RSI平滑週期(EMA)\"),

QQE_Factor(4.236, \"波動率乘數(通常為4.236)\");

Variable: vRSI(0), SmoothRSI(0), AbsDelta(0);

Variable: AtrRSI(0), SmoothAtrRSI(0), Darvas(0);

Variable: TrLevel(0); // 動態追蹤線

// 1. 計算 RSI 並進行平滑處理

vRSI = RSI(Close, RSILen);

SmoothRSI = XAverage(vRSI, SF);

// 2. 計算 RSI 的變動絕對值 (量化動能的波動)

if CurrentBar \> 1 then

AbsDelta = AbsValue(SmoothRSI - SmoothRSI\[1\])

else

AbsDelta = 0;

// 3. 對波動率進行雙重平滑 (標準設定為 27 期 EMA)

AtrRSI = XAverage(AbsDelta, 27);

SmoothAtrRSI = XAverage(AtrRSI, 27);

// 4. 計算動態區間 (Darvas Box 原理)

Darvas = SmoothAtrRSI \* QQE_Factor;

// 5. 計算動態追蹤停損線 (Trailing Level)

// 邏輯：根據 RSI 與前一期追蹤線的相對位置，決定追蹤線是要收斂還是翻轉

if CurrentBar = 1 then begin

TrLevel = SmoothRSI;

end else begin

if SmoothRSI \< TrLevel\[1\] and SmoothRSI\[1\] \< TrLevel\[1\] then

// 空頭延續：追蹤線只能向下壓，不能往上退

TrLevel = MinList(TrLevel\[1\], SmoothRSI + Darvas)

else if SmoothRSI \> TrLevel\[1\] and SmoothRSI\[1\] \> TrLevel\[1\]
then

// 多頭延續：追蹤線只能向上墊，不能往下退 (保護獲利)

TrLevel = MaxList(TrLevel\[1\], SmoothRSI - Darvas)

else if SmoothRSI \> TrLevel\[1\] then

// 剛由空翻多：重新設定下緣支撐

TrLevel = SmoothRSI - Darvas

else

// 剛由多翻空：重新設定上緣壓力

TrLevel = SmoothRSI + Darvas;

end;

// 6. 繪圖輸出

Plot1(SmoothRSI, \"平滑 RSI\");

Plot2(TrLevel, \"動態追蹤線\");

Plot3(50, \"多空強弱分界\");

## 場景 24：IFT-RSI (Inverse Fisher Transform on RSI)

> 來源：[[逆費雪轉換
> RSI]{.underline}](https://www.xq.com.tw/xstrader/%e9%80%86%e8%b2%bb%e9%9b%aa%e8%bd%89%e6%8f%9b-rsi/)
> 說明：２．對應的ＸＱ腳本

// 指標名稱：IFT-RSI (Inverse Fisher Transform on RSI)

// 理論基礎：John Ehlers

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: RSILen(5, \"RSI 計算週期\"), WMA_Len(9, \"WMA 平滑週期\");

Variable: vRSI(0), ScaledRSI(0), SmoothRSI(0), vxt(0), IFT(0);

// 1. 計算基礎 RSI

vRSI = RSI(Close, RSILen);

// 2. 數值平移與壓縮

// 將 0\~100 的 RSI 平移至零軸，並壓縮至大約 -5 到 +5 的區間

ScaledRSI = 0.1 \* (vRSI - 50);

// 3. 雜訊平滑處理

// Ehlers 建議使用加權移動平均 (WMA) 來保留近期的權重同時過濾雜訊

SmoothRSI = WMA(ScaledRSI, WMA_Len);

// 4. 逆費雪轉換核心公式

// 公式: (e\^(2x) - 1) / (e\^(2x) + 1)

vxt = ExpValue(2 \* SmoothRSI);

if (vxt + 1) \<\> 0 then

IFT = (vxt - 1) / (vxt + 1)

else

IFT = 0;

// 5. 繪圖輸出

Plot1(IFT, \"IFT-RSI\");

// 繪製極端參考線

Plot2(0.5, \"超買反轉線\");

Plot3(-0.5, \"超賣反轉線\");

Plot4(0, \"零軸\");

## 場景 25：Weis Wave Volume (韋斯波段成交量)

> 來源：[[韋斯波段成交量 (Weis Wave
> Volume)]{.underline}](https://www.xq.com.tw/xstrader/%e9%9f%8b%e6%96%af%e6%b3%a2%e6%ae%b5%e6%88%90%e4%ba%a4%e9%87%8f-weis-wave-volume/)
> 說明：3. XScript (XQ 語法) 完整實作代碼

// 指標名稱：Weis Wave Volume (韋斯波段成交量)

// 邏輯：基於波段高低點反轉來累積成交量

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: RevPct(1.5, \"波段反轉門檻(%)\"); // 預設 1.5% 反轉才算新波段

Variable: Trend(1), vxt(0), WaveVol(0), RevAmt(0);

// 1. 初始狀態設定

if CurrentBar = 1 then begin

vxt = Close;

WaveVol = Volume;

Trend = 1; // 假設初始為上漲波 (1為上漲，-1為下跌)

end else begin

// 根據當前極值與使用者設定的百分比，計算反轉所需的絕對價差

RevAmt = vxt \* (RevPct / 100);

// 2. 當前為「上漲波」的邏輯

if Trend = 1 then begin

if High \> vxt then vxt = High; // 不斷更新波段最高點

// 判斷是否觸發向下反轉 (從最高點回落超過設定門檻)

if (vxt - Low) \>= RevAmt then begin

Trend = -1; // 翻轉為下跌波

vxt = Low; // 紀錄新的極低點

WaveVol = Volume; // 重新開始累加下跌波成交量

end else begin

WaveVol = WaveVol + Volume; // 未反轉，持續累加上漲波成交量

end;

end

// 3. 當前為「下跌波」的邏輯

else if Trend = -1 then begin

if Low \< vxt then vxt = Low; // 不斷更新波段最低點

// 判斷是否觸發向上反轉 (從最低點反彈超過設定門檻)

if (High - vxt) \>= RevAmt then begin

Trend = 1; // 翻轉為上漲波

vxt = High; // 紀錄新的極高點

WaveVol = Volume; // 重新開始累加上漲波成交量

end else begin

WaveVol = WaveVol + Volume; // 未反轉，持續累加下跌波成交量

end;

end;

end;

// 4. 繪圖輸出

if trend=1 then begin

Plot1(WaveVol, \"Weis Wave\");

noplot(2);

end else begin

noplot(1);

plot2(WaveVol, \"Weis Wave\");

end;

## 場景 26：Volume Flow Indicator (VFI) - 成交量流量指標

> 來源：[[成交量流量指標 (Volume Flow Indicator,
> VFI)]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%90%e4%ba%a4%e9%87%8f%e6%b5%81%e9%87%8f%e6%8c%87%e6%a8%99-volume-flow-indicator-vfi-%e3%80%80/)
> 說明：3. XScript  語法

// 指標名稱：Volume Flow Indicator (VFI) - 成交量流量指標

// 作者：Markos Katsanos

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input:

Length(130, \"計算週期(預設130)\"),

Coef(0.2, \"截止係數(預設0.2)\"),

Smooth(3, \"平滑週期(預設3)\");

Variable: TP(0), PrevTP(0), MF(0), Cutoff(0);

Variable: Vave(0), Vmax(0), VC(0), DirVol(0);

Variable: SumDirVol(0), VFI_Raw(0), VFI(0);

// 1. 計算典型價格 (Typical Price)

// 結合最高、最低與收盤價，比單看收盤價更具代表性

TP = (High + Low + Close) / 3;

if CurrentBar = 1 then

PrevTP = TP

else

PrevTP = TP\[1\];

// 價格變化量

MF = TP - PrevTP;

// 2. 計算波動率截止閾值 (Cutoff)

// 這裡使用 30 日收盤價的標準差乘以係數，作為過濾盤整雜訊的門檻

Cutoff = Coef \* StandardDev(Close, 30, 1);

// 3. 異常成交量截斷 (Volume Cap)

// 限制單日最大成交量不得超過平均量的 2.5 倍

Vave = Average(Volume, Length);

Vmax = Vave \* 2.5;

VC = MinList(Volume, Vmax);

// 4. 判斷有效資金流向 (Directional Volume)

// 只有當價格變動「大於」波動閾值時，才計入有效成交量

if MF \> Cutoff then

DirVol = VC

else if MF \< -1 \* Cutoff then

DirVol = -1 \* VC

else

DirVol = 0; // 變動太小，視為雜訊，資金流為 0

// 5. 計算 VFI 原始數值

// 將過去 N 天的有效資金加總，並除以平均量進行標準化

SumDirVol = Summation(DirVol, Length);

if Vave \> 0 then

VFI_Raw = SumDirVol / Vave

else

VFI_Raw = 0;

// 6. 最終平滑處理

// 使用 XAverage (EMA) 讓曲線更平滑，便於判讀

VFI = XAverage(VFI_Raw, Smooth);

// 7. 繪圖與視覺化

Plot1(VFI, \"VFI\");

Plot2(0, \"零軸\");

// 顏色標示：零軸之上為紅(資金流入)，之下為綠(資金流出)

## 場景 27：Choppiness Index (CHOP)

> 來源：[[斬波指標(Choppiness Index,
> CHOP)]{.underline}](https://www.xq.com.tw/xstrader/%e6%96%ac%e6%b3%a2%e6%8c%87%e6%a8%99choppiness-index-chop/)
> 說明：3. XScript (XQ 語法) 完整腳本

// 指標名稱：Choppiness Index (CHOP)

// 作者：E.W. Dreiss

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: Length(14, \"計算週期\");

Variable: TR(0), SumTR(0);

Variable: MaxHi(0), MinLo(0), RangeLen(0);

Variable: CHOP(0);

// 1. 計算真實波幅 (True Range)

// XQ 內建 TrueRange 函數，若無則使用 MaxList 手動計算

TR = TrueRange;

// 2. 計算分子：路徑總長 (過去 N 天波動總和)

SumTR = Summation(TR, Length);

// 3. 計算分母：直線位移 (過去 N 天的高低區間)

MaxHi = Highest(High, Length);

MinLo = Lowest(Low, Length);

RangeLen = MaxHi - MinLo;

// 4. 核心公式計算

// 保護機制：避免分母為 0 (雖然極少發生)

if RangeLen \> 0 and SumTR \> 0 then begin

// Log 在 XQ 中是以 10 為底，這正是公式需要的

Value1 = SumTR / RangeLen;

CHOP = 100 \* Log(Value1) / Log(Length);

end else begin

CHOP = 50; // 若無法計算，給予中性值

end;

// 5. 繪圖輸出

Plot1(CHOP, \"Choppiness Index\");

// 繪製參考線

Plot2(61.8, \"盤整界線 (Fib 61.8)\");

Plot3(38.2, \"趨勢界線 (Fib 38.2)\");

## 場景 28：Kaufman\'s Adaptive Moving Average (KAMA)

> 來源：[[考夫曼自適應均線 (Kaufman's Adaptive Moving Average,
> KAMA)]{.underline}](https://www.xq.com.tw/xstrader/%e8%80%83%e5%a4%ab%e6%9b%bc%e8%87%aa%e9%81%a9%e6%87%89%e5%9d%87%e7%b7%9a-kaufmans-adaptive-moving-average-kama/)
> 說明：這段代碼您可以直接用於 XQ。

// 指標名稱：Kaufman\'s Adaptive Moving Average (KAMA)

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input:

Period(10, \"計算週期 (ER)\"),

FastEnd(2, \"最快EMA週期\"),

SlowEnd(30, \"最慢EMA週期\");

Variable: Direction(0), Volatility1(0), ER(0);

Variable: FastSC(0), SlowSC(0), SC(0);

Variable: KAMA_Val(0);

// 1. 初始化平滑常數 (將 EMA 週期轉換為權重常數)

// EMA權重公式 = 2 / (N + 1)

Once begin

FastSC = 2 / (FastEnd + 1);

SlowSC = 2 / (SlowEnd + 1);

end;

// 2. 計算效率係數 (Efficiency Ratio, ER)

// Direction: 價格淨位移 (直線距離)

Direction = AbsValue(Close - Close\[Period\]);

// Volatility: 價格總路徑 (每日波動總和)

// 使用 Summation 函數累加過去 Period 天的每日波動

Volatility1 = Summation(AbsValue(Close - Close\[1\]), Period);

// 防呆機制：避免分母為 0

if Volatility1 \> 0 then

ER = Direction / Volatility1

else

ER = 0;

// 3. 計算平滑常數 (SC)

// 這是 KAMA 的核心：將 ER 對映到 FastSC 與 SlowSC
之間，並平方以壓抑雜訊

SC = Power(ER \* (FastSC - SlowSC) + SlowSC, 2);

// 4. 計算 KAMA

// 第一根 Bar 直接用收盤價，之後用遞歸公式

if CurrentBar = 1 then

KAMA_Val = Close

else

KAMA_Val = KAMA_Val\[1\] + SC \* (Close - KAMA_Val\[1\]);

// 5. 繪圖輸出

Plot1(KAMA_Val, \"KAMA\");

## 場景 29：Vortex Indicator (VI)

> 來源：[[漩渦指標]{.underline}](https://www.xq.com.tw/xstrader/%e6%bc%a9%e6%b8%a6%e6%8c%87%e6%a8%99/)
> 說明：2. XScript (XQ 語法) 完整腳本

// 指標名稱：Vortex Indicator (VI)

// 發表年份：2010

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: Length(14, \"計算週期\");

Variable: VM_Plus(0), VM_Minus(0);

Variable: Sum_VM_Plus(0), Sum_VM_Minus(0), Sum_TR(0);

Variable: VI_Plus(0), VI_Minus(0);

Variable: TR(0);

// 1. 計算單根 K 線的漩渦移動量 (Vortex Movement)

// 邏輯：今天的高點離昨天的低點有多遠 (多頭力道)

VM_Plus = AbsValue(High - Low\[1\]);

// 邏輯：今天的低點離昨天的高點有多遠 (空頭力道)

VM_Minus = AbsValue(Low - High\[1\]);

// 2. 計算真實波幅 (True Range)

// 這是為了將波動率標準化，讓不同價位的股票可以比較

TR = TrueRange;

// 註：若 XQ 版本較舊不支援 TrueRange，可用以下公式取代：

// TR = MaxList(High - Low, AbsValue(High - Close\[1\]), AbsValue(Low -
Close\[1\]));

// 3. 進行週期累加 (Summation)

// 這裡將過去 N 天的力道總和起來

Sum_VM_Plus = Summation(VM_Plus, Length);

Sum_VM_Minus = Summation(VM_Minus, Length);

Sum_TR = Summation(TR, Length);

// 4. 計算最終指標數值 (歸一化)

if Sum_TR \<\> 0 then begin

VI_Plus = Sum_VM_Plus / Sum_TR;

VI_Minus = Sum_VM_Minus / Sum_TR;

end;

// 5. 繪圖輸出

Plot1(VI_Plus, \"VI+ (多頭)\");

Plot2(VI_Minus, \"VI- (空頭)\");

Plot3(VI_Plus-VI_Minus,\"差額\");

## 場景 30：Ehlers Correlation Trend Indicator

> 來源：[[Ehlers
> 相關性趨勢指標]{.underline}](https://www.xq.com.tw/xstrader/ehlers-%e7%9b%b8%e9%97%9c%e6%80%a7%e8%b6%a8%e5%8b%a2%e6%8c%87%e6%a8%99/)
> 說明：用Xscript寫的腳本如下

// 指標名稱：Ehlers Correlation Trend Indicator

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: Length(20, \"計算週期\");

Variable: SX(0), SY(0), SXX(0), SYY(0), SXY(0), i(0);

Variable: Corr(0);

// 初始化累加變數

SX = 0; SY = 0; SXX = 0; SYY = 0; SXY = 0;

// 計算價格與「時間序列(1, 2, 3\...)」的相關性

for i = 0 to Length - 1 begin

Value1 = Close\[i\]; // Y: 價格

Value2 = Length - i; // X: 時間序 (越近數值越大，模擬上升直線)

SX = SX + Value2;

SY = SY + Value1;

SXY = SXY + (Value2 \* Value1);

SXX = SXX + (Value2 \* Value2);

SYY = SYY + (Value1 \* Value1);

end;

// 相關係數公式

Value3 = (Length \* SXX) - (SX \* SX);

Value4 = (Length \* SYY) - (SY \* SY);

if Value3 \> 0 and Value4 \> 0 then

Corr = ((Length \* SXY) - (SX \* SY)) / SquareRoot(Value3 \* Value4)

else

Corr = 0;

Plot1(Corr, \"Trend Correlation\");

Plot2(0, \"Zero\");

Plot3(0.5, \"Strong Trend\");

## 場景 31：內行人指數

> 來源：[[內行人指數]{.underline}](https://www.xq.com.tw/xstrader/%e5%85%a7%e8%a1%8c%e4%ba%ba%e6%8c%87%e6%95%b8/)
> 說明：我寫的腳本如下

value1=getfield(\"外資買賣超\", \"D\");

value2=getField(\"投信買賣超\", \"D\");

value3=getField(\"自營商買賣超\", \"D\");

value4=getField(\"關鍵券商買賣超張數\", \"D\");

value5=getField(\"關聯券商買賣超張數\", \"D\");

value6=getField(\"地緣券商買賣超張數\", \"D\");

value7=getField(\"融資增減張數\", \"D\");

value8=getField(\"融券增減張數\", \"D\");

var:count(0);

count=0;

if value1\>0 then count=count+1;

if value2\>0 then count=count+1;

if value3\>0 then count=count+1;

if value4\>0 then count=count+1;

if value5\>0 then count=count+1;

if value6\>0 then count=count+1;

if value7\<0 then count=count+1;

if value8\>0 then count=count+1;

value9=average(count,40);

value10=count-value9;

plot1(average(count,3),\"內行人參與係數\");

plot2(value10,\"差額\");

## 場景 32：Points and Line (P&L) Chart --- 在 XQ 系統中，要完全改變「繪圖引擎」去畫 P&L Chart 較難，但我們可以透過「指標」的形式，利用Plot函數模擬出這種效果：

> 來源：[[Points and Line (P&L)
> Chart]{.underline}](https://www.xq.com.tw/xstrader/points-and-line-pl-chart/)
> 說明：在 XQ 系統中，要完全改變「繪圖引擎」去畫 P&L Chart
> 較難，但我們可以透過「指標」的形式，利用Plot函數模擬出這種效果：

// 模擬 P&L Chart 的邏輯 (簡化版)

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: BoxSizePct(1, \"變動閾值%\");

Variable: LastPoint(0), TargetChange(0);

if CurrentBar = 1 then LastPoint = Close;

// 計算變動幅度

TargetChange = LastPoint \* (BoxSizePct / 100);

// 只有當收盤價偏離上一個點超過門檻時，才更新點位

if AbsValue(Close - LastPoint) \>= TargetChange then begin

LastPoint = Close;

end;

// 繪製點與連線

Plot1(LastPoint, \"P&L Line\");

## 場景 33：SuperTrend

> 來源：[[Super
> trend]{.underline}](https://www.xq.com.tw/xstrader/super-trend/)
> 說明：這是為您準備的 XScript 版本，您可以直接在 XQ 系統中建立指標：

// 指標名稱: SuperTrend

input: \_atrLength(10, \"ATR週期\"), \_multiplier(3, \"倍數\");

variable: \_avgPrice(0), \_atr(0), \_up(0), \_dn(0), \_trend(1),
\_st(0);

// 1. 計算典型價格與 ATR

\_avgPrice = (High + Low) / 2;

\_atr = average(TrueRange,\_atrlength);

// 2. 計算基礎上下軌

value1 = \_avgPrice + (\_multiplier \* \_atr); // Basic Upper

value2 = \_avgPrice - (\_multiplier \* \_atr); // Basic Lower

// 3. 處理「階梯式」邏輯

// 下軌 (支撐) 不向下掉

if value2 \> \_dn\[1\] or Close\[1\] \< \_dn\[1\] then

\_dn = value2

else

\_dn = \_dn\[1\];

// 上軌 (壓力) 不向上升

if value1 \< \_up\[1\] or Close\[1\] \> \_up\[1\] then

\_up = value1

else

\_up = \_up\[1\];

// 4. 判斷多空趨勢

if Close \> \_up\[1\] then

\_trend = 1

else if Close \< \_dn\[1\] then

\_trend = -1

else

\_trend = \_trend\[1\];

// 5. 決定 SuperTrend 的數值

if \_trend = 1 then \_st = \_dn else \_st = \_up;

// 6. 繪圖

Plot1(\_st, \"SuperTrend\" );

## 場景 34：Anchored VWAP --- 用Xscript寫的函數腳本如下

> 來源：[[Anchored
> VWAP]{.underline}](https://www.xq.com.tw/xstrader/anchored-vwap/)
> 說明：用Xscript寫的函數腳本如下

// 函數名稱:  AnchoredVWAP

// 傳回值: 數值序列

// 參數:

// Price: 通常傳入 (High + Low + Close) / 3

// Vol: 傳入成交量 Volume

// TargetDate: 錨定日期，格式為 YYYYMMDD (例如 20231026)

input: Price(numeric), Vol(numeric), TargetDate(numeric);

variable: sumPV(0), sumV(0), avwapValue(0);

// 當目前的 K 線日期大於或等於我們設定的錨定日期時開始計算

if Date \>= TargetDate then

begin

// 如果是剛到達錨定日的第一根 K 線 (或是從未開始計算轉為開始計算)

// 我們需要將之前的累加值重置

if Date\[1\] \< TargetDate then

begin

sumPV = Price \* Vol;

sumV = Vol;

end

else

begin

// 否則持續累加 價格\*成交量 與 成交量

sumPV = sumPV + (Price \* Vol);

sumV = sumV + Vol;

end;

// 避免除以 0 的錯誤

if sumV \<\> 0 then

avwapValue = sumPV / sumV

else

avwapValue = Price;

end

else

avwapValue = 0; // 尚未到達錨定日，回傳 0

AnchoredVWAP=avwapvalue;

## 場景 35：Anchored VWAP --- 把這個函數應用到繪圖的腳本可以這麼寫

> 來源：[[Anchored
> VWAP]{.underline}](https://www.xq.com.tw/xstrader/anchored-vwap/)
> 說明：把這個函數應用到繪圖的腳本可以這麼寫

input:targetdate(20260108);

value1=AnchoredVWAP(close,volume,targetdate);

if value1\<\>0  then  plot1(value1,\"AnchoredVWAP\")

else noplot(1);

## 場景 36：Cybernetic Oscillator --- 以下是根據 John Ehlers 2025 年最新優化版本撰寫的 XScript 腳本：

> 來源：[[Cybernetic
> Oscillator]{.underline}](https://www.xq.com.tw/xstrader/cybernetic-oscillator/)
> 說明：以下是根據 John Ehlers 2025 年最新優化版本撰寫的 XScript 腳本：

// 名稱：Cybernetic Oscillator (Ehlers 2025)

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: HPLen(30, \"高通週期\"), LPLen(20, \"平滑週期\"), RMSLen(50,
\"標準化窗口\");

Variable: a1(0), b1(0), c1(0), c2(0), c3(0), x1(0);

Variable: HP(0), LP(0), RMS(0), CyberOsc(0);

// 1. 初始化高通濾波係數

Once begin

a1 = Expvalue(-1.414 \* 3.14159 / HPLen);

b1 = 2 \* a1 \* Cos(1.414 \* 3.14159 / HPLen);

c1 = -a1 \* a1;

x1 = (1 + b1 - c1) / 4;

end;

// 2. 高通濾波 (去除趨勢)

if CurrentBar \> 2 then

HP = x1 \* (Close - 2 \* Close\[1\] + Close\[2\]) + b1 \* HP\[1\] + c1
\* HP\[2\]

else

HP = 0;

// 3. 超級平滑濾波 (去除噪音 - 係數複用)

// 這裡使用簡化的二階平滑邏輯

LP = Average(HP, LPLen);

// 4. RMS 歸一化

RMS = SquareRoot(Summation(Power(LP, 2), RMSLen) / RMSLen);

if RMS \<\> 0 then

CyberOsc = LP / RMS

else

CyberOsc = 0;

// 5. 繪圖

Plot1(CyberOsc, \"Cybernetic Oscillator\");

Plot2(0, \"零軸\");

## 場景 37：BBTrend (John Bollinger)

> 來源：[[BBTrend]{.underline}](https://www.xq.com.tw/xstrader/bbtrend/)
> 說明：\* 數值大小： 遠離 0 軸的距離代表趨勢的動能（Momentum）。

// 指標名稱：BBTrend (John Bollinger)

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: ShortLen(10, \"短期週期\"), LongLen(20, \"長期週期\"), Dev(2,
\"標準差\");

Variable: sUp(0), sLow(0), sMid(0), lUp(0), lLow(0), lMid(0);

Variable: LowerDiff(0), UpperDiff(0), BBT(0);

// 1. 計算短期布林通道 (10, 2)

sMid = Average(Close, ShortLen);

sUp = sMid + Dev \* StandardDev(Close, ShortLen, 1);

sLow = sMid - Dev \* StandardDev(Close, ShortLen, 1);

// 2. 計算長期布林通道 (20, 2)

lMid = Average(Close, LongLen);

lUp = lMid + Dev \* StandardDev(Close, LongLen, 1);

lLow = lMid - Dev \* StandardDev(Close, LongLen, 1);

// 3. BBTrend 核心運算

LowerDiff = AbsValue(sLow - lLow);

UpperDiff = AbsValue(sUp - lUp);

// 進行歸一化 (Normalization)

if sMid \<\> 0 then

BBT = (LowerDiff - UpperDiff) / sMid \* 100

else

BBT = 0;

// 4. 繪製柱狀圖

Plot1(BBT, \"BBTrend\");

Plot2(0, \"零軸\");

## 場景 38：納達拉亞-沃森包絡線 (Nadaraya-Watson Envelope) --- 底下是AI寫的Sample code，我只修改了內建函數及變數的名稱，AI係使用迴圈來模擬高斯核的加權計算：

> 來源：[[納達拉亞-沃森包絡線 (Nadaraya-Watson
> Envelope)]{.underline}](https://www.xq.com.tw/xstrader/%e7%b4%8d%e9%81%94%e6%8b%89%e4%ba%9e-%e6%b2%83%e6%a3%ae%e5%8c%85%e7%b5%a1%e7%b7%9a-nadaraya-watson-envelope/)
> 說明：底下是AI寫的Sample
> code，我只修改了內建函數及變數的名稱，AI係使用迴圈來模擬高斯核的加權計算：

// 名稱：Nadaraya-Watson Envelope (簡化版)

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: h1(8, \"Bandwidth 頻寬\"), Mult(2, \"Multiplier 倍數\"),
Window(50, \"計算窗口\");

Variable: i(0), weight(0), sumWeight(0), sumPrice(0), NW_Center(0),
MAD(0);

// 1. 計算核回歸中心線

sumPrice = 0;

sumWeight = 0;

for i = 0 to Window begin

// 高斯核權重公式：exp(-(距離\^2) / (2 \* h\^2))

weight = Expvalue(-1 \* Power(i, 2) / (2 \* Power(h1, 2)));

sumPrice = sumPrice + Close\[i\] \* weight;

sumWeight = sumWeight + weight;

end;

if sumWeight \<\> 0 then NW_Center = sumPrice / sumWeight;

// 2. 計算平均絕對偏差 (MAD) 作為軌道寬度

MAD = Average(AbsValue(Close - NW_Center), Window);

// 3. 繪製結果

Plot1(NW_Center, \"NW 中心線\");

Plot2(NW_Center + Mult \* MAD, \"上軌\");

Plot3(NW_Center - Mult \* MAD, \"下軌\");

## 場景 39：Ultimate Smoother (John Ehlers, 2024)

> 來源：[[Ultimate Smoother
> 指標]{.underline}](https://www.xq.com.tw/xstrader/ultimate-smoother-%e6%8c%87%e6%a8%99/)
> 說明：以下是這個指標的Xscript腳本

// 指標名稱：Ultimate Smoother (John Ehlers, 2024)

// 適用對象：趨勢判斷、雜訊過濾

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Input: Length(20, \"計算週期\");

Variable: a1(0), c1(0), c2(0), c3(0), US(0);

// 1. 初始化係數 (僅在第一根 K 線或長度改變時計算以優化運算效率)

// 使用雙極低通濾波器原理

Once begin

// 使用 1.414 (根號2) 作為臨界阻尼係數

a1 = ExpValue(-1.414 \* 3.14159 / Length);

c2 = 2 \* a1 \* Cos(1.414 \* 3.14159 / Length); // XScript Cos
使用弧度制

c3 = -a1 \* a1;

c1 = (1 + c2 - c3) / 4;

end;

// 2. 核心遞歸演算法

// 該指標結合了目前價格、歷史價格以及指標的前兩期數值

if CurrentBar \< 4 then

US = Close // 初始緩衝

else

US = (1 - c1) \* Close

\+ (2 \* c1 - c2) \* Close\[1\]

\- (c1 + c3) \* Close\[2\]

\+ c2 \* US\[1\]

\+ c3 \* US\[2\];

// 3. 繪圖輸出

Plot1(US, \"Ultimate Smoother\");

## 場景 40：Chaikin Money Flow (CMF，蔡金資金流量)指標

> 來源：[[Chaikin Money Flow
> (CMF，蔡金資金流量)指標]{.underline}](https://www.xq.com.tw/xstrader/chaikin-money-flow-cmf%ef%bc%8c%e8%94%a1%e9%87%91%e8%b3%87%e9%87%91%e6%b5%81%e9%87%8f%e6%8c%87%e6%a8%99/)
> 說明：以下是這個指標的腳本

// CMF 指標實作

input: Length(21, \"計算週期\");

variable: MFM(0), MFV(0), CMF_Value(0);

// 計算貨幣流量乘數

if High \<\> Low then

MFM = ((Close - Low) - (High - Close)) / (High - Low)

else

MFM = 0;

MFV = MFM \* Volume;

// 計算 CMF

if Summation(Volume, Length) \<\> 0 then

CMF_Value = Summation(MFV, Length) / Summation(Volume, Length)

else

CMF_Value = 0;

Plot1(CMF_Value, \"CMF\");

Plot2(0, \"零軸\");

## 場景 41：TSV (Time Segmented Volume)

> 來源：[[TSV指標及其應用]{.underline}](https://www.xq.com.tw/xstrader/tsv%e6%8c%87%e6%a8%99%e5%8f%8a%e5%85%b6%e6%87%89%e7%94%a8/)
> 說明：以下是用Xscript寫的對應指標腳本

// 指標名稱：TSV (Time Segmented Volume)

// 應用場景：技術分析副圖

// 邏輯參考：Worden Brothers

input: T_Period(18, \"TSV週期\");

input: S_Period(8, \"平滑週期\");

variable: V_Segment(0), TSV_Value(0), TSV_Signal(0);

// 核心運算：價格變動(加權) \* 成交量

V_Segment = (Close - Close\[1\]) \* Volume;

// 計算 TSV 總和

TSV_Value = Summation(V_Segment, T_Period);

// 平滑處理 (訊號線)

TSV_Signal = Average(TSV_Value, S_Period);

// 繪製圖表

Plot1(TSV_Value, \"TSV\");

Plot2(TSV_Signal, \"TSV訊號線\");

## 場景 42：從科技股代工廠的資本支出，研判科技板塊在S曲線中的位置 --- 畫出上面這張圖的指標腳本，我附在下面

> 來源：[[從科技股代工廠的資本支出，研判科技板塊在S曲線中的位置]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%9e%e7%a7%91%e6%8a%80%e8%82%a1%e4%bb%a3%e5%b7%a5%e5%bb%a0%e7%9a%84%e8%b3%87%e6%9c%ac%e6%94%af%e5%87%ba%ef%bc%8c%e7%a0%94%e5%88%a4%e7%a7%91%e6%8a%80%e6%9d%bf%e5%a1%8a%e5%9c%a8s%e6%9b%b2%e7%b7%9a/)
> 說明：畫出上面這張圖的指標腳本，我附在下面

Group: \_group();//宣告群組

var: \_i(0), \_size(0);

\_group = GetSymbolGroup(\"成份股\");//指定群組的商品

// 檢查是否有資料

\_size = GroupSize(\_group);

if \_size = 0 then return;

// 迴圈運算前，初始化變數

value1 = 0;

value2 = 0;

value3=0;

// 迴圈計算每一檔成份股數值

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"資本支出金額\", \"Q\") \> value1
then begin //如果成份股有人提前公佈數值，目前計算的都歸零

value1 = GetSymbolFieldDate(\_group\[\_i\], \"資本支出金額\", \"Q\");

value2 = 0;

value3 = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"資本支出金額\", \"Q\") = value1
then begin //依最新的資料期別進行統計

value2 = value2 + 1;

value3 = value3 + GetSymbolField(\_group\[\_i\], \"資本支出金額\",
\"Q\");

end;

// 實際要計算的內容===結束===

end;

end;

// 要繪製的指標

//

plot(1, value3, \"整體資本支出金額\");

不過這邊要特別強調兩點

一，代工廠及零組件廠第一次FOR特定科技板塊作資本支出的統計值才有意義，代表是在S曲線要起飛的那一段

如果是加碼投入，那可能滲透率都已經過五成了

二，資本支出一季才公佈一次，要即時掌握新興科技是否進到S曲線迷人的那一段，觀察新聞中相關供應鍊資本支出的消息，應該會更即時。

下面是我請AI幫我分析目前幾個大的科技板塊在S曲線中的位置，供大家參考。

## 場景 43：從Ondas大漲看中小型科技飆股具備那些特徵 --- 我根據上述的這些條件，及Gemini寫的Xscript腳本，寫了一個選股腳本如下

> 來源：[[從Ondas大漲看中小型科技飆股具備那些特徵]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%9eondas%e5%a4%a7%e6%bc%b2%e7%9c%8b%e4%b8%ad%e5%b0%8f%e5%9e%8b%e7%a7%91%e6%8a%80%e9%a3%86%e8%82%a1%e5%85%b7%e5%82%99%e9%82%a3%e4%ba%9b%e7%89%b9%e5%be%b5/)
> 說明：我根據上述的這些條件，及Gemini寫的Xscript腳本，寫了一個選股腳本如下

// 合約負債年增率 \> 30% (代表訂單能見度高)

Condition1 = GetField(\"合約負債\", \"Q\") \> GetField(\"合約負債\",
\"Q\")\[4\] \* 1.3;

// 監控價格異常波動但尚未噴發 (帶量橫盤)

Condition2 = Volume \> Average(Volume, 20) \* 2;

Condition3 = High \< Highest(High, 60) \* 1.05; //
在高點附近整理，等待突破

Condition4=getfield(\"普通股股本\", \"Q\")\<100;

if condition1 and condition2 and condition3 and condition4

then ret=1;

## 場景 44：大陸股神楊永興的尾盤八法

> 來源：[[大陸股神楊永興的尾盤八法]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e9%99%b8%e8%82%a1%e7%a5%9e%e6%a5%8a%e6%b0%b8%e8%88%88%e7%9a%84%e5%b0%be%e7%9b%a4%e5%85%ab%e6%b3%95/)
> 說明：選股腳本如下

// 邏輯：漲幅、量比、換手率、市值、趨勢、強於大盤

input: MinMarketCap(50, \"最低市值(億)\");

input: MaxMarketCap(500, \"最高市值(億)\");

// 1. 量比 \> 1 (今日成交量高於過去 5 日平均量)

variable: VolRatio(0);

VolRatio = Volume / Average(Volume\[1\], 5);

condition1 = VolRatio \> 1;

// 2.換手率在 2% - 10% 之間

// 注意：需確保欄位有資料，若無資料可改用 (成交量 / 發行張數)

variable: TurnoverRate(0);

TurnoverRate =getField(\"週轉率\", \"D\");

condition2 = TurnoverRate \>= 2 and TurnoverRate \<= 10;

// 3. 市值篩選 (預設台幣 50 億 - 500 億)

condition3 = GetField(\"總市值(億)\", \"D\") \>= MinMarketCap 

         and GetField(\"總市值(億)\", \"D\") \<= MaxMarketCap;

// 4. 成交量持續放大 (今日量大於昨日量，且呈現溫和遞增)

condition4 = Volume \> Volume\[1\] and Volume\[1\] \> Volume\[2\] \*
0.8;

// 5. 均線多頭排列 (短期均線 \> 60日線，且 60日線向上)

condition5 = Average(Close, 5) \> Average(Close, 20)

         and Average(Close, 20) \> Average(Close, 60)

         and Average(Close, 60) \> Average(Close, 60)\[1\];

// 綜合判斷

if condition1 and condition2 and condition3 and condition4 

   and condition5  

then ret = 1;

outputfield(1, VolRatio, 2, \"量比\");

outputfield(2, TurnoverRate, 2, \"週轉率\");

outputfield(3, GetField(\"總市值(億)\", \"D\"), 0, \"市值(億)\");

## 場景 45：大陸股神楊永興的尾盤八法

> 來源：[[大陸股神楊永興的尾盤八法]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e9%99%b8%e8%82%a1%e7%a5%9e%e6%a5%8a%e6%b0%b8%e8%88%88%e7%9a%84%e5%b0%be%e7%9b%a4%e5%85%ab%e6%b3%95/)
> 說明：策略雷達腳本如下

// 腳本名稱：楊永興尾盤強勢股監控

// 執行頻率：1分鐘線

// 適用對象：台股上市櫃股票

input: MonitorTime(130000, \"監控開始時間(HHMMSS)\");

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 基礎過濾條件

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 取得當前價格與昨日收盤價計算即時漲幅

// 1. 漲幅在 3% - 5% 之間

condition1 = (closed(0)/closed(1)-1)\*100\>=3

and (closed(0)/closed(1)-1)\*100\<=5;

// 2. 即時量比 \> 1 (今日成交量高於過去 5 日平均量)

variable: AvgVol5(0);

AvgVol5 = Average(GetField(\"成交量\", \"D\")\[1\], 5);

condition2 = GetField(\"成交量\", \"D\") \> AvgVol5;

// 3. 成交量持續放大 (今日量大於昨日量)

condition3 = GetField(\"成交量\", \"D\") \> GetField(\"成交量\",
\"D\")\[1\];

// 4. 價格位置：位於當日高點附近 (尾盤創新高之意)

condition4 = Close \>= (High \* 0.98) ;

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 觸發時機控制

//
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 僅在 13:00 之後且 13:25 之前觸發 (尾盤黃金 25 分鐘)

if CurrentTime \>= MonitorTime and CurrentTime \<= 132500 then begin

if condition1 and condition2 and condition3 and condition4

then Ret = 1;

end;

## 場景 46：納瓦爾寶典的讀書心得 --- 我根據AI的分析，找到了營業利益成長率要大於營收成長率的關鍵篩選標準，以下是對應的腳本

> 來源：[[納瓦爾寶典的讀書心得]{.underline}](https://www.xq.com.tw/xstrader/%e7%b4%8d%e7%93%a6%e7%88%be%e5%af%b6%e5%85%b8%e7%9a%84%e8%ae%80%e6%9b%b8%e5%bf%83%e5%be%97/)
> 說明：我根據AI的分析，找到了營業利益成長率要大於營收成長率的關鍵篩選標準，以下是對應的腳本

input:n(2,\"連續n季符合條件\");

value1=getField(\"營收成長率\", \"Q\");

value2=getField(\"營業利益成長率\", \"Q\");

if trueall(value2\>value1,n)

then ret=1;

## 場景 47：精準選股這本書的讀書心得

> 來源：[[精準選股這本書的讀書心得]{.underline}](https://www.xq.com.tw/xstrader/%e7%b2%be%e6%ba%96%e9%81%b8%e8%82%a1%e9%80%99%e6%9c%ac%e6%9b%b8%e7%9a%84%e8%ae%80%e6%9b%b8%e5%bf%83%e5%be%97/)

// 腳本名稱：營收高速增長持久賽

// 適用對象：尋找處於擴張期的科技領頭羊

input: RevGrowthLimit(20, \"營收年增率門檻(%)\");

input: Quarters(4, \"持續季度數\");

// 檢查過去 N 季的單季營收年增率是否都達標

variable: i(0), isPersistent(true);

isPersistent = true;

for i = 0 to Quarters - 1 begin

if GetField(\"營收年增率\", \"Q\")\[i\] \< RevGrowthLimit then

isPersistent = false;

end;

// 加上成交量過濾，確保流動性

if isPersistent and V \> 500 then ret = 1;

outputfield(1, GetField(\"營收年增率\", \"Q\"), 2,
\"最新一季營收年增率\");

outputfield(2, GetField(\"營業利益率\", \"Q\"), 2, \"最新一季營益率\");

## 場景 48：精準選股這本書的讀書心得 --- 邏輯基礎：當高品質公司（高成長、有獲利能力）因為市場因素導致股價從高點回落 20-30% 時，是最好的進場點。

> 來源：[[精準選股這本書的讀書心得]{.underline}](https://www.xq.com.tw/xstrader/%e7%b2%be%e6%ba%96%e9%81%b8%e8%82%a1%e9%80%99%e6%9c%ac%e6%9b%b8%e7%9a%84%e8%ae%80%e6%9b%b8%e5%bf%83%e5%be%97/)
> 說明：邏輯基礎：當高品質公司（高成長、有獲利能力）因為市場因素導致股價從高點回落
> 20-30% 時，是最好的進場點。

// 腳本名稱：DHQ 高品質脫臼股篩選

// 邏輯：基本面強勁 + 股價近期大幅回檔

input: DropFromHigh(20, \"回檔幅度門檻(%)\");

input: GrowthThreshold(20, \"基本面營收增長門檻(%)\");

input: LookbackPeriod(240, \"回溯最高價的天數(約一年)\");

// 1. 計算股價是否「脫臼」 (Dislocated)

variable: highPrice(0);

highPrice = Highest(GetField(\"最高價\", \"D\"), LookbackPeriod);

condition1 = Close \< highPrice \* (1 - DropFromHigh / 100);

// 2. 判斷是否為「高品質」 (High-Quality)

// 營收年增率高 且 營業利益率為正 (代表有實質獲利能力，非純燒錢)

condition2 = GetField(\"營收年增率\", \"Q\") \>= GrowthThreshold;

condition3 = GetField(\"營業利益率\", \"Q\") \> 0;

// 3. 排除趨勢徹底轉壞的情況 (例如跌破年線太遠可能基本面出大事)

// 我們尋找的是「脫臼」而非「骨折」，加入移動平均線參考

condition4 = Close \> Average(Close, 240) \* 0.85;

if condition1 and condition2 and condition3 and condition4 then ret = 1;

outputfield(1, (Close/highPrice - 1) \* 100, 2, \"較一年高點跌幅%\");

outputfield(2, GetField(\"營收年增率\", \"Q\"), 2, \"營收年增率\");

## 場景 49：精準選股這本書的讀書心得 --- 邏輯基礎：Mahaney 建議使用 P/S 或 EV/Revenue。我們可以篩選「成長性高於估值倍數」的標的（類似科技股的 PEG 概念）。

> 來源：[[精準選股這本書的讀書心得]{.underline}](https://www.xq.com.tw/xstrader/%e7%b2%be%e6%ba%96%e9%81%b8%e8%82%a1%e9%80%99%e6%9c%ac%e6%9b%b8%e7%9a%84%e8%ae%80%e6%9b%b8%e5%bf%83%e5%be%97/)
> 說明：邏輯基礎：Mahaney 建議使用 P/S 或
> EV/Revenue。我們可以篩選「成長性高於估值倍數」的標的（類似科技股的 PEG
> 概念）。

// 腳本名稱：科技股性價比篩選

// 邏輯：營收年增率 / 股價營收比 (PSR) \> 門檻

input: PSR_Limit(10, \"股價營收比上限\");

input: RatioThreshold(2, \"營收成長對比PSR的倍數\");

variable: psr(0), revGrowth(0);

psr = GetField(\"股價營收比\", \"D\");

revGrowth = GetField(\"營收年增率\", \"Q\");

// 確保營收增長是 PSR 的 N 倍以上 (例如成長 30%，PSR 只有 5，比例為 6)

if psr \< PSR_Limit and psr \> 0 then begin

if (revGrowth / psr) \> RatioThreshold then ret = 1;

end;

outputfield(1, psr, 2, \"PSR\");

outputfield(2, revGrowth, 2, \"營收年增率\");

outputfield(3, revGrowth / psr, 2, \"性價比評分\");

## 場景 50：細產業整體來自營運的現金流量的意義 --- 要追蹤這個數字，在XQ中自訂指標的腳本如下

> 來源：[[細產業整體來自營運的現金流量的意義]{.underline}](https://www.xq.com.tw/xstrader/%e7%b4%b0%e7%94%a2%e6%a5%ad%e6%95%b4%e9%ab%94%e4%be%86%e8%87%aa%e7%87%9f%e9%81%8b%e7%9a%84%e7%8f%be%e9%87%91%e6%b5%81%e9%87%8f%e7%9a%84%e6%84%8f%e7%be%a9/)
> 說明：要追蹤這個數字，在XQ中自訂指標的腳本如下

Group: \_group();//宣告群組

var: \_i(0), \_size(0);

\_group = GetSymbolGroup(\"成份股\");//指定群組的商品

// 檢查是否有資料

\_size = GroupSize(\_group);

if \_size = 0 then return;

// 迴圈運算前，初始化變數

value1 = 0;

value2 = 0;

value3=0;

// 迴圈計算每一檔成份股數值

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"來自營運之現金流量\", \"Q\") \>
value1 then begin //如果成份股有人提前公佈數值，目前計算的都歸零

value1 = GetSymbolFieldDate(\_group\[\_i\], \"來自營運之現金流量\",
\"Q\");

value2 = 0;

value3 = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"來自營運之現金流量\", \"Q\") =
value1 then begin //依最新的資料期別進行統計

value2 = value2 + 1;

value3 = value3 + GetSymbolField(\_group\[\_i\], \"來自營運之現金流量\",
\"Q\");

end;

// 實際要計算的內容===結束===

end;

end;

// 要繪製的指標

//

plot(1, value3, \"整體來自營運之現金流量\");

## 場景 51：從平均殖利率找細產業超買與超賣區 --- 用來追踨細產業殖利率長期走勢的自訂指標，腳本如下

> 來源：[[從平均殖利率找細產業超買與超賣區]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%9e%e5%b9%b3%e5%9d%87%e6%ae%96%e5%88%a9%e7%8e%87%e6%89%be%e7%b4%b0%e7%94%a2%e6%a5%ad%e8%b6%85%e8%b2%b7%e8%88%87%e8%b6%85%e8%b3%a3%e5%8d%80/)
> 說明：用來追踨細產業殖利率長期走勢的自訂指標，腳本如下

Group: \_group();

var: \_i(0), \_size(0);

var: \_Health(0);

\_group = GetSymbolGroup(\"成份股\");

// 檢查是否有資料

//

\_size = GroupSize(\_group);

if \_size = 0 then return;

// 迴圈運算前，初始化變數

//

value1 = 0;

value2 = 0;

value3=0;

// 迴圈計算每一檔成份股數值

//

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

//getSymbolFielDDate(\"請填入正確的商品ID\", \"殖利率\", \"D\")

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"殖利率\", \"D\") \> value1 then
begin //如果成份股有人提前公佈數值，目前計算的都歸零

value1 = GetSymbolFieldDate(\_group\[\_i\], \"殖利率\", \"D\");

value2 = 0;

value3 = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"殖利率\", \"D\") = value1 then
begin //依最新的資料期別進行統計

value2 = value2 + 1;

value3 = value3 + GetSymbolField(\_group\[\_i\], \"殖利率\", \"D\");

end;

value4=value3/value2;

// 實際要計算的內容===結束===

//

end;

end;

// 要繪製的指標

//

plot(1, value4, \"平均殖利率\");

## 場景 52：從細產業整體營業利益看產業目前的狀態 --- 下面這個腳本是用Group語法寫出來的自訂指標腳本，

> 來源：[[從細產業整體營業利益看產業目前的狀態]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%9e%e7%b4%b0%e7%94%a2%e6%a5%ad%e6%95%b4%e9%ab%94%e7%87%9f%e6%a5%ad%e5%88%a9%e7%9b%8a%e7%9c%8b%e7%94%a2%e6%a5%ad%e7%9b%ae%e5%89%8d%e7%9a%84%e7%8b%80%e6%85%8b/)
> 說明：下面這個腳本是用Group語法寫出來的自訂指標腳本，

Group: \_group();//宣告群組

var: \_i(0), \_size(0);

\_group = GetSymbolGroup(\"成份股\");//指定群組的商品

// 檢查是否有資料

\_size = GroupSize(\_group);

if \_size = 0 then return;

// 迴圈運算前，初始化變數

value1 = 0;

value2 = 0;

value3=0;

// 迴圈計算每一檔成份股數值

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"營業利益\", \"Q\") \> value1
then begin //如果成份股有人提前公佈數值，目前計算的都歸零

value1 = GetSymbolFieldDate(\_group\[\_i\], \"營業利益\", \"Q\");

value2 = 0;

value3 = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"營業利益\", \"Q\") = value1 then
begin //依最新的資料期別進行統計

value2 = value2 + 1;

value3 = value3 + GetSymbolField(\_group\[\_i\], \"營業利益\", \"Q\");

value4=average(value3,4);

end;

// 實際要計算的內容===結束===

end;

end;

// 要繪製的指標

//

plot(1, value3, \"整體營業利益\");

plot(2,value4,\"4季移動平均\");

## 場景 53：研發費用與產業輪動的關係 --- 產業整體研發費用的自訂指標，樣本如下

> 來源：[[研發費用與產業輪動的關係]{.underline}](https://www.xq.com.tw/xstrader/%e7%a0%94%e7%99%bc%e8%b2%bb%e7%94%a8%e8%88%87%e7%94%a2%e6%a5%ad%e8%bc%aa%e5%8b%95%e7%9a%84%e9%97%9c%e4%bf%82/)
> 說明：產業整體研發費用的自訂指標，樣本如下

Group: \_group();//宣告群組

var: \_i(0), \_size(0);

\_group = GetSymbolGroup(\"成份股\");//指定群組的商品

// 檢查是否有資料

\_size = GroupSize(\_group);

if \_size = 0 then return;

// 迴圈運算前，初始化變數

value1 = 0;

value2 = 0;

value3=0;

// 迴圈計算每一檔成份股數值

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"研發費用\", \"Q\") \> value1
then begin //如果成份股有人提前公佈數值，目前計算的都歸零

value1 = GetSymbolFieldDate(\_group\[\_i\], \"研發費用\", \"Q\");

value2 = 0;

value3 = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"研發費用\", \"Q\") = value1 then
begin //依最新的資料期別進行統計

value2 = value2 + 1;

value3 = value3 + GetSymbolField(\_group\[\_i\], \"研發費用\", \"Q\");

end;

// 實際要計算的內容===結束===

end;

end;

// 要繪製的指標

//

plot(1, value3, \"整體研發費用\");

## 場景 54：對產業景氣更敏感的偵測工具： 產業整體營收月增率 --- 整體產業月營收的畫指標腳本樣本如下

> 來源：[[對產業景氣更敏感的偵測工具：
> 產業整體營收月增率]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8d%e7%94%a2%e6%a5%ad%e6%99%af%e6%b0%a3%e6%9b%b4%e6%95%8f%e6%84%9f%e7%9a%84%e5%81%b5%e6%b8%ac%e5%b7%a5%e5%85%b7%ef%bc%9a-%e7%94%a2%e6%a5%ad%e6%95%b4%e9%ab%94%e7%87%9f%e6%94%b6%e6%9c%88%e5%a2%9e/)
> 說明：整體產業月營收的畫指標腳本樣本如下

input: \_calcType(1, \"計算方式\",
inputkind:=Dict(\[\"加權平均\",1\],\[\"簡單平均\",2\]),
quickedit:=true);

Group: \_group();

var: \_i(0), \_size(0), \_lastestMonth(0);

var: \_sumEarning(0), \_earningCount(0), \_avgEarning(0);

var: \_sumWeightedEarning(0),\_sumCapital(0);

\_group = GetSymbolGroup(\"成份股\");

// 檢查是否有資料

//

\_size = GroupSize(\_group);

if \_size = 0 then return;

// 迴圈運算前，初始化變數

//

\_sumEarning = 0;

\_sumWeightedEarning = 0;

\_sumCapital = 0;

\_lastestMonth = 0;

\_earningCount = 0;

// 迴圈計算每一檔成份股數值

//

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

//

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"月營收月增率\", \"M\") \>
\_lastestMonth then begin //如果成份股有人提前公佈數值，目前計算的都歸零

\_lastestMonth = GetSymbolFieldDate(\_group\[\_i\], \"月營收月增率\",
\"M\");

\_earningCount = 0;

\_sumEarning = 0;

\_sumWeightedEarning = 0;

\_sumCapital = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"月營收月增率\", \"M\") =
\_lastestMonth then begin //依最新的資料期別進行統計

\_earningCount = \_earningCount + 1;

\_sumEarning = \_sumEarning + GetSymbolField(\_group\[\_i\],
\"月營收月增率\", \"M\");

\_sumCapital = \_sumCapital + GetSymbolField(\_group\[\_i\],
\"股本(億)\", \"D\");

\_sumWeightedEarning = \_sumWeightedEarning +
GetSymbolField(\_group\[\_i\], \"股本(億)\", \"D\") \*
GetSymbolField(\_group\[\_i\], \"月營收月增率\", \"M\");

end;

// 實際要計算的內容===結束===

//

end;

end;

if \_calcType = 2 then

\_avgEarning = \_sumEarning / \_earningCount

else

\_avgEarning = \_sumWeightedEarning / \_sumCapital;

// 要繪製的指標

//

plot(1, \_avgEarning, \"月營收月增率\");

## 場景 55：用細產業合計月營收年增率來抓景氣方向 --- 計算一個細產業的月營收年增率的寫法，sample如下

> 來源：[[用細產業合計月營收年增率來抓景氣方向]{.underline}](https://www.xq.com.tw/xstrader/%e7%94%a8%e7%b4%b0%e7%94%a2%e6%a5%ad%e5%90%88%e8%a8%88%e6%9c%88%e7%87%9f%e6%94%b6%e5%b9%b4%e5%a2%9e%e7%8e%87%e4%be%86%e6%8a%93%e6%99%af%e6%b0%a3%e6%96%b9%e5%90%91/)
> 說明：計算一個細產業的月營收年增率的寫法，sample如下

input: \_calcType(1, \"計算方式\",
inputkind:=Dict(\[\"加權平均\",1\],\[\"簡單平均\",2\]),
quickedit:=true);

Group: \_group();

var: \_i(0), \_size(0), \_lastestMonth(0);

var: \_sumEarning(0), \_earningCount(0), \_avgEarning(0);

var: \_sumWeightedEarning(0),\_sumCapital(0);

\_group = GetSymbolGroup(\"成份股\");

// 檢查是否有資料

//

\_size = GroupSize(\_group);

if \_size = 0 then return;

// 迴圈運算前，初始化變數

//

\_sumEarning = 0;

\_sumWeightedEarning = 0;

\_sumCapital = 0;

\_lastestMonth = 0;

\_earningCount = 0;

// 迴圈計算每一檔成份股數值

//

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

//

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"月營收年增率\", \"M\") \>
\_lastestMonth then begin //如果成份股有人提前公佈數值，目前計算的都歸零

\_lastestMonth = GetSymbolFieldDate(\_group\[\_i\], \"月營收年增率\",
\"M\");

\_earningCount = 0;

\_sumEarning = 0;

\_sumWeightedEarning = 0;

\_sumCapital = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"月營收年增率\", \"M\") =
\_lastestMonth then begin //依最新的資料期別進行統計

\_earningCount = \_earningCount + 1;

\_sumEarning = \_sumEarning + GetSymbolField(\_group\[\_i\],
\"月營收年增率\", \"M\");

\_sumCapital = \_sumCapital + GetSymbolField(\_group\[\_i\],
\"股本(億)\", \"D\");

\_sumWeightedEarning = \_sumWeightedEarning +
GetSymbolField(\_group\[\_i\], \"股本(億)\", \"D\") \*
GetSymbolField(\_group\[\_i\], \"月營收年增率\", \"M\");

end;

// 實際要計算的內容===結束===

//

end;

end;

if \_calcType = 2 then

\_avgEarning = \_sumEarning / \_earningCount

else

\_avgEarning = \_sumWeightedEarning / \_sumCapital;

// 要繪製的指標

//

plot(1, \_avgEarning, \"月營收年增率\");

## 場景 56：用細產業平均本益比看行業景氣位置 --- 下面是細行業本益比的腳本，供大家參考

> 來源：[[用細產業平均本益比看行業景氣位置]{.underline}](https://www.xq.com.tw/xstrader/%e7%94%a8%e7%b4%b0%e7%94%a2%e6%a5%ad%e5%b9%b3%e5%9d%87%e6%9c%ac%e7%9b%8a%e6%af%94%e7%9c%8b%e8%a1%8c%e6%a5%ad%e6%99%af%e6%b0%a3%e4%bd%8d%e7%bd%ae/)
> 說明：下面是細行業本益比的腳本，供大家參考

Group: \_group();

var: \_i(0), \_size(0);

\_group = GetSymbolGroup(\"成份股\");

// 檢查是否有資料

//

\_size = GroupSize(\_group);

if \_size = 0 then return;

// 迴圈運算前，初始化變數

//

value1 = 0;

value2 = 0;

value3=0;

// 迴圈計算每一檔成份股數值

//

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

//getSymbolFieldDate(\"請填入正確的商品ID\", \"本益比\", \"D\")

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"本益比\", \"D\") \> value1 then
begin //如果成份股有人提前公佈數值，目前計算的都歸零

value1 = GetSymbolFieldDate(\_group\[\_i\], \"本益比\", \"D\");

value2 = 0;

value3 = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"本益比\", \"D\") = value1 then
begin //依最新的資料期別進行統計

value2 = value2 + 1;

value3 = value3 + GetSymbolField(\_group\[\_i\], \"本益比\", \"D\");

end;

value4=value3/value2;

// 實際要計算的內容===結束===

//

end;

end;

// 要繪製的指標

//

plot(1, value4, \"平均本益比\");

## 場景 57：整體資本支出對產業未來前景的預測力 --- 腳本一樣是從先前其他類以的自訂指標，例如整體存貨的腳本，直接複製，然後把欄位名稱改成資本支出金額即可

> 來源：[[整體資本支出對產業未來前景的預測力]{.underline}](https://www.xq.com.tw/xstrader/%e6%95%b4%e9%ab%94%e8%b3%87%e6%9c%ac%e6%94%af%e5%87%ba%e5%b0%8d%e7%94%a2%e6%a5%ad%e6%9c%aa%e4%be%86%e5%89%8d%e6%99%af%e7%9a%84%e9%a0%90%e6%b8%ac%e5%8a%9b/)
> 說明：腳本一樣是從先前其他類以的自訂指標，例如整體存貨的腳本，直接複製，然後把欄位名稱改成資本支出金額即可

Group: \_group();//宣告群組

var: \_i(0), \_size(0);

var: \_Health(0);

\_group = GetSymbolGroup(\"成份股\");//指定群組的商品

// 檢查是否有資料

\_size = GroupSize(\_group);

if \_size = 0 then return;

// 迴圈運算前，初始化變數

value1 = 0;

value2 = 0;

value3=0;

// 迴圈計算每一檔成份股數值

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"資本支出金額\", \"Q\") \> value1
then begin //如果成份股有人提前公佈數值，目前計算的都歸零

value1 = GetSymbolFieldDate(\_group\[\_i\], \"資本支出金額\", \"Q\");

value2 = 0;

value3 = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"資本支出金額\", \"Q\") = value1
then begin //依最新的資料期別進行統計

value2 = value2 + 1;

value3 = value3 + GetSymbolField(\_group\[\_i\], \"資本支出金額\",
\"Q\");

end;

// 實際要計算的內容===結束===

end;

end;

// 要繪製的指標

//

plot(1, value3, \"整體資本支出金額\");

## 場景 58：從產業整體庫存的變化，看產業輪動會輪到那個細產業 --- 這個整體庫存指標的寫法，參考腳本如下

> 來源：[[從產業整體庫存的變化，看產業輪動會輪到那個細產業]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%9e%e7%94%a2%e6%a5%ad%e6%95%b4%e9%ab%94%e5%ba%ab%e5%ad%98%e7%9a%84%e8%ae%8a%e5%8c%96%ef%bc%8c%e7%9c%8b%e7%94%a2%e6%a5%ad%e8%bc%aa%e5%8b%95%e6%9c%83%e8%bc%aa%e5%88%b0%e9%82%a3%e5%80%8b%e7%b4%b0/)
> 說明：這個整體庫存指標的寫法，參考腳本如下

Group: \_group();//宣告群組

var: \_i(0), \_size(0);

var: \_Health(0);

\_group = GetSymbolGroup(\"成份股\");//指定群組的商品

// 檢查是否有資料

\_size = GroupSize(\_group);

if \_size = 0 then return;

// 迴圈運算前，初始化變數

value1 = 0;

value2 = 0;

value3=0;

// 迴圈計算每一檔成份股數值

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"存貨\", \"Q\") \> value1 then
begin //如果成份股有人提前公佈數值，目前計算的都歸零

value1 = GetSymbolFieldDate(\_group\[\_i\], \"存貨\", \"Q\");

value2 = 0;

value3 = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"存貨\", \"Q\") = value1 then
begin //依最新的資料期別進行統計

value2 = value2 + 1;

value3 = value3 + GetSymbolField(\_group\[\_i\], \"存貨\", \"Q\");

end;

// 實際要計算的內容===結束===

end;

end;

// 要繪製的指標

//

plot(1, value3, \"整體存貨\");

## 場景 59：從整體預收款的變化，尋找細產業多空反轉點 --- 計算細產業總體預收款的指標腳本，跟總營收類似

> 來源：[[從整體預收款的變化，尋找細產業多空反轉點]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%95%b4%e9%ab%94%e9%a0%90%e6%94%b6%e6%ac%be%e7%9a%84%e8%ae%8a%e5%8c%96%ef%bc%8c%e5%b0%8b%e6%89%be%e7%b4%b0%e7%94%a2%e6%a5%ad%e5%a4%9a%e7%a9%ba%e5%8f%8d%e8%bd%89%e9%bb%9e/)
> 說明：計算細產業總體預收款的指標腳本，跟總營收類似

Group: \_group();//宣告群組

var: \_i(0), \_size(0);

var: \_Health(0);

\_group = GetSymbolGroup(\"成份股\");//指定群組的商品

// 檢查是否有資料

\_size = GroupSize(\_group);

if \_size = 0 then return;

// 迴圈運算前，初始化變數

value1 = 0;

value2 = 0;

value3=0;

// 迴圈計算每一檔成份股數值

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"預收款項\", \"Q\") \> value1
then begin //如果成份股有人提前公佈數值，目前計算的都歸零

value1 = GetSymbolFieldDate(\_group\[\_i\], \"預收款項\", \"Q\");

value2 = 0;

value3 = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"預收款項\", \"Q\") = value1 then
begin //依最新的資料期別進行統計

value2 = value2 + 1;

value3 = value3 + GetSymbolField(\_group\[\_i\], \"預收款項\", \"Q\");

end;

// 實際要計算的內容===結束===

end;

end;

// 要繪製的指標

//

plot(1, value3, \"預收款指標\");

## 場景 60：細產業的總體營收走勢圖怎麼畫? 怎麼用?

> 來源：[[細產業的總體營收走勢圖怎麼畫?
> 怎麼用?]{.underline}](https://www.xq.com.tw/xstrader/%e7%b4%b0%e7%94%a2%e6%a5%ad%e7%9a%84%e7%b8%bd%e9%ab%94%e7%87%9f%e6%94%b6%e8%b5%b0%e5%8b%a2%e5%9c%96%e6%80%8e%e9%ba%bc%e7%95%ab-%e6%80%8e%e9%ba%bc%e7%94%a8/)
> 說明：Sample如下

Group: \_group();//宣告一個群組

var: \_i(0), \_size(0);//宣告幾個變數

var: \_sumEarning(0);

\_group = GetSymbolGroup(\"成份股\");

//用GetSymbolGroup這個語法指定group代表商品代碼的成份股

// 檢查是否有資料

//

\_size = GroupSize(\_group);//groupsize是用來計算這個群組有多少成份股

if \_size = 0 then return;

// 迴圈運算前，初始化變數

//

\_sumEarning = 0;

value1 = 0;

value2 = 0;

// 迴圈計算每一檔成份股數值

//

for \_i = 1 to \_size begin //大迴圈會跑遍每一檔成份股

if CheckSymbolField(\_group\[\_i\], \"Close\") then begin
//確認股票當天有資料

// 實際要計算的內容===開始===

//

// STEP 1 換期時數值歸零

if GetSymbolFieldDate(\_group\[\_i\], \"月營收\", \"M\") \> value1 then
begin //如果成份股有人提前公佈數值，目前計算的都歸零

value1 = GetSymbolFieldDate(\_group\[\_i\], \"月營收\", \"M\");

value2 = 0;

\_sumEarning = 0;

end;

// STEP 2 同樣期別時，數值計算

if GetSymbolFieldDate(\_group\[\_i\], \"月營收\", \"M\") = value1 then
begin //依最新的資料期別進行統計

value2 = value2 + 1;

\_sumEarning = \_sumEarning + GetSymbolField(\_group\[\_i\], \"月營收\",
\"M\");

end;

// 實際要計算的內容===結束===

//

end;

end;

// 要繪製的指標

//

plot(1, \_sumEarning, \"營收合計\");

上面這個腳本有用到checksymbolfield這個內建函數，這是依據傳入的商品代碼、欄位和頻率來判斷該資料是否能夠取用，回傳True
/ False

## 場景 61：江湖傳說解密系列(5)：什麼樣的股票出量可以追? --- 首先跟大家分享我用來挑選出量股的腳本：

> 來源：[[江湖傳說解密系列(5)：什麼樣的股票出量可以追?]{.underline}](https://www.xq.com.tw/xstrader/%e6%b1%9f%e6%b9%96%e5%82%b3%e8%aa%aa%e8%a7%a3%e5%af%86%e7%b3%bb%e5%88%975%ef%bc%9a%e4%bb%80%e9%ba%bc%e6%a8%a3%e7%9a%84%e8%82%a1%e7%a5%a8%e5%87%ba%e9%87%8f%e5%8f%af%e4%bb%a5%e8%bf%bd/)
> 說明：首先跟大家分享我用來挑選出量股的腳本：

value1=GetField(\"佔大盤成交量比\",\"D\");

setbackbar(20);

input:length(20);

variable:up1(0);

up1 = bollingerband(value1, Length, 2 );

if

value1 crosses over up1

and close\>close\[1\]

//量暴增而且股價上漲

and close\<close\[1\]\*1.08

//但漲幅沒有非常大

then ret=1;

## 場景 62：江湖傳說解密系列(5)：什麼樣的股票出量可以追? --- 關於獲利能力好轉，我用的是以下的腳本：

> 來源：[[江湖傳說解密系列(5)：什麼樣的股票出量可以追?]{.underline}](https://www.xq.com.tw/xstrader/%e6%b1%9f%e6%b9%96%e5%82%b3%e8%aa%aa%e8%a7%a3%e5%af%86%e7%b3%bb%e5%88%975%ef%bc%9a%e4%bb%80%e9%ba%bc%e6%a8%a3%e7%9a%84%e8%82%a1%e7%a5%a8%e5%87%ba%e9%87%8f%e5%8f%af%e4%bb%a5%e8%bf%bd/)
> 說明：關於獲利能力好轉，我用的是以下的腳本：

if barfreq\<\>\"Q\" then raiseruntimeerror(\"頻率請用季\");

//value1=GetFieldDate(\"營業利益率\",\"Q\");

if netprofitrsi cross over 50

//and value1=20180301

then ret=1;

outputfield(1,netprofitrsi,1,\"營業淨利率RSI\");

outputfield(2,value1,0,\"最新資料日期\");

## 場景 63：江湖傳說解密系列(5)：什麼樣的股票出量可以追? --- 這裡用到一個函數: netprofitrsi ，腳本如下：

> 來源：[[江湖傳說解密系列(5)：什麼樣的股票出量可以追?]{.underline}](https://www.xq.com.tw/xstrader/%e6%b1%9f%e6%b9%96%e5%82%b3%e8%aa%aa%e8%a7%a3%e5%af%86%e7%b3%bb%e5%88%975%ef%bc%9a%e4%bb%80%e9%ba%bc%e6%a8%a3%e7%9a%84%e8%82%a1%e7%a5%a8%e5%87%ba%e9%87%8f%e5%8f%af%e4%bb%a5%e8%bf%bd/)
> 說明：這裡用到一個函數: netprofitrsi ，腳本如下：

value1=GetField(\"營業利益率\",\"Q\");

value2=highest(value1,8)-lowest(value1,8);

value3=value1-lowest(value1,8);

if value2\<\>0 then value4=value3/value2\*100;

ret=value4;

## 場景 64：江湖傳說解密系列(4)： 創新高的股票能不能追？ --- 於是我寫了以下的腳本：

> 來源：[[江湖傳說解密系列(4)：
> 創新高的股票能不能追？]{.underline}](https://www.xq.com.tw/xstrader/%e6%b1%9f%e6%b9%96%e5%82%b3%e8%aa%aa%e8%a7%a3%e5%af%86%e7%b3%bb%e5%88%974%ef%bc%9a-%e5%89%b5%e6%96%b0%e9%ab%98%e7%9a%84%e8%82%a1%e7%a5%a8%e8%83%bd%e4%b8%8d%e8%83%bd%e8%bf%bd%ef%bc%9f/)
> 說明：於是我寫了以下的腳本：

value1=lowest(low,90);

if value1=low\[89\]

//波段低點跟前一日一樣，代表未再創新低

and highest(high\[1\],90)\<=value1\*(1+20/100)

//波段高點跟波段低點之間沒有隔太遠

and close crosses over highest(close\[1\],90)

//股價突破波段的高點

then ret=1;

## 場景 65：江湖傳說解密系列(2)：追強勢股是不是該挑毛利率高的？ --- 這裡我用CMI指標來找強勢股：

> 來源：[[江湖傳說解密系列(2)：追強勢股是不是該挑毛利率高的？]{.underline}](https://www.xq.com.tw/xstrader/%e6%b1%9f%e6%b9%96%e5%82%b3%e8%aa%aa%e8%a7%a3%e5%af%86%e7%b3%bb%e5%88%972-%e8%bf%bd%e5%bc%b7%e5%8b%a2%e8%82%a1%e6%98%af%e4%b8%8d%e6%98%af%e8%a9%b2%e6%8c%91%e6%af%9b%e5%88%a9%e7%8e%87%e9%ab%98/)
> 說明：這裡我用CMI指標來找強勢股：

Input:Period(10);

Var:CMI(0),AvgCMI(0);

// 計算

CMI=100\*(C-C\[Period-1\])/(Highest(H,Period)-Lowest(L,Period));

AvgCMI=average(CMI,6);

// CMI趨勢向上

if trueall(CMI\>=65,3) and AvgCMI\>=81 and Bias(7)\<4

and Average(GetField(\"成交金額(億)\",\"D\"),5)\>=0.1

then ret=1;

## 場景 66：江湖傳說解密系列(1)：多重MACD多頭交易策略？

> 來源：[[江湖傳說解密系列(1)：多重MACD多頭交易策略？]{.underline}](https://www.xq.com.tw/xstrader/%e6%b1%9f%e6%b9%96%e5%82%b3%e8%aa%aa%e8%a7%a3%e5%af%86%e7%b3%bb%e5%88%971%e5%a4%9a%e9%87%8dmacd%e5%a4%9a%e9%a0%ad%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：我寫的腳本如下：

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

if difValue \> macdValue

then ret=1;

## 場景 67：低貝他的股票無量變有量 --- 以下是無量變有量的腳本：

> 來源：[[低貝他的股票無量變有量]{.underline}](https://www.xq.com.tw/xstrader/%e4%bd%8e%e8%b2%9d%e4%bb%96%e7%9a%84%e8%82%a1%e7%a5%a8%e7%84%a1%e9%87%8f%e8%ae%8a%e6%9c%89%e9%87%8f/)
> 說明：以下是無量變有量的腳本：

input:v1(500,\"前一根bar成交量\");

input:v2(2000,\"這根bar成交量\");

if trueall(volume\[1\]\<=v1,10) and volume\>v2

then ret=1;

## 場景 68：投信大買的獲利能力創新高股 --- 一、毛利率或營益率創長期新高

> 來源：[[投信大買的獲利能力創新高股]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e4%bf%a1%e5%a4%a7%e8%b2%b7%e7%9a%84%e7%8d%b2%e5%88%a9%e8%83%bd%e5%8a%9b%e5%89%b5%e6%96%b0%e9%ab%98%e8%82%a1/)
> 說明：一、毛利率或營益率創長期新高

settotalbar(28);

value1=GetField(\"營業毛利率\",\"Q\");

value2=GetField(\"營業利益\",\"Q\");

input:period(28,\"過去N季\");

if value1=highest(value1,period)

or value2=highest(value2,period)

then ret=1;

## 場景 69：投信大買的獲利能力創新高股 --- 二、最近N日漲幅小於M%

> 來源：[[投信大買的獲利能力創新高股]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e4%bf%a1%e5%a4%a7%e8%b2%b7%e7%9a%84%e7%8d%b2%e5%88%a9%e8%83%bd%e5%8a%9b%e5%89%b5%e6%96%b0%e9%ab%98%e8%82%a1/)
> 說明：二、最近N日漲幅小於M%

input:period(10,\"計算區間\");

input:ratio(10,\"最低漲跌幅\");

value1 = rateofchange(close,period-1);

if value1 \< ratio then ret=1;

outputfield(1,value1,1,\"區間漲跌幅\");

## 場景 70：技術分析用在中小型股是不是比較有用？

> 來源：[[技術分析用在中小型股是不是比較有用？]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%80%e8%a1%93%e5%88%86%e6%9e%90%e7%94%a8%e5%9c%a8%e4%b8%ad%e5%b0%8f%e5%9e%8b%e8%82%a1%e6%98%af%e4%b8%8d%e6%98%af%e6%af%94%e8%bc%83%e6%9c%89%e7%94%a8%ef%bc%9f/)
> 說明：它的腳本如下：

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

SU=CLOSE-CLOSE\[1\]+SU\[1\]

else

SU=SU\[1\];

if close \< close\[1\] then

SD=CLOSE\[1\]-CLOSE+SD\[1\]

else

SD=SD\[1\];

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

TechScore = count;

## 場景 71：技術分析用在中小型股是不是比較有用？

> 來源：[[技術分析用在中小型股是不是比較有用？]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%80%e8%a1%93%e5%88%86%e6%9e%90%e7%94%a8%e5%9c%a8%e4%b8%ad%e5%b0%8f%e5%9e%8b%e8%82%a1%e6%98%af%e4%b8%8d%e6%98%af%e6%af%94%e8%bc%83%e6%9c%89%e7%94%a8%ef%bc%9f/)
> 說明：我的定義如下：

value1=techscore;

value2=average(value1,10);

if value2 crosses over 5

then ret=1;

## 場景 72：自營商買賣超到底是不是一個值得參考的數據？

> 來源：[[自營商買賣超到底是不是一個值得參考的數據？]{.underline}](https://www.xq.com.tw/xstrader/%e8%87%aa%e7%87%9f%e5%95%86%e8%b2%b7%e8%b3%a3%e8%b6%85%e5%88%b0%e5%ba%95%e6%98%af%e4%b8%8d%e6%98%af%e4%b8%80%e5%80%8b%e5%80%bc%e5%be%97%e5%8f%83%e8%80%83%e7%9a%84%e6%95%b8%e6%93%9a%ef%bc%9f/)
> 說明：首先介紹他寫的腳本：

Input:
Length(9,\"累計天數\"),UpRatio(1.5,\"上漲幅度(%)\"),VolRatio(7,\"買賣超佔量比(%)\");

// 收紅K

Condition1=C\>=(1+UpRatio/100)\*C\[1\];

// 自營商自行買賣買賣超佔量比\>7%

Condition2=Summation(GetField(\"自營商自行買賣買賣超\"),Length)\>VolRatio/100\*Summation(V,Length);

If Condition1 and Condition2 Then Ret=1;

## 場景 73：外資不碰的股票有人在收 --- 為了找出這樣的股票，我們優秀的同事幫我寫了以下的腳本：

> 來源：[[外資不碰的股票有人在收]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%96%e8%b3%87%e4%b8%8d%e8%b8%ab%e7%9a%84%e8%82%a1%e7%a5%a8%e6%9c%89%e4%ba%ba%e5%9c%a8%e6%94%b6/)
> 說明：為了找出這樣的股票，我們優秀的同事幫我寫了以下的腳本：

input: period(5,\"計算期間\");

input: investorLimit(2000,\"外資持股上限\");

input: ratio(50,\"主力買張比重(%)\");

input: volLimit(500 , \"成交均量下限\");

SetTotalBar(3);

// 主力買張比重

value1 = summation(GetField(\"主力買張\",\"D\")\[1\], period);

value2 = summation(volume\[1\], period);

value3 = value1 / value2 \* 100;

if GetField(\"外資持股\",\"D\") \[1\]\< investorLimit and value3 \>
ratio and value2 \> volLimit \* period

then ret=1;

## 場景 74：基本面好轉但股價仍在低位區 --- 這裡我使用的是一個叫作低調創高的腳本：

> 來源：[[基本面好轉但股價仍在低位區]{.underline}](https://www.xq.com.tw/xstrader/%e5%9f%ba%e6%9c%ac%e9%9d%a2%e5%a5%bd%e8%bd%89%e4%bd%86%e8%82%a1%e5%83%b9%e4%bb%8d%e5%9c%a8%e4%bd%8e%e4%bd%8d%e5%8d%80%e3%80%80/)
> 說明：這裡我使用的是一個叫作低調創高的腳本：

value1=standarddev(close,10,1);

if value1\<average(value1,10)

and close crosses over highest(close\[1\],10)

then ret=1;

## 場景 75：月營收成長超過以往且大股東站在買方 --- 首先我們先來寫一個月營收年增率長期以來第一次突破某臨界點的腳本：

> 來源：[[月營收成長超過以往且大股東站在買方]{.underline}](https://www.xq.com.tw/xstrader/%e6%9c%88%e7%87%9f%e6%94%b6%e6%88%90%e9%95%b7%e8%b6%85%e9%81%8e%e4%bb%a5%e5%be%80%e4%b8%94%e5%a4%a7%e8%82%a1%e6%9d%b1%e7%ab%99%e5%9c%a8%e8%b2%b7%e6%96%b9/)
> 說明：首先我們先來寫一個月營收年增率長期以來第一次突破某臨界點的腳本：

input:ratio(20,\"月營收年增率下限\");

value1=dateValue(currentdate,\"d\");

if getfield(\"月營收年增率\", \"M\")\>=ratio

and barslast(getfield(\"月營收年增率\", \"M\")\>=ratio)\[1\]\>12

then ret=1;

## 場景 76：從月營收估算EPS後推估出值得留意的低價股 --- XQ系統有內建一個月營收推估出的低本益比股，腳本如下：

> 來源：[[從月營收估算EPS後推估出值得留意的低價股]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%9e%e6%9c%88%e7%87%9f%e6%94%b6%e4%bc%b0%e7%ae%97eps%e5%be%8c%e6%8e%a8%e4%bc%b0%e5%87%ba%e5%80%bc%e5%be%97%e7%95%99%e6%84%8f%e7%9a%84%e4%bd%8e%e5%83%b9%e8%82%a1/)
> 說明：XQ系統有內建一個月營收推估出的低本益比股，腳本如下：

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

## 場景 77：過往不錯的公司落難時

> 來源：[[過往不錯的公司落難時]{.underline}](https://www.xq.com.tw/xstrader/23070-2/)
> 說明：這兩條的腳本如下：

value1 = GetField(\"現金股利\",\"Y\");

value2 = getfielddate(\"現金股利\");

// 連續N年都有配股利

input: year_length1(8, \"連續N年都有配股利\");

condition1 = trueall(value1 \> 0, year_length1);

// 過去N年配大於X元股利

input: year_length2(5, \"過去N年配\");

input: cash_threshold(1, \"配至少X元\");

condition2 = trueall(value1 \>= cash_threshold, year_length2);

if

condition1

and condition2

then

ret = 1;

outputfield(1, value1\[0\], 2, formatdate(\"yyyy\", value2\[0\]));

outputfield(2, value1\[1\], 2, formatdate(\"yyyy\", value2\[1\]));

outputfield(3, value1\[2\], 2, formatdate(\"yyyy\", value2\[2\]));

outputfield(4, value1\[3\], 2, formatdate(\"yyyy\", value2\[3\]));

outputfield(5, value1\[4\], 2, formatdate(\"yyyy\", value2\[4\]));

## 場景 78：過往不錯的公司落難時 --- 他寫了一個函數來作計算：

> 來源：[[過往不錯的公司落難時]{.underline}](https://www.xq.com.tw/xstrader/23070-2/)
> 說明：他寫了一個函數來作計算：

input: x(numeric, \"季度\");

settotalbar(30);

value1 = GetField(\"營業利益率\",\"Q\");

value11 = 0;

if value1\[x\] \> value1\[x+4\] then value11 += 1;

if value1\[x+4\] \> value1\[x+8\] then value11 += 1;

if value1\[x+8\] \> value1\[x+12\] then value11 += 1;

ret = value11;

## 場景 79：過往不錯的公司落難時 --- 同樣的，他也寫了一個函數來計算過去n季，有幾季是每一季的營業毛利率都比去年同期高。

> 來源：[[過往不錯的公司落難時]{.underline}](https://www.xq.com.tw/xstrader/23070-2/)
> 說明：同樣的，他也寫了一個函數來計算過去n季，有幾季是每一季的營業毛利率都比去年同期高。

input: x(numeric, \"季度\");

settotalbar(30);

value1 = GetField(\"營業毛利率\",\"Q\");

value11 = 0;

if value1\[x\] \> value1\[x+4\] then value11 += 1;

if value1\[x+4\] \> value1\[x+8\] then value11 += 1;

if value1\[x+8\] \> value1\[x+12\] then value11 += 1;

ret = value11;

## 場景 80：過往不錯的公司落難時 --- 有了這兩個函數之後，他寫了以下的腳本：

> 來源：[[過往不錯的公司落難時]{.underline}](https://www.xq.com.tw/xstrader/23070-2/)
> 說明：有了這兩個函數之後，他寫了以下的腳本：

settotalbar(30);

input: score_threshold1(9, \"營業利益率得分門檻\");

input: score_threshold2(9, \"營業毛利率得分門檻\");

value10 = callfunction(\"過去三年營業利益率同季比較分數\", 0);

value11 = callfunction(\"過去三年營業利益率同季比較分數\", 1);

value12 = callfunction(\"過去三年營業利益率同季比較分數\", 2);

value13 = callfunction(\"過去三年營業利益率同季比較分數\", 3);

value19 = value10 + value11 + value12 + value13;

outputfield(1, value19, 0, \"營業利益率得分\");

value20 = callfunction(\"過去三年營業毛利率同季比較分數\", 0);

value21 = callfunction(\"過去三年營業毛利率同季比較分數\", 1);

value22 = callfunction(\"過去三年營業毛利率同季比較分數\", 2);

value23 = callfunction(\"過去三年營業毛利率同季比較分數\", 3);

value29 = value20 + value21 + value22 + value23;

outputfield(2, value29, 0, \"營業毛利率得分\");

if value19 \>= score_threshold1 and value29 \>= score_threshold2 then
ret = 1;

## 場景 81：創新高股能不能逆勢上漲？ --- 先來測一下創百日新高。

> 來源：[[創新高股能不能逆勢上漲？]{.underline}](https://www.xq.com.tw/xstrader/%e5%89%b5%e6%96%b0%e9%ab%98%e8%82%a1%e8%83%bd%e4%b8%8d%e8%83%bd%e9%80%86%e5%8b%a2%e4%b8%8a%e6%bc%b2%ef%bc%9f/)
> 說明：先來測一下創百日新高。

if close=highest(close,100)

then ret=1;

## 場景 82：聚合理論在選股上的應用 --- 然後再搭配價量創近期新高的技術面條件：

> 來源：[[聚合理論在選股上的應用]{.underline}](https://www.xq.com.tw/xstrader/%e8%81%9a%e5%90%88%e7%90%86%e8%ab%96%e5%9c%a8%e9%81%b8%e8%82%a1%e4%b8%8a%e7%9a%84%e6%87%89%e7%94%a8/)
> 說明：然後再搭配價量創近期新高的技術面條件：

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 83：尋找阿爾發之旅系列27 --- 暴量剛起漲的腳本如下：

> 來源：[[尋找阿爾發之旅系列27]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9727/)
> 說明：暴量剛起漲的腳本如下：

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 84：尋找阿爾發之旅系列26 --- 加入N日來籌碼被收集的腳本：

> 來源：[[尋找阿爾發之旅系列26]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9726/)
> 說明：加入N日來籌碼被收集的腳本：

input:period(20);

value1=GetField(\"分公司賣出家數\")\[1\];

value2=GetField(\"分公司買進家數\")\[1\];

if linearregslope(value1,period)\>0

//賣出的家數愈來愈多

and linearregslope(value2,period)\<0

//買進的家數愈來愈少

then ret=1;

## 場景 85：尋找阿爾發之旅系列26 --- 或是加入暴量剛起漲的腳本：

> 來源：[[尋找阿爾發之旅系列26]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9726/)
> 說明：或是加入暴量剛起漲的腳本：

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 86：尋找阿爾發之旅系列25 --- 我寫了以下的腳本來描述獲利穩定，無爆發力，計算其目標價，然後找出當前股價離目標價很遠的股票：

> 來源：[[尋找阿爾發之旅系列25]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9725/)
> 說明：我寫了以下的腳本來描述獲利穩定，無爆發力，計算其目標價，然後找出當前股價離目標價很遠的股票：

var:tp(0);

if highest(GetField(\"每股稅後淨利(元)\",\"Y\"),7)

-lowest(GetField(\"每股稅後淨利(元)\",\"Y\"),7)\<1.5

and trueall(GetField(\"每股稅後淨利(元)\",\"Y\")\>1,7)

//每年EPS差距不大且每年賺錢

then tp=GetField(\"每股淨值(元)\",\"Q\")+

average(GetField(\"每股稅後淨利(元)\",\"Y\"),4)\*7;

input:rate(40,\"折價比率\");

if close\*(1+rate/100)\<tp

then ret=1;

outputfield(1,tp,1,\"目標價\");

outputfield(2,tp/close-1,1,\"折價率\");

## 場景 87：尋找阿爾發之旅系列25 --- 這裡我用的大股東站在買方的腳本如下：

> 來源：[[尋找阿爾發之旅系列25]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9725/)
> 說明：這裡我用的大股東站在買方的腳本如下：

input: v1(500,\"買超下限張數\");

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

value2=getField(\"關聯券商買賣超張數\", \"D\");

value3=getField(\"地緣券商買賣超張數\", \"D\");

if GetField(\"內部人持股比例\",\"M\")

\>GetField(\"內部人持股比例\",\"M\")\[1\]

or GetField(\"大戶持股比例\",\"W\",param := 1000)

\>GetField(\"大戶持股比例\",\"W\",param := 1000)\[1\]+0.5

or value1\>=v1

or value2\>=v1

or value3\>=v1

then ret=1;

outputfield(1,GetField(\"內部人持股比例\",\"M\"),0,\"內部人\");

outputfield(2,GetField(\"內部人持股比例\",\"M\")\[1\],0,\"前期內部人\");

outputfield(3,value1,0,\"關鍵券商\");

outputfield(4,GetField(\"大戶持股比例\",\"W\",param :=
1000),1,\"千張大戶比例\");

outputfield(5,GetField(\"大戶持股比例\",\"W\",param :=
1000)\[1\],1,\"前期千張大戶比例\");

## 場景 88：尋找阿爾發之旅系列24 --- 借用一個我同事寫的腳本來描述放量上漲。

> 來源：[[尋找阿爾發之旅系列24]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9724/)
> 說明：借用一個我同事寫的腳本來描述放量上漲。

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 89：尋找阿爾發之旅系列23 --- 計算的公式及腳本如下：

> 來源：[[尋找阿爾發之旅系列23]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9723/)
> 說明：計算的公式及腳本如下：

value1=GetField(\"總市值\",\"D\");//單位億

value2=GetField(\"負債總額\",\"Q\");//單位百萬

value3=GetField(\"現金及約當現金\",\"Q\");//單位百萬

value4=GetField(\"短期投資\",\"Q\");//單位百萬

value5=GetField(\"稅前息前折舊前淨利\",\"Q\");//單位百萬

var: pricingm1(0);

input: bl(4,\"上限值\");

if value5\>0 then begin

pricingm1=(value1\*100+value2-value3-value4)/summation(value5,4);

if pricingm1\<bl and pricingm1\>1

then ret=1;

outputfield(1,pricingm1,1,\"EV/EBITDA\");

outputfield(2,value1\*100+value2-value3-value4,0,\"EV\");

outputfield(3,value5,0,\"EBITDA\");

outputfield(4,value1,0,\"總市值\");

outputfield(5,value2,0,\"負債總額\");

outputfield(6,value3,0,\"現金\");

outputfield(7,value4,0,\"短期投資\");

end;

## 場景 90：尋找阿爾發之旅系列22 --- 首先來找在整理中的股票，在布林指標中，是用布林帶寬小於N%來描敘整理格局：

> 來源：[[尋找阿爾發之旅系列22]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9722/)
> 說明：首先來找在整理中的股票，在布林指標中，是用布林帶寬小於N%來描敘整理格局：

input:length(20,\"計算天期\");

input:width(1.5,\"帶寬%\");

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 = bollingerband(Close, Length, 2);

down1 = bollingerband(Close, Length, -2 );

mid1 = (up1 + down1) / 2; bbandwidth = 100 \* (up1 - down1) / mid1;

if bbandwidth \<width then ret=1;

## 場景 91：尋找阿爾發之旅系列22 --- 其次我們用突破布林線上緣來形容股價轉強：

> 來源：[[尋找阿爾發之旅系列22]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9722/)
> 說明：其次我們用突破布林線上緣來形容股價轉強：

Input: Length(20), UpperBand(2);

SetInputName(1, \"期數\");

SetInputName(2, \"通道上緣\");

settotalbar(3);

Ret = close \>= bollingerband(Close, Length, UpperBand);

## 場景 92：尋找阿爾發之旅系列21 --- 根據上述的條件，我原本寫的腳本如下：

> 來源：[[尋找阿爾發之旅系列21]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9721/)
> 說明：根據上述的條件，我原本寫的腳本如下：

input: v1(500, \"投信估計持股上限(張)\");

value1=GetField(\"投信持股\",\"D\");

value2=GetField(\"投信買賣超\",\"D\");

if value1 \< v1 and value2 \> VOLUME\*0.2

then ret=1;

## 場景 93：尋找阿爾發之旅系列21 --- 所以在腳本上加上一行字，找出大買超是近期第一天的個股：

> 來源：[[尋找阿爾發之旅系列21]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9721/)
> 說明：所以在腳本上加上一行字，找出大買超是近期第一天的個股：

input: v1(500, \"投信估計持股上限(張)\");

value1=GetField(\"投信持股\",\"D\");

value2=GetField(\"投信買賣超\",\"D\");

if value1 \< v1

and value2 \> VOLUME\*0.2

and barslast(value2 \> VOLUME\*0.2)\[1\]\>100

then ret=1;

## 場景 94：尋找阿爾發之旅系列20 --- 其中用到的腳本我列在下面：

> 來源：[[尋找阿爾發之旅系列20]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%9720/)
> 說明：其中用到的腳本我列在下面：

input:day(10);

input: FastLength(12, \"DIF短期期數\"), SlowLength(26, \"DIF長期期數\"),
MACDLength(9, \"MACD期數\");

variable: difValue(0), macdValue(0), oscValue(0),Kprice(0);

settotalbar(100);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

if absvalue((average(close,20)-close)/close)\*100\<2

//股價距離月線不到2%

and absvalue((average(close,60)-close)/close)\*100\<2

//股價距離季線不到2%

and close=highest(close,day)

//股價創10日高點

and macdvalue\>macdvalue\[1\]

and macdvalue\>0

and difvalue\>0

then ret=1;

## 場景 95：尋找阿爾發之旅系列十九

> 來源：[[尋找阿爾發之旅系列十九]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%8d%81%e4%b9%9d/)
> 說明：以下是他寫的腳本：

Input:Period(10);

Var:CMI(0),AvgCMI(0);

// 計算

CMI=100\*(C-C\[Period-1\])/(Highest(H,Period)-Lowest(L,Period));

AvgCMI=average(CMI,6);

// CMI趨勢向上

if trueall(CMI\>=65,3) and AvgCMI\>=81 and Bias(7)\<4

and Average(GetField(\"成交金額(億)\",\"D\"),5)\>=0.2

then ret=1;

## 場景 96：尋找阿爾發之旅系列十八

> 來源：[[尋找阿爾發之旅系列十八]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%8d%81%e5%85%ab/)
> 說明：於是寫出以下的腳本：

// 作多: 持有期間=10

//

input:period(10,\"籌碼計算天期\");

Value1=GetField(\"分公司買進家數\",\"D\")\[1\];

value2=GetField(\"分公司賣出家數\",\"D\")\[1\];

value3=(value2-value1);

//賣出的家數比買進家數多的部份

value4=average(close,5);

//五日移動平均

if countif(value3\>50, period)/period \>0.7

and linearregslope(value4,5)\>0

then ret=1;

## 場景 97：尋找阿爾發之旅系列十七 --- 於是我就使用先前常用的暴量起漲腳本。

> 來源：[[尋找阿爾發之旅系列十七]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%8d%81%e4%b8%83/)
> 說明：於是我就使用先前常用的暴量起漲腳本。

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 98：尋找阿爾發之旅系列十六 --- 後來我無意中發現，好像GVI指數如果由底部往上走，往往會是短多的機會，於是我寫了以下的腳本：

> 來源：[[尋找阿爾發之旅系列十六]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%8d%81%e5%85%ad/)
> 說明：後來我無意中發現，好像GVI指數如果由底部往上走，往往會是短多的機會，於是我寫了以下的腳本：

value1=GetField(\"股價淨值比\",\"D\");

value2=GetField(\"股東權益報酬率\",\"Q\");

var:GVI(0);

GVI=1/value1\*(1+value2)\*(1+value2)\*(1+value2)\*(1+value2)\*(1+value2);

if gvi cross over 1.2

then ret=1;

## 場景 99：尋找阿爾發之旅系列十五 --- 其中市值營收比小於N這個腳本如下：

> 來源：[[尋找阿爾發之旅系列十五]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%8d%81%e4%ba%94/)
> 說明：其中市值營收比小於N這個腳本如下：

value1=getField(\"總市值(億)\", \"D\");

value2=getField(\"營業收入淨額\", \"Y\");//單位：百萬

value3=(value1\*100)/value2;// 總市值營收比

input:ratio(1,\"總市值營收比\");

if value3\<ratio then ret=1;

## 場景 100：尋找阿爾發之旅系列十五 --- 這裡我用的是暴量起漲這個先前介紹過很有用的腳本：

> 來源：[[尋找阿爾發之旅系列十五]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%8d%81%e4%ba%94/)
> 說明：這裡我用的是暴量起漲這個先前介紹過很有用的腳本：

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 101：尋找阿爾發之旅系列十四 --- 於是我寫了一個大盤走多頭的腳本：

> 來源：[[尋找阿爾發之旅系列十四]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%8d%81%e5%9b%9b/)
> 說明：於是我寫了一個大盤走多頭的腳本：

value1=getSymbolField(\"tse.tw\", \"收盤價\", \"D\");

if value1\> average(value1,22)

then ret=1;

## 場景 102：尋找阿爾發之旅系列十三 --- 創百日新高的腳本如下：

> 來源：[[尋找阿爾發之旅系列十三]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%8d%81%e4%b8%89/)
> 說明：創百日新高的腳本如下：

if close=highest(close,100)

then ret=1;

## 場景 103：尋找阿爾發之旅系列十三 --- 如果把這個腳本改成是近一段時間以來第一次創百日新高的話，

> 來源：[[尋找阿爾發之旅系列十三]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%8d%81%e4%b8%89/)
> 說明：如果把這個腳本改成是近一段時間以來第一次創百日新高的話，

if close=highest(close,100)

and barslast(close=highest(close,100))\[1\]\>60

then ret=1;

## 場景 104：尋找阿爾發之旅系列十二 --- 這個我從網路上看來的觀點，寫出來的腳本如下圖：

> 來源：[[尋找阿爾發之旅系列十二]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%8d%81%e4%ba%8c/)
> 說明：這個我從網路上看來的觀點，寫出來的腳本如下圖：

variable:rsv1(0),k1(0),d1(0);

stochastic(9,3,3,rsv1,k1,d1);

condition1=false;

value1=average(close,5);

value2=average(close,20);

value3=average(close,60);

if linearregslope(close,5)crosses over 0

//近五日趨勢線剛剛由下跌轉成上漲

and linearregslope(value1,5)\>0

and linearregslope(value2,5)\>0

and linearregslope(value3,5)\>0

//週線，月線及季線的斜率都是正的

and k1\>80

//9K大於80

then condition1=true;

if condition1

and barslast(condition1)\[1\]\>10

//近10日第一次符合上述條件

then ret=1;

## 場景 105：尋找阿爾發之旅系列十一 --- 1. 連續5日成交量\>5002. MACD黃金交叉且OSC愈來愈大3. 90日最高與最低之幅度\<10%

> 來源：[[尋找阿爾發之旅系列十一]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%8d%81%e4%b8%80/)
> 說明：1. 連續5日成交量\>5002. MACD黃金交叉且OSC愈來愈大3.
> 90日最高與最低之幅度\<10%

Input:SPeriod(5),LLPeriod(90);

Input:FastLength(12),SlowLength(26),MACDLength(9);

Var:difValue(0),macdValue(0),oscValue(0);

// 計算

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

// 條件

Condition1=trueall(V\>500,SPeriod);//1. 連續5日成交量\>500

Condition2=oscValue\>0 and oscValue\[1\]\<0

and oscValue\[1\]\>oscValue\[2\]

and oscValue\[0\]\>-oscValue\[1\];

//2. MACD黃金交叉且OSC愈來愈大

Condition3=absvalue(100\*(Lowest(L,LLPeriod)-Highest(H,LLPeriod))

/Highest(H,LLPeriod))\<10;//3. 144日最高與最低之幅度\<10%

Condition99=Condition1 and Condition2 and Condition3 ;

// 篩選

IF Condition99 Then Ret=1;

## 場景 106：尋找阿爾發之旅系列之九 --- 下面是我同事，根據上述的概念所寫的腳本：

> 來源：[[尋找阿爾發之旅系列之九]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e4%b9%8b%e4%b9%9d/)
> 說明：下面是我同事，根據上述的概念所寫的腳本：

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

## 場景 107：台灣加權指數為何會超越恆生指數的細部探討 --- 由於加權指數是以總市值作為計算基礎，我寫了一個腳本來計算自2016年5月19日收盤價到昨天為止，總市值的變動情況：

> 來源：[[台灣加權指數為何會超越恆生指數的細部探討]{.underline}](https://www.xq.com.tw/xstrader/%e5%8f%b0%e7%81%a3%e5%8a%a0%e6%ac%8a%e6%8c%87%e6%95%b8%e7%82%ba%e4%bd%95%e6%9c%83%e8%b6%85%e8%b6%8a%e6%81%86%e7%94%9f%e6%8c%87%e6%95%b8%e7%9a%84%e7%b4%b0%e9%83%a8%e6%8e%a2%e8%a8%8e/)
> 說明：由於加權指數是以總市值作為計算基礎，我寫了一個腳本來計算自2016年5月19日收盤價到昨天為止，總市值的變動情況：

value1=getbaroffset(20160519);

value2=getField(\"總市值(億)\", \"D\");

value3=value2-value2\[value1\];

value4=(value2/value2\[value1\]-1);

ret=1;

outputfield(1,value3,0,\"市值變動（億）\");

outputfield(2,value2\[value1\],0,\"前期總市值\");

outputfield(3,value2,0,\"目前總市值\");

outputfield(4,value4,0,\"變動率\");

## 場景 108：尋找阿爾發之旅系列八 --- 首先，我寫了一個無量變有量的腳本：

> 來源：[[尋找阿爾發之旅系列八]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%85%ab/)
> 說明：首先，我寫了一個無量變有量的腳本：

input:v1(500,\"前一根bar成交量\");

input:v2(2000,\"這根bar成交量\");

if trueall(volume\[1\]\<=v1,10) and volume\>v2

then ret=1;

## 場景 109：尋找阿爾發之旅系列七 --- 這樣的想法，寫出來的腳本如下：

> 來源：[[尋找阿爾發之旅系列七]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e4%b8%83/)
> 說明：這樣的想法，寫出來的腳本如下：

input:days(60,\"計算期間\");

input:M1(800,\"最低買超張數\");

value1=getField(\"外資買賣超\", \"D\");

value2=getField(\"投信買賣超\", \"D\");

condition1=value1\>m1 and value2\>m1;

if condition1

and barslast(condition1)\[1\]\>=days

and close\<50

then ret=1;

## 場景 110：尋找阿爾發之旅系列六 --- 於是，我寫了以下的腳本：

> 來源：[[尋找阿爾發之旅系列六]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%85%ad/)
> 說明：於是，我寫了以下的腳本：

value1=close\[1\]/close\[30\]-1;

if value1\>-0.703448

and value1\<-0.284939047

then ret=1;

## 場景 111：尋找阿爾發之旅系列五 --- 後來我在觀察K 線時發現，未必要等到90天，如果有30天都沒有破底且最近一個交易日創波段最高點，後市短多的機率就會變高，我寫的腳本如下：

> 來源：[[尋找阿爾發之旅系列五]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e4%ba%94/)
> 說明：後來我在觀察K
> 線時發現，未必要等到90天，如果有30天都沒有破底且最近一個交易日創波段最高點，後市短多的機率就會變高，我寫的腳本如下：

input:period(30);

input:percent(10);

setinputname(1,\"未破底區間\");

setinputname(2,\"盤整區間漲幅上限\");

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

## 場景 112：尋找阿爾發之旅系列四

> 來源：[[尋找阿爾發之旅系列四]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e5%9b%9b/)
> 說明：腳本全文如下：

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 113：尋找阿爾發之旅系列三

> 來源：[[尋找阿爾發之旅系列三]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e4%b8%89/)
> 說明：這個實驗的腳本如下：

value1=getField(\"總市值(億)\", \"D\");

value2=getField(\"研發費用\", \"Y\");//百萬

value3=value2/(value1\*100)\*100;

if value3\>15 then ret=1;

## 場景 114：尋找阿爾發之旅系列二 --- 舉個例子，大家常用的布林值買超策略：

> 來源：[[尋找阿爾發之旅系列二]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e4%ba%8c/)
> 說明：舉個例子，大家常用的布林值買超策略：

input:length(20);

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 = bollingerband(Close, Length, 1);

down1 = bollingerband(Close, Length, -1 );

mid1 = (up1 + down1) / 2;

bbandwidth = 100 \* (up1 - down1) / mid1;

if bbandwidth crosses above 5 and close \> up1 and close\> up1\[1\]

and average(close,20)\>average(close,20)\[1\]

then ret=1;

## 場景 115：尋找阿爾發之旅系列一

> 來源：[[尋找阿爾發之旅系列一]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e9%98%bf%e7%88%be%e7%99%bc%e4%b9%8b%e6%97%85%e7%b3%bb%e5%88%97%e4%b8%80/)
> 說明：我寫的腳本如下：

value1=lowest(low,90);

if value1=low\[89\]

//波段低點跟90日前一樣，代表未再創新低

and highest(high\[1\],90)\<=value1\*(1+20/100)

//波段高點跟波段低點之間沒有隔太遠，不超過兩成

and close crosses over highest(close\[1\],90)

//股價突破90日以來的高點

then ret=1;

## 場景 116：滿手現金卻發可轉債？勝率 98% 的 CB 量化選股因子 --- XS 選股代碼》價外卻溢價的CB

> 來源：[[滿手現金卻發可轉債？勝率 98% 的 CB
> 量化選股因子]{.underline}](https://www.xq.com.tw/xstrader/%e6%bb%bf%e6%89%8b%e7%8f%be%e9%87%91%e5%8d%bb%e7%99%bc%e5%8f%af%e8%bd%89%e5%82%b5%ef%bc%9f%e5%8b%9d%e7%8e%87-98-%e7%9a%84-cb-%e9%87%8f%e5%8c%96%e9%81%b8%e8%82%a1%e5%9b%a0%e5%ad%90/)
> 說明：XS 選股代碼》價外卻溢價的CB

// \*\*\*\*\* 價外卻溢價的CB \*\*\*\*\*

Input: ITM(105, \"價內定義\"), OTM(95, \"價外定義\");

Input: PriceH(120, \"CB市價上限\"), PriceL(95, \"CB市價下限\");

// 計算 轉換張數

Value1 = 100 / GetSymbolInfo(\"轉換價格\");

// 計算 轉換價值(Parity)

Value2 = Value1 \* GetSymbolField(\"Underlying\", \"Close\", \"D\");

// 計算 轉換溢價率

Value3 = (Close - Value2) / Value2;

// 判斷 CB市價 \>= 偏好標準

Condition1 = Close \<= PriceH and Close \>= PriceL;

// 判斷 轉換價值 = 價外

Condition2 = Value2 \<= OTM;

// 判斷 溢價率為正數

Condition3 = Value3 \> 0;

IF Condition1 and Condition2 and Condition3

Then Ret = 1;

OutputField1(Value3, 2, \"溢價率\");

OutputField2(Value2, 0, \"轉換價值\");

## 場景 117：滿手現金卻發可轉債？勝率 98% 的 CB 量化選股因子 --- XS 選股代碼》CB標的之股價淨值比

> 來源：[[滿手現金卻發可轉債？勝率 98% 的 CB
> 量化選股因子]{.underline}](https://www.xq.com.tw/xstrader/%e6%bb%bf%e6%89%8b%e7%8f%be%e9%87%91%e5%8d%bb%e7%99%bc%e5%8f%af%e8%bd%89%e5%82%b5%ef%bc%9f%e5%8b%9d%e7%8e%87-98-%e7%9a%84-cb-%e9%87%8f%e5%8c%96%e9%81%b8%e8%82%a1%e5%9b%a0%e5%ad%90/)
> 說明：XS 選股代碼》CB標的之股價淨值比

// \*\*\*\*\* CB標的之股價淨值比 \*\*\*\*\*

Input: Ratio(0.8, \"股價淨值比上限\");

// 判斷 股價淨值比 \<= 標準

Condition1 = GetSymbolField(\"Underlying\", \"股價淨值比\", \"D\") \<=
Ratio;

IF Condition1

Then Ret = 1;

## 場景 118：滿手現金卻發可轉債？勝率 98% 的 CB 量化選股因子 --- XS 選股代碼》CB標的之自由現金流量比

> 來源：[[滿手現金卻發可轉債？勝率 98% 的 CB
> 量化選股因子]{.underline}](https://www.xq.com.tw/xstrader/%e6%bb%bf%e6%89%8b%e7%8f%be%e9%87%91%e5%8d%bb%e7%99%bc%e5%8f%af%e8%bd%89%e5%82%b5%ef%bc%9f%e5%8b%9d%e7%8e%87-98-%e7%9a%84-cb-%e9%87%8f%e5%8c%96%e9%81%b8%e8%82%a1%e5%9b%a0%e5%ad%90/)
> 說明：XS 選股代碼》CB標的之自由現金流量比

// \*\*\*\*\* CB標的之自由現金流量比 \*\*\*\*\*

Input: Ratio(5, \"自由現金流量比上限\");

// 判斷 自由現金流量比 \<= 上限 Condition1 =
GetSymbolField(\"Underlying\", \"股價自由現金流量比\", \"D\") \<= Ratio;
IF Condition1 Then Ret = 1;

OutputField1(GetSymbolField(\"Underlying\", \"股價自由現金流量比\",
\"D\"),

2, \"股價自由現金流量比\");

## 場景 119：滿手現金卻發可轉債？勝率 98% 的 CB 量化選股因子 --- XS 選股代碼》CB標的之現金殖利率

> 來源：[[滿手現金卻發可轉債？勝率 98% 的 CB
> 量化選股因子]{.underline}](https://www.xq.com.tw/xstrader/%e6%bb%bf%e6%89%8b%e7%8f%be%e9%87%91%e5%8d%bb%e7%99%bc%e5%8f%af%e8%bd%89%e5%82%b5%ef%bc%9f%e5%8b%9d%e7%8e%87-98-%e7%9a%84-cb-%e9%87%8f%e5%8c%96%e9%81%b8%e8%82%a1%e5%9b%a0%e5%ad%90/)
> 說明：XS 選股代碼》CB標的之現金殖利率

// \*\*\*\*\* CB標的之現金殖利率 \*\*\*\*\*

Input: Ratio(5, \"現金殖利率下限\");

// 判斷 現金殖利率 \>= 下限

Condition1 = GetSymbolField(\"Underlying\", \"現金股利殖利率\", \"D\")
\>= Ratio;

IF Condition1

Then Ret = 1;

OutputField1(GetSymbolField(\"Underlying\", \"現金股利殖利率\", \"D\"),
2, \"現金股利殖利率\");

## 場景 120：滿手現金卻發可轉債？勝率 98% 的 CB 量化選股因子 --- XS 指標代碼》溢價率指標

> 來源：[[滿手現金卻發可轉債？勝率 98% 的 CB
> 量化選股因子]{.underline}](https://www.xq.com.tw/xstrader/%e6%bb%bf%e6%89%8b%e7%8f%be%e9%87%91%e5%8d%bb%e7%99%bc%e5%8f%af%e8%bd%89%e5%82%b5%ef%bc%9f%e5%8b%9d%e7%8e%87-98-%e7%9a%84-cb-%e9%87%8f%e5%8c%96%e9%81%b8%e8%82%a1%e5%9b%a0%e5%ad%90/)
> 說明：XS 指標代碼》溢價率指標

// \*\*\*\*\* 折溢價指標 \*\*\*\*\*

Input: ITM(105, \"價內定義\"), OTM(95, \"價外定義\");

Input: PriceH(120, \"CB市價上限\"), PriceL(95, \"CB市價下限\");

// 計算 轉換張數

Value1 = 100 / GetField(\"轉換價格\");

// 計算 轉換價值

Value2 = Value1 \* GetSymbolField(\"Underlying\", \"Close\");

// 計算 轉換溢價率

Value3 = (Close - Value2) / Value2;

// 判斷 CB市價 \>= 偏好標準

Condition1 = Close \<= PriceH and Close \>= PriceL;

// 判斷 轉換價值 = 價外

Condition2 = Value2 \<= OTM;

// 判斷 溢價率為正數

Condition3 = Value3 \> 0;

// 畫出 折溢價率

Plot1(Value3, \"折溢價率\");

IF Condition1 and Condition2 and Condition3

Then Plot2(Value3, \"折溢價率\");

## 場景 121：滿手現金卻發可轉債？勝率 98% 的 CB 量化選股因子 --- XS 指標代碼》券償指標

> 來源：[[滿手現金卻發可轉債？勝率 98% 的 CB
> 量化選股因子]{.underline}](https://www.xq.com.tw/xstrader/%e6%bb%bf%e6%89%8b%e7%8f%be%e9%87%91%e5%8d%bb%e7%99%bc%e5%8f%af%e8%bd%89%e5%82%b5%ef%bc%9f%e5%8b%9d%e7%8e%87-98-%e7%9a%84-cb-%e9%87%8f%e5%8c%96%e9%81%b8%e8%82%a1%e5%9b%a0%e5%ad%90/)
> 說明：XS 指標代碼》券償指標

// \*\*\*\*\* 券償指標 \*\*\*\*\*

// 畫出 融券增減張數

Plot1(GetSymbolField(\"Underlying\", \"融券增減張數\", \"D\"),
\"融券增減張數\");

// 計算 融券賣出佔總量比

IF GetSymbolField(\"Underlying\", \"Volume\") \> 0

Then Value1 = GetSymbolField(\"Underlying\", \"融券賣出張數\", \"D\") /
(GetSymbolField(\"Underlying\", \"Volume\") -
GetSymbolField(\"Underlying\", \"當日沖銷張數\"))

Else Value1 = Value1\[1\];

// 畫出 券償還張數

Plot3(GetSymbolField(\"Underlying\", \"現券償還張數\", \"D\"),
\"現券償還張數\");

// 畫出 有融券現償的融券餘額減少位置

IF GetSymbolField(\"Underlying\", \"現券償還張數\", \"D\") \> 0

and GetSymbolField(\"Underlying\", \"融券增減張數\", \"D\") \< 0

Then Plot5(GetSymbolField(\"Underlying\", \"融券增減張數\", \"D\"),
\"融券增減值(償券中)\");

## 場景 122：月營收大成長後大股東開始進場 --- 我根據他的想法，寫了一個月營收年增率長期以來第一次突破20%的腳本，腳本如下：

> 來源：[[月營收大成長後大股東開始進場]{.underline}](https://www.xq.com.tw/xstrader/%e6%9c%88%e7%87%9f%e6%94%b6%e5%a4%a7%e6%88%90%e9%95%b7%e5%be%8c%e5%a4%a7%e8%82%a1%e6%9d%b1%e9%96%8b%e5%a7%8b%e9%80%b2%e5%a0%b4/)
> 說明：我根據他的想法，寫了一個月營收年增率長期以來第一次突破20%的腳本，腳本如下：

input:ratio(20,\"月營收年增率下限\");

value1=dateValue(currentdate,\"d\");

if getfield(\"月營收年增率\", \"M\")\>=ratio

and barslast(getfield(\"月營收年增率\", \"M\")\>=ratio)\[1\]\>12

then ret=1;

## 場景 123：好公司長期未破底後創新高 --- 首先長時間未破底後創新高這個腳本跟我2018年時寫的還是一樣

> 來源：[[好公司長期未破底後創新高]{.underline}](https://www.xq.com.tw/xstrader/%e5%a5%bd%e5%85%ac%e5%8f%b8%e9%95%b7%e6%9c%9f%e6%9c%aa%e7%a0%b4%e5%ba%95%e5%be%8c%e5%89%b5%e6%96%b0%e9%ab%98/)
> 說明：首先長時間未破底後創新高這個腳本跟我2018年時寫的還是一樣

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

## 場景 124：長期盤整後跳空上漲的獲利穩定股 --- 於是寫了一個腳本如下：

> 來源：[[長期盤整後跳空上漲的獲利穩定股]{.underline}](https://www.xq.com.tw/xstrader/%e9%95%b7%e6%9c%9f%e7%9b%a4%e6%95%b4%e5%be%8c%e8%b7%b3%e7%a9%ba%e4%b8%8a%e6%bc%b2%e7%9a%84%e7%8d%b2%e5%88%a9%e7%a9%a9%e5%ae%9a%e8%82%a1/)
> 說明：於是寫了一個腳本如下：

if (highest(high\[1\],60)/lowest(low\[1\],60)-1)\*100\<8

and open \> close\[1\]\*1.02

and close\<60

then ret=1;

## 場景 125：低量能＋區間盤整＝勝率80%？反其道而行的高勝率因子 --- XS 選股代碼》區間未破底且創新高

> 來源：[[低量能＋區間盤整＝勝率80%？反其道而行的高勝率因子]{.underline}](https://www.xq.com.tw/xstrader/%e7%aa%81%e7%a0%b4%e9%87%8f%e7%b8%ae%e7%9b%a4%e6%95%b4%e5%8d%80%e9%96%93%e5%be%8c%e7%9a%84%e9%ab%98%e5%8b%9d%e7%8e%87%e7%ad%96%e7%95%a5/)
> 說明：XS 選股代碼》區間未破底且創新高

// \*\*\*\*\* 區間未破底且創新高 \*\*\*\*\*

// 設定 輸入值

Input:period(60, \"區間定義\");

Input:percent(25, \"區間振幅定義\");

// 預設 條件值

Condition1 = False;

Condition2 = False;

// 計算 區間低點

Value1 = Lowest(Low, Period);

// 判斷 區間低點不破

IF Value1 = Low\[Period - 1\]

Then Condition1 = True;

// 判斷 區間高點 \<= 區間振幅

IF Highest(High\[1\], Period) \<= Value1 \* (1 + Percent / 100)

Then Condition2 = True;

// 判斷 區間低點不破 且 區間高點 \<= 區間振幅

IF Condition1 and Condition2

// 判斷 收盤價 由下往上穿過 區間高點

and Close Crosses Over Highest(Close\[1\], Period)

Then Ret=1;

Outputfield1(Value1, 2, \"前波低點\");

Outputfield2(Highest(High\[1\], Period), 2, \"前波高點\");

## 場景 126：可能要上櫃轉上市的交易策略 --- 用這些選股條件選出的上櫃股票，再加上暴量起漲這個進場時機的腳本：

> 來源：[[可能要上櫃轉上市的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e5%8f%af%e8%83%bd%e8%a6%81%e4%b8%8a%e6%ab%83%e8%bd%89%e4%b8%8a%e5%b8%82%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：用這些選股條件選出的上櫃股票，再加上暴量起漲這個進場時機的腳本：

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 127：毛利率大增的中小型低價股出量起漲 --- 所以我才加上暴量剛起漲這個策略，在這些股票價量創20日新高時才進場。

> 來源：[[毛利率大增的中小型低價股出量起漲]{.underline}](https://www.xq.com.tw/xstrader/%e6%af%9b%e5%88%a9%e7%8e%87%e5%a4%a7%e5%a2%9e%e7%9a%84%e4%b8%ad%e5%b0%8f%e5%9e%8b%e4%bd%8e%e5%83%b9%e8%82%a1%e5%87%ba%e9%87%8f%e8%b5%b7%e6%bc%b2/)
> 說明：所以我才加上暴量剛起漲這個策略，在這些股票價量創20日新高時才進場。

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 128：抓住法說行情的先知者：關鍵券商買賣超 + 新聞分數 --- XS 選股代碼》法說會前關鍵券商布局

> 來源：[[抓住法說行情的先知者：關鍵券商買賣超 +
> 新聞分數]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%93%e4%bd%8f%e6%b3%95%e8%aa%aa%e8%a1%8c%e6%83%85%e7%9a%84%e5%85%88%e7%9f%a5%e8%80%85/)
> 說明：XS 選股代碼》法說會前關鍵券商布局

// \*\*\*\*\* 法說會前關鍵券商布局 \*\*\*\*\*

Input: MaxDate(10, \"發生剩餘日(最多)\");

Input: MinDate(2, \"發生剩餘日(最少)\");

Input: Ratio(5, \"近日關鍵券商量比\");

Input: Count(1, \"近日發生正向新聞次數\");

Input: Period(10, \"近日期數\");

// \-\-\-\-- 判斷條件 \-\-\-\--

// 判斷 法說會即將發生

Condition1 = DateDiff(GetField(\"法說會日期\"), Date) \<= MaxDate and
DateDiff(GetField(\"法說會日期\"), Date) \>= MinDate;

// 判斷 關鍵券商量比最大值 \>= 5

Condition2 = FastHighest((GetField(\"關鍵券商買賣超張數\") /
(GetField(\"成交量\") - GetField(\"當日沖銷張數\")) \* 100), Period) \>=
Ratio;

// 判斷 正向新聞至少出現一次

Condition3 = CountIf(GetField(\"新聞正向分數\") \>= 1, Period) \>=
Count;

// \-\-\-\-- 符合全部條件執行選股 \-\-\-\--

IF Condition1 and Condition2 and Condition3

Then Ret = 1;

## 場景 129：用 " 官股券商買賣超 " 判斷大型權值股的進場點，勝率高達 70%？ --- XS 指標代碼》官股護盤指標

> 來源：[[用 " 官股券商買賣超 " 判斷大型權值股的進場點，勝率高達
> 70%？]{.underline}](https://www.xq.com.tw/xstrader/%e7%94%a8%e5%ae%98%e8%82%a1%e5%88%b8%e5%95%86%e8%b2%b7%e8%b3%a3%e8%b6%85%e5%88%a4%e6%96%b7%e5%a4%a7%e5%9e%8b%e6%ac%8a%e5%80%bc%e8%82%a1%e7%9a%84%e9%80%b2%e5%a0%b4%e9%bb%9e/)
> 說明：XS 指標代碼》官股護盤指標

// \*\*\*\*\* 官股護盤指標 \*\*\*\*\*

Input: Length(5, \"計算期數\");

// 計算 近期官股券商買進金額占市值比

Value1 = Summation(GetField(\"官股券商買進金額\"), Length) /
Summation(GetSymbolField(\"TSE.TW\", \"總市值(元)\"), Length) ;

// 計算 近期漲跌幅

Value2 = (GetSymbolField(\"TSE.TW\", \"總市值(元)\") -
GetSymbolField(\"TSE.TW\", \"總市值(元)\")\[Length\]) /
GetSymbolField(\"TSE.TW\", \"總市值(元)\")\[Length\];

// 判斷 近期官股券商買進金額占市值比 與 近期漲跌幅 的關聯係數

Value3 = Value2 / Value1;

IF Value3 \> 0

Then Plot1(Value3, \"關聯係數\");

// 計算 關聯係數標準差

Value4 = BollingerBand(Value3, 240, 2);

// 判斷 護盤點

IF Value3 \>= Value4

// 判斷 240MA 趨勢向下

and Average(Close, 240) \< Average(Close, 240)\[1\]

Then Begin

// 畫出 護盤點

Plot2(Value3, \"關聯係數(護盤)\");

// 畫出 進場訊號

Plot4(Value4, \"進場訊號\");

End;

// 畫出 關聯係數標準差

Plot3(Value4, \"關聯係數標準差\");

## 場景 130：用 " 官股券商買賣超 " 判斷大型權值股的進場點，勝率高達 70%？ --- XS 選股代碼》官股護盤時機點

> 來源：[[用 " 官股券商買賣超 " 判斷大型權值股的進場點，勝率高達
> 70%？]{.underline}](https://www.xq.com.tw/xstrader/%e7%94%a8%e5%ae%98%e8%82%a1%e5%88%b8%e5%95%86%e8%b2%b7%e8%b3%a3%e8%b6%85%e5%88%a4%e6%96%b7%e5%a4%a7%e5%9e%8b%e6%ac%8a%e5%80%bc%e8%82%a1%e7%9a%84%e9%80%b2%e5%a0%b4%e9%bb%9e/)
> 說明：XS 選股代碼》官股護盤時機點

// \*\*\*\*\* 官股護盤時機點 \*\*\*\*\*

Input: Length(5, \"計算期數\");

// 計算 近期官股券商買進金額占市值比

Value1 = Summation(GetSymbolField(\"TSE.TW\", \"官股券商買賣超張數\"),
Length) / Summation(GetSymbolField(\"TSE.TW\", \"成交量\"), Length) ;

// 計算 近期漲跌幅

Value2 = (GetSymbolField(\"TSE.TW\", \"總市值(元)\") -
GetSymbolField(\"TSE.TW\", \"總市值(元)\")\[Length\]) /
GetSymbolField(\"TSE.TW\", \"總市值(元)\")\[Length\];

// 判斷 近期官股券商買進金額占市值比 與 近期漲跌幅 的關聯係數

Value3 = Value2 / Value1;

// 計算 關聯係數標準差

Value4 = BollingerBand(Value3, 240, 2);

// 判斷 護盤點

IF Value3 \>= Value4

Then Ret = 1;

## 場景 131：利用台幣貶值找出受惠族群 (內附選股條件)

> 來源：[[利用台幣貶值找出受惠族群
> (內附選股條件)]{.underline}](https://www.xq.com.tw/xstrader/%e5%88%a9%e7%94%a8%e5%8f%b0%e5%b9%a3%e8%b2%b6%e5%80%bc%e6%89%be%e5%87%ba%e5%8f%97%e6%83%a0%e6%97%8f/)
> 說明：▼ 台幣貶值

// \*\*\*\*\* 台幣貶值 \*\*\*\*\*

Input: ShortLength(5, \"短期數\");

Input: LongLength(22, \"長期數\");

Condition1 = Average(GetSymbolField(\"TPFI.TW\", \"收盤價\", \"D\"),
ShortLength)

\> Average(GetSymbolField(\"TPFI.TW\", \"收盤價\", \"D\"), LongLength);

IF Condition1

Then Ret = 1;

## 場景 132：利用台幣貶值找出受惠族群 (內附選股條件) --- ▼ 市場產品力強 (推銷和管理費用成長率 \< 營收成長率)

> 來源：[[利用台幣貶值找出受惠族群
> (內附選股條件)]{.underline}](https://www.xq.com.tw/xstrader/%e5%88%a9%e7%94%a8%e5%8f%b0%e5%b9%a3%e8%b2%b6%e5%80%bc%e6%89%be%e5%87%ba%e5%8f%97%e6%83%a0%e6%97%8f/)
> 說明：▼ 市場產品力強 (推銷和管理費用成長率 \< 營收成長率)

// \*\*\*\*\* 市場產品力強 \*\*\*\*\*

// 判斷 推銷費用成長率 \< 營收成長率

Condition1 = (GetField(\"推銷費用\", \"Q\")\[0\] -
GetField(\"推銷費用\", \"Q\")\[1\]) / GetField(\"推銷費用\", \"Q\")\[1\]
\* 100

\< GetField(\"營收成長率\", \"Q\");

// 判斷 管理費用成長率 \< 營收成長率

Condition2 = (GetField(\"管理費用\", \"Q\")\[0\] -
GetField(\"管理費用\", \"Q\")\[1\]) / GetField(\"管理費用\", \"Q\")\[1\]
\* 100

\< GetField(\"營收成長率\", \"Q\");

IF Condition1 and Condition2

Then Ret = 1;

OutputField1(GetField(\"營收成長率\", \"Q\"), 2, \"營收成長率\");

OutputField2((GetField(\"推銷費用\", \"Q\")\[0\] -
GetField(\"推銷費用\", \"Q\")\[1\]) / GetField(\"推銷費用\", \"Q\")\[1\]
\* 100, 2, \"推銷費用成長率\");

OutputField3((GetField(\"管理費用\", \"Q\")\[0\] -
GetField(\"管理費用\", \"Q\")\[1\]) / GetField(\"管理費用\", \"Q\")\[1\]
\* 100, 2, \"管理費用成長率\");

## 場景 133：利用台幣貶值找出受惠族群 (內附選股條件) --- ▼ 應收帳款管理力 (應收帳款周轉天數 \< 90天)

> 來源：[[利用台幣貶值找出受惠族群
> (內附選股條件)]{.underline}](https://www.xq.com.tw/xstrader/%e5%88%a9%e7%94%a8%e5%8f%b0%e5%b9%a3%e8%b2%b6%e5%80%bc%e6%89%be%e5%87%ba%e5%8f%97%e6%83%a0%e6%97%8f/)
> 說明：▼ 應收帳款管理力 (應收帳款周轉天數 \< 90天)

// \*\*\*\*\* 應收帳款管理力 \*\*\*\*\*

IF GetField(\"應收帳款及票據\", \"Q\") / GetField(\"營業收入淨額\",
\"Q\") \* 90 \<= 90

Then Ret = 1;

## 場景 134：利用黃金切割率進行股票強度的判斷 --- 我們先提供一串語法代表 黃金切割率的進階應用給予參考。

> 來源：[[利用黃金切割率進行股票強度的判斷]{.underline}](https://www.xq.com.tw/xstrader/%e5%88%a9%e7%94%a8%e9%bb%83%e9%87%91%e5%88%87%e5%89%b2%e7%8e%87%e9%80%b2%e8%a1%8c%e8%82%a1%e7%a5%a8%e5%bc%b7%e5%ba%a6%e7%9a%84%e5%88%a4%e6%96%b7/)
> 說明：我們先提供一串語法代表 黃金切割率的進階應用給予參考。

input:length(120,\"高低點區間近N日\"),days(20,\"基準日\");

settotalbar(1);

value1=highest(H\[days\],length);

value2=lowest(L\[days\],length);

value3=0.236\*value2+0.764\*value1;

value4=0.382\*value2+0.618\*value1;

outputfield1(100\*(C/value1-1),\"距離高點差%\");

outputfield2(100\*(C/value2-1),\"距離低點差%\");

outputfield3(100\*(C/value3-1),\"距離0.236差%\");

outputfield4(100\*(C/value4-1),\"距離0.382差%\");

outputfield5(value1,\"基準日前最高價\");

ret=1;

## 場景 135：XS進階應用-財報公布日期的取用說明 --- 小編在這邊分享一個應用範例，如下：

> 來源：[[XS進階應用-財報公布日期的取用說明]{.underline}](https://www.xq.com.tw/xstrader/xs%e9%80%b2%e9%9a%8e%e6%87%89%e7%94%a8-%e8%b2%a1%e5%a0%b1%e5%85%ac%e5%b8%83%e6%97%a5%e6%9c%9f%e7%9a%84%e5%8f%96%e7%94%a8%e8%aa%aa%e6%98%8e/)
> 說明：小編在這邊分享一個應用範例，如下：

SetBarFreq(\"d\"); //僅限日頻率

input:days(1,\"幾日內更新\");

var:i(0);

settotalBar(days+1);

value1 = GetFieldDate(\"營業毛利率\",\"q\");

if value1 = 0 then return; //過濾沒資料或資料尚未轉檔完畢

for i = days downTo 1

begin

if value1\<\>value1\[i\] then begin

ret = 1;

value2 = i-1;

value3 = GetField(\"Date\",\"D\")\[i-1\];

end;

end;

outputField1(value2,\"幾日前更新\");

outputField2(value3,\"毛利率更新日\");

outputField3(month(value1),\"毛利率期別\");

## 場景 136：尋找今年上半年，賺贏去年一整年的個股

> 來源：[[尋找今年上半年，賺贏去年一整年的個股]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e4%bb%8a%e5%b9%b4%e4%b8%8a%e5%8d%8a%e5%b9%b4%ef%bc%8c%e8%b3%ba%e8%b4%8f%e5%8e%bb%e5%b9%b4%e4%b8%80%e6%95%b4%e5%b9%b4%e7%9a%84%e5%80%8b%e8%82%a1%e3%80%82/)
> 說明：程式碼如下：

value1=GetField(\"每股稅後淨利(元)\",\"Q\");

value2=GetFieldDate(\"每股稅後淨利(元)\",\"Q\"); //抓季報資料時間

condition1=GetField(\"營業利益率\", \"Q\")\>GetField(\"營業利益率\",
\"Y\")\*1.5;

condition2=GetField(\"營業毛利率\", \"Q\")\>GetField(\"營業毛利率\",
\"Y\")\*1.5;

//if
(value1+value1\[1\])\>(value1\[2\]+value1\[3\]+value1\[4\]+value1\[5\])
and value1\>0 then ret=1;

ret= (value1+value1\[1\])\>GetField(\"每股稅後淨利(元)\",\"Y\")

and value1\>0 and GetField(\"每股稅後淨利(元)\",\"Y\")\>0

and condition1 and condition2;

outputfield1(value1,\"最新EPS\");

outputfield2(value1+value1\[1\],\"半年EPS\");

outputfield3(GetField(\"每股稅後淨利(元)\",\"Y\"),\"去年EPS\");

outputfield4(GetField(\"營業利益率\", \"Q\"),\"最新營業利益率\");

outputfield5(GetField(\"營業利益率\", \"Y\"),\"去年營業利益率\");

outputfield6(GetField(\"營業毛利率\", \"Q\"),\"最新毛利率\");

outputfield7(GetField(\"營業毛利率\", \"Y\"),\"去年毛利率\");

## 場景 137：挖掘季報驚豔潛力股 --- 綜合以上所述，程式碼如下：

> 來源：[[挖掘季報驚豔潛力股]{.underline}](https://www.xq.com.tw/xstrader/%e6%8c%96%e6%8e%98%e5%ad%a3%e5%a0%b1%e9%a9%9a%e8%b1%94%e6%bd%9b%e5%8a%9b%e8%82%a1/)
> 說明：綜合以上所述，程式碼如下：

value1=GetField(\"月營收年增率\",\"M\");

value2=GetField(\"累計營收年增率\",\"M\");

//月營收年增率/累計營收年增率 每月都\>0 且 月月增

condition1=value1\>value1\[1\] and value1\[1\]\>value1\[2\]

and value1\>0 and value1\[1\]\>0 and value1\[2\]\>0;

condition2=value2\>value2\[1\] and value2\[1\]\>value2\[2\]

and value2\>0 and value2\[1\]\>0 and value2\[2\]\>0;

condition3=GetField(\"營業利益率\",\"Q\")\>GetField(\"營業利益率\",\"Q\")\[1\]

and GetField(\"營業利益率\",\"Q\")\>0;

{and
GetField(\"營業利益率\",\"Q\")\[1\]\>GetField(\"營業利益率\",\"Q\")\[2\]}

ret=condition1 and condition2 and condition3;

outputfield1(GetField(\"營業利益率\",\"Q\"),\"本次營益率\");

outputfield2(GetField(\"營業利益率\",\"Q\")\[1\],\"上次營益率\");

//outputfield3(GetField(\"營業利益率\",\"Q\")\[2\],\"上上次營益率\");

outputfield4(value1,\"MOM\");

outputfield5(value1\[1\],\"MOM\[1\]\");

outputfield6(value1\[2\],\"MOM\[2\]\");

outputfield7(value2,\"YOY\");

outputfield8(value2\[1\],\"YOY\[1\]\");

outputfield9(value2\[2\],\"YOY\[2\]\");

## 場景 138：如何結合選股中心 與 量化積木 進行全雲端監控 --- 營業利益率負轉正程式碼：

> 來源：[[如何結合選股中心 與 量化積木
> 進行全雲端監控]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e7%b5%90%e5%90%88%e9%81%b8%e8%82%a1%e4%b8%ad%e5%bf%83-%e8%88%87-%e9%87%8f%e5%8c%96%e7%a9%8d%e6%9c%a8-%e9%80%b2%e8%a1%8c%e5%85%a8%e9%9b%b2%e7%ab%af%e7%9b%a3%e6%8e%a7/)
> 說明：營業利益率負轉正程式碼：

value1=GetField(\"營業利益率\",\"Q\");

value2=GetField(\"每股稅後淨利(元)\",\"Q\");

ret= value1\>=0 and value1\[1\]\<0;

outputfield1(value1,\" 最新營益率% \");

outputfield2(value1\[1\],\" 上一期營益率% \");

outputfield3(value2,\" 最新EPS \");

outputfield4(value2\[1\],\" 上一期EPS \");

## 場景 139：找尋強勢股籌碼又集中的股票

> 來源：[[找尋強勢股籌碼又集中的股票]{.underline}](https://www.xq.com.tw/xstrader/%e6%89%be%e5%b0%8b%e5%bc%b7%e5%8b%a2%e8%82%a1%e7%b1%8c%e7%a2%bc%e5%8f%88%e9%9b%86%e4%b8%ad%e7%9a%84%e8%82%a1%e7%a5%a8/)
> 說明：大盤濾網腳本如下：

settotalbar(30);

input:days(10,\"均線天數\");

value1=GetSymbolField(\"TSE.TW\",\"收盤價\",\"D\");

if value1\>average(value1,days) then ret=1;

outputfield1(value1,\"大盤\");

outputfield2(average(value1,days),\"大盤均線\");

## 場景 140：找尋強勢股籌碼又集中的股票 --- 籌碼集中度選股腳本如下：

> 來源：[[找尋強勢股籌碼又集中的股票]{.underline}](https://www.xq.com.tw/xstrader/%e6%89%be%e5%b0%8b%e5%bc%b7%e5%8b%a2%e8%82%a1%e7%b1%8c%e7%a2%bc%e5%8f%88%e9%9b%86%e4%b8%ad%e7%9a%84%e8%82%a1%e7%a5%a8/)
> 說明：籌碼集中度選股腳本如下：

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

value2=GetField(\"地緣券商買賣超張數\",\"D\");

value3=GetField(\"外資買賣超\",\"D\");

value4=GetField(\"投信買賣超\",\"D\");

value5=GetField(\"自營商自行買賣買賣超\",\"D\");

value6=GetField(\"綜合前十大券商買賣超張數\",\"D\");

if volume\<\>0 then

value7=(value1+value2+value3+value4+value5+value6)/volume\*100;

input:period(3,\"計算天數\");

input:ratio(10,\"籌碼集中度下限\");

value8=average(value7,period);

if value8\>=ratio

and volume\>2000

then ret=1;

outputfield(1,value1,0,\"關鍵券商\");

outputfield(2,value2,0,\"地緣券商\");

outputfield(3,value3,0,\"外資\");

outputField(4,value4,0,\"投信\");

outputField(5,value5,0,\"自營商\");

outputField(6,value6,0,\"前十大券商\");

outputfield(7,value7,0,\"當日籌碼集中度\");

outputfield(8,value8,0,\"區間平均籌碼集中度\");

## 場景 141：融券回補日前主力大戶蠢蠢欲動 --- 1.10日\<融券最後回補日\<60日2.3日主力買超數量總計\>3日總量\*0.083.融券餘額張數創5日新高4.融券使用率創5日新高5.今收盤價創5日新高+實體紅K\...

> 來源：[[融券回補日前主力大戶蠢蠢欲動]{.underline}](https://www.xq.com.tw/xstrader/20100-2/)
> 說明：1.10日\<融券最後回補日\<60日2.3日主力買超數量總計\>3日總量\*0.083.融券餘額張數創5日新高4.融券使用率創5日新高5.今收盤價創5日新高+實體紅K棒(漲幅\>3%的紅K+上引線比例\<1%)6.大盤指數在均線之上

Condition1=trueall(V\>500,5);

// 融券最後回補日距今\<60日 且 至少還有10日(大於)

Condition2=DateDiff(GetField(\"融券最後回補日\"), Date)\<60

and DateDiff(GetField(\"融券最後回補日\"), Date)\>10;

// 3日主力買超數量總計\>3日量和\*0.08

Condition3=summation(GetField(\"主力買賣超張數\",\"D\"),3)\>0.08\*summation(V,3);

// 融券餘額張數創5日新高

Condition4=GetField(\"融券餘額張數\",\"D\")=Highest(GetField(\"融券餘額張數\",\"D\"),5);

// 融券使用率創5日新高

Condition5=GetField(\"融券使用率\",\"D\")=Highest(GetField(\"融券使用率\",\"D\"),5);

// 今收盤價創5日新高+實體紅K棒(漲幅\>3%的紅K+上引線比例\<1%)

Condition6=C\>Highest(H\[1\],5) and (C-O)/O\>0.03 and (H-C)/C\<0.01;

// 大盤指數在均線之上

Condition101=GetSymbolField(\"TSE.TW\",\"收盤價\")\>average(GetSymbolField(\"TSE.TW\",\"收盤價\"),5);

Condition100=Condition1 and Condition2 and Condition3 and Condition4 and
Condition6 and Condition101;

// 篩選

If Condition100 Then Ret=1;

## 場景 142：挑選特定日期以來，漲幅不大但主力昨日買超 --- 我們把策略名稱稱為：「挑選特定日期以來，漲幅不大但主力昨日買超」，以這個策略為例，我們將特定日期放在指數創新高那天(20230615)，特定日期漲幅不大的語法如\...

> 來源：[[挑選特定日期以來，漲幅不大但主力昨日買超]{.underline}](https://www.xq.com.tw/xstrader/2023062801-2/)
> 說明：我們把策略名稱稱為：「挑選特定日期以來，漲幅不大但主力昨日買超」，以這個策略為例，我們將特定日期放在指數創新高那天(20230615)，特定日期漲幅不大的語法如下：

value1=getbarOffset(20230615); //算出最高點距離現在多少根K棒

value2=c\[value1\]; //找到最高點當日收盤價

if value2\<\>0 then

value3=(c-value2)/value2\*100;

input:ratio(6,\"波段跌幅上限\");

if value3\<ratio and value3\>-5 then ret=1;

outputField1(value3,\"波段漲幅\");

## 場景 143：GVI指標低檔回升

> 來源：[[GVI指標低檔回升]{.underline}](https://www.xq.com.tw/xstrader/gvi%e6%8c%87%e6%a8%99%e4%bd%8e%e6%aa%94%e5%9b%9e%e5%8d%87/)
> 說明：我寫的腳本如下

value1=GetField(\"股價淨值比\",\"D\");

value2=GetField(\"股東權益報酬率\",\"Q\");

var:GVI(0);

GVI=1/value1\*(1+value2)\*(1+value2)\*(1+value2)\*(1+value2)\*(1+value2);

if gvi cross over 1.1

then ret=1;

## 場景 144：CMI市場波動指標轉強股

> 來源：[[CMI市場波動指標轉強股]{.underline}](https://www.xq.com.tw/xstrader/cmi%e5%b8%82%e5%a0%b4%e6%b3%a2%e5%8b%95%e6%8c%87%e6%a8%99%e8%bd%89%e5%bc%b7%e8%82%a1/)
> 說明：這個策略的腳本如下

Input:Period(10);

Input:TSELen(6);

Var:CMI(0),AvgCMI(0);

// 計算

CMI=100\*(C-C\[Period-1\])/(Highest(H,Period)-Lowest(L,Period));

AvgCMI=average(CMI,6);

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 選股條件

// 大盤趨勢向上且非KY股

Condition1=CCT_TSE_Trend(TSELen)=1 and rightstr(symbolname,2)\<\>\"KY\";

// CMI趨勢向上

Condition2=trueall(CMI\>=65,3) and AvgCMI\>=81 and Bias(7)\<4;

// 個股條件

Condition100=Condition1 and Condition2;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 選股條件

// 均成交金額\>0.35E

Condition101=Average(GetField(\"成交金額(億)\",\"D\"),5)\>=0.35;

// 個股條件(籌碼相關)

Condition200=Condition101;

// 篩選

If Condition100 and Condition101 Then

Ret=1;

## 場景 145：大股東站在買方的績優成長股 --- 其中大股東站在買方的腳本如下

> 來源：[[大股東站在買方的績優成長股]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%82%a1%e6%9d%b1%e7%ab%99%e5%9c%a8%e8%b2%b7%e6%96%b9%e7%9a%84%e7%b8%be%e5%84%aa%e6%88%90%e9%95%b7%e8%82%a1/)
> 說明：其中大股東站在買方的腳本如下

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

value2=getField(\"關聯券商買賣超張數\", \"D\");

value3=getField(\"地緣券商買賣超張數\", \"D\");

if GetField(\"內部人持股比例\",\"M\")

\>GetField(\"內部人持股比例\",\"M\")\[1\]

or GetField(\"大戶持股比例\",\"W\",param := 1000)

\>GetField(\"大戶持股比例\",\"W\",param := 1000)\[1\]+0.5

or value1\>=500

or value2\>500

or value3\>500

then ret=1;

outputfield(1,GetField(\"內部人持股比例\",\"M\"),0,\"內部人\");

outputfield(2,GetField(\"內部人持股比例\",\"M\")\[1\],0,\"前期內部人\");

outputfield(3,value1,0,\"關鍵券商\");

outputfield(4,GetField(\"大戶持股比例\",\"W\",param :=
1000),1,\"千張大戶比例\");

outputfield(5,GetField(\"大戶持股比例\",\"W\",param :=
1000)\[1\],1,\"前期千張大戶比例\");

## 場景 146：下切線突破搭配主力買超

> 來源：[[下切線突破搭配主力買超]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%8b%e5%88%87%e7%b7%9a%e7%aa%81%e7%a0%b4/)
> 說明：下切線突破的腳本如下

input:in1(60,\"計算區間\"),in2(false,\"嚴格模式\");

settotalBar(in1\*2);

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

if condition3\[1\] and not condition3

and

(getField(\"投信買賣超\", \"D\")\>0

or getField(\"外資買賣超\", \"D\")\>0)

then ret=1;

## 場景 147：三次到頂而破 --- 三次到頂這個條件的腳本如下

> 來源：[[三次到頂而破]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%89%e6%ac%a1%e5%88%b0%e9%a0%82%e8%80%8c%e7%a0%b4/)
> 說明：三次到頂這個條件的腳本如下

variable:i(0),j(0),j1(0),BP(0);

value1=average(H,10);//求出高10日均線作為趨勢線

value2=value1-value1\[1\];//求出高10日均線的切線斜率

condition1 = value2\>0;//條件一為趨勢成長

condition2 = trueall(condition1,15);//條件二為15日連續成長

condition3 = trueall(not condition1,20);

//條件三為20日連續下跌作為離開上漲波段判斷

if condition1 and not condition1\[1\] and not condition4 then value3 =0;

//如果終止一段漲幅且未進入第一次下轉區則重設關鍵價

if condition3

then begin

value3=0;

condition4=false;

condition5=false;

end;

//如果連續下跌則離開第一次下轉區不予進場並重設關鍵價

if value1 crosses under value4 and condition4

then begin

condition5=true;

end;

//如果10日均線跌破關鍵價則進入平行整理區

if condition1 and not condition5

then begin

if H\>value3

then begin

value3=H;

value4=(L+H)/2;

end;

end;

//設在成長期間的最高點的高低價平均為關鍵價

if condition2\[1\] and not condition2

then begin

condition4=true;

condition5=false;

end;

//如果停止連續成長則進入第一次下轉區

if value1 crosses over value4 and condition5 and condition4

then begin

condition5=false;

condition4=false;

ret=1;

end;

//如果收盤價突破平行整理區則進場

## 場景 148：PB跌到歷年低點區且低於0.8 --- 一，PB跌到歷史低點區且低於0.8

> 來源：[[PB跌到歷年低點區且低於0.8]{.underline}](https://www.xq.com.tw/xstrader/pb%e8%b7%8c%e5%88%b0%e6%ad%b7%e5%b9%b4%e4%bd%8e%e9%bb%9e%e5%8d%80%e4%b8%94%e4%bd%8e%e6%96%bc0-8/)
> 說明：一，PB跌到歷史低點區且低於0.8

value1=GetField(\"股價淨值比\",\"Y\");

value2=lowest(value1,4);

if value1\<value2\*1.3 and value1\<=0.8

then ret=1;

outputfield(1, GetField(\"股價淨值比\",\"Y\"),2, \"PB比\", order := -1);

## 場景 149：PB跌到歷年低點區且低於0.8 --- 二，流動資產減流動負債超過市值N成

> 來源：[[PB跌到歷年低點區且低於0.8]{.underline}](https://www.xq.com.tw/xstrader/pb%e8%b7%8c%e5%88%b0%e6%ad%b7%e5%b9%b4%e4%bd%8e%e9%bb%9e%e5%8d%80%e4%b8%94%e4%bd%8e%e6%96%bc0-8/)
> 說明：二，流動資產減流動負債超過市值N成

input:ratio(80,\"佔總市值百分比%\");

if
(GetField(\"流動資產\",\"Q\")-GetField(\"負債總額\",\"Q\"))\*100\>GetField(\"總市值\",\"D\")\*ratio/100

then ret=1;

## 場景 150：PB跌到歷年低點區且低於0.8

> 來源：[[PB跌到歷年低點區且低於0.8]{.underline}](https://www.xq.com.tw/xstrader/pb%e8%b7%8c%e5%88%b0%e6%ad%b7%e5%b9%b4%e4%bd%8e%e9%bb%9e%e5%8d%80%e4%b8%94%e4%bd%8e%e6%96%bc0-8/)
> 說明：三，無量變有量

input:v1(1000,\"前一期成交量\");

input:v2(1000,\"最新期成交量\");

if trueall(volume\[1\]\<=v1,10) and volume\>v2

then ret=1;

## 場景 151：股價低於目標價 --- 我根據上述的概念，寫了一個選股腳本如下

> 來源：[[股價低於目標價]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e7%9b%ae%e6%a8%99%e5%83%b9/)
> 說明：我根據上述的概念，寫了一個選股腳本如下

//獲利穩定股目標價計算方法

value1=GetField(\"每股稅後淨利(元)\",\"Q\");

value2=summation(value1,4);

//最近四季的EPS總和

value3=highest(value2,20);

//過去20季以來四季EPS總和的最高值

value4=lowest(value2,20);

//過去20季以來四季EPS總和的最低值

value5=average(value2,20);

var:tp(0);//目標價

if value4\>1

//連續四季合計的EPS在過去20季都大於1元

and value3-value4\<3

//四季合計的EPS近20季以來最高與最低EPS差1.5元以內

then

tp=8\*value5;

input:discount(30,\"折價率\");

if close\*(1+discount/100)\<tp then ret=1;

//目標價與市價差30%以上

outputfield(1,tp,0,\"目標價\");

outputfield(2,(tp-close)/close\*100,1,\"預期報酬率\");

## 場景 152：股價遠低於十年股利加淨值 --- 根據這樣的想法，我寫了以下的腳本，來找出目前股價遠低於十年股利加淨值的公司

> 來源：[[股價遠低於十年股利加淨值]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e9%81%a0%e4%bd%8e%e6%96%bc%e5%8d%81%e5%b9%b4%e8%82%a1%e5%88%a9%e5%8a%a0%e6%b7%a8%e5%80%bc/)
> 說明：根據這樣的想法，我寫了以下的腳本，來找出目前股價遠低於十年股利加淨值的公司

value1=(getField("股利合計", "Y")

+getField("股利合計", "Y")\[1\]

+getField("股利合計", "Y")\[2\]

+getField("股利合計", "Y")\[3\]

+getField("股利合計", "Y")\[4\]

+getField("股利合計", "Y")\[5\]

+getField("股利合計", "Y")\[6\]

+getField("股利合計", "Y")\[7\]

+getField("股利合計", "Y")\[8\]

+getField("股利合計", "Y")\[9\])/10;

## 場景 153：股價遠低於十年股利加淨值 --- value1=(getField("股利合計", "Y")+getField("股利合計", "Y")\[1\]+getField("股利合計", "Y")\[2\]+\...

> 來源：[[股價遠低於十年股利加淨值]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e9%81%a0%e4%bd%8e%e6%96%bc%e5%8d%81%e5%b9%b4%e8%82%a1%e5%88%a9%e5%8a%a0%e6%b7%a8%e5%80%bc/)
> 說明：value1=(getField("股利合計", "Y")+getField("股利合計",
> "Y")\[1\]+getField("股利合計", "Y")\[2\]+getField("股利合計",
> "Y")\[3\]+getField("股利合計", "Y")\[4\]+getField("股利合計",
> "Y")\[5\]+getField("股利合計", "Y")\[6\]+getField("股利合計", "Y"\...

value2=value1+getField("每股淨值(元)", "Q");

var:pg("");

input:ratio(20,"折價率");

if close\*(1+ratio/100)\< value2

then ret=1;

outputfield(1,close/value2,2,"折價率");

## 場景 154：股價在五年平均總市值以下的績優股

> 來源：[[股價在五年平均總市值以下的績優股]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e5%9c%a8%e4%ba%94%e5%b9%b4%e5%b9%b3%e5%9d%87%e7%b8%bd%e5%b8%82%e5%80%bc%e4%bb%a5%e4%b8%8b%e7%9a%84%e7%b8%be%e5%84%aa%e8%82%a1/)
> 說明：其中用到的腳本如下：

value1=(GetField(\"總市值(億)\",\"Y\")+GetField(\"總市值(億)\",\"Y\")\[1\]+

GetField(\"總市值(億)\",\"Y\")\[2\]+GetField(\"總市值(億)\",\"Y\")\[3\]+

GetField(\"總市值(億)\",\"Y\")\[4\])/5;

value2=GetField(\"總市值(億)\",\"D\");

input:ratio(40,\"低於平均市值的最低幅度\");

if (value1/value2-1)\*100\>ratio then ret=1;

outputfield(1,(value1/value2-1)\*100,0,\"低於平均市值的幅度\");

## 場景 155：十年現金流量總和遠超過總市值 --- 其中十年現金流量總和遠高過總市值的腳本如下

> 來源：[[十年現金流量總和遠超過總市值]{.underline}](https://www.xq.com.tw/xstrader/%e5%8d%81%e5%b9%b4%e7%8f%be%e9%87%91%e6%b5%81%e9%87%8f%e7%b8%bd%e5%92%8c%e9%81%a0%e8%b6%85%e9%81%8e%e7%b8%bd%e5%b8%82%e5%80%bc/)
> 說明：其中十年現金流量總和遠高過總市值的腳本如下

value1=getField(\"來自營運之現金流量\",
\"Y\")+getField(\"來自營運之現金流量\", \"Y\")\[1\]

+getField(\"來自營運之現金流量\",
\"Y\")\[2\]+getField(\"來自營運之現金流量\", \"Y\")\[3\]

+getField(\"來自營運之現金流量\",
\"Y\")\[4\]+getField(\"來自營運之現金流量\", \"Y\")\[5\]

+getField(\"來自營運之現金流量\",
\"Y\")\[6\]+getField(\"來自營運之現金流量\", \"Y\")\[7\]

+getField(\"來自營運之現金流量\",
\"Y\")\[8\]+getField(\"來自營運之現金流量\", \"Y\")\[9\];

//過去十年來自營運之現金流量總和,單位百萬

value2=getField(\"總市值(億)\", \"D\");

input:ratio(65,\"折價比例\");

if (value1/100)/value2\>=(1+ratio/100)

then ret=1;

outputfield(1,value1/100,0,\"十年營運現金流總和(億)\");

outputfield(2,value2,0,\"總市值(億)\");

outputfield(3,(value1/100)/value2,2,\"佔比\");

## 場景 156：股價低於十年股價低點平均值且籌碼被收集中 --- 其中股價低於10年低點平均值的腳本如下

> 來源：[[股價低於十年股價低點平均值且籌碼被收集中]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e5%8d%81%e5%b9%b4%e8%82%a1%e5%83%b9%e4%bd%8e%e9%bb%9e%e5%b9%b3%e5%9d%87%e5%80%bc%e4%b8%94%e7%b1%8c%e7%a2%bc%e8%a2%ab%e6%94%b6%e9%9b%86%e4%b8%ad/)
> 說明：其中股價低於10年低點平均值的腳本如下

value1=(lowY(1)+lowY(2)+lowY(3)+lowY(4)+lowY(5)

+lowY(6)+lowY(7)+lowY(8)+lowY(9)+lowY(10))/10;

if close\<value1

then ret=1;

## 場景 157：股價低於十年股價低點平均值且籌碼被收集中 --- 另一個籌碼收集的腳本則如下

> 來源：[[股價低於十年股價低點平均值且籌碼被收集中]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e5%8d%81%e5%b9%b4%e8%82%a1%e5%83%b9%e4%bd%8e%e9%bb%9e%e5%b9%b3%e5%9d%87%e5%80%bc%e4%b8%94%e7%b1%8c%e7%a2%bc%e8%a2%ab%e6%94%b6%e9%9b%86%e4%b8%ad/)
> 說明：另一個籌碼收集的腳本則如下

value1=GetField(\"分公司買進家數\");

value2=GetField(\"分公司賣出家數\");

value3=value2-value1;

value4=countif(value3\>30,5);

//計算買進家數與賣出家數的差距夠大的天數

if value4\>3

then ret=1;

## 場景 158：股價低於10年低點平均值且主力買超 --- 其中股價低於10年低點平均值的腳本如下

> 來源：[[股價低於10年低點平均值且主力買超]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc10%e5%b9%b4%e4%bd%8e%e9%bb%9e%e5%b9%b3%e5%9d%87%e5%80%bc%e4%b8%94%e4%b8%bb%e5%8a%9b%e8%b2%b7%e8%b6%85-2/)
> 說明：其中股價低於10年低點平均值的腳本如下

value1=(lowY(1)+lowY(2)+lowY(3)+lowY(4)+lowY(5)

+lowY(6)+lowY(7)+lowY(8)+lowY(9)+lowY(10))/10;

if close\<value1

then ret=1;

## 場景 159：找尋創特定日期新高的股票 --- 那麼，要如何找出這些股票呢？首先，我們先找出最高點出現的日期，根據大盤技術分析圖表，今年6月15號指數創了新高。接下來，我們可以撰寫一個腳本如下。

> 來源：[[找尋創特定日期新高的股票]{.underline}](https://www.xq.com.tw/xstrader/19866-2/)
> 說明：那麼，要如何找出這些股票呢？首先，我們先找出最高點出現的日期，根據大盤技術分析圖表，今年6月15號指數創了新高。接下來，我們可以撰寫一個腳本如下。

input:highestdate(20230615,\"請輸入波段最高日期\");

value1=getbaroffset(highetdate); //找出最高點距離機天有幾根Bar

value2=close\[value1\]; //定義最高點當天的收盤價

if v\>2000 then

begin

if c cross over value2 or  c cross over highest(h\[1\],value1)

then ret=1;

end;

outputfield1(value2,1,\"前一波指數高點收盤價\");

outputfield2(value1,0,\"指數高點距今幾根Bar\");

## 場景 160：企業價值營收比達標 --- 其中企業價值營收比的腳本如下

> 來源：[[企業價值營收比達標]{.underline}](https://www.xq.com.tw/xstrader/%e4%bc%81%e6%a5%ad%e5%83%b9%e5%80%bc%e7%87%9f%e6%94%b6%e6%af%94%e9%81%94%e6%a8%99/)
> 說明：其中企業價值營收比的腳本如下

value1=getField(\"總市值(億)\", \"D\");//億

value2=getField(\"負債總額\", \"Q\");//百萬

value3=getField(\"流動資產\", \"Q\");//百萬

value4=getField(\"應收帳款及票據\", \"Q\");//百萬

value5=getField(\"營業收入淨額\", \"Y\");//百萬

value6=(value1\*100+value2-(value3-value4))/value5;

input:ratio(0.7,\"比例上限\");

if value6\<ratio

and value6\>0

then ret=1;

outputfield(1,value6,1,\"企業價值營收比\");

outputfield(2,value1,0,\"總市值單位億元\");

outputfield(3,value1\*100+value2-(value3-value4),0,\"企業價值單位百萬\");

outputfield(4,value5,0,\"年營收\");

## 場景 161：企業價值營收比達標 --- 大跌後突破月線的腳本如下

> 來源：[[企業價值營收比達標]{.underline}](https://www.xq.com.tw/xstrader/%e4%bc%81%e6%a5%ad%e5%83%b9%e5%80%bc%e7%87%9f%e6%94%b6%e6%af%94%e9%81%94%e6%a8%99/)
> 說明：大跌後突破月線的腳本如下

if close\*1.283\<close\[30\]

and close\*1.782\>close\[30\]

and barslast(close cross over average(close,22))=0

and barslast(close cross over average(close,22))\[1\]\>30

then ret=1;

## 場景 162：選股策略介紹\~大股東或內部人買超 --- 成交量佔比暴增的腳本如下

> 來源：[[選股策略介紹\~大股東或內部人買超]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e4%bb%8b%e7%b4%b9%e5%a4%a7%e8%82%a1%e6%9d%b1%e6%88%96%e5%85%a7%e9%83%a8%e4%ba%ba%e8%b2%b7%e8%b6%85/)
> 說明：成交量佔比暴增的腳本如下

value1=GetField(\"佔大盤成交量比\",\"D\");

setbackbar(20);

input:length(20);

variable:up1(0);

up1 = bollingerband(value1, Length, 2 );

if

value1 crosses over up1

and close\>close\[1\]

//量暴增而且股價上漲

and close\<close\[1\]\*1.05

//但漲幅沒有非常大

then ret=1;

## 場景 163：選股策略介紹\~大股東或內部人買超 --- PB跌到歷年低點區的腳本如下

> 來源：[[選股策略介紹\~大股東或內部人買超]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e4%bb%8b%e7%b4%b9%e5%a4%a7%e8%82%a1%e6%9d%b1%e6%88%96%e5%85%a7%e9%83%a8%e4%ba%ba%e8%b2%b7%e8%b6%85/)
> 說明：PB跌到歷年低點區的腳本如下

value1=GetField(\"股價淨值比\",\"Y\");

value2=lowest(value1,6);

if value1\<value2\*1.1

then ret=1;

outputfield(1,value2,1,\"近六年最低股價淨值比\");

outputfield(2,value1,1,\"目前股價淨值比\");

## 場景 164：那些年我學到的投資觀念(八)：減法思維 --- 我先前有寫過一個選股策略：股本小於60億且董監與投信共襄盛舉。

> 來源：[[那些年我學到的投資觀念(八)：減法思維]{.underline}](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e5%b9%b4%e6%88%91%e5%ad%b8%e5%88%b0%e7%9a%84%e6%8a%95%e8%b3%87%e8%a7%80%e5%bf%b5%e5%85%ab%e6%b8%9b%e6%b3%95%e6%80%9d%e7%b6%ad/)
> 說明：我先前有寫過一個選股策略：股本小於60億且董監與投信共襄盛舉。

Input:SPeriod(5);

Var:Amount(0),Ratio(0);

Amount=GetField(\"投信買賣超\",\"D\");

Ratio=100\*Summation(Amount,SPeriod)

/Summation(V-GetField(\"當日沖銷張數\"),SPeriod);

// 五日平均成交金額\>0.15E

Condition1=Average(GetField(\"成交金額(億)\",\"D\"),5)\>=0.15;

// 董監持股佔股本比例\>=8%

Condition2=GetField(\"董監持股佔股本比例\", \"D\")\>=8;

// 董監持股增加

Condition3=GetField(\"董監持股\", \"M\")\>1.005\*GetField(\"董監持股\",
\"M\")\[1\];

// 投信區間買超

Condition4=Ratio\>1;

// 個股條件(籌碼相關)

if condition1 and condition2 and condition3 and condition4

then ret=1;

## 場景 165：股票便宜到大股東進場去買的選股策略 --- 股價低於每股自由支配現金加淨值的腳本如下：

> 來源：[[股票便宜到大股東進場去買的選股策略]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e7%a5%a8%e4%be%bf%e5%ae%9c%e5%88%b0%e5%a4%a7%e8%82%a1%e6%9d%b1%e9%80%b2%e5%a0%b4%e5%8e%bb%e8%b2%b7%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5/)
> 說明：股價低於每股自由支配現金加淨值的腳本如下：

value1=getField(\"稅前息前折舊前淨利\", \"Q\");

value2=getField(\"資本支出金額\", \"Q\");

value3=getField(\"股本(億)\", \"D\");

value4=(value1-value2)/(value3\*10);

//每股自由支配現金

value5=getField(\"每股淨值(元)\", \"Q\");

if (value4\*4+value5)\>close\*1.5

and value4\>0

then ret=1;

outputfield(1,value4\*4+value5,1,\"每股淨值+自由現金\");

outputfield(2,value4\*4,1,\"每股自由現金\");

outputfield(3,value5,1,\"每股淨值\");

## 場景 166：股票便宜到大股東進場去買的選股策略 --- 大股東站在買方的腳本如下：

> 來源：[[股票便宜到大股東進場去買的選股策略]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e7%a5%a8%e4%be%bf%e5%ae%9c%e5%88%b0%e5%a4%a7%e8%82%a1%e6%9d%b1%e9%80%b2%e5%a0%b4%e5%8e%bb%e8%b2%b7%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5/)
> 說明：大股東站在買方的腳本如下：

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

value2=getField(\"關聯券商買賣超張數\", \"D\");

value3=getField(\"地緣券商買賣超張數\", \"D\");

if GetField(\"內部人持股比例\",\"M\")

\>GetField(\"內部人持股比例\",\"M\")\[1\]

or GetField(\"大戶持股比例\",\"W\",param := 1000)

\>GetField(\"大戶持股比例\",\"W\",param := 1000)\[1\]+0.5

or value1\>=500

or value2\>500

or value3\>500

then ret=1;

outputfield(1,GetField(\"內部人持股比例\",\"M\"),0,\"內部人\");

outputfield(2,GetField(\"內部人持股比例\",\"M\")\[1\],0,\"前期內部人\");

outputfield(3,value1,0,\"關鍵券商\");

outputfield(4,GetField(\"大戶持股比例\",\"W\",param :=
1000),1,\"千張大戶比例\");

outputfield(5,GetField(\"大戶持股比例\",\"W\",param :=
1000)\[1\],1,\"前期千張大戶比例\");

## 場景 167：股價低於10年低點平均值且籌碼被收集 --- 股價低於10年低點平均值

> 來源：[[股價低於10年低點平均值且籌碼被收集]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc10%e5%b9%b4%e4%bd%8e%e9%bb%9e%e5%b9%b3%e5%9d%87%e5%80%bc%e4%b8%94%e7%b1%8c%e7%a2%bc%e8%a2%ab%e6%94%b6%e9%9b%86/)
> 說明：股價低於10年低點平均值

value1=(lowY(1)+lowY(2)+lowY(3)+lowY(4)+lowY(5)

+lowY(6)+lowY(7)+lowY(8)+lowY(9)+lowY(10))/10;

if close\<value1

then ret=1;

## 場景 168：股價低於10年低點平均值且籌碼被收集

> 來源：[[股價低於10年低點平均值且籌碼被收集]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc10%e5%b9%b4%e4%bd%8e%e9%bb%9e%e5%b9%b3%e5%9d%87%e5%80%bc%e4%b8%94%e7%b1%8c%e7%a2%bc%e8%a2%ab%e6%94%b6%e9%9b%86/)
> 說明：近幾日籌碼明顯被收集

value1=GetField(\"分公司買進家數\");

value2=GetField(\"分公司賣出家數\");

value3=value2-value1;

value4=countif(value3\>30,5);

//計算買進家數與賣出家數的差距夠大的天數

if value4\>3

then ret=1;

## 場景 169：股價低於淨值且籌碼被收集

> 來源：[[股價低於淨值且籌碼被收集]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e6%b7%a8%e5%80%bc%e4%b8%94%e7%b1%8c%e7%a2%bc%e8%a2%ab%e6%94%b6%e9%9b%86/)
> 說明：腳本的程式碼如下：

value1=GetField(\"分公司買進家數\");

value2=GetField(\"分公司賣出家數\");

value3=value2-value1;

value4=countif(value3\>25,5);

//計算買進家數與賣出家數的差距夠大的天數

if value4\>2

then ret=1;

## 場景 170：市值營收比夠低且籌碼被收集的個股 --- 上面的一至五項我們同事寫成以下的腳本。

> 來源：[[市值營收比夠低且籌碼被收集的個股]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%82%e5%80%bc%e7%87%9f%e6%94%b6%e6%af%94%e5%a4%a0%e4%bd%8e%e4%b8%94%e7%b1%8c%e7%a2%bc%e8%a2%ab%e6%94%b6%e9%9b%86%e7%9a%84%e5%80%8b%e8%82%a1/)
> 說明：上面的一至五項我們同事寫成以下的腳本。

// 計算

// 連續兩季市值營收比\<3%

Condition1=GetField(\"市值營收比\", \"Q\")\[1\]\<3 and
GetField(\"市值營收比\", \"Q\")\<GetField(\"市值營收比\", \"Q\")\[1\];

// 月營收年增率成長

Condition2=GetField(\"月營收年增率\",
\"M\")\>GetField(\"累計營收年增率\", \"M\")\[1\]\*1.5;

// 連續兩季營業利益率\>3%

Condition3=GetField(\"營業利益率\", \"Q\")\>5 and
GetField(\"營業利益率\", \"Q\")\[1\]\>3;

// 股本\>10E

Condition4=GetField(\"股本(億)\",\"D\")\>=10;

// 個股條件

Condition100=Condition1 and Condition2 and Condition3 and Condition4;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 選股條件

// 均成交金額\>0.2E

Condition101=Average(GetField(\"成交金額(億)\",\"D\"),5)\>=0.20;

// 個股條件(籌碼相關)

Condition200=Condition101;

// 篩選

If Condition100 and Condition200 Then Begin

Ret=1;

End;

## 場景 171：股價低於10年低點平均值且主力買超 --- 我寫了一個腳本來找出股價低於10年低點平均值的股票

> 來源：[[股價低於10年低點平均值且主力買超]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc10%e5%b9%b4%e4%bd%8e%e9%bb%9e%e5%b9%b3%e5%9d%87%e5%80%bc%e4%b8%94%e4%b8%bb%e5%8a%9b%e8%b2%b7%e8%b6%85/)
> 說明：我寫了一個腳本來找出股價低於10年低點平均值的股票

value1=(lowY(1)+lowY(2)+lowY(3)+lowY(4)+lowY(5)

+lowY(6)+lowY(7)+lowY(8)+lowY(9)+lowY(10))/10;

if close\<value1

then ret=1;

## 場景 172：價值型股法人買超 --- 根據這樣的假設，我寫了一個腳本來算出EV/EBITDA有沒有低於5：

> 來源：[[價值型股法人買超]{.underline}](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e5%9e%8b%e8%82%a1%e6%b3%95%e4%ba%ba%e8%b2%b7%e8%b6%85-2/)
> 說明：根據這樣的假設，我寫了一個腳本來算出EV/EBITDA有沒有低於5：

value1=GetField(\"總市值\",\"D\");//單位億

value2=GetField(\"負債總額\",\"Q\");//單位百萬

value3=GetField(\"現金及約當現金\",\"Q\");//單位百萬

value4=GetField(\"短期投資\",\"Q\");//單位百萬

value5=GetField(\"稅前息前折舊前淨利\",\"Q\");//單位百萬

var: pricingm1(0);

input: bl(5,\"上限值\");

if value5\>0 then begin

pricingm1=(value1\*100+value2-value3-value4)/summation(value5,4);

if pricingm1\<bl and pricingm1\>1

then ret=1;

outputfield(1,pricingm1,1,\"EV/EBITDA\");

outputfield(2,value1\*100+value2-value3-value4,0,\"EV\");

outputfield(3,value5,0,\"EBITDA\");

outputfield(4,value1,0,\"總市值\");

outputfield(5,value2,0,\"負債總額\");

outputfield(6,value3,0,\"現金\");

outputfield(7,value4,0,\"短期投資\");

end;

## 場景 173：關聯券商選股法

> 來源：[[關聯券商選股法]{.underline}](https://www.xq.com.tw/xstrader/%e9%97%9c%e8%81%af%e5%88%b8%e5%95%86%e9%81%b8%e8%82%a1%e6%b3%95/)
> 說明：以下是我寫的腳本：

value1=getField(\"關聯券商買賣超張數\", \"D\");

value2=getField(\"當日沖銷張數\", \"D\");

if volume\<\>0

then value3=value1/(volume-value2)\*100;

value4=close\*value1/10;

input:lb(20,\"佔比下限\");

input:lb1(2000,\"買超下限,單位:萬元 \");

if value3\>= lb

and value4\>=lb1

then ret=1;

## 場景 174：預收帳款明顯成長的公司 --- 第一個是預收帳款成長：

> 來源：[[預收帳款明顯成長的公司]{.underline}](https://www.xq.com.tw/xstrader/%e9%a0%90%e6%94%b6%e5%b8%b3%e6%ac%be%e6%98%8e%e9%a1%af%e6%88%90%e9%95%b7%e7%9a%84%e5%85%ac%e5%8f%b8/)
> 說明：第一個是預收帳款成長：

settotalbar(12);

input: ratio_1(1.1, \"本季比去年同期增長N倍\");

input: ratio_2(15, \"預收款項成長佔股本X%\");

// 計算過去四季預收款項成長的幅度佔股本比例

value1 = summation(GetField(\"預收款項\", \"Q\"), 4);

value2 = summation(GetField(\"預收款項\", \"Q\"), 4)\[4\];

value3 = value1 - value2;

value4 = value3 / (GetField(\"股本(億)\",\"D\") \* 100);

if

GetField(\"預收款項\", \"Q\") \>= GetField(\"預收款項\", \"Q\")\[4\] \*
ratio_1

and value4 \> ratio_2 / 100

then

ret = 1;

outputfield(1, GetField(\"預收款項\", \"Q\"), 2, \"預收款項\");

outputfield(3, GetField(\"預收款項\", \"Q\")\[4\], 2,
\"去年同期預收款項\");

outputfield(5, value4, 2, \"預收款項成長佔股本比例\");

## 場景 175：預收帳款明顯成長的公司

> 來源：[[預收帳款明顯成長的公司]{.underline}](https://www.xq.com.tw/xstrader/%e9%a0%90%e6%94%b6%e5%b8%b3%e6%ac%be%e6%98%8e%e9%a1%af%e6%88%90%e9%95%b7%e7%9a%84%e5%85%ac%e5%8f%b8/)
> 說明：第二個是暴量剛起漲：

input: period(15, \"日期區間\");

Input: ratioLimit(10, \"區間最大漲幅%\");

if

close = highest(close, period) //今日最高創區間最高價

and volume = highest(volume, period) //今日成交量創區間最大量

and highest(high, period) \< lowest(low, period) \* (1 + ratioLimit \*
0.01)

//今日最高價距離區間最低價漲幅尚不大

then

ret = 1;

## 場景 176：下檔風險有限且法人大買超 --- 我寫了一個腳本來尋找投資風險值夠低的股票，腳本如下：

> 來源：[[下檔風險有限且法人大買超]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%8b%e6%aa%94%e9%a2%a8%e9%9a%aa%e6%9c%89%e9%99%90%e4%b8%94%e6%b3%95%e4%ba%ba%e5%a4%a7%e8%b2%b7%e8%b6%85/)
> 說明：我寫了一個腳本來尋找投資風險值夠低的股票，腳本如下：

value1=getField(\"月營收\", \"M\")+getField(\"月營收\",
\"M\")\[1\]+getField(\"月營收\", \"M\")\[2\]

+getField(\"月營收\", \"M\")\[3\]+getField(\"月營收\",
\"M\")\[4\]+getField(\"月營收\", \"M\")\[5\]

+getField(\"月營收\", \"M\")\[6\]+getField(\"月營收\",
\"M\")\[7\]+getField(\"月營收\", \"M\")\[8\]

+getField(\"月營收\", \"M\")\[9\]+getField(\"月營收\",
\"M\")\[10\]+getField(\"月營收\", \"M\")\[11\];

//過去12個月營收，單位:億

value2=getField(\"股本(億)\", \"D\");

value3=value1/value2\*10;

//過去12個月的每股營收

value4=getField(\"每股淨值(元)\", \"Q\");

value6=getField(\"常續性利益(稅後)\",
\"Q\")+getField(\"常續性利益(稅後)\", \"Q\")\[1\]

+getField(\"常續性利益(稅後)\",
\"Q\")\[2\]+getField(\"常續性利益(稅後)\", \"Q\")\[3\];

value7=value6/(value2\*10);

//近四季每股常續性利益

var:DRV(0);

DRV=(value3+value4\*1.5+value7/3)/3;

//參考價格

value8=(close-DRV)/close\*100;

//偏離值

if value3\<100

//每股營收小於100

and value8\<-75

//偏離值小於負75

and value7\>2

//近四季每股常續性收益大於2元

and value4\>15

//每股淨值大於15元

then ret=1;

outputfield(1,value8,1,\"偏離值\");

outputfield(2,DRV,1,\"下跌風險值\");

outputfield(3,value3,1,\"過去12個月的每股營收\");

outputfield(4,value7,1,\"近四季常續性稅後盈餘\");

outputfield(5,value4,1,\"每股淨值\");

## 場景 177：長期盤整後的資金流向轉正 --- 一、近N日震盪幅度小於M%

> 來源：[[長期盤整後的資金流向轉正]{.underline}](https://www.xq.com.tw/xstrader/%e9%95%b7%e6%9c%9f%e7%9b%a4%e6%95%b4%e5%be%8c%e7%9a%84%e8%b3%87%e9%87%91%e6%b5%81%e5%90%91%e8%bd%89%e6%ad%a3-2/)
> 說明：一、近N日震盪幅度小於M%

input:n(7,\"區間波動範圍%\");

input:period(25,\"區間長度\");

if lowest(close\[1\],period)\*(1+n/100)\>highest(close\[1\],period)

then ret=1;

## 場景 178：長期盤整後的資金流向轉正 --- 二、佔全市場成交量創20日新高

> 來源：[[長期盤整後的資金流向轉正]{.underline}](https://www.xq.com.tw/xstrader/%e9%95%b7%e6%9c%9f%e7%9b%a4%e6%95%b4%e5%be%8c%e7%9a%84%e8%b3%87%e9%87%91%e6%b5%81%e5%90%91%e8%bd%89%e6%ad%a3-2/)
> 說明：二、佔全市場成交量創20日新高

value1=GetField(\"佔全市場成交量比\",\"D\");

SetTotalBar(20);

if

value1=highest(value1,20)

then ret=1;

## 場景 179：籌碼被收集的整理股 --- 首先我寫了一個籌碼被收集的整理股的腳本：

> 來源：[[籌碼被收集的整理股]{.underline}](https://www.xq.com.tw/xstrader/%e7%b1%8c%e7%a2%bc%e8%a2%ab%e6%94%b6%e9%9b%86%e7%9a%84%e6%95%b4%e7%90%86%e8%82%a1/)
> 說明：首先我寫了一個籌碼被收集的整理股的腳本：

value1=GetField(\"分公司買進家數\", \"D\");

value2=getField(\"分公司賣出家數\", \"D\");

if trueall(value2\>value1\*1.3,5) then begin

if close\> average(close,60)

and (highest(high,20)-lowest(low,20))/close\*100\<7

then ret=1;

end;

## 場景 180：買盤強勢創高股

> 來源：[[買盤強勢創高股]{.underline}](https://www.xq.com.tw/xstrader/%e8%b2%b7%e7%9b%a4%e5%bc%b7%e5%8b%a2%e5%89%b5%e9%ab%98%e8%82%a1/)
> 說明：以下是我寫的腳本：

input:Len(10);

input:Period(5);

Var:BTotal(0),STotal(0),BSRatio(0);

BTotal=GetField(\"分公司買進家數\");

STotal=GetField(\"分公司賣出家數\");

BSRatio=100\*(STotal-BTotal)/(STotal+BTotal);

//賣出家數減買進家數差佔總交易家數的比例

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

if C\>=C\[1\]\*1.02

//漲幅超過2%

and C\*1.02\>=H

//收盤接近最高價

and C\>=Highest(H\[1\],Len)

//收盤創波段高點

and Average(GetField(\"成交金額(億)\",\"D\"),period)\>=0.15

//成交值超過1500萬

and trueall(BSRatio\>5,period)

//籌碼在被收集中

and BSRatio=Highest(BSRatio,10)

//籌碼收集的情況持續中

then ret=1;

## 場景 181：中小型科技股選股策略 --- 於是我寫了以下的腳本去找這樣的股票：

> 來源：[[中小型科技股選股策略]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%ad%e5%b0%8f%e5%9e%8b%e7%a7%91%e6%8a%80%e8%82%a1%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5/)
> 說明：於是我寫了以下的腳本去找這樣的股票：

Input:SPeriod(8);

Var:Amount(0),Ratio(0);

// 計算

Amount=GetField(\"投信買賣超\",\"D\");

Ratio=100\*Summation(Amount,SPeriod)

/Summation(V-GetField(\"當日沖銷張數\"),SPeriod);

// 連續三季研發費用佔總市值比率達到一定的水準

value1=getField(\"總市值(億)\", \"D\");

value2=getField(\"研發費用\", \"Q\");

value3=value2/(value1\*100)\*100;

Condition1=value3\>2.1

and value3\[90\]\>1.8

and value3\[180\]\>1.5;

// 營業利益率\>5%

Condition2=GetField(\"營業利益率\", \"Q\")\>5;

// 均成交金額\>0.2E

Condition3=Average(GetField(\"成交金額(億)\",\"D\"),5)\>=0.20;

// 投信買超

Condition4=Ratio\>0.5;

// 個股條件(籌碼相關)

if condition1 and condition2 and condition3 and condition4

then ret=1;

## 場景 182：多方勢力一起進場

> 來源：[[多方勢力一起進場]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%9a%e6%96%b9%e5%8b%a2%e5%8a%9b%e4%b8%80%e8%b5%b7%e9%80%b2%e5%a0%b4/)
> 說明：於是我寫了以下的腳本

setBarback(200);

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

value2=GetField(\"地緣券商買賣超張數\",\"D\");

value3=GetField(\"綜合前十大券商買賣超張數\",\"D\");

value4=GetField(\"外資買賣超\",\"D\");

value5=GetField(\"投信買賣超\",\"D\");

value6=GetField(\"自營商自行買賣買賣超\",\"D\");

value7=GetField(\"主力買賣超張數\",\"D\");

value8=value1+value2+value3+value4+value5+value6+value7;

//這些各方勢力買超合計的張數

value9=value8/volume\*100;

//合計佔成交量的比重

var:count(0);

condition1=false;

count=0;

if value1\>0 then count=count+1;

if value2\>0 then count=count+1;

if value3\>0 then count=count+1;

if value4\>0 then count=count+1;

if value5\>0 then count=count+1;

if value6\>0 then count=count+1;

if value7\>0 then count=count+1;

if volume\>500

//成交量大於500張

and count\>=5

//七項至少六項是買超

and value9\>75

//合計買超張數佔成交量達75%以上

then condition1=true;

if barslast(condition1)=0

//最近一期符合上述條件

and barslast(condition1)\[1\]\>100

//很久沒有符合這個條件

then ret=1;

outputfield(1,count,0,\"符合條件數\");

## 場景 183：投信與外資一陣子以來的同步買超 --- 首先是寫一個腳本來描敘投信與外資同步大買，我寫的腳本如下：

> 來源：[[投信與外資一陣子以來的同步買超]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e4%bf%a1%e8%88%87%e5%a4%96%e8%b3%87%e4%b8%80%e9%99%a3%e5%ad%90%e4%bb%a5%e4%be%86%e7%9a%84%e5%90%8c%e6%ad%a5%e8%b2%b7%e8%b6%85/)
> 說明：首先是寫一個腳本來描敘投信與外資同步大買，我寫的腳本如下：

input:days(60,\"計算期間\");

input:M1(200,\"最低買超張數\");

value1=getField(\"外資買賣超\", \"D\");

value2=getField(\"投信買賣超\", \"D\");

condition1=value1\>m1 and value2\>m1;

if condition1

and barslast(condition1)\[1\]\>=days

then ret=1;

## 場景 184：大跌後股價突破月線 --- 先來定義一下什麼叫作大跌，根據我們AI  Team的研究，30個交易日裡，股價跌了28.3%，抄底的勝率最高，所以我就先寫一個條件如下：

> 來源：[[大跌後股價突破月線]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e8%82%a1%e5%83%b9%e7%aa%81%e7%a0%b4%e6%9c%88%e7%b7%9a/)
> 說明：先來定義一下什麼叫作大跌，根據我們AI 
> Team的研究，30個交易日裡，股價跌了28.3%，抄底的勝率最高，所以我就先寫一個條件如下：

if close\[30\]\>close\*1.283

then ret=1;

## 場景 185：大跌後股價突破月線 --- 接下來就再加上股價近一個月來第一次突破月線的腳本，合起來的腳本如下：

> 來源：[[大跌後股價突破月線]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e8%82%a1%e5%83%b9%e7%aa%81%e7%a0%b4%e6%9c%88%e7%b7%9a/)
> 說明：接下來就再加上股價近一個月來第一次突破月線的腳本，合起來的腳本如下：

if close\[30\]\>close\*1.283

and barslast(close cross over average(close,22))=0

and barslast(close cross over average(close,22))\[1\]\>30

then ret=1;

## 場景 186：布林選股法 --- 下面是布林值帶寬收窄的腳本：

> 來源：[[布林選股法]{.underline}](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e5%b8%83%e6%9e%97%e5%80%bc%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e7%9a%84%e4%b8%80%e4%ba%9b%e6%8e%a2%e8%a8%8e/)
> 說明：下面是布林值帶寬收窄的腳本：

input:length(20,\"計算天期\");

input:width(1.5,\"帶寬%\");

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 = bollingerband(Close, Length, 2);

down1 = bollingerband(Close, Length, -2 );

mid1 = (up1 + down1) / 2;

bbandwidth = 100 \* (up1 - down1) / mid1;

if bbandwidth \<width

then ret=1;

## 場景 187：布林選股法 --- 接下來是K棒突破布林線上緣的腳本：

> 來源：[[布林選股法]{.underline}](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e5%b8%83%e6%9e%97%e5%80%bc%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e7%9a%84%e4%b8%80%e4%ba%9b%e6%8e%a2%e8%a8%8e/)
> 說明：接下來是K棒突破布林線上緣的腳本：

Input: Length(20), UpperBand(2);

SetInputName(1, \"期數\");

SetInputName(2, \"通道上緣\");

settotalbar(3);

Ret = close \>= bollingerband(Close, Length, UpperBand);

## 場景 188：穩定盈餘成長股暴量起漲

> 來源：[[穩定盈餘成長股暴量起漲]{.underline}](https://www.xq.com.tw/xstrader/%e7%a9%a9%e5%ae%9a%e7%9b%88%e9%a4%98%e6%88%90%e9%95%b7%e8%82%a1%e6%9a%b4%e9%87%8f%e8%b5%b7%e6%bc%b2/)
> 說明：暴量漲的腳本

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 189：股價遠低於五年平均總市值 --- 如果目前的總市值遠遠低於過去五年的平均總市值，且這段時間股價有明顯的跌幅，那麼股價就可能被嚴重低估。

> 來源：[[股價遠低於五年平均總市值]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e9%81%a0%e4%bd%8e%e6%96%bc%e4%ba%94%e5%b9%b4%e5%b9%b3%e5%9d%87%e7%b8%bd%e5%b8%82%e5%80%bc/)
> 說明：如果目前的總市值遠遠低於過去五年的平均總市值，且這段時間股價有明顯的跌幅，那麼股價就可能被嚴重低估。

value1=(GetField(\"總市值(億)\",\"Y\")+GetField(\"總市值(億)\",\"Y\")\[1\]+

GetField(\"總市值(億)\",\"Y\")\[2\]+GetField(\"總市值(億)\",\"Y\")\[3\]+

GetField(\"總市值(億)\",\"Y\")\[4\])/5;

value2=GetField(\"總市值(億)\",\"D\");

input:ratio(40,\"低於平均市值的最低幅度\");

if (value1/value2-1)\*100\>ratio then ret=1;

outputfield(1,(value1/value2-1)\*100,0,\"低於平均市值的幅度\");

## 場景 190：股價低於剩餘收益模型 --- 這個模型對於那些每年ROE都有達到一定水準且獲利穩定的公司，是還蠻可以拿來作為評價的標準。

> 來源：[[股價低於剩餘收益模型]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e5%89%a9%e9%a4%98%e6%94%b6%e7%9b%8a%e6%a8%a1%e5%9e%8b/)
> 說明：這個模型對於那些每年ROE都有達到一定水準且獲利穩定的公司，是還蠻可以拿來作為評價的標準。

value1=getField(\"總市值(億)\", \"D\");

value2=getField(\"股東權益總額\", \"Q\");//百萬

value3=getField(\"股東權益報酬率\", \"Q\");//單位&

input:ratio(8,\"折現率%\");

var:pvr(0);

pvr=summation(value2\*value3/100,10)/power(1+ratio/100,10);

value4=pvr+value2;

input:discountrate(30,\"折價幅度\");

if value1\*100\*(1+discountrate/100)\<value4

then ret=1;

## 場景 191：股價低於股利估值 --- 用過去五年的平均股利作計算的基礎，如果目前股價低於這數字的16倍，而且過去五年每股股利都超過五毛，代表目前的股價可能在平均水準之下，這時候如果搭配法人買超，代表\...

> 來源：[[股價低於股利估值]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e8%82%a1%e5%88%a9%e4%bc%b0%e5%80%bc/)
> 說明：用過去五年的平均股利作計算的基礎，如果目前股價低於這數字的16倍，而且過去五年每股股利都超過五毛，代表目前的股價可能在平均水準之下，這時候如果搭配法人買超，代表法人可能也認同目前的估值被低估了。

input:N1(5);

input:N2(16);

setinputname(1,\"股利平均的年數\");

setinputname(2,\"股利的倍數\");

value1=GetField(\"股利合計\",\"Y\");

value2=average(value1,N1);

if close\<value2\*N2

then ret=1;

## 場景 192：股價低於十年本業獲利估值 --- 如果這個數字跟股價相比，股價有一定幅度的折價，那就代表目前的股價可能被低估了。

> 來源：[[股價低於十年本業獲利估值]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e5%8d%81%e5%b9%b4%e6%9c%ac%e6%a5%ad%e7%8d%b2%e5%88%a9%e4%bc%b0%e5%80%bc/)
> 說明：如果這個數字跟股價相比，股價有一定幅度的折價，那就代表目前的股價可能被低估了。

variable: idx(0), t(0);

input:r1(3);

input:r2(2);

input:r3(10,\"折價比例\");

setinputname(1,\"假設未來十年營業利益年成長率\");

setinputname(2,\"未來十年平均年利率\");

setinputname(3,\"未來獲利折現合計淨值與市價比\");

// 計算未來10年的營業利益折現值

value1=GetField(\"營業利益\",\"Y\"); //單位:百萬

value2=GetField(\"最新股本\"); //單位:億

value3=GetField(\"每股淨值(元)\",\"y\");

value11 =
maxlist(GetField(\"營業利益\",\"Y\"),GetField(\"營業利益\",\"Y\")\[1\],GetField(\"營業利益\",\"Y\")\[2\],GetField(\"營業利益\",\"Y\")\[3\],GetField(\"營業利益\",\"Y\")\[4\]);

value12 =
minlist(GetField(\"營業利益\",\"Y\"),GetField(\"營業利益\",\"Y\")\[1\],GetField(\"營業利益\",\"Y\")\[2\],GetField(\"營業利益\",\"Y\")\[3\],GetField(\"營業利益\",\"Y\")\[4\]);

if trueall(value1\>0,5) and (value11-value12)/value11\<0.5

then begin

t = 0;

for idx =1 to 10

begin

t = t + value1 \* power(1+r1/100,idx)/power(1+r2/100,idx);

end;

// t=百萬,value2=億,換成每股

value5 = t / value2 / 100;

value6=(value3+value5);

if close\< value6\*(1-r3/100)

then ret=1;

end;

outputfield(1, value5, 2, \"估算十年每股營業利益折現值\");

outputfield(2, value6, 2, \"估值\");

## 場景 193：股價低於平均股利法估值

> 來源：[[股價低於平均股利法估值]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e5%b9%b3%e5%9d%87%e8%82%a1%e5%88%a9%e6%b3%95%e4%bc%b0%e5%80%bc/)
> 說明：他寫的腳本如下：

Input:SPeriod(10);

Input:N1(5);

Input:N2(16);

Var:Amount(0),Ratio(0);

// 計算

Amount=GetField(\"官股券商買賣超張數\",\"D\");

Ratio=100\*Summation(Amount,SPeriod)

/Summation(V-GetField(\"當日沖銷張數\"),SPeriod);

value1=GetField(\"股利合計\",\"Y\");

value2=average(value1,N1);

// 條件

ConditIon1=C\>Average(C,8)

and Average(C,8)\>Average(C,8)\[1\]

and l\>l\[1\]\*1.02;

Condition2=Average(GetField(\"成交金額(億)\",\"D\"),10)

\>=0.1

and V\<=2\*average(V\[1\],5);

Condition3=close\<value2\*N2;

Condition4=Ratio\>1;

if Condition1 and Condition2 and Condition3 and Condition4

Then Ret=1;

## 場景 194：股價低於歷年股價低點平均值 --- 蠻多公司的大股東，對於自己公司的股價心目中都有一個絕不能跌破的馬其諾防線，這個防線可能是某次增資時的價格，可能是老板對員工的承諾，我們可以找出過去十年每年的最低\...

> 來源：[[股價低於歷年股價低點平均值]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e6%ad%b7%e5%b9%b4%e8%82%a1%e5%83%b9%e4%bd%8e%e9%bb%9e%e5%b9%b3%e5%9d%87%e5%80%bc/)
> 說明：蠻多公司的大股東，對於自己公司的股價心目中都有一個絕不能跌破的馬其諾防線，這個防線可能是某次增資時的價格，可能是老板對員工的承諾，我們可以找出過去十年每年的最低價，然後算出這十年最低價的平均值，一旦股價低於這個數字，可能就是股價開始要接近大股東心目中的防線了

value1=(lowY(1)+lowY(2)+lowY(3)+lowY(4)+lowY(5)

+lowY(6)+lowY(7)+lowY(8)+lowY(9)+lowY(10))/10;

var: pr(\"\");

if close\<value1

then ret=1;

## 場景 195：股價遠低於證券價值 --- 當股價遠低於每股證券價值就是股價可能超跌了。

> 來源：[[股價遠低於證券價值]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e9%81%a0%e4%bd%8e%e6%96%bc%e8%ad%89%e5%88%b8%e5%83%b9%e5%80%bc/)
> 說明：當股價遠低於每股證券價值就是股價可能超跌了。

value1=getField(\"來自營運之現金流量\",
\"Q\")+getField(\"來自營運之現金流量\", \"Q\")\[1\]

+getField(\"來自營運之現金流量\",
\"Q\")\[2\]+getField(\"來自營運之現金流量\", \"Q\")\[3\];

value2=getField(\"長期負債\", \"Q\");

//以上單位百萬元

value3=getField(\"股本(億)\", \"D\");//單位:億元

input:vm(10,\"評價倍數\");

value4=value1\*vm\*0.8;

//企業總價值

value5=(value4-value2)/value3/10;

//每股證券價值

input: discount(30,\"折價率%\");

if close\<value5\*(1-discount/100)

then ret=1;

outputField(1,value5,0,\"每股證券價值\");

outputfield(2,close/value5,2,\"折價率\");

## 場景 196：股價低於歷年最低股價淨值比 --- 每年股價淨值比最低值，可以說是當年度整體市場對該個股的評價最低值，如果是過去十年這個數值的平均值，可以說是長期下來，市場對該股評價最低點的共識值，一旦現在的股價\...

> 來源：[[股價低於歷年最低股價淨值比]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e6%ad%b7%e5%b9%b4%e6%9c%80%e4%bd%8e%e8%82%a1%e5%83%b9%e6%b7%a8%e5%80%bc%e6%af%94/)
> 說明：每年股價淨值比最低值，可以說是當年度整體市場對該個股的評價最低值，如果是過去十年這個數值的平均值，可以說是長期下來，市場對該股評價最低點的共識值，一旦現在的股價淨值比低於這個十年低點平均值，而且營收還在成長，那就很有可能目前的股價是進到超跌區了。這個策略就是基於這樣的假設所發展出來的。

SetBarMode(2);

Input:

Series(numericseries), // 價格序列

Ago(numericsimple); //
K棒相對位置，和序列引用定義相同，0表當年度、1表前一年\...依此類推。

Var:

StartBar(0),

EndBar(0),

StartDate(0),

EndDate(0);

SetBackBar(260\*Ago);

// 起訖日期判斷

StartDate=EncodeDate(Year(Date)-Ago,1,1); // 相對年度第一日

EndDate=EncodeDate(Year(Date)-Ago,12,31); // 相對年度最後一日

StartBar=GetBarOffset(StartDate);

EndBar=GetBarOffset(EndDate);

// 起訖K棒位置判斷

If Year(Date\[StartBar\])\<Year(StartDate) Then StartBar=StartBar-1;

If Year(Date\[EndBar\])\>Year(EndDate) Then EndBar=EndBar+1;

// 計算區間極限值

// 若判斷後之起訖時間不在範圍內(新股/資料異常)：不顯示

If Year(Date\[StartBar\])\<\>Year(StartDate) or
Year(Date\[EndBar\])\<\>Year(EndDate) Then

AnnualLowest=0

Else

AnnualLowest=Lowest(Series\[EndBar\],StartBar-EndBar+1);

## 場景 197：股價低於歷年最低股價淨值比

> 來源：[[股價低於歷年最低股價淨值比]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e6%ad%b7%e5%b9%b4%e6%9c%80%e4%bd%8e%e8%82%a1%e5%83%b9%e6%b7%a8%e5%80%bc%e6%af%94/)

value1=getField(\"股價淨值比\", \"D\");

value2=(annuallowest(value1,1)

+annuallowest(value1,2)

+annuallowest(value1,3)

+annuallowest(value1,4)

+annuallowest(value1,5)

+annuallowest(value1,6)

+annuallowest(value1,7)

+annuallowest(value1,8)

+annuallowest(value1,9)

+annuallowest(value1,10))/10;

if value1\<value2

then ret=1;

## 場景 198：股價低於每股自由支配現金加淨值

> 來源：[[股價低於每股自由支配現金加淨值]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e6%af%8f%e8%82%a1%e8%87%aa%e7%94%b1%e6%94%af%e9%85%8d%e7%8f%be%e9%87%91%e5%8a%a0%e6%b7%a8%e5%80%bc/)
> 說明：我寫的腳本如下：

value1=getField(\"稅前息前折舊前淨利\", \"Q\");

value2=getField(\"資本支出金額\", \"Q\");

value3=getField(\"股本(億)\", \"D\");

value4=(value1-value2)/(value3\*10);

//每股自由支配現金

value5=getField(\"每股淨值(元)\", \"Q\");

if (value4\*4+value5)\>close\*1.5

and value4\>0

then ret=1;

outputfield(1,value4\*4+value5,1,\"每股淨值+自由現金\");

outputfield(2,value4\*4,1,\"每股自由現金\");

outputfield(3,value5,1,\"每股淨值\");

## 場景 199：營收成長籌碼佳趨勢向上 --- 以下是根據上述精神寫的腳本

> 來源：[[營收成長籌碼佳趨勢向上]{.underline}](https://www.xq.com.tw/xstrader/%e7%87%9f%e6%94%b6%e6%88%90%e9%95%b7%e7%b1%8c%e7%a2%bc%e4%bd%b3%e8%b6%a8%e5%8b%a2%e5%90%91%e4%b8%8a/)
> 說明：以下是根據上述精神寫的腳本

Input:SPeriod(3);

Input:SMALen(5),LMALen(13);

//每月初一到15之間

Condition1=dayofmonth(Date)\>1 and dayofmonth(Date)\<15;

// 營收連續成長

Condition2=GetField(\"累計營收年增率\",\"M\")\>20

and GetField(\"累計營收年增率\",\"M\")\[1\]\>20;

// 相對大量

Condition3=V\>=Highest(V\[1\],SPeriod)\*1.2;

// 籌碼四選二(外資/投信/主力/控盤)

Condition4=CCT_Chip(1)\>=2;

// 股本\<100億

Condition5=GetField(\"股本(億)\",\"D\")\<100;

// 均線黃金交叉

Condition6=average(L,SMALen) Cross Over average(H,LMALen) ;

// 個股條件

Condition100=Condition1 and Condition2 and Condition3 and Condition4 and
Condition5 and Condition6;

If Condition100 Then

Ret=1;

## 場景 200：營收成長籌碼佳趨勢向上 --- 其中有一個函數的腳本如下

> 來源：[[營收成長籌碼佳趨勢向上]{.underline}](https://www.xq.com.tw/xstrader/%e7%87%9f%e6%94%b6%e6%88%90%e9%95%b7%e7%b1%8c%e7%a2%bc%e4%bd%b3%e8%b6%a8%e5%8b%a2%e5%90%91%e4%b8%8a/)
> 說明：其中有一個函數的腳本如下

Input:Days(numericsimple);

Var:ChipCount(0);

ChipCount=0;

CCT_Chip=0;

If summation(GetField(\"投信買賣超\"),Days)\>0 Then

ChipCount=ChipCount+1;

//Else

//ChipCount=ChipCount;

If summation(GetField(\"外資買賣超\"),Days)\>0 Then

ChipCount=ChipCount+1;

If summation(GetField(\"主力買賣超張數\"),Days)\>0 Then

ChipCount=ChipCount+1;

If summation(GetField(\"控盤者買賣超張數\"),Days)\>0 Then

ChipCount=ChipCount+1;

CCT_Chip=ChipCount;

## 場景 201：盤整趨勢化操作

> 來源：[[盤整趨勢化操作]{.underline}](https://www.xq.com.tw/xstrader/%e7%9b%a4%e6%95%b4%e8%b6%a8%e5%8b%a2%e5%8c%96%e6%93%8d%e4%bd%9c/)
> 說明：他寫了如下腳本

Input:n1(10),n2(4);

Value1=absvalue(C-C\[n1-1\]);

//近n日收盤價價差的絕對值

Value2=summation(range,n1);

//近n日價格差的總和

If Value1=0 Then

Return

Else

Value3=Value2/Value1;

//近n日波動區間總和除以價差

Value4=average(Value3,n2);

//取這比例的短期平均值

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 盤整區間

Condition1=Value4\<=9 and Value4\>0;

// 強勢穿越均線

Condition2=C Cross Over average(H,30) and C\>O\*1.01 and C\*1.01\>H;

// 股本\>12E

Condition3=GetField(\"股本(億)\",\"D\")\>12;

// 個股條件

Condition100=Condition1 and Condition2 and Condition3 ;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 選股條件

// 均成交金額\>0.13E且非暴大量

Condition101=Average(GetField(\"成交金額(億)\",\"D\"),4)\>=0.13

and V\<=1.8\*average(V\[1\],5);

If Condition100 and Condition101 Then

Ret=1;

## 場景 202：盤整跳空法人買超股

> 來源：[[盤整跳空法人買超股]{.underline}](https://www.xq.com.tw/xstrader/%e7%9b%a4%e6%95%b4%e8%b7%b3%e7%a9%ba%e6%b3%95%e4%ba%ba%e8%b2%b7%e8%b6%85%e8%82%a1/)
> 說明：以下是我同事寫的腳本

Input:SPeriod(2);

Input:Len(12);

Var:Amount(0),Ratio(0);

// 計算

Amount=GetField(\"法人買賣超張數\");

Ratio=100\*Summation(Amount,SPeriod)/Summation(V-GetField(\"當日沖銷張數\"),SPeriod);

Value1=Highest(H\[1\],Len);

Value2=Lowest(L\[1\],Len);

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 選股條件

// 盤整區間

Condition2=Value1\<1.045\*Value2;

// 開盤跳空

ConditIon3=O\>1.015\*H\[1\];

// 股本\>12E

Condition4=GetField(\"股本(億)\",\"D\")\>12;

// 個股條件

Condition100=Condition2 and Condition3 and Condition4;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 選股條件

// 法人區間買超

Condition101=Ratio\>=1.8;

// 個股條件(籌碼相關)

// 篩選

If Condition100 and Condition101 Then

Ret=1;

## 場景 203：投信小試身手 --- 同事寫的，符合上述概念的選股腳本如下：

> 來源：[[投信小試身手]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e4%bf%a1%e5%b0%8f%e8%a9%a6%e8%ba%ab%e6%89%8b/)
> 說明：同事寫的，符合上述概念的選股腳本如下：

Input:SITCARatioThreshold(2);

Var:SITCA(0),SITCARatio(0),NetV(0),SVR(0);

// 計算

// 投信買賣超金額

SITCA=GetField(\"投信買賣超\",\"D\");

SITCARatio=GetField(\"投信持股比例\",\"D\");

NetV=V-GetField(\"當日沖銷張數\",\"D\");

SVR=SITCA/NetV;

// 條件

// 連續5日成交量\>500

Condition1=trueall(V\>500,5);

// 投信買超增加且連續二日投信買超占量比高

Condition2=SVR\>=0.10 and SVR\[1\]\>0.05 and SVR\>SVR\[1\];

// 投信持股比例\<1.5%

Condition3=SITCARatio\<SITCARatioThreshold ;

// 當日收紅K(4%) 代表投信追價的決心

Condition4=(C-O)/O\>=0.04;

Condition100=Condition1 and Condition2 and Condition3 and Condition4;

// 篩選

If Condition100 Then Ret=1;

## 場景 204：優質低價股 --- 以下是計算過去四季合計EPS的腳本：

> 來源：[[優質低價股]{.underline}](https://www.xq.com.tw/xstrader/%e5%84%aa%e8%b3%aa%e4%bd%8e%e5%83%b9%e8%82%a1/)
> 說明：以下是計算過去四季合計EPS的腳本：

input:X(5); SetInputName(1, \"元\");

variable: N(4);

SetTotalBar(3);

Value1 = Summation(GetField(\"EPS\",\"Q\"),N);

if Value1 \> X then ret=1;

SetOutputName1(\"EPS合計\");

OutputField1(Value1);

## 場景 205：價值型股法人買超 --- 前者是後者的四倍，代表純粹談這家公司的運營情況，四年可以回本

> 來源：[[價值型股法人買超]{.underline}](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e5%9e%8b%e8%82%a1%e6%b3%95%e4%ba%ba%e8%b2%b7%e8%b6%85/)
> 說明：前者是後者的四倍，代表純粹談這家公司的運營情況，四年可以回本

value1=GetField(\"總市值\",\"D\");//單位億

value2=GetField(\"負債總額\",\"Q\");//單位百萬

value3=GetField(\"現金及約當現金\",\"Q\");//單位百萬

value4=GetField(\"短期投資\",\"Q\");//單位百萬

value5=GetField(\"稅前息前折舊前淨利\",\"Q\");//單位百萬

var: pricingm1(0);

input: bl(4,\"上限值\");

if value5\>0 then begin

pricingm1=(value1\*100+value2-value3-value4)

/summation(value5,4);

if pricingm1\<bl and pricingm1\>1

then ret=1;

outputfield(1,pricingm1,1,\"EV/EBITDA\");

outputfield(2,value1\*100+value2-value3-value4,0,\"EV\");

outputfield(3,value5,0,\"EBITDA\");

outputfield(4,value1,0,\"總市值\");

outputfield(5,value2,0,\"負債總額\");

outputfield(6,value3,0,\"現金\");

outputfield(7,value4,0,\"短期投資\");

end;

## 場景 206：投信積極買超股 --- 綜合這三個條件寫出來的腳本如下：

> 來源：[[投信積極買超股]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e4%bf%a1%e7%a9%8d%e6%a5%b5%e8%b2%b7%e8%b6%85%e8%82%a1/)
> 說明：綜合這三個條件寫出來的腳本如下：

Input:SPeriod(3);

Var:Amount(0),Ratio(0);

// 計算

Amount=GetField(\"投信買賣超\",\"D\");

Ratio=100\*Summation(Amount,SPeriod)

/Summation(V-GetField(\"當日沖銷張數\"),SPeriod);

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 投信集中度\>5%

Condition101=Ratio\>=5;

// 投信今日大幅度買超

Condition102=GetField(\"投信買賣超\")

\>=8\*Highest(absvalue(GetField(\"投信買賣超\")\[1\]),SPeriod);

// 投信今日買超

Condition103=GetField(\"投信買賣超\",\"D\")\>0;

// 投信持股比例0.1\~1%

Condition104=GetField(\"投信持股比例\",\"D\")\<1.0 and
GetField(\"投信持股比例\",\"D\")\>0.1;

// 個股條件(籌碼相關)

if Condition101 and Condition102 and Condition103 and Condition104 Then

Ret=1;

## 場景 207：盤整後KD黃金交叉

> 來源：[[盤整後KD黃金交叉]{.underline}](https://www.xq.com.tw/xstrader/%e7%9b%a4%e6%95%b4%e5%be%8ckd%e9%bb%83%e9%87%91%e4%ba%a4%e5%8f%89/)
> 說明：同仁寫的腳本如下：

Input:SPeriod(5),MPeriod(8),LPeriod(55),LLPeriod(144);

Input:SMALen(13);

Input:Length(9),RSVt(3),Kt(3);

Var:\_rsv(0),k(0),\_d(0);

Var:rsvW(0),kW(0),\_dW(0);

// 計算

Stochastic(Length, RSVt, Kt, \_rsv, k, \_d);

xf_Stochastic(\"W\",Length, RSVt, Kt, rsvW, kW, \_dW);

// 條件

Condition1=trueall(V\>500,SPeriod);

//1. 連續5日成交量\>500

Condition2=k Cross Over \_d and kW Cross Over \_dW;

//2. 日KD黃金交叉且週KD黃金交叉

Condition3=k\>k\[1\] and \_d\>\_d\[1\] and kW\>kW\[1\]

and \_dW\>\_dW\[1\] and k\>50;

//3. 日K值和D值向上+週K值和D值向上且K值\>50

Condition4=absvalue(100\*(Lowest(L,LLPeriod)

-Highest(H,LLPeriod))/Highest(H,LLPeriod))\<10;

//4. 144日最高與最低之幅度\<10%

Condition99=Condition1 and Condition2 and Condition3

and Condition4 ;

// 篩選

IF Condition99 Then Ret=1;

## 場景 208：投信久違大買超

> 來源：[[投信久違大買超]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e4%bf%a1%e4%b9%85%e9%81%95%e5%a4%a7%e8%b2%b7%e8%b6%85/)
> 說明：我同事寫的腳本如下：

input: v1(2000); setinputname(1, \"投信估計持股上限(張)\");

input: v2(300); setinputname(2, \"近一日買賣超(張)\");

value1=GetField(\"投信持股\",\"D\");

value2=GetField(\"投信買賣超\",\"D\");

if value1 \< v1 and value2 \> v2

then ret=1;

SetOutputName1(\"投信買賣超(張)\");

OutputField1(value2);

## 場景 209：狹幅整理後的MACD黃金交叉

> 來源：[[狹幅整理後的MACD黃金交叉]{.underline}](https://www.xq.com.tw/xstrader/%e7%8b%b9%e5%b9%85%e6%95%b4%e7%90%86%e5%be%8c%e7%9a%84macd%e9%bb%83%e9%87%91%e4%ba%a4%e5%8f%89/)
> 說明：以下是他寫的腳本：

// 定義

Input:SPeriod(5),LLPeriod(144);

Input:FastLength(12),SlowLength(26),MACDLength(9);

Var:difValue(0),macdValue(0),oscValue(0);

// 計算

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

// 條件

Condition1=trueall(V\>500,SPeriod);

//1. 連續5日成交量\>500

Condition2=oscValue\>0

and oscValue\[1\]\<0

and oscValue\[1\]\>oscValue\[2\]

and oscValue\[0\]\>-oscValue\[1\];

//2. MACD黃金交叉且OSC愈來愈大

Condition3=absvalue(100\*(Lowest(L,LLPeriod)-Highest(H,LLPeriod))

/Highest(H,LLPeriod))\<10;

//3. 144日最高與最低之幅度\<10%

Condition99=Condition1 and Condition2 and Condition3 ;

// 篩選

IF Condition99 Then Ret=1;

## 場景 210：高董監持股強勢股

> 來源：[[高董監持股強勢股]{.underline}](https://www.xq.com.tw/xstrader/%e9%ab%98%e8%91%a3%e7%9b%a3%e6%8c%81%e8%82%a1%e5%bc%b7%e5%8b%a2%e8%82%a1/)
> 說明：他寫的腳本如下

// 定義

Input:Len(15);

// 計算

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 選股條件

// 股價離高點沒有太遠

Condition2=C\*1.07\>Average(H,Len) ;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 選股條件

// 均成交金額\>0.12E

Condition101=Average(GetField(\"成交金額(億)\",\"D\"),5)\>=0.12;

// 董監持股佔股本比例\>=10%

Condition102=GetField(\"董監持股佔股本比例\", \"D\")\>=10;

// 連續兩月董監持股增加

Condition103=GetField(\"董監持股\",
\"M\")\>=1.005\*GetField(\"董監持股\", \"M\")\[1\] and
GetField(\"董監持股\", \"M\")\[1\]\>=1.01\*GetField(\"董監持股\",
\"M\")\[2\];

// 個股條件(籌碼相關)

Condition200=Condition101 and Condition102 and Condition103;

// 篩選

If Condition2 and Condition200 Then

Ret=1;

## 場景 211：復仇者聯盟 --- 其中用到的暴量起漲的腳本，程式碼如下：

> 來源：[[復仇者聯盟]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%a9%e4%bb%87%e8%80%85%e8%81%af%e7%9b%9f/)
> 說明：其中用到的暴量起漲的腳本，程式碼如下：

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

## 場景 212：營收好轉大股東看好股 --- 基於這樣的想法，我寫了一個腳本如下：

> 來源：[[營收好轉大股東看好股]{.underline}](https://www.xq.com.tw/xstrader/%e7%87%9f%e6%94%b6%e5%a5%bd%e8%bd%89%e5%a4%a7%e8%82%a1%e6%9d%b1%e7%9c%8b%e5%a5%bd%e8%82%a1/)
> 說明：基於這樣的想法，我寫了一個腳本如下：

value1=GetField(\"月營收\",\"M\")

+GetField(\"月營收\",\"M\")\[1\]+GetField(\"月營收\",\"M\")\[2\];//億

outputfield(1,value1,1,\"近三月營收合計(億)\");

value2=GetField(\"營業利益率\",\"Q\");

outputfield(2,value2,1,\"營業利益率\");

value3=value1\*4\*value2/100;

//用最近三個月的營收乘以最近一季營業利益率來估算全年本業獲利

value4=GetField(\"最新股本\");//億

variable:FEPS(0);

FEPS=value3/value4\*10;

//用這樣估算的本業獲利來算預估的EPS

outputfield(3,FEPS,2,\"預估本業EPS\");

if feps\<\>0

then value5=close/feps;

outputfield(4,value5,\"預估本益比\");

input:pe(6,\"預估本益比上限\");

if value5\<pe and value5\>0

then ret=1;

outputfield(5,value4,0,\"股本億元\");

## 場景 213：股價低於平均股利的15倍 --- 我把這兩個觀察整合在一起，假設股價跌到股利的15倍且法人買超，是個好的進場時機，然後寫成了以下的腳本：

> 來源：[[股價低於平均股利的15倍]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e4%bd%8e%e6%96%bc%e5%b9%b3%e5%9d%87%e8%82%a1%e5%88%a9%e7%9a%8415%e5%80%8d/)
> 說明：我把這兩個觀察整合在一起，假設股價跌到股利的15倍且法人買超，是個好的進場時機，然後寫成了以下的腳本：

value1=(GetField(\"股利合計\",\"Y\")+GetField(\"股利合計\",\"Y\")\[1\]

+GetField(\"股利合計\",\"Y\")\[2\]+GetField(\"股利合計\",\"Y\")\[3\]

+GetField(\"股利合計\",\"Y\")\[4\])/5;

if close\<value1\*15

and getField(\"投信買賣超\", \"D\")\>200

and getField(\"外資買賣超\", \"D\")\>500

then ret=1;

## 場景 214：企業價值營收比夠低 --- 這數字是扣除負債及流動資產的可立即變現部份，更清楚的呈現市場對一家公司運營本身的估值，用這個數字去除以年營收，就是所謂的企業價值營收比，我把這樣的概念寫成腳本，\...

> 來源：[[企業價值營收比夠低]{.underline}](https://www.xq.com.tw/xstrader/%e4%bc%81%e6%a5%ad%e5%83%b9%e5%80%bc%e7%87%9f%e6%94%b6%e6%af%94%e5%a4%a0%e4%bd%8e/)
> 說明：這數字是扣除負債及流動資產的可立即變現部份，更清楚的呈現市場對一家公司運營本身的估值，用這個數字去除以年營收，就是所謂的企業價值營收比，我把這樣的概念寫成腳本，去尋找企業價值不到營收1/5的公司

value1=getField(\"總市值(億)\", \"D\");//億

value2=getField(\"負債總額\", \"Q\");//百萬

value3=getField(\"流動資產\", \"Q\");//百萬

value4=getField(\"應收帳款及票據\", \"Q\");//百萬

value5=getField(\"營業收入淨額\", \"Y\");//百萬

value6=(value1\*100+value2-(value3-value4))/value5;

input:ratio(0.2,\"比例上限\");

if value6\<ratio

and value6\>0

then ret=1;

outputfield(1,value6,1,\"企業價值營收比\");

outputfield(2,value1,0,\"總市值單位億元\");

outputfield(3,value1\*100+value2-(value3-value4),0,\"企業價值單位百萬\");

outputfield(4,value5,0,\"年營收\");

## 場景 215：本益比位於五年低位區 --- 首先，先來找出股價接近五年來平均最低本益比的股票，我寫的腳本如下

> 來源：[[本益比位於五年低位區]{.underline}](https://www.xq.com.tw/xstrader/%e6%9c%ac%e7%9b%8a%e6%af%94%e4%bd%8d%e6%96%bc%e4%ba%94%e5%b9%b4%e4%bd%8e%e4%bd%8d%e5%8d%80/)
> 說明：首先，先來找出股價接近五年來平均最低本益比的股票，我寫的腳本如下

value1=lowest(getField(\"本益比\", \"D\"),200);

value2=lowest(getField(\"本益比\", \"D\"),400);

value3=lowest(getField(\"本益比\", \"D\"),600);

value4=lowest(getField(\"本益比\", \"D\"),800);

value5=lowest(getField(\"本益比\", \"D\"),1000);

value6=(value1+value2+value3+value4+value5)/5;

if getField(\"本益比\", \"D\")\<value6\*1.1

then ret=1;

## 場景 216：月營收創近年新高 --- 系統有一個月營收創N期新高的腳本

> 來源：[[月營收創近年新高]{.underline}](https://www.xq.com.tw/xstrader/%e6%9c%88%e7%87%9f%e6%94%b6%e5%89%b5%e8%bf%91%e5%b9%b4%e6%96%b0%e9%ab%98/)
> 說明：系統有一個月營收創N期新高的腳本

input:N(60); setinputname(1, \"期別\");

SetTotalBar(3);

if GetField(\"月營收\", \"M\") \>= Highest(GetField(\"月營收\",
\"M\"),N) then ret=1;

SetOutputName1(\"月營收\");

OutputField1(GetField(\"月營收\", \"M\"));

## 場景 217：月營收創近年新高 --- 再來是用下面的腳本來確定營收是最近的一期

> 來源：[[月營收創近年新高]{.underline}](https://www.xq.com.tw/xstrader/%e6%9c%88%e7%87%9f%e6%94%b6%e5%89%b5%e8%bf%91%e5%b9%b4%e6%96%b0%e9%ab%98/)
> 說明：再來是用下面的腳本來確定營收是最近的一期

value1=getFieldDate(\"月營收\", \"M\");

//取得月營收日期

value2=datevalue(date,\"M\");

//取得最近一根K棒的月份數值

value3=datevalue(value1,\"M\");

//取得月營收日期的月份數值

if value2-value3=1

//如果K棒月份數值比公佈的數值差一

then ret=1;

value4=getField(\"月營收\", \"M\");

value5=getField(\"月營收月增率\", \"M\");

value6=getField(\"月營收年增率\", \"M\");

value7=getField(\"累計營收年增率\", \"M\");

outputfield(1,value4,2,\"月營收(億)\");

outputfield(2,value5,0,\"月增率\");

outputfield(3,value6,0,\"年增率\");

outputField(4,value7,0,\"累計年增率\");

outputfield(5,value1,0,\"月份\");

## 場景 218：大跌後的多頭執帶 --- \[檔名:\] 多頭執帶75\[說明:\] 開在最低點一路走高收在最高點附近的K棒

> 來源：[[大跌後的多頭執帶]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e7%9a%84%e5%a4%9a%e9%a0%ad%e5%9f%b7%e5%b8%b6/)
> 說明：\[檔名:\] 多頭執帶75\[說明:\]
> 開在最低點一路走高收在最高點附近的K棒

condition20=close\>open;

condition21=(Close-Open)\>(high-low)\*0.9;
condition22=Close\>Close\[1\]+high\[1\]-low\[1\];

IF condition20  and condition21  and condition22 

THEN  bkpatterm=\"多頭執帶\";

## 場景 219：大跌後的多頭執帶 --- 所以根據這個腳本，我就可以寫出以下的選股策略

> 來源：[[大跌後的多頭執帶]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e7%9a%84%e5%a4%9a%e9%a0%ad%e5%9f%b7%e5%b8%b6/)
> 說明：所以根據這個腳本，我就可以寫出以下的選股策略

if bkpattern=\"多頭執帶\"

and close\*1.283\<close\[30\]

then ret=1;

## 場景 220：平台整理後突破 --- 首先得先跟大家交代一下我寫的腳本：

> 來源：[[平台整理後突破]{.underline}](https://www.xq.com.tw/xstrader/%e5%b9%b3%e5%8f%b0%e6%95%b4%e7%90%86%e5%be%8c%e7%aa%81%e7%a0%b4/)
> 說明：首先得先跟大家交代一下我寫的腳本：

input:Period(20, \"平台區間\");

input:ratio(7, \"整理幅度(%)\");

input:ratio1(3,\"各高點(低點)間的差異幅度\");

variable:h1(0),h2(0),L1(0),L2(0);

h1=nthhighest(1,high\[1\],period);

//找出區間最高點

h2=nthhighest(4,high\[1\],period);

//找出區間第四高點

l1=nthlowest(1,low\[1\],period);

//找出區間最低點

l2=nthlowest(4,low\[1\],period);

//找出區間第四低點

if (h1-l1)/l1\<=ratio/100

//區間最高點與最低點差距小於7%

and (h1-h2)/h2\<=ratio1/100

//區間最高點與第四高點間差距小於3%

and (l2-l1)/l1\<=ratio1/100

//區間最低點與第四低點間差距小於3%

and close crosses over h1

//收盤價突破區間高點

and close\[period+30\]\*1.1\<h1

//整理前的第30天收盤價已有一定漲幅

and volume\> average(volume,period)

//成交量大於區間均量

then ret=1;

## 場景 221：產業上中下游都突破月線 --- 先跟大家介紹這個腳本：

> 來源：[[產業上中下游都突破月線]{.underline}](https://www.xq.com.tw/xstrader/%e7%94%a2%e6%a5%ad%e4%b8%8a%e4%b8%ad%e4%b8%8b%e6%b8%b8%e9%83%bd%e7%aa%81%e7%a0%b4%e6%9c%88%e7%b7%9a/)
> 說明：先跟大家介紹這個腳本：

value1=GetField(\"上游股價指標\",\"D\");

value2=GetField(\"同業股價指標\",\"D\");

value3=GetField(\"下游股價指標\",\"D\");

var:count(0);

count=0;

if value1 cross over average(value1,20)

then count=count+1;

if value2 cross over average(value2,20)

then count=count+1;

if value3 cross over average(value3,20)

then count=count+1;

if count\>2 then ret=1;

## 場景 222：不知名買盤力量突破盤整區

> 來源：[[不知名買盤力量突破盤整區]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%8d%e7%9f%a5%e5%90%8d%e8%b2%b7%e7%9b%a4%e5%8a%9b%e9%87%8f%e7%aa%81%e7%a0%b4%e7%9b%a4%e6%95%b4%e5%8d%80/)
> 說明：他寫的對應腳本如下

Input:RangeRatio(0.03),SPeriod(8);

Var:KeyKBarLow(0),KeyKBarHigh(0),KeyKBarDate(0),KBarOffset(0);

// 計算

// 選股條件

// 連續5日成交量\>500

Condition1=average(V,SPeriod)\>500;

// 創盤整高點

Condition2=(Highest(H\[1\],Speriod)-Lowest(L\[1\],Speriod))/Lowest(L\[1\],Speriod)\<=0.05

and H=Highest(H,21);

// 收盤接近今日高+收盤創8日高點+前日收黑K(%)

Condition3=(H-C)/C\<=0.01

and C\>=Highest(H\[1\],Speriod)

and (C\[2\]-O\[2\])/O\[2\]\<-0.01 ;

// 股本\<200億

Condition4=GetField(\"股本(億)\",\"D\")\<200;

// 投信/主力累積至昨日為賣超

Condition5=summation(GetField(\"投信買賣超\",\"D\")\[1\],SPeriod)\<0 or
summation(GetField(\"主力買賣超張數\",\"D\")\[1\],SPeriod)\<0;

Condition100=Condition1 and Condition2 and Condition3 and Condition4 and
Condition5;

// 篩選

If Condition100 Then Begin

Ret=1;

End;

## 場景 223：大跌後的多頭母子 --- 接下來我就用這個自訂函數來寫大跌後的多頭母子這個腳本

> 來源：[[大跌後的多頭母子]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e7%9a%84%e5%a4%9a%e9%a0%ad%e6%af%8d%e5%ad%90/)
> 說明：接下來我就用這個自訂函數來寫大跌後的多頭母子這個腳本

if bkpattern=\"多頭母子\"

and close\*1.283\<close\[30\]

and close\*1.728\>close\[30\]

then ret=1;

## 場景 224：大戶持續買進中 --- 其中有兩個腳本，千張大戶人數增加的腳本如下

> 來源：[[大戶持續買進中]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e6%88%b6%e6%8c%81%e7%ba%8c%e8%b2%b7%e9%80%b2%e4%b8%ad/)
> 說明：其中有兩個腳本，千張大戶人數增加的腳本如下

value1=GetField(\"大戶持股人數\",\"W\",param := 1000);

if value1\>value1\[1\]+3

then ret=1;

## 場景 225：大戶持續買進中 --- 每股淨值接股價的公司的腳本如下

> 來源：[[大戶持續買進中]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e6%88%b6%e6%8c%81%e7%ba%8c%e8%b2%b7%e9%80%b2%e4%b8%ad/)
> 說明：每股淨值接股價的公司的腳本如下

value1=GetField(\"每股淨值(元)\",\"Q\");

input:prec(0,\"兩者差異比例\");

if (close-value1)/close\*100\<prec then ret=1;

outputfield(1,value1,1,\"每股淨值\");

outputfield(2,(close-value1)/close,1,\"股價淨值差\");

## 場景 226：流動資產減負債超過市值一定比例 --- 首先我先寫了一個簡單的腳本來找出流動資產減負債超過市值的公司

> 來源：[[流動資產減負債超過市值一定比例]{.underline}](https://www.xq.com.tw/xstrader/%e6%b5%81%e5%8b%95%e8%b3%87%e7%94%a2%e6%b8%9b%e8%b2%a0%e5%82%b5%e8%b6%85%e9%81%8e%e5%b8%82%e5%80%bc%e4%b8%80%e5%ae%9a%e6%af%94%e4%be%8b/)
> 說明：首先我先寫了一個簡單的腳本來找出流動資產減負債超過市值的公司

input:ratio(120,\"佔總市值百分比%\");

if
(GetField(\"流動資產\",\"Q\")-GetField(\"負債總額\",\"Q\"))/100\>GetField(\"總市值\",\"D\")\*ratio/100

then ret=1;

outputfield(1,GetField(\"流動資產\",\"Q\"),0,\"流動資產\");

outputfield(2,GetField(\"負債總額\",\"Q\"),0,\"負債總額\");

outputfield(3,GetField(\"流動資產\",\"Q\")-GetField(\"負債總額\",\"Q\"),0,\"差額\");

outputfield(4,GetField(\"總市值\",\"D\"),0,\"總市值\");

## 場景 227：流動資產減負債超過市值一定比例 --- 這裡用的腳本是系統內建的量剛起漲

> 來源：[[流動資產減負債超過市值一定比例]{.underline}](https://www.xq.com.tw/xstrader/%e6%b5%81%e5%8b%95%e8%b3%87%e7%94%a2%e6%b8%9b%e8%b2%a0%e5%82%b5%e8%b6%85%e9%81%8e%e5%b8%82%e5%80%bc%e4%b8%80%e5%ae%9a%e6%af%94%e4%be%8b/)
> 說明：這裡用的腳本是系統內建的量剛起漲

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

## 場景 228：近期大跌的高配息股 --- 首先，先來算出目前股價是過去十年現金股利總和的倍數，我寫的腳本如下：

> 來源：[[近期大跌的高配息股]{.underline}](https://www.xq.com.tw/xstrader/%e8%bf%91%e6%9c%9f%e5%a4%a7%e8%b7%8c%e7%9a%84%e9%ab%98%e9%85%8d%e6%81%af%e8%82%a1/)
> 說明：首先，先來算出目前股價是過去十年現金股利總和的倍數，我寫的腳本如下：

value1=getField( \"現金股利\", \"Y\")+getField( \"現金股利\",
\"Y\")\[1\]

+getField( \"現金股利\", \"Y\")\[2\]+getField( \"現金股利\", \"Y\")\[3\]

+getField( \"現金股利\", \"Y\")\[4\]+getField( \"現金股利\", \"Y\")\[5\]

+getField( \"現金股利\", \"Y\")\[6\]+getField( \"現金股利\", \"Y\")\[7\]

+getField( \"現金股利\", \"Y\")\[8\]+getField( \"現金股利\",
\"Y\")\[9\];

input:lowband(50,\"十年配息合計低標\");

input:ratio(1.5,\"收盤價是十年股息合計的最低倍數\");

if value1\>=lowband

and close\<value1\*ratio

then ret=1;

outputfield(1,value1,1,\"十年合計配息\");

## 場景 229：好公司總市值接近歷史低點 --- 首先，是先找到總市值接近歷史低點的公司，我用的腳本如下：

> 來源：[[好公司總市值接近歷史低點]{.underline}](https://www.xq.com.tw/xstrader/%e5%a5%bd%e5%85%ac%e5%8f%b8%e7%b8%bd%e5%b8%82%e5%80%bc%e6%8e%a5%e8%bf%91%e6%ad%b7%e5%8f%b2%e4%bd%8e%e9%bb%9e/)
> 說明：首先，是先找到總市值接近歷史低點的公司，我用的腳本如下：

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

## 場景 230：好公司總市值接近歷史低點 --- 接下來關於交易時點，我用的是系統內建的暴量剛起漲的腳本：

> 來源：[[好公司總市值接近歷史低點]{.underline}](https://www.xq.com.tw/xstrader/%e5%a5%bd%e5%85%ac%e5%8f%b8%e7%b8%bd%e5%b8%82%e5%80%bc%e6%8e%a5%e8%bf%91%e6%ad%b7%e5%8f%b2%e4%bd%8e%e9%bb%9e/)
> 說明：接下來關於交易時點，我用的是系統內建的暴量剛起漲的腳本：

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

## 場景 231：股價自由現金流量比夠低且開始暴量起漲 --- 例如我最常用的就是暴量起漲這個腳本：

> 來源：[[股價自由現金流量比夠低且開始暴量起漲]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e8%87%aa%e7%94%b1%e7%8f%be%e9%87%91%e6%b5%81%e9%87%8f%e6%af%94%e5%a4%a0%e4%bd%8e%e4%b8%94%e9%96%8b%e5%a7%8b%e6%9a%b4%e9%87%8f%e8%b5%b7%e6%bc%b2/)
> 說明：例如我最常用的就是暴量起漲這個腳本：

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 232：大股東青睞股SAR出現買進訊號 --- 這個條件的對應腳本如上：

> 來源：[[大股東青睞股SAR出現買進訊號]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%82%a1%e6%9d%b1%e9%9d%92%e7%9d%9e%e8%82%a1sar%e5%87%ba%e7%8f%be%e8%b2%b7%e9%80%b2%e8%a8%8a%e8%99%9f/)
> 說明：這個條件的對應腳本如上：

input:AFIncrement(0.02); setinputname(1,\"加速因子\");

input:AFMax(0.2); setinputname(2,\"加速因子最大值\");

variable: sarValue(0);

sarValue = SAR(AFIncrement, AFIncrement, AFMax);

if close crosses over sarValue

then ret=1;

## 場景 233：營收成長股剛突破月線 --- 我把同事根據上述觀察寫的腳本改寫了一下，po在下面：

> 來源：[[營收成長股剛突破月線]{.underline}](https://www.xq.com.tw/xstrader/%e7%87%9f%e6%94%b6%e6%88%90%e9%95%b7%e8%82%a1%e5%89%9b%e7%aa%81%e7%a0%b4%e6%9c%88%e7%b7%9a/)
> 說明：我把同事根據上述觀察寫的腳本改寫了一下，po在下面：

input:MALen(21);

// 連續三個月營收成長

if GetField(\"月營收年增率\", \"M\")\>GetField(\"月營收年增率\",
\"M\")\[1\]

and GetField(\"月營收年增率\", \"M\")\[1\]\>GetField(\"月營收年增率\",
\"M\")\[2\]

//近三個月月營收年增率至少達到4.5%

and GetField(\"月營收年增率\", \"M\")\[2\]\>4.5

//前三天的收盤價都在月線之下

and Trueall(C\[1\]\<average(C,MALen)\[1\],3)

//最近一個交易日收盤價突破月線

and C Cross Over average(C,MALen)

//日成交金額超過一千萬元

and average(GetField(\"成交金額(億)\",\"D\"),5)\>=0.10

//成交量還沒有暴增

and V\<=1.5\*average(V\[1\],12)

then ret=1;

## 場景 234：盤整後的DMI買進訊號 --- 這個選股策略一共有兩個腳本，一個敘述，腳本一是近Ｎ日最高最低點差距小於Ｍ％，如果各位有要寫到區間盤整時，這是很常用的腳本。

> 來源：[[盤整後的DMI買進訊號]{.underline}](https://www.xq.com.tw/xstrader/%e7%9b%a4%e6%95%b4%e5%be%8c%e7%9a%84dmi%e8%b2%b7%e9%80%b2%e8%a8%8a%e8%99%9f/)
> 說明：這個選股策略一共有兩個腳本，一個敘述，腳本一是近Ｎ日最高最低點差距小於Ｍ％，如果各位有要寫到區間盤整時，這是很常用的腳本。

Input:band1(10,\"區間漲跌幅上限\"),days(144,\"盤整區間\");

setbackbar(days+20);

if absvalue(100\*(Lowest(L,days)

-Highest(H,days))/Highest(H,days))\<band1

then ret=1;

## 場景 235：盤整後的DMI買進訊號 --- 另一個腳本則是ＤＭＩ出現買進訊號，這個腳本裡比較特別的是，天期是用５天，原因是因為條件裡有一個條件是成交量近五日都大於５００張，我們就看這五天ＤＭＩ的表現是否在\...

> 來源：[[盤整後的DMI買進訊號]{.underline}](https://www.xq.com.tw/xstrader/%e7%9b%a4%e6%95%b4%e5%be%8c%e7%9a%84dmi%e8%b2%b7%e9%80%b2%e8%a8%8a%e8%99%9f/)
> 說明：另一個腳本則是ＤＭＩ出現買進訊號，這個腳本裡比較特別的是，天期是用５天，原因是因為條件裡有一個條件是成交量近五日都大於５００張，我們就看這五天ＤＭＩ的表現是否在出量時同步出現買進訊號

input:Length(５,\"計算期數\");

variable: pdi(0), ndi(0), adx_value(0);

DirectionMovement(Length, pdi, ndi, adx_value);

if pdi\>pdi\[1\] and ndi\<ndi\[1\] and Pdi crosses over Ndi

then ret=1;

## 場景 236：距離目標價還很遠的獲利穩定股 --- 我根據這樣的想法，寫了一個腳本如下：

> 來源：[[距離目標價還很遠的獲利穩定股]{.underline}](https://www.xq.com.tw/xstrader/%e8%b7%9d%e9%9b%a2%e7%9b%ae%e6%a8%99%e5%83%b9%e9%82%84%e5%be%88%e9%81%a0%e7%9a%84%e7%8d%b2%e5%88%a9%e7%a9%a9%e5%ae%9a%e8%82%a1/)
> 說明：我根據這樣的想法，寫了一個腳本如下：

var:tp(0);

if highest(GetField(\"每股稅後淨利(元)\",\"Y\"),7)

-lowest(GetField(\"每股稅後淨利(元)\",\"Y\"),7)\<1.5

and trueall(GetField(\"每股稅後淨利(元)\",\"Y\")\>1,7)

//每年EPS差距不大且每年賺錢

then tp=GetField(\"每股淨值(元)\",\"Q\")+

average(GetField(\"每股稅後淨利(元)\",\"Y\"),4)\*7;

input:rate(40,\"折價比率\");

if close\*(1+rate/100)\<tp

then ret=1;

outputfield(1,tp,1,\"目標價\");

outputfield(2,tp/close-1,1,\"折價率\");

## 場景 237：價量同步創新高且法人也追價股 --- 以下是我根據上述三個條件寫的腳本：

> 來源：[[價量同步創新高且法人也追價股]{.underline}](https://www.xq.com.tw/xstrader/%e5%83%b9%e9%87%8f%e5%90%8c%e6%ad%a5%e5%89%b5%e6%96%b0%e9%ab%98%e4%b8%94%e6%b3%95%e4%ba%ba%e4%b9%9f%e8%bf%bd%e5%83%b9%e8%82%a1/)
> 說明：以下是我根據上述三個條件寫的腳本：

Input:SPeriod(13),LPeriod(135);

Condition1=trueall(V\>500,5);

// 連續5日成交量\>500

Condition20=H=Highest(H,LPeriod);

//創長期新高

Condition2=Condition20 and Not Condition20\[1\];

//長期以來第一次創波段新高，不是一直創波段新高

Condition3=(Highest(C,SPeriod)-Lowest(C,SPeriod))/Lowest(C,SPeriod)\<0.05;

//近期漲幅不大

Condition4=V=Highest(V,SPeriod);

// 創區間大量

Condition100=Condition1 and Condition2 and Condition3 and Condition4 ;

// 篩選

If Condition100 Then Ret=1;

## 場景 238：近200日以來第一次成交金額超過兩億的低價股 --- 要寫出這樣的選股策略，我先寫出一個腳本來篩選出過去N日以來第一次成交量超過M億元的敘述，我寫的腳本如下：

> 來源：[[近200日以來第一次成交金額超過兩億的低價股]{.underline}](https://www.xq.com.tw/xstrader/%e8%bf%91200%e6%97%a5%e4%bb%a5%e4%be%86%e7%ac%ac%e4%b8%80%e6%ac%a1%e6%88%90%e4%ba%a4%e9%87%91%e9%a1%8d%e8%b6%85%e9%81%8e%e5%85%a9%e5%84%84%e7%9a%84%e4%bd%8e%e5%83%b9%e8%82%a1/)
> 說明：要寫出這樣的選股策略，我先寫出一個腳本來篩選出過去N日以來第一次成交量超過M億元的敘述，我寫的腳本如下：

value1=getField(\"成交金額(億)\", \"D\");

input:days(200,\"未達成交金額下限的日期數\");

input:vl(2,\"金額下限,單位億元\");

setbackbar(days);

if value1 \>vl

and barslast(value1\>vl)\[1\]\>days

then ret=1;

## 場景 239：估值折價嚴重且法人買超 --- 根據他們的這個基本思維，我寫了一個腳本如下：

> 來源：[[估值折價嚴重且法人買超]{.underline}](https://www.xq.com.tw/xstrader/%e4%bc%b0%e5%80%bc%e6%8a%98%e5%83%b9%e5%9a%b4%e9%87%8d%e4%b8%94%e6%b3%95%e4%ba%ba%e8%b2%b7%e8%b6%85/)
> 說明：根據他們的這個基本思維，我寫了一個腳本如下：

value1=getField(\"來自營運之現金流量\",
\"Y\")+getField(\"來自營運之現金流量\", \"Y\")\[1\]

+getField(\"來自營運之現金流量\",
\"Y\")\[2\]+getField(\"來自營運之現金流量\", \"Y\")\[3\]

+getField(\"來自營運之現金流量\",
\"Y\")\[4\]+getField(\"來自營運之現金流量\", \"Y\")\[5\]

+getField(\"來自營運之現金流量\",
\"Y\")\[6\]+getField(\"來自營運之現金流量\", \"Y\")\[7\]

+getField(\"來自營運之現金流量\",
\"Y\")\[8\]+getField(\"來自營運之現金流量\", \"Y\")\[9\];

//過去十年來自營運之現金流量總和,單位百萬

value2=getField(\"總市值(億)\", \"D\");

input:ratio(65,\"折價比例\");

if (value1/100)/value2\>=(1+ratio/100)

then ret=1;

outputfield(1,value1/100,0,\"十年營運現金流總和(億)\");

outputfield(2,value2,0,\"總市值(億)\");

outputfield(3,(value1/100)/value2,2,\"佔比\");

## 場景 240：低市銷率關鍵券商買超股 --- 基於這四個條件，他寫了一個程式，我把它改寫如下：

> 來源：[[低市銷率關鍵券商買超股]{.underline}](https://www.xq.com.tw/xstrader/%e4%bd%8e%e5%b8%82%e9%8a%b7%e7%8e%87%e9%97%9c%e9%8d%b5%e5%88%b8%e5%95%86%e8%b2%b7%e8%b6%85%e8%82%a1/)
> 說明：基於這四個條件，他寫了一個程式，我把它改寫如下：

Input:MALen(8);

Input:SPeriod(5);

Var:Amount(0),Ratio(0);

Amount=GetField(\"關鍵券商買賣超張數\",\"D\");

Ratio=100\*Summation(Amount,SPeriod)

/Summation(V-GetField(\"當日沖銷張數\"),SPeriod);

if Average(GetField(\"成交金額(億)\",\"D\"),5)\>=0.15

//近五日成交金額平均都有1500萬元

and Ratio\>=1

//大股東這五天買的很積極

and GetField(\"月營收年增率\", \"M\")\>5

//月營收年增率大於5%

and GetField(\"月營收年增率\", \"M\")\>GetField(\"累計營收年增率\",
\"M\")\[1\]

//月營收年增率大於前一期的累計營收增率

and C\>Average(H,MALen)

//股價大於8日最高價的移動平均

and Average(H,MALen)\>Average(H,MALen)\[1\]

//最高價的移動平均在往上走

and GetField(\"市值營收比\", \"Q\")\<3.5

//市值營收比小於3.5

then ret=1;

## 場景 241：穩定獲利配息的公司，股價跌破淨值 --- 其中股價低於淨值，我寫的腳本如下

> 來源：[[穩定獲利配息的公司，股價跌破淨值]{.underline}](https://www.xq.com.tw/xstrader/%e7%a9%a9%e5%ae%9a%e7%8d%b2%e5%88%a9%e9%85%8d%e6%81%af%e7%9a%84%e5%85%ac%e5%8f%b8%ef%bc%8c%e8%82%a1%e5%83%b9%e8%b7%8c%e7%a0%b4%e6%b7%a8%e5%80%bc/)
> 說明：其中股價低於淨值，我寫的腳本如下

value1=GetField(\"每股淨值(元)\",\"Q\");

if close\<value1 then ret=1;

if close\<\>0 then value2= (value1-close)/close\*100;

outputfield(1,value2,1,\"折價比例%\");

outputfield(2,value1,1,\"每股淨值\");

## 場景 242：投信開始著墨的股票 --- 同仁用XQ量化平台，寫了一個函數的腳本，稱為投信集中度排序，函數腳本如下

> 來源：[[投信開始著墨的股票]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e4%bf%a1%e9%96%8b%e5%a7%8b%e8%91%97%e5%a2%a8%e7%9a%84%e8%82%a1%e7%a5%a8/)
> 說明：同仁用XQ量化平台，寫了一個函數的腳本，稱為投信集中度排序，函數腳本如下

SetBarMode(1);

Input:Length(3, numericsimple, \"計算期間\");

If GetFieldDate(\"投信買賣超\",\"D\")=GetFieldDate(\"收盤價\",\"D\")

and 100\*Summation(GetField(\"投信買賣超\",\"D\"),Length)

/Summation(GetField(\"Volume\",\"D\")-GetField(\"當日沖銷張數\",\"D\"),Length)\>0

Then

Retval=100\*Summation(GetField(\"投信買賣超\",\"D\"),Length)

/Summation(GetField(\"Volume\",\"D\")-GetField(\"當日沖銷張數\",\"D\"),Length);

## 場景 243：關聯券商開箱文 --- 以下是我試著寫的一個腳本

> 來源：[[關聯券商開箱文]{.underline}](https://www.xq.com.tw/xstrader/%e9%97%9c%e8%81%af%e5%88%b8%e5%95%86%e9%96%8b%e7%ae%b1%e6%96%87/)
> 說明：以下是我試著寫的一個腳本

condition1=false;

condition2=false;

value1=getField(\"關聯券商買賣超張數\", \"D\");

value2=getField(\"關鍵券商買賣超張數\", \"D\");

if trueall(value1\>500,3)

and value1/volume\>0.1

then

condition1=true;

if trueall(value2\>500,3)

and value2/volume\>0.1

then

condition2=true;

if condition1 or condition2

then ret=1;

## 場景 244：走進網友的交易室6-使用交易模組進行空單自動交易設定 --- {交易腳本只能使用日頻率，無法使用周頻率空方邏輯：股價剛跌破週20MA。空停損、利邏輯：1.突破週20MA or 2.突破日20MA or 3.突破前一週K棒的\...

> 來源：[[走進網友的交易室6-使用交易模組進行空單自動交易設定]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a46-%e4%bd%bf%e7%94%a8%e4%ba%a4%e6%98%93%e6%a8%a1%e7%b5%84%e9%80%b2%e8%a1%8c%e7%a9%ba%e5%96%ae%e8%87%aa%e5%8b%95%e4%ba%a4%e6%98%93/)
> 說明：{交易腳本只能使用日頻率，無法使用周頻率空方邏輯：股價剛跌破週20MA。空停損、利邏輯：1.突破週20MA
> or 2.突破日20MA or 3.突破前一週K棒的高點 。}

input:days(100,"日線頻率");

input:vvolume(2,"爆量倍數");

## 場景 245：走進網友的交易室6-使用交易模組進行空單自動交易設定 --- input:days(100,"日線頻率");input:vvolume(2,"爆量倍數");

> 來源：[[走進網友的交易室6-使用交易模組進行空單自動交易設定]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a46-%e4%bd%bf%e7%94%a8%e4%ba%a4%e6%98%93%e6%a8%a1%e7%b5%84%e9%80%b2%e8%a1%8c%e7%a9%ba%e5%96%ae%e8%87%aa%e5%8b%95%e4%ba%a4%e6%98%93/)
> 說明：input:days(100,"日線頻率");input:vvolume(2,"爆量倍數");

value1=average(c,100); //100日換算為周線為20周

value2=average(c,4); //4週換算為20日均線

## 場景 246：走進網友的交易室6-使用交易模組進行空單自動交易設定 --- value1=average(c,100); //100日換算為周線為20周value2=average(c,4); //4週換算為20日均線

> 來源：[[走進網友的交易室6-使用交易模組進行空單自動交易設定]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a46-%e4%bd%bf%e7%94%a8%e4%ba%a4%e6%98%93%e6%a8%a1%e7%b5%84%e9%80%b2%e8%a1%8c%e7%a9%ba%e5%96%ae%e8%87%aa%e5%8b%95%e4%ba%a4%e6%98%93/)
> 說明：value1=average(c,100);
> //100日換算為周線為20周value2=average(c,4); //4週換算為20日均線

//進場條件

condition1=c\<=value1; //收盤價小於100日均線(20周)

condition2=c\>value1; //收盤價大於等於100日均線(20周)

condition3=v\>=summation(v\[1\],5)\*vvolume; //爆量倍數

## 場景 247：走進網友的交易室6-使用交易模組進行空單自動交易設定 --- //進場條件condition1=c\<=value1; //收盤價小於100日均線(20周)condition2=c\>value1; //收盤價大於等於100日\...

> 來源：[[走進網友的交易室6-使用交易模組進行空單自動交易設定]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a46-%e4%bd%bf%e7%94%a8%e4%ba%a4%e6%98%93%e6%a8%a1%e7%b5%84%e9%80%b2%e8%a1%8c%e7%a9%ba%e5%96%ae%e8%87%aa%e5%8b%95%e4%ba%a4%e6%98%93/)
> 說明：//進場條件condition1=c\<=value1;
> //收盤價小於100日均線(20周)condition2=c\>value1;
> //收盤價大於等於100日均線(20周)condition3=v\>=summation(v\[1\],5)\*vvolume;
> //爆量倍數

//出場條件

condition4=c\[1\]\<=value1\[1\] and c\>value1; //突破週20MA

condition5=c\[1\]\<=value2\[1\] and c\>value2; //突破日20MA

condition6=c\>H\[1\]; //突破前K棒高點

## 場景 248：走進網友的交易室6-使用交易模組進行空單自動交易設定 --- //出場條件condition4=c\[1\]\<=value1\[1\] and c\>value1; //突破週20MAcondition5=c\[1\]\<=value2\[\...

> 來源：[[走進網友的交易室6-使用交易模組進行空單自動交易設定]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a46-%e4%bd%bf%e7%94%a8%e4%ba%a4%e6%98%93%e6%a8%a1%e7%b5%84%e9%80%b2%e8%a1%8c%e7%a9%ba%e5%96%ae%e8%87%aa%e5%8b%95%e4%ba%a4%e6%98%93/)
> 說明：//出場條件condition4=c\[1\]\<=value1\[1\] and c\>value1;
> //突破週20MAcondition5=c\[1\]\<=value2\[1\] and c\>value2;
> //突破日20MAcondition6=c\>H\[1\]; //突破前K棒高點

if trueAll(condition2\[1\],2) and condition1 and condition3 then
setposition(-1);

## 場景 249：走進網友的交易室6-使用交易模組進行空單自動交易設定 --- if trueAll(condition2\[1\],2) and condition1 and condition3 then setposition(-1);

> 來源：[[走進網友的交易室6-使用交易模組進行空單自動交易設定]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a46-%e4%bd%bf%e7%94%a8%e4%ba%a4%e6%98%93%e6%a8%a1%e7%b5%84%e9%80%b2%e8%a1%8c%e7%a9%ba%e5%96%ae%e8%87%aa%e5%8b%95%e4%ba%a4%e6%98%93/)
> 說明：if trueAll(condition2\[1\],2) and condition1 and condition3 then
> setposition(-1);

if Position \< 0 and (condition4 or condition5 or condition6) then
setposition(0);

## 場景 250：走進網友的交易室5-使用交易模組進行多單自動交易設定 --- {交易腳本只能使用日頻率，無法使用周頻率多方邏輯：股價剛站上 週20MA。多停損、利邏輯：1.跌破週20MA or 2.跌破日20MA or 3.跌破前一週K棒\...

> 來源：[[走進網友的交易室5-使用交易模組進行多單自動交易設定]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a45-%e4%bd%bf%e7%94%a8%e4%ba%a4%e6%98%93%e6%a8%a1%e7%b5%84%e9%80%b2%e8%a1%8c%e5%a4%9a%e5%96%ae%e8%87%aa%e5%8b%95%e4%ba%a4%e6%98%93/)
> 說明：{交易腳本只能使用日頻率，無法使用周頻率多方邏輯：股價剛站上
> 週20MA。多停損、利邏輯：1.跌破週20MA or 2.跌破日20MA or
> 3.跌破前一週K棒的低點 。}

input:days(100,"日線頻率");

input:vvolume(2,"爆量倍數");

## 場景 251：走進網友的交易室5-使用交易模組進行多單自動交易設定 --- value1=average(c,100); //100日換算為周線為20周

> 來源：[[走進網友的交易室5-使用交易模組進行多單自動交易設定]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a45-%e4%bd%bf%e7%94%a8%e4%ba%a4%e6%98%93%e6%a8%a1%e7%b5%84%e9%80%b2%e8%a1%8c%e5%a4%9a%e5%96%ae%e8%87%aa%e5%8b%95%e4%ba%a4%e6%98%93/)
> 說明：value1=average(c,100); //100日換算為周線為20周

//進場條件

condition1=c\<value1; //收盤價小於100日均線(20周)

condition2=c\>=value1; //收盤價大於等於100日均線(20周)

condition3=v\>=summation(v\[1\],5)\*vvolume; //爆量倍數

## 場景 252：走進網友的交易室5-使用交易模組進行多單自動交易設定 --- //進場條件condition1=c\<value1; //收盤價小於100日均線(20周)condition2=c\>=value1; //收盤價大於等於100日\...

> 來源：[[走進網友的交易室5-使用交易模組進行多單自動交易設定]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a45-%e4%bd%bf%e7%94%a8%e4%ba%a4%e6%98%93%e6%a8%a1%e7%b5%84%e9%80%b2%e8%a1%8c%e5%a4%9a%e5%96%ae%e8%87%aa%e5%8b%95%e4%ba%a4%e6%98%93/)
> 說明：//進場條件condition1=c\<value1;
> //收盤價小於100日均線(20周)condition2=c\>=value1;
> //收盤價大於等於100日均線(20周)condition3=v\>=summation(v\[1\],5)\*vvolume;
> //爆量倍數

//出場條件

value2=average(c,100); //100日換算為周線為20周

value3=average(c,20); //4週換算為20日均線

condition4=c\[1\]\>value2\[1\] and c\<value2; //1.跌破週20MA

condition5=c\[1\]\>value3\[1\] and c\<value3; //2.跌破日20MA

condition6=c\<l\[1\]; //3.跌破前一週K棒的低點

## 場景 253：走進網友的交易室5-使用交易模組進行多單自動交易設定 --- //出場條件value2=average(c,100); //100日換算為周線為20周value3=average(c,20); //4週換算為20日均線co\...

> 來源：[[走進網友的交易室5-使用交易模組進行多單自動交易設定]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a45-%e4%bd%bf%e7%94%a8%e4%ba%a4%e6%98%93%e6%a8%a1%e7%b5%84%e9%80%b2%e8%a1%8c%e5%a4%9a%e5%96%ae%e8%87%aa%e5%8b%95%e4%ba%a4%e6%98%93/)
> 說明：//出場條件value2=average(c,100);
> //100日換算為周線為20周value3=average(c,20);
> //4週換算為20日均線condition4=c\[1\]\>value2\[1\] and c\<value2;
> //1.跌破週20MAcondition5=c\[1\]\>value3\[1\] and c\<value3;
> //2.跌破日20MAcondition6=c\<l\[1\]; /\...

if trueAll(condition1\[1\],2) and condition2 and condition3 then
setposition(1);

## 場景 254：走進網友的交易室5-使用交易模組進行多單自動交易設定 --- if trueAll(condition1\[1\],2) and condition2 and condition3 then setposition(1);

> 來源：[[走進網友的交易室5-使用交易模組進行多單自動交易設定]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a45-%e4%bd%bf%e7%94%a8%e4%ba%a4%e6%98%93%e6%a8%a1%e7%b5%84%e9%80%b2%e8%a1%8c%e5%a4%9a%e5%96%ae%e8%87%aa%e5%8b%95%e4%ba%a4%e6%98%93/)
> 說明：if trueAll(condition1\[1\],2) and condition2 and condition3 then
> setposition(1);

if Position \> 0 and (condition4 or condition5 or condition6) then
setposition(0);

## 場景 255：走進網友的交易室1-使用XS打造多方警示策略的步驟

> 來源：[[走進網友的交易室1-使用XS打造多方警示策略的步驟]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a41-%e4%bd%bf%e7%94%a8xs%e6%89%93%e9%80%a0%e5%a4%9a%e6%96%b9%e7%ad%96%e7%95%a5%e7%9a%84%e6%ad%a5%e9%a9%9f/)
> 說明：多方警示腳本：

//此策略為週頻率

settotalBar(60);

input:days(20,"週線頻率");

input:vvolume(2,"週爆量倍數");

## 場景 256：走進網友的交易室1-使用XS打造多方警示策略的步驟 --- //此策略為週頻率settotalBar(60);input:days(20,"週線頻率");input:vvolume(2,"週爆量倍數");

> 來源：[[走進網友的交易室1-使用XS打造多方警示策略的步驟]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a41-%e4%bd%bf%e7%94%a8xs%e6%89%93%e9%80%a0%e5%a4%9a%e6%96%b9%e7%ad%96%e7%95%a5%e7%9a%84%e6%ad%a5%e9%a9%9f/)
> 說明：//此策略為週頻率settotalBar(60);input:days(20,"週線頻率");input:vvolume(2,"週爆量倍數");

value1=average(c,20);

condition1=c\<value1;

condition2=c\>=value1;

condition3=v\>=v\[1\]\*vvolume;

## 場景 257：走進網友的交易室1-使用XS打造多方警示策略的步驟

> 來源：[[走進網友的交易室1-使用XS打造多方警示策略的步驟]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a41-%e4%bd%bf%e7%94%a8xs%e6%89%93%e9%80%a0%e5%a4%9a%e6%96%b9%e7%ad%96%e7%95%a5%e7%9a%84%e6%ad%a5%e9%a9%9f/)
> 說明：多方停損、停利腳本：

//此策略為週頻率

settotalBar(60);

input:days(20,"週線頻率");

input:vvolume(2,"週爆量倍數");

input:bs(1,"停損利方式",inputkind:=dict(\["跌破週20MA",1\],\["跌破日20MA",2\],\["跌破前K棒低點",3\]));

## 場景 258：走進網友的交易室1-使用XS打造多方警示策略的步驟 --- //此策略為週頻率settotalBar(60);input:days(20,"週線頻率");input:vvolume(2,"週爆量倍數");input:bs\...

> 來源：[[走進網友的交易室1-使用XS打造多方警示策略的步驟]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a41-%e4%bd%bf%e7%94%a8xs%e6%89%93%e9%80%a0%e5%a4%9a%e6%96%b9%e7%ad%96%e7%95%a5%e7%9a%84%e6%ad%a5%e9%a9%9f/)
> 說明：//此策略為週頻率settotalBar(60);input:days(20,"週線頻率");input:vvolume(2,"週爆量倍數");input:bs(1,"停損利方式",inputkind:=dict(\["跌破週20MA",1\],\["跌破日20MA",2\],\["跌破前K棒低點",3\]));

value1=average(c,20);

value2=average(c,4);//4週換算為20日均線

condition1=c\[1\]\>value1\[1\] and c\<value1;

condition2=c\>=value1;

condition3=v\>=v\[1\]\*vvolume;

condition4=c\[1\]\>value2\[1\] and c\<value2;

condition5=c\[1\]\>l\[1\] and c\<l\[1\];

## 場景 259：走進網友的交易室1-使用XS打造多方警示策略的步驟 --- value1=average(c,20);value2=average(c,4);//4週換算為20日均線condition1=c\[1\]\>value1\[1\] a\...

> 來源：[[走進網友的交易室1-使用XS打造多方警示策略的步驟]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a41-%e4%bd%bf%e7%94%a8xs%e6%89%93%e9%80%a0%e5%a4%9a%e6%96%b9%e7%ad%96%e7%95%a5%e7%9a%84%e6%ad%a5%e9%a9%9f/)
> 說明：value1=average(c,20);value2=average(c,4);//4週換算為20日均線condition1=c\[1\]\>value1\[1\]
> and
> c\<value1;condition2=c\>=value1;condition3=v\>=v\[1\]\*vvolume;condition4=c\[1\]\>value2\[1\]
> and c\<value2;condition5=c\[1\]\>l\[1\] \...

if bs=1 then if condition1 then ret=1;

if bs=2 then if condition4 then ret=1;

if bs=3 then if condition5 then ret=1;

## 場景 260：走進網友的交易室2-使用XS打造空方警示策略的步驟 --- 接下來製作盤中警示條件：本文先介紹「空方」買賣腳本，作用為盤中跳出提醒標的符合資格；自動下單的範本後續提供。

> 來源：[[走進網友的交易室2-使用XS打造空方警示策略的步驟]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e7%b6%b2%e5%8f%8b%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a42-%e4%bd%bf%e7%94%a8xs%e6%89%93%e9%80%a0%e7%a9%ba%e6%96%b9%e8%ad%a6%e7%a4%ba%e7%ad%96%e7%95%a5%e7%9a%84%e6%ad%a5%e9%a9%9f/)
> 說明：接下來製作盤中警示條件：本文先介紹「空方」買賣腳本，作用為盤中跳出提醒標的符合資格；自動下單的範本後續提供。

//此策略為週頻率

input:days(20,\"週線頻率\");

input:vvolume(1,\"週爆量倍數\");

value1=average(c,20);

condition1=c\<=value1;

condition2=c\>value1;

condition3=v\>=v\[1\]\*vvolume;

if trueAll(condition2\[1\],2) and condition1 and condition3 then ret=1;

## 場景 261：股市傳說實驗室29\~整理結束創新高的好公司 --- 要符合上述條件，我寫的腳本如下：

> 來源：[[股市傳說實驗室29\~整理結束創新高的好公司]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a429%e6%95%b4%e7%90%86%e7%b5%90%e6%9d%9f%e5%89%b5%e6%96%b0%e9%ab%98%e7%9a%84%e5%a5%bd%e5%85%ac%e5%8f%b8/)
> 說明：要符合上述條件，我寫的腳本如下：

value1=lowest(low,90);

if value1=low\[89\]

//波段低點跟前一日一樣，代表未再創新低

and highest(high\[1\],90)\<=value1\*(1+20/100)

//波段高點跟波段低點之間沒有隔太遠

and close crosses over highest(close\[1\],90)

//股價突破波段的高點

then ret=1;

## 場景 262：股市傳說實驗室28\~夏藍選股法 --- 一、五年內至少三年營收成長

> 來源：[[股市傳說實驗室28\~夏藍選股法]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a428%e5%a4%8f%e8%98%ad%e9%81%b8%e8%82%a1%e6%b3%95/)
> 說明：一、五年內至少三年營收成長

value1=GetField(\"營業收入淨額\",\"Y\");

value2=value1-value1\[1\];

if countif(value2\>0,5)\>=3

then ret=1;

## 場景 263：股市傳說實驗室28\~夏藍選股法 --- 二、過去三年來自營運的現金流量都大於零

> 來源：[[股市傳說實驗室28\~夏藍選股法]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a428%e5%a4%8f%e8%98%ad%e9%81%b8%e8%82%a1%e6%b3%95/)
> 說明：二、過去三年來自營運的現金流量都大於零

value1=GetField(\"來自營運之現金流量\",\"Y\");

if trueall(value1\>0,3)

then ret=1;

## 場景 264：股市傳說實驗室28\~夏藍選股法 --- 三、資產報酬率呈上升趨勢

> 來源：[[股市傳說實驗室28\~夏藍選股法]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a428%e5%a4%8f%e8%98%ad%e9%81%b8%e8%82%a1%e6%b3%95/)
> 說明：三、資產報酬率呈上升趨勢

value1=GetField(\"資產報酬率\",\"Q\");

value2=average(value1,4);

value3=linearregslope(value2,5);

if value3\>0

then ret=1;

## 場景 265：股市傳說實驗室27\~超跌股的報復性上漲 --- 一、股價距離合理價格很遠

> 來源：[[股市傳說實驗室27\~超跌股的報復性上漲]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a427%e8%b6%85%e8%b7%8c%e8%82%a1%e7%9a%84%e5%a0%b1%e5%be%a9%e6%80%a7%e4%b8%8a%e6%bc%b2/)
> 說明：一、股價距離合理價格很遠

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

## 場景 266：股市傳說實驗室27\~超跌股的報復性上漲 --- 二、股價最近開始出量上漲

> 來源：[[股市傳說實驗室27\~超跌股的報復性上漲]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a427%e8%b6%85%e8%b7%8c%e8%82%a1%e7%9a%84%e5%a0%b1%e5%be%a9%e6%80%a7%e4%b8%8a%e6%bc%b2/)
> 說明：二、股價最近開始出量上漲

Input: day(20,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 267：股市傳說實驗室25\~大跌後的主力回頭收集

> 來源：[[股市傳說實驗室25\~大跌後的主力回頭收集]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a425%e5%a4%a7%e8%b7%8c%e5%be%8c%e7%9a%84%e4%b8%bb%e5%8a%9b%e5%9b%9e%e9%a0%ad%e6%94%b6%e9%9b%86/)
> 說明：用的腳本如下

input:period(10);

value1=GetField(\"分公司賣出家數\")\[1\];

value2=GetField(\"分公司買進家數\")\[1\];

if linearregslope(value1,period)\>0

//賣出的家數愈來愈多

and linearregslope(value2,period)\<0

//買進的家數愈來愈少

and

close\*1.05\<close\[period\]

//但這段期間股價在跌

and close\*1.283\<close\[30\]

and close\*1.782\>close\[30\]

//波段跌幅夠大

then ret=1;

## 場景 268：股市傳說實驗室24\~ADX翻轉的績優股 --- 這當中有一個XS的腳本，我列在下方：

> 來源：[[股市傳說實驗室24\~ADX翻轉的績優股]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a424adx%e7%bf%bb%e8%bd%89%e7%9a%84%e7%b8%be%e5%84%aa%e8%82%a1/)
> 說明：這當中有一個XS的腳本，我列在下方：

input: Length(14,\"期數\");

variable: pdi_value(0), ndi_value(0), adx_value(0);

DirectionMovement(Length, pdi_value, ndi_value, adx_value);

value1=average(adx_value,5);

if linearregslope(value1,20)\<0

//有一陣子ADX的趨勢向下

and linearregslope(value1,10)cross over 0

//但近期的ADX趨勢轉向上

then ret=1;

## 場景 269：股市傳說實驗室21\~股價很久以來第一次站上20元可不可以衝一波？ --- 這是一個腳本條件，腳本如下：

> 來源：[[股市傳說實驗室21\~股價很久以來第一次站上20元可不可以衝一波？]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a421%e8%82%a1%e5%83%b9%e5%be%88%e4%b9%85%e4%bb%a5%e4%be%86%e7%ac%ac%e4%b8%80%e6%ac%a1%e7%ab%99%e4%b8%8a20%e5%85%83%e5%8f%af%e4%b8%8d/)
> 說明：這是一個腳本條件，腳本如下：

setbackbar(100);

input:period(100,\"維持原價位區間的天數\");

value1=intportion(close/10);

if trueall(value1\[1\]=value1\[2\],period)

and value1\[1\]=1

and value1\>value1\[1\]

then ret=1;

## 場景 270：股市傳說實驗室18\~暴量上漲是不是個作多訊號？ --- 基於這四點，我寫了一個腳本如下：

> 來源：[[股市傳說實驗室18\~暴量上漲是不是個作多訊號？]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a418%e6%9a%b4%e9%87%8f%e4%b8%8a%e6%bc%b2%e6%98%af%e4%b8%8d%e6%98%af%e5%80%8b%e4%bd%9c%e5%a4%9a%e8%a8%8a%e8%99%9f/)
> 說明：基於這四點，我寫了一個腳本如下：

value1=GetField(\"成交金額(元)\",\"D\");

value2=GetSymbolField(\"tse.tw\",\"成交金額(元)\",\"D\");

if value2\<\>0 then

value3=value1/value2\*100;

value4=GetField(\"股本(億)\",\"D\");

value5=GetField(\"投信買賣超\",\"D\");

setbackbar(20);

input:length(20);

variable:up1(0);

up1 = bollingerband(value3, Length, 2 );

if

value4\>10 and value4\<40

//股本在10億到40億之間

and

value3 crosses over up1

//資金流向突破布林值上限

and close\>close\[1\]

//量暴增而且股價上漲

and close\<close\[1\]\*1.05

//但漲幅沒有非常大

and value5\>200

//投信買超大於200張

and value1\>80000000

//成交值大於8000萬

then ret=1;

## 場景 271：自訂指標之董監持股比例 --- 前一篇畫了一張董監持股比例的圖，有網友反映這個指標目前XQ好像沒有支援，問說這圖要在那裡才看得到，這個指標是我自己訂的，腳本如下

> 來源：[[自訂指標之董監持股比例]{.underline}](https://www.xq.com.tw/xstrader/%e8%87%aa%e8%a8%82%e6%8c%87%e6%a8%99%e4%b9%8b%e8%91%a3%e7%9b%a3%e6%8c%81%e8%82%a1%e6%af%94%e4%be%8b/)
> 說明：前一篇畫了一張董監持股比例的圖，有網友反映這個指標目前XQ好像沒有支援，問說這圖要在那裡才看得到，這個指標是我自己訂的，腳本如下

value1=getField(\"董監持股佔股本比例\", \"M\");

value2=getField(\"董監持股佔股本比例\", \"M\")

-getField(\"董監持股佔股本比例\", \"M\")\[1\];

plot1(value1,\"董監持股比例\");

plot2(value2,\"變動值\");

## 場景 272：股市傳說實驗室16\~週RSI低檔回昇 --- 我把這樣的想法寫成以下的腳本：

> 來源：[[股市傳說實驗室16\~週RSI低檔回昇]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a416%e9%80%b1rsi%e4%bd%8e%e6%aa%94%e5%9b%9e%e5%8d%87/)
> 說明：我把這樣的想法寫成以下的腳本：

if barfreq\<\>\"W\" then raiseRunTimeError(\"請改用週頻率\");

input:period(8,\"期間\");

value1=rsi(close,period);

if value1 cross over 20

then ret=1;

## 場景 273：股市傳說實驗室15\~地緣券商買超到底有沒有參考價值？ --- 下面這個腳本是地緣券商連續五天買超大於200張：

> 來源：[[股市傳說實驗室15\~地緣券商買超到底有沒有參考價值？]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a415%e5%9c%b0%e7%b7%a3%e5%88%b8%e5%95%86%e8%b2%b7%e8%b6%85%e5%88%b0%e5%ba%95%e6%9c%89%e6%b2%92%e6%9c%89%e5%8f%83%e8%80%83%e5%83%b9/)
> 說明：下面這個腳本是地緣券商連續五天買超大於200張：

input:period(5,\"最近n日\");

value1=GetField(\"地緣券商買賣超張數\",\"D\");

if trueall(value1\>200,period)

then ret=1;

## 場景 274：股市傳說實驗室14\~本益比位於五年低位區 --- 根據這樣的說法，我寫了一個腳本如下，用來找出目前股價對應的本益比位低於五年低位區。

> 來源：[[股市傳說實驗室14\~本益比位於五年低位區]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a414%e6%9c%ac%e7%9b%8a%e6%af%94%e4%bd%8d%e6%96%bc%e4%ba%94%e5%b9%b4%e4%bd%8e%e4%bd%8d%e5%8d%80/)
> 說明：根據這樣的說法，我寫了一個腳本如下，用來找出目前股價對應的本益比位低於五年低位區。

value1=lowest(getField(\"本益比\", \"D\"),200);

value2=lowest(getField(\"本益比\", \"D\"),400);

value3=lowest(getField(\"本益比\", \"D\"),600);

value4=lowest(getField(\"本益比\", \"D\"),800);

value5=lowest(getField(\"本益比\", \"D\"),1000);

value6=(value1+value2+value3+value4+value5)/5;

if getField(\"本益比\", \"D\")\<value6\*1.1

then ret=1;

## 場景 275：股市傳說實驗室13\~PB接近五年低點且法人買超 --- 首先一樣是先寫個腳本來找那些股價淨值比在五年低點附近的股票：

> 來源：[[股市傳說實驗室13\~PB接近五年低點且法人買超]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a413pb%e6%8e%a5%e8%bf%91%e4%ba%94%e5%b9%b4%e4%bd%8e%e9%bb%9e%e4%b8%94%e6%b3%95%e4%ba%ba%e8%b2%b7%e8%b6%85/)
> 說明：首先一樣是先寫個腳本來找那些股價淨值比在五年低點附近的股票：

input:r1(5,\"PB距離N個月來低點只剩N%\");

input:r2(60,\"N個月以來\");

setbarfreq(\"M\");

if barfreq \<\> \"M\" then raiseruntimeerror(\"頻率錯誤\");

value1=GetField(\"股價淨值比\",\"M\");

value2=lowest(GetField(\"股價淨值比\",\"M\"),r2);

value3=average(GetField(\"股價淨值比\",\"M\"),r2);

if value1 \< value3 and value1 \< value2\*(1+r1/100)

then ret=1;

## 場景 276：股市傳說實驗室12\~大股東連續買超 --- 接下來對照這個概念的腳本如下：

> 來源：[[股市傳說實驗室12\~大股東連續買超]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a412%e5%a4%a7%e8%82%a1%e6%9d%b1%e9%80%a3%e7%ba%8c%e8%b2%b7%e8%b6%85/)
> 說明：接下來對照這個概念的腳本如下：

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

if trueall(value1\>500,4)

then ret=1;

outputfield(1,value1,0,\"關鍵券商買超張數\");

## 場景 277：股市傳說實驗室10\~過去的現金流量比現在的市值高 --- 我寫了以下的腳本，想要來回測看看：

> 來源：[[股市傳說實驗室10\~過去的現金流量比現在的市值高]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a410%e9%81%8e%e5%8e%bb%e7%9a%84%e7%8f%be%e9%87%91%e6%b5%81%e9%87%8f%e6%af%94%e7%8f%be%e5%9c%a8%e7%9a%84%e5%b8%82%e5%80%bc%e9%ab%98/)
> 說明：我寫了以下的腳本，想要來回測看看：

value1=getField(\"來自營運之現金流量\",
\"Y\")+getField(\"來自營運之現金流量\", \"Y\")\[1\]

+getField(\"來自營運之現金流量\",
\"Y\")\[2\]+getField(\"來自營運之現金流量\", \"Y\")\[3\]

+getField(\"來自營運之現金流量\",
\"Y\")\[4\]+getField(\"來自營運之現金流量\", \"Y\")\[5\]

+getField(\"來自營運之現金流量\",
\"Y\")\[6\]+getField(\"來自營運之現金流量\", \"Y\")\[7\]

+getField(\"來自營運之現金流量\",
\"Y\")\[8\]+getField(\"來自營運之現金流量\", \"Y\")\[9\];

//過去十年來自營運之現金流量總和,單位百萬

value2=getField(\"總市值(億)\", \"D\");

input:ratio(80,\"折價比例\");

if (value1/100)/value2\>=(1+ratio/100)

then ret=1;

outputfield(1,value1/100,0,\"十年營運現金流總和(億)\");

outputfield(2,value2,0,\"總市值(億)\");

outputfield(3,(value1/100)/value2,2,\"佔比\");

## 場景 278：股市傳說實驗室9\~增資股即將出籠 --- 為了驗證這個江湖傳說，我寫了以下的腳本：

> 來源：[[股市傳說實驗室9\~增資股即將出籠]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a49%e5%a2%9e%e8%b3%87%e8%82%a1%e5%8d%b3%e5%b0%87%e5%87%ba%e7%b1%a0/)
> 說明：為了驗證這個江湖傳說，我寫了以下的腳本：

value1=GetField(\"現增新股上市日\");

value2=GetField(\"現增比率\");//每千股可認股數

value3=GetField(\"現增價格\");

value4=GetField(\"融券餘額張數\",\"D\");

value5=GetField(\"普通股股本\",\"Q\");//單位:億

if value1\>date and datediff(value1,date)\<2//增資股快上市了

and

value5\*10000\*value2/1000\>10000//增資張數大於10000張

and

value4\[30\]\>value4-1000//近一個月融券增加沒有超過1000張

and

value3\*1.1\<close//股價仍比現增價格高超過一成

then ret=1;

outputfield(1,value1,0,\"新股上市日\");

outputfield(2,value2,0,\"現增比率\");

outputfield(3,close-value3,0,\"現增價差\");

## 場景 279：股市傳說實驗室8\~籌碼鎖定率夠高且站上布林值上緣

> 來源：[[股市傳說實驗室8\~籌碼鎖定率夠高且站上布林值上緣]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a48%e7%b1%8c%e7%a2%bc%e9%8e%96%e5%ae%9a%e7%8e%87%e5%a4%a0%e9%ab%98%e4%b8%94%e7%ab%99%e4%b8%8a%e5%b8%83%e6%9e%97%e5%80%bc%e4%b8%8a%e7%b7%a3/)
> 說明：我寫的腳本如下：

value1=GetField(\"籌碼鎖定率\",\"D\");

Input: Length(20, \"期數\"), UpperBand(2, \"通道上緣\");

settotalbar(3);

if value1 \>= 7

and close \>= bollingerband(Close, Length, UpperBand)

then ret=1;

## 場景 280：股市傳說實驗室8\~籌碼鎖定率夠高且站上布林值上緣 --- 如果是單純的K棒突破布林值上緣：

> 來源：[[股市傳說實驗室8\~籌碼鎖定率夠高且站上布林值上緣]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a48%e7%b1%8c%e7%a2%bc%e9%8e%96%e5%ae%9a%e7%8e%87%e5%a4%a0%e9%ab%98%e4%b8%94%e7%ab%99%e4%b8%8a%e5%b8%83%e6%9e%97%e5%80%bc%e4%b8%8a%e7%b7%a3/)
> 說明：如果是單純的K棒突破布林值上緣：

close cross Above bollingerband(Close, Length, UpperBand)

## 場景 281：股市傳說實驗室7\~法人持續買超的低價股

> 來源：[[股市傳說實驗室7\~法人持續買超的低價股]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a47%e6%b3%95%e4%ba%ba%e6%8c%81%e7%ba%8c%e8%b2%b7%e8%b6%85%e7%9a%84%e4%bd%8e%e5%83%b9%e8%82%a1/)
> 說明：我寫的腳本如下：

value1=getField(\"法人買賣超張數\", \"D\");

input:period(12);

if close\<highest(close,period)

//股價低於計算區間的最高點

and countif(value1\>0,period)\>period\*0.75

//3/4的日子裡法人買超

and value1\>1000

//近一個交易日法人買超達1000張以上

and value1\[1\]\>800

//前一個交易日法人買超達800張以上

and close\<40

then ret=1;

## 場景 282：股市傳說實驗室6\~指標同步翻多 --- 要符合上述三個條件，我寫了以下的腳本：

> 來源：[[股市傳說實驗室6\~指標同步翻多]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a46%e6%8c%87%e6%a8%99%e5%90%8c%e6%ad%a5%e7%bf%bb%e5%a4%9a/)
> 說明：要符合上述三個條件，我寫了以下的腳本：

input: Length_D(9,\"日KD期間\");

variable:rsv_d(0),kk_d(0),dd_d(0),c5(0);

stochastic(Length_D, 3, 3, rsv_d, kk_d, dd_d);

input:FastLength(12, \"DIF短期期數\");

input:SlowLength(26, \"DIF長期期數\");

input:MACDLength(9, \"MACD期數\");

variable: difValue(0), macdValue(0), oscValue(0);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

if kk_d crosses over dd_d

and kk_d\<30

and oscValue Crosses Above 0

and rsi(close,10)\>=50

then ret=1;

這個腳本回測過去七年，停損停利都設為7%，回測報告如下：

## 場景 283：股市傳說實驗室6\~指標同步翻多 --- 我有試著把RSI這條件拿掉，改成近5日RSI趨勢是往上。

> 來源：[[股市傳說實驗室6\~指標同步翻多]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a46%e6%8c%87%e6%a8%99%e5%90%8c%e6%ad%a5%e7%bf%bb%e5%a4%9a/)
> 說明：我有試著把RSI這條件拿掉，改成近5日RSI趨勢是往上。

and linearRegSlope(rsi(close,10),5)\>0

## 場景 284：股市傳說實驗室6\~指標同步翻多 --- 我們使用這樣的概念，再配合主力買超佔成交量兩成這個條件，可以寫出以下的腳本：

> 來源：[[股市傳說實驗室6\~指標同步翻多]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a46%e6%8c%87%e6%a8%99%e5%90%8c%e6%ad%a5%e7%bf%bb%e5%a4%9a/)
> 說明：我們使用這樣的概念，再配合主力買超佔成交量兩成這個條件，可以寫出以下的腳本：

input: Length(24, \"天數\");

Variable: hp(0), lp(0), numerator(0), denominator(0), \_vhf(0);

hp = highest(Close, Length);

lp = lowest(Close, Length);

numerator = hp - lp;

denominator = Summation(absvalue((Close - Close\[1\])), Length);

if denominator \<\> 0 then

\_vhf = numerator / denominator

else

\_vhf = 0;

input:period(14); setinputname(1,\"計算期數\");

variable: pdi(0), ndi(0), adx_value(0);

DirectionMovement(period, pdi, ndi, adx_value);

value1=getField(\"主力買賣超張數\", \"D\");

if volume\<\>0 then

value2=value1/volume\*100;

if pdi\>pdi\[1\] and ndi\<ndi\[1\] and pdi crosses over ndi

and rsi(\_vhf,5)\>70

and value2\>=20

then ret=1;

## 場景 285：股市傳說實驗室5\~分點重押好股 --- 綜合KOL的說法，我寫成選股腳本如下：

> 來源：[[股市傳說實驗室5\~分點重押好股]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a45%e5%88%86%e9%bb%9e%e9%87%8d%e6%8a%bc%e5%a5%bd%e8%82%a1/)
> 說明：綜合KOL的說法，我寫成選股腳本如下：

value1=getField(\"分公司淨買超金額家數\", \"D\");

value2=getField(\"分公司淨賣超金額家數\", \"D\");

value3=getField(\"主力買賣超張數\", \"D\");

value4=getField(\"累計營收年增率\", \"M\");

value5=getField(\"月營收年增率\", \"M\");

if volume\<\>0

then value6=value3/volume\*100;

if value1\*2\<=value2

//買家數不到賣家數的一半

and countif(value2\>value1,20)\>12

//過去20天籌碼被收集的天數大於12天

and value6\>=10

//主力買超佔成交量超過一成

and value4\>0

//累計營收年增率大於0

and value5\>5

//月營收年增率大於5%

and close\>average(close,60)

//股價在季線之上

then ret=1;

## 場景 286：股市傳說實驗室4\~營收三連增法人主力爭買 --- 我把上述五個條件寫成腳本如下：

> 來源：[[股市傳說實驗室4\~營收三連增法人主力爭買]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a44%e7%87%9f%e6%94%b6%e4%b8%89%e9%80%a3%e5%a2%9e%e6%b3%95%e4%ba%ba%e4%b8%bb%e5%8a%9b%e7%88%ad%e8%b2%b7/)
> 說明：我把上述五個條件寫成腳本如下：

value2=getField(\"法人買賣超張數\", \"D\");

value3=getField(\"主力買賣超張數\", \"D\");

value4=datevalue(currentdate,\"d\");

if value4\>10 and value4\<=15

then begin

if getField(\"月營收年增率\", \"M\")\>getField(\"月營收年增率\",
\"M\")\[1\]

and getField(\"月營收年增率\", \"M\")\[1\]\>getField(\"月營收年增率\",
\"M\")\[2\]

and getField(\"月營收年增率\", \"M\")\[2\]\>getField(\"月營收年增率\",
\"M\")\[3\]

and trueall(value2\>500,2)

and trueall(value3\>1000,2)

and close\> average(close,60)

then ret=1;

end;

這個腳本回測過去七年，停損停利俱用7%，勝率超過六成，總報酬率148%。

## 場景 287：股市傳說實驗室3\~營收公佈前主力大買超 --- 為了找到這些股票，我寫了一個腳本，專門在每個月的1號到10號，去找這段期最新一個月營收還沒有公佈，然後連續兩天主力買都超過1000張，且連續兩天主力買超佔成交量\...

> 來源：[[股市傳說實驗室3\~營收公佈前主力大買超]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a43%e7%87%9f%e6%94%b6%e5%85%ac%e4%bd%88%e5%89%8d%e4%b8%bb%e5%8a%9b%e5%a4%a7%e8%b2%b7%e8%b6%85/)
> 說明：為了找到這些股票，我寫了一個腳本，專門在每個月的1號到10號，去找這段期最新一個月營收還沒有公佈，然後連續兩天主力買都超過1000張，且連續兩天主力買超佔成交量超過兩成的股票。

var:dd(\" \");

var:dr(\" \");

dd=datetostring(currentdate);

dr=rightstr(dd,2);

value11=strtonum(dr);

input:d1(1,\"起始日\");

input:d2(10,\"截止日\");

if value11\>=d1

and value11\<=d2

then begin

value1=getFieldDate(\"月營收\", \"M\");

//取得月營收日期

value2=datevalue(date,\"M\");

//取得最近一根K棒的月份數值

value3=datevalue(value1,\"M\");

//取得月營收日期的月份數值

value4=getField(\"主力買賣超張數\", \"D\");

if volume\<\>0 then

value5=value4/volume\*100;

if value2-value3=2

//如果K棒月份數值比公佈的數值差2

and trueall(value4\>1000,2)

and trueall(value5\>20,2)

then ret=1;

end;

## 場景 288：股市傳說實驗室3\~營收公佈前主力大買超 --- 勝率是58%，MDD是-18%，這已經是一個可以往下繼續深化的交易策略，我根據坊間KOL的教學，加上一個股價必須在季線之上的條件：

> 來源：[[股市傳說實驗室3\~營收公佈前主力大買超]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a43%e7%87%9f%e6%94%b6%e5%85%ac%e4%bd%88%e5%89%8d%e4%b8%bb%e5%8a%9b%e5%a4%a7%e8%b2%b7%e8%b6%85/)
> 說明：勝率是58%，MDD是-18%，這已經是一個可以往下繼續深化的交易策略，我根據坊間KOL的教學，加上一個股價必須在季線之上的條件：

and close\> average(close,60)

## 場景 289：股市傳說實驗室2\~投信認養股 --- 接著第二個條件是股價要突破投信成本區：

> 來源：[[股市傳說實驗室2\~投信認養股]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a42%e6%8a%95%e4%bf%a1%e8%aa%8d%e9%a4%8a%e8%82%a1/)
> 說明：接著第二個條件是股價要突破投信成本區：

if close cross over getField(\"投信成本\", \"D\")

then ret=1;

## 場景 290：股市傳說實驗室1\~關於外資認養股 --- 首先先寫一個突破外資成本線的腳本：

> 來源：[[股市傳說實驗室1\~關於外資認養股]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a41%e9%97%9c%e6%96%bc%e5%a4%96%e8%b3%87%e8%aa%8d%e9%a4%8a%e8%82%a1/)
> 說明：首先先寫一個突破外資成本線的腳本：

value1=getField(\"外資成本\", \"D\");

if close cross over value1 then ret=1;

## 場景 291：股市傳說實驗室1\~關於外資認養股 --- 我先前寫過一個外資鍾愛股連買三天的選股策略：

> 來源：[[股市傳說實驗室1\~關於外資認養股]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a41%e9%97%9c%e6%96%bc%e5%a4%96%e8%b3%87%e8%aa%8d%e9%a4%8a%e8%82%a1/)
> 說明：我先前寫過一個外資鍾愛股連買三天的選股策略：

value1=GetField(\"外資買賣超\");

value2=GetField(\"外資持股比例\");

if value2\>10

and trueall(value1\>500,3)

and barslast(trueall(value1\>1000,3))\[1\]\>20

then ret=1;

## 場景 292：股市傳說實驗室1\~關於外資認養股 --- 另外再加上暴量剛起漲這個條件：

> 來源：[[股市傳說實驗室1\~關於外資認養股]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%b8%82%e5%82%b3%e8%aa%aa%e5%af%a6%e9%a9%97%e5%ae%a41%e9%97%9c%e6%96%bc%e5%a4%96%e8%b3%87%e8%aa%8d%e9%a4%8a%e8%82%a1/)
> 說明：另外再加上暴量剛起漲這個條件：

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

## 場景 293：機會比風險大的選股策略系列之5：10年現金流量總和遠高於市值

> 來源：[[機會比風險大的選股策略系列之5：10年現金流量總和遠高於市值]{.underline}](https://www.xq.com.tw/xstrader/%e6%a9%9f%e6%9c%83%e6%af%94%e9%a2%a8%e9%9a%aa%e5%a4%a7%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b510%e5%b9%b4%e7%8f%be%e9%87%91%e6%b5%81%e9%87%8f%e7%b8%bd%e5%92%8c/)
> 說明：其中的腳本如下：

value1=getField(\"來自營運之現金流量\",
\"Y\")+getField(\"來自營運之現金流量\", \"Y\")\[1\]

+getField(\"來自營運之現金流量\",
\"Y\")\[2\]+getField(\"來自營運之現金流量\", \"Y\")\[3\]

+getField(\"來自營運之現金流量\",
\"Y\")\[4\]+getField(\"來自營運之現金流量\", \"Y\")\[5\]

+getField(\"來自營運之現金流量\",
\"Y\")\[6\]+getField(\"來自營運之現金流量\", \"Y\")\[7\]

+getField(\"來自營運之現金流量\",
\"Y\")\[8\]+getField(\"來自營運之現金流量\", \"Y\")\[9\];

//過去十年來自營運之現金流量總和,單位百萬

value2=getField(\"總市值(億)\", \"D\");

input:ratio(80,\"折價比例\");

if (value1/100)/value2\>=(1+ratio/100)

then ret=1;

outputfield(1,value1/100,0,\"十年營運現金流總和(億)\");

outputfield(2,value2,0,\"總市值(億)\");

outputfield(3,(value1/100)/value2,2,\"佔比\");

這個腳本的概念就是去計算過去十年，來自營運的現金流量總和，看看是不是超出目前總市值一定的比例。

用上述的選股策略去跑上市普通股減KY股的回測，停損設20%，停利設30%。

回測的結果如下：

## 場景 294：機會比風險大的選股策略系列之4：總市值研發費用比夠低的公司 --- 其中總市值研發費用倍數夠低的腳本如下：

> 來源：[[機會比風險大的選股策略系列之4：總市值研發費用比夠低的公司]{.underline}](https://www.xq.com.tw/xstrader/%e6%a9%9f%e6%9c%83%e6%af%94%e9%a2%a8%e9%9a%aa%e5%a4%a7%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b4%ef%bc%9a%e7%b8%bd%e5%b8%82%e5%80%bc%e7%a0%94%e7%99%bc%e8%b2%bb%e7%94%a8/)
> 說明：其中總市值研發費用倍數夠低的腳本如下：

value1=getField(\"總市值(億)\", \"D\");//億

value2=getField(\"研發費用\", \"Y\");//百萬

value3=value1/value2\*100;

input:ratio(10,\"市值研發費用最高倍數上限\");

if value3\<ratio then ret=1;

## 場景 295：外資廣度指標

> 來源：[[外資廣度指標]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%96%e8%b3%87%e5%bb%a3%e5%ba%a6%e6%8c%87%e6%a8%99/)
> 說明：下面是我寫的腳本：

array:lead\[100\](0);

lead\[1\]=GetSymbolField(\"1102.tw\",\"外資買賣超張數\",\"D\");//台泥

lead\[2\]=GetSymbolField(\"2317.tw\",\"外資買賣超張數\",\"D\");//鴻海

lead\[3\]=GetSymbolField(\"1216.tw\",\"外資買賣超張數\",\"D\");//統一

lead\[4\]=GetSymbolField(\"1301.tw\",\"外資買賣超張數\",\"D\");//台塑

lead\[5\]=GetSymbolField(\"1304.tw\",\"外資買賣超張數\",\"D\");//台聚

lead\[6\]=GetSymbolField(\"1312.tw\",\"外資買賣超張數\",\"D\");//國喬

lead\[7\]=GetSymbolField(\"1326.tw\",\"外資買賣超張數\",\"D\");//台化

lead\[8\]=GetSymbolField(\"1455.tw\",\"外資買賣超張數\",\"D\");//集盛

lead\[9\]=GetSymbolField(\"1476.tw\",\"外資買賣超張數\",\"D\");//儒鴻

lead\[10\]=GetSymbolField(\"1477.tw\",\"外資買賣超張數\",\"D\");//聚陽

lead\[11\]=GetSymbolField(\"1513.tw\",\"外資買賣超張數\",\"D\");//中興電

lead\[12\]=GetSymbolField(\"1515.tw\",\"外資買賣超張數\",\"D\");//力山

lead\[13\]=GetSymbolField(\"1521.tw\",\"外資買賣超張數\",\"D\");//大億

lead\[14\]=GetSymbolField(\"1527.tw\",\"外資買賣超張數\",\"D\");//鑽全

lead\[15\]=GetSymbolField(\"1560.tw\",\"外資買賣超張數\",\"D\");//中砂

lead\[16\]=GetSymbolField(\"1565.tw\",\"外資買賣超張數\",\"D\");//精華

lead\[17\]=GetSymbolField(\"1582.tw\",\"外資買賣超張數\",\"D\");//信錦

lead\[18\]=GetSymbolField(\"1605.tw\",\"外資買賣超張數\",\"D\");//華新

lead\[19\]=GetSymbolField(\"1717.tw\",\"外資買賣超張數\",\"D\");//長興

lead\[20\]=GetSymbolField(\"1723.tw\",\"外資買賣超張數\",\"D\");//中碳

lead\[21\]=GetSymbolField(\"1726.tw\",\"外資買賣超張數\",\"D\");//永記

lead\[22\]=GetSymbolField(\"1736.tw\",\"外資買賣超張數\",\"D\");//喬山

lead\[23\]=GetSymbolField(\"1773.tw\",\"外資買賣超張數\",\"D\");//勝一

lead\[24\]=GetSymbolField(\"1795.tw\",\"外資買賣超張數\",\"D\");//美時

lead\[25\]=GetSymbolField(\"1907.tw\",\"外資買賣超張數\",\"D\");//永豊餘

lead\[26\]=GetSymbolField(\"2002.tw\",\"外資買賣超張數\",\"D\");//中鋼

lead\[27\]=GetSymbolField(\"2006.tw\",\"外資買賣超張數\",\"D\");//東鋼

lead\[28\]=GetSymbolField(\"2015.tw\",\"外資買賣超張數\",\"D\");//豊興

lead\[29\]=GetSymbolField(\"2029.tw\",\"外資買賣超張數\",\"D\");//盛餘

lead\[30\]=GetSymbolField(\"2027.tw\",\"外資買賣超張數\",\"D\");//大成鋼

lead\[31\]=GetSymbolField(\"2031.tw\",\"外資買賣超張數\",\"D\");//新光鋼

lead\[32\]=GetSymbolField(\"2049.tw\",\"外資買賣超張數\",\"D\");//上銀

lead\[33\]=GetSymbolField(\"2059.tw\",\"外資買賣超張數\",\"D\");//川湖

lead\[34\]=GetSymbolField(\"2103.tw\",\"外資買賣超張數\",\"D\");//台橡

lead\[35\]=GetSymbolField(\"2105.tw\",\"外資買賣超張數\",\"D\");//正新

lead\[36\]=GetSymbolField(\"2204.tw\",\"外資買賣超張數\",\"D\");//中華車

lead\[37\]=GetSymbolField(\"2207.tw\",\"外資買賣超張數\",\"D\");//和泰車

lead\[38\]=GetSymbolField(\"2231.tw\",\"外資買賣超張數\",\"D\");//為升

lead\[39\]=GetSymbolField(\"2233.tw\",\"外資買賣超張數\",\"D\");//宇隆

lead\[40\]=GetSymbolField(\"2301.tw\",\"外資買賣超張數\",\"D\");//光寶

lead\[41\]=GetSymbolField(\"2303.tw\",\"外資買賣超張數\",\"D\");//聯電

lead\[42\]=GetSymbolField(\"2308.tw\",\"外資買賣超張數\",\"D\");//台達電

lead\[43\]=GetSymbolField(\"2313.tw\",\"外資買賣超張數\",\"D\");//華通

lead\[44\]=GetSymbolField(\"2324.tw\",\"外資買賣超張數\",\"D\");//仁寶

lead\[45\]=GetSymbolField(\"2327.tw\",\"外資買賣超張數\",\"D\");//國巨

lead\[46\]=GetSymbolField(\"2330.tw\",\"外資買賣超張數\",\"D\");//台積電

lead\[47\]=GetSymbolField(\"2337.tw\",\"外資買賣超張數\",\"D\");//旺宏

lead\[48\]=GetSymbolField(\"2344.tw\",\"外資買賣超張數\",\"D\");//華邦電

lead\[49\]=GetSymbolField(\"2345.tw\",\"外資買賣超張數\",\"D\");//智邦

lead\[50\]=GetSymbolField(\"2347.tw\",\"外資買賣超張數\",\"D\");//聯強

lead\[51\]=GetSymbolField(\"2352.tw\",\"外資買賣超張數\",\"D\");//佳世達

lead\[52\]=GetSymbolField(\"2353.tw\",\"外資買賣超張數\",\"D\");//宏碁

lead\[53\]=GetSymbolField(\"2354.tw\",\"外資買賣超張數\",\"D\");//鴻準

lead\[54\]=GetSymbolField(\"2357.tw\",\"外資買賣超張數\",\"D\");//華碩

lead\[55\]=GetSymbolField(\"2368.tw\",\"外資買賣超張數\",\"D\");//金像電

lead\[56\]=GetSymbolField(\"2376.tw\",\"外資買賣超張數\",\"D\");//技嘉

lead\[57\]=GetSymbolField(\"2377.tw\",\"外資買賣超張數\",\"D\");//微星

lead\[58\]=GetSymbolField(\"2379.tw\",\"外資買賣超張數\",\"D\");//瑞昱

lead\[59\]=GetSymbolField(\"2382.tw\",\"外資買賣超張數\",\"D\");//廣達

lead\[60\]=GetSymbolField(\"2383.tw\",\"外資買賣超張數\",\"D\");//台光電

lead\[61\]=GetSymbolField(\"2385.tw\",\"外資買賣超張數\",\"D\");//群光

lead\[62\]=GetSymbolField(\"2393.tw\",\"外資買賣超張數\",\"D\");//億光

lead\[63\]=GetSymbolField(\"2395.tw\",\"外資買賣超張數\",\"D\");//研華

lead\[64\]=GetSymbolField(\"2408.tw\",\"外資買賣超張數\",\"D\");//南亞科

lead\[65\]=GetSymbolField(\"2409.tw\",\"外資買賣超張數\",\"D\");//友達

lead\[66\]=GetSymbolField(\"2439.tw\",\"外資買賣超張數\",\"D\");//美律

lead\[67\]=GetSymbolField(\"2449.tw\",\"外資買賣超張數\",\"D\");//京元電

lead\[68\]=GetSymbolField(\"2454.tw\",\"外資買賣超張數\",\"D\");//聯發科

lead\[69\]=GetSymbolField(\"2603.tw\",\"外資買賣超張數\",\"D\");//長榮

lead\[70\]=GetSymbolField(\"2606.tw\",\"外資買賣超張數\",\"D\");//裕民

lead\[71\]=GetSymbolField(\"2610.tw\",\"外資買賣超張數\",\"D\");//華航

lead\[72\]=GetSymbolField(\"2615.tw\",\"外資買賣超張數\",\"D\");//萬海

lead\[73\]=GetSymbolField(\"2707.tw\",\"外資買賣超張數\",\"D\");//晶華

lead\[74\]=GetSymbolField(\"2729.tw\",\"外資買賣超張數\",\"D\");//瓦城

lead\[75\]=GetSymbolField(\"2731.tw\",\"外資買賣超張數\",\"D\");//雄獅

lead\[76\]=GetSymbolField(\"2912.tw\",\"外資買賣超張數\",\"D\");//統一超

lead\[77\]=GetSymbolField(\"3008.tw\",\"外資買賣超張數\",\"D\");//大立光

lead\[78\]=GetSymbolField(\"3034.tw\",\"外資買賣超張數\",\"D\");//聯詠

lead\[79\]=GetSymbolField(\"3037.tw\",\"外資買賣超張數\",\"D\");//欣興

lead\[80\]=GetSymbolField(\"3042.tw\",\"外資買賣超張數\",\"D\");//晶技

lead\[81\]=GetSymbolField(\"3130.tw\",\"外資買賣超張數\",\"D\");//104

lead\[82\]=GetSymbolField(\"3231.tw\",\"外資買賣超張數\",\"D\");//緯創

lead\[83\]=GetSymbolField(\"3406.tw\",\"外資買賣超張數\",\"D\");//玉晶光

lead\[84\]=GetSymbolField(\"3481.tw\",\"外資買賣超張數\",\"D\");//群創

lead\[85\]=GetSymbolField(\"3576.tw\",\"外資買賣超張數\",\"D\");//聯合再生

lead\[86\]=GetSymbolField(\"3665.tw\",\"外資買賣超張數\",\"D\");//貿聯

lead\[87\]=GetSymbolField(\"3702.tw\",\"外資買賣超張數\",\"D\");//大聯大

lead\[88\]=GetSymbolField(\"3707.tw\",\"外資買賣超張數\",\"D\");//漢磊

lead\[89\]=GetSymbolField(\"3708.tw\",\"外資買賣超張數\",\"D\");//上緯

lead\[90\]=GetSymbolField(\"3711.tw\",\"外資買賣超張數\",\"D\");//日月光

lead\[91\]=GetSymbolField(\"3714.tw\",\"外資買賣超張數\",\"D\");//富采

lead\[92\]=GetSymbolField(\"4438.tw\",\"外資買賣超張數\",\"D\");//廣越

lead\[93\]=GetSymbolField(\"5434.tw\",\"外資買賣超張數\",\"D\");//崇越

lead\[94\]=GetSymbolField(\"6269.tw\",\"外資買賣超張數\",\"D\");//台郡

lead\[95\]=GetSymbolField(\"6285.tw\",\"外資買賣超張數\",\"D\");//啟碁

lead\[96\]=GetSymbolField(\"6505.tw\",\"外資買賣超張數\",\"D\");//台塑化

lead\[97\]=GetSymbolField(\"9910.tw\",\"外資買賣超張數\",\"D\");//豊泰

lead\[98\]=GetSymbolField(\"9921.tw\",\"外資買賣超張數\",\"D\");//巨大

lead\[99\]=GetSymbolField(\"8299.tw\",\"外資買賣超張數\",\"D\");//群聯

lead\[100\]=GetSymbolField(\"8086.tw\",\"外資買賣超張數\",\"D\");//宏捷科

variable:i(0),count(0);

count=0;

for i=1 to 100 begin

if lead\[i\]\>=lead\[i\]\[1\]

and lead\[i\]\>=100

//外資買超大於100張，且不比前一天少

then

count=count+1;

end;

plot1(average(count,15),\"外資廣度指標\");

## 場景 296：續強力指標

> 來源：[[續強力指標]{.underline}](https://www.xq.com.tw/xstrader/%e7%ba%8c%e5%bc%b7%e5%8a%9b%e6%8c%87%e6%a8%99/)
> 說明：我寫的腳本如下：

array:lead\[100\](0);

lead\[1\]=GetSymbolField(\"1102.tw\",\"收盤價\",\"D\");//台泥

lead\[2\]=GetSymbolField(\"2317.tw\",\"收盤價\",\"D\");//鴻海

lead\[3\]=GetSymbolField(\"1216.tw\",\"收盤價\",\"D\");//統一

lead\[4\]=GetSymbolField(\"1301.tw\",\"收盤價\",\"D\");//台塑

lead\[5\]=GetSymbolField(\"1304.tw\",\"收盤價\",\"D\");//台聚

lead\[6\]=GetSymbolField(\"1312.tw\",\"收盤價\",\"D\");//國喬

lead\[7\]=GetSymbolField(\"1326.tw\",\"收盤價\",\"D\");//台化

lead\[8\]=GetSymbolField(\"1455.tw\",\"收盤價\",\"D\");//集盛

lead\[9\]=GetSymbolField(\"1476.tw\",\"收盤價\",\"D\");//儒鴻

lead\[10\]=GetSymbolField(\"1477.tw\",\"收盤價\",\"D\");//聚陽

lead\[11\]=GetSymbolField(\"1513.tw\",\"收盤價\",\"D\");//中興電

lead\[12\]=GetSymbolField(\"1515.tw\",\"收盤價\",\"D\");//力山

lead\[13\]=GetSymbolField(\"1521.tw\",\"收盤價\",\"D\");//大億

lead\[14\]=GetSymbolField(\"1527.tw\",\"收盤價\",\"D\");//鑽全

lead\[15\]=GetSymbolField(\"1560.tw\",\"收盤價\",\"D\");//中砂

lead\[16\]=GetSymbolField(\"1565.tw\",\"收盤價\",\"D\");//精華

lead\[17\]=GetSymbolField(\"1582.tw\",\"收盤價\",\"D\");//信錦

lead\[18\]=GetSymbolField(\"1605.tw\",\"收盤價\",\"D\");//華新

lead\[19\]=GetSymbolField(\"1717.tw\",\"收盤價\",\"D\");//長興

lead\[20\]=GetSymbolField(\"1723.tw\",\"收盤價\",\"D\");//中碳

lead\[21\]=GetSymbolField(\"1726.tw\",\"收盤價\",\"D\");//永記

lead\[22\]=GetSymbolField(\"1736.tw\",\"收盤價\",\"D\");//喬山

lead\[23\]=GetSymbolField(\"1773.tw\",\"收盤價\",\"D\");//勝一

lead\[24\]=GetSymbolField(\"1795.tw\",\"收盤價\",\"D\");//美時

lead\[25\]=GetSymbolField(\"1907.tw\",\"收盤價\",\"D\");//永豊餘

lead\[26\]=GetSymbolField(\"2002.tw\",\"收盤價\",\"D\");//中鋼

lead\[27\]=GetSymbolField(\"2006.tw\",\"收盤價\",\"D\");//東鋼

lead\[28\]=GetSymbolField(\"2015.tw\",\"收盤價\",\"D\");//豊興

lead\[29\]=GetSymbolField(\"2029.tw\",\"收盤價\",\"D\");//盛餘

lead\[30\]=GetSymbolField(\"2027.tw\",\"收盤價\",\"D\");//大成鋼

lead\[31\]=GetSymbolField(\"2031.tw\",\"收盤價\",\"D\");//新光鋼

lead\[32\]=GetSymbolField(\"2049.tw\",\"收盤價\",\"D\");//上銀

lead\[33\]=GetSymbolField(\"2059.tw\",\"收盤價\",\"D\");//川湖

lead\[34\]=GetSymbolField(\"2103.tw\",\"收盤價\",\"D\");//台橡

lead\[35\]=GetSymbolField(\"2105.tw\",\"收盤價\",\"D\");//正新

lead\[36\]=GetSymbolField(\"2204.tw\",\"收盤價\",\"D\");//中華車

lead\[37\]=GetSymbolField(\"2207.tw\",\"收盤價\",\"D\");//和泰車

lead\[38\]=GetSymbolField(\"2231.tw\",\"收盤價\",\"D\");//為升

lead\[39\]=GetSymbolField(\"2233.tw\",\"收盤價\",\"D\");//宇隆

lead\[40\]=GetSymbolField(\"2301.tw\",\"收盤價\",\"D\");//光寶

lead\[41\]=GetSymbolField(\"2303.tw\",\"收盤價\",\"D\");//聯電

lead\[42\]=GetSymbolField(\"2308.tw\",\"收盤價\",\"D\");//台達電

lead\[43\]=GetSymbolField(\"2313.tw\",\"收盤價\",\"D\");//華通

lead\[44\]=GetSymbolField(\"2324.tw\",\"收盤價\",\"D\");//仁寶

lead\[45\]=GetSymbolField(\"2327.tw\",\"收盤價\",\"D\");//國巨

lead\[46\]=GetSymbolField(\"2330.tw\",\"收盤價\",\"D\");//台積電

lead\[47\]=GetSymbolField(\"2337.tw\",\"收盤價\",\"D\");//旺宏

lead\[48\]=GetSymbolField(\"2344.tw\",\"收盤價\",\"D\");//華邦電

lead\[49\]=GetSymbolField(\"2345.tw\",\"收盤價\",\"D\");//智邦

lead\[50\]=GetSymbolField(\"2347.tw\",\"收盤價\",\"D\");//聯強

lead\[51\]=GetSymbolField(\"2352.tw\",\"收盤價\",\"D\");//佳世達

lead\[52\]=GetSymbolField(\"2353.tw\",\"收盤價\",\"D\");//宏碁

lead\[53\]=GetSymbolField(\"2354.tw\",\"收盤價\",\"D\");//鴻準

lead\[54\]=GetSymbolField(\"2357.tw\",\"收盤價\",\"D\");//華碩

lead\[55\]=GetSymbolField(\"2368.tw\",\"收盤價\",\"D\");//金像電

lead\[56\]=GetSymbolField(\"2376.tw\",\"收盤價\",\"D\");//技嘉

lead\[57\]=GetSymbolField(\"2377.tw\",\"收盤價\",\"D\");//微星

lead\[58\]=GetSymbolField(\"2379.tw\",\"收盤價\",\"D\");//瑞昱

lead\[59\]=GetSymbolField(\"2382.tw\",\"收盤價\",\"D\");//廣達

lead\[60\]=GetSymbolField(\"2383.tw\",\"收盤價\",\"D\");//台光電

lead\[61\]=GetSymbolField(\"2385.tw\",\"收盤價\",\"D\");//群光

lead\[62\]=GetSymbolField(\"2393.tw\",\"收盤價\",\"D\");//億光

lead\[63\]=GetSymbolField(\"2395.tw\",\"收盤價\",\"D\");//研華

lead\[64\]=GetSymbolField(\"2408.tw\",\"收盤價\",\"D\");//南亞科

lead\[65\]=GetSymbolField(\"2409.tw\",\"收盤價\",\"D\");//友達

lead\[66\]=GetSymbolField(\"2439.tw\",\"收盤價\",\"D\");//美律

lead\[67\]=GetSymbolField(\"2449.tw\",\"收盤價\",\"D\");//京元電

lead\[68\]=GetSymbolField(\"2454.tw\",\"收盤價\",\"D\");//聯發科

lead\[69\]=GetSymbolField(\"2603.tw\",\"收盤價\",\"D\");//長榮

lead\[70\]=GetSymbolField(\"2606.tw\",\"收盤價\",\"D\");//裕民

lead\[71\]=GetSymbolField(\"2610.tw\",\"收盤價\",\"D\");//華航

lead\[72\]=GetSymbolField(\"2615.tw\",\"收盤價\",\"D\");//萬海

lead\[73\]=GetSymbolField(\"2707.tw\",\"收盤價\",\"D\");//晶華

lead\[74\]=GetSymbolField(\"2729.tw\",\"收盤價\",\"D\");//瓦城

lead\[75\]=GetSymbolField(\"2731.tw\",\"收盤價\",\"D\");//雄獅

lead\[76\]=GetSymbolField(\"2912.tw\",\"收盤價\",\"D\");//統一超

lead\[77\]=GetSymbolField(\"3008.tw\",\"收盤價\",\"D\");//大立光

lead\[78\]=GetSymbolField(\"3034.tw\",\"收盤價\",\"D\");//聯詠

lead\[79\]=GetSymbolField(\"3037.tw\",\"收盤價\",\"D\");//欣興

lead\[80\]=GetSymbolField(\"3042.tw\",\"收盤價\",\"D\");//晶技

lead\[81\]=GetSymbolField(\"3130.tw\",\"收盤價\",\"D\");//104

lead\[82\]=GetSymbolField(\"3231.tw\",\"收盤價\",\"D\");//緯創

lead\[83\]=GetSymbolField(\"3406.tw\",\"收盤價\",\"D\");//玉晶光

lead\[84\]=GetSymbolField(\"3481.tw\",\"收盤價\",\"D\");//群創

lead\[85\]=GetSymbolField(\"3576.tw\",\"收盤價\",\"D\");//聯合再生

lead\[86\]=GetSymbolField(\"3665.tw\",\"收盤價\",\"D\");//貿聯

lead\[87\]=GetSymbolField(\"3702.tw\",\"收盤價\",\"D\");//大聯大

lead\[88\]=GetSymbolField(\"3707.tw\",\"收盤價\",\"D\");//漢磊

lead\[89\]=GetSymbolField(\"3708.tw\",\"收盤價\",\"D\");//上緯

lead\[90\]=GetSymbolField(\"3711.tw\",\"收盤價\",\"D\");//日月光

lead\[91\]=GetSymbolField(\"3714.tw\",\"收盤價\",\"D\");//富采

lead\[92\]=GetSymbolField(\"4438.tw\",\"收盤價\",\"D\");//廣越

lead\[93\]=GetSymbolField(\"5434.tw\",\"收盤價\",\"D\");//崇越

lead\[94\]=GetSymbolField(\"6269.tw\",\"收盤價\",\"D\");//台郡

lead\[95\]=GetSymbolField(\"6285.tw\",\"收盤價\",\"D\");//啟碁

lead\[96\]=GetSymbolField(\"6505.tw\",\"收盤價\",\"D\");//台塑化

lead\[97\]=GetSymbolField(\"9910.tw\",\"收盤價\",\"D\");//豊泰

lead\[98\]=GetSymbolField(\"9921.tw\",\"收盤價\",\"D\");//巨大

lead\[99\]=GetSymbolField(\"8299.tw\",\"收盤價\",\"D\");//群聯

lead\[100\]=GetSymbolField(\"8086.tw\",\"收盤價\",\"D\");//宏捷科

variable:i(0),count(0);

count=0;

for i=1 to 100 begin

if lead\[i\]\>=lead\[i\]\[1\]\*1.01

and lead\[i\]\[1\]\>=lead\[i\]\[2\]\*1.03

//前一日漲超過2.5%而今日仍能續漲超過1%

then

count=count+1;

end;

plot1(average(count,15),\"續強指標\");

## 場景 297：指標股築底指標 --- 根據這樣的思維，我寫了一個指標股築底指標，這個指標的腳本如下

> 來源：[[指標股築底指標]{.underline}](https://www.xq.com.tw/xstrader/%e6%8c%87%e6%a8%99%e8%82%a1%e7%af%89%e5%ba%95%e6%8c%87%e6%a8%99/)
> 說明：根據這樣的思維，我寫了一個指標股築底指標，這個指標的腳本如下

array:lead\[100\](0);

lead\[1\]=GetSymbolField(\"1102.tw\",\"收盤價\",\"D\");//台泥

lead\[2\]=GetSymbolField(\"2317.tw\",\"收盤價\",\"D\");//鴻海

lead\[3\]=GetSymbolField(\"1216.tw\",\"收盤價\",\"D\");//統一

lead\[4\]=GetSymbolField(\"1301.tw\",\"收盤價\",\"D\");//台塑

lead\[5\]=GetSymbolField(\"1304.tw\",\"收盤價\",\"D\");//台聚

lead\[6\]=GetSymbolField(\"1312.tw\",\"收盤價\",\"D\");//國喬

lead\[7\]=GetSymbolField(\"1326.tw\",\"收盤價\",\"D\");//台化

lead\[8\]=GetSymbolField(\"1455.tw\",\"收盤價\",\"D\");//集盛

lead\[9\]=GetSymbolField(\"1476.tw\",\"收盤價\",\"D\");//儒鴻

lead\[10\]=GetSymbolField(\"1477.tw\",\"收盤價\",\"D\");//聚陽

lead\[11\]=GetSymbolField(\"1513.tw\",\"收盤價\",\"D\");//中興電

lead\[12\]=GetSymbolField(\"1515.tw\",\"收盤價\",\"D\");//力山

lead\[13\]=GetSymbolField(\"1521.tw\",\"收盤價\",\"D\");//大億

lead\[14\]=GetSymbolField(\"1527.tw\",\"收盤價\",\"D\");//鑽全

lead\[15\]=GetSymbolField(\"1560.tw\",\"收盤價\",\"D\");//中砂

lead\[16\]=GetSymbolField(\"1565.tw\",\"收盤價\",\"D\");//精華

lead\[17\]=GetSymbolField(\"1582.tw\",\"收盤價\",\"D\");//信錦

lead\[18\]=GetSymbolField(\"1605.tw\",\"收盤價\",\"D\");//華新

lead\[19\]=GetSymbolField(\"1717.tw\",\"收盤價\",\"D\");//長興

lead\[20\]=GetSymbolField(\"1723.tw\",\"收盤價\",\"D\");//中碳

lead\[21\]=GetSymbolField(\"1726.tw\",\"收盤價\",\"D\");//永記

lead\[22\]=GetSymbolField(\"1736.tw\",\"收盤價\",\"D\");//喬山

lead\[23\]=GetSymbolField(\"1773.tw\",\"收盤價\",\"D\");//勝一

lead\[24\]=GetSymbolField(\"1795.tw\",\"收盤價\",\"D\");//美時

lead\[25\]=GetSymbolField(\"1907.tw\",\"收盤價\",\"D\");//永豊餘

lead\[26\]=GetSymbolField(\"2002.tw\",\"收盤價\",\"D\");//中鋼

lead\[27\]=GetSymbolField(\"2006.tw\",\"收盤價\",\"D\");//東鋼

lead\[28\]=GetSymbolField(\"2015.tw\",\"收盤價\",\"D\");//豊興

lead\[29\]=GetSymbolField(\"2029.tw\",\"收盤價\",\"D\");//盛餘

lead\[30\]=GetSymbolField(\"2027.tw\",\"收盤價\",\"D\");//大成鋼

lead\[31\]=GetSymbolField(\"2031.tw\",\"收盤價\",\"D\");//新光鋼

lead\[32\]=GetSymbolField(\"2049.tw\",\"收盤價\",\"D\");//上銀

lead\[33\]=GetSymbolField(\"2059.tw\",\"收盤價\",\"D\");//川湖

lead\[34\]=GetSymbolField(\"2103.tw\",\"收盤價\",\"D\");//台橡

lead\[35\]=GetSymbolField(\"2105.tw\",\"收盤價\",\"D\");//正新

lead\[36\]=GetSymbolField(\"2204.tw\",\"收盤價\",\"D\");//中華車

lead\[37\]=GetSymbolField(\"2207.tw\",\"收盤價\",\"D\");//和泰車

lead\[38\]=GetSymbolField(\"2231.tw\",\"收盤價\",\"D\");//為升

lead\[39\]=GetSymbolField(\"2233.tw\",\"收盤價\",\"D\");//宇隆

lead\[40\]=GetSymbolField(\"2301.tw\",\"收盤價\",\"D\");//光寶

lead\[41\]=GetSymbolField(\"2303.tw\",\"收盤價\",\"D\");//聯電

lead\[42\]=GetSymbolField(\"2308.tw\",\"收盤價\",\"D\");//台達電

lead\[43\]=GetSymbolField(\"2313.tw\",\"收盤價\",\"D\");//華通

lead\[44\]=GetSymbolField(\"2324.tw\",\"收盤價\",\"D\");//仁寶

lead\[45\]=GetSymbolField(\"2327.tw\",\"收盤價\",\"D\");//國巨

lead\[46\]=GetSymbolField(\"2330.tw\",\"收盤價\",\"D\");//台積電

lead\[47\]=GetSymbolField(\"2337.tw\",\"收盤價\",\"D\");//旺宏

lead\[48\]=GetSymbolField(\"2344.tw\",\"收盤價\",\"D\");//華邦電

lead\[49\]=GetSymbolField(\"2345.tw\",\"收盤價\",\"D\");//智邦

lead\[50\]=GetSymbolField(\"2347.tw\",\"收盤價\",\"D\");//聯強

lead\[51\]=GetSymbolField(\"2352.tw\",\"收盤價\",\"D\");//佳世達

lead\[52\]=GetSymbolField(\"2353.tw\",\"收盤價\",\"D\");//宏碁

lead\[53\]=GetSymbolField(\"2354.tw\",\"收盤價\",\"D\");//鴻準

lead\[54\]=GetSymbolField(\"2357.tw\",\"收盤價\",\"D\");//華碩

lead\[55\]=GetSymbolField(\"2368.tw\",\"收盤價\",\"D\");//金像電

lead\[56\]=GetSymbolField(\"2376.tw\",\"收盤價\",\"D\");//技嘉

lead\[57\]=GetSymbolField(\"2377.tw\",\"收盤價\",\"D\");//微星

lead\[58\]=GetSymbolField(\"2379.tw\",\"收盤價\",\"D\");//瑞昱

lead\[59\]=GetSymbolField(\"2382.tw\",\"收盤價\",\"D\");//廣達

lead\[60\]=GetSymbolField(\"2383.tw\",\"收盤價\",\"D\");//台光電

lead\[61\]=GetSymbolField(\"2385.tw\",\"收盤價\",\"D\");//群光

lead\[62\]=GetSymbolField(\"2393.tw\",\"收盤價\",\"D\");//億光

lead\[63\]=GetSymbolField(\"2395.tw\",\"收盤價\",\"D\");//研華

lead\[64\]=GetSymbolField(\"2408.tw\",\"收盤價\",\"D\");//南亞科

lead\[65\]=GetSymbolField(\"2409.tw\",\"收盤價\",\"D\");//友達

lead\[66\]=GetSymbolField(\"2439.tw\",\"收盤價\",\"D\");//美律

lead\[67\]=GetSymbolField(\"2449.tw\",\"收盤價\",\"D\");//京元電

lead\[68\]=GetSymbolField(\"2454.tw\",\"收盤價\",\"D\");//聯發科

lead\[69\]=GetSymbolField(\"2603.tw\",\"收盤價\",\"D\");//長榮

lead\[70\]=GetSymbolField(\"2606.tw\",\"收盤價\",\"D\");//裕民

lead\[71\]=GetSymbolField(\"2610.tw\",\"收盤價\",\"D\");//華航

lead\[72\]=GetSymbolField(\"2615.tw\",\"收盤價\",\"D\");//萬海

lead\[73\]=GetSymbolField(\"2707.tw\",\"收盤價\",\"D\");//晶華

lead\[74\]=GetSymbolField(\"2729.tw\",\"收盤價\",\"D\");//瓦城

lead\[75\]=GetSymbolField(\"2731.tw\",\"收盤價\",\"D\");//雄獅

lead\[76\]=GetSymbolField(\"2912.tw\",\"收盤價\",\"D\");//統一超

lead\[77\]=GetSymbolField(\"3008.tw\",\"收盤價\",\"D\");//大立光

lead\[78\]=GetSymbolField(\"3034.tw\",\"收盤價\",\"D\");//聯詠

lead\[79\]=GetSymbolField(\"3037.tw\",\"收盤價\",\"D\");//欣興

lead\[80\]=GetSymbolField(\"3042.tw\",\"收盤價\",\"D\");//晶技

lead\[81\]=GetSymbolField(\"3130.tw\",\"收盤價\",\"D\");//104

lead\[82\]=GetSymbolField(\"3231.tw\",\"收盤價\",\"D\");//緯創

lead\[83\]=GetSymbolField(\"3406.tw\",\"收盤價\",\"D\");//玉晶光

lead\[84\]=GetSymbolField(\"3481.tw\",\"收盤價\",\"D\");//群創

lead\[85\]=GetSymbolField(\"3576.tw\",\"收盤價\",\"D\");//聯合再生

lead\[86\]=GetSymbolField(\"3665.tw\",\"收盤價\",\"D\");//貿聯

lead\[87\]=GetSymbolField(\"3702.tw\",\"收盤價\",\"D\");//大聯大

lead\[88\]=GetSymbolField(\"3707.tw\",\"收盤價\",\"D\");//漢磊

lead\[89\]=GetSymbolField(\"3708.tw\",\"收盤價\",\"D\");//上緯

lead\[90\]=GetSymbolField(\"3711.tw\",\"收盤價\",\"D\");//日月光

lead\[91\]=GetSymbolField(\"3714.tw\",\"收盤價\",\"D\");//富采

lead\[92\]=GetSymbolField(\"4438.tw\",\"收盤價\",\"D\");//廣越

lead\[93\]=GetSymbolField(\"5434.tw\",\"收盤價\",\"D\");//崇越

lead\[94\]=GetSymbolField(\"6269.tw\",\"收盤價\",\"D\");//台郡

lead\[95\]=GetSymbolField(\"6285.tw\",\"收盤價\",\"D\");//啟碁

lead\[96\]=GetSymbolField(\"6505.tw\",\"收盤價\",\"D\");//台塑化

lead\[97\]=GetSymbolField(\"9910.tw\",\"收盤價\",\"D\");//豊泰

lead\[98\]=GetSymbolField(\"9921.tw\",\"收盤價\",\"D\");//巨大

lead\[99\]=GetSymbolField(\"8299.tw\",\"收盤價\",\"D\");//群聯

lead\[100\]=GetSymbolField(\"8086.tw\",\"收盤價\",\"D\");//宏捷科

variable:i(0),count(0);

count=0;

for i=1 to 100 begin

if lead\[i\]\>lowest(lead\[i\],10)\*1.1

//收盤價比近十日低點回升一成

then

count=count+1;

end;

plot1(100-count,\"指標股築底家數\");

//用100-count 代表數字愈大，愈多股票沒有比十日低點高超過一成

//數字愈小，代表愈來愈多股票比十日低點高出一成

plot2(20);

plot3(35);

## 場景 298：大盤指標系列之上漲下跌趨動力比 --- 我把這個想法寫成了自訂指標

> 來源：[[大盤指標系列之上漲下跌趨動力比]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e7%9b%a4%e6%8c%87%e6%a8%99%e7%b3%bb%e5%88%97%e4%b9%8b%e4%b8%8a%e6%bc%b2%e4%b8%8b%e8%b7%8c%e8%b6%a8%e5%8b%95%e5%8a%9b%e6%af%94/)
> 說明：我把這個想法寫成了自訂指標

settotalbar(1000);

value1=getField(\"上漲家數\", \"D\");

value2=getField(\"下跌家數\", \"D\");

value3=getField(\"上漲量\", \"D\");

value4=getField(\"下跌量\", \"D\");

value5=(value3/value1);

//上漲量/上漲家數

value6=(value4/value2);

//下跌量/下跌家數

value7=value6/value5;

plot1(value7,\"上漲下跌趨動力比值\");

plot2(1);

plot3(2);

## 場景 299：指標股站在月線之上的家數 --- 這個指標的寫法是先選出100檔在主要產業裡具有領導地位的公司，然後計算這100檔股票裡，有多少檔目前的收盤價是大於其月線的價位，以下是我寫的腳本

> 來源：[[指標股站在月線之上的家數]{.underline}](https://www.xq.com.tw/xstrader/%e6%8c%87%e6%a8%99%e8%82%a1%e7%ab%99%e5%9c%a8%e6%9c%88%e7%b7%9a%e4%b9%8b%e4%b8%8a%e7%9a%84%e5%ae%b6%e6%95%b8/)
> 說明：這個指標的寫法是先選出100檔在主要產業裡具有領導地位的公司，然後計算這100檔股票裡，有多少檔目前的收盤價是大於其月線的價位，以下是我寫的腳本

array:lead\[100\](0);

lead\[1\]=GetSymbolField(\"1102.tw\",\"收盤價\",\"D\");//台泥

lead\[2\]=GetSymbolField(\"2317.tw\",\"收盤價\",\"D\");//鴻海

lead\[3\]=GetSymbolField(\"1216.tw\",\"收盤價\",\"D\");//統一

lead\[4\]=GetSymbolField(\"1301.tw\",\"收盤價\",\"D\");//台塑

lead\[5\]=GetSymbolField(\"1304.tw\",\"收盤價\",\"D\");//台聚

lead\[6\]=GetSymbolField(\"1312.tw\",\"收盤價\",\"D\");//國喬

lead\[7\]=GetSymbolField(\"1326.tw\",\"收盤價\",\"D\");//台化

lead\[8\]=GetSymbolField(\"1455.tw\",\"收盤價\",\"D\");//集盛

lead\[9\]=GetSymbolField(\"1476.tw\",\"收盤價\",\"D\");//儒鴻

lead\[10\]=GetSymbolField(\"1477.tw\",\"收盤價\",\"D\");//聚陽

lead\[11\]=GetSymbolField(\"1513.tw\",\"收盤價\",\"D\");//中興電

lead\[12\]=GetSymbolField(\"1515.tw\",\"收盤價\",\"D\");//力山

lead\[13\]=GetSymbolField(\"1521.tw\",\"收盤價\",\"D\");//大億

lead\[14\]=GetSymbolField(\"1527.tw\",\"收盤價\",\"D\");//鑽全

lead\[15\]=GetSymbolField(\"1560.tw\",\"收盤價\",\"D\");//中砂

lead\[16\]=GetSymbolField(\"1565.tw\",\"收盤價\",\"D\");//精華

lead\[17\]=GetSymbolField(\"1582.tw\",\"收盤價\",\"D\");//信錦

lead\[18\]=GetSymbolField(\"1605.tw\",\"收盤價\",\"D\");//華新

lead\[19\]=GetSymbolField(\"1717.tw\",\"收盤價\",\"D\");//長興

lead\[20\]=GetSymbolField(\"1723.tw\",\"收盤價\",\"D\");//中碳

lead\[21\]=GetSymbolField(\"1726.tw\",\"收盤價\",\"D\");//永記

lead\[22\]=GetSymbolField(\"1736.tw\",\"收盤價\",\"D\");//喬山

lead\[23\]=GetSymbolField(\"1773.tw\",\"收盤價\",\"D\");//勝一

lead\[24\]=GetSymbolField(\"1795.tw\",\"收盤價\",\"D\");//美時

lead\[25\]=GetSymbolField(\"1907.tw\",\"收盤價\",\"D\");//永豊餘

lead\[26\]=GetSymbolField(\"2002.tw\",\"收盤價\",\"D\");//中鋼

lead\[27\]=GetSymbolField(\"2006.tw\",\"收盤價\",\"D\");//東鋼

lead\[28\]=GetSymbolField(\"2015.tw\",\"收盤價\",\"D\");//豊興

lead\[29\]=GetSymbolField(\"2029.tw\",\"收盤價\",\"D\");//盛餘

lead\[30\]=GetSymbolField(\"2027.tw\",\"收盤價\",\"D\");//大成鋼

lead\[31\]=GetSymbolField(\"2031.tw\",\"收盤價\",\"D\");//新光鋼

lead\[32\]=GetSymbolField(\"2049.tw\",\"收盤價\",\"D\");//上銀

lead\[33\]=GetSymbolField(\"2059.tw\",\"收盤價\",\"D\");//川湖

lead\[34\]=GetSymbolField(\"2103.tw\",\"收盤價\",\"D\");//台橡

lead\[35\]=GetSymbolField(\"2105.tw\",\"收盤價\",\"D\");//正新

lead\[36\]=GetSymbolField(\"2204.tw\",\"收盤價\",\"D\");//中華車

lead\[37\]=GetSymbolField(\"2207.tw\",\"收盤價\",\"D\");//和泰車

lead\[38\]=GetSymbolField(\"2231.tw\",\"收盤價\",\"D\");//為升

lead\[39\]=GetSymbolField(\"2233.tw\",\"收盤價\",\"D\");//宇隆

lead\[40\]=GetSymbolField(\"2301.tw\",\"收盤價\",\"D\");//光寶

lead\[41\]=GetSymbolField(\"2303.tw\",\"收盤價\",\"D\");//聯電

lead\[42\]=GetSymbolField(\"2308.tw\",\"收盤價\",\"D\");//台達電

lead\[43\]=GetSymbolField(\"2313.tw\",\"收盤價\",\"D\");//華通

lead\[44\]=GetSymbolField(\"2324.tw\",\"收盤價\",\"D\");//仁寶

lead\[45\]=GetSymbolField(\"2327.tw\",\"收盤價\",\"D\");//國巨

lead\[46\]=GetSymbolField(\"2330.tw\",\"收盤價\",\"D\");//台積電

lead\[47\]=GetSymbolField(\"2337.tw\",\"收盤價\",\"D\");//旺宏

lead\[48\]=GetSymbolField(\"2344.tw\",\"收盤價\",\"D\");//華邦電

lead\[49\]=GetSymbolField(\"2345.tw\",\"收盤價\",\"D\");//智邦

lead\[50\]=GetSymbolField(\"2347.tw\",\"收盤價\",\"D\");//聯強

lead\[51\]=GetSymbolField(\"2352.tw\",\"收盤價\",\"D\");//佳世達

lead\[52\]=GetSymbolField(\"2353.tw\",\"收盤價\",\"D\");//宏碁

lead\[53\]=GetSymbolField(\"2354.tw\",\"收盤價\",\"D\");//鴻準

lead\[54\]=GetSymbolField(\"2357.tw\",\"收盤價\",\"D\");//華碩

lead\[55\]=GetSymbolField(\"2368.tw\",\"收盤價\",\"D\");//金像電

lead\[56\]=GetSymbolField(\"2376.tw\",\"收盤價\",\"D\");//技嘉

lead\[57\]=GetSymbolField(\"2377.tw\",\"收盤價\",\"D\");//微星

lead\[58\]=GetSymbolField(\"2379.tw\",\"收盤價\",\"D\");//瑞昱

lead\[59\]=GetSymbolField(\"2382.tw\",\"收盤價\",\"D\");//廣達

lead\[60\]=GetSymbolField(\"2383.tw\",\"收盤價\",\"D\");//台光電

lead\[61\]=GetSymbolField(\"2385.tw\",\"收盤價\",\"D\");//群光

lead\[62\]=GetSymbolField(\"2393.tw\",\"收盤價\",\"D\");//億光

lead\[63\]=GetSymbolField(\"2395.tw\",\"收盤價\",\"D\");//研華

lead\[64\]=GetSymbolField(\"2408.tw\",\"收盤價\",\"D\");//南亞科

lead\[65\]=GetSymbolField(\"2409.tw\",\"收盤價\",\"D\");//友達

lead\[66\]=GetSymbolField(\"2439.tw\",\"收盤價\",\"D\");//美律

lead\[67\]=GetSymbolField(\"2449.tw\",\"收盤價\",\"D\");//京元電

lead\[68\]=GetSymbolField(\"2454.tw\",\"收盤價\",\"D\");//聯發科

lead\[69\]=GetSymbolField(\"2603.tw\",\"收盤價\",\"D\");//長榮

lead\[70\]=GetSymbolField(\"2606.tw\",\"收盤價\",\"D\");//裕民

lead\[71\]=GetSymbolField(\"2610.tw\",\"收盤價\",\"D\");//華航

lead\[72\]=GetSymbolField(\"2615.tw\",\"收盤價\",\"D\");//萬海

lead\[73\]=GetSymbolField(\"2707.tw\",\"收盤價\",\"D\");//晶華

lead\[74\]=GetSymbolField(\"2729.tw\",\"收盤價\",\"D\");//瓦城

lead\[75\]=GetSymbolField(\"2731.tw\",\"收盤價\",\"D\");//雄獅

lead\[76\]=GetSymbolField(\"2912.tw\",\"收盤價\",\"D\");//統一超

lead\[77\]=GetSymbolField(\"3008.tw\",\"收盤價\",\"D\");//大立光

lead\[78\]=GetSymbolField(\"3034.tw\",\"收盤價\",\"D\");//聯詠

lead\[79\]=GetSymbolField(\"3037.tw\",\"收盤價\",\"D\");//欣興

lead\[80\]=GetSymbolField(\"3042.tw\",\"收盤價\",\"D\");//晶技

lead\[81\]=GetSymbolField(\"3130.tw\",\"收盤價\",\"D\");//104

lead\[82\]=GetSymbolField(\"3231.tw\",\"收盤價\",\"D\");//緯創

lead\[83\]=GetSymbolField(\"3406.tw\",\"收盤價\",\"D\");//玉晶光

lead\[84\]=GetSymbolField(\"3481.tw\",\"收盤價\",\"D\");//群創

lead\[85\]=GetSymbolField(\"3576.tw\",\"收盤價\",\"D\");//聯合再生

lead\[86\]=GetSymbolField(\"3665.tw\",\"收盤價\",\"D\");//貿聯

lead\[87\]=GetSymbolField(\"3702.tw\",\"收盤價\",\"D\");//大聯大

lead\[88\]=GetSymbolField(\"3707.tw\",\"收盤價\",\"D\");//漢磊

lead\[89\]=GetSymbolField(\"3708.tw\",\"收盤價\",\"D\");//上緯

lead\[90\]=GetSymbolField(\"3711.tw\",\"收盤價\",\"D\");//日月光

lead\[91\]=GetSymbolField(\"3714.tw\",\"收盤價\",\"D\");//富采

lead\[92\]=GetSymbolField(\"4438.tw\",\"收盤價\",\"D\");//廣越

lead\[93\]=GetSymbolField(\"5434.tw\",\"收盤價\",\"D\");//崇越

lead\[94\]=GetSymbolField(\"6269.tw\",\"收盤價\",\"D\");//台郡

lead\[95\]=GetSymbolField(\"6285.tw\",\"收盤價\",\"D\");//啟碁

lead\[96\]=GetSymbolField(\"6505.tw\",\"收盤價\",\"D\");//台塑化

lead\[97\]=GetSymbolField(\"9910.tw\",\"收盤價\",\"D\");//豊泰

lead\[98\]=GetSymbolField(\"9921.tw\",\"收盤價\",\"D\");//巨大

lead\[99\]=GetSymbolField(\"8299.tw\",\"收盤價\",\"D\");//群聯

lead\[100\]=GetSymbolField(\"8086.tw\",\"收盤價\",\"D\");//宏捷科

variable:i(0),count(0);

count=0;

for i=1 to 100 begin

if lead\[i\]\>=average(lead\[i\],22)

then

count=count+1;

end;

plot1(count,\"指標股站在月線之上家數\");

plot2(50);

## 場景 300：空頭氣勢指標

> 來源：[[空頭氣勢指標]{.underline}](https://www.xq.com.tw/xstrader/%e7%a9%ba%e9%a0%ad%e6%b0%a3%e5%8b%a2%e6%8c%87%e6%a8%99/)
> 說明：我寫的指標腳本如下

value1=getField(\"融券增減張數\");

value2=getField(\"借券餘額張數\");

value3=value2-value2\[1\];

value4=average(value1,5)+average(value3,5);

plot1(value4,\"空頭氣勢指標\");

## 場景 301：從融資維持率看抄底時機 --- 所以我就寫了一個指標如下

> 來源：[[從融資維持率看抄底時機]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%9e%e8%9e%8d%e8%b3%87%e7%b6%ad%e6%8c%81%e7%8e%87%e7%9c%8b%e6%8a%84%e5%ba%95%e6%99%82%e6%a9%9f/)
> 說明：所以我就寫了一個指標如下

value1=getField(\"融資維持率\");

plot1(value1,\"融資維持率\");

plot2(130);

plot3(150);

## 場景 302：抄底系列之大跌後的主力回頭收集 --- 這常中介紹的第一個策略： 大跌後的主力回頭收集，改良後的腳本如下

> 來源：[[抄底系列之大跌後的主力回頭收集]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%84%e5%ba%95%e7%b3%bb%e5%88%97%e4%b9%8b%e5%a4%a7%e8%b7%8c%e5%be%8c%e7%9a%84%e4%b8%bb%e5%8a%9b%e5%9b%9e%e9%a0%ad%e6%94%b6%e9%9b%86/)
> 說明：這常中介紹的第一個策略： 大跌後的主力回頭收集，改良後的腳本如下

input:period(10);

value1=GetField(\"分公司賣出家數\")\[1\];

value2=GetField(\"分公司買進家數\")\[1\];

if linearregslope(value1,period)\>0

//賣出的家數愈來愈多

and linearregslope(value2,period)\<0

//買進的家數愈來愈少

and

close\*1.05\<close\[period\]

//但這段期間股價在跌

and close\*1.283\<close\[30\]

and close\*1.782\>close\[30\]

//波段跌幅夠大

then ret=1;

## 場景 303：哪些股票股價被低估了？ --- 我看到這個公式時，有寫過一個選股策略，先找出用這個公式估算之下，折價夠高的股票

> 來源：[[哪些股票股價被低估了？]{.underline}](https://www.xq.com.tw/xstrader/%e9%82%a3%e4%ba%9b%e8%82%a1%e7%a5%a8%e8%82%a1%e5%83%b9%e8%a2%ab%e4%bd%8e%e4%bc%b0%e4%ba%86%ef%bc%9f/)
> 說明：我看到這個公式時，有寫過一個選股策略，先找出用這個公式估算之下，折價夠高的股票

value1=getField(\"每股稅後淨利(元)\", \"Q\")

+getField(\"每股稅後淨利(元)\", \"Q\")\[1\]

+getField(\"每股稅後淨利(元)\", \"Q\")\[2\]

+getField(\"每股稅後淨利(元)\", \"Q\")\[3\];

//前四季EPS總和

value2=getField(\"每股淨值(元)\", \"Q\");

//最新每股淨值

var:parvalue(0);

if value1\<\>0 then

parvalue=squareroot(22.5\*value1\*value2);

input:discountrate(25,\"discount\");

if close\<parvalue\*((100-discountrate)/100)

then ret=1;

outputfield(1,value1,1,\"近四季EPS總和\");

outputfield(2,value2,1,\"每股淨值\");

outputfield(3,parvalue,1,\"合理股價\");

outputfield(4,(1-parvalue/close)\*100,1,\"折價率\");

## 場景 304：融資要減多少，大盤才會見底？

> 來源：[[融資要減多少，大盤才會見底？]{.underline}](https://www.xq.com.tw/xstrader/%e8%9e%8d%e8%b3%87%e8%a6%81%e6%b8%9b%e5%a4%9a%e5%b0%91%ef%bc%8c%e5%a4%a7%e7%9b%a4%e6%89%8d%e6%9c%83%e8%a6%8b%e5%ba%95%ef%bc%9f/)
> 說明：以下是我寫的腳本

value1=getField(\"融資增減\");//單位:元

input:band1(100,\"融資減少金額\");//單位:億元

value2=value1\[2\]+value1\[1\];

if -(value2)/100000000\>band1

then ret=1;

## 場景 305：融資要減多少，大盤才會見底？ --- 為了更符合這兩年的情況，我把腳本修改如下

> 來源：[[融資要減多少，大盤才會見底？]{.underline}](https://www.xq.com.tw/xstrader/%e8%9e%8d%e8%b3%87%e8%a6%81%e6%b8%9b%e5%a4%9a%e5%b0%91%ef%bc%8c%e5%a4%a7%e7%9b%a4%e6%89%8d%e6%9c%83%e8%a6%8b%e5%ba%95%ef%bc%9f/)
> 說明：為了更符合這兩年的情況，我把腳本修改如下

value1=getField(\"融資增減\");//單位:元

input:band1(150,\"融資減少金額\");//單位:億元

value2=value1\[2\]+value1\[1\]+value1;

if -(value2)/100000000\>band1

then ret=1;

## 場景 306：近N日外資買超天數

> 來源：[[近N日外資買超天數]{.underline}](https://www.xq.com.tw/xstrader/%e8%bf%91n%e6%97%a5%e5%a4%96%e8%b3%87%e8%b2%b7%e8%b6%85%e5%a4%a9%e6%95%b8/)
> 說明：我寫的腳本不複雜

value1=getField(\"外資買賣超金額\");

input:period(10,\"計算區間\");

value2=countif(value1\>0,period);

plot1(value2-5,\"買超天數\");

## 場景 307：指標股創新高家數 --- 以下是根據這些步驟寫的腳本

> 來源：[[指標股創新高家數]{.underline}](https://www.xq.com.tw/xstrader/%e6%8c%87%e6%a8%99%e8%82%a1%e5%89%b5%e6%96%b0%e9%ab%98%e5%ae%b6%e6%95%b8/)
> 說明：以下是根據這些步驟寫的腳本

array:lead\[100\](0);

lead\[1\]=GetSymbolField(\"1102.tw\",\"收盤價\",\"D\");//台泥

lead\[2\]=GetSymbolField(\"2317.tw\",\"收盤價\",\"D\");//鴻海

lead\[3\]=GetSymbolField(\"1216.tw\",\"收盤價\",\"D\");//統一

lead\[4\]=GetSymbolField(\"1301.tw\",\"收盤價\",\"D\");//台塑

lead\[5\]=GetSymbolField(\"1304.tw\",\"收盤價\",\"D\");//台聚

lead\[6\]=GetSymbolField(\"1312.tw\",\"收盤價\",\"D\");//國喬

lead\[7\]=GetSymbolField(\"1326.tw\",\"收盤價\",\"D\");//台化

lead\[8\]=GetSymbolField(\"1455.tw\",\"收盤價\",\"D\");//集盛

lead\[9\]=GetSymbolField(\"1476.tw\",\"收盤價\",\"D\");//儒鴻

lead\[10\]=GetSymbolField(\"1477.tw\",\"收盤價\",\"D\");//聚陽

lead\[11\]=GetSymbolField(\"1513.tw\",\"收盤價\",\"D\");//中興電

lead\[12\]=GetSymbolField(\"1515.tw\",\"收盤價\",\"D\");//力山

lead\[13\]=GetSymbolField(\"1521.tw\",\"收盤價\",\"D\");//大億

lead\[14\]=GetSymbolField(\"1527.tw\",\"收盤價\",\"D\");//鑽全

lead\[15\]=GetSymbolField(\"1560.tw\",\"收盤價\",\"D\");//中砂

lead\[16\]=GetSymbolField(\"1565.tw\",\"收盤價\",\"D\");//精華

lead\[17\]=GetSymbolField(\"1582.tw\",\"收盤價\",\"D\");//信錦

lead\[18\]=GetSymbolField(\"1605.tw\",\"收盤價\",\"D\");//華新

lead\[19\]=GetSymbolField(\"1717.tw\",\"收盤價\",\"D\");//長興

lead\[20\]=GetSymbolField(\"1723.tw\",\"收盤價\",\"D\");//中碳

lead\[21\]=GetSymbolField(\"1726.tw\",\"收盤價\",\"D\");//永記

lead\[22\]=GetSymbolField(\"1736.tw\",\"收盤價\",\"D\");//喬山

lead\[23\]=GetSymbolField(\"1773.tw\",\"收盤價\",\"D\");//勝一

lead\[24\]=GetSymbolField(\"1795.tw\",\"收盤價\",\"D\");//美時

lead\[25\]=GetSymbolField(\"1907.tw\",\"收盤價\",\"D\");//永豊餘

lead\[26\]=GetSymbolField(\"2002.tw\",\"收盤價\",\"D\");//中鋼

lead\[27\]=GetSymbolField(\"2006.tw\",\"收盤價\",\"D\");//東鋼

lead\[28\]=GetSymbolField(\"2015.tw\",\"收盤價\",\"D\");//豊興

lead\[29\]=GetSymbolField(\"2029.tw\",\"收盤價\",\"D\");//盛餘

lead\[30\]=GetSymbolField(\"2027.tw\",\"收盤價\",\"D\");//大成鋼

lead\[31\]=GetSymbolField(\"2031.tw\",\"收盤價\",\"D\");//新光鋼

lead\[32\]=GetSymbolField(\"2049.tw\",\"收盤價\",\"D\");//上銀

lead\[33\]=GetSymbolField(\"2059.tw\",\"收盤價\",\"D\");//川湖

lead\[34\]=GetSymbolField(\"2103.tw\",\"收盤價\",\"D\");//台橡

lead\[35\]=GetSymbolField(\"2105.tw\",\"收盤價\",\"D\");//正新

lead\[36\]=GetSymbolField(\"2204.tw\",\"收盤價\",\"D\");//中華車

lead\[37\]=GetSymbolField(\"2207.tw\",\"收盤價\",\"D\");//和泰車

lead\[38\]=GetSymbolField(\"2231.tw\",\"收盤價\",\"D\");//為升

lead\[39\]=GetSymbolField(\"2233.tw\",\"收盤價\",\"D\");//宇隆

lead\[40\]=GetSymbolField(\"2301.tw\",\"收盤價\",\"D\");//光寶

lead\[41\]=GetSymbolField(\"2303.tw\",\"收盤價\",\"D\");//聯電

lead\[42\]=GetSymbolField(\"2308.tw\",\"收盤價\",\"D\");//台達電

lead\[43\]=GetSymbolField(\"2313.tw\",\"收盤價\",\"D\");//華通

lead\[44\]=GetSymbolField(\"2324.tw\",\"收盤價\",\"D\");//仁寶

lead\[45\]=GetSymbolField(\"2327.tw\",\"收盤價\",\"D\");//國巨

lead\[46\]=GetSymbolField(\"2330.tw\",\"收盤價\",\"D\");//台積電

lead\[47\]=GetSymbolField(\"2337.tw\",\"收盤價\",\"D\");//旺宏

lead\[48\]=GetSymbolField(\"2344.tw\",\"收盤價\",\"D\");//華邦電

lead\[49\]=GetSymbolField(\"2345.tw\",\"收盤價\",\"D\");//智邦

lead\[50\]=GetSymbolField(\"2347.tw\",\"收盤價\",\"D\");//聯強

lead\[51\]=GetSymbolField(\"2352.tw\",\"收盤價\",\"D\");//佳世達

lead\[52\]=GetSymbolField(\"2353.tw\",\"收盤價\",\"D\");//宏碁

lead\[53\]=GetSymbolField(\"2354.tw\",\"收盤價\",\"D\");//鴻準

lead\[54\]=GetSymbolField(\"2357.tw\",\"收盤價\",\"D\");//華碩

lead\[55\]=GetSymbolField(\"2368.tw\",\"收盤價\",\"D\");//金像電

lead\[56\]=GetSymbolField(\"2376.tw\",\"收盤價\",\"D\");//技嘉

lead\[57\]=GetSymbolField(\"2377.tw\",\"收盤價\",\"D\");//微星

lead\[58\]=GetSymbolField(\"2379.tw\",\"收盤價\",\"D\");//瑞昱

lead\[59\]=GetSymbolField(\"2382.tw\",\"收盤價\",\"D\");//廣達

lead\[60\]=GetSymbolField(\"2383.tw\",\"收盤價\",\"D\");//台光電

lead\[61\]=GetSymbolField(\"2385.tw\",\"收盤價\",\"D\");//群光

lead\[62\]=GetSymbolField(\"2393.tw\",\"收盤價\",\"D\");//億光

lead\[63\]=GetSymbolField(\"2395.tw\",\"收盤價\",\"D\");//研華

lead\[64\]=GetSymbolField(\"2408.tw\",\"收盤價\",\"D\");//南亞科

lead\[65\]=GetSymbolField(\"2409.tw\",\"收盤價\",\"D\");//友達

lead\[66\]=GetSymbolField(\"2439.tw\",\"收盤價\",\"D\");//美律

lead\[67\]=GetSymbolField(\"2449.tw\",\"收盤價\",\"D\");//京元電

lead\[68\]=GetSymbolField(\"2454.tw\",\"收盤價\",\"D\");//聯發科

lead\[69\]=GetSymbolField(\"2603.tw\",\"收盤價\",\"D\");//長榮

lead\[70\]=GetSymbolField(\"2606.tw\",\"收盤價\",\"D\");//裕民

lead\[71\]=GetSymbolField(\"2610.tw\",\"收盤價\",\"D\");//華航

lead\[72\]=GetSymbolField(\"2615.tw\",\"收盤價\",\"D\");//萬海

lead\[73\]=GetSymbolField(\"2707.tw\",\"收盤價\",\"D\");//晶華

lead\[74\]=GetSymbolField(\"2729.tw\",\"收盤價\",\"D\");//瓦城

lead\[75\]=GetSymbolField(\"2731.tw\",\"收盤價\",\"D\");//雄獅

lead\[76\]=GetSymbolField(\"2912.tw\",\"收盤價\",\"D\");//統一超

lead\[77\]=GetSymbolField(\"3008.tw\",\"收盤價\",\"D\");//大立光

lead\[78\]=GetSymbolField(\"3034.tw\",\"收盤價\",\"D\");//聯詠

lead\[79\]=GetSymbolField(\"3037.tw\",\"收盤價\",\"D\");//欣興

lead\[80\]=GetSymbolField(\"3042.tw\",\"收盤價\",\"D\");//晶技

lead\[81\]=GetSymbolField(\"3130.tw\",\"收盤價\",\"D\");//104

lead\[82\]=GetSymbolField(\"3231.tw\",\"收盤價\",\"D\");//緯創

lead\[83\]=GetSymbolField(\"3406.tw\",\"收盤價\",\"D\");//玉晶光

lead\[84\]=GetSymbolField(\"3481.tw\",\"收盤價\",\"D\");//群創

lead\[85\]=GetSymbolField(\"3576.tw\",\"收盤價\",\"D\");//聯合再生

lead\[86\]=GetSymbolField(\"3665.tw\",\"收盤價\",\"D\");//貿聯

lead\[87\]=GetSymbolField(\"3702.tw\",\"收盤價\",\"D\");//大聯大

lead\[88\]=GetSymbolField(\"3707.tw\",\"收盤價\",\"D\");//漢磊

lead\[89\]=GetSymbolField(\"3708.tw\",\"收盤價\",\"D\");//上緯

lead\[90\]=GetSymbolField(\"3711.tw\",\"收盤價\",\"D\");//日月光

lead\[91\]=GetSymbolField(\"3714.tw\",\"收盤價\",\"D\");//富采

lead\[92\]=GetSymbolField(\"4438.tw\",\"收盤價\",\"D\");//廣越

lead\[93\]=GetSymbolField(\"5434.tw\",\"收盤價\",\"D\");//崇越

lead\[94\]=GetSymbolField(\"6269.tw\",\"收盤價\",\"D\");//台郡

lead\[95\]=GetSymbolField(\"6285.tw\",\"收盤價\",\"D\");//啟碁

lead\[96\]=GetSymbolField(\"6505.tw\",\"收盤價\",\"D\");//台塑化

lead\[97\]=GetSymbolField(\"9910.tw\",\"收盤價\",\"D\");//豊泰

lead\[98\]=GetSymbolField(\"9921.tw\",\"收盤價\",\"D\");//巨大

lead\[99\]=GetSymbolField(\"8299.tw\",\"收盤價\",\"D\");//群聯

lead\[100\]=GetSymbolField(\"8086.tw\",\"收盤價\",\"D\");//宏捷科

variable:i(0),count(0);

count=0;

for i=1 to 100 begin

if lead\[i\]=highest(lead\[i\],10)

then

count=count+1;

end;

## 場景 308：指標股創新低家數指標 --- 下面是我根據上述的步驟寫的指標腳本

> 來源：[[指標股創新低家數指標]{.underline}](https://www.xq.com.tw/xstrader/%e6%8c%87%e6%a8%99%e8%82%a1%e5%89%b5%e6%96%b0%e4%bd%8e%e5%ae%b6%e6%95%b8%e6%8c%87%e6%a8%99/)
> 說明：下面是我根據上述的步驟寫的指標腳本

array:lead\[100\](0);

array:pcg\[100\](0);

lead\[1\]=GetSymbolField(\"1102.tw\",\"收盤價\",\"D\");//台泥

lead\[2\]=GetSymbolField(\"2317.tw\",\"收盤價\",\"D\");//鴻海

lead\[3\]=GetSymbolField(\"1216.tw\",\"收盤價\",\"D\");//統一

lead\[4\]=GetSymbolField(\"1301.tw\",\"收盤價\",\"D\");//台塑

lead\[5\]=GetSymbolField(\"1304.tw\",\"收盤價\",\"D\");//台聚

lead\[6\]=GetSymbolField(\"1312.tw\",\"收盤價\",\"D\");//國喬

lead\[7\]=GetSymbolField(\"1326.tw\",\"收盤價\",\"D\");//台化

lead\[8\]=GetSymbolField(\"1455.tw\",\"收盤價\",\"D\");//集盛

lead\[9\]=GetSymbolField(\"1476.tw\",\"收盤價\",\"D\");//儒鴻

lead\[10\]=GetSymbolField(\"1477.tw\",\"收盤價\",\"D\");//聚陽

lead\[11\]=GetSymbolField(\"1513.tw\",\"收盤價\",\"D\");//中興電

lead\[12\]=GetSymbolField(\"1515.tw\",\"收盤價\",\"D\");//力山

lead\[13\]=GetSymbolField(\"1521.tw\",\"收盤價\",\"D\");//大億

lead\[14\]=GetSymbolField(\"1527.tw\",\"收盤價\",\"D\");//鑽全

lead\[15\]=GetSymbolField(\"1560.tw\",\"收盤價\",\"D\");//中砂

lead\[16\]=GetSymbolField(\"1565.tw\",\"收盤價\",\"D\");//精華

lead\[17\]=GetSymbolField(\"1582.tw\",\"收盤價\",\"D\");//信錦

lead\[18\]=GetSymbolField(\"1605.tw\",\"收盤價\",\"D\");//華新

lead\[19\]=GetSymbolField(\"1717.tw\",\"收盤價\",\"D\");//長興

lead\[20\]=GetSymbolField(\"1723.tw\",\"收盤價\",\"D\");//中碳

lead\[21\]=GetSymbolField(\"1726.tw\",\"收盤價\",\"D\");//永記

lead\[22\]=GetSymbolField(\"1736.tw\",\"收盤價\",\"D\");//喬山

lead\[23\]=GetSymbolField(\"1773.tw\",\"收盤價\",\"D\");//勝一

lead\[24\]=GetSymbolField(\"1795.tw\",\"收盤價\",\"D\");//美時

lead\[25\]=GetSymbolField(\"1907.tw\",\"收盤價\",\"D\");//永豊餘

lead\[26\]=GetSymbolField(\"2002.tw\",\"收盤價\",\"D\");//中鋼

lead\[27\]=GetSymbolField(\"2006.tw\",\"收盤價\",\"D\");//東鋼

lead\[28\]=GetSymbolField(\"2015.tw\",\"收盤價\",\"D\");//豊興

lead\[29\]=GetSymbolField(\"2029.tw\",\"收盤價\",\"D\");//盛餘

lead\[30\]=GetSymbolField(\"2027.tw\",\"收盤價\",\"D\");//大成鋼

lead\[31\]=GetSymbolField(\"2031.tw\",\"收盤價\",\"D\");//新光鋼

lead\[32\]=GetSymbolField(\"2049.tw\",\"收盤價\",\"D\");//上銀

lead\[33\]=GetSymbolField(\"2059.tw\",\"收盤價\",\"D\");//川湖

lead\[34\]=GetSymbolField(\"2103.tw\",\"收盤價\",\"D\");//台橡

lead\[35\]=GetSymbolField(\"2105.tw\",\"收盤價\",\"D\");//正新

lead\[36\]=GetSymbolField(\"2204.tw\",\"收盤價\",\"D\");//中華車

lead\[37\]=GetSymbolField(\"2207.tw\",\"收盤價\",\"D\");//和泰車

lead\[38\]=GetSymbolField(\"2231.tw\",\"收盤價\",\"D\");//為升

lead\[39\]=GetSymbolField(\"2233.tw\",\"收盤價\",\"D\");//宇隆

lead\[40\]=GetSymbolField(\"2301.tw\",\"收盤價\",\"D\");//光寶

lead\[41\]=GetSymbolField(\"2303.tw\",\"收盤價\",\"D\");//聯電

lead\[42\]=GetSymbolField(\"2308.tw\",\"收盤價\",\"D\");//台達電

lead\[43\]=GetSymbolField(\"2313.tw\",\"收盤價\",\"D\");//華通

lead\[44\]=GetSymbolField(\"2324.tw\",\"收盤價\",\"D\");//仁寶

lead\[45\]=GetSymbolField(\"2327.tw\",\"收盤價\",\"D\");//國巨

lead\[46\]=GetSymbolField(\"2330.tw\",\"收盤價\",\"D\");//台積電

lead\[47\]=GetSymbolField(\"2337.tw\",\"收盤價\",\"D\");//旺宏

lead\[48\]=GetSymbolField(\"2344.tw\",\"收盤價\",\"D\");//華邦電

lead\[49\]=GetSymbolField(\"2345.tw\",\"收盤價\",\"D\");//智邦

lead\[50\]=GetSymbolField(\"2347.tw\",\"收盤價\",\"D\");//聯強

lead\[51\]=GetSymbolField(\"2352.tw\",\"收盤價\",\"D\");//佳世達

lead\[52\]=GetSymbolField(\"2353.tw\",\"收盤價\",\"D\");//宏碁

lead\[53\]=GetSymbolField(\"2354.tw\",\"收盤價\",\"D\");//鴻準

lead\[54\]=GetSymbolField(\"2357.tw\",\"收盤價\",\"D\");//華碩

lead\[55\]=GetSymbolField(\"2368.tw\",\"收盤價\",\"D\");//金像電

lead\[56\]=GetSymbolField(\"2376.tw\",\"收盤價\",\"D\");//技嘉

lead\[57\]=GetSymbolField(\"2377.tw\",\"收盤價\",\"D\");//微星

lead\[58\]=GetSymbolField(\"2379.tw\",\"收盤價\",\"D\");//瑞昱

lead\[59\]=GetSymbolField(\"2382.tw\",\"收盤價\",\"D\");//廣達

lead\[60\]=GetSymbolField(\"2383.tw\",\"收盤價\",\"D\");//台光電

lead\[61\]=GetSymbolField(\"2385.tw\",\"收盤價\",\"D\");//群光

lead\[62\]=GetSymbolField(\"2393.tw\",\"收盤價\",\"D\");//億光

lead\[63\]=GetSymbolField(\"2395.tw\",\"收盤價\",\"D\");//研華

lead\[64\]=GetSymbolField(\"2408.tw\",\"收盤價\",\"D\");//南亞科

lead\[65\]=GetSymbolField(\"2409.tw\",\"收盤價\",\"D\");//友達

lead\[66\]=GetSymbolField(\"2439.tw\",\"收盤價\",\"D\");//美律

lead\[67\]=GetSymbolField(\"2449.tw\",\"收盤價\",\"D\");//京元電

lead\[68\]=GetSymbolField(\"2454.tw\",\"收盤價\",\"D\");//聯發科

lead\[69\]=GetSymbolField(\"2603.tw\",\"收盤價\",\"D\");//長榮

lead\[70\]=GetSymbolField(\"2606.tw\",\"收盤價\",\"D\");//裕民

lead\[71\]=GetSymbolField(\"2610.tw\",\"收盤價\",\"D\");//華航

lead\[72\]=GetSymbolField(\"2615.tw\",\"收盤價\",\"D\");//萬海

lead\[73\]=GetSymbolField(\"2707.tw\",\"收盤價\",\"D\");//晶華

lead\[74\]=GetSymbolField(\"2729.tw\",\"收盤價\",\"D\");//瓦城

lead\[75\]=GetSymbolField(\"2731.tw\",\"收盤價\",\"D\");//雄獅

lead\[76\]=GetSymbolField(\"2912.tw\",\"收盤價\",\"D\");//統一超

lead\[77\]=GetSymbolField(\"3008.tw\",\"收盤價\",\"D\");//大立光

lead\[78\]=GetSymbolField(\"3034.tw\",\"收盤價\",\"D\");//聯詠

lead\[79\]=GetSymbolField(\"3037.tw\",\"收盤價\",\"D\");//欣興

lead\[80\]=GetSymbolField(\"3042.tw\",\"收盤價\",\"D\");//晶技

lead\[81\]=GetSymbolField(\"3130.tw\",\"收盤價\",\"D\");//104

lead\[82\]=GetSymbolField(\"3231.tw\",\"收盤價\",\"D\");//緯創

lead\[83\]=GetSymbolField(\"3406.tw\",\"收盤價\",\"D\");//玉晶光

lead\[84\]=GetSymbolField(\"3481.tw\",\"收盤價\",\"D\");//群創

lead\[85\]=GetSymbolField(\"3576.tw\",\"收盤價\",\"D\");//聯合再生

lead\[86\]=GetSymbolField(\"3665.tw\",\"收盤價\",\"D\");//貿聯

lead\[87\]=GetSymbolField(\"3702.tw\",\"收盤價\",\"D\");//大聯大

lead\[88\]=GetSymbolField(\"3707.tw\",\"收盤價\",\"D\");//漢磊

lead\[89\]=GetSymbolField(\"3708.tw\",\"收盤價\",\"D\");//上緯

lead\[90\]=GetSymbolField(\"3711.tw\",\"收盤價\",\"D\");//日月光

lead\[91\]=GetSymbolField(\"3714.tw\",\"收盤價\",\"D\");//富采

lead\[92\]=GetSymbolField(\"4438.tw\",\"收盤價\",\"D\");//廣越

lead\[93\]=GetSymbolField(\"5434.tw\",\"收盤價\",\"D\");//崇越

lead\[94\]=GetSymbolField(\"6269.tw\",\"收盤價\",\"D\");//台郡

lead\[95\]=GetSymbolField(\"6285.tw\",\"收盤價\",\"D\");//啟碁

lead\[96\]=GetSymbolField(\"6505.tw\",\"收盤價\",\"D\");//台塑化

lead\[97\]=GetSymbolField(\"9910.tw\",\"收盤價\",\"D\");//豊泰

lead\[98\]=GetSymbolField(\"9921.tw\",\"收盤價\",\"D\");//巨大

lead\[99\]=GetSymbolField(\"8299.tw\",\"收盤價\",\"D\");//群聯

lead\[100\]=GetSymbolField(\"8086.tw\",\"收盤價\",\"D\");//宏捷科

variable:i(0),count(0);

count=0;

for i=1 to 100 begin

if lead\[i\]=lowest(lead\[i\],10)

then

count=count+1;

end;

plot1(average(count,5));

## 場景 309：用指標股月營收製定的大盤長線多空指標 --- 首先，我先寫了一個腳本，來計算出我挑出來的，各行各業龍頭，其月營收年增率的總和及移動平均

> 來源：[[用指標股月營收製定的大盤長線多空指標]{.underline}](https://www.xq.com.tw/xstrader/%e7%94%a8%e6%8c%87%e6%a8%99%e8%82%a1%e6%9c%88%e7%87%9f%e6%94%b6%e8%a3%bd%e5%ae%9a%e7%9a%84%e5%a4%a7%e7%9b%a4%e9%95%b7%e7%b7%9a%e5%a4%9a%e7%a9%ba%e6%8c%87%e6%a8%99/)
> 說明：首先，我先寫了一個腳本，來計算出我挑出來的，各行各業龍頭，其月營收年增率的總和及移動平均

array:lead\[100\](0);

array:pcg\[100\](0);

lead\[1\]=GetSymbolField(\"1102.tw\",\"月營收\",\"M\");//台泥

lead\[2\]=GetSymbolField(\"2317.tw\",\"月營收\",\"M\");//鴻海

lead\[3\]=GetSymbolField(\"1216.tw\",\"月營收\",\"M\");//統一

lead\[4\]=GetSymbolField(\"1301.tw\",\"月營收\",\"M\");//台塑

lead\[5\]=GetSymbolField(\"1304.tw\",\"月營收\",\"M\");//台聚

lead\[6\]=GetSymbolField(\"1312.tw\",\"月營收\",\"M\");//國喬

lead\[7\]=GetSymbolField(\"1326.tw\",\"月營收\",\"M\");//台化

lead\[8\]=GetSymbolField(\"1455.tw\",\"月營收\",\"M\");//集盛

lead\[9\]=GetSymbolField(\"1476.tw\",\"月營收\",\"M\");//儒鴻

lead\[10\]=GetSymbolField(\"1477.tw\",\"月營收\",\"M\");//聚陽

lead\[11\]=GetSymbolField(\"1513.tw\",\"月營收\",\"M\");//中興電

lead\[12\]=GetSymbolField(\"1515.tw\",\"月營收\",\"M\");//力山

lead\[13\]=GetSymbolField(\"1521.tw\",\"月營收\",\"M\");//大億

lead\[14\]=GetSymbolField(\"1527.tw\",\"月營收\",\"M\");//鑽全

lead\[15\]=GetSymbolField(\"1560.tw\",\"月營收\",\"M\");//中砂

lead\[16\]=GetSymbolField(\"1565.tw\",\"月營收\",\"M\");//精華

lead\[17\]=GetSymbolField(\"1582.tw\",\"月營收\",\"M\");//信錦

lead\[18\]=GetSymbolField(\"1605.tw\",\"月營收\",\"M\");//華新

lead\[19\]=GetSymbolField(\"1717.tw\",\"月營收\",\"M\");//長興

lead\[20\]=GetSymbolField(\"1723.tw\",\"月營收\",\"M\");//中碳

//lead\[21\]=GetSymbolField(\"1726.tw\",\"月營收\",\"M\");//永記

lead\[22\]=GetSymbolField(\"1736.tw\",\"月營收\",\"M\");//喬山

lead\[23\]=GetSymbolField(\"1773.tw\",\"月營收\",\"M\");//勝一

lead\[24\]=GetSymbolField(\"1795.tw\",\"月營收\",\"M\");//美時

lead\[25\]=GetSymbolField(\"1907.tw\",\"月營收\",\"M\");//永豊餘

lead\[26\]=GetSymbolField(\"2002.tw\",\"月營收\",\"M\");//中鋼

lead\[27\]=GetSymbolField(\"2006.tw\",\"月營收\",\"M\");//東鋼

lead\[28\]=GetSymbolField(\"2015.tw\",\"月營收\",\"M\");//豊興

lead\[29\]=GetSymbolField(\"2029.tw\",\"月營收\",\"M\");//盛餘

lead\[30\]=GetSymbolField(\"2027.tw\",\"月營收\",\"M\");//大成鋼

lead\[31\]=GetSymbolField(\"2031.tw\",\"月營收\",\"M\");//新光鋼

lead\[32\]=GetSymbolField(\"2049.tw\",\"月營收\",\"M\");//上銀

lead\[33\]=GetSymbolField(\"2059.tw\",\"月營收\",\"M\");//川湖

lead\[34\]=GetSymbolField(\"2103.tw\",\"月營收\",\"M\");//台橡

lead\[35\]=GetSymbolField(\"2105.tw\",\"月營收\",\"M\");//正新

lead\[36\]=GetSymbolField(\"2204.tw\",\"月營收\",\"M\");//中華車

lead\[37\]=GetSymbolField(\"2207.tw\",\"月營收\",\"M\");//和泰車

lead\[38\]=GetSymbolField(\"2231.tw\",\"月營收\",\"M\");//為升

lead\[39\]=GetSymbolField(\"2233.tw\",\"月營收\",\"M\");//宇隆

lead\[40\]=GetSymbolField(\"2301.tw\",\"月營收\",\"M\");//光寶

lead\[41\]=GetSymbolField(\"2303.tw\",\"月營收\",\"M\");//聯電

lead\[42\]=GetSymbolField(\"2308.tw\",\"月營收\",\"M\");//台達電

lead\[43\]=GetSymbolField(\"2313.tw\",\"月營收\",\"M\");//華通

lead\[44\]=GetSymbolField(\"2324.tw\",\"月營收\",\"M\");//仁寶

lead\[45\]=GetSymbolField(\"2327.tw\",\"月營收\",\"M\");//國巨

lead\[46\]=GetSymbolField(\"2330.tw\",\"月營收\",\"M\");//台積電

lead\[47\]=GetSymbolField(\"2337.tw\",\"月營收\",\"M\");//旺宏

lead\[48\]=GetSymbolField(\"2344.tw\",\"月營收\",\"M\");//華邦電

lead\[49\]=GetSymbolField(\"2345.tw\",\"月營收\",\"M\");//智邦

lead\[50\]=GetSymbolField(\"2347.tw\",\"月營收\",\"M\");//聯強

lead\[51\]=GetSymbolField(\"2352.tw\",\"月營收\",\"M\");//佳世達

lead\[52\]=GetSymbolField(\"2353.tw\",\"月營收\",\"M\");//宏碁

lead\[53\]=GetSymbolField(\"2354.tw\",\"月營收\",\"M\");//鴻準

lead\[54\]=GetSymbolField(\"2357.tw\",\"月營收\",\"M\");//華碩

lead\[55\]=GetSymbolField(\"2368.tw\",\"月營收\",\"M\");//金像電

lead\[56\]=GetSymbolField(\"2376.tw\",\"月營收\",\"M\");//技嘉

lead\[57\]=GetSymbolField(\"2377.tw\",\"月營收\",\"M\");//微星

lead\[58\]=GetSymbolField(\"2379.tw\",\"月營收\",\"M\");//瑞昱

lead\[59\]=GetSymbolField(\"2382.tw\",\"月營收\",\"M\");//廣達

lead\[60\]=GetSymbolField(\"2383.tw\",\"月營收\",\"M\");//台光電

lead\[61\]=GetSymbolField(\"2385.tw\",\"月營收\",\"M\");//群光

lead\[62\]=GetSymbolField(\"2393.tw\",\"月營收\",\"M\");//億光

lead\[63\]=GetSymbolField(\"2395.tw\",\"月營收\",\"M\");//研華

lead\[64\]=GetSymbolField(\"2408.tw\",\"月營收\",\"M\");//南亞科

lead\[65\]=GetSymbolField(\"2409.tw\",\"月營收\",\"M\");//友達

lead\[66\]=GetSymbolField(\"2439.tw\",\"月營收\",\"M\");//美律

lead\[67\]=GetSymbolField(\"2449.tw\",\"月營收\",\"M\");//京元電

lead\[68\]=GetSymbolField(\"2454.tw\",\"月營收\",\"M\");//聯發科

lead\[69\]=GetSymbolField(\"2603.tw\",\"月營收\",\"M\");//長榮

lead\[70\]=GetSymbolField(\"2606.tw\",\"月營收\",\"M\");//裕民

lead\[71\]=GetSymbolField(\"2610.tw\",\"月營收\",\"M\");//華航

lead\[72\]=GetSymbolField(\"2615.tw\",\"月營收\",\"M\");//萬海

lead\[73\]=GetSymbolField(\"2707.tw\",\"月營收\",\"M\");//晶華

lead\[74\]=GetSymbolField(\"2729.tw\",\"月營收\",\"M\");//瓦城

lead\[75\]=GetSymbolField(\"2731.tw\",\"月營收\",\"M\");//雄獅

lead\[76\]=GetSymbolField(\"2912.tw\",\"月營收\",\"M\");//統一超

lead\[77\]=GetSymbolField(\"3008.tw\",\"月營收\",\"M\");//大立光

lead\[78\]=GetSymbolField(\"3034.tw\",\"月營收\",\"M\");//聯詠

lead\[79\]=GetSymbolField(\"3037.tw\",\"月營收\",\"M\");//欣興

lead\[80\]=GetSymbolField(\"3042.tw\",\"月營收\",\"M\");//晶技

lead\[81\]=GetSymbolField(\"3130.tw\",\"月營收\",\"M\");//104

lead\[82\]=GetSymbolField(\"3231.tw\",\"月營收\",\"M\");//緯創

lead\[83\]=GetSymbolField(\"3406.tw\",\"月營收\",\"M\");//玉晶光

lead\[84\]=GetSymbolField(\"3481.tw\",\"月營收\",\"M\");//群創

lead\[85\]=GetSymbolField(\"3576.tw\",\"月營收\",\"M\");//聯合再生

lead\[86\]=GetSymbolField(\"3665.tw\",\"月營收\",\"M\");//貿聯

lead\[87\]=GetSymbolField(\"3702.tw\",\"月營收\",\"M\");//大聯大

lead\[88\]=GetSymbolField(\"3707.tw\",\"月營收\",\"M\");//漢磊

//lead\[89\]=GetSymbolField(\"3708.tw\",\"月營收\",\"M\");//上緯

//lead\[90\]=GetSymbolField(\"3711.tw\",\"月營收\",\"M\");//日月光

//lead\[91\]=GetSymbolField(\"3714.tw\",\"月營收\",\"M\");//富采

lead\[92\]=GetSymbolField(\"4438.tw\",\"月營收\",\"M\");//廣越

lead\[93\]=GetSymbolField(\"5434.tw\",\"月營收\",\"M\");//崇越

lead\[94\]=GetSymbolField(\"6269.tw\",\"月營收\",\"M\");//台郡

lead\[95\]=GetSymbolField(\"6285.tw\",\"月營收\",\"M\");//啟碁

lead\[96\]=GetSymbolField(\"6505.tw\",\"月營收\",\"M\");//台塑化

lead\[97\]=GetSymbolField(\"9910.tw\",\"月營收\",\"M\");//豊泰

lead\[98\]=GetSymbolField(\"9921.tw\",\"月營收\",\"M\");//巨大

lead\[99\]=GetSymbolField(\"8299.tw\",\"月營收\",\"M\");//群聯

lead\[100\]=GetSymbolField(\"8086.tw\",\"月營收\",\"M\");//宏捷科

variable:i(0);

for i=1 to 100 begin

if lead\[i\]\[12\]\<\>0

then

pcg\[i\]=(lead\[i\]-lead\[i\]\[12\])/lead\[i\]\[12\];

end;

value1=array_sum(pcg,1,100);

value2=average(value1,4);

plot1(value1);

plot2(value2);

## 場景 310：如何找到 大股東持股增加的股票

> 來源：[[如何找到
> 大股東持股增加的股票]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e6%89%be%e5%88%b0-%e5%a4%a7%e8%82%a1%e6%9d%b1%e6%8c%81%e8%82%a1%e5%a2%9e%e5%8a%a0%e7%9a%84%e8%82%a1%e7%a5%a8/)

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

value2=GetField(\"地緣券商買賣超張數\",\"D\");

if GetField(\"內部人持股比例\",\"M\")

\>=GetField(\"內部人持股比例\",\"M\")\[1\]

and GetField(\"大戶持股比例\",\"W\",param := 1000)

\>=GetField(\"大戶持股比例\",\"W\",param := 1000)\[1\]+0.5

and value1\>=0

and value2\>=0

then ret=1;

outputfield(1,GetField(\"內部人持股比例\",\"M\"),0,\"內部人\");

outputfield(2,GetField(\"內部人持股比例\",\"M\")\[1\],0,\"前期內部人\");

outputfield(3,value1,0,\"關鍵券商\");

outputfield(4,value2,0,\"地緣券商\");

outputfield(5,GetField(\"大戶持股比例\",\"W\",param :=
1000),1,\"千張大戶比例\");

outputfield(6,GetField(\"大戶持股比例\",\"W\",param :=
1000)\[1\],1,\"前期千張大戶比例\");

## 場景 311：如何找到每年配息穩定成長 的公司 --- 下面兩個條件我是寫成選股腳本，腳本如下：

> 來源：[[如何找到每年配息穩定成長
> 的公司]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e6%89%be%e5%88%b0%e6%af%8f%e5%b9%b4%e9%85%8d%e6%81%af%e7%a9%a9%e5%ae%9a%e6%88%90%e9%95%b7-%e7%9a%84%e5%85%ac%e5%8f%b8/)
> 說明：下面兩個條件我是寫成選股腳本，腳本如下：

if trueall(getField(\"現金股利\", \"Y\")\>getField(\"現金股利\",
\"Y\")\[1\],5)

and getField(\"現金股利\", \"Y\")\>2

then ret=1;

outputfield(1,getField(\"現金股利\", \"Y\"),1,\"現金股利\");

outputfield(2,getFielddate(\"現金股利\", \"Y\"),0,\"現金股利期別\");

## 場景 312：好股票好價格系列之二 --- 對於這個條件設的比較嚴，我這裡的好價格是指目前的股價要低於每股淨值加上自由支配現金，這代表只要公司維持目前的營運水準，股價已經低於現有的淨值加上新創造出來的現金\...

> 來源：[[好股票好價格系列之二]{.underline}](https://www.xq.com.tw/xstrader/%e5%a5%bd%e8%82%a1%e7%a5%a8%e5%a5%bd%e5%83%b9%e6%a0%bc%e7%b3%bb%e5%88%97%e4%b9%8b%e4%ba%8c/)
> 說明：對於這個條件設的比較嚴，我這裡的好價格是指目前的股價要低於每股淨值加上自由支配現金，這代表只要公司維持目前的營運水準，股價已經低於現有的淨值加上新創造出來的現金，這個條件必須寫成以下的腳本

value1=getField(\"稅前息前折舊前淨利\", \"Q\");

value2=getField(\"資本支出金額\", \"Q\");

value3=getField(\"股本(億)\", \"D\");

value4=(value1-value2)/(value3\*10);

//每股自由支配現金

value5=getField(\"每股淨值(元)\", \"Q\");

if (value4\*4+value5)\>close

and value4\>0

then ret=1;

outputfield(1,value4\*4+value5,1,\"每股淨值+自由現金\");

outputfield(2,value4\*4,1,\"每股自由現金\");

outputfield(3,value5,1,\"每股淨值\");

## 場景 313：好股票好價格系列之三 --- 至於好價格的定義則是「加入研發費用計算的本益比夠低」，這個條件的腳本如下：

> 來源：[[好股票好價格系列之三]{.underline}](https://www.xq.com.tw/xstrader/%e5%a5%bd%e8%82%a1%e7%a5%a8%e5%a5%bd%e5%83%b9%e6%a0%bc%e7%b3%bb%e5%88%97%e4%b9%8b%e4%b8%89/)
> 說明：至於好價格的定義則是「加入研發費用計算的本益比夠低」，這個條件的腳本如下：

value1=getField(\"本期稅後淨利\", \"Q\")+getField(\"本期稅後淨利\",
\"Q\")\[1\]

+getField(\"本期稅後淨利\", \"Q\")\[2\]+getField(\"本期稅後淨利\",
\"Q\")\[3\];

value2=getField(\"股本(億)\", \"D\");

value3=getField(\"研發費用\", \"Q\")+getField(\"研發費用\", \"Q\")\[1\]

+getField(\"研發費用\", \"Q\")\[2\]+getField(\"研發費用\", \"Q\")\[3\];

value4=(value1+value3)/(value2\*10);

if value4\<\>0 then

value5=close/value4;

input:highbond(8,\"上限\");

if value5\<=highbond

and value5\>0 then ret=1;

outputfield(1,value5,0,\"考慮研發費用的本益比\");

outputfield(2,value4,1,\"加計研發費用的每股盈餘\");

## 場景 314：大修正後的抄底系列之三\~抄底腳本之大跌後長黑後的長紅

> 來源：[[大修正後的抄底系列之三\~抄底腳本之大跌後長黑後的長紅]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e4%bf%ae%e6%ad%a3%e5%be%8c%e7%9a%84%e6%8a%84%e5%ba%95%e7%b3%bb%e5%88%97%e4%b9%8b%e4%b8%89%e6%8a%84%e5%ba%95%e8%85%b3%e6%9c%ac%e4%b9%8b%e5%a4%a7%e8%b7%8c%e5%be%8c%e9%95%b7%e9%bb%91%e5%be%8c/)

if close\*1.2849\<close\[30\]

//波段下跌超過28.49%

then begin

if close\[1\]\*1.05\<close\[2\]

//前天下跌超過5%

and close\>1.05\*close\[1\]

//昨天上漲超過5%

then ret=1;

end;

## 場景 315：跌多少、跌多久才值得開始抄底？ --- 請大家跑一下，下方的選股腳本：

> 來源：[[跌多少、跌多久才值得開始抄底？]{.underline}](https://www.xq.com.tw/xstrader/%e8%b7%8c%e5%a4%9a%e5%b0%91%e3%80%81%e8%b7%8c%e5%a4%9a%e4%b9%85%e6%89%8d%e5%80%bc%e5%be%97%e9%96%8b%e5%a7%8b%e6%8a%84%e5%ba%95%ef%bc%9f/)
> 說明：請大家跑一下，下方的選股腳本：

value1=close/close\[30\]-1;

if value1\>-0.703448

and value1\<-0.284939047

then ret=1;

## 場景 316：大修正後的抄底系列之一\~ 來研判是反彈還是回升的領先指標 --- 這個指標的腳本如下，大家可以複制到腳本編輯器裡，不用自己一檔一檔敲。

> 來源：[[大修正後的抄底系列之一\~
> 來研判是反彈還是回升的領先指標]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e4%bf%ae%e6%ad%a3%e5%be%8c%e7%9a%84%e6%8a%84%e5%ba%95%e7%b3%bb%e5%88%97%e4%b9%8b%e4%b8%80-%e4%be%86%e7%a0%94%e5%88%a4%e6%98%af%e5%8f%8d%e5%bd%88%e9%82%84%e6%98%af%e5%9b%9e%e5%8d%87/)
> 說明：這個指標的腳本如下，大家可以複制到腳本編輯器裡，不用自己一檔一檔敲。

setbackbar(200);

settotalbar(1000);

array:T50\[100\](0);

t50\[1\]=GetSymbolField(\"5876.tw\",\"close\");

t50\[2\]=GetSymbolField(\"2317.tw\",\"close\");

t50\[3\]=GetSymbolField(\"2412.tw\",\"close\");

t50\[4\]=GetSymbolField(\"1301.tw\",\"close\");

t50\[5\]=GetSymbolField(\"1303.tw\",\"close\");

t50\[6\]=GetSymbolField(\"2454.tw\",\"close\");

t50\[7\]=GetSymbolField(\"1326.tw\",\"close\");

t50\[8\]=GetSymbolField(\"2308.tw\",\"close\");

t50\[9\]=GetSymbolField(\"2882.tw\",\"close\");

t50\[10\]=GetSymbolField(\"2881.tw\",\"close\");

t50\[11\]=GetSymbolField(\"2891.tw\",\"close\");

t50\[12\]=GetSymbolField(\"2002.tw\",\"close\");

t50\[13\]=GetSymbolField(\"1216.tw\",\"close\");

t50\[14\]=GetSymbolField(\"3008.tw\",\"close\");

t50\[15\]=GetSymbolField(\"2886.tw\",\"close\");

t50\[16\]=GetSymbolField(\"3711.tw\",\"close\");

t50\[17\]=GetSymbolField(\"2357.tw\",\"close\");

t50\[18\]=GetSymbolField(\"2474.tw\",\"close\");

t50\[19\]=GetSymbolField(\"3045.tw\",\"close\");

t50\[20\]=GetSymbolField(\"6505.tw\",\"close\");

t50\[21\]=GetSymbolField(\"2303.tw\",\"close\");

t50\[22\]=GetSymbolField(\"2382.tw\",\"close\");

t50\[23\]=GetSymbolField(\"2207.tw\",\"close\");

t50\[24\]=GetSymbolField(\"2892.tw\",\"close\");

t50\[25\]=GetSymbolField(\"4938.tw\",\"close\");

t50\[26\]=GetSymbolField(\"2884.tw\",\"close\");

t50\[27\]=GetSymbolField(\"2912.tw\",\"close\");

t50\[28\]=GetSymbolField(\"2885.tw\",\"close\");

t50\[29\]=GetSymbolField(\"2883.tw\",\"close\");

t50\[30\]=GetSymbolField(\"2105.tw\",\"close\");

t50\[31\]=GetSymbolField(\"2880.tw\",\"close\");

t50\[32\]=GetSymbolField(\"2330.tw\",\"close\");

t50\[33\]=GetSymbolField(\"4904.tw\",\"close\");

t50\[34\]=GetSymbolField(\"5880.tw\",\"close\");

t50\[35\]=GetSymbolField(\"2823.tw\",\"close\");

t50\[36\]=GetSymbolField(\"9904.tw\",\"close\");

t50\[37\]=GetSymbolField(\"1402.tw\",\"close\");

t50\[38\]=GetSymbolField(\"1101.tw\",\"close\");

t50\[39\]=GetSymbolField(\"2887.tw\",\"close\");

t50\[40\]=GetSymbolField(\"2890.tw\",\"close\");

t50\[41\]=GetSymbolField(\"2801.tw\",\"close\");

t50\[42\]=GetSymbolField(\"2633.tw\",\"close\");

t50\[43\]=GetSymbolField(\"5871.tw\",\"close\");

t50\[44\]=GetSymbolField(\"2301.tw\",\"close\");

t50\[45\]=GetSymbolField(\"2395.tw\",\"close\");

t50\[46\]=GetSymbolField(\"2354.tw\",\"close\");

t50\[47\]=GetSymbolField(\"9904.tw\",\"close\");

t50\[48\]=GetSymbolField(\"1102.tw\",\"close\");

t50\[49\]=GetSymbolField(\"2408.tw\",\"close\");

t50\[50\]=GetSymbolField(\"2227.tw\",\"close\");

t50\[51\]=GetSymbolField(\"2409.tw\",\"close\");

t50\[52\]=GetSymbolField(\"6669.tw\",\"close\");

t50\[53\]=GetSymbolField(\"2377.tw\",\"close\");

t50\[54\]=GetSymbolField(\"2888.tw\",\"close\");

t50\[55\]=GetSymbolField(\"4958.tw\",\"close\");

t50\[56\]=GetSymbolField(\"3037.tw\",\"close\");

t50\[57\]=GetSymbolField(\"2301.tw\",\"close\");

t50\[58\]=GetSymbolField(\"9921.tw\",\"close\");

t50\[59\]=GetSymbolField(\"2049.tw\",\"close\");

t50\[60\]=GetSymbolField(\"5269.tw\",\"close\");

t50\[61\]=GetSymbolField(\"1476.tw\",\"close\");

t50\[62\]=GetSymbolField(\"3481.tw\",\"close\");

t50\[63\]=GetSymbolField(\"8464.tw\",\"close\");

t50\[64\]=GetSymbolField(\"8454.tw\",\"close\");

t50\[65\]=GetSymbolField(\"2823.tw\",\"close\");

t50\[66\]=GetSymbolField(\"2603.tw\",\"close\");

t50\[67\]=GetSymbolField(\"3231.tw\",\"close\");

t50\[68\]=GetSymbolField(\"2324.tw\",\"close\");

t50\[69\]=GetSymbolField(\"2633.tw\",\"close\");

t50\[70\]=GetSymbolField(\"2356.tw\",\"close\");

t50\[71\]=GetSymbolField(\"9904.tw\",\"close\");

t50\[72\]=GetSymbolField(\"8046.tw\",\"close\");

t50\[73\]=GetSymbolField(\"2492.tw\",\"close\");

t50\[74\]=GetSymbolField(\"6409.tw\",\"close\");

t50\[75\]=GetSymbolField(\"2354.tw\",\"close\");

t50\[76\]=GetSymbolField(\"2353.tw\",\"close\");

t50\[77\]=GetSymbolField(\"2834.tw\",\"close\");

t50\[78\]=GetSymbolField(\"2227.tw\",\"close\");

t50\[79\]=GetSymbolField(\"2347.tw\",\"close\");

t50\[80\]=GetSymbolField(\"9914.tw\",\"close\");

t50\[81\]=GetSymbolField(\"6239.tw\",\"close\");

t50\[82\]=GetSymbolField(\"3702.tw\",\"close\");

t50\[83\]=GetSymbolField(\"2360.tw\",\"close\");

t50\[84\]=GetSymbolField(\"3406.tw\",\"close\");

t50\[85\]=GetSymbolField(\"2385.tw\",\"close\");

t50\[86\]=GetSymbolField(\"9945.tw\",\"close\");

t50\[87\]=GetSymbolField(\"2337.tw\",\"close\");

t50\[88\]=GetSymbolField(\"3044.tw\",\"close\");

t50\[89\]=GetSymbolField(\"1504.tw\",\"close\");

t50\[90\]=GetSymbolField(\"1227.tw\",\"close\");

t50\[91\]=GetSymbolField(\"2313.tw\",\"close\");

t50\[92\]=GetSymbolField(\"2618.tw\",\"close\");

t50\[93\]=GetSymbolField(\"1605.tw\",\"close\");

t50\[94\]=GetSymbolField(\"2542.tw\",\"close\");

t50\[95\]=GetSymbolField(\"2344.tw\",\"close\");

t50\[96\]=GetSymbolField(\"1434.tw\",\"close\");

t50\[97\]=GetSymbolField(\"1229.tw\",\"close\");

t50\[98\]=GetSymbolField(\"2376.tw\",\"close\");

t50\[99\]=GetSymbolField(\"1722.tw\",\"close\");

t50\[100\]=GetSymbolField(\"2610.tw\",\"close\");

variable:count(0),i(0);

count=0;

for i=1 to 100 begin

if t50\[i\] \> average(t50\[i\],22)

then count=count+1;

end;

plot1(average(count,3)-50);

## 場景 317：打造專屬的抄底指標 --- 前幾天，同事問說能不能把怪傑33的抄底指標在XQ量化平台寫成指標給大家參考，我試著寫了一個如下，先聲明，這只是個Sample,目的是讓大家可以盡情的用這個Sam\...

> 來源：[[打造專屬的抄底指標]{.underline}](https://www.xq.com.tw/xstrader/%e6%89%93%e9%80%a0%e5%b0%88%e5%b1%ac%e7%9a%84%e6%8a%84%e5%ba%95%e6%8c%87%e6%a8%99/)
> 說明：前幾天，同事問說能不能把怪傑33的抄底指標在XQ量化平台寫成指標給大家參考，我試著寫了一個如下，先聲明，這只是個Sample,目的是讓大家可以盡情的用這個Sample套上自己中意的抄底指標，然後應用在K線上，附圖是這個Sample跑在幾檔藍籌股上的圖，我寫的腳本如下：

if close\*1.05\<close\[20\] then begin

//20個交易日跌超過5%

if barfreq \<\> \"D\"

then raiseruntimeerror(\"不支援此頻率\");

//只有在日線適用

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

switch(close) begin

case \>150: value5=low\*0.9;

case \<50 : value5=low\*0.98;

default: value5=low\*0.95;

end;

//用value5來代表在K線上標註的進場點，讓他顯示在K線的下方

//==========法說會前大股東買超================

input: N1(5, \"連續 N1 日成交量 \> X1 張，N1\");

input: X1(500, \"連續 N1 日成交量 \> X1 張，X1\");

input: N2(14, \"N2 日內有法說會，N1\");

input: N3(3, \"N3 日內主力買超數量總計佔成交量 X2 %，N3\");

input: X3(2, \"N3 日內主力買超數量總計佔成交量 X2 %，X2\");

// 連續 N1 日成交量 \> X1 張

Condition11 = trueall(volume \> X1, N1);

// N2 日內有法說會

value1 = DateDiff(GetField(\"法說會日期\"), Date);

Condition12 = 0 \< value1 and value1 \< N2;

// N3 日內主力買超數量總計佔成交量 X3 %

Condition13 = summation(GetField(\"主力買賣超張數\",\"D\"), N3)

\> summation(volume, N3) \* X3 / 100;

// 關鍵券商買超

Condition14 = GetField(\"關鍵券商買賣超張數\",\"D\") \> 0;

if condition11 and condition12 and condition13 and condition14

then condition1=true;

if condition1 then

plot1(value5,\" 法說會前公司派買超\");

//============股價接近主力成本線====================

value1=GetField(\"主力買張\");

value2=(o+h+l+c)/4;

value3=value1\*value2;//做多金額

if summation(value1,40)\<\>0 then

value4=summation(value3,40)/summation(value1,40);

//金額除以張數等於成本

if absValue(value4/close-1)\<0.04

then

condition2=true;

if condition2 then

plot2(value5\*0.99,\"股價接近主力成本線\");

//===========近兩日主力買超==============

if trueall(GetField(\"主力買賣超張數\",\"D\")\>500,2)

then

condition3=true;

if condition3 then

plot3(value5\*0.98,\"近兩日主力買超\");

//===========資金重新回到該類股================

value6=GetField(\"成交金額\",\"D\");

value7=GetSymbolField(\"tse.tw\",\"成交金額\",\"D\");

if value6\<\>0 then value8=value6/value7\*100;

value9=average(value8,20);

value10=value8/value9;

if value10\>1.1 then

condition4=true;

if condition4=true then

plot4(value5\*0.97,\"籌碼收集\");

//===========法人同步買超====================

variable: v1(0),v2(0),v3(0),c1(0);

v1=GetField(\"外資買賣超\");

v2=GetField(\"投信買賣超\");

v3=GetField(\"自營商買賣超\");

c1= barslast(minlist2(v1,v2,v3)\>100);

if c1=0 and c1\[1\]\>10 then

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

if c6=0 and c6\[1\]\>10 then

condition6=true;

if condition6 then

plot6(value5\*0.95,\"DIF-MACD 翻正\");

//========開盤委買遞增======================

var:o1(0);

o1=getField(\"開盤委買\", \"D\");

if o1\>o1\[1\] and o1\[1\]\>o1\[2\] then

condition7=true;

if condition7 then

plot7(value5\*0.94,\"開盤委買遞增\");

//=========總成交次數明顯增加================

variable: t1(0),mat1(0),c8(0);

t1=GetField(\"總成交次數\",\"D\");

mat1=average(t1,20)\*1.1;

c8=barslast(t1 crosses over mat1 and close\>close\[1\]);

if c8=0 and c8\[1\]\>20 then

condition8=true;

if condition8 then

plot8(value5\*0.93,\"成交次數明顯增加\");

//=========連兩日股價表現優於大盤==================

variable:s1(0),c9(0);

s1=GetField(\"強弱指標\",\"D\");

c9=barslast(trueall(s1\>0,2));

if c9=0 and c9\[1\]\>20 then

condition9=true;

if condition9 then

plot9(value5\*0.92,\"連兩日股價表現優於大盤\");

//============股價跌回BBand下緣後回升================

input:length(20);

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 = bollingerband(Close, Length, 1);

down1 = bollingerband(Close, Length, -1 );

mid1 = (up1 + down1) / 2;

if absValue(close/down1-1)\<0.03

and close\>close\[1\]

and down1\>down1\[1\]

and down1\[1\]\>down1\[2\]

then condition10=true;

if condition10 then

plot10(value5\*0.91,\"股價跌回BBand下緣後回升\");

end;

## 場景 318：上漲家數指標 --- 今天跟大家介紹的是一個叫作上漲家數指標，這個指標的寫法如下：

> 來源：[[上漲家數指標]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%8a%e6%bc%b2%e5%ae%b6%e6%95%b8%e6%8c%87%e6%a8%99/)
> 說明：今天跟大家介紹的是一個叫作上漲家數指標，這個指標的寫法如下：

input:shortterm(5,\"短期均線\");

value1=GetField(\"上漲家數\");

value2=average(value1,shortterm);

plot1(value2,\"均線\");

plot2(600);

plot3(300);

## 場景 319：均買均賣張指標

> 來源：[[均買均賣張指標]{.underline}](https://www.xq.com.tw/xstrader/%e5%9d%87%e8%b2%b7%e5%9d%87%e8%b3%a3%e5%bc%b5%e6%8c%87%e6%a8%99/)
> 說明：這個指標的腳本如下：

value1=getField(\"委買均\", \"D\");

value2=getField(\"委賣均\", \"D\");

value3=value1-value2;

plot1(value3,\"委買委賣均張差\");

plot2(value1,\"委買均張\");

plot3(value2,\"委賣均張\");

## 場景 320：外盤量佔比指標 --- 在研判大盤後市時，另一個我很常用的指標是外盤量佔比指標，這個指標的腳本如下

> 來源：[[外盤量佔比指標]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%96%e7%9b%a4%e9%87%8f%e4%bd%94%e6%af%94%e6%8c%87%e6%a8%99-2/)
> 說明：在研判大盤後市時，另一個我很常用的指標是外盤量佔比指標，這個指標的腳本如下

value1=getField(\"內盤量\");

value2=getField(\"外盤量\");

input:period(5,\"計算區間\");

value3=summation(value1,period);//區間內盤量合計

value4=summation(value2,period);//區間外盤量合計

value5=value3+value4;//區間內外盤量合計

if value5\<\>0 then

value6=value4/value5\*100;

plot1(value6,\"外盤量佔比指標\");

plot2(50);

plot3(45);

## 場景 321：法人賣出比重 --- 今天來跟大家介紹法人賣出比重這個指標，首先也是先跟大家介紹指標的腳本：

> 來源：[[法人賣出比重]{.underline}](https://www.xq.com.tw/xstrader/%e6%b3%95%e4%ba%ba%e8%b3%a3%e5%87%ba%e6%af%94%e9%87%8d/)
> 說明：今天來跟大家介紹法人賣出比重這個指標，首先也是先跟大家介紹指標的腳本：

value1=GetField(\"法人賣出比重\");

value2=average(value1,5);

plot1(value2,\"法人賣出比重\");

plot2(30);

plot3(20);

## 場景 322：主力作多成本線

> 來源：[[主力作多成本線]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%bb%e5%8a%9b%e4%bd%9c%e5%a4%9a%e6%88%90%e6%9c%ac%e7%b7%9a-2/)

input:period(40);

value1=GetField(\"主力買張\");

value2=(o+h+l+c)/4;

value3=value1\*value2;//做多金額

if summation(value1,period)\<\>0

then value4=summation(value3,period)/summation(value1,period);

//主力作多金額除以主力買張

plot1(value4,\"主力作多成本線\");

## 場景 323：外資成本線 --- 外資成本線的指標腳本如下：

> 來源：[[外資成本線]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%96%e8%b3%87%e6%88%90%e6%9c%ac%e7%b7%9a/)
> 說明：外資成本線的指標腳本如下：

Input: period(40, \"期間(天)\");

variable: avg_b(0);

if GetField(\"Volume\") \> 0 then

Value5 = GetField(\"外資買張\")\*GetField(\"成交金額\")

/(GetField(\"Volume\")\*1000)

else

Value5 = 0;

Value1 = summation(Value5, period);

Value2 = summation(GetField(\"外資買張\"), period);

if Value2 \> 0 and Value2 \<\> Value2\[1\]

then avg_b = Value1 / Value2;

plot1(avg_b,\"外資成本線\");

## 場景 324：實質成交值指標

> 來源：[[實質成交值指標]{.underline}](https://www.xq.com.tw/xstrader/%e5%af%a6%e8%b3%aa%e6%88%90%e4%ba%a4%e5%80%bc%e6%8c%87%e6%a8%99/)

value1=(open+high+low+close)/4;

value2=getField(\"現股當沖張數\");

value3=getField(\"資券互抵張數\");

value4=volume-value2-value3;

value5=value1\*value4\*1000;

input:period(7,\"移動平均天期\");

value6=average(value5,period);

plot1(value6,\"實質成交值指標\");

## 場景 325：資金供需指標 --- 根據這樣的概念，我寫的自訂指標腳本如下：

> 來源：[[資金供需指標]{.underline}](https://www.xq.com.tw/xstrader/%e8%b3%87%e9%87%91%e4%be%9b%e9%9c%80%e6%8c%87%e6%a8%99/)
> 說明：根據這樣的概念，我寫的自訂指標腳本如下：

settotalbar(200);

//計算近200根

if close\>close\[1\]

then value1=value1\[1\]+volume

//從第一根起累計上漲時的成交量

else

if close\<close\[1\]

then

value2=value2\[1\]+volume

//從第一根起累計下跌時的成交量

else begin

value1=value1\[1\];

value2=value2\[1\];

//如果股價平盤就不計當日量

end;

value3=value1-value2;

//累計上漲量減下跌量

value4=average(value3,10);

//取n日移動平均

plot1(value3,\"net\");

plot2(value4,\"av\");

## 場景 326：我常用的選股策略系列之42\~估值合理且投信進場的股票

> 來源：[[我常用的選股策略系列之42\~估值合理且投信進場的股票]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b42%e4%bc%b0%e5%80%bc%e5%90%88%e7%90%86%e4%b8%94%e6%8a%95%e4%bf%a1%e9%80%b2%e5%a0%b4%e7%9a%84/)

value1=GetField(\"總市值\",\"D\");//單位億

value2=GetField(\"負債總額\",\"Q\");//單位百萬

value3=GetField(\"現金及約當現金\",\"Q\");//單位百萬

value4=GetField(\"短期投資\",\"Q\");//單位百萬

value5=GetField(\"稅前息前折舊前淨利\",\"Q\");//單位百萬

var: pricingm1(0);

input: bl(5,\"上限值\");

if value5\>0 then begin

pricingm1=(value1\*100+value2-value3-value4)/summation(value5,4);

if pricingm1\<bl and pricingm1\>1

then ret=1;

outputfield(1,pricingm1,1,\"EV/EBITDA\");

outputfield(2,value1\*100+value2-value3-value4,0,\"EV\");

outputfield(3,value5,0,\"EBITDA\");

outputfield(4,value1,0,\"總市值\");

outputfield(5,value2,0,\"負債總額\");

outputfield(6,value3,0,\"現金\");

outputfield(7,value4,0,\"短期投資\");

end;

## 場景 327：我常用的選股策略系列之40\~班哲明格拉罕低本益比法

> 來源：[[我常用的選股策略系列之40\~班哲明格拉罕低本益比法]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b40%e7%8f%ad%e5%93%b2%e6%98%8e%e6%a0%bc%e6%8b%89%e7%bd%95%e4%bd%8e%e6%9c%ac%e7%9b%8a%e6%af%94/)

input:PriceLimit(5),Length(5), VolumeLimit(500);

SetInputName(1, \"最小股價\");

SetInputName(2, \"均量天期\");

SetInputName(3, \"最小均量\");

SetTotalBar(3);

Value1 = Average(volume,Length);

if close \> PriceLimit and Value1 \> VolumeLimit

Then ret = 1;

## 場景 328：我常用的選股策略系列之38\~存股標的短線有大拉回

> 來源：[[我常用的選股策略系列之38\~存股標的短線有大拉回]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b38%e5%ad%98%e8%82%a1%e6%a8%99%e7%9a%84%e7%9f%ad%e7%b7%9a%e6%9c%89%e5%a4%a7%e6%8b%89%e5%9b%9e/)

value1=GetField(\"營業毛利率\",\"Q\");

input:ratio(10,\"毛利率單季衰退幅度上限\");

input:period(10,\"計算的期間，單位是季\");

if trueall(value1\>value1\[1\]\*(1-ratio/100),period)

then ret=1;

## 場景 329：我常用的選股策略系列之37\~不明買盤介入

> 來源：[[我常用的選股策略系列之37\~不明買盤介入]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b37%e4%b8%8d%e6%98%8e%e8%b2%b7%e7%9b%a4%e4%bb%8b%e5%85%a5/)

input:period(5 ,\"均線期間\");

input:ratio(30 ,\"不明買盤比重%\");

settotalbar(period + 7);

value1=GetField(\"法人買張\",\"D\")\[1\];

value2=GetField(\"資券互抵張數\",\"D\")\[1\];

value3=GetField(\"散戶買張\",\"D\")\[1\];

value4=getField(\"現股當沖張數\", \"D\")\[1\];

value5=volume\[1\] - value1 - value2 - value3-value4;

//算出每天扣除法人，散戶，當沖，資券互抵等的成交量

//這樣的成交量就算是不明買盤

value6=value5\*100/volume\[1\]; // 不明買盤的比重

value7=average(value6,period);

//取幾日平均值

if value7 crosses over ratio

//不明買盤的比重突破一定比重

and (getField(\"投信買賣超\", \"D\")\>200

and getField(\"外資買賣超\", \"D\")\>500)

//法人都開始進場

then ret=1;

## 場景 330：我常用的選股策略系列之36\~長期低價的前績優股 --- 1.過去N年裡有一年EPS超過M元。這代表這家公司過往曾經有不錯的表現，對應的腳本如下：

> 來源：[[我常用的選股策略系列之36\~長期低價的前績優股]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b36%e9%95%b7%e6%9c%9f%e4%bd%8e%e5%83%b9%e7%9a%84%e5%89%8d%e7%b8%be%e5%84%aa%e8%82%a1/)
> 說明：1.過去N年裡有一年EPS超過M元。這代表這家公司過往曾經有不錯的表現，對應的腳本如下：

input:period(7,\"年期\");

input:l1(3,\"eps\");

value1=GetField(\"每股稅後淨利(元)\",\"Y\");

if trueany(value1\>=l1,period)

then ret=1;

## 場景 331：我常用的選股策略系列之36\~長期低價的前績優股 --- 2.過去X日股價都小於Y元，代表有一陣子股價並沒有突出的表現，對應的腳本如下：

> 來源：[[我常用的選股策略系列之36\~長期低價的前績優股]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b36%e9%95%b7%e6%9c%9f%e4%bd%8e%e5%83%b9%e7%9a%84%e5%89%8d%e7%b8%be%e5%84%aa%e8%82%a1/)
> 說明：2.過去X日股價都小於Y元，代表有一陣子股價並沒有突出的表現，對應的腳本如下：

input:period(400,\"天期\");

input:l1(30,\"股價上限\");

if trueall(high\<=l1,period)

then ret=1;

## 場景 332：我常用的選股策略系列之34\~地緣券商連5日買超

> 來源：[[我常用的選股策略系列之34\~地緣券商連5日買超]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b34%e5%9c%b0%e7%b7%a3%e5%88%b8%e5%95%86%e9%80%a35%e6%97%a5%e8%b2%b7%e8%b6%85/)

input:period(5,\"最近n日\");

value1=GetField(\"地緣券商買賣超張數\",\"D\");

if trueall(value1\>200,period)

then ret=1;

## 場景 333：我常用的選股策略系列之33\~好久不見的五連陽

> 來源：[[我常用的選股策略系列之33\~好久不見的五連陽]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b33%e5%a5%bd%e4%b9%85%e4%b8%8d%e8%a6%8b%e7%9a%84%e4%ba%94%e9%80%a3%e9%99%bd/)

settotalbar(100);

if trueall(close\>close\[1\],5)

and barslast(trueall(close\>close\[1\],5))\[1\]\>60

then ret=1;

## 場景 334：我常用的選股策略系列之31\~成長股落入合理價位

> 來源：[[我常用的選股策略系列之31\~成長股落入合理價位]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b31%e6%88%90%e9%95%b7%e8%82%a1%e8%90%bd%e5%85%a5%e5%90%88%e7%90%86%e5%83%b9%e4%bd%8d/)

value1=GetField(\"月營收\",\"M\")

+GetField(\"月營收\",\"M\")\[1\]+GetField(\"月營收\",\"M\")\[2\];//億

outputfield(1,value1,1,\"近三月營收合計(億)\");

value2=GetField(\"營業利益率\",\"Q\");

outputfield(2,value2,1,\"營業利益率\");

value3=value1\*4\*value2/100;

value4=GetField(\"最新股本\");//億

variable:FEPS(0);

FEPS=value3/value4\*10;

input:per(10,\"合理本益比\");

var:parvalue(0);

parvalue=feps\*per;

input:disr(15,\"折價率\");

if close\*(1+disr/100)\<parvalue

then ret=1;

## 場景 335：我常用的選股策略系列之30\~ 估值合理且萬方擁戴的個股

> 來源：[[我常用的選股策略系列之30\~
> 估值合理且萬方擁戴的個股]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b30-%e4%bc%b0%e5%80%bc%e5%90%88%e7%90%86%e4%b8%94%e8%90%ac%e6%96%b9%e6%93%81%e6%88%b4%e7%9a%84/)

input:m1(\"不符合\"),m2(\"符合\");

variable:s1(\"\"),s2(\"\"),s3(\"\"),s4(\"\"),s5(\"\");

variable:count(0);

condition1=false;

condition2=false;

condition3=false;

condition4=false;

condition5=false;

count=0;

//用最近三個月營收推估的獲利殖利率高於一定水準

value1=GetField(\"營業利益\",\"Q\");//單位:百萬

value2=GetField(\"月營收\",\"M\");//單位:億

value3=GetField(\"營業利益率\",\"Q\");

value4=GETFIELD(\"月營收\",\"M\")+GETFIELD(\"月營收\",\"M\")\[1\]

+GETFIELD(\"月營收\",\"M\")\[2\];

//近三個月營收

value5=value4\*value3/100;

//用最近一期營益率去估算的最近一季營業利益

value6=GetField(\"營業利益\",\"Q\")+GetField(\"營業利益\",\"Q\")\[1\]

+GetField(\"營業利益\",\"Q\")\[2\]+value5\*100;

//前三季營業利益加上最近一季預估營業利益

value8=GetField(\"最新股本\");//單位億

value9=value6/(value8\*100)\*10;

//估算出來的EPS

value10=value9/close\*100;

//eps/股價\*100: 預估殖利率

input:r1(5,\"殖利率下限\");

if value10\>r1 and value3\>0 and close\>10

then begin

condition1=true ;

s1=m2;

count=count+1;

end else

s1=m1;

//本業推估本益比低於N

input:epsl(15,\"預估本益比上限\");

value11= GetField(\"營業利益\",\"Q\")+GetField(\"營業利益\",\"Q\")\[1\]

+GetField(\"營業利益\",\"Q\")\[2\]+GetField(\"營業利益\",\"Q\")\[3\];

value12= GetField(\"最新股本\");//單位億;

value13= value11/(value12\*10);//每股預估EPS

if close/value13\<=epsl then begin

condition2=true ;

s2=m2;

count=count+1;

end else

s2=m1;

//流動資產減負債超過市值N成

input:ratio(80,\"佔總市值百分比%\");

if (GetField(\"流動資產\",\"Q\")-GetField(\"負債總額\",\"Q\"))/100

\>GetField(\"總市值\",\"D\")\*ratio/100

then begin condition3=true ;

s3=m2;

count=count+1;

end else

s3=m1;

//股價低於N年平均股利的N倍

input:N1(16,\"股利的倍數\");

value15=(GetField(\"股利合計\",\"Y\")

+GetField(\"股利合計\",\"Y\")\[1\]

+GetField(\"股利合計\",\"Y\")\[2\]

+GetField(\"股利合計\",\"Y\")\[3\]

+GetField(\"股利合計\",\"Y\")\[4\])/5;

if close\<value15\*N1 then begin

condition4=true ;

s4=m2;

count=count+1;

end else

s4=m1;

//高自由現金流總市值比

input:ratio1(10,\"近四季自由現金流總合佔總市值最低比率單位:%\");

if (GetField(\"來自營運之現金流量\",\"Q\")

+GetField(\"來自營運之現金流量\",\"Q\")\[1\]+

GetField(\"來自營運之現金流量\",\"Q\")\[2\]

+GetField(\"來自營運之現金流量\",\"Q\")\[3\]

-GetField(\"資本支出金額\",\"Q\")-GetField(\"資本支出金額\",\"Q\")\[1\]

-GetField(\"資本支出金額\",\"Q\")\[2\]-GetField(\"資本支出金額\",\"Q\")\[3\])

\>GetField(\"總市值\",\"D\")\*100\*ratio1/100

then begin

condition5=true ;

s5=m2;

count=count+1;

end else

s5=m1;

if count\>1

//符合至少兩個條件

then ret=1;

outputfield(1,count,0,\"符合條件數\");

outputfield(2,value9,1,\"預估EPS\");

outputfield(3,s1,0,\"高預估殖利率股\");

outputfield(4,s2,0,\"本業推估本益比低\");

outputfield(5,s3,0,\"流動性淨資產接近市值\");

outputfield(6,s4,0,\"以歷年平均股利計算之高殖利率股\");

outputfield(7,s5,0,\"高自由現金流總市值比\");

## 場景 336：我常用的選股策略系列之27\~本益比不高的隱形冠軍 --- 既然是隱形冠軍，那就代表市場沒有很注意，所以我設了一個五日均量\<2000張的條件，最後在進場時點的掌握上，我用了本業預估本益比低於8這個腳本，腳本如下：

> 來源：[[我常用的選股策略系列之27\~本益比不高的隱形冠軍]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b27%e6%9c%ac%e7%9b%8a%e6%af%94%e4%b8%8d%e9%ab%98%e7%9a%84%e9%9a%b1%e5%bd%a2%e5%86%a0%e8%bb%8d/)
> 說明：既然是隱形冠軍，那就代表市場沒有很注意，所以我設了一個五日均量\<2000張的條件，最後在進場時點的掌握上，我用了本業預估本益比低於8這個腳本，腳本如下：

input:epsl(8,\"預估本益比上限\");

value3= summation(GetField(\"營業利益\",\"Q\"),4); //單位百萬;

value4= GetField(\"最新股本\");//單位億;

value5= value3/(value4\*10);//每股預估EPS

if value5\>0 and close/value5\<=epsl

then ret=1;

## 場景 337：我常用的選股策略系列之24\~大股東站在買方 --- 我先前有跟大家分享大股東站在買方這個腳本

> 來源：[[我常用的選股策略系列之24\~大股東站在買方]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b24%e5%a4%a7%e8%82%a1%e6%9d%b1%e7%ab%99%e5%9c%a8%e8%b2%b7%e6%96%b9/)
> 說明：我先前有跟大家分享大股東站在買方這個腳本

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

if GetField(\"內部人持股比例\",\"M\")

\>GetField(\"內部人持股比例\",\"M\")\[1\]

or GetField(\"大戶持股比例\",\"W\",param := 1000)

\>GetField(\"大戶持股比例\",\"W\",param := 1000)\[1\]+0.5

or value1\>=500

then ret=1;

outputfield(1,GetField(\"內部人持股比例\",\"M\"),0,\"內部人\");

outputfield(2,GetField(\"內部人持股比例\",\"M\")\[1\],0,\"前期內部人\");

outputfield(3,value1,0,\"關鍵券商\");

outputfield(4,GetField(\"大戶持股比例\",\"W\",param :=
1000),1,\"千張大戶比例\");

outputfield(5,GetField(\"大戶持股比例\",\"W\",param :=
1000)\[1\],1,\"前期千張大戶比例\");

## 場景 338：我常用的選股策略系列之25\~即將進入季節性旺季

> 來源：[[我常用的選股策略系列之25\~即將進入季節性旺季]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b25%e5%8d%b3%e5%b0%87%e9%80%b2%e5%85%a5%e5%ad%a3%e7%af%80%e6%80%a7%e6%97%ba%e5%ad%a3/)
> 說明：我用的腳本如下

array:m1\[10\](0);

variable:x(0),count(0);

count=0;

for x=1 to 10

begin

m1\[x\]=(close\[12\*x-1\]-close\[12\*x\]);

if m1\[x\]\>0

then count=count+1;

end;

if count\>=9

then ret=1;

outputfield(1,count,0,\"符合的次數\");

## 場景 339：我常用的選股策略系列之23\~低本益比的定存股

> 來源：[[我常用的選股策略系列之23\~低本益比的定存股]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b23%e4%bd%8e%e6%9c%ac%e7%9b%8a%e6%af%94%e7%9a%84%e5%ae%9a%e5%ad%98%e8%82%a1/)

input:peuplimit(15,\"預估本益比上限\");

value3= summation(GetField(\"營業利益\",\"Q\"),4); //單位百萬;

value4= GetField(\"最新股本\");//單位億;

value5= value3/(value4\*10);//每股預估EPS

if value5\>0 and close/value5\<=peuplimit

then ret=1;

## 場景 340：我常用的選股策略系列之22\~大跌時籌碼在集中且投信有參加

> 來源：[[我常用的選股策略系列之22\~大跌時籌碼在集中且投信有參加]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b22%e5%a4%a7%e8%b7%8c%e6%99%82%e7%b1%8c%e7%a2%bc%e5%9c%a8%e9%9b%86%e4%b8%ad%e4%b8%94%e6%8a%95/)

input:period(20);

value1=GetField(\"分公司賣出家數\")\[1\];

value2=GetField(\"分公司買進家數\")\[1\];

if linearregslope(value1,period)\>0

//賣出的家數愈來愈多

and linearregslope(value2,period)\<0

//買進的家數愈來愈少

and close\*1.05\<close\[period\]

//但這段期間股價在跌

and close\*1.25\<close\[40\]

//波段跌幅夠大

then ret=1;

## 場景 341：我常用的選股策略系列之19\~ 跌深的績優股近日主力買超

> 來源：[[我常用的選股策略系列之19\~
> 跌深的績優股近日主力買超]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b19-%e8%b7%8c%e6%b7%b1%e7%9a%84%e7%b8%be%e5%84%aa%e8%82%a1%e8%bf%91%e6%97%a5%e4%b8%bb%e5%8a%9b/)

input:n1(3,\"每股稅後淨利最低標準\");

value1=GetField(\"每股稅後淨利(元)\",\"Q\");

value2=summation(value1,4);

//算出近四季EPS總和

if value2\>=n1

//近四季EPS總和要大於三元

and close\*1.3\<close\[39\]

//近四十個交易日股價要下跌三成以上

then ret=1;

## 場景 342：我常用的選股策略系列之18\~ 主力與代操共襄盛舉 的股票

> 來源：[[我常用的選股策略系列之18\~ 主力與代操共襄盛舉
> 的股票]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b18-%e4%b8%bb%e5%8a%9b%e8%88%87%e4%bb%a3%e6%93%8d%e5%85%b1%e8%a5%84%e7%9b%9b%e8%88%89-%e7%9a%84/)

value1=getField(\"主力買賣超張數\", \"D\");

value2=getField(\"綜合前十大券商買賣超張數\", \"D\");

value3=GetField(\"投信持股比例\");

value4=GetField(\"股本(億)\",\"D\");

input: plus(500,\"主力比代操多買超的張數\");

input: plus1(500,\"代操買超張數下限\");

input: ratio(20,\"代操+主力買超佔成交量比例下限\");

if value3\<5

//投信持股比例不到5%

and value1\>value2+plus

//主力買超張數大於代操買超張數超過下限

and value2\>plus1

//代操買超大於下限

and value4\<50

//股本小於50億

and (value1+value2)/volume\>=ratio/100

//主力買超與代操買超合計大於成交量一定比例

and volume\>1500

//成交量大於1500張

then ret=1;

## 場景 343：我常用的選股策略系列之17\~ 大跌後轉強且投信認同的股票

> 來源：[[我常用的選股策略系列之17\~
> 大跌後轉強且投信認同的股票]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b17-%e5%a4%a7%e8%b7%8c%e5%be%8c%e8%bd%89%e5%bc%b7%e4%b8%94%e6%8a%95%e4%bf%a1%e8%aa%8d%e5%90%8c/)

input:Length(6,\"N期內\");

input:Times(2,\"創M次以上長紅\");

## 場景 344：我常用的選股策略系列之17\~ 大跌後轉強且投信認同的股票

> 來源：[[我常用的選股策略系列之17\~
> 大跌後轉強且投信認同的股票]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b17-%e5%a4%a7%e8%b7%8c%e5%be%8c%e8%bd%89%e5%bc%b7%e4%b8%94%e6%8a%95%e4%bf%a1%e8%aa%8d%e5%90%8c/)

for i = 0 to la begin

if close\[i\]\>=close\[i+1\] \*1.045

then

o1+=1;　　

end;

if o1 \>= Times

then ret=1;

## 場景 345：我常用的選股策略系列之16\~ 由投信主導的盤整後創新高 --- 以下是我寫的腳本 供各位參考 裡頭的參數都是可以修改的，我喜歡透過這樣的方式去找出那些盤整後突破的股票，有那一些是由投信在主導的，有興趣的朋友可以試看看

> 來源：[[我常用的選股策略系列之16\~
> 由投信主導的盤整後創新高]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b16-%e7%94%b1%e6%8a%95%e4%bf%a1%e4%b8%bb%e5%b0%8e%e7%9a%84%e7%9b%a4%e6%95%b4%e5%be%8c%e5%89%b5/)
> 說明：以下是我寫的腳本 供各位參考
> 裡頭的參數都是可以修改的，我喜歡透過這樣的方式去找出那些盤整後突破的股票，有那一些是由投信在主導的，有興趣的朋友可以試看看

Input:PLen(18),PRatio(8);

Input:Period(3);

Var:Amount(0),VRatio(0);

Amount=getField(\"投信買賣超\", \"D\");

VRatio=100\*Summation(Amount,2)

/Summation(V-GetField(\"當日沖銷張數\"),2);

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 盤整

Condition2=(Highest(H\[1\],PLen)-Lowest(L\[1\],PLen))/C\[1\]\<=0.01\*PRatio;

// 創高轉強

Condition3=H=Highest(H,PLen) and C\*1.032\>H and L\>L\[1\];;

// 70E\<市值\<700E

Condition4=GetField(\"總市值(億)\",\"D\")\>70

and GetField(\"總市值(億)\",\"D\")\<=700;

// 個股條件

Condition100=Condition2 and Condition3 and Condition4;

//\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

// 選股條件

// 均成交金額\>0.2E

Condition101=Average(GetField(\"成交金額(億)\",\"D\"),Period)\>=0.2;

// 投信區間買超

Condition102=VRatio\>=5 and GetField(\"投信持股比例\",\"D\")\<3.3;

// 個股條件(籌碼相關)

Condition200=Condition101 and Condition102;

// 篩選

If Condition100 and Condition200 Then

Ret=1;

以下是對應的回測報告

## 場景 346：我常用的選股策略系列之15\~找小型電子股的選股策略 --- 根據這樣的想法，寫成了以下的腳本

> 來源：[[我常用的選股策略系列之15\~找小型電子股的選股策略]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b15%e6%89%be%e5%b0%8f%e5%9e%8b%e9%9b%bb%e5%ad%90%e8%82%a1%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96/)
> 說明：根據這樣的想法，寫成了以下的腳本

value1=getField(\"總市值(億)\", \"D\");//億

value2=getField(\"研發費用\", \"Y\");//百萬

value3=value1/value2\*100;

input:ratio(8,\"市值研發費用最高倍數上限\");

if value3\<ratio then ret=1;

## 場景 347：我常用的選股策略系列之14\~主力與投信共襄盛舉的中小型股 --- 根據上述這四個條件，我寫的腳本如下

> 來源：[[我常用的選股策略系列之14\~主力與投信共襄盛舉的中小型股]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b14%e4%b8%bb%e5%8a%9b%e8%88%87%e6%8a%95%e4%bf%a1%e5%85%b1%e8%a5%84%e7%9b%9b%e8%88%89%e7%9a%84/)
> 說明：根據上述這四個條件，我寫的腳本如下

value1=GetField(\"主力買張\");

value2=GetField(\"投信買張\");

value3=GetField(\"投信買賣超\");

value4=GetField(\"投信持股比例\");

value5=GetField(\"股本(億)\",\"D\");

if value4\<5

//投信持股比例不到5%

and value1\>value2+1000

//主力買進張數大於投信買進張數一千張

and value3\>1000

//投信買超大於1000張

and value5\<50

//股本小於50億

then ret=1;

## 場景 348：我常用的選股策略系列之13\~各方勢力一湧而上的股票

> 來源：[[我常用的選股策略系列之13\~各方勢力一湧而上的股票]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b13%e5%90%84%e6%96%b9%e5%8b%a2%e5%8a%9b%e4%b8%80%e6%b9%a7%e8%80%8c%e4%b8%8a%e7%9a%84%e8%82%a1/)

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

value2=GetField(\"地緣券商買賣超張數\",\"D\");

value3=GetField(\"綜合前十大券商買賣超張數\",\"D\");

value4=GetField(\"外資買賣超\",\"D\");

value5=GetField(\"投信買賣超\",\"D\");

value6=GetField(\"自營商自行買賣買賣超\",\"D\");

value7=GetField(\"主力買賣超張數\",\"D\");

value8=value1+value2+value3+value4+value5+value6+value7;

//這些各方勢力買超合計的張數

value9=value8/volume\*100;

//合計佔成交量的比重

var:count(0);

condition1=false;

count=0;

if value1\>0 then count=count+1;

if value2\>0 then count=count+1;

if value3\>0 then count=count+1;

if value4\>0 then count=count+1;

if value5\>0 then count=count+1;

if value6\>0 then count=count+1;

if value7\>0 then count=count+1;

if volume\>2000

//成交量大於2000張

and count\>=6

//七項至少六項是買超

and value9\>60

//合計買超張數佔成交量達六成以上

then condition1=true;

if barslast(condition1)=0

//最近一期符合上述條件

## 場景 349：我常用的選股策略系列之11\~ K在低檔回升且外資投信同步買超

> 來源：[[我常用的選股策略系列之11\~
> K在低檔回升且外資投信同步買超]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b11-k%e5%9c%a8%e4%bd%8e%e6%aa%94%e5%9b%9e%e5%8d%87%e4%b8%94%e5%a4%96%e8%b3%87%e6%8a%95%e4%bf%a1/)

settotalbar(100);

var:rsv1(0),k1(0),d1(0);

stochastic(9,3,3,rsv1,k1,d1);

condition1=k1 cross over 20;

value1=GetField(\"外資買賣超\",\"D\");

value2=GetField(\"投信買賣超\",\"D\");

condition2=value1\>500 and value2\>200;

if condition1 and condition2 then ret=1;

## 場景 350：我常用的選股策略系列之10 \~ 葛林布萊特的神奇公式

> 來源：[[我常用的選股策略系列之10 \~
> 葛林布萊特的神奇公式]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b10-%e8%91%9b%e6%9e%97%e5%b8%83%e8%90%8a%e7%89%b9%e7%9a%84%e7%a5%9e%e5%a5%87%e5%85%ac%e5%bc%8f/)

input:r1(10,\"盈餘殖利率\");

value1=getField(\"稅前息前淨利\", \"Q\");//EBIT 百萬

value2=getField(\"流動資產\", \"Q\")-getField(\"流動負債\",
\"Q\");//超額現金 百萬

value3=getField(\"總市值(億)\", \"D\")\*100+getField(\"負債總額\",
\"Q\")-value2;//總企業價值

value4=value1/value3\*100;

if value4\>r1 then ret=1;

outputField(1,value4,1,\"盈餘殖利率\");

## 場景 351：我常用的選股策略系列之8\~ ADX由負轉正的藍籌股 --- ADX由負轉正的腳本我列在下面

> 來源：[[我常用的選股策略系列之8\~
> ADX由負轉正的藍籌股]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b8-adx%e7%94%b1%e8%b2%a0%e8%bd%89%e6%ad%a3%e7%9a%84%e8%97%8d%e7%b1%8c%e8%82%a1/)
> 說明：ADX由負轉正的腳本我列在下面

input: Length(14,\"期數\"), Threshold(25,\"穿越值\");

variable: pdi_value(0), ndi_value(0), adx_value(0);

DirectionMovement(Length, pdi_value, ndi_value, adx_value);

value1=average(adx_value,5);

if linearregslope(value1,20)\<0

and linearregslope(value1,10)cross over 0

then ret=1;

## 場景 352：我常用的選股策略系列之7\~用月營收預估低本益比股 --- 第三個條件是一個選股腳本，腳本的程式碼如下

> 來源：[[我常用的選股策略系列之7\~用月營收預估低本益比股]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b7%e7%94%a8%e6%9c%88%e7%87%9f%e6%94%b6%e9%a0%90%e4%bc%b0%e4%bd%8e%e6%9c%ac%e7%9b%8a%e6%af%94%e8%82%a1/)
> 說明：第三個條件是一個選股腳本，腳本的程式碼如下

value1=GetField(\"月營收\",\"M\")

+GetField(\"月營收\",\"M\")\[1\]+GetField(\"月營收\",\"M\")\[2\];//億

outputfield(1,value1,1,\"近三月營收合計(億)\");

value2=GetField(\"營業利益率\",\"Q\");

outputfield(2,value2,1,\"營業利益率\");

value3=value1\*4\*value2/100;

//用最近三個月的營收乘以最近一季營業利益率來估算全年本業獲利

value4=GetField(\"最新股本\");//億

variable:FEPS(0);

FEPS=value3/value4\*10;

//用這樣估算的本業獲利來算預估的EPS

outputfield(3,FEPS,2,\"預估本業EPS\");

if feps\<\>0

then value5=close/feps;

outputfield(4,value5,\"預估本益比\");

input:pe(8,\"預估本益比上限\");

if //getfieldDate(\"營業利益率\", \"Q\")=20201201

//and

value5\<pe and value5\>4

then ret=1;

outputfield(5,value4,0,\"股本億元\");

## 場景 353：我常用的選股策略系列之4：融資大減但大股東站買方 --- 融資近40天減少超過3000張 且近三日每天都上漲這個條件的腳本如下，也可以直接從選股條件中作設定

> 來源：[[我常用的選股策略系列之4：融資大減但大股東站買方]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b4%ef%bc%9a%e8%9e%8d%e8%b3%87%e5%a4%a7%e6%b8%9b%e4%bd%86%e5%a4%a7%e8%82%a1%e6%9d%b1%e7%ab%99%e8%b2%b7/)
> 說明：融資近40天減少超過3000張
> 且近三日每天都上漲這個條件的腳本如下，也可以直接從選股條件中作設定

input: period(40,\"計算區間\");

input: v1(3000,\"融資減少張數\");

settotalbar(45);

value2 = GetField(\"融資餘額張數\")\[period\] -
GetField(\"融資餘額張數\")\[1\];

if value2 \> v1 and

trueall(close \> close\[1\],3)

then ret=1;

## 場景 354：我常用的選股策略系列之4：融資大減但大股東站買方

> 來源：[[我常用的選股策略系列之4：融資大減但大股東站買方]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b4%ef%bc%9a%e8%9e%8d%e8%b3%87%e5%a4%a7%e6%b8%9b%e4%bd%86%e5%a4%a7%e8%82%a1%e6%9d%b1%e7%ab%99%e8%b2%b7/)
> 說明：這個條件的腳本如下：

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

if GetField(\"內部人持股比例\",\"M\")

\>GetField(\"內部人持股比例\",\"M\")\[1\]

or GetField(\"大戶持股比例\",\"W\",param := 1000)

\>GetField(\"大戶持股比例\",\"W\",param := 1000)\[1\]+0.5

or value1\>=500

then ret=1;

outputfield(1,GetField(\"內部人持股比例\",\"M\"),0,\"內部人\");

outputfield(2,GetField(\"內部人持股比例\",\"M\")\[1\],0,\"前期內部人\");

outputfield(3,value1,0,\"關鍵券商\");

outputfield(4,GetField(\"大戶持股比例\",\"W\",param :=
1000),1,\"千張大戶比例\");

outputfield(5,GetField(\"大戶持股比例\",\"W\",param :=
1000)\[1\],1,\"前期千張大戶比例\");

## 場景 355：我常用的選股策略系列之1:股價領先創百日新高的個股

> 來源：[[我常用的選股策略系列之1:股價領先創百日新高的個股]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%91%e5%b8%b8%e7%94%a8%e7%9a%84%e9%81%b8%e8%82%a1%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b1%e8%82%a1%e5%83%b9%e9%a0%98%e5%85%88%e5%89%b5%e7%99%be%e6%97%a5%e6%96%b0%e9%ab%98%e7%9a%84%e5%80%8b/)
> 說明：這個策略的腳本如下

Input:SPeriod(13),LPeriod(100);

// 計算

// 條件

// 連續5日成交量\>500

Condition1=trueall(V\>500,5);

// 創區間新高

Condition20=H=Highest(H,LPeriod);

Condition2=Condition20 and Not Condition20\[1\];

// 區間壓縮

Condition3=(Highest(C,SPeriod)-Lowest(C,SPeriod))/Lowest(C,SPeriod)\<0.05;

// 創區間大量

Condition4=V=Highest(V,SPeriod);

// 大盤趨勢向上

Condition100=Condition1 and Condition2 and Condition3 and Condition4 ;

// 篩選

If Condition100 Then Ret=1;

## 場景 356：走進我的交易室之2 上漲家數指標

> 來源：[[走進我的交易室之2
> 上漲家數指標]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e6%88%91%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a4%e4%b9%8b2-%e4%b8%8a%e6%bc%b2%e5%ae%b6%e6%95%b8%e6%8c%87%e6%a8%99/)
> 說明：這個指標的寫法如下

input:shortterm(5,\"短期均線\");

value1=GetField(\"上漲家數\");

value2=average(value1,shortterm);

plot1(value2,\"均線\");

plot2(600);

plot3(300);

## 場景 357：走進我的交易室之4\~均買均賣張指標

> 來源：[[走進我的交易室之4\~均買均賣張指標]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e6%88%91%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a4%e4%b9%8b4%e5%9d%87%e8%b2%b7%e5%9d%87%e8%b3%a3%e5%bc%b5%e6%8c%87%e6%a8%99/)
> 說明：這個指標的腳本如下

value1=getField(\"委買均\", \"D\");

value2=getField(\"委賣均\", \"D\");

value3=value1-value2;

plot1(value3,\"委買委賣均張差\");

plot2(value1,\"委買均張\");

plot3(value2,\"委賣均張\");

## 場景 358：走進我的交易室之5\~外盤量佔比指標 --- 在研判大盤後市時，另一個我很常用的指標是外盤量佔比指標，這個指標的腳本如下

> 來源：[[走進我的交易室之5\~外盤量佔比指標]{.underline}](https://www.xq.com.tw/xstrader/%e8%b5%b0%e9%80%b2%e6%88%91%e7%9a%84%e4%ba%a4%e6%98%93%e5%ae%a4%e4%b9%8b5%e5%a4%96%e7%9b%a4%e9%87%8f%e4%bd%94%e6%af%94%e6%8c%87%e6%a8%99/)
> 說明：在研判大盤後市時，另一個我很常用的指標是外盤量佔比指標，這個指標的腳本如下

value1=getField(\"內盤量\");

value2=getField(\"外盤量\");

input:period(5,\"計算區間\");

value3=summation(value1,period);//區間內盤量合計

value4=summation(value2,period);//區間外盤量合計

value5=value3+value4;//區間內外盤量合計

if value5\<\>0 then

value6=value4/value5\*100;

plot1(value6,\"外盤量佔比指標\");

plot2(50);

plot3(45);

## 場景 359：常用的語法匯總 --- 我把常用的一些語法匯總在這裡給大家參考，這樣大家就可以直接取用，不用再自己另外撰寫

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：我把常用的一些語法匯總在這裡給大家參考，這樣大家就可以直接取用，不用再自己另外撰寫

input:P1(1000,\"暴量張數定義\");

if barfreq \<\> \"Tick\" then RaiseRuntimeError(\"請設定頻率為TICK\");

variable:BarNumberOfToday(0);

if Date \<\> Date\[1\] then BarNumberOfToday=1

else BarNumberOfToday+=1;{記錄今天的Bar數}

if currenttime \< 090500 and date =currentdate {必需在9:05以前發生}

then begin {計算拉升時總張數}

variable: HighBar(NthHighestBar(1,Close,BarNumberOfToday));
{找到出現最高價那根Bar}

variable:idx(BarNumberOfToday-1),PullVolume(0),DropVolume(0);

for idx = BarNumberOfToday-1 to HighBar

{從開盤那個Bar,拉升到最高點那個Bar,上漲過程累計量}

begin

PullVolume += volume\[idx\]; {拉升的量}

end;

if PullVolume \> P1 then ret=1;

end;

## 場景 360：常用的語法匯總

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)

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

## 場景 361：常用的語法匯總

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：分鐘量暴量N%

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

## 場景 362：常用的語法匯總 --- 以下腳本程式碼其中有一個estvolume自訂函數，在連結的文章中有做介紹，請注意要新增並編譯完成estvolume函數腳本後，才能取用此函數到其他腳本中。

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：以下腳本程式碼其中有一個estvolume自訂函數，在連結的文章中有做介紹，請注意要新增並編譯完成estvolume函數腳本後，才能取用此函數到其他腳本中。

input: VLength(20,\"均量期數\");

input: volpercent(60,\"爆量增幅%\");

input: r1(5,\"區間高低差%\");

input: period(30,\"盤整最小期數\");

if Close crosses above highest(high\[1\],period)//股價突破盤整區間

and

estvolume \> average(volume,VLength) \*(1+ volpercent/100)//暴量

and

highest(high,period)\<=lowest(low,period)\*(1+r1/100)//先前區間盤整

then ret=1;

## 場景 363：常用的語法匯總

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：箱型整理突破

input:period(40,\"計算區間\");

value1=highest(close\[1\],period);

value2=lowest(close\[1\],period);

if value1\<value2\*1.05

and close\>close\[2\]\*1.006

and close crosses over value1

and volume\>average(volume\[1\],20)\*1.3

then ret=1;

## 場景 364：常用的語法匯總

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：波動範圍變大

value1=truerange;

value2=highest(value1,20);

if value1\>value2\[1\]

and value1\>value1\[1\]

and close\*1.01\>high

and close\>close\[1\]

and volume\>1000

then ret=1;

## 場景 365：常用的語法匯總 --- 底部愈墊愈高且資金流入

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：底部愈墊愈高且資金流入

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

Value5=average(GetField(\"資金流向\")\[1\],13);

if linearregslope(Value5,5) \> 0

then condition2=true;

if condition1 and condition2

then ret=1;

## 場景 366：常用的語法匯總

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：股價突破布林值上緣

input:length(20,\"布林值計算天數\");

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 = bollingerband(Close, Length, 2);

//以上是計算布林值的上軌值

input: day(9, \"日KD期間\");

variable:rsv_d(0),kk_d(0),dd_d(0);

stochastic(day, 3, 3, rsv_d, kk_d, dd_d);

//以上是計算KD值

if kk_d \>=80

//KD鈍化

and close crosses over up1

then ret=1;

## 場景 367：常用的語法匯總 --- 在新增「突破下降趨勢線」腳本前，請大家記得要先新增 angleprice 自訂函數，此自訂函數的腳本程式碼如下：

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：在新增「突破下降趨勢線」腳本前，請大家記得要先新增 angleprice
> 自訂函數，此自訂函數的腳本程式碼如下：

input:Date1(numeric),ang(numeric);

variable:Date1Price(0);

Date1Price =Open\[Date1\];

value1=tan(ang);

value2=date1price\*(1+value1\*date1/100);

angleprice=value2;

## 場景 368：常用的語法匯總 --- 新增並編譯完成 angleprice 自訂函數後，即可撰寫「突破下降趨勢線」的腳本：

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：新增並編譯完成 angleprice
> 自訂函數後，即可撰寫「突破下降趨勢線」的腳本：

setbackbar(60);

variable:keyprice(0);

value1=highestbar(high,20);

value2=swinghighbar(close,20,2,2,2);

if value2\<\>-1 then begin

value3=angle(date\[value1\],date\[value2\]);

keyprice=angleprice(value1,value3);

if value1\>value2

and trueall(close \>keyprice,3)

and close\>keyprice\*1.05

and close\[40\]\*1.1\<highest(high,20)

then ret=1;

end;

## 場景 369：常用的語法匯總

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)

input: BigBuy(500); setinputname(1,\"大戶買單(萬)\");

input: BigBuyTimes(10); setinputname(2,\"大戶買進次數\");

input:TXT(\"須逐筆洗價\"); setinputname(3,\"使用限制:\");

variable: intrabarpersist Xtime(0);//計數器

variable: intrabarpersist Volumestamp(0);

Volumestamp =q_DailyVolume;

if Date \<\> currentdate or Volumestamp = Volumestamp\[1\] then Xtime
=0; //開盤那根要歸0次數

if q_tickvolume\*q_Last \> BigBuy\*10 and q_BidAskFlag=1 then Xtime+=1;
//量夠大就加1次

if Xtime \> BigBuyTimes then ret=1;

## 場景 370：常用的語法匯總

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：價量背離後跌破

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

## 場景 371：常用的語法匯總

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：回檔後籌碼收集

condition1=false;

value1=GetField(\"分公司買進家數\")\[1\];

value2=GetField(\"分公司賣出家數\")\[1\];

value3=value2-value1;

value4=countif(value3\>20,10);

value5=GetField(\"投信買張\")\[1\];

value6=summation(value5,5);

if countif(value6\>=1000,60)\>=1

then condition1=true;

//過去60個交易日投信曾五天買超過2000張

if value4\>=6

//最近十天有六天以上，籌碼是收集的

and close\[30\]\>close\*1.1

//最近三十天跌超過一成

and condition1

then ret=1;

## 場景 372：常用的語法匯總

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：突破外資成本線

Input: period(20, \"期間(天)\");

variable: avg_b(0);

value3=GetField(\"成交金額\")/(GetField(\"Volume\")\*1000);

//當日均價

if GetField(\"Volume\") \> 0 then

Value5 = GetField(\"外資買張\")\*value3

//外資買進金額

else

Value5 = 0;

Value1 = summation(Value5, period);

Value2 = summation(GetField(\"外資買張\"), period);

if Value2 \> 0 then avg_b = Value1 / Value2;

if close crosses over avg_b then ret=1;

## 場景 373：常用的語法匯總

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：內外盤力道空翻多

variable:IORatio(0),z(1);

if GetField(\"內盤量\")\[z\]\<\>0 then

IORatio=GetField(\"外盤量\")\[z\]/GetField(\"內盤量\")\[z\]-1

{每天的內外盤力道比例}

else

ioratio=ioratio\[1\];

variable:iHigh(0),iLow(10000);

if IORatio \> 0.5 then

begin

iHigh = H;

end

else if IORatio \< -0.5 then

begin

iLow = L;

end;

if iHigh crosses over iLow then ret=1;

## 場景 374：常用的語法匯總

> 來源：[[常用的語法匯總]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%b8%e7%94%a8%e7%9a%84%e8%aa%9e%e6%b3%95%e5%8c%af%e7%b8%bd/)
> 說明：開盤委買暴增

input:length(5);

value1=GetField(\"開盤委買\");

value5=average(value1,100);

if

value1\>4\*value5

and value1\>200

and close\<close\[10\]

then ret=1;

## 場景 375：網格交易介紹 --- 下面的腳本，是公司的高手寫的網格交易自動化交易的腳本範例，供大家參考

> 來源：[[網格交易介紹]{.underline}](https://www.xq.com.tw/xstrader/%e7%b6%b2%e6%a0%bc%e4%ba%a4%e6%98%93%e4%bb%8b%e7%b4%b9/)
> 說明：下面的腳本，是公司的高手寫的網格交易自動化交易的腳本範例，供大家參考

//參數定義

input:P_LS(1,\"多空啟動\",inputkind:=dict(\[\"多方啟動\",1\],\[\"空方啟動\",-1\]));

input:P_UpLimit(80,\"區間上緣\");

input:P_DnLimit(70,\"區間下緣\");

input:P_Grid(10,\"網格數\");

input:P_GridV(1,\"每筆張數\");

//變數定義

var:V_LS(0);//多空方向

var:V_Grid(0);//網格點數

var:intrabarpersist V_GridNo(0);//網格編號

var:intrabarpersist V_GridPosition(0);//網格目標部位

//多空方向，預設做多

if P_LS=-1 then V_LS=-1 else V_LS=1;

//網格計算

//計算每格點數

once V_Grid = intPortion((P_UpLimit-P_DnLimit)/P_Grid);

if V_LS=1 then

value1=MaxList((close-P_DnLimit)/V_Grid,0)

else

value1=MaxList((P_UpLimit-close)/V_Grid,0);

//計算目前所處網格編號，最低網格為0號

V_GridNo = intPortion(value1);

//計算網格應有部位

if V_LS=1 then begin

V_GridPosition = P_GridV \* maxList(P_Grid - V_GridNo,0);

//啟動策略或價格下跌造成部位不足，以網格下價買齊

if filled \< V_GridPosition then begin

setposition(V_GridPosition, P_DnLimit + V_Grid\*V_GridNo);

end else begin

//價格上漲造成部位太多，以網格上價賣出

setposition(V_GridPosition, P_DnLimit + (V_Grid+1)\*V_GridNo);

end;

end else begin

V_GridPosition = - P_GridV \* maxList(P_Grid - V_GridNo,0);

//啟動策略或價格上漲造成部位不足，以網格上價放空

if filled \> V_GridPosition then setposition(V_GridPosition, P_UpLimit -
V_Grid\*V_GridNo);

//價格下跌造成部位太多，以網格下價回補

setposition(V_GridPosition, P_UpLimit - (V_Grid+1)\*V_GridNo);

end;

## 場景 376：4/8日新聞重點立即看\~找營收大爆發的股票 --- 其中月營收是最近一期這個條件，是要確定挑到符合上面營收成長條件的日期，是在最近一個月營收公佈的那一天，這個腳本如下

> 來源：[[4/8日新聞重點立即看\~找營收大爆發的股票]{.underline}](https://www.xq.com.tw/xstrader/4-8%e6%97%a5%e6%96%b0%e8%81%9e%e9%87%8d%e9%bb%9e%e7%ab%8b%e5%8d%b3%e7%9c%8b%e6%89%be%e7%87%9f%e6%94%b6%e5%a4%a7%e7%88%86%e7%99%bc%e7%9a%84%e8%82%a1%e7%a5%a8/)
> 說明：其中月營收是最近一期這個條件，是要確定挑到符合上面營收成長條件的日期，是在最近一個月營收公佈的那一天，這個腳本如下

value1=getFieldDate(\"月營收\", \"M\");

//取得月營收日期

value2=datevalue(date,\"M\");

//取得最近一根K棒的月份數值

value3=datevalue(value1,\"M\");

//取得月營收日期的月份數值

if value2-value3=1

//如果K棒月份數值比公佈的數值差一

then ret=1;

outputfield(1,value1,0,\"最新營收月份\");

## 場景 377：XQ交易語法專章 --- 也可以傳入K棒的價格, 例如Close

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：也可以傳入K棒的價格, 例如Close

SetPosition(1, Close);

## 場景 378：XQ交易語法專章

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：也可以傳入數值運算式

SetPosition(1, Close + 1.0);

## 場景 379：XQ交易語法專章 --- 支援檔位換算功能(AddSpread) AddSpread(Close, 1)表示是Close價格往上加1檔, AddSpread(Close, 2)表示加2檔\...

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：支援檔位換算功能(AddSpread) AddSpread(Close,
> 1)表示是Close價格往上加1檔, AddSpread(Close, 2)表示加2檔
> AddSpread(Close, -1)表示是Close價格往下減1檔
> AddSpread也可以用在警示腳本,
> 以及指標腳本，例如我們如果在空手時要用現價加一檔買進一張，就可以像下面這麼寫

SetPosition(1, AddSpread(Close, 1));

## 場景 380：XQ交易語法專章 --- 除了可以SetPosition之外, 也可以讀到目前的Position，所以如果要加碼一張，可以像下面這樣的寫法

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：除了可以SetPosition之外,
> 也可以讀到目前的Position，所以如果要加碼一張，可以像下面這樣的寫法

SetPosition(Position+1)

## 場景 381：XQ交易語法專章 --- 這樣的語法非常簡潔，不必在那邊buy 啦   sell啦，@market啦，巴啦吧啦的寫的落落長，例如我們如果要在股價突破月線時市價進場買進一張，那就可以直接寫

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：這樣的語法非常簡潔，不必在那邊buy 啦 
>  sell啦，@market啦，巴啦吧啦的寫的落落長，例如我們如果要在股價突破月線時市價進場買進一張，那就可以直接寫

if close cross over average(close,22) then  setposition(1,market);

## 場景 382：XQ交易語法專章 --- 如果腳本內想要判斷目前成交狀態的話, 就可以透過讀取Filled這個變數來判斷.例如當目前部位是零的時候，下面的幾種寫法，代表不同的意義

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：如果腳本內想要判斷目前成交狀態的話,
> 就可以透過讀取Filled這個變數來判斷.例如當目前部位是零的時候，下面的幾種寫法，代表不同的意義

if Position = 1 and Filled = 1 then begin

{ 已經送出一筆買進1張的委託, 而且這一筆委託已經成交 }

end;

## 場景 383：XQ交易語法專章

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)

if Position = 1 and Filled = 0 then begin

{ 已經送出一筆買進1張的委託, 可是還沒有成交}

end;

## 場景 384：XQ交易語法專章

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)

if Position = -1 and Filled = 0 then begin

{ 已經送出一筆賣出1張的委託, 可是還沒有成交 }

end;

## 場景 385：XQ交易語法專章

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)

if Position = -1 and Filled = -1 then begin

{ 已經送出一筆賣出1張的委託, 而且這一筆委託已經成交 }

{ Filled跟Position一樣, 可能會大於0, 也可能會小於0 }

end;

## 場景 386：XQ交易語法專章 --- 範例: 多單1口進場後, +1.5%停利, -1.5%停損

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：範例: 多單1口進場後, +1.5%停利, -1.5%停損

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

## 場景 387：XQ交易語法專章 --- n的範圍從1到FilledRecordCount

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：n的範圍從1到FilledRecordCount

var: idx(0);

for idx = 1 to FilledRecordCount begin

value2 = FilledRecordDate(idx);

value3 = FilledRecordTime(idx);

value4 = FilledRecordBS(idx);

value5 = FilledRecordPrice(idx);

value6 = FilledRecordQty(idx);

value7 = FilledRecordIsRealtime(idx);

end;

## 場景 388：XQ交易語法專章 --- 下面是XQ量化平台的PM寫的範例，供大家參考

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：下面是XQ量化平台的PM寫的範例，供大家參考

//Good-after-Time/Date (GAT)直到設定的日期/時間才送出

input:d1(20200115,\"請輸入生效日格式yyyymmdd\");

input:t1(090000,\"請輸入生效時間格式hhmmss\");

input:v1(1,\"請輸入買進張數\");

if d1 \< currentdate or d1 \> dateAdd(currentdate,\"Y\",1) or d1 \>
99999999 then RaiseRunTimeError(\"請檢查生效日期\");

if t1 \> 240000 then RaiseRunTimeError(\"請檢查生效時間\");

if v1 \<= 0 then RaiseRunTimeError(\"買進張數需大於0\");

if currentdate \* 1000000 + currenttime \>= d1 \* 1000000 + t1

then setposition(v1,market);

## 場景 389：XQ交易語法專章 --- 這種下單的方式是用在像是除權前，或是法說會結束日等指定特定日期要平倉的下單方式，範例如下

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：這種下單的方式是用在像是除權前，或是法說會結束日等指定特定日期要平倉的下單方式，範例如下

//Good-after-Time/Date (GAT)直到設定的日期/時間才送出

input:d1(20200115,\"請輸入生效日格式yyyymmdd\");

input:t1(090000,\"請輸入生效時間格式hhmmss\");

if d1 \< currentdate or d1 \> dateAdd(currentdate,\"Y\",1) or d1 \>
99999999 then RaiseRunTimeError(\"請檢查生效日期\");

if t1 \> 240000 then RaiseRunTimeError(\"請檢查生效時間\");

if currentdate \* 1000000 + currenttime \>= d1 \* 1000000 + t1

then setposition(0,market);

## 場景 390：XQ交易語法專章 --- GTC 是Good till cancel的縮寫，使用者可以設定特定價位和張數，然後讓系統幫你盯盤買到你設定的量

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：GTC 是Good till
> cancel的縮寫，使用者可以設定特定價位和張數，然後讓系統幫你盯盤買到你設定的量

input:theposition(50,\"交易金額，單位萬元\");

input:taprice(130,\"目標價位\");

value1=IntPortion(theposition\*10/open);

if filled \< value1

then setposition(value1,taprice);

## 場景 391：XQ交易語法專章

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：四，MIT買進單

//Market-if-Touched(MIT)若觸到特定價格即轉為市價單。

input:v1(1,\"買進張數\");

input:p1(50,\"觸發價位\");

if close\>=p1

then setposition(v1,market);

## 場景 392：XQ交易語法專章

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：五，MPM買單

//Midpoint Match (MPM)以買賣報價的的中間價格交易

input:v1(1,\"請輸入買進張數\");

setposition(v1, (q_BestAsk1+q_BestBid1)/2);

## 場景 393：XQ交易語法專章

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：六，作多掃單

value1=q_BestAskSize1;

value2=value1+q_BestAskSize2;

value3=value2+q_BestAskSize3;

value4=value3+q_BestAskSize4;

value5=value4+q_BestAskSize5;

input:v1(499,\"掃單張數\");

if v1\<value1

then setposition(q_BestAsk1,v1)

else if v1\<value2

then setposition(q_BestAsk2,v1)

else if v1\<value3

then setposition(q_BestAsk3,v1)

else if v1\<value4

then setposition(q_BestAsk4,v1)

else if v1\<value5

then setposition(q_BestAsk5,v1);

## 場景 394：XQ交易語法專章

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：七，開盤市價買進

input:theposition(50,\"買進金額，單位萬元\");

input:t1(090000,\"請輸入執行時間，格式hhmmss\");

value1=IntPortion(theposition\*10/open);

if time\>=090000

then setposition(value1,market);

## 場景 395：XQ交易語法專章

> 來源：[[XQ交易語法專章]{.underline}](https://www.xq.com.tw/xstrader/xq%e4%ba%a4%e6%98%93%e8%aa%9e%e6%b3%95%e5%b0%88%e7%ab%a0/)
> 說明：八，收盤市價平倉

input:t1(132955,\"請輸入執行時間，格式hhmmss\");

if time\>=t1

then setposition(0,market);

## 場景 396：如何找到財報會有驚喜的公司

> 來源：[[如何找到財報會有驚喜的公司]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e6%89%be%e5%88%b0%e8%b2%a1%e5%a0%b1%e6%9c%83%e6%9c%89%e9%a9%9a%e5%96%9c%e7%9a%84%e5%85%ac%e5%8f%b8/)
> 說明：以下是我寫的腳本

input:band1(10,\"本益比上限\");

if getfielddate(\"每股稅後淨利(元)\", \"Q\")=20200901

then begin

value1=CLOSE/ (getField(\"每股稅後淨利(元)\", \"Q\")

+getField(\"每股稅後淨利(元)\", \"Q\")\[1\]

+getField(\"每股稅後淨利(元)\", \"Q\")\[2\]

//前三季EPS合計

+getField(\"每股稅後淨利(元)\", \"Q\")

//第三季EPS

\*(getField(\"月營收\", \"M\")\[2\]+getField(\"月營收\",
\"M\")\[3\]+getField(\"月營收\", \"M\")\[4\])

/(getField(\"月營收\", \"M\")\[5\]+getField(\"月營收\",
\"M\")\[6\]+getField(\"月營收\", \"M\")\[7\]));

//乘上（1+第四季營收季增率）

if value1\<band1

and value1\>0

then ret=1;

end;

outputfield(1,value1,1,\"預估本益比\");

outputfield(2,getField(\"每股稅後淨利(元)\", \"Q\"),1,\"第三季EPS\");

outputfield(3,getField(\"每股稅後淨利(元)\",
\"Q\")\[1\],1,\"第二季EPS\");

outputfield(4,getField(\"每股稅後淨利(元)\",
\"Q\")\[2\],1,\"第一季EPS\");

outputfield(5,getfielddate(\"每股稅後淨利(元)\",
\"Q\"),0,\"最新財報日期\");

## 場景 397：如何用選股中心找出預估現金殖利率高的股票

> 來源：[[如何用選股中心找出預估現金殖利率高的股票]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e7%94%a8%e9%81%b8%e8%82%a1%e4%b8%ad%e5%bf%83%e6%89%be%e5%87%ba%e9%a0%90%e4%bc%b0%e7%8f%be%e9%87%91%e6%ae%96%e5%88%a9%e7%8e%87%e9%ab%98%e7%9a%84%e8%82%a1%e7%a5%a8/)
> 說明：我寫的腳本如下

var: dr(0);//dr代表預估現金股利殖利率

input:lowbond(5);

if getFielddate(\"每股稅後淨利(元)\",\"Q\")=20201201

//確定是用去年全年的財報當計算基礎

then begin

if GetField(\"股利年度\",\"Y\")=2020 then

dr=GetField(\"現金股利殖利率\",\"D\")

else

dr= (GetField(\"每股稅後淨利(元)\",\"Y\")

\*GetField(\"現金派息比率\",\"Y\")/100)/close\*100;

end;

if dr\>lowbond then ret=1;

outputfield(1,close/GetField(\"每股稅後淨利(元)\",\"Y\"),1,\"本益比\");

outputfield(2,GetField(\"現金派息比率\",\"Y\"),1,\"現金派息比率\");

outputfield(3,GetField(\"每股稅後淨利(元)\",\"Y\"),1,\"去年EPS\");

outputfield(4,(GetField(\"每股稅後淨利(元)\",\"Y\")

\*GetField(\"現金派息比率\",\"Y\")/100) ,1,\"現金股利\");

outputfield(5,dr,1,\"預估現金殖利率\");

outputfield(6,getFieldDate(\"股利年度\",\"Y\"),0,\"股利年度\");

## 場景 398：總報酬本益比的算法及應用 --- 接下來我來寫一個腳本，試著來計算每檔股本的總報酬率本益比

> 來源：[[總報酬本益比的算法及應用]{.underline}](https://www.xq.com.tw/xstrader/%e7%b8%bd%e5%a0%b1%e9%85%ac%e6%9c%ac%e7%9b%8a%e6%af%94%e7%9a%84%e7%ae%97%e6%b3%95%e5%8f%8a%e6%87%89%e7%94%a8/)
> 說明：接下來我來寫一個腳本，試著來計算每檔股本的總報酬率本益比

value1=getField(\"殖利率\", \"D\");

value2=getField(\"累計營收年增率\", \"M\");

value3=getField(\"本益比\", \"D\");

value4=(value1+value2)/value3;

if value4\>1.2

then ret=1;

outputfield(1,value4,1,\"總報酬率本益比\");

## 場景 399：外資及投信同步買超的個股 --- 於是我寫了以下的腳本，

> 來源：[[外資及投信同步買超的個股]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%96%e8%b3%87%e5%8f%8a%e6%8a%95%e4%bf%a1%e5%90%8c%e6%ad%a5%e8%b2%b7%e8%b6%85%e7%9a%84%e5%80%8b%e8%82%a1/)
> 說明：於是我寫了以下的腳本，

value1=getField(\"外資買張\", \"D\");

value2=getField(\"投信買張\", \"D\");

if volume\<\>0

then value3=(value1+value2)/volume\*100;

input:ratio(30,\"投信外資合計買張佔成交量下限\");

if value3\>=ratio then ret=1;

## 場景 400：如何透過選股中心取得最新公佈營收年增率暴增的公司 --- 首先請參考下面這個選股腳本

> 來源：[[如何透過選股中心取得最新公佈營收年增率暴增的公司]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e9%80%8f%e9%81%8e%e9%81%b8%e8%82%a1%e4%b8%ad%e5%bf%83%e5%8f%96%e5%be%97%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e7%87%9f%e6%94%b6%e5%b9%b4%e5%a2%9e%e7%8e%87%e6%9a%b4%e5%a2%9e%e7%9a%84/)
> 說明：首先請參考下面這個選股腳本

input:ratio(30,\"營收yoy下限\");

value1=getFieldDate(\"月營收年增率\", \"M\");

if getField(\"月營收年增率\", \"M\")\>ratio

and value1=20201201

then ret=1;

outputfield(1,getField(\"月營收年增率\", \"M\"),1,\"月營收年增率\");

outputfield(2,value1,0,\"營收月份\");

## 場景 401：如何透過選股中心取得最新公佈營收年增率暴增的公司 --- 我們可以在上面的腳本中加上一行條件式

> 來源：[[如何透過選股中心取得最新公佈營收年增率暴增的公司]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e9%80%8f%e9%81%8e%e9%81%b8%e8%82%a1%e4%b8%ad%e5%bf%83%e5%8f%96%e5%be%97%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e7%87%9f%e6%94%b6%e5%b9%b4%e5%a2%9e%e7%8e%87%e6%9a%b4%e5%a2%9e%e7%9a%84/)
> 說明：我們可以在上面的腳本中加上一行條件式

and value1\<\>value1\[1\]

## 場景 402：如何透過選股中心取得最新公佈營收年增率暴增的公司 --- 這一行表示最一根bar對應的營收數據日期跟前一根不一樣，那就代表新的月營收是在最近一根bar公佈的，樣腳本就可以改成像下面的樣子

> 來源：[[如何透過選股中心取得最新公佈營收年增率暴增的公司]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e9%80%8f%e9%81%8e%e9%81%b8%e8%82%a1%e4%b8%ad%e5%bf%83%e5%8f%96%e5%be%97%e6%9c%80%e6%96%b0%e5%85%ac%e4%bd%88%e7%87%9f%e6%94%b6%e5%b9%b4%e5%a2%9e%e7%8e%87%e6%9a%b4%e5%a2%9e%e7%9a%84/)
> 說明：這一行表示最一根bar對應的營收數據日期跟前一根不一樣，那就代表新的月營收是在最近一根bar公佈的，樣腳本就可以改成像下面的樣子

input:ratio(30,\"營收yoy下限\");

value1=getFieldDate(\"月營收年增率\", \"M\");

if getField(\"月營收年增率\", \"M\")\>ratio

and value1=20201201

and value1\<\>value1\[1\]

then ret=1;

outputfield(1,getField(\"月營收年增率\", \"M\"),1,\"月營收年增率\");

outputfield(2,value1,0,\"營收月份\");

## 場景 403：股價沒有創新高但法人持續買超 --- 首先，還是先跟大家報告我寫的腳本

> 來源：[[股價沒有創新高但法人持續買超]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e6%b2%92%e6%9c%89%e5%89%b5%e6%96%b0%e9%ab%98%e4%bd%86%e6%b3%95%e4%ba%ba%e6%8c%81%e7%ba%8c%e8%b2%b7%e8%b6%85/)
> 說明：首先，還是先跟大家報告我寫的腳本

value1=getField(\"法人買賣超張數\", \"D\");

input:period(12);

if close\<highest(close,period)

//股價低於計算區間的最高點

and countif(value1\>0,period)\>period\*0.75

//3/4的日子裡法人買超

and value1\>1000

//近一個交易日法人買超達1000張以上

and value1\[1\]\>800

//前一個交易日法人買超達800張以上

then ret=1;

## 場景 404：創百日新高的高勝率策略 --- 我之前在部落格裡有寫過一個創百日新高但距低點不遠的腳本，勝率不算太迷人，後來公司的工程師把它改良後，寫了一個同名字的腳本，放在系統內建的價量選股目錄中，這個腳本\...

> 來源：[[創百日新高的高勝率策略]{.underline}](https://www.xq.com.tw/xstrader/%e5%89%b5%e7%99%be%e6%97%a5%e6%96%b0%e9%ab%98%e7%9a%84%e9%ab%98%e5%8b%9d%e7%8e%87%e7%ad%96%e7%95%a5/)
> 說明：我之前在部落格裡有寫過一個創百日新高但距低點不遠的腳本，勝率不算太迷人，後來公司的工程師把它改良後，寫了一個同名字的腳本，放在系統內建的價量選股目錄中，這個腳本如下：

input:day(100); setinputname(1,\"計算區間\");

input:percents(14); setinputname(2,\"距離區間最低點漲幅\");

SetTotalBar(3);

value1 = lowest(close, day-1);

if high = highest(close, day-1) and value1 \* (1 + percents/100) \>=
high

then ret=1;

## 場景 405：創百日新高的高勝率策略 --- 我們同事覺得這個方向可以繼續研究，後來就寫了以下的腳本

> 來源：[[創百日新高的高勝率策略]{.underline}](https://www.xq.com.tw/xstrader/%e5%89%b5%e7%99%be%e6%97%a5%e6%96%b0%e9%ab%98%e7%9a%84%e9%ab%98%e5%8b%9d%e7%8e%87%e7%ad%96%e7%95%a5/)
> 說明：我們同事覺得這個方向可以繼續研究，後來就寫了以下的腳本

Input:SPeriod(13),LPeriod(377);

// 計算

// 條件

// 連續5日成交量\>500

Condition1=trueall(V\>500,5);

// 創區間新高

Condition20=H=Highest(H,LPeriod);

Condition2=Condition20 and Not Condition20\[1\];

// 區間壓縮

Condition3=(Highest(C,SPeriod)-Lowest(C,SPeriod))/Lowest(C,SPeriod)\<0.05;

// 創區間大量

Condition4=V=Highest(V,SPeriod);

// 大盤趨勢向上

Condition5=cct_tse_trend(8)=1 ;

Condition100=Condition1 and Condition2 and Condition3 and Condition4 and
Condition5;

// 篩選

If Condition100 Then Ret=1;

## 場景 406：創長期新高的股票能不能追?

> 來源：[[創長期新高的股票能不能追?]{.underline}](https://www.xq.com.tw/xstrader/%e5%89%b5%e9%95%b7%e6%9c%9f%e6%96%b0%e9%ab%98%e7%9a%84%e8%82%a1%e7%a5%a8%e8%83%bd%e4%b8%8d%e8%83%bd%e8%bf%bd/)
> 說明：首先還是先PO腳本

input:period(500,\"創n日新高\");

value1=GetField(\"主力買賣超張數\")\[1\];

if close crosses over highest(close\[1\],period)

//股價創500日新高

and trueall(close\>close\[1\],3)

//股價連續三日上漲

and trueall(value1\>0,3)

//主力連三日買超

then ret=1;

## 場景 407：要如何避免自己的持股變成處份股票？ --- 這個選股腳本很長，我先把腳本po在下面

> 來源：[[要如何避免自己的持股變成處份股票？]{.underline}](https://www.xq.com.tw/xstrader/%e8%a6%81%e5%a6%82%e4%bd%95%e9%81%bf%e5%85%8d%e8%87%aa%e5%b7%b1%e7%9a%84%e6%8c%81%e8%82%a1%e8%ae%8a%e6%88%90%e8%99%95%e4%bb%bd%e8%82%a1%e7%a5%a8%ef%bc%9f/)
> 說明：這個選股腳本很長，我先把腳本po在下面

SETBARFREQ(\"AD\");

setbarback(100);

Input:Len(90);

Var:TSEClose(0),TSEVolume(0),StockChangeRatio(0),TSEChangeRatio(0);

Var:AlertCount41(0),AlertCount42(0),AlertCount43(0),AlertCount44(0),AlertCount47(0),AlertCount48(0),AlertCount49(0),AlertCount410(0),AlertCount411(0),AlertCount412(0);

Var:AlertCount61(0),AlertCount21(0);

// 計算

// TSE成交價

TSEClose=GetSymbolField(\"TSE.TW\",\"收盤價\",\"D\");

// TSE成交量

TSEVolume=GetSymbolField(\"TSE.TW\",\"成交量\",\"D\");

// TSE漲跌幅

TSEChangeRatio=GetSymbolField(\"TSE.TW\",\"漲跌幅\",\"D\");

// 個股漲跌幅

StockChangeRatio=GetField(\"漲跌幅\",\"D\");

// 【上市】

{===============================================================================================================================================================

Condition50

第四條第一項第一款

4.1. 最近一段期間累積之收盤價漲跌百分比異常者。

本要點第四條第一項第一款「有價證券最近一段期間累積之收盤價漲跌百分比異常者」，係指有價證券當日達下列各款情事【之一】者：

Condition1

一、最近六個營業日（含當日）累積之收盤價漲跌百分比超過百分之三十二，且其漲跌百分比與全體有價證券及同類有價證券依本項規定計算之平均值的差幅均在百分之二十以上者。

Condition2

二、最近六個營業日（含當日）累積之收盤價漲跌百分比超過百分之二十五，且其漲跌百分比與全體有價證券及同類有價證券依本項規定計算之平均值的差幅均在百分之二十以上，

及最近六個營業日（含當日）起迄兩個營業日之收盤價價差達新臺幣五十元以上者。

前項除外情形如下：

一、初次上市普通股採無升降幅度限制期間之收盤價漲跌百分比，不納入前項標準之計算。

二、有價證券或指數在計算前項標準期間內，如有因非交易之原因（如除權、除息等）造成價格變動者，則於計算收盤價或收盤指數漲跌百分比時，排除此項變動因素。

Condition3

三、有價證券（不含認購（售）權證）當日收盤價未滿新臺幣五元者不適用前項標準。

四、同類有價證券未達五種者不適用前項有關類股之規定。

Condition4

五、有價證券本益比為負值或達六十倍以上者不適用前項有關類股之規定。

六、公開資訊觀測站公告有價證券當日之前一個營業日溢（折）價百分比達下列情事之一者，不適用前項標準：

（一）未超過百分之十。

（二）與前項所達標準漲（跌）之方向相反。

}

// 基本條件

Condition1=100\*(C-C\[5\])/C\[5\]\>32 and
100\*(C-C\[5\])/C\[5\]-100\*(TSEClose-TSEClose\[5\])/TSEClose\[5\]\>=20;

Condition2=100\*(C-C\[5\])/C\[5\]\>25 and
100\*(C-C\[5\])/C\[5\]-100\*(TSEClose-TSEClose\[5\])/TSEClose\[5\]\>=20
and C-C\[5\]\>=50;

// 除外條件

Condition3=C\<5;

Condition4=GetField(\"本益比\",\"D\")\<0 or
GetField(\"本益比\",\"D\")\>=60 ;

// 條件整合

Condition50=Condition1 or Condition2 and (Not Condition3 or Not
Condition4);

// 篩選

If Condition50 Then Begin

AlertCount41=1;

End;

{===============================================================================================================================================================

Condition100

4.2. 第四條第一項第二款

本要點第四條第一項第二款「有價證券最近一段期間起迄兩個營業日之收盤價漲跌百分比異常者」，係指有價證券當日達下列各款情事【之一】者：

Condition51

一、有價證券最近三十個營業日（含當日）起迄兩個營業日之收盤價漲跌百分比超過百分之一百，且符合下列二項條件【之一】：

（一）其漲幅百分比與全體有價證券及同類有價證券依本款規定計算之平均值的差幅均在百分之八十五以上，及當日收盤價須高於當日開盤參考價者。

（二）其跌幅百分比與全體有價證券及同類有價證券依本款規定計算之平均值的差幅均在百分之八十五以上，及當日收盤價須低於當日開盤參考價者。

Condition52

二、有價證券最近六十個營業日（含當日）起迄兩個營業日之收盤價漲跌百分比超過百分之一百三十，且符合下列二項條件【之一】：

（一）其漲幅百分比與全體有價證券及同類有價證券依本款規定計算之平均值的差幅均在百分之一百一十以上，及當日收盤價須高於當日開盤參考價者。

（二）其跌幅百分比與全體有價證券及同類有價證券依本款規定計算之平均值的差幅均在百分之一百一十以上，及當日收盤價須低於當日開盤參考價者。

Condition53

三、有價證券最近九十個營業日（含當日）起迄兩個營業日之收盤價漲跌百分比超過百分之一百六十，且符合下列二項條件【之一】：

（一）其漲幅百分比與全體有價證券及同類有價證券依本款規定計算之平均值的差幅均在百分之一百三十五以上，及當日收盤價須高於當日開盤參考價者。

（二）其跌幅百分比與全體有價證券及同類有價證券依本款規定計算之平均值的差幅均在百分之一百三十五以上，及當日收盤價須低於當日開盤參考價者。

前項除外情形如下：

一、初次上市普通股採無升降幅度限制期間之收盤價漲跌百分比，不納入前項標準之計算。

二、非分離型附認股權公司債、非分離型附認股權特別股、認購（售）權證、認股權憑證不適用前項標準。

Condition54

三、有價證券最近三十個營業日（含當日）內，已依本要點第四條第一項第一款公布注意交易資訊，

且其最近六個營業日（含當日）累積之收盤價漲跌百分比達下列情事之一者，不適用前項標準：

Condition55

（一）未超過百分之二十五。

Condition56

（二）超過百分之二十五，且其漲跌百分比與全體有價證券及同類有價證券依最近六個營業日（含當日）累積之收盤價漲跌百分比計算之平均值的差幅均未達百分之二十以上。

（三）與前項各款所達標準漲跌之方向相反。

四、有價證券最近六十個營業日（含當日）內，最近一次經依本要點第六條第二項或第三項規定發布處置，其處置原因僅有前項標準情事，

且其最近六個營業日（含當日）累積之收盤價漲跌百分比達下列情事之一者，不適用前項標準：

Condition58

（一）未超過百分之十。

Condition59

（二）超過百分之十，且其漲跌百分比與全體有價證券及同類有價證券依最近六個營業日（含當日）累積之收盤價漲跌百分比計算之平均值的差幅均未達百分之五以上。

（三）與前項各款所達標準漲跌之方向相反。

五、有價證券在計算前項標準期間內，如有因非交易之原因（如除權、除息等）造成價格變動者，則於計算收盤價漲跌百分比時，排除此項變動因素。

六、同類有價證券未達五種者不適用前項有關類股之規定。

Condition60

七、有價證券本益比為負值或達六十倍以上者不適用前項有關類股之規定。

八、公開資訊觀測站公告有價證券當日之前一個營業日溢（折）價百分比達下列情事之一者，不適用前項標準：

（一）未超過百分之十。

（二）與前項所達標準漲（跌）之方向相反。

}

// 基本條件

Condition51=100\*(C-C\[29\])/C\[29\]\>100 and
100\*(C-C\[29\])/C\[29\]-100\*(TSEClose-TSEClose\[29\])/TSEClose\[29\]\>=85
and C\<\>O;

Condition52=100\*(C-C\[59\])/C\[59\]\>130 and
100\*(C-C\[59\])/C\[59\]-100\*(TSEClose-TSEClose\[59\])/TSEClose\[59\]\>=110
and C\<\>O;

Condition53=100\*(C-C\[89\])/C\[89\]\>160 and
100\*(C-C\[89\])/C\[89\]-100\*(TSEClose-TSEClose\[89\])/TSEClose\[89\]\>=135
and C\<\>O;

// 除外條件

Condition54=trueany(Condition50,30);

Condition55=Condition54 and 100\*(C-C\[5\])/C\[5\]\<=25;

Condition56=Condition54 and 100\*(C-C\[5\])/C\[5\]\>25 and
100\*(C-C\[5\])/C\[5\]-100\*(TSEClose-TSEClose\[5\])/TSEClose\[5\]\<20;

Condition58=100\*(C-C\[5\])/C\[5\]\<=10;

Condition59=Condition54 and 100\*(C-C\[5\])/C\[5\]\>10 and
100\*(C-C\[5\])/C\[5\]-100\*(TSEClose-TSEClose\[5\])/TSEClose\[5\]\<5;

Condition60=GetField(\"本益比\",\"D\")\<0 or
GetField(\"本益比\",\"D\")\>=60 ;

// 條件整合

Condition100=Condition51 or Condition52 or Condition53 and (Not
Condition55 or Not Condition56 or Not Condition58 or Not Condition59 or
Not Condition60);

// 篩選

If Condition100 Then Begin

AlertCount42=1;

End;

{===============================================================================================================================================================

Condition150

4.3. 第四條第一項第三款

本要點第四條第一項第三款「有價證券最近一段期間累積之收盤價漲跌百分比異常，且其當日之成交量較最近一段期間之日平均成交量異常放大者」，係指有價證券當日【同時】達下列各款情事者：

Condition101

一、最近六個營業日（含當日）累積之收盤價漲跌百分比超過百分之二十五，且其漲跌百分比與全體有價證券及同類有價證券依本款規定計算之平均值的差幅，均在百分之二十以上。

Condition102

二、當日之成交量較最近六十個營業日（含當日）之日平均成交量放大為五倍以上，且其放大倍數與全體有價證券依本款規定計算之平均值相差四倍以上。

前項除外情形如下：

一、初次上市普通股採無升降幅度限制期間之收盤價漲跌百分比、日成交量，不納入前項標準之計算。

二、轉換公司債、非分離型附認股權公司債、非分離型附認股權特別股、債券換股權利證書、認購（售）權證、認股權憑證、指數股票型基金受益憑證、指數投資證券不適用前項標準。

三、有價證券在計算前項標準期間內，如有因非交易之原因（如除權、除息等）造成價格變動者，則於計算收盤價漲跌百分比時，排除此項變動因素。

Condition103

四、有價證券當日週轉率未達千分之一以上，或成交量未達五百交易單位以上者，不適用前項標準。

五、同類有價證券未達五種者，不適用前項有關類股之規定。

Condition104

六、有價證券本益比為負值或達六十倍以上者，不適用前項有關類股之規定。

七、公開資訊觀測站公告有價證券當日之前一個營業日溢（折）價百分比達下列情事之一者，不適用前項標準：

（一）未超過百分之十。

（二）與前項所達標準漲（跌）之方向相反。

}

// 基本條件

Condition101=100\*(C-C\[5\])/C\[5\]\>25 and
100\*(C-C\[5\])/C\[5\]-100\*(TSEClose-TSEClose\[5\])/TSEClose\[5\]\>=20;

Condition102=V/Average(V,60)\>=5 and
V/Average(V,60)\>=4\*TSEVolume/Average(TSEVolume,60);

// 除外條件

Condition103=GetField(\"週轉率\",\"D\")\<0.1 or V\<500;

Condition104=GetField(\"本益比\",\"D\")\<0 or
GetField(\"本益比\",\"D\")\>=60 ;

// 條件整合

Condition150=Condition101 and Condition102 and (Not Condition103 or Not
Condition104);

// 篩選

If Condition150 Then Begin

AlertCount43=1;

End;

{===============================================================================================================================================================

Condition200

4.4. 第四條第一項第四款

本要點第四條第一項第四款「有價證券最近一段期間累積之收盤價漲跌百分比異常，且其當日之週轉率過高者」，係指有價證券當日【同時】達下列各款情事者：

Condition151

一、最近六個營業日（含當日）累積之收盤價漲跌百分比超過百分之二十五，且其漲跌百分比與全體有價證券及同類有價證券依本款規定計算之平均值的差幅，均在百分之二十以上。

Condition152

二、當日週轉率百分之十以上，且其週轉率與全體有價證券依本款規定計算之平均值的差幅在百分之五以上。

前項除外情形如下：

一、初次上市普通股採無升降幅度限制期間之收盤價漲跌百分比，不納入前項標準之計算。

二、轉換公司債、非分離型附認股權公司債、非分離型附認股權特別股、債券換股權利證書、認購（售）權證、認股權憑證、指數股票型基金受益憑證、指數投資證券不適用前項標準。

三、有價證券在計算前項標準期間內，如有因非交易之原因（如除權、除息等）造成價格變動者，則於計算收盤價漲跌百分比時，排除此項變動因素。

四、同類有價證券未達五種者，不適用前項有關類股之規定。

Condition153

五、有價證券本益比為負值或達六十倍以上者，不適用前項有關類股之規定。

六、公開資訊觀測站公告有價證券當日之前一個營業日溢（折）價百分比達下列情事之一者，不適用前項標準：

（一）未超過百分之十。

（二）與前項所達標準漲（跌）之方向相反。

}

// 基本條件

Condition151=100\*(C-C\[5\])/C\[5\]\>25 and
100\*(C-C\[5\])/C\[5\]-100\*(TSEClose-TSEClose\[5\])/TSEClose\[5\]\>=20;

Condition152=GetField(\"週轉率\",\"D\")\>=10 and
GetField(\"週轉率\",\"D\")-GetSymbolField(\"TSE.TW\",\"週轉率\",\"D\")\>=5;

// 除外條件

Condition153=GetField(\"本益比\",\"D\")\<0 or
GetField(\"本益比\",\"D\")\>=60 ;

// 條件整合

Condition200=Condition151 and Condition152 and (Not Condition153);

// 篩選

If Condition200 Then Begin

AlertCount44=1;

End;

{===============================================================================================================================================================

Condition250

4.7. 第四條第一項第七款

本要點第四條第一項第七款「有價證券最近一段期間累積之收盤價漲跌百分比異常，且券資比明顯放大者」，係指有價證券當日【同時】達下列各款情事者：

Condition201

一、最近六個營業日（含當日）累積之收盤價漲跌百分比超過百分之二十五，且其漲跌百分比與全體有價證券及同類有價證券依本款規定計算之平均值的差幅，均在百分之二十以上。

Condition202

二、當日之前一個營業日之券資比百分之二十以上，且【同時】符合下列二項條件：

（一）融資使用率百分之二十五以上。

（二）融券使用率百分之十五以上。

Condition203

三、當日之前一個營業日之券資比較最近六個營業日（從當日之前一個營業日起）之最低券資比放大四倍以上。

前項除外情形如下：

一、初次上市普通股採無升降幅度限制期間之收盤價漲跌百分比，不納入前項標準之計算。

二、有價證券在計算前項標準期間內，如有因非交易之原因（如除權、除息等）造成價格變動者，則於計算收盤價或收盤指數漲跌百分比時，排除此項變動因素。

三、同類有價證券未達五種者，不適用前項有關類股之規定。

Condition204

四、有價證券本益比為負值或達六十倍以上者，不適用前項有關類股之規定。

Condition205

五、當日之前一個營業日券資比低於當日之前二個營業日之券資比。

六、公開資訊觀測站公告有價證券當日之前一個營業日溢（折）價百分比達下列情事之一者，不適用前項標準：

（一）未超過百分之十。

（二）與前項所達標準漲（跌）之方向相反。

}

// 基本條件

Condition201=100\*(C-C\[5\])/C\[5\]\>25 and
100\*(C-C\[5\])/C\[5\]-100\*(TSEClose-TSEClose\[5\])/TSEClose\[5\]\>=20;

Condition202=GetField(\"券資比\",\"D\")\[1\]\>=20 and
GetField(\"融資使用率\",\"D\")\>=25 and
GetField(\"融券使用率\",\"D\")\>=15;

Condition203=GetField(\"券資比\",\"D\")\[1\]\>=4\*Lowest(GetField(\"券資比\",\"D\")\[1\],6);

// 除外條件

Condition204=GetField(\"本益比\",\"D\")\<0 or
GetField(\"本益比\",\"D\")\>=60 ;

Condition205=GetField(\"券資比\",\"D\")\[1\]\<GetField(\"券資比\",\"D\")\[2\];

// 條件整合

Condition250=Condition201 and Condition202 and Condition203 and (Not
Condition204 or Not Condition205);

// 篩選

If Condition250 Then Begin

AlertCount47=1;

End;

{===============================================================================================================================================================

Condition300

4.9. 第四條第一項第九款

本要點第四條第一項第九款「有價證券當日及最近數日之日平均成交量較最近一段期間之日平均成交量明顯放大者」，係指有價證券當日【同時】達下列各款情事者：

Condition251

一、最近六個營業日（含當日）之日平均成交量較最近六十個營業日（含當日）之日平均成交量放大為五倍以上，且其放大倍數與全體有價證券依本款規定計算之平均值相差四倍以上。

Condition252

二、當日之成交量較最近六十個營業日（含當日）之日平均成交量放大為五倍以上，且其放大倍數與全體有價證券依本款規定計算之平均值相差四倍以上。

前項除外情形如下：

一、初次上市普通股採無升降幅度限制期間之日成交量，不納入前項標準之計算。

二、轉換公司債、非分離型附認股權公司債、非分離型附認股權特別股、債券換股權利證書、認購（售）權證、認股權憑證、指數股票型基金受益憑證、指數投資證券不適用前項標準。

Condition253

三、在最近六個營業日（含當日）內，已依本要點第四條第一項第三款公布注意交易資訊之有價證券，不適用前項標準。

Condition254

四、有價證券當日週轉率未達千分之一以上，或成交量未達五百交易單位以上者，不適用前項標準。

}

// 基本條件

Condition251=Average(V,6)/Average(V,60)\>=5 and
Average(V,6)/Average(V,60)\>=4\*Average(TSEVolume,6)/Average(TSEVolume,60);

Condition252=V/Average(V,60)\>=5 and
V/Average(V,60)\>=4\*TSEVolume/Average(TSEVolume,60);

// 除外條件

Condition253=trueany(Condition150,6);

Condition254=GetField(\"週轉率\",\"D\")\<0.1 or V\<500;

// 條件整合

Condition300=Condition251 and Condition252 and (Not Condition253 or Not
Condition254);

// 篩選

If Condition300 Then Begin

AlertCount49=1;

End;

{===============================================================================================================================================================

Condition350

4.10. 第四條第一項第十款

本要點第四條第一項第十款「有價證券最近一段期間之累積週轉率明顯過高者」，係指有價證券當日【同時】達下列各款情事者：

Condition301

一、最近六個營業日（含當日）之累積週轉率超過百分之五十，且其累積週轉率與全體有價證券依本款規定計算之平均值的差幅在百分之四十以上。

Condition302

二、當日週轉率百分之十以上，且其週轉率與全體有價證券依本款規定計算之平均值的差幅在百分之五以上。

前項除外情形如下：

一、初次上市普通股採無升降幅度限制期間之日週轉率，不納入前項標準之計算。

二、轉換公司債、非分離型附認股權公司債、非分離型附認股權特別股、債券換股權利證書、認購（售）權證、認股權憑證、指數股票型基金受益憑證、指數投資證券不適用前項標準。

Condition303

三、在最近六個營業日（含當日）內，已依本要點第四條第一項第四款公布注意交易資訊之有價證券，不適用前項標準。

Condition304

四、有價證券當日成交金額未滿新臺幣五億元以上者，不適用前項標準。

}

// 基本條件

Condition301=Summation(GetField(\"週轉率\",\"D\"),6)\>50 and
Summation(GetField(\"週轉率\",\"D\"),6)-Summation(GetSymbolField(\"TSE.TW\",\"週轉率\",\"D\"),6)\>=40;

Condition302=GetField(\"週轉率\",\"D\")\>=10 and
GetField(\"週轉率\",\"D\")-GetSymbolField(\"TSE.TW\",\"週轉率\",\"D\")\>=5;

// 除外條件

Condition303=trueany(Condition200,6);

Condition304=GetField(\"成交金額(億)\",\"D\")\<5;

// 條件整合

Condition350=Condition301 and Condition302 and (Not Condition303 or Not
Condition304);

// 篩選

If Condition350 Then Begin

AlertCount410=1;

End;

{===============================================================================================================================================================

Condition400

4.11. 第四條第一項第十一款

本要點第四條第一項第十一款「有價證券最近一段期間起迄兩個營業日之收盤價價差異常者」，係指有價證券當日達下列各款情事【之一】者：

Condition351

一、有價證券最近六個營業日（含當日）起迄兩個營業日之收盤價價差達新臺幣一百元以上，且有價證券當日收盤價須為最近六個營業日（含當日）收盤價最高者。

但最近五個營業日（不含當日）無收盤價時，則當日收盤價須高於開盤參考價。

Condition352

二、有價證券最近六個營業日（含當日）起迄兩個營業日之收盤價價差達新臺幣一百元以上，且有價證券證當日收盤價須為最近六個營業日（含當日）收盤價最低者。

但最近五個營業日（不含當日）無收盤價時，則當日收盤價須低於開盤參考價。

前項除外情形如下：

一、初次上市普通股採無升降幅度限制期間之收盤價，不納入前項標準之計算。

二、有價證券或指數在計算前項標準期間內，如有因非交易之原因（如除權、除息等）造成價格變動者，則於計算收盤價或收盤指數時，排除此項變動因素。

Condition353

三、在最近六個營業日（含當日）內，當日之前五個營業日已依本要點第四條第一項第十一款公布注意交易資訊之有價證券，不適用前項標準。

}

// 基本條件

Condition351=absvalue(C-C\[5\])\>=100 and C=Highest(C,6);

Condition352=absvalue(C-C\[5\])\>=100 and C=Lowest(C,6);

// 除外條件

// 條件整合

Condition400=truecount(Condition351 or Condition352,6)=1;

// 篩選

If Condition400 Then Begin

AlertCount411=1;

End;

{===============================================================================================================================================================

Condition450

4.12. 第四條第一項第十二款

本要點第四條第一項第十二款「有價證券最近一段期間之借券賣出成交量占總成交量比率明顯過高者」，係指有價證券當日之前一個營業日【同時】達下列各款情事者：

Condition401

一、最近六個營業日（從當日之前一個營業日起）之借券賣出成交量占最近六個營業日（從當日之前一個營業日起）總成交量比率在百分之十二以上。

Condition402

二、當日之前一個營業日借券賣出成交量較最近六十個營業日（從當日之前一個營業日起）之日平均借券賣出成交量放大為五倍以上。

前項除外情形如下：

一、初次上市普通股採無升降幅度限制期間之日成交量，不納入前項標準之計算。

二、指數股票型基金受益憑證不適用前項標準。

三、有價證券當日之【前一個營業日】達下列情事【之一】者，不適用前項標準：

Condition403

（一）週轉率未超過千分之三。

Condition404

（二）成交量未超過五百交易單位。

Condition405

（三）借券賣出成交量未超過一百交易單位。

}

// 基本條件

Condition401=Summation(GetField(\"借券賣出張數\",\"D\")\[1\],6)/Summation(V\[1\],6)\>0.12;

Condition402=GetField(\"借券賣出張數\",\"D\")\[1\]\>=5\*Average(GetField(\"借券賣出張數\",\"D\")\[1\],60);

// 除外條件

Condition403=GetField(\"週轉率\",\"D\")\[1\]\<=0.3;

Condition404=V\[1\]\<=500;

Condition405=GetField(\"借券賣出張數\",\"D\")\[1\]\<=100;

// 條件整合

Condition450=Condition401 and Condition402 and (Not Condition403 or Not
Condition404 or Not Condition405);

// 篩選

If Condition450 Then Begin

AlertCount412=1;

End;

{===============================================================================================================================================================

Condition500

6.1 第六條

有價證券之交易有下列情形【之一】時，本公司即發布為處置之有價證券：

Condition451

一、連續三個營業日經本公司依第四條第一項第一款發布交易資訊者。

Condition452

二、連續五個營業日或

Condition453

最近十個營業日內有六個營業日或

Condition454

最近三十個營業日內有十二個營業日經本公司依第四條第一項第一款至第八款發布交易資訊者。

}

// 基本條件

Condition451=Trueall(Condition50,3);

Condition452=Trueall(Condition50 or Condition100 or Condition150 or
Condition200 or Condition250,3);

Condition453=Truecount(Condition50 or Condition100 or Condition150 or
Condition200 or Condition250,10)\>=6;

Condition454=Truecount(Condition50 or Condition100 or Condition150 or
Condition200 or Condition250,30)\>=12;

// 條件整合

Condition500=Condition451 or Condition452 or Condition453 or
Condition454;

// 篩選

If Condition500 Then Begin

AlertCount61=1;

End;

{===============================================================================================================================================================

Condition550

2.1 第 2 條

本公司於每日交易時間內（下稱盤中），分析上市有價證券（不含外國債券、政府債券、普通公司債）之交易，發現其有下列情形【之一】時，即依第三條規定辦理。

Condition501

一、當日盤中成交價振幅超過百分之九，且與本公司發行量加權股價指數振幅之差幅在百分之五以上，且其成交量達三千交易單位以上者。

Condition502

二、當日盤中成交價漲跌百分比超過百分之六，且與本公司發行量加權股價指數漲跌百分比之差幅在百分之四以上，且其成交量達三千交易單位以上者。

Condition503

三、當日盤中週轉率超過百分之十，且其成交量達三千交易單位以上者。

但轉換公司債、非分離型附認股權公司債、非分離型附認股權特別股、債券換股權利證書、認購（售）權證、認股權憑證、指數股票型基金受益憑證及指數投資證券不適用之。

四、依本要點規定發布交易資訊或採取處置措施者。

五、經市場傳聞或媒體報導或經本公司電腦系統分析有異常情事並經簽報核准者。

六、其他經主管機關指定者。

有價證券升降幅度計算公式含有以標的證券或標的指數等計算因素者，以其當日盤中振幅、漲跌百分比與標的證券或標的指數之振幅、漲跌百分比

（投資組合者，取其組合標的證券或標的指數振幅、漲跌百分比之平均值）計算差幅。

第一項第一款、第二款、第三款關於「且其成交量達三千交易單位以上者」之規定，於初次上市普通股採無升降幅度限制期間之交易不適用之。

有價證券交易單位低於一千單位（股、受益權單位、存託憑證單位等，下同）者，其成交（委託）量交易單位數據標準依下列公式調整：

調整後成交（委託）量交易單位數據標準＝調整前成交（委託）量交易單

位數據標準ｘ（1000 ÷ 該有價證券交易單位）。

}

// 基本條件

Condition501=absvalue(StockChangeRatio)\>9 and
absvalue(StockChangeRatio-TSEChangeRatio)\>=5 and V\>=3000;

Condition502=absvalue(StockChangeRatio)\>6 and
absvalue(StockChangeRatio-TSEChangeRatio)\>=4 and V\>=3000;

Condition503=GetField(\"週轉率\",\"D\")\>10 and V\>=3000;

// 條件整合

Condition550=Condition501 or Condition502 or Condition503;

// 篩選

If Condition550 Then Begin

AlertCount21=1;

End;

## 場景 408：XQ量化交易平台上的型態學相關函數 --- 例如，要計算近五期的次高價，就可以這麼寫：

> 來源：[[XQ量化交易平台上的型態學相關函數]{.underline}](https://www.xq.com.tw/xstrader/xs%e4%b8%8a%e7%9a%84%e5%9e%8b%e6%85%8b%e5%ad%b8%e7%9b%b8%e9%97%9c%e5%87%bd%e6%95%b8/)
> 說明：例如，要計算近五期的次高價，就可以這麼寫：

Value1=nthhighest(2,high,5);

## 場景 409：XQ量化交易平台上的型態學相關函數 --- 這個型態的特色是在整理期間還是一峰高過一峰，最後以更陡的漲勢來突破整理，要描述這樣的型態，可以運用上面所提到的nthhighest 及nthhighestbar\...

> 來源：[[XQ量化交易平台上的型態學相關函數]{.underline}](https://www.xq.com.tw/xstrader/xs%e4%b8%8a%e7%9a%84%e5%9e%8b%e6%85%8b%e5%ad%b8%e7%9b%b8%e9%97%9c%e5%87%bd%e6%95%b8/)
> 說明：這個型態的特色是在整理期間還是一峰高過一峰，最後以更陡的漲勢來突破整理，要描述這樣的型態，可以運用上面所提到的nthhighest
> 及nthhighestbar這兩個函數，參考的腳本如下：

input:period(20,\"計算區間\");

value2=nthhighest(1,high\[1\],period);//最高價

value3=nthhighest(2,high\[1\],period);//第二高價

value4=nthhighest(3,high\[1\],period);//第三高價

value5=nthhighestbar(1,high\[1\],period);//最高價距今幾根bar

value6=nthhighestbar(2,high\[1\],period);//第二高價距今幾根bar

value7=nthhighestbar(3,high\[1\],period);//第三高價距今幾根bar

if value6-value5\>3 and value7-value6\>3

  //三個高點沒有連在一起，且是愈來愈高

and maxlist(value2,value3,value4)

\<minlist(value2,value3,value4)\*1.05

  //三個高點相差不到5%

and close crosses over value2

  //創新高

then ret=1;

## 場景 410：XQ量化交易平台上的型態學相關函數 --- 例如想要找出過去20天，第二個左右兩邊都各至少有三天的高點價位，就可以寫成：

> 來源：[[XQ量化交易平台上的型態學相關函數]{.underline}](https://www.xq.com.tw/xstrader/xs%e4%b8%8a%e7%9a%84%e5%9e%8b%e6%85%8b%e5%ad%b8%e7%9b%b8%e9%97%9c%e5%87%bd%e6%95%b8/)
> 說明：例如想要找出過去20天，第二個左右兩邊都各至少有三天的高點價位，就可以寫成：

value1=swinghigh(high,20,3,3,2);

## 場景 411：XQ量化交易平台上的型態學相關函數 --- 以下是一個多次到頂而破的例子，用到的是 highest及highestbar這兩個函數

> 來源：[[XQ量化交易平台上的型態學相關函數]{.underline}](https://www.xq.com.tw/xstrader/xs%e4%b8%8a%e7%9a%84%e5%9e%8b%e6%85%8b%e5%ad%b8%e7%9b%b8%e9%97%9c%e5%87%bd%e6%95%b8/)
> 說明：以下是一個多次到頂而破的例子，用到的是
> highest及highestbar這兩個函數

input:HitTimes(4,\"設定觸頂次數\");

input:RangeRatio(1,\"設定頭部區範圍寬度%\");

input:Length(40,\"計算期數\");

if GetSymbolField(\"tse.tw\",\"收盤價\")

\>average(GetSymbolField(\"tse.tw\",\"收盤價\"),10)

then begin

variable: theHigh(0);

//找到過去其間的最高點

theHigh = Highest(High\[1\],Length);

value1=highestbar(high\[1\],length);

variable: HighLowerBound(0);

// 設為瓶頸區間上界

HighLowerBound = theHigh \*(100-RangeRatio)/100;

variable: TouchRangeTimes(0);

//回算在此區間中 進去瓶頸區的次數

TouchRangeTimes = CountIF(High\[1\] \> HighLowerBound, Length-value1);

Condition1 = TouchRangeTimes \>= HitTimes;

Condition2 = close \> theHigh;

condition3=close\[length\]\*1.1\<thehigh;

Ret = Condition1 and Condition2 and condition3 ;

end;

## 場景 412：圖說技術指標的設計方式與背後的思維（五) --- 今天要跟大家討論的是，除了把股價拿來作為統計分佈的計算標的，其實透過Getfield語法，我們也可以把其他欄位拿來試看看，今天跟大家舉個例子，我們平常看到個股的\...

> 來源：[[圖說技術指標的設計方式與背後的思維（五)]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e4%ba%94/)
> 說明：今天要跟大家討論的是，除了把股價拿來作為統計分佈的計算標的，其實透過Getfield語法，我們也可以把其他欄位拿來試看看，今天跟大家舉個例子，我們平常看到個股的外資買賣超時，如果只看絕對值，可能不見得很有感，但如果把布林值這種常態分配的概念放進去，就可以觀察目前的數字在統計學上，是不是已進十分罕見，如果罕見，往往就可能是一個新方向的開始，基於這樣的想法，我寫了一個腳本如下

input: Length(20, \"天數\"), UpperBand(2, \"上\"), LowerBand(2, \"下\"),
EMALength(3, \"EMA\");

variable: up(0), down(0), mid(0), bbandwidth(0), ema(0);

value1=GetField(\"外資買賣超張數\");

up = bollingerband(value1, Length, UpperBand);

down = bollingerband(value1, Length, -1 \* LowerBand);

Plot1(value1, \"外資買超張數\");

Plot2(up, \"上限\");

plot3(down,\"下限\");

## 場景 413：總市值低於一定標準

> 來源：[[總市值低於一定標準]{.underline}](https://www.xq.com.tw/xstrader/%e7%b8%bd%e5%b8%82%e5%80%bc%e4%bd%8e%e6%96%bc%e4%b8%80%e5%ae%9a%e6%a8%99%e6%ba%96/)
> 說明：我寫的腳本如下

value1=GetField(\"總市值(億)\",\"D\");//億元

value2=GetField(\"流動資產\",\"Q\");//百萬

value3=GetField(\"負債總額\",\"Q\");//百萬

value4=GetField(\"普通股股本\",\"Q\");//億元

if value4\<\>0 then

value5=((value2-value3)/100-value1)/(value4);

if value5\>0 then ret=1;

outputfield(1,value1,0,\"總市值億元\");

outputfield(2,value2/100,0,\"流動資產億元\");

outputfield(3,value3/100,0,\"負債總額億元\");

outputfield(4,value4,0,\"股本億元\");

outputfield(5,value5\*10,2,\"每股折價\");

## 場景 414：圖說技術指標的設計方式與背後的思維（四) --- 乖離率的概念簡單說，就是目前的價格離平均值有多遠，XS裡有一個bias的函數就是用來計算乖離率，它的腳本如下

> 來源：[[圖說技術指標的設計方式與背後的思維（四)]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e5%9b%9b/)
> 說明：乖離率的概念簡單說，就是目前的價格離平均值有多遠，XS裡有一個bias的函數就是用來計算乖離率，它的腳本如下

SetBarMode(1);

// Bias function (for 乖離率相關指標)

//

input: length(numericsimple);

value1 = Average(close, length);

Bias = (close - value1) \* 100 / value1;

## 場景 415：圖說技術指標的設計方式與背後的思維（四) --- 除了偏離均線算是乖離，另外一種概念叫震盪，它的概念是人們有時太過樂觀，有時又太過悲觀，所以造成股價會上下波動，形成一種像鐘擺一樣的來回震盪走勢，這個概念裡最有名\...

> 來源：[[圖說技術指標的設計方式與背後的思維（四)]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e5%9b%9b/)
> 說明：除了偏離均線算是乖離，另外一種概念叫震盪，它的概念是人們有時太過樂觀，有時又太過悲觀，所以造成股價會上下波動，形成一種像鐘擺一樣的來回震盪走勢，這個概念裡最有名的指標是KD指標，它的計算方式是去找出特定區間內，收盤價與最低價的距離佔區間最高價與最低價間距離的比例，它的計算公式如下，在XS中是把它寫成一個叫Stochastic的函數，函數的腳本如下

input:

length(numericsimple), rsvt(numericsimple), kt(numericsimple),

rsv(numericref), k(numericref), d(numericref);

variable:

maxHigh(0), minLow(0);

maxHigh = Highest(high, length);

//找出波段最高點

minLow = Lowest(low, length);

//找出波段最低點

if maxHigh \<\> minLow then

rsv = 100 \* (close - minLow) / (maxHigh - minLow)

else

rsv = 50;

//定議RSV是收盤價減去波段最低點除以最高點到最低點間的距離

if currentbar = 1 then

begin

k = 50;

d = 50;

end

else

begin

k = (k\[1\] \* (rsvt - 1) + rsv) / rsvt;

//K值是平滑RSV值

d = (d\[1\] \* (kt - 1) + k) / kt;

//D值是K值的平滑值

end;

stochastic = 1;

## 場景 416：圖說技術指標的設計方式與背後的思維（四) --- 一般rsvt常用的是3，也就是平滑的權重是1/3，區間是9，所以如果要寫出9K在低檔與9D黃金交叉的腳本，就可以運用這個stochastic的函數撰寫如下

> 來源：[[圖說技術指標的設計方式與背後的思維（四)]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e5%9b%9b/)
> 說明：一般rsvt常用的是3，也就是平滑的權重是1/3，區間是9，所以如果要寫出9K在低檔與9D黃金交叉的腳本，就可以運用這個stochastic的函數撰寫如下

input: Length(9), RSVt(3), Kt(3);

variable: rsv(0), k(0), \_d(0);

SetTotalBar(maxlist(Length,6) \* 3);

SetInputName(1, \"天數\");

SetInputName(2, \"RSVt權數\");

SetInputName(3, \"Kt權數\");

Stochastic(Length, RSVt, Kt, rsv, k, \_d);

Ret = k crosses above \_d;

## 場景 417：期指盤中領先指標的另一個寫法

> 來源：[[期指盤中領先指標的另一個寫法]{.underline}](https://www.xq.com.tw/xstrader/%e6%9c%9f%e6%8c%87%e7%9b%a4%e4%b8%ad%e9%a0%98%e5%85%88%e6%8c%87%e6%a8%99%e7%9a%84%e5%8f%a6%e4%b8%80%e5%80%8b%e5%af%ab%e6%b3%95/)
> 說明：這個腳本如下

array:T50\[50\](0);

t50\[1\]=GetSymbolField(\"5876.tw\",\"close\");

t50\[2\]=GetSymbolField(\"2317.tw\",\"close\");

t50\[3\]=GetSymbolField(\"2412.tw\",\"close\");

t50\[4\]=GetSymbolField(\"1301.tw\",\"close\");

t50\[5\]=GetSymbolField(\"1303.tw\",\"close\");

t50\[6\]=GetSymbolField(\"2454.tw\",\"close\");

t50\[7\]=GetSymbolField(\"1326.tw\",\"close\");

t50\[8\]=GetSymbolField(\"2308.tw\",\"close\");

t50\[9\]=GetSymbolField(\"2882.tw\",\"close\");

t50\[10\]=GetSymbolField(\"2881.tw\",\"close\");

t50\[11\]=GetSymbolField(\"2891.tw\",\"close\");

t50\[12\]=GetSymbolField(\"2002.tw\",\"close\");

t50\[13\]=GetSymbolField(\"1216.tw\",\"close\");

t50\[14\]=GetSymbolField(\"3008.tw\",\"close\");

t50\[15\]=GetSymbolField(\"2886.tw\",\"close\");

t50\[16\]=GetSymbolField(\"3711.tw\",\"close\");

t50\[17\]=GetSymbolField(\"2357.tw\",\"close\");

t50\[18\]=GetSymbolField(\"2474.tw\",\"close\");

t50\[19\]=GetSymbolField(\"3045.tw\",\"close\");

t50\[20\]=GetSymbolField(\"6505.tw\",\"close\");

t50\[21\]=GetSymbolField(\"2303.tw\",\"close\");

t50\[22\]=GetSymbolField(\"2382.tw\",\"close\");

t50\[23\]=GetSymbolField(\"2207.tw\",\"close\");

t50\[24\]=GetSymbolField(\"2892.tw\",\"close\");

t50\[25\]=GetSymbolField(\"4938.tw\",\"close\");

t50\[26\]=GetSymbolField(\"2884.tw\",\"close\");

t50\[27\]=GetSymbolField(\"2912.tw\",\"close\");

t50\[28\]=GetSymbolField(\"2885.tw\",\"close\");

t50\[29\]=GetSymbolField(\"2883.tw\",\"close\");

t50\[30\]=GetSymbolField(\"2105.tw\",\"close\");

t50\[31\]=GetSymbolField(\"2880.tw\",\"close\");

t50\[32\]=GetSymbolField(\"2330.tw\",\"close\");

t50\[33\]=GetSymbolField(\"4904.tw\",\"close\");

t50\[34\]=GetSymbolField(\"5880.tw\",\"close\");

t50\[35\]=GetSymbolField(\"2823.tw\",\"close\");

t50\[36\]=GetSymbolField(\"9904.tw\",\"close\");

t50\[37\]=GetSymbolField(\"1402.tw\",\"close\");

t50\[38\]=GetSymbolField(\"1101.tw\",\"close\");

t50\[39\]=GetSymbolField(\"2887.tw\",\"close\");

t50\[40\]=GetSymbolField(\"2890.tw\",\"close\");

t50\[41\]=GetSymbolField(\"2801.tw\",\"close\");

t50\[42\]=GetSymbolField(\"2633.tw\",\"close\");

t50\[43\]=GetSymbolField(\"5871.tw\",\"close\");

t50\[44\]=GetSymbolField(\"2301.tw\",\"close\");

t50\[45\]=GetSymbolField(\"2395.tw\",\"close\");

t50\[46\]=GetSymbolField(\"2354.tw\",\"close\");

t50\[47\]=GetSymbolField(\"9904.tw\",\"close\");

t50\[48\]=GetSymbolField(\"1102.tw\",\"close\");

t50\[49\]=GetSymbolField(\"2408.tw\",\"close\");

t50\[50\]=GetSymbolField(\"2227.tw\",\"close\");

variable:count(0),i(0);

count=0;

for i=1 to 50

begin

if t50\[i\]\> t50\[i\]\[1\]

then count=count+1;

end;

value1=average(count,10);

plot1(value1);

## 場景 418：如何打造盤中即時多空指標？ --- 我把這個腳本放在下面給大家參考

> 來源：[[如何打造盤中即時多空指標？]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e6%89%93%e9%80%a0%e7%9b%a4%e4%b8%ad%e5%8d%b3%e6%99%82%e5%a4%9a%e7%a9%ba%e6%8c%87%e6%a8%99%ef%bc%9f/)
> 說明：我把這個腳本放在下面給大家參考

array:T50\[50\](0);

t50\[1\]=GetSymbolField(\"5876.tw\",\"close\");

t50\[2\]=GetSymbolField(\"2317.tw\",\"close\");

t50\[3\]=GetSymbolField(\"2412.tw\",\"close\");

t50\[4\]=GetSymbolField(\"1301.tw\",\"close\");

t50\[5\]=GetSymbolField(\"1303.tw\",\"close\");

t50\[6\]=GetSymbolField(\"2454.tw\",\"close\");

t50\[7\]=GetSymbolField(\"1326.tw\",\"close\");

t50\[8\]=GetSymbolField(\"2308.tw\",\"close\");

t50\[9\]=GetSymbolField(\"2882.tw\",\"close\");

t50\[10\]=GetSymbolField(\"2881.tw\",\"close\");

t50\[11\]=GetSymbolField(\"2891.tw\",\"close\");

t50\[12\]=GetSymbolField(\"2002.tw\",\"close\");

t50\[13\]=GetSymbolField(\"1216.tw\",\"close\");

t50\[14\]=GetSymbolField(\"3008.tw\",\"close\");

t50\[15\]=GetSymbolField(\"2886.tw\",\"close\");

t50\[16\]=GetSymbolField(\"3711.tw\",\"close\");

t50\[17\]=GetSymbolField(\"2357.tw\",\"close\");

t50\[18\]=GetSymbolField(\"2474.tw\",\"close\");

t50\[19\]=GetSymbolField(\"3045.tw\",\"close\");

t50\[20\]=GetSymbolField(\"6505.tw\",\"close\");

t50\[21\]=GetSymbolField(\"2303.tw\",\"close\");

t50\[22\]=GetSymbolField(\"2382.tw\",\"close\");

t50\[23\]=GetSymbolField(\"2207.tw\",\"close\");

t50\[24\]=GetSymbolField(\"2892.tw\",\"close\");

t50\[25\]=GetSymbolField(\"4938.tw\",\"close\");

t50\[26\]=GetSymbolField(\"2884.tw\",\"close\");

t50\[27\]=GetSymbolField(\"2912.tw\",\"close\");

t50\[28\]=GetSymbolField(\"2885.tw\",\"close\");

t50\[29\]=GetSymbolField(\"2883.tw\",\"close\");

t50\[30\]=GetSymbolField(\"2105.tw\",\"close\");

t50\[31\]=GetSymbolField(\"2880.tw\",\"close\");

t50\[32\]=GetSymbolField(\"2330.tw\",\"close\");

t50\[33\]=GetSymbolField(\"4904.tw\",\"close\");

t50\[34\]=GetSymbolField(\"5880.tw\",\"close\");

t50\[35\]=GetSymbolField(\"2481.tw\",\"close\");

t50\[36\]=GetSymbolField(\"9904.tw\",\"close\");

t50\[37\]=GetSymbolField(\"1402.tw\",\"close\");

t50\[38\]=GetSymbolField(\"1101.tw\",\"close\");

t50\[39\]=GetSymbolField(\"2887.tw\",\"close\");

t50\[40\]=GetSymbolField(\"2890.tw\",\"close\");

t50\[41\]=GetSymbolField(\"2801.tw\",\"close\");

t50\[42\]=GetSymbolField(\"1476.tw\",\"close\");

t50\[43\]=GetSymbolField(\"2409.tw\",\"close\");

t50\[44\]=GetSymbolField(\"2301.tw\",\"close\");

t50\[45\]=GetSymbolField(\"2395.tw\",\"close\");

t50\[46\]=GetSymbolField(\"2354.tw\",\"close\");

t50\[47\]=GetSymbolField(\"9904.tw\",\"close\");

t50\[48\]=GetSymbolField(\"1102.tw\",\"close\");

t50\[49\]=GetSymbolField(\"2408.tw\",\"close\");

t50\[50\]=GetSymbolField(\"2227.tw\",\"close\");

variable:count(0),i(0);

count=0;

for i=1 to 50

begin

if t50\[i\] \> average(t50\[i\],10)

then count=count+1;

end;

plot1(count-25);

## 場景 419：圖說技術指標的設計方式與背後的思維（三) --- 一般的移動平均線，就是把平均線期別裡的每個收盤價加總起來除以天期，XS裡的average函數就是這麼算的，腳本如下

> 來源：[[圖說技術指標的設計方式與背後的思維（三)]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e4%b8%89/)
> 說明：一般的移動平均線，就是把平均線期別裡的每個收盤價加總起來除以天期，XS裡的average函數就是這麼算的，腳本如下

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

if Length \> 0 then

Average = Summation(thePrice, Length) / Length

else

Average =0;

## 場景 420：圖說技術指標的設計方式與背後的思維（三) --- 簡單的移動平均線最常被垢病的，是把過去的價格跟現在的價格視為一樣重要，這樣在價格波動時，可能反應不夠靈敏，所以有人主張，應該不能用簡單平均，要用加權平均來算移動\...

> 來源：[[圖說技術指標的設計方式與背後的思維（三)]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e4%b8%89/)
> 說明：簡單的移動平均線最常被垢病的，是把過去的價格跟現在的價格視為一樣重要，這樣在價格波動時，可能反應不夠靈敏，所以有人主張，應該不能用簡單平均，要用加權平均來算移動平均線，給予最新的價格較高的權重。XS裡有一個函數Xaverage就是這樣的作法。

SetBarMode(2);

input:thePrice(numericseries); //\"價格序列\"

input:Length(Numeric); //\"計算期間\"

variable: Factor(0);

if length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);

if CurrentBar = 1 then

XAverage = thePrice

else

XAverage = XAverage\[1\] + Factor \* (thePrice - XAverage\[1\]);

## 場景 421：圖說技術指標的設計方式與背後的思維（三) --- 我們先來看看這個指標的函數計算方式

> 來源：[[圖說技術指標的設計方式與背後的思維（三)]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e4%b8%89/)
> 說明：我們先來看看這個指標的函數計算方式

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

## 場景 422：圖說技術指標的設計方式與背後的思維（三) --- 如果要說把加權移動平均的概念運用的最到位的，TRIX指標應該是其中一個，它的計算公式如下

> 來源：[[圖說技術指標的設計方式與背後的思維（三)]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e4%b8%89/)
> 說明：如果要說把加權移動平均的概念運用的最到位的，TRIX指標應該是其中一個，它的計算公式如下

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

## 場景 423：圖說技術指標的設計方式與背後的思維（二) --- 提到成交量，大家最耳熟能詳的應該是能量潮OBV指標，這指標的腳本如下

> 來源：[[圖說技術指標的設計方式與背後的思維（二)]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e4%ba%8c/)
> 說明：提到成交量，大家最耳熟能詳的應該是能量潮OBV指標，這指標的腳本如下

variable: obvolume(0);

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

Plot1(obvolume, \"OBV\");

## 場景 424：圖說技術指標的設計方式與背後的思維（二) --- 另外一個把各價位跟成交量結合的技術指標叫作Chaikin Money Flow，它的腳本如下

> 來源：[[圖說技術指標的設計方式與背後的思維（二)]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e4%ba%8c/)
> 說明：另外一個把各價位跟成交量結合的技術指標叫作Chaikin Money
> Flow，它的腳本如下

variable:ad(0),chai(0);

if h-l\<\> 0 then

ad=((c-l)-(h-c))/(h-l)\*volume;

input:length(5);

value1=summation(ad,length);

value2=summation(volume,length);

if value2\<\>0 then

chai=value1/value2;

plot1(chai);

## 場景 425：圖說技術指標的設計方式與背後的思維（二) --- 這個指標重視的是當根K棒的多空力道變化，但沒有考慮到前後根K棒價格的變化，有另一個技術指標Money Flow Index則是把成交量跟前後根的變化一起考量，這\...

> 來源：[[圖說技術指標的設計方式與背後的思維（二)]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e4%ba%8c/)
> 說明：這個指標重視的是當根K棒的多空力道變化，但沒有考慮到前後根K棒價格的變化，有另一個技術指標Money
> Flow Index則是把成交量跟前後根的變化一起考量，這個指標的計算腳本如下

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

## 場景 426：圖說技術指標的設計方式與背後的思維（一） --- 所以累積/派發線指標的腳本就可以撰寫如下

> 來源：[[圖說技術指標的設計方式與背後的思維（一）]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e4%b8%80%ef%bc%89/)
> 說明：所以累積/派發線指標的腳本就可以撰寫如下

VAR:ADL(0);

if currentbar=1 then

adl=((close-low)-(high-close))/(high-low)\*volume

else if high\<\>low then

adl=adl\[1\]+((close-low)-(high-close))/(high-low)\*volume

else

adl=adl\[1\]+((close/close\[1\])-1)\*volume;

plot1(adl,\"累積派發線\");

## 場景 427：圖說技術指標的設計方式與背後的思維（一）

> 來源：[[圖說技術指標的設計方式與背後的思維（一）]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e4%b8%80%ef%bc%89/)
> 說明：一，錢德動能震盪指標

Input:length(10, \"天期\");

variable: SU(0),SD(0);

if close \>= close\[1\] then

SU = CLOSE - CLOSE\[1\]

//上漲值

else

SU = 0;

if close \< close\[1\] then

SD = CLOSE\[1\] - CLOSE

//下跌值

else

SD = 0;

value1 = summation(SU,length);

//區間上漲值的總合

value2 = summation(SD,length);

//區間下跌值的總合

value3 = (value1-value2)/(value1+value2)\*100;

//區間上漲值總合減下跌值總合的結果當分子

//兩者的總合當分母

plot1(value3, \"CMO\");

## 場景 428：圖說技術指標的設計方式與背後的思維（一） --- 類似把一段區間上漲與下跌值相加總之後再作運算的，最普遍被應用的是RSI這個指標，這個指標是由RS相對強度這個概念而來，以下是相對強度的腳本

> 來源：[[圖說技術指標的設計方式與背後的思維（一）]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%96%e8%aa%aa%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%ad%e8%a8%88%e6%96%b9%e5%bc%8f%e8%88%87%e8%83%8c%e5%be%8c%e7%9a%84%e6%80%9d%e7%b6%ad%ef%bc%88%e4%b8%80%ef%bc%89/)
> 說明：類似把一段區間上漲與下跌值相加總之後再作運算的，最普遍被應用的是RSI這個指標，這個指標是由RS相對強度這個概念而來，以下是相對強度的腳本

SetBarMode(1);

//指定為simple函數

input: price(numericseries), length(numericsimple);

variable: sumUp(0), sumDown(0), up(0), down(0);

if CurrentBar = 1 then begin

sumUp = Average(maxlist(price - price\[1\], 0), length);

//第一根的sumUP是過去一段期間內上漲點數合的平均值

sumDown = Average(maxlist(price\[1\] - price, 0), length);

//第一個的sumDown是過去一段期間內下跌點數合的平均值

end else begin

up = maxlist(price - price\[1\], 0);

// up是如果當天上漲時的上漲值

down = maxlist(price\[1\] - price, 0);

//down是如果當日下跌時的下跌值

sumUp = sumUp\[1\] + (up - sumUp\[1\]) / length;

//sumUp是前一期的sumUP+最近一期上漲值（如果上漲的話）

sumDown = sumDown\[1\] + (down - sumDown\[1\]) / length;

//sumDown是前一期的sumDown+最近一期下跌值（如果下跌的話）

end;

if sumDown = 0 then RS = 0 else RS = sumUp /sumDown;

## 場景 429：歐沙納希價值型交易策略 --- 我用的是暴量剛起漲這個腳本

> 來源：[[歐沙納希價值型交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e6%ad%90%e6%b2%99%e7%b4%8d%e5%b8%8c%e5%83%b9%e5%80%bc%e5%9e%8b%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：我用的是暴量剛起漲這個腳本

Input: day(30,\"日期區間\");

Input: ratioLimit(7, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 430：在多變的世界裡，尋找一些靠譜的事 --- 其中過去n年有一年eps超過m元的腳本如下

> 來源：[[在多變的世界裡，尋找一些靠譜的事]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%a8%e5%a4%9a%e8%ae%8a%e7%9a%84%e4%b8%96%e7%95%8c%e8%a3%a1%ef%bc%8c%e5%b0%8b%e6%89%be%e4%b8%80%e4%ba%9b%e9%9d%a0%e8%ad%9c%e7%9a%84%e4%ba%8b/)
> 說明：其中過去n年有一年eps超過m元的腳本如下

input:period(7,\"年期\");

input:l1(4,\"eps\");

value1=GetField(\"每股稅後淨利(元)\",\"Y\");

if trueany(value1\>=l1,period)

then ret=1;

## 場景 431：在多變的世界裡，尋找一些靠譜的事 --- 過去n天股價都小於m元的腳本則如下

> 來源：[[在多變的世界裡，尋找一些靠譜的事]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%a8%e5%a4%9a%e8%ae%8a%e7%9a%84%e4%b8%96%e7%95%8c%e8%a3%a1%ef%bc%8c%e5%b0%8b%e6%89%be%e4%b8%80%e4%ba%9b%e9%9d%a0%e8%ad%9c%e7%9a%84%e4%ba%8b/)
> 說明：過去n天股價都小於m元的腳本則如下

input:period(400,\"天期\");

input:l1(30,\"股價上限\");

if trueall(high\<=l1,period)

then ret=1;

## 場景 432：關於極短線交易策略撰寫上的一些小技巧(一) --- 例如想要累計今天大買單或大賣單的成交金額或張數，想要累計外盤成交的筆數之類的，這是我們在寫極短線腳本時會常用到的，但卻不知道怎麼寫，後來我請了同事給了我一個範本\...

> 來源：[[關於極短線交易策略撰寫上的一些小技巧(一)]{.underline}](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e6%a5%b5%e7%9f%ad%e7%b7%9a%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e6%92%b0%e5%af%ab%e4%b8%8a%e7%9a%84%e4%b8%80%e4%ba%9b%e5%b0%8f%e6%8a%80%e5%b7%a7%e4%b8%80/)
> 說明：例如想要累計今天大買單或大賣單的成交金額或張數，想要累計外盤成交的筆數之類的，這是我們在寫極短線腳本時會常用到的，但卻不知道怎麼寫，後來我請了同事給了我一個範本，他寫的是今天大單買進超過N次的腳本

input: atVolume(100,\"大單門檻\");

input: LaTime(10,\"大單筆數\");

input:TXT(\"須逐筆洗價\",\"使用限制\");

settotalbar(3);

variable: intrabarpersist Xtime(0);

//計數器

variable: intrabarpersist Volumestamp(0);

Volumestamp =q_DailyVolume;

if Date\> date\[1\] or

Volumestamp = Volumestamp\[1\]

then Xtime =0; //開盤那根要歸0次數

if q_tickvolume \> atVolume

//單筆tick成交量超過大單門檻

and GetQuote(\"BidAskFlag\")=1

//外盤成交

then Xtime+=1;

//量夠大就加1次

if Xtime \> LaTime

and close\>close\[1\]\*1.01

then

begin

ret=1;

Xtime=0;

end;

## 場景 433：關於極短線交易策略撰寫上的一些小技巧(一) --- 我們常會寫一些腳本是屬於那種要從第N根1分鐘線開始作計算的腳本，例如開盤八法是去計算前三根五分鐘線的漲跌情況，我的同事寫了一個開盤前三根都是紅K棒的腳本給我

> 來源：[[關於極短線交易策略撰寫上的一些小技巧(一)]{.underline}](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e6%a5%b5%e7%9f%ad%e7%b7%9a%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e6%92%b0%e5%af%ab%e4%b8%8a%e7%9a%84%e4%b8%80%e4%ba%9b%e5%b0%8f%e6%8a%80%e5%b7%a7%e4%b8%80/)
> 說明：我們常會寫一些腳本是屬於那種要從第N根1分鐘線開始作計算的腳本，例如開盤八法是去計算前三根五分鐘線的漲跌情況，我的同事寫了一個開盤前三根都是紅K棒的腳本給我

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

## 場景 434：關於極短線交易策略撰寫上的一些小技巧(一) --- 我在寫極短線腳本時，經常用到1分鐘線，這時候常會想要確定要拿多少跟K棒來算，以及每一根K棒是計算的第幾根，還有第一根如果要計算像十根移動平均時，必須再往前多拿九\...

> 來源：[[關於極短線交易策略撰寫上的一些小技巧(一)]{.underline}](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e6%a5%b5%e7%9f%ad%e7%b7%9a%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e6%92%b0%e5%af%ab%e4%b8%8a%e7%9a%84%e4%b8%80%e4%ba%9b%e5%b0%8f%e6%8a%80%e5%b7%a7%e4%b8%80/)
> 說明：我在寫極短線腳本時，經常用到1分鐘線，這時候常會想要確定要拿多少跟K棒來算，以及每一根K棒是計算的第幾根，還有第一根如果要計算像十根移動平均時，必須再往前多拿九根來算，這些到底在腳本上要怎麼設，我常弄的迷迷糊糊，後來我同事就寫了一個範本給我

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

then ret=1;

end;

## 場景 435：關於極短線交易策略撰寫上的一些小技巧(一) --- 透過這兩個函數，我們就可以框定這個腳本要從最近一根之前的第幾根bar開始計算起，然後要往前引用多少根的資料，把每根bar標示號碼之後，就可以用currentba\...

> 來源：[[關於極短線交易策略撰寫上的一些小技巧(一)]{.underline}](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e6%a5%b5%e7%9f%ad%e7%b7%9a%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e6%92%b0%e5%af%ab%e4%b8%8a%e7%9a%84%e4%b8%80%e4%ba%9b%e5%b0%8f%e6%8a%80%e5%b7%a7%e4%b8%80/)
> 說明：透過這兩個函數，我們就可以框定這個腳本要從最近一根之前的第幾根bar開始計算起，然後要往前引用多少根的資料，把每根bar標示號碼之後，就可以用currentbar這個函數來表達現在要的是第幾根，例如以下的腳本是去計算加權平均值，這時候第一根必須引用收盤價作為加權平均值，所以腳本可以如下面這麼寫

if CurrentBar = 1 then

XAverage = Close

else

XAverage = XAverage\[1\] + Factor \* (Close - XAverage\[1\])

## 場景 436：關於極短線交易策略撰寫上的一些小技巧(一) --- 我在寫極短線腳本時，會希望設定一些特定時間的關卡點，例如09：15或是10點，是午飯時間如12：00之類的，我們同事寫了一個範本給我

> 來源：[[關於極短線交易策略撰寫上的一些小技巧(一)]{.underline}](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e6%a5%b5%e7%9f%ad%e7%b7%9a%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e6%92%b0%e5%af%ab%e4%b8%8a%e7%9a%84%e4%b8%80%e4%ba%9b%e5%b0%8f%e6%8a%80%e5%b7%a7%e4%b8%80/)
> 說明：我在寫極短線腳本時，會希望設定一些特定時間的關卡點，例如09：15或是10點，是午飯時間如12：00之類的，我們同事寫了一個範本給我

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

## 場景 437：關於極短線交易策略撰寫上的一些小技巧(一) --- 我們在透過分鐘線描述當天走勢時，常常會想要考慮到日線對應的價量關係，例如今天盤中一分鐘線突破前一根日線高點之類的想法，這時候會希望可以在分鐘線的腳本中，引用日線\...

> 來源：[[關於極短線交易策略撰寫上的一些小技巧(一)]{.underline}](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e6%a5%b5%e7%9f%ad%e7%b7%9a%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e6%92%b0%e5%af%ab%e4%b8%8a%e7%9a%84%e4%b8%80%e4%ba%9b%e5%b0%8f%e6%8a%80%e5%b7%a7%e4%b8%80/)
> 說明：我們在透過分鐘線描述當天走勢時，常常會想要考慮到日線對應的價量關係，例如今天盤中一分鐘線突破前一根日線高點之類的想法，這時候會希望可以在分鐘線的腳本中，引用日線的價量資料，這時候就需要用到一些語法上的小技巧，茲舉例如下

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

//一分鐘線第一根的最新價格高於前一日的收盤價

then BreakHigh = true;

//開高

value1 = average(GetField(\"Volume\", \"D\")\[1\], 5);

//用getfield語法來取得過去五天成交量再作移動平均

//五日均量

condition3 = value1 \> averageVolume;

//五日均量大於某張數

value2 = rateofchange(GetField(\"Close\", \"D\")\[1\], 3);

condition4 = AbsValue(value2) \< changeRatio;

//前三日漲帳幅小於一定標準

condition5 = summation(volume, 5) \> value1 \* volumeRatio;

//前五根一分鐘線成交量的合計大於五日均量某個比例

if condition1 and condition2 and condition3

and Condition4 and Condition5

and BreakHigh

then ret=1;

## 場景 438：關於極短線交易策略撰寫上的一些小技巧(一) --- 我在描繪分時圖盤整後突破高點時，不知道要怎麼寫才合適？ 同事給了我一個範本如下

> 來源：[[關於極短線交易策略撰寫上的一些小技巧(一)]{.underline}](https://www.xq.com.tw/xstrader/%e9%97%9c%e6%96%bc%e6%a5%b5%e7%9f%ad%e7%b7%9a%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e6%92%b0%e5%af%ab%e4%b8%8a%e7%9a%84%e4%b8%80%e4%ba%9b%e5%b0%8f%e6%8a%80%e5%b7%a7%e4%b8%80/)
> 說明：我在描繪分時圖盤整後突破高點時，不知道要怎麼寫才合適？
> 同事給了我一個範本如下

input:HitTimes(3,\"設定觸頂次數\");

input:RangeRatio(1,\"設定頭部區範圍寬度%\");

input:Length(20,\"計算期數\");

settotalbar(Length + 3);

variable: theHigh(0);

theHigh = Highest(High\[1\],Length);

//找到過去其間的最高點

variable: HighLowerBound(0);

HighLowerBound = theHigh \*(100-RangeRatio)/100;

// 設為瓶頸區間上界

variable: TouchRangeTimes(0);

//回算在此區間中 進去瓶頸區的次數

TouchRangeTimes = CountIF(High\[1\] \> HighLowerBound, Length);

if TouchRangeTimes \>= HitTimes and close \> theHigh then ret=1;

## 場景 439：如何快速定義及應用K線型態來寫腳本？ --- 首先，我寫了一個樣本函數如下：

> 來源：[[如何快速定義及應用K線型態來寫腳本？]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e5%bf%ab%e9%80%9f%e5%ae%9a%e7%be%a9%e5%8f%8a%e6%87%89%e7%94%a8k%e7%b7%9a%e5%9e%8b%e6%85%8b%e4%be%86%e5%af%ab%e8%85%b3%e6%9c%ac%ef%bc%9f/)
> 說明：首先，我寫了一個樣本函數如下：

bKpatterm型態函數

settotalbar(5);

condition2 = (minlist(open,close)-Low) \> absvalue(open-close)\*3;

condition3 = minlist(open, close) \> low\* (100 + 2)/100;

if trueall( condition2 and condition3, 3)

then bkpatterm=\"三長下影線\";

{\[檔名:\] 紅三兵

\[說明:\] 連續三根上漲實體K棒

}

condition1= ( close - open ) \>(high -low) \* 0.75;

//狀況1:實體上漲K棒

condition4= ( close\[1\] - open\[1\] ) \>(high\[1\] -low\[1\]) \* 0.75;

//狀況2:前一根也是實體上漲K棒

condition5= ( close\[2\] - open\[2\] ) \>(high\[2\] -low\[2\]) \* 0.75;

//狀況3:前前根也是實體上漲K棒

condition6= close \> close\[1\];

//狀況4: 上漲

condition7= close\[1\] \> close\[2\];//狀況5:上漲

{結果判斷}

IF

condition1

and condition4

and condition5

and condition6

and condition7

THEN bkpatterm=\"紅三兵\";

condition8= ( open\[2\] - close\[2\] ) \>(high\[2\] -low\[2\]) \* 0.75;

//狀況1:實體下跌K棒

condition9= ( close\[1\] - open\[1\] ) \>(high\[1\] -low\[1\]) \* 0.75;

//狀況2:實體上漲K棒

condition10= high\[1\] \< high\[2\] and low\[1\] \> low\[2\];

//狀況3:前期內包於前前期

condition11=( close - open ) \> 0.75 \*(high -low);

//狀況4:當期實體上漲K棒

condition12=close \> open\[2\];

//狀況5:現價突破前前期開盤價

IF condition8

and condition9

and condition10

and condition11

and condition12

THEN bkpatterm=\"內困三日翻紅\";

condition13=open = High and close \< open ;//狀況1: 開高收低留黑棒

condition14=(high -low) \> 2 \*(high\[1\]-low\[1\]) ;//狀況2: 波動倍增

condition15=(close-low)\> (open-close) \*2 ;//狀況3:
下影線為實體兩倍以上

IF condition13

and condition14

and condition15

THEN bkpatterm=\"吊人線\";

condition16=(open\[1\] - close\[1\] ) \>(high\[1\] -low\[1\])\*0.75;

//狀況1:前期出黑K棒

condition17=( close - open ) \>(high -low) \* 0.75;

//狀況2:當期紅棒

condition18=high \> high\[1\];

//狀況3:高過昨高

condition19=open\<low\[1\];

//狀況4:開低破昨低

IF condition16

and condition17

and condition18

and condition19

THEN bkpatterm=\"多頭吞噬\";

{

\[檔名:\] 多頭執帶

\[說明:\] 開在最低點一路走高收在最高點附近的K棒

}

condition20=close\>open;

condition21=(Close-Open)\>(high-low)\*0.9;

condition22=Close\>Close\[1\]+high\[1\]-low\[1\];

IF condition20

and condition21

and condition22

THEN bkpatterm=\"多頭執帶\";

{

\[檔名:\] 多頭母子

\[說明:\] 前期收長黑K棒 今期開高小幅收紅不過昨高

}

condition23=( open\[1\] - close\[1\] ) \>(high\[1\] -low\[1\])\*0.75;

//狀況1:前期出長黑K棒

condition24=close\[3\]-close\[2\]\<close\[2\]-close\[1\];

//狀況2:前期呈波動放大下跌

condition25=( close - open ) \>(high -low) \* 0.75;

//狀況3:當期紅棒

condition26=high \< high\[1\];

//狀況4:高不過昨高

condition27=low\>low\[1\];

//狀況5:低不破昨低

IF

condition23

and condition24

and condition25

and condition26

and condition27

THEN bkpatterm=\"多頭母子\";

{

\[檔名:\] 多頭遭遇

\[說明:\] 前期收黑K棒 當期開低走高紅棒嘗試反攻昨收

}

condition28= (open\[1\] - close\[1\] ) \>(high\[1\] -low\[1\]) \* 0.75;

//狀況1:前期出黑K棒

condition29= close\[1\] \< close\[2\];

//狀況2:前期收跌

condition30= ( close - open ) \>(high -low) \* 0.75;

//狀況3:當期收紅K棒

condition31= open \< close\[1\] and close \< close\[1\];

//狀況4:開低且收跌

condition32= low \< low\[1\];//狀況5:破前期低點

{結果判斷}

IF

condition28

and condition29

and condition30

and condition31

and condition32

THEN bkpatterm=\"多頭遭遇\";

## 場景 440：如何快速定義及應用K線型態來寫腳本？ --- 這當中除了本益比小於12及近一日三大法人合計買超這兩個條件是系統內建的之外，另外加了一個腳本型的選股條件： 低本益比股大跌後出現多頭母子，我寫的腳本如下：

> 來源：[[如何快速定義及應用K線型態來寫腳本？]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e5%bf%ab%e9%80%9f%e5%ae%9a%e7%be%a9%e5%8f%8a%e6%87%89%e7%94%a8k%e7%b7%9a%e5%9e%8b%e6%85%8b%e4%be%86%e5%af%ab%e8%85%b3%e6%9c%ac%ef%bc%9f/)
> 說明：這當中除了本益比小於12及近一日三大法人合計買超這兩個條件是系統內建的之外，另外加了一個腳本型的選股條件：
> 低本益比股大跌後出現多頭母子，我寫的腳本如下：

if bkpatterm=\"多頭母子\"

and close\*1.4\<close\[90\]

and close\*1.2\<close\[30\]

then ret=1;

## 場景 441：大跌後出現什麼癥兆是可以抄底的？

> 來源：[[大跌後出現什麼癥兆是可以抄底的？]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e5%87%ba%e7%8f%be%e4%bb%80%e9%ba%bc%e7%99%a5%e5%85%86%e6%98%af%e5%8f%af%e4%bb%a5%e6%8a%84%e5%ba%95%e7%9a%84%ef%bc%9f/)
> 說明：我寫的腳本如下

input:period(20);

value1=GetField(\"分公司賣出家數\")\[1\];

value2=GetField(\"分公司買進家數\")\[1\];

if linearregslope(value1,period)\>0

//賣出的家數愈來愈多

and linearregslope(value2,period)\<0

//買進的家數愈來愈少

and

close\*1.05\<close\[period\]

//過去一段時間股價在跌

and close\*1.25\<close\[30\]

then ret=1;

## 場景 442：大跌後出現什麼癥兆是可以抄底的？

> 來源：[[大跌後出現什麼癥兆是可以抄底的？]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e5%87%ba%e7%8f%be%e4%bb%80%e9%ba%bc%e7%99%a5%e5%85%86%e6%98%af%e5%8f%af%e4%bb%a5%e6%8a%84%e5%ba%95%e7%9a%84%ef%bc%9f/)
> 說明：對應的腳本如下

if trueall(close\>open,5)

and close\*1.4\<close\[90\]

and close\*1.2\<close\[20\]

then ret=1;

## 場景 443：大跌後出現什麼癥兆是可以抄底的？ --- 這個策略是去尋找大跌且近期急跌後，近十個交易日價量背離的股票

> 來源：[[大跌後出現什麼癥兆是可以抄底的？]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e5%87%ba%e7%8f%be%e4%bb%80%e9%ba%bc%e7%99%a5%e5%85%86%e6%98%af%e5%8f%af%e4%bb%a5%e6%8a%84%e5%ba%95%e7%9a%84%ef%bc%9f/)
> 說明：這個策略是去尋找大跌且近期急跌後，近十個交易日價量背離的股票

input:period(10);

input:times(5);

if close\[1\]\*1.4\<close\[90\]

and close\*1.2\<close\[30\]

and countif(c\>c\[1\]xor v\>v\[1\],period)

\>=times

and close=highest(close,period)

then ret=1;

## 場景 444：大跌後出現什麼癥兆是可以抄底的？ --- 這個腳本是去尋找那些大跌之後，加速趕底後，出現長紅的股票

> 來源：[[大跌後出現什麼癥兆是可以抄底的？]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e5%87%ba%e7%8f%be%e4%bb%80%e9%ba%bc%e7%99%a5%e5%85%86%e6%98%af%e5%8f%af%e4%bb%a5%e6%8a%84%e5%ba%95%e7%9a%84%ef%bc%9f/)
> 說明：這個腳本是去尋找那些大跌之後，加速趕底後，出現長紅的股票

if close\*1.4\<close\[90\]

and close\*1.2\<close\[20\]

then begin

if close\[1\]\*1.05\<close\[2\]

and close\>1.05\*close\[1\]

then ret=1;

end;

## 場景 445：大跌後出現什麼癥兆是可以抄底的？ --- 這是去尋找大跌後，近三天出現至少一根長下影線的股票

> 來源：[[大跌後出現什麼癥兆是可以抄底的？]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e5%87%ba%e7%8f%be%e4%bb%80%e9%ba%bc%e7%99%a5%e5%85%86%e6%98%af%e5%8f%af%e4%bb%a5%e6%8a%84%e5%ba%95%e7%9a%84%ef%bc%9f/)
> 說明：這是去尋找大跌後，近三天出現至少一根長下影線的股票

input: Percent(1.5,\"下影線佔股價絕對百分比\");

settotalbar(5);

condition1 = (minlist(open,close)-Low) \> absvalue(open-close)\*3;

//下影線的長度是實體的三倍以上

condition2 = minlist(open, close) \> low\* (100 + Percent)/100;

if countif( condition1 and condition2, 5)\>=1

and close\[20\]\> close\*1.25

and close\[90\]\>close\*1.4

then ret=1;

## 場景 446：大跌後出現什麼癥兆是可以抄底的？ --- 這個腳本是去尋找大跌且股價很久沒有上漲超過6%的股票

> 來源：[[大跌後出現什麼癥兆是可以抄底的？]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e5%87%ba%e7%8f%be%e4%bb%80%e9%ba%bc%e7%99%a5%e5%85%86%e6%98%af%e5%8f%af%e4%bb%a5%e6%8a%84%e5%ba%95%e7%9a%84%ef%bc%9f/)
> 說明：這個腳本是去尋找大跌且股價很久沒有上漲超過6%的股票

value1=barslast(close\>=close\[1\]\*1.06);

if value1\[1\]\>50

//超過50天沒有單日上漲超過6%

and value1=0

//今天上漲超過6%

and average(volume,100)\>500

and volume\>1000

and close\[1\]\*1.25\<close\[50\]

//過去50天跌幅超過25%

then ret=1;

## 場景 447：大跌後出現什麼癥兆是可以抄底的？ --- 這個腳本是股價大跌後，去尋找股價離低點沒有很遠，且股價近期以來第一次突破月線的標的

> 來源：[[大跌後出現什麼癥兆是可以抄底的？]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%a7%e8%b7%8c%e5%be%8c%e5%87%ba%e7%8f%be%e4%bb%80%e9%ba%bc%e7%99%a5%e5%85%86%e6%98%af%e5%8f%af%e4%bb%a5%e6%8a%84%e5%ba%95%e7%9a%84%ef%bc%9f/)
> 說明：這個腳本是股價大跌後，去尋找股價離低點沒有很遠，且股價近期以來第一次突破月線的標的

input:period(90,\"計算區間\");

value1=highest(high,period);

value2=lowest(low,period);

if value2\*1.3\<value1

and close\<value2\*1.07

and barslast(close cross over average(close,22))=0

and barslast(close cross over average(close,22))\[1\]\>30

then ret=1;

## 場景 448：長線客買賣超張數指標 --- 之前有跟大家聊過關鍵券商，地緣券商，官股券商及前十大綜合券商總公司的意義，這些都是屬於長線的力量，再搭配外資，投信及非套利的自營商買賣超，應該可以代表一檔股票長\...

> 來源：[[長線客買賣超張數指標]{.underline}](https://www.xq.com.tw/xstrader/%e9%95%b7%e7%b7%9a%e5%ae%a2%e8%b2%b7%e8%b3%a3%e8%b6%85%e5%bc%b5%e6%95%b8%e6%8c%87%e6%a8%99/)
> 說明：之前有跟大家聊過關鍵券商，地緣券商，官股券商及前十大綜合券商總公司的意義，這些都是屬於長線的力量，再搭配外資，投信及非套利的自營商買賣超，應該可以代表一檔股票長線的買賣力道，我把這些力量加總起來，組合成一個長線客買賣超張數指標，以下是這個指標的腳本

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

value2=GetField(\"地緣券商買賣超張數\",\"D\");

value3=GetField(\"外資買賣超張數\");

value4=GetField(\"投信買賣超張數\");

value5=GetField(\"自營商自行買賣買賣超\");

value6=GetField(\"官股券商買賣超張數\",\"D\");

value7=GetField(\"綜合前十大券商買賣超張數\",\"D\");

value8=value1+value2+value3+value4+value5+value6+value7;

plot1(value8,\"長線客買賣超張數\");

## 場景 449：長線客買賣超張數指標

> 來源：[[長線客買賣超張數指標]{.underline}](https://www.xq.com.tw/xstrader/%e9%95%b7%e7%b7%9a%e5%ae%a2%e8%b2%b7%e8%b3%a3%e8%b6%85%e5%bc%b5%e6%95%b8%e6%8c%87%e6%a8%99/)
> 說明：我所寫的腳本如下

value1=GetField(\"關鍵券商買賣超張數\",\"D\");

value2=GetField(\"地緣券商買賣超張數\",\"D\");

value3=GetField(\"外資買賣超\",\"D\");

value4=GetField(\"投信買賣超\",\"D\");

value5=GetField(\"自營商自行買賣買賣超\",\"D\");

value6=GetField(\"官股券商買賣超張數\",\"D\");

value7=GetField(\"綜合前十大券商買賣超張數\",\"D\");

value8=value1+value2+value3+value4+value5+value6+value7;

input:ratio(10,\"長線買盤佔百分比\");

if volume\<\>0 then value9=value8/volume\*100;

if value9\>=ratio and volume\>2000

then ret=1;

outputfield(1,value9,2,\"長線買盤佔比\");

## 場景 450：基本面與技術面滲在一起的成長股交易策略 --- 今天來跟大家介紹一個很典型的成長股交易策略，這個策略的概念是當最新一季的營業利益，毛利率及營業利益率都創近幾年來的新高，且技術面出現暴量起漲時就進場買進。大家別\...

> 來源：[[基本面與技術面滲在一起的成長股交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e5%9f%ba%e6%9c%ac%e9%9d%a2%e8%88%87%e6%8a%80%e8%a1%93%e9%9d%a2%e6%bb%b2%e5%9c%a8%e4%b8%80%e8%b5%b7%e7%9a%84%e6%88%90%e9%95%b7%e8%82%a1%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：今天來跟大家介紹一個很典型的成長股交易策略，這個策略的概念是當最新一季的營業利益，毛利率及營業利益率都創近幾年來的新高，且技術面出現暴量起漲時就進場買進。大家別小看這個很老生常談的想法，實際回測下來，這個策略過去五來的勝率快逼近75%，是屬於四戰三勝的夢幻型交易策略。

Input: day(60,\"日期區間\");

Input: ratioLimit(14, \"區間最大漲幅%\");

Condition1 = H=highest(H,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

if Condition1 And Condition2 And Condition3

then ret=1;

## 場景 451：股價距合理價值很遠然後開始暴量起漲 --- 這個策略的選股腳本如下

> 來源：[[股價距合理價值很遠然後開始暴量起漲]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e8%b7%9d%e5%90%88%e7%90%86%e5%83%b9%e5%80%bc%e5%be%88%e9%81%a0%e7%84%b6%e5%be%8c%e9%96%8b%e5%a7%8b%e6%9a%b4%e9%87%8f%e8%b5%b7%e6%bc%b2/)
> 說明：這個策略的選股腳本如下

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

## 場景 452：股價距合理價值很遠然後開始暴量起漲 --- 搭配的盤中洗價腳本如下

> 來源：[[股價距合理價值很遠然後開始暴量起漲]{.underline}](https://www.xq.com.tw/xstrader/%e8%82%a1%e5%83%b9%e8%b7%9d%e5%90%88%e7%90%86%e5%83%b9%e5%80%bc%e5%be%88%e9%81%a0%e7%84%b6%e5%be%8c%e9%96%8b%e5%a7%8b%e6%9a%b4%e9%87%8f%e8%b5%b7%e6%bc%b2/)
> 說明：搭配的盤中洗價腳本如下

Input: day(60,\"日期區間\");

Input: ratioLimit(14, \"區間最大漲幅%\");

Condition1 = H=highest(H,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

if Condition1 And Condition2 And Condition3

then ret=1;

## 場景 453：即將進入季節性多頭的股票 --- 這個選股策略的腳本如下

> 來源：[[即將進入季節性多頭的股票]{.underline}](https://www.xq.com.tw/xstrader/%e5%8d%b3%e5%b0%87%e9%80%b2%e5%85%a5%e5%ad%a3%e7%af%80%e6%80%a7%e5%a4%9a%e9%a0%ad%e7%9a%84%e8%82%a1%e7%a5%a8/)
> 說明：這個選股策略的腳本如下

array:m1\[10\](0);

variable:x(0),count(0);

count=0;

for x=1 to 10

begin

m1\[x\]=(close\[12\*x-1\]-close\[12\*x\]);

if m1\[x\]\>0

then count=count+1;

end;

if count\>=7

then ret=1;

outputfield(1,count,0,\"符合的次數\");

## 場景 454：好公司暴量起漲時 --- 這裡用的還是常用的暴量起漲的腳本

> 來源：[[好公司暴量起漲時]{.underline}](https://www.xq.com.tw/xstrader/%e5%a5%bd%e5%85%ac%e5%8f%b8%e6%9a%b4%e9%87%8f%e8%b5%b7%e6%bc%b2%e6%99%82/)
> 說明：這裡用的還是常用的暴量起漲的腳本

Input: day(60,\"日期區間\");

Input: ratioLimit(14, \"區間最大漲幅%\");

Condition1 = H=highest(H,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

if Condition1 And Condition2 And Condition3

then ret=1;

## 場景 455：創百日新高但距低點不遠 --- 請看一下右上方就是選股條件，其中的選股腳本如下

> 來源：[[創百日新高但距低點不遠]{.underline}](https://www.xq.com.tw/xstrader/%e5%89%b5%e7%99%be%e6%97%a5%e6%96%b0%e9%ab%98%e4%bd%86%e8%b7%9d%e4%bd%8e%e9%bb%9e%e4%b8%8d%e9%81%a0/)
> 說明：請看一下右上方就是選股條件，其中的選股腳本如下

input:day(200,\"計算區間\");

input:day1(20,\"短線漲幅計算區間\");

input:percents(10,\"距離區間最低點漲幅\");

value1=lowest(close,day1-1);

if close=highest(close,day-1)

and value1\*(1+percents/100)\>=high

and high \>= value1\*1.05

and volume \>= average(volume\[1\], 5)

then ret=1;

## 場景 456：產業板塊輪動圖介紹 --- 由於我查了半天也找不到精確的計算公式，所以就自己試寫了一個

> 來源：[[產業板塊輪動圖介紹]{.underline}](https://www.xq.com.tw/xstrader/%e7%94%a2%e6%a5%ad%e6%9d%bf%e5%a1%8a%e8%bc%aa%e5%8b%95%e5%9c%96%e4%bb%8b%e7%b4%b9/)
> 說明：由於我查了半天也找不到精確的計算公式，所以就自己試寫了一個

variable:JDKRS(0);

variable:JDKRSMTM(0);

VALUE1=(rateofchange(close,1)-rateofchange(getsymbolfield(\"TSE.TW\",
\"close\", \"D\"),1))/100;

JDKRS=AVERAGE((1+VALUE1)\*100,14);

JDKRSMTM=momentum(JDKRS,10);

Plot1(JDKRS,\"KDJRS\");

plot2(JDKRSMTM,\"KDJRSMTM\");

plot3(100);

## 場景 457：產業板塊輪動圖介紹 --- 這樣大家可能還看的不是很清楚，所以我另外寫了一個選股腳本

> 來源：[[產業板塊輪動圖介紹]{.underline}](https://www.xq.com.tw/xstrader/%e7%94%a2%e6%a5%ad%e6%9d%bf%e5%a1%8a%e8%bc%aa%e5%8b%95%e5%9c%96%e4%bb%8b%e7%b4%b9/)
> 說明：這樣大家可能還看的不是很清楚，所以我另外寫了一個選股腳本

variable:JDKRS(0);

variable:JDKRSMTM(0);

VALUE1=(rateofchange(close,1)-rateofchange(getsymbolfield(\"TSE.TW\",
\"close\", \"D\"),1))/100;

JDKRS=AVERAGE((1+VALUE1)\*100,14);

JDKRSMTM=momentum(JDKRS,10)\*200;

variable:status(\"\");

if JDKRS\>=100 and JDKRSMTM\>=0 then status=\"領先\"

else

if JDKRS\>=100 and JDKRSMTM\<0 then status=\"轉差\"

else

if JDKRS\<100 and JDKRSMTM\>=0 then status=\"改善\"

else

if JDKRS\<100 and JDKRSMTM\<0 then status=\"落後\";

if status\[1\]=\"改善\"and status=\"領先\" then ret=1;

outputfield(1,status,0,\"今日狀態\");

outputfield(2,status\[1\],0,\"前一日狀態\");

## 場景 458：價值低估股暴量起漲 --- 這裡我用的選股腳本是去尋找過去五年獲利穩定的公司，用目前的營業利益，然後假設未來十年的營業利益年增率及折現用的利率，把未來十年每一年的本業獲利折現，然後加總後加\...

> 來源：[[價值低估股暴量起漲]{.underline}](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e4%bd%8e%e4%bc%b0%e8%82%a1%e6%9a%b4%e9%87%8f%e8%b5%b7%e6%bc%b2/)
> 說明：這裡我用的選股腳本是去尋找過去五年獲利穩定的公司，用目前的營業利益，然後假設未來十年的營業利益年增率及折現用的利率，把未來十年每一年的本業獲利折現，然後加總後加上淨值，再看看這個數字跟目前股價的比值，如果比值低於一，那就代表股價被低估。

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

## 場景 459：價值低估股暴量起漲

> 來源：[[價值低估股暴量起漲]{.underline}](https://www.xq.com.tw/xstrader/%e5%83%b9%e5%80%bc%e4%bd%8e%e4%bc%b0%e8%82%a1%e6%9a%b4%e9%87%8f%e8%b5%b7%e6%bc%b2/)

Input: day(60,\"日期區間\");

Input: ratioLimit(14, \"區間最大漲幅%\");

Condition1 = H=highest(H,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

if Condition1 And Condition2 And Condition3

then ret=1;

## 場景 460：籌碼面交易策略之投信動真格的 --- 接下來跟大家分享相關的腳本及回測報告

> 來源：[[籌碼面交易策略之投信動真格的]{.underline}](https://www.xq.com.tw/xstrader/%e7%b1%8c%e7%a2%bc%e9%9d%a2%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%b9%8b%e6%8a%95%e4%bf%a1%e5%8b%95%e7%9c%9f%e6%a0%bc%e7%9a%84/)
> 說明：接下來跟大家分享相關的腳本及回測報告

value1=GetField(\"投信買賣超\",\"D\");

if value1 \<=0

then value2=0

else

value2=value2\[1\]+value1;

value3=close\*value2/10;//單位:萬元

if value3 crosses over 10000

and close\<100

then ret=1;

## 場景 461：籌碼面交易策略之投信動真格的

> 來源：[[籌碼面交易策略之投信動真格的]{.underline}](https://www.xq.com.tw/xstrader/%e7%b1%8c%e7%a2%bc%e9%9d%a2%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e4%b9%8b%e6%8a%95%e4%bf%a1%e5%8b%95%e7%9c%9f%e6%a0%bc%e7%9a%84/)

input:period(5);

if close crosses over average(close,period)

then ret=1;

## 場景 462：地緣券商買超的交易策略 --- 這裡用的是系統內建的地緣券商買賣超張數這個欄位，這裡所謂的地緣券商定義，是以個股總公司為圓心, 找出位在公司附近的券商分點, 預設的半徑為3公里 , 如果距離總\...

> 來源：[[地緣券商買超的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%b0%e7%b7%a3%e5%88%b8%e5%95%86%e8%b2%b7%e8%b6%85%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：這裡用的是系統內建的地緣券商買賣超張數這個欄位，這裡所謂的地緣券商定義，是以個股總公司為圓心,
> 找出位在公司附近的券商分點, 預設的半徑為3公里 ,
> 如果距離總公司小於3公里的券商分點家數超過30家, 距離改為1 KM, 反之,
> 若券商分點家數為0, 距離改為10 KM; 符合上述條件分點,扣除外資券商，
> 即列為此個股的地緣券商。

value1=GetField(\"地緣券商買賣超張數\",\"D\");

if trueall(value1\>200,3)

then ret=1;

## 場景 463：地緣券商買超的交易策略

> 來源：[[地緣券商買超的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e5%9c%b0%e7%b7%a3%e5%88%b8%e5%95%86%e8%b2%b7%e8%b6%85%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)

input: Shortlength(3); setinputname(1,\"短期均線期數\");

input: Longlength(10); setinputname(2,\"長期均線期數\");

settotalbar(8);

setbarback(maxlist(Shortlength,Longlength,6));

If Average(Close,Shortlength) crosses over Average(Close,Longlength)
then Ret=1;

## 場景 464：PB接近十年低點後的均線黃金交叉 --- 如果股價淨值比接近十年低點，通常有兩種情況，一種是底部到了大股東的最後防線，另一種則是公司的基本面在惡化中，這時候如果三日均線能突破十日均線，那麼第一種的機率會\...

> 來源：[[PB接近十年低點後的均線黃金交叉]{.underline}](https://www.xq.com.tw/xstrader/pb%e6%8e%a5%e8%bf%91%e5%8d%81%e5%b9%b4%e4%bd%8e%e9%bb%9e%e5%be%8c%e7%9a%84%e5%9d%87%e7%b7%9a%e9%bb%83%e9%87%91%e4%ba%a4%e5%8f%89/)
> 說明：如果股價淨值比接近十年低點，通常有兩種情況，一種是底部到了大股東的最後防線，另一種則是公司的基本面在惡化中，這時候如果三日均線能突破十日均線，那麼第一種的機率會高一些。於是，我找出PB接近十年低點的股票，然後在三日均線如果突破十日均線時進場，停損停利都設為7%，回測的結果發現，這樣的交易策略，有很不錯的勝率，而且風險也不高，今天就介紹給大家。

input:r1(10); setinputname(1,\"PB距離N個月來低點只剩N%\");

input:r2(60); setinputname(2,\"N個月以來\");

//input:TXT(\"僅適用月資料\"); setinputname(3,\"使用限制\");

setbarfreq(\"M\");

if barfreq \<\> \"M\" then raiseruntimeerror(\"頻率錯誤\");

value1=GetField(\"股價淨值比\",\"M\");

value2=lowest(GetField(\"股價淨值比\",\"M\"),r2);

value3=average(GetField(\"股價淨值比\",\"M\"),r2);

if value1 \< value3 and value1 \< value2\*(1+r1/100)

and close cross over average(close,10)

then ret=1;

setoutputname1(\"股價淨值比\");

outputfield1(value1);

## 場景 465：PB接近十年低點後的均線黃金交叉 --- 至於警示腳本，則是使用3日均線突破10日均線。

> 來源：[[PB接近十年低點後的均線黃金交叉]{.underline}](https://www.xq.com.tw/xstrader/pb%e6%8e%a5%e8%bf%91%e5%8d%81%e5%b9%b4%e4%bd%8e%e9%bb%9e%e5%be%8c%e7%9a%84%e5%9d%87%e7%b7%9a%e9%bb%83%e9%87%91%e4%ba%a4%e5%8f%89/)
> 說明：至於警示腳本，則是使用3日均線突破10日均線。

input: Shortlength(3); setinputname(1,\"短期均線期數\");

input: Longlength(10); setinputname(2,\"長期均線期數\");

settotalbar(8);

setbarback(maxlist(Shortlength,Longlength,6));

If Average(Close,Shortlength) crosses over Average(Close,Longlength)
then Ret=1;

## 場景 466：外資喜歡的股票又開始連續買超 --- 所以今天來跟大家介紹一個跟外資相關的交易策略，接下來也來陸續介紹這一類的交易策略。

> 來源：[[外資喜歡的股票又開始連續買超]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%96%e8%b3%87%e5%96%9c%e6%ad%a1%e7%9a%84%e8%82%a1%e7%a5%a8%e5%8f%88%e9%96%8b%e5%a7%8b%e9%80%a3%e7%ba%8c%e8%b2%b7%e8%b6%85/)
> 說明：所以今天來跟大家介紹一個跟外資相關的交易策略，接下來也來陸續介紹這一類的交易策略。

value1=GetField(\"外資買賣超\");

value2=GetField(\"外資持股比例\");

if value2\>10

and trueall(value1\>500,3)

and barslast(trueall(value1\>1000,3))\[1\]\>20

then ret=1;

## 場景 467：外資喜歡的股票又開始連續買超 --- 這個腳本是在尋找外資持股比例超過一成，最近三天外資買超都超過五百張，且上一次發生這樣的情況已經是20天前

> 來源：[[外資喜歡的股票又開始連續買超]{.underline}](https://www.xq.com.tw/xstrader/%e5%a4%96%e8%b3%87%e5%96%9c%e6%ad%a1%e7%9a%84%e8%82%a1%e7%a5%a8%e5%8f%88%e9%96%8b%e5%a7%8b%e9%80%a3%e7%ba%8c%e8%b2%b7%e8%b6%85/)
> 說明：這個腳本是在尋找外資持股比例超過一成，最近三天外資買超都超過五百張，且上一次發生這樣的情況已經是20天前

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

## 場景 468：盈餘成長比營收成長幅度高的公司 --- 下面就跟大家分享要完成這樣的策略雷達，所要使用的選股及警示策略

> 來源：[[盈餘成長比營收成長幅度高的公司]{.underline}](https://www.xq.com.tw/xstrader/s10/)
> 說明：下面就跟大家分享要完成這樣的策略雷達，所要使用的選股及警示策略

condition1=false;

value1=GetField(\"營收成長率\",\"Y\");

value2=GetField(\"稅後淨利成長率\",\"y\");

value3=GetField(\"本期稅後淨利\",\"Y\");//單位:百萬

if value1\>0//年營收是成長的

and value2\>0//年盈餘也是成長的

and value2\>value1

//盈餘成長率大於營收成長率

then condition1=true;

if countif(condition1,5)\>=3

//過去五年至少3年符合上述情形

and value3\>200

//年稅後淨利超過2億元

then ret=1;

## 場景 469：盈餘成長比營收成長幅度高的公司

> 來源：[[盈餘成長比營收成長幅度高的公司]{.underline}](https://www.xq.com.tw/xstrader/s10/)

Input: day(60,\"日期區間\");

Input: ratioLimit(14, \"區間最大漲幅%\");

Condition1 = H=highest(H,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

if Condition1 And Condition2 And Condition3

then ret=1;

## 場景 470：營運好轉的好公司暴量起漲 --- 其中最後一項是用選股腳本寫的，腳本如下

> 來源：[[營運好轉的好公司暴量起漲]{.underline}](https://www.xq.com.tw/xstrader/s9/)
> 說明：其中最後一項是用選股腳本寫的，腳本如下

settotalbar(3);

value1=GetField(\"來自營運之現金流量\",\"Q\");

value2=GetField(\"本期稅後淨利\",\"Q\");

if value1 \> value2

then ret=1;

## 場景 471：營運好轉的好公司暴量起漲

> 來源：[[營運好轉的好公司暴量起漲]{.underline}](https://www.xq.com.tw/xstrader/s9/)

Input: day(60,\"日期區間\");

Input: ratioLimit(14, \"區間最大漲幅%\");

Condition1 = H=highest(H,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

if Condition1 And Condition2 And Condition3

then ret=1;

## 場景 472：毛利率在成長的非熱門股

> 來源：[[毛利率在成長的非熱門股]{.underline}](https://www.xq.com.tw/xstrader/s8/)
> 說明：我使用的選股條件如下

Input: day(60,\"日期區間\");

Input: ratioLimit(14, \"區間最大漲幅%\");

Condition1 = H=highest(H,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

if Condition1 And Condition2 And Condition3

then ret=1;

## 場景 473：高殖利率股週線突破月線 --- 這個選股腳本就是挑殖利率還有5%，過去五年每年股利都有超過兩元的，而且今年以來累計營收年增率還很強的。

> 來源：[[高殖利率股週線突破月線]{.underline}](https://www.xq.com.tw/xstrader/s6/)
> 說明：這個選股腳本就是挑殖利率還有5%，過去五年每年股利都有超過兩元的，而且今年以來累計營收年增率還很強的。

input: Shortlength(5); setinputname(1,\"短期均線期數\");

input: Longlength(20); setinputname(2,\"長期均線期數\");

settotalbar(8);

setbarback(maxlist(Shortlength,Longlength,6));

If Average(Close,Shortlength) crosses over Average(Close,Longlength)
then Ret=1;

## 場景 474：用系統內建價值衡量數據所衍生出來的交易策略 --- 先前介紹過一個本益比低於10及市值營收比低於150%的價值型投資策略，有網友問到價值型投資的衡量工具很多，比較實用的有那些？ 今天我想跟大家分享一個用PE，PB\...

> 來源：[[用系統內建價值衡量數據所衍生出來的交易策略]{.underline}](https://www.xq.com.tw/xstrader/s5/)
> 說明：先前介紹過一個本益比低於10及市值營收比低於150%的價值型投資策略，有網友問到價值型投資的衡量工具很多，比較實用的有那些？
> 今天我想跟大家分享一個用PE，PB，殖利率綜合建構的交易策略。

if GetField(\"本益比\",\"D\") \< 10 and

GetField(\"股價淨值比\",\"D\") \<1.5 and

GetField(\"殖利率\",\"D\") \> 5 and

GetField(\"營收成長率\",\"Q\") \>0

then ret=1;

## 場景 475：用系統內建價值衡量數據所衍生出來的交易策略 --- 這個選股策略是找出殖利率大於5%，而且本益比低於10且PB小於1.5但季的營收成長率還是向上的股票。

> 來源：[[用系統內建價值衡量數據所衍生出來的交易策略]{.underline}](https://www.xq.com.tw/xstrader/s5/)
> 說明：這個選股策略是找出殖利率大於5%，而且本益比低於10且PB小於1.5但季的營收成長率還是向上的股票。

Input: day(60,\"日期區間\");

Input: ratioLimit(14, \"區間最大漲幅%\");

Condition1 = H=highest(H,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

if Condition1 And Condition2 And Condition3

then ret=1;

## 場景 476：大股票的交易策略

> 來源：[[大股票的交易策略]{.underline}](https://www.xq.com.tw/xstrader/s4/)
> 說明：警示腳本如下

variable:iHigh(0); iHigh=maxlist(iHigh,H);

variable:iLow(100000); iLow=minlist(iLow,L);

variable:hitlow(0),hitlowdate(0);

if iLow = Low then

begin

hitlow+=1;

hitlowdate =date;

//觸低次數與最後一次觸低日期

end;

if DateAdd(hitlowdate,\"M\",2) \< Date
and//如果自觸低點那天1個月後都沒有再觸低

iHigh/iLow \< 1.3 and //波動在三成以內

iHigh = High

//來到設定日期以來最高點

and average(volume,100)\>500

and volume\>1000

//有一定的成交量

then ret =1;

## 場景 477：當好公司無量變有量就是好的進場時機

> 來源：[[當好公司無量變有量就是好的進場時機]{.underline}](https://www.xq.com.tw/xstrader/s3/)
> 說明：好公司的選股腳本

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

## 場景 478：當好公司無量變有量就是好的進場時機

> 來源：[[當好公司無量變有量就是好的進場時機]{.underline}](https://www.xq.com.tw/xstrader/s3/)
> 說明：無量變有量的警示腳本

Input: day(60,\"日期區間\");

Input: ratioLimit(14, \"區間最大漲幅%\");

Condition1 = H=highest(H,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

if Condition1 And Condition2 And Condition3

then ret=1;

## 場景 479：尋找代操資金在佈局的交易策略

> 來源：[[尋找代操資金在佈局的交易策略]{.underline}](https://www.xq.com.tw/xstrader/s2/)
> 說明：代操看上的股票

value1=GetField(\"綜合前十大券商買賣超張數\",\"D\");

value2=value1\*close/10;//成交值單位萬元

if trueall(value2\>2000,3)

and value2\>10000

and close cross over average(close,10)

then ret=1;

## 場景 480：尋找代操資金在佈局的交易策略 --- EPS N年內至少有一年看到四元

> 來源：[[尋找代操資金在佈局的交易策略]{.underline}](https://www.xq.com.tw/xstrader/s2/)
> 說明：EPS N年內至少有一年看到四元

input:a3(4,\"EPS曾經到過的高點\");

value1=GetField(\"每股稅後淨利(元)\",\"Y\");

if trueany(value1\>a3,7)

then ret=1;

## 場景 481：尋找代操資金在佈局的交易策略 --- 選股的腳本可以修改如下

> 來源：[[尋找代操資金在佈局的交易策略]{.underline}](https://www.xq.com.tw/xstrader/s2/)
> 說明：選股的腳本可以修改如下

input:a3(4,\"EPS曾經到過的高點\");

value1=GetField(\"綜合前十大券商買賣超張數\",\"D\");

value2=value1\*close/10;//成交值單位萬元

value3=GetField(\"每股稅後淨利(元)\",\"Y\");

if trueany(value3\>a3,7)

and trueall(value2\>2000,3)

and value2\>10000

then ret=1;

## 場景 482：高勝率價值型交易策略 --- 我用的是暴量起漲股的腳本

> 來源：[[高勝率價值型交易策略]{.underline}](https://www.xq.com.tw/xstrader/s1/)
> 說明：我用的是暴量起漲股的腳本

Input: day(10,\"日期區間\");

Input: ratioLimit(5, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 483：從基本面出發的交易策略\~ 十年寒窗股 --- 這部份我用的是暴量剛起漲這個腳本

> 來源：[[從基本面出發的交易策略\~
> 十年寒窗股]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%9e%e5%9f%ba%e6%9c%ac%e9%9d%a2%e5%87%ba%e7%99%bc%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5-%e5%8d%81%e5%b9%b4%e5%af%92%e7%aa%97%e8%82%a1/)
> 說明：這部份我用的是暴量剛起漲這個腳本

Input: day(60,\"日期區間\");

Input: ratioLimit(14, \"區間最大漲幅%\");

Condition1 = H=highest(H,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

if Condition1 And Condition2 And Condition3

then ret=1;

## 場景 484：一個關於千張大戶的交易策略 --- 這個短期均線突破長期均線的腳本如下

> 來源：[[一個關於千張大戶的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%80%e5%80%8b%e9%97%9c%e6%96%bc%e5%8d%83%e5%bc%b5%e5%a4%a7%e6%88%b6%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：這個短期均線突破長期均線的腳本如下

input: Shortlength(2); setinputname(1,\"短期均線期數\");

input: Longlength(10); setinputname(2,\"長期均線期數\");

settotalbar(8);

setbarback(maxlist(Shortlength,Longlength,6));

If Average(Close,Shortlength) crosses over Average(Close,Longlength)
then Ret=1;

## 場景 485：高週轉率高勝率穩定報酬交易策略系列介紹之二: 布林交易法則

> 來源：[[高週轉率高勝率穩定報酬交易策略系列介紹之二:
> 布林交易法則]{.underline}](https://www.xq.com.tw/xstrader/bl2/)
> 說明：K棒突破布林值上緣

Input: Length(20), UpperBand(2);

SetInputName(1, \"期數\");

SetInputName(2, \"通道上緣\");

settotalbar(3);

Ret = close \>= bollingerband(Close, Length, UpperBand);

## 場景 486：高週轉率高勝率穩定報酬交易策略系列介紹之二: 布林交易法則

> 來源：[[高週轉率高勝率穩定報酬交易策略系列介紹之二:
> 布林交易法則]{.underline}](https://www.xq.com.tw/xstrader/bl2/)
> 說明：布林值帶寬小於N

input:length(20,\"計算天期\");

input:width(3,\"帶寬%\");

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 = bollingerband(Close, Length, 1);

down1 = bollingerband(Close, Length, -1 );

mid1 = (up1 + down1) / 2;

bbandwidth = 100 \* (up1 - down1) / mid1;

if bbandwidth \<width

then ret=1;

## 場景 487：高週轉率高勝率穩定報酬交易策略系列介紹之二: 布林交易法則 --- 至於雷達的觸發策略，則是用股價創20日新高這個腳本

> 來源：[[高週轉率高勝率穩定報酬交易策略系列介紹之二:
> 布林交易法則]{.underline}](https://www.xq.com.tw/xstrader/bl2/)
> 說明：至於雷達的觸發策略，則是用股價創20日新高這個腳本

if close=highest(close,20)

then ret=1;

## 場景 488：一個高週轉率且穩定獲利的交易策略 --- 其中本業推估本益比低的選股腳本如下

> 來源：[[一個高週轉率且穩定獲利的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%80%e5%80%8b%e9%ab%98%e9%80%b1%e8%bd%89%e7%8e%87%e4%b8%94%e7%a9%a9%e5%ae%9a%e7%8d%b2%e5%88%a9%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：其中本業推估本益比低的選股腳本如下

input:peuplimit(12,\"預估本益比上限\");

value3= summation(GetField(\"營業利益\",\"Q\"),4); //單位百萬;

value4= GetField(\"最新股本\");//單位億;

value5= value3/(value4\*10);//每股預估EPS

if value5\>0 and close/value5\<=peuplimit

then ret=1;

## 場景 489：一個高週轉率且穩定獲利的交易策略 --- 第二部份的盤中觸發策略，其腳本如下

> 來源：[[一個高週轉率且穩定獲利的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%80%e5%80%8b%e9%ab%98%e9%80%b1%e8%bd%89%e7%8e%87%e4%b8%94%e7%a9%a9%e5%ae%9a%e7%8d%b2%e5%88%a9%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：第二部份的盤中觸發策略，其腳本如下

input:period(100,\"計算天數\");

value1=highest(high,period);

value2=highest(volume,period);

if high=value1 and volume=value2

then ret=1;

## 場景 490：一個長期維持七成以上勝率的交易策略\~高護城河股暴量起漲 --- 每天在策略雷達用以下的腳本來跑這個選股策略選出來的股票

> 來源：[[一個長期維持七成以上勝率的交易策略\~高護城河股暴量起漲]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%80%e5%80%8b%e9%95%b7%e6%9c%9f%e7%b6%ad%e6%8c%81%e4%b8%83%e6%88%90%e4%bb%a5%e4%b8%8a%e5%8b%9d%e7%8e%87%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%e9%ab%98%e8%ad%b7%e5%9f%8e%e6%b2%b3%e8%82%a1/)
> 說明：每天在策略雷達用以下的腳本來跑這個選股策略選出來的股票

Input: day(60,\"日期區間\");

Input: ratioLimit(14, \"區間最大漲幅%\");

Condition1 = H=highest(H,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

if Condition1 And Condition2 And Condition3

then ret=1;

## 場景 491：基本面投資策略系列之二： 股價夠低估的股票暴量起漲 --- 低本益比低PB高殖利率

> 來源：[[基本面投資策略系列之二：
> 股價夠低估的股票暴量起漲]{.underline}](https://www.xq.com.tw/xstrader/%e5%9f%ba%e6%9c%ac%e9%9d%a2%e6%8a%95%e8%b3%87%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b%e4%ba%8c%ef%bc%9a-%e8%82%a1%e5%83%b9%e5%a4%a0%e4%bd%8e%e4%bc%b0%e7%9a%84%e8%82%a1%e7%a5%a8%e6%9a%b4%e9%87%8f/)
> 說明：低本益比低PB高殖利率

{本益比小於 15 倍 股價淨值比小於 2 倍 殖利率大於 3%}

if GetField(\"本益比\",\"D\") \< 10 and

GetField(\"股價淨值比\",\"D\") \<1.5 and

GetField(\"殖利率\",\"D\") \> 5 and

GetField(\"營收成長率\",\"Q\") \>0

then ret=1;

## 場景 492：基本面投資策略系列之二： 股價夠低估的股票暴量起漲

> 來源：[[基本面投資策略系列之二：
> 股價夠低估的股票暴量起漲]{.underline}](https://www.xq.com.tw/xstrader/%e5%9f%ba%e6%9c%ac%e9%9d%a2%e6%8a%95%e8%b3%87%e7%ad%96%e7%95%a5%e7%b3%bb%e5%88%97%e4%b9%8b%e4%ba%8c%ef%bc%9a-%e8%82%a1%e5%83%b9%e5%a4%a0%e4%bd%8e%e4%bc%b0%e7%9a%84%e8%82%a1%e7%a5%a8%e6%9a%b4%e9%87%8f/)

Input: day(10,\"日期區間\");

Input: ratioLimit(5, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 493：基本面投資策略系列之一 --- 這個策略是用來尋找那些過往現金股利都有一定水準，但股價目前跟其現金股利水準相比，明顯估值偏低的中小型股，其中股價低於N年平均股利的N倍這個條件的腳本如下

> 來源：[[基本面投資策略系列之一]{.underline}](https://www.xq.com.tw/xstrader/%e5%9f%ba%e6%9c%ac%e9%9d%a2%e6%8a%95%e8%b3%87%e7%ad%96%e7%95%a5%e4%b9%8b%e4%b8%80/)
> 說明：這個策略是用來尋找那些過往現金股利都有一定水準，但股價目前跟其現金股利水準相比，明顯估值偏低的中小型股，其中股價低於N年平均股利的N倍這個條件的腳本如下

input:N1(5);

input:N2(16);

setinputname(1,\"股利平均的年數\");

setinputname(2,\"股利的倍數\");

value1=GetField(\"股利合計\",\"Y\");

value2=average(value1,N1);

if close\<value2\*N2

then ret=1;

## 場景 494：基本面投資策略系列之一

> 來源：[[基本面投資策略系列之一]{.underline}](https://www.xq.com.tw/xstrader/%e5%9f%ba%e6%9c%ac%e9%9d%a2%e6%8a%95%e8%b3%87%e7%ad%96%e7%95%a5%e4%b9%8b%e4%b8%80/)
> 說明：暴量剛起漲的腳本如下

Input: day(10,\"日期區間\");

Input: ratioLimit(5, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 495：飆股的長相如何寫成選股程式 --- 我寫了幾個，都沒有把其中的精神寫的很精準，後來請公司的高手出馬，寫了一個腳本如下

> 來源：[[飆股的長相如何寫成選股程式]{.underline}](https://www.xq.com.tw/xstrader/%e9%a3%86%e8%82%a1%e7%9a%84%e9%95%b7%e7%9b%b8/)
> 說明：我寫了幾個，都沒有把其中的精神寫的很精準，後來請公司的高手出馬，寫了一個腳本如下

settotalbar(30);

array:attack\[10\](0);

variable:i(1);

stochastic(9,3,3,value1,value2,value3);

//計算KD

condition1=value2\>value3;

//K\>D的時候

if H\>value4 and condition1

//K\>D的時候且創新高(抓高點)

then begin

value4=H;

attack\[1\]=value4;

end;

if condition1\[1\] and not condition1

//KD死亡交叉的時候統計攻頂的戰果

then begin

for i=10 downto 2 attack\[i\]=attack\[i-1\];

//在陣列中依序發生順序向後排

value4=0;

end;

///////////////

value5=attack\[1\];

value6=attack\[1\];

for i=2 to 4

begin

if attack\[i\]\>value5 then value5=attack\[i\];

if attack\[i\]\<value6 and attack\[i\]\>0 then value6=attack\[i\];

end;

//////////////最近5次攻頂戰果的最高與最低

if value6\>0 then value7=value5/value6-1;

condition2=value7\<0.05;

///攻頂戰果最高與最低不超過5%

if condition2\[1\] and not condition2 and H\>attack\[2\]

and volume\>2000

and GetField(\"主力買賣超張數\",\"D\")\>2000

and GetField(\"法人買賣超張數\",\"D\")\>1000

then ret=1;

///脫離攻頂戰果5%的區間而且本次還創攻頂戰果的新高

## 場景 496：與本土法人相關的交易策略 --- 一，中小型股投信初介入

> 來源：[[與本土法人相關的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e8%88%87%e6%9c%ac%e5%9c%9f%e6%b3%95%e4%ba%ba%e7%9b%b8%e9%97%9c%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：一，中小型股投信初介入

settotalbar(130);

setbarback(65);

value1=GetField(\"股本(億)\",\"D\");

condition1 = GetField(\"投信持股\")\[1\]\<=1000

and getField(\"投信買賣超\")\[1\]=0;

if H\>H\[1\]

and TrueAll(condition1\[1\],60)

and GetField(\"投信買賣超\")\[1\]\*C\>1000

and value1\<30

then ret=1;

## 場景 497：與本土法人相關的交易策略 --- 二，投信會買的股票出現籌碼收集的現象

> 來源：[[與本土法人相關的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e8%88%87%e6%9c%ac%e5%9c%9f%e6%b3%95%e4%ba%ba%e7%9b%b8%e9%97%9c%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：二，投信會買的股票出現籌碼收集的現象

condition1=false;

value1=GetField(\"分公司買進家數\");

value2=GetField(\"分公司賣出家數\");

value3=value2-value1;

value4=countif(value3\>20,10);

value5=GetField(\"投信買張\");

value6=summation(value5,5);

if countif(value6\>=2000,300)\>=1

then condition1=true;

//過去300個交易日投信曾五天買超過2000張

if value4\>=6

//最近十天有六天以上，籌碼是收集的

and close\[30\]\>close\*1.1

//最近三十天跌超過一成

and condition1

then ret=1;

## 場景 498：與本土法人相關的交易策略 --- 三，主力與投信共襄盛舉

> 來源：[[與本土法人相關的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e8%88%87%e6%9c%ac%e5%9c%9f%e6%b3%95%e4%ba%ba%e7%9b%b8%e9%97%9c%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：三，主力與投信共襄盛舉

value1=GetField(\"主力買張\");

value2=GetField(\"投信買張\");

value3=GetField(\"投信買賣超張數\");

value4=GetField(\"投信持股比例\");

value5=GetField(\"股本(億)\",\"D\");

if value4\<5

//投信持股比例不到5%

and value1\>value2+1000

//主力買進張數大於投信買進張數一千張

and value3\>1000

//投信買超大於1000張

and value5\<50

//股本小於50億

then ret=1;

## 場景 499：與本土法人相關的交易策略 --- 四，投信很久沒買，現在買超

> 來源：[[與本土法人相關的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e8%88%87%e6%9c%ac%e5%9c%9f%e6%b3%95%e4%ba%ba%e7%9b%b8%e9%97%9c%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：四，投信很久沒買，現在買超

input:day(20,\"連續沒有買超的天數\");

value1=GetField(\"投信買賣超\",\"D\");

if trueall(value1\[1\]\<=0,day)

and value1\>500

then ret=1;

## 場景 500：與本土法人相關的交易策略 --- 五，投信買超且突破其成本

> 來源：[[與本土法人相關的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e8%88%87%e6%9c%ac%e5%9c%9f%e6%b3%95%e4%ba%ba%e7%9b%b8%e9%97%9c%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：五，投信買超且突破其成本

value1=GetField(\"投信成本\",\"D\");

value2=GetField(\"投信買賣超\",\"D\");

if close cross over value1

and value2 \>300

then ret=1;

## 場景 501：平均年報酬率一年兩成的價值型投資皮氏選股法 --- 其中包含了兩個選股腳本，一個是暴量剛起漲，

> 來源：[[平均年報酬率一年兩成的價值型投資皮氏選股法]{.underline}](https://www.xq.com.tw/xstrader/%e5%b9%b3%e5%9d%87%e5%b9%b4%e5%a0%b1%e9%85%ac%e7%8e%87%e4%b8%80%e5%b9%b4%e5%85%a9%e6%88%90%e7%9a%84%e5%83%b9%e5%80%bc%e5%9e%8b%e6%8a%95%e8%b3%87%e7%9a%ae%e6%b0%8f%e9%81%b8%e8%82%a1%e6%b3%95/)
> 說明：其中包含了兩個選股腳本，一個是暴量剛起漲，

Input: day(10,\"日期區間\");

Input: ratioLimit(5, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 502：平均年報酬率一年兩成的價值型投資皮氏選股法 --- 一個是營運現金流大於稅後盈餘

> 來源：[[平均年報酬率一年兩成的價值型投資皮氏選股法]{.underline}](https://www.xq.com.tw/xstrader/%e5%b9%b3%e5%9d%87%e5%b9%b4%e5%a0%b1%e9%85%ac%e7%8e%87%e4%b8%80%e5%b9%b4%e5%85%a9%e6%88%90%e7%9a%84%e5%83%b9%e5%80%bc%e5%9e%8b%e6%8a%95%e8%b3%87%e7%9a%ae%e6%b0%8f%e9%81%b8%e8%82%a1%e6%b3%95/)
> 說明：一個是營運現金流大於稅後盈餘

settotalbar(3);

value1=GetField(\"來自營運之現金流量\",\"Q\");

value2=GetField(\"本期稅後淨利\",\"Q\");

if value1 \> value2

then ret=1;

## 場景 503：老師父賺很大的獨門絕學 --- 我根據他的想法，寫了以下的腳本

> 來源：[[老師父賺很大的獨門絕學]{.underline}](https://www.xq.com.tw/xstrader/%e8%80%81%e5%b8%ab%e7%88%b6%e8%b3%ba%e5%be%88%e5%a4%a7%e7%9a%84%e7%8d%a8%e9%96%80%e7%b5%95%e5%ad%b8/)
> 說明：我根據他的想法，寫了以下的腳本

settotalbar(400);

value1=GetField(\"強弱指標\",\"D\");

value2=GetField(\"股本(億)\",\"D\");

value3=GetField(\"主力買賣超張數\");

if high=highest(high,400)

and value1\>0

and volume\>2000

and value2\<100

and close\>30

and trueall(value3\>0,5)

then ret=1;

## 場景 504：每年平均獲利三成\~ 麥克貝瑞選股法

> 來源：[[每年平均獲利三成\~
> 麥克貝瑞選股法]{.underline}](https://www.xq.com.tw/xstrader/%e6%af%8f%e5%b9%b4%e5%b9%b3%e5%9d%87%e7%8d%b2%e5%88%a9%e4%b8%89%e6%88%90-%e9%ba%a5%e5%85%8b%e8%b2%9d%e7%91%9e%e9%81%b8%e8%82%a1%e6%b3%95/)
> 說明：本業推估本益比低於N

input:peuplimit(12,\"預估本益比上限\");

value3= summation(GetField(\"營業利益\",\"Q\"),4); //單位百萬;

value4= GetField(\"最新股本\");//單位億;

value5= value3/(value4\*10);//每股預估EPS

if value5\>0 and close/value5\<=peuplimit

then ret=1;

## 場景 505：每年平均獲利三成\~ 麥克貝瑞選股法

> 來源：[[每年平均獲利三成\~
> 麥克貝瑞選股法]{.underline}](https://www.xq.com.tw/xstrader/%e6%af%8f%e5%b9%b4%e5%b9%b3%e5%9d%87%e7%8d%b2%e5%88%a9%e4%b8%89%e6%88%90-%e9%ba%a5%e5%85%8b%e8%b2%9d%e7%91%9e%e9%81%b8%e8%82%a1%e6%b3%95/)
> 說明：價量同步創N期新高

input:period(30,\"計算天數\");

value1=highest(high,period);

value2=highest(volume,period);

if high=value1 and volume=value2

then ret=1;

## 場景 506：如何把分享的腳本變成實戰用的交易策略？ --- 我舉的策略雷達腳本如下

> 來源：[[如何把分享的腳本變成實戰用的交易策略？]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e6%8a%8a%e5%88%86%e4%ba%ab%e7%9a%84%e8%85%b3%e6%9c%ac%e8%ae%8a%e6%88%90%e5%af%a6%e6%88%b0%e7%94%a8%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5%ef%bc%9f/)
> 說明：我舉的策略雷達腳本如下

if momentum(close,10) crosses over 0

//動能指標突破零

and GetField(\"投信買賣超\")\>1000

//投信買超突破1000張

and barslast(GetField(\"投信買賣超\")\>1000 )\[1\]\>10

//近十日投信都沒有這麼大買超

and close \> average(close,5)

//股價站在週線之上

then ret=1;

## 場景 507：主力與投信共襄盛舉的交易策略 --- 根據這樣的邏輯，我寫了一個腳本如下：

> 來源：[[主力與投信共襄盛舉的交易策略]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%bb%e5%8a%9b%e8%88%87%e6%8a%95%e4%bf%a1%e5%85%b1%e8%a5%84%e7%9b%9b%e8%88%89%e7%9a%84%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/)
> 說明：根據這樣的邏輯，我寫了一個腳本如下：

value1=GetField(\"主力買張\");

value2=GetField(\"投信買張\");

value3=GetField(\"投信買賣超張數\");

value4=GetField(\"投信持股比例\");

value5=GetField(\"股本(億)\",\"D\");

if value4\<5

//投信持股比例不到5%

and value1\>value2+1000

//主力買進張數大於投信買進張數一千張

and value3\>1000

//投信買超大於1000張

and value5\<50

//股本小於50億

then ret=1;

## 場景 508：我尋找潛力股的方法之二\~ 自由現金流穩定的公司股價夠低 --- 一個是自由現金流量過去n年每年都超過m億元

> 來源：[[我尋找潛力股的方法之二\~
> 自由現金流穩定的公司股價夠低]{.underline}](https://www.xq.com.tw/xstrader/value1/)
> 說明：一個是自由現金流量過去n年每年都超過m億元

value1=GetField(\"來自營運之現金流量\",\"Y\");//單位百萬

value2=GetField(\"資本支出金額\",\"Y\");//單位百萬

value3=GetField(\"利息支出\",\"Y\");//單位百萬

value4=GetField(\"所得稅費用\",\"Y\");//單位百萬

value5=value1-value2-value3-value4;//自由現金流量

input:lm(1,\"自由現金流量下限，單位億元\");

input:years(8,\"符合條件年數\");

if trueall(value5\>=lm,years) then ret=1;

## 場景 509：我尋找潛力股的方法之二\~ 自由現金流穩定的公司股價夠低 --- 另一個則是股價每股自由現金流量比低於一定值

> 來源：[[我尋找潛力股的方法之二\~
> 自由現金流穩定的公司股價夠低]{.underline}](https://www.xq.com.tw/xstrader/value1/)
> 說明：另一個則是股價每股自由現金流量比低於一定值

value1=GetField(\"來自營運之現金流量\",\"Q\");//單位百萬

value2=GetField(\"資本支出金額\",\"Q\");//單位百萬

value3=GetField(\"利息支出\",\"Q\");//單位百萬

value4=GetField(\"所得稅費用\",\"Q\");//單位百萬

value5=value1-value2-value3-value4;//自由現金流量

value6=GetField(\"普通股股本\",\"Q\");//單位億元

value7=value5/value6/10;//每股自由現金流

value8=close/value7;

input:ratio(5,\"低標\");

if value8\<5 and value8 \>0 then ret=1;

## 場景 510：當沖語法支援的欄位說明 --- 下面是系統內建的幾個腳本，給大家作個參考

> 來源：[[當沖語法支援的欄位說明]{.underline}](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%b2%96%e8%aa%9e%e6%b3%95%e6%94%af%e6%8f%b4%e7%9a%84%e6%ac%84%e4%bd%8d%e8%aa%aa%e6%98%8e/)
> 說明：下面是系統內建的幾個腳本，給大家作個參考

input: atVolume(50,\"大單門檻\");

input: LaTime(10,\"大單筆數\");

input: TXT(\"須逐筆洗價\",\"使用限制\");

settotalbar(3);

variable: intrabarpersist Xtime(0);

//計數器

variable: intrabarpersist Volumestamp(0);

Volumestamp =q_DailyVolume;

if time \< time\[1\]

or Volumestamp = Volumestamp\[1\]

then Xtime =0; //開盤那根要歸0次數

if q_tickvolume \> atVolume

//單筆tick成交量超過大單門檻

and GetQuote(\"BidAskFlag\")=1

//外盤成交

then Xtime+=1;

//量夠大就加1次

if Xtime \> LaTime then begin

ret=1;

Xtime=0;

end;

## 場景 511：當沖語法支援的欄位說明 --- 參考的腳本 盤中委買遠大於委賣

> 來源：[[當沖語法支援的欄位說明]{.underline}](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%b2%96%e8%aa%9e%e6%b3%95%e6%94%af%e6%8f%b4%e7%9a%84%e6%ac%84%e4%bd%8d%e8%aa%aa%e6%98%8e/)
> 說明：參考的腳本 盤中委買遠大於委賣

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

if close\<\>q_DailyUplimit then begin

if condition1

or (condition2 and condition3)

then ret=1;

end;

## 場景 512：如何在XS選股中心用財報數字選股 --- 根據這樣的公式，我寫了一個函數的腳本如下

> 來源：[[如何在XS選股中心用財報數字選股]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e5%9c%a8xs%e9%81%b8%e8%82%a1%e4%b8%ad%e5%bf%83%e7%94%a8%e8%b2%a1%e5%a0%b1%e6%95%b8%e5%ad%97%e9%81%b8%e8%82%a1/)
> 說明：根據這樣的公式，我寫了一個函數的腳本如下

value1=GetField(\"股價淨值比\",\"D\");

value2=GetField(\"股東權益報酬率\",\"Q\");

value3=GetField(\"總市值(億)\",\"D\");

value4=GetField(\"營業利益率\",\"Q\");

if value3\>=200 and value4\>0 then

GVI=1/value1\*(1+value2/100)\*(1+value2/100)\*(1+value2/100)\*(1+value2/100)\*(1+value2/100)

else GVI=0;

## 場景 513：台灣50專屬交易指標之創新高與新低指標

> 來源：[[台灣50專屬交易指標之創新高與新低指標]{.underline}](https://www.xq.com.tw/xstrader/%e5%8f%b0%e7%81%a350%e5%b0%88%e5%b1%ac%e4%ba%a4%e6%98%93%e6%8c%87%e6%a8%99%e4%b9%8b%e5%89%b5%e6%96%b0%e9%ab%98%e8%88%87%e6%96%b0%e4%bd%8e%e6%8c%87%e6%a8%99/)
> 說明：創新高家數指標

value1=GetSymbolField(\"1101.tw\",\"收盤價\",\"D\");

value2=GetSymbolField(\"1102.tw\",\"收盤價\",\"D\");

value3=GetSymbolField(\"1216.tw\",\"收盤價\",\"D\");

value4=GetSymbolField(\"1301.tw\",\"收盤價\",\"D\");

value5=GetSymbolField(\"1303.tw\",\"收盤價\",\"D\");

value6=GetSymbolField(\"1326.tw\",\"收盤價\",\"D\");

value7=GetSymbolField(\"1402.tw\",\"收盤價\",\"D\");

value8=GetSymbolField(\"2002.tw\",\"收盤價\",\"D\");

value9=GetSymbolField(\"2105.tw\",\"收盤價\",\"D\");

value10=GetSymbolField(\"2207.tw\",\"收盤價\",\"D\");

value11=GetSymbolField(\"2301.tw\",\"收盤價\",\"D\");

value12=GetSymbolField(\"2303.tw\",\"收盤價\",\"D\");

value13=GetSymbolField(\"2308.tw\",\"收盤價\",\"D\");

value14=GetSymbolField(\"2317.tw\",\"收盤價\",\"D\");

value15=GetSymbolField(\"2327.tw\",\"收盤價\",\"D\");

value16=GetSymbolField(\"2330.tw\",\"收盤價\",\"D\");

value17=GetSymbolField(\"2357.tw\",\"收盤價\",\"D\");

value18=GetSymbolField(\"2382.tw\",\"收盤價\",\"D\");

value19=GetSymbolField(\"2395.tw\",\"收盤價\",\"D\");

value20=GetSymbolField(\"2408.tw\",\"收盤價\",\"D\");

value21=GetSymbolField(\"2409.tw\",\"收盤價\",\"D\");

value22=GetSymbolField(\"2412.tw\",\"收盤價\",\"D\");

value23=GetSymbolField(\"2454.tw\",\"收盤價\",\"D\");

value24=GetSymbolField(\"2474.tw\",\"收盤價\",\"D\");

value25=GetSymbolField(\"2633.tw\",\"收盤價\",\"D\");

value26=GetSymbolField(\"2801.tw\",\"收盤價\",\"D\");

value27=GetSymbolField(\"2880.tw\",\"收盤價\",\"D\");

value28=GetSymbolField(\"2881.tw\",\"收盤價\",\"D\");

value29=GetSymbolField(\"2882.tw\",\"收盤價\",\"D\");

value30=GetSymbolField(\"2883.tw\",\"收盤價\",\"D\");

value31=GetSymbolField(\"2884.tw\",\"收盤價\",\"D\");

value32=GetSymbolField(\"2885.tw\",\"收盤價\",\"D\");

value33=GetSymbolField(\"2886.tw\",\"收盤價\",\"D\");

value34=GetSymbolField(\"2887.tw\",\"收盤價\",\"D\");

value35=GetSymbolField(\"2890.tw\",\"收盤價\",\"D\");

value36=GetSymbolField(\"2891.tw\",\"收盤價\",\"D\");

value37=GetSymbolField(\"2892.tw\",\"收盤價\",\"D\");

value38=GetSymbolField(\"2912.tw\",\"收盤價\",\"D\");

value39=GetSymbolField(\"3008.tw\",\"收盤價\",\"D\");

value40=GetSymbolField(\"3045.tw\",\"收盤價\",\"D\");

value41=GetSymbolField(\"3711.tw\",\"收盤價\",\"D\");

value42=GetSymbolField(\"4904.tw\",\"收盤價\",\"D\");

value43=GetSymbolField(\"4938.tw\",\"收盤價\",\"D\");

value44=GetSymbolField(\"5871.tw\",\"收盤價\",\"D\");

value45=GetSymbolField(\"5876.tw\",\"收盤價\",\"D\");

value46=GetSymbolField(\"5880.tw\",\"收盤價\",\"D\");

value47=GetSymbolField(\"6505.tw\",\"收盤價\",\"D\");

value48=GetSymbolField(\"9904.tw\",\"收盤價\",\"D\");

value49=GetSymbolField(\"9910.tw\",\"收盤價\",\"D\");

value50=GetSymbolField(\"2823.tw\",\"收盤價\",\"D\");

variable:count(0);

input:period(20);

count=0;

if value1=highest(value1,period) then count=count+1;

if value2=highest(value2,period) then count=count+1;

if value3=highest(value3,period) then count=count+1;

if value4=highest(value4,period) then count=count+1;

if value5=highest(value5,period) then count=count+1;

if value6=highest(value6,period) then count=count+1;

if value7=highest(value7,period) then count=count+1;

if value8=highest(value8,period) then count=count+1;

if value9=highest(value9,period) then count=count+1;

if value10=highest(value10,period) then count=count+1;

if value11=highest(value11,period) then count=count+1;

if value12=highest(value12,period) then count=count+1;

if value13=highest(value13,period) then count=count+1;

if value14=highest(value14,period) then count=count+1;

if value15=highest(value15,period) then count=count+1;

if value16=highest(value16,period) then count=count+1;

if value17=highest(value17,period) then count=count+1;

if value18=highest(value18,period) then count=count+1;

if value19=highest(value19,period) then count=count+1;

if value20=highest(value20,period) then count=count+1;

if value21=highest(value21,period) then count=count+1;

if value22=highest(value22,period) then count=count+1;

if value23=highest(value23,period) then count=count+1;

if value24=highest(value24,period) then count=count+1;

if value25=highest(value25,period) then count=count+1;

if value26=highest(value26,period) then count=count+1;

if value27=highest(value27,period) then count=count+1;

if value28=highest(value28,period) then count=count+1;

if value29=highest(value29,period) then count=count+1;

if value30=highest(value30,period) then count=count+1;

if value31=highest(value31,period) then count=count+1;

if value32=highest(value32,period) then count=count+1;

if value33=highest(value33,period) then count=count+1;

if value34=highest(value34,period) then count=count+1;

if value35=highest(value35,period) then count=count+1;

if value36=highest(value36,period) then count=count+1;

if value37=highest(value37,period) then count=count+1;

if value38=highest(value38,period) then count=count+1;

if value39=highest(value39,period) then count=count+1;

if value40=highest(value40,period) then count=count+1;

if value41=highest(value41,period) then count=count+1;

if value42=highest(value42,period) then count=count+1;

if value43=highest(value43,period) then count=count+1;

if value44=highest(value44,period) then count=count+1;

if value45=highest(value45,period) then count=count+1;

if value46=highest(value46,period) then count=count+1;

if value47=highest(value47,period) then count=count+1;

if value48=highest(value48,period) then count=count+1;

if value49=highest(value49,period) then count=count+1;

if value50=highest(value50,period) then count=count+1;

value51=count;

plot1(value51,\"台灣50創新高家數指標\");

## 場景 514：台灣50專屬多空指標 --- 有不少朋友喜歡看多大盤時買0050，看壞大盤後市時買00632R，所以需要一個研究台灣50後市的多空依據，以下的腳本是用來計算台灣50裡的50檔成份股，有多少檔\...

> 來源：[[台灣50專屬多空指標]{.underline}](https://www.xq.com.tw/xstrader/tw50/)
> 說明：有不少朋友喜歡看多大盤時買0050，看壞大盤後市時買00632R，所以需要一個研究台灣50後市的多空依據，以下的腳本是用來計算台灣50裡的50檔成份股，有多少檔站在月線之上。

value1=GetSymbolField(\"1101.tw\",\"收盤價\");

value2=GetSymbolField(\"1102.tw\",\"收盤價\");

value3=GetSymbolField(\"1216.tw\",\"收盤價\");

value4=GetSymbolField(\"1301.tw\",\"收盤價\");

value5=GetSymbolField(\"1303.tw\",\"收盤價\");

value6=GetSymbolField(\"1326.tw\",\"收盤價\");

value7=GetSymbolField(\"1402.tw\",\"收盤價\");

value8=GetSymbolField(\"2002.tw\",\"收盤價\");

value9=GetSymbolField(\"2105.tw\",\"收盤價\");

value10=GetSymbolField(\"2207.tw\",\"收盤價\");

value11=GetSymbolField(\"2301.tw\",\"收盤價\");

value12=GetSymbolField(\"2303.tw\",\"收盤價\");

value13=GetSymbolField(\"2308.tw\",\"收盤價\");

value14=GetSymbolField(\"2317.tw\",\"收盤價\");

value15=GetSymbolField(\"2327.tw\",\"收盤價\");

value16=GetSymbolField(\"2330.tw\",\"收盤價\");

value17=GetSymbolField(\"2357.tw\",\"收盤價\");

value18=GetSymbolField(\"2382.tw\",\"收盤價\");

value19=GetSymbolField(\"2395.tw\",\"收盤價\");

value20=GetSymbolField(\"2408.tw\",\"收盤價\");

value21=GetSymbolField(\"2409.tw\",\"收盤價\");

value22=GetSymbolField(\"2412.tw\",\"收盤價\");

value23=GetSymbolField(\"2454.tw\",\"收盤價\");

value24=GetSymbolField(\"2474.tw\",\"收盤價\");

value25=GetSymbolField(\"2633.tw\",\"收盤價\");

value26=GetSymbolField(\"2801.tw\",\"收盤價\");

value27=GetSymbolField(\"2880.tw\",\"收盤價\");

value28=GetSymbolField(\"2881.tw\",\"收盤價\");

value29=GetSymbolField(\"2882.tw\",\"收盤價\");

value30=GetSymbolField(\"2883.tw\",\"收盤價\");

value31=GetSymbolField(\"2884.tw\",\"收盤價\");

value32=GetSymbolField(\"2885.tw\",\"收盤價\");

value33=GetSymbolField(\"2886.tw\",\"收盤價\");

value34=GetSymbolField(\"2887.tw\",\"收盤價\");

value35=GetSymbolField(\"2890.tw\",\"收盤價\");

value36=GetSymbolField(\"2891.tw\",\"收盤價\");

value37=GetSymbolField(\"2892.tw\",\"收盤價\");

value38=GetSymbolField(\"2912.tw\",\"收盤價\");

value39=GetSymbolField(\"3008.tw\",\"收盤價\");

value40=GetSymbolField(\"3045.tw\",\"收盤價\");

value41=GetSymbolField(\"3711.tw\",\"收盤價\");

value42=GetSymbolField(\"4904.tw\",\"收盤價\");

value43=GetSymbolField(\"4938.tw\",\"收盤價\");

value44=GetSymbolField(\"5871.tw\",\"收盤價\");

value45=GetSymbolField(\"5876.tw\",\"收盤價\");

value46=GetSymbolField(\"5880.tw\",\"收盤價\");

value47=GetSymbolField(\"6505.tw\",\"收盤價\");

value48=GetSymbolField(\"9904.tw\",\"收盤價\");

value49=GetSymbolField(\"9910.tw\",\"收盤價\");

value50=GetSymbolField(\"2823.tw\",\"收盤價\");

variable:count(0);

input:period(20);

count=0;

if value1\>average(value1,period) then count=count+1;

if value2\>average(value2,period) then count=count+1;

if value3\>average(value3,period) then count=count+1;

if value4\>average(value4,period) then count=count+1;

if value5\>average(value5,period) then count=count+1;

if value6\>average(value6,period) then count=count+1;

if value7\>average(value7,period) then count=count+1;

if value8\>average(value8,period) then count=count+1;

if value9\>average(value9,period) then count=count+1;

if value10\>average(value10,period) then count=count+1;

if value11\>average(value11,period) then count=count+1;

if value12\>average(value12,period) then count=count+1;

if value13\>average(value13,period) then count=count+1;

if value14\>average(value14,period) then count=count+1;

if value15\>average(value15,period) then count=count+1;

if value16\>average(value16,period) then count=count+1;

if value17\>average(value17,period) then count=count+1;

if value18\>average(value18,period) then count=count+1;

if value19\>average(value19,period) then count=count+1;

if value20\>average(value20,period) then count=count+1;

if value21\>average(value21,period) then count=count+1;

if value22\>average(value22,period) then count=count+1;

if value23\>average(value23,period) then count=count+1;

if value24\>average(value24,period) then count=count+1;

if value25\>average(value25,period) then count=count+1;

if value26\>average(value26,period) then count=count+1;

if value27\>average(value27,period) then count=count+1;

if value28\>average(value28,period) then count=count+1;

if value29\>average(value29,period) then count=count+1;

if value30\>average(value30,period) then count=count+1;

if value31\>average(value31,period) then count=count+1;

if value32\>average(value32,period) then count=count+1;

if value33\>average(value33,period) then count=count+1;

if value34\>average(value34,period) then count=count+1;

if value35\>average(value35,period) then count=count+1;

if value36\>average(value36,period) then count=count+1;

if value37\>average(value37,period) then count=count+1;

if value38\>average(value38,period) then count=count+1;

if value39\>average(value39,period) then count=count+1;

if value40\>average(value40,period) then count=count+1;

if value41\>average(value41,period) then count=count+1;

if value42\>average(value42,period) then count=count+1;

if value43\>average(value43,period) then count=count+1;

if value44\>average(value44,period) then count=count+1;

if value45\>average(value45,period) then count=count+1;

if value46\>average(value46,period) then count=count+1;

if value47\>average(value47,period) then count=count+1;

if value48\>average(value48,period) then count=count+1;

if value49\>average(value49,period) then count=count+1;

if value50\>average(value50,period) then count=count+1;

value51=count-25;

plot1(value51,\"台灣50多頭指數\");

用這個腳本可以畫出下面這張圖

## 場景 515：如何使用跨頻率技術指標來建構策略雷達 --- 舉個例子，如果我希望電腦可以在個股週RSI小於20且日KD低檔黃金交叉時發出訊號，那麼就可以使用像下面這樣的腳本

> 來源：[[如何使用跨頻率技術指標來建構策略雷達]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e4%bd%bf%e7%94%a8%e8%b7%a8%e9%a0%bb%e7%8e%87%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e4%be%86%e5%bb%ba%e6%a7%8b%e7%ad%96%e7%95%a5%e9%9b%b7%e9%81%94/)
> 說明：舉個例子，如果我希望電腦可以在個股週RSI小於20且日KD低檔黃金交叉時發出訊號，那麼就可以使用像下面這樣的腳本

input: Length_D(9,\"日KD期間\");

variable:rsv_d(0),kk_d(0),dd_d(0),c5(0);

stochastic(Length_D, 3, 3, rsv_d, kk_d, dd_d);

if xf_RSI(\"w\",close,5)\<=20 and kk_d \<=30

and kk_d crosses over dd_d

then ret=1;

## 場景 516：如何使用跨頻率技術指標來建構策略雷達 --- 這當中的xf_RSI就是在日線底下使用的跨頻率函數，大家也可以看一下這種跨頻率函數的寫法

> 來源：[[如何使用跨頻率技術指標來建構策略雷達]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e4%bd%bf%e7%94%a8%e8%b7%a8%e9%a0%bb%e7%8e%87%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e4%be%86%e5%bb%ba%e6%a7%8b%e7%ad%96%e7%95%a5%e9%9b%b7%e9%81%94/)
> 說明：這當中的xf_RSI就是在日線底下使用的跨頻率函數，大家也可以看一下這種跨頻率函數的寫法

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

condition1 = xf_getdtvalue(FreqType, Date) \<\> xf_getdtvalue(FreqType,
Date\[1\]);

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

## 場景 517：如何使用跨頻率技術指標來建構策略雷達 --- 這樣的語法目前系統內建的指標都是常用的指標，如果需要其他的指標，可以用類似的方法來自訂一個函數，例如跨頻率的加權移動平均線EMA就可以像下面這樣的寫法

> 來源：[[如何使用跨頻率技術指標來建構策略雷達]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e4%bd%bf%e7%94%a8%e8%b7%a8%e9%a0%bb%e7%8e%87%e6%8a%80%e8%a1%93%e6%8c%87%e6%a8%99%e4%be%86%e5%bb%ba%e6%a7%8b%e7%ad%96%e7%95%a5%e9%9b%b7%e9%81%94/)
> 說明：這樣的語法目前系統內建的指標都是常用的指標，如果需要其他的指標，可以用類似的方法來自訂一個函數，例如跨頻率的加權移動平均線EMA就可以像下面這樣的寫法

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

condition1 = xf_getdtvalue(FreqType, Date) \<\> xf_getdtvalue(FreqType,
Date\[1\]);

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

## 場景 518：盤中上漲下跌量累計差額指標 --- 首先依慣例還是先給腳本

> 來源：[[盤中上漲下跌量累計差額指標]{.underline}](https://www.xq.com.tw/xstrader/%e7%9b%a4%e4%b8%ad%e4%b8%8a%e6%bc%b2%e4%b8%8b%e8%b7%8c%e9%87%8f%e7%b4%af%e8%a8%88%e5%b7%ae%e9%a1%8d%e6%8c%87%e6%a8%99/)
> 說明：首先依慣例還是先給腳本

variable:i(0),tv(0),tp1(0),tp(0);

i=0;

if date\<\>date\[1\] then begin

value1=0;

value2=0;

end;

if V\>0

then begin

while GetField(\"時間\",\"Tick\")\[i\]\>=time and
GetFieldDate(\"成交量\",\"Tick\")\[i\]=date

i+=1;

while i\>0

begin

i-=1;

tv=GetField(\"成交量\",\"Tick\")\[i\];

tp=GetField(\"收盤價\",\"Tick\")\[i\];

tp1=GetField(\"收盤價\",\"Tick\")\[i+1\];

if tp\>tp1 //上漲

then begin

condition1=true;

condition2=false;

end;

if tp\<tp1

then begin

condition1=false;

condition2=true;

end;

if condition1 then value1+=tv;//上漲成交量累加

if condition2 then value2+=tv;//下跌成交量累加

end;

end;

value3=value1-value2;

plot1(value3,\"累計上漲下跌量差\");

## 場景 519：期指盤中大戶散戶指標

> 來源：[[期指盤中大戶散戶指標]{.underline}](https://www.xq.com.tw/xstrader/%e6%9c%9f%e6%8c%87%e7%9b%a4%e4%b8%ad%e5%a4%a7%e6%88%b6%e6%95%a3%e6%88%b6%e6%8c%87%e6%a8%99/)
> 說明：首先還是先PO腳本

input:

bos(true,\"類別\",inputkind:=dict(\[\"大戶\",true\],\[\"散戶\",false\]),quickedit:=true),

p(50,\"大戶門檻(口數)\");//預設值先訂50口，大家可以改成自己的定義

variable:i(0),tv(0),tp1(0),tp(0);

i=0;

if date\<\>date\[1\]

then begin

//當天開盤開始從新起算

value1=0;

value2=0;

end;

if V\>0

then begin

while GetField(\"時間\",\"Tick\")\[i\]\>=time and
GetFieldDate(\"成交量\",\"Tick\")\[i\]=getfield(\"日期\", \"D\")

i+=1;

while i\>0

begin

i-=1;

//做一個從這一根往前算到開盤共幾根的計數器

tv=GetField(\"成交量\",\"Tick\")\[i\];

tp=GetField(\"收盤價\",\"Tick\")\[i\];

tp1=GetField(\"收盤價\",\"Tick\")\[i+1\];

condition1=tv\>=p;//設定符合大戶的口數門檻

if tp\>tp1 //分上漲及下跌時的情況，這裡沒有考慮平盤的口數

then begin

condition2=true;

condition3=false;

end;

if tp\<tp1

then begin

condition2=false;

condition3=true;

end;

if condition1

then begin

if condition2 then value1+=tv;//計算累積的大戶量

if condition3 then value1-=tv;

end

else begin

if condition2 then value2+=tv;//計算累積的非大戶量

if condition3 then value2-=tv;

end;

end;

end;

if bos then value3=value1 else value3=value2;

if value3\>=0 then plot1(value3,\"大戶買賣超\");

if value3\<0 then plot2(value3,\"大戶買賣超\");

if not bos

then begin

setplotlabel(1,\"散戶買賣超\");

setplotlabel(2,\"散戶買賣超\");

end;

## 場景 520：盤中的大戶散戶買賣超指標 --- 先跟大家分享這個指標腳本

> 來源：[[盤中的大戶散戶買賣超指標]{.underline}](https://www.xq.com.tw/xstrader/%e7%9b%a4%e4%b8%ad%e7%9a%84%e5%a4%a7%e6%88%b6%e6%95%a3%e6%88%b6%e8%b2%b7%e8%b3%a3%e8%b6%85%e6%8c%87%e6%a8%99/)
> 說明：先跟大家分享這個指標腳本

input:

bos(true,\"類別\",inputkind:=dict(\[\"大戶\",true\],\[\"散戶\",false\]),quickedit:=true),

p(100,\"大戶門檻(萬元)\");

variable:i(0),tv(0),tp1(0),tp(0);

i=0;

if date\<\>date\[1\]

then begin

value1=0;

value2=0;

end;

if V\>0

then begin

while GetField(\"時間\",\"Tick\")\[i\]\>=time and
GetFieldDate(\"成交量\",\"Tick\")\[i\]=date

i+=1;

while i\>0

begin

i-=1;

tv=GetField(\"成交量\",\"Tick\")\[i\];

tp=GetField(\"收盤價\",\"Tick\")\[i\];

tp1=GetField(\"收盤價\",\"Tick\")\[i+1\];

condition1=0.1\*tv\*tp\>=p;

if tp\>tp1

then begin

condition2=true;

condition3=false;

end;

if tp\<tp1

then begin

condition2=false;

condition3=true;

end;

if condition1

then begin

if condition2 then value1+=tv;

if condition3 then value1-=tv;

end

else begin

if condition2 then value2+=tv;

if condition3 then value2-=tv;

end;

end;

end;

if bos then value3=value1 else value3=value2;

if value3\>=0 then plot1(value3,\"大戶買賣超\");

if value3\<0 then plot2(value3,\"大戶買賣超\");

if not bos

then begin

setplotlabel(1,\"散戶買賣超\");

setplotlabel(2,\"散戶買賣超\");

end;

## 場景 521：如何盤中即時估算主力大戶當天買賣超 --- 這個腳本如下，這是一個警示腳本，中中大戶的定義各位可以自行調整，要佔成交量比例超過多少才讓電腦發出訊號？ 也是可以調整的。

> 來源：[[如何盤中即時估算主力大戶當天買賣超]{.underline}](https://www.xq.com.tw/xstrader/9816-2/)
> 說明：這個腳本如下，這是一個警示腳本，中中大戶的定義各位可以自行調整，要佔成交量比例超過多少才讓電腦發出訊號？
> 也是可以調整的。

input: BigBuy(300,\"大戶買單(萬)\");

input: bigbuyratio(30,\"大戶買單比例下限%\");

variable: intrabarpersist Xvolume(0);//累計大戶買單

variable: intrabarpersist Volumestamp(0);

Volumestamp =q_DailyVolume;

if Date \<\> currentdate or Volumestamp = Volumestamp\[1\] then Xvolume
=0; //開盤那根要歸0

if q_tickvolume\*q_Last \> BigBuy\*10 and q_BidAskFlag=1 then
Xvolume=Xvolume+q_tickvolume; //量夠大就加到累計大戶買單

if volumestamp \>=1000 then begin

if Xvolume/volumestamp\*100\> bigbuyratio then ret=1;

end;

## 場景 522：如何盤中即時估算主力大戶當天買賣超

> 來源：[[如何盤中即時估算主力大戶當天買賣超]{.underline}](https://www.xq.com.tw/xstrader/9816-2/)
> 說明：XBvolume

variable: intrabarpersist XBvolume(0);//累計大戶買單

variable: intrabarpersist Volumestamp(0);

Volumestamp =q_DailyVolume;

if Date \<\> currentdate or Volumestamp = Volumestamp\[1\] then XBvolume
=0; //開盤那根要歸0

if q_tickvolume\*q_Last \> 1000 and q_BidAskFlag=1 then
XBvolume=XBvolume+q_tickvolume;

//量夠大就加到累計大戶買單

//1000代表大戶的標準是100萬，如果想要改變定義請自行修改數字

## 場景 523：如何盤中即時估算主力大戶當天買賣超

> 來源：[[如何盤中即時估算主力大戶當天買賣超]{.underline}](https://www.xq.com.tw/xstrader/9816-2/)
> 說明：XSvolume

variable: intrabarpersist XSvolume(0);//累計大戶賣單

variable: intrabarpersist Volumestamp(0);

Volumestamp =q_DailyVolume;

if Date \<\> currentdate or Volumestamp = Volumestamp\[1\] then XSvolume
=0;

if q_tickvolume\*q_Last \> 1000 and q_BidAskFlag=-1

then XSvolume=XSvolume+q_tickvolume;

## 場景 524：依成交量分佈情況而設計的預估量演算法 --- 這個估計量的腳本如果作成指標，其腳本如下

> 來源：[[依成交量分佈情況而設計的預估量演算法]{.underline}](https://www.xq.com.tw/xstrader/%e4%be%9d%e6%88%90%e4%ba%a4%e9%87%8f%e5%88%86%e4%bd%88%e6%83%85%e6%b3%81%e8%80%8c%e8%a8%ad%e8%a8%88%e7%9a%84%e9%a0%90%e4%bc%b0%e9%87%8f%e6%bc%94%e7%ae%97%e6%b3%95/)
> 說明：這個估計量的腳本如果作成指標，其腳本如下

//

// 參數: 統計天期(N)

// 繪製: 當日估計成交量

//

// 支援任何頻率(分鐘/日)

//

// 計算方式: 依照過去N日, 每日1分鐘累計成交均量(統計天期平均),
算出每分鐘累計成交量的分佈比例,

// 然後依照目前的累計日成交量以及分佈比例, 推算當日收盤估計成交量

//

input: length(5, \"統計天數\");

variable: BARPERDAY(270); // 1分鐘bar每一天270筆

array: arr_minvolume\[\](0); // (過去N日)每日每分鐘累計: 共length \*
270筆

array: arr_minvolume_percent\[270\](0); // (平均)每分鐘累計成交量比例:
共270筆

array: arr_avg_minvolume\[270\](0); // (平均)每分鐘累計成交量: 共270筆

variable: \_i(0), \_j(0), \_k(0);

variable: \_totaldays(0);

variable: \_lastdate(0);

Array_SetMaxIndex(arr_minvolume, length \* 270);

{

print(text(

\"currentbar=\", numtostr(currentbar, 0),

\",date=\", numtostr(date, 0),

\",time=\", numtostr(time, 0),

\",lastdate=\", numtostr(\_lastdate, 0),

\",totaldays=\", numtostr(\_totaldays, 0)

));

}

if \_lastdate = 0 then begin

// 跳過第一個不滿一天的資料

if barfreq = \"Min\" and time = 090000 then

\_lastdate = date

else begin

// 日線的話則從20190101才開始算

if date \>= 20190101 then

\_lastdate = date;

end;

end;

if \_lastdate \<\> 0 and date \<\> \_lastdate then begin

\_lastdate = date;

\_totaldays = \_totaldays + 1;

if \_totaldays \>= length then begin

// 計算過去N天的成交量分佈

//

// 因為我可能跑在不同頻率上,
所以要先算出過去N日\'1分鐘\'資料的起點跟終點

//

variable: \_start(0), \_end(0), \_startdate(0), \_accvolume(0);

\_end = 1;

while getfield(\"time\", \"1\")\[\_end\] \<\> 132900 begin

\_end = \_end + 1;

end;

\_start = \_end + BARPERDAY \* length - 1;

// \_start = 統計日期第一日第一筆1分鐘資料的位置

// \_end = 統計日期最後一日最後一筆1分鐘資料的位置

//

// arr_minvolume\[\]: 儲存過去N天, 每一分鐘的日累積成交量

// arr_minvolume\[1\] = 09:00,

// arr_minvolume\[2\] = 09:01

// arr_minvolume\[271\] = 第二天09:00

// ..

\_startdate = getfield(\"date\", \"1\")\[\_start\];

\_accvolume = 0;

for \_i = \_start downto \_end begin

if \_startdate \<\> getfield(\"date\", \"1\")\[\_i\] then begin

// 換日

\_accvolume = 0;

\_startdate = getfield(\"date\", \"1\")\[\_i\];

end;

\_accvolume += getfield(\"volume\", \"1\")\[\_i\];

arr_minvolume\[\_start - \_i + 1\] = \_accvolume; // 當日累積volume

end;

// arr_avg_minvolume\[\]: 每一分鐘的日平均累積成交量

//

for \_j = 1 to BARPERDAY begin

arr_avg_minvolume\[\_j\] = 0;

for \_i = 1 to length begin

arr_avg_minvolume\[\_j\] += arr_minvolume\[\_j + (\_i - 1) \*
BARPERDAY\];

end;

end;

for \_j = 1 to BARPERDAY begin

arr_avg_minvolume\[\_j\] = arr_avg_minvolume\[\_j\] / length;

end;

// arr_minvolume_percent\[\]: 每一分鐘的日平均累積成交量%

//

for \_j = 1 to BARPERDAY begin

arr_minvolume_percent\[\_j\] = arr_avg_minvolume\[\_j\] /
arr_avg_minvolume\[BARPERDAY\];

end;

{

print(text(

\"main-date=\", numtostr(date, 0), \",\",

\"main-time=\", numtostr(time, 0), \",\",

\"start=\", numtostr(\_start, 0), \",\",

\"end=\", numtostr(\_end, 0), \",\",

\"startdate=\", numtostr(getfield(\"date\", \"1\")\[\_start\], 0),
\",\", numtostr(getfield(\"time\", \"1\")\[\_start\], 0), \",\",

\"enddate=\", numtostr(getfield(\"date\", \"1\")\[\_end\], 0), \",\",
numtostr(getfield(\"time\", \"1\")\[\_end\], 0), \",\"

));

for \_i = 1 to 270 begin

print(text(

numtostr(\_i, 0), \"=\",

numtostr(arr_minvolume_percent\[\_i\] \* 100, 2)));

end;

}

end;

end;

if \_totaldays \>= length then begin

// 如果已經有分佈資料了, 則計算估計成交量

//

variable: \_estvolume(0);

variable: \_timeindex(0);

variable: \_time(0), \_v(0);

// 算出目前時間應該是1\~270的哪一筆

// 分鐘線的話就用bar的時間

// 日線的話, 如果是歷史日線, 就用收盤時間估算, 如果是最後一天(盤中日線),
用目前時間估算

//

if barfreq = \"Min\" then

\_time = time

else begin

if date \< currentdate then

\_time = 132900

else

\_time = currenttime;

end;

\_timeindex = floor(timediff(\_time, 090000, \"M\")) + 1;

\_timeindex = minlist(\_timeindex, 270);

\_timeindex = maxlist(1, \_timeindex);

// 預估量 = 累計到目前的日成交量 / 這個時間點之前所佔的日成交量%

//

\_v = GetField(\"volume\", \"D\");

if arr_minvolume_percent\[\_timeindex\] \> 0 then

\_estvolume = \_v / arr_minvolume_percent\[\_timeindex\]

else

\_estvolume = 0;

plot1(\_estvolume, \"預估量\");

end;

## 場景 525：依成交量分佈情況而設計的預估量演算法 --- 我也試著把這個預估量的腳本寫成函數

> 來源：[[依成交量分佈情況而設計的預估量演算法]{.underline}](https://www.xq.com.tw/xstrader/%e4%be%9d%e6%88%90%e4%ba%a4%e9%87%8f%e5%88%86%e4%bd%88%e6%83%85%e6%b3%81%e8%80%8c%e8%a8%ad%e8%a8%88%e7%9a%84%e9%a0%90%e4%bc%b0%e9%87%8f%e6%bc%94%e7%ae%97%e6%b3%95/)
> 說明：我也試著把這個預估量的腳本寫成函數

input: length(numericsimple);

variable: BARPERDAY(270); // 1分鐘bar每一天270筆

array: arr_minvolume\[\](0); // (過去N日)每日每分鐘累計: 共length \*
270筆

array: arr_minvolume_percent\[270\](0); // (平均)每分鐘累計成交量比例:
共270筆

array: arr_avg_minvolume\[270\](0); // (平均)每分鐘累計成交量: 共270筆

variable: \_i(0), \_j(0), \_k(0);

variable: \_totaldays(0);

variable: \_lastdate(0);

Array_SetMaxIndex(arr_minvolume, length \* 270);

{

print(text(

\"currentbar=\", numtostr(currentbar, 0),

\",date=\", numtostr(date, 0),

\",time=\", numtostr(time, 0),

\",lastdate=\", numtostr(\_lastdate, 0),

\",totaldays=\", numtostr(\_totaldays, 0)

));

}

if \_lastdate = 0 then begin

// 跳過第一個不滿一天的資料

if barfreq = \"Min\" and time = 090000 then

\_lastdate = date

else begin

// 日線的話則從20190101才開始算

if date \>= 20190101 then

\_lastdate = date;

end;

end;

if \_lastdate \<\> 0 and date \<\> \_lastdate then begin

\_lastdate = date;

\_totaldays = \_totaldays + 1;

if \_totaldays \>= length then begin

// 計算過去N天的成交量分佈

//

// 因為我可能跑在不同頻率上,
所以要先算出過去N日\'1分鐘\'資料的起點跟終點

//

variable: \_start(0), \_end(0), \_startdate(0), \_accvolume(0);

\_end = 1;

while getfield(\"time\", \"1\")\[\_end\] \<\> 132900 begin

\_end = \_end + 1;

end;

\_start = \_end + BARPERDAY \* length - 1;

// \_start = 統計日期第一日第一筆1分鐘資料的位置

// \_end = 統計日期最後一日最後一筆1分鐘資料的位置

//

// arr_minvolume\[\]: 儲存過去N天, 每一分鐘的日累積成交量

// arr_minvolume\[1\] = 09:00,

// arr_minvolume\[2\] = 09:01

// arr_minvolume\[271\] = 第二天09:00

// ..

\_startdate = getfield(\"date\", \"1\")\[\_start\];

\_accvolume = 0;

for \_i = \_start downto \_end begin

if \_startdate \<\> getfield(\"date\", \"1\")\[\_i\] then begin

// 換日

\_accvolume = 0;

\_startdate = getfield(\"date\", \"1\")\[\_i\];

end;

\_accvolume += getfield(\"volume\", \"1\")\[\_i\];

arr_minvolume\[\_start - \_i + 1\] = \_accvolume; // 當日累積volume

end;

// arr_avg_minvolume\[\]: 每一分鐘的日平均累積成交量

//

for \_j = 1 to BARPERDAY begin

arr_avg_minvolume\[\_j\] = 0;

for \_i = 1 to length begin

arr_avg_minvolume\[\_j\] += arr_minvolume\[\_j + (\_i - 1) \*
BARPERDAY\];

end;

end;

for \_j = 1 to BARPERDAY begin

arr_avg_minvolume\[\_j\] = arr_avg_minvolume\[\_j\] / length;

end;

// arr_minvolume_percent\[\]: 每一分鐘的日平均累積成交量%

//

for \_j = 1 to BARPERDAY begin

arr_minvolume_percent\[\_j\] = arr_avg_minvolume\[\_j\] /
arr_avg_minvolume\[BARPERDAY\];

end;

{

print(text(

\"main-date=\", numtostr(date, 0), \",\",

\"main-time=\", numtostr(time, 0), \",\",

\"start=\", numtostr(\_start, 0), \",\",

\"end=\", numtostr(\_end, 0), \",\",

\"startdate=\", numtostr(getfield(\"date\", \"1\")\[\_start\], 0),
\",\", numtostr(getfield(\"time\", \"1\")\[\_start\], 0), \",\",

\"enddate=\", numtostr(getfield(\"date\", \"1\")\[\_end\], 0), \",\",
numtostr(getfield(\"time\", \"1\")\[\_end\], 0), \",\"

));

for \_i = 1 to 270 begin

print(text(

numtostr(\_i, 0), \"=\",

numtostr(arr_minvolume_percent\[\_i\] \* 100, 2)));

end;

}

end;

end;

if \_totaldays \>= length then begin

// 如果已經有分佈資料了, 則計算估計成交量

//

variable: \_estvolume(0);

variable: \_timeindex(0);

variable: \_time(0), \_v(0);

// 算出目前時間應該是1\~270的哪一筆

// 分鐘線的話就用bar的時間

// 日線的話, 如果是歷史日線, 就用收盤時間估算, 如果是最後一天(盤中日線),
用目前時間估算

//

if barfreq = \"Min\" then

\_time = time

else begin

if date \< currentdate then

\_time = 132900

else

\_time = currenttime;

end;

\_timeindex = floor(timediff(\_time, 090000, \"M\")) + 1;

\_timeindex = minlist(\_timeindex, 270);

\_timeindex = maxlist(1, \_timeindex);

// 預估量 = 累計到目前的日成交量 / 這個時間點之前所佔的日成交量%

//

\_v = GetField(\"volume\", \"D\");

if arr_minvolume_percent\[\_timeindex\] \> 0 then

\_estvolume = \_v / arr_minvolume_percent\[\_timeindex\]

else

\_estvolume = 0;

destvolume=\_estvolume;

end;

## 場景 526：依成交量分佈情況而設計的預估量演算法 --- 利用這個Destvolume的函數，我們就可以寫出預估量比五日均量增加N%的警示腳本

> 來源：[[依成交量分佈情況而設計的預估量演算法]{.underline}](https://www.xq.com.tw/xstrader/%e4%be%9d%e6%88%90%e4%ba%a4%e9%87%8f%e5%88%86%e4%bd%88%e6%83%85%e6%b3%81%e8%80%8c%e8%a8%ad%e8%a8%88%e7%9a%84%e9%a0%90%e4%bc%b0%e9%87%8f%e6%bc%94%e7%ae%97%e6%b3%95/)
> 說明：利用這個Destvolume的函數，我們就可以寫出預估量比五日均量增加N%的警示腳本

input:day(10,\"預估量估算期間\");

input:period(20,\"均量計算期間\");

input:ratio(80,\" 暴量比例\");

if destvolume(day) crosses over average(volume,period)\*(1+ratio/100)

and close\>close\[1\]\*1.01

then ret=1;

## 場景 527：美股產業輪動

> 來源：[[美股產業輪動]{.underline}](https://www.xq.com.tw/xstrader/%e7%be%8e%e8%82%a1%e7%94%a2%e6%a5%ad%e8%bc%aa%e5%8b%95/)
> 說明：RS的腳本如下

input:preiod(20,\"RS移動平均線計算期別\");

value1=GetSymbolField(\"GSPC.FS\",\"收盤價\",\"W\");

variable:rss(0);

variable:rssav(0);

if value1\<\>0 then rss=CLOSE/value1;

rssav=average(rss,10);

plot1(rss,\"美股RS指標\");

plot2(rssav,\"移動平均\");

## 場景 528：從相對強度指標挑強勢類股 --- 根據這樣的公式，寫出對應的指標腳本如下

> 來源：[[從相對強度指標挑強勢類股]{.underline}](https://www.xq.com.tw/xstrader/%e5%be%9e%e7%9b%b8%e5%b0%8d%e5%bc%b7%e5%ba%a6%e6%8c%87%e6%a8%99%e6%8c%91%e5%bc%b7%e5%8b%a2%e9%a1%9e%e8%82%a1/)
> 說明：根據這樣的公式，寫出對應的指標腳本如下

input:preiod(20,\"RS移動平均線計算期別\");

value1=GetSymbolField(\"TSE.TW\",\"收盤價\",\"D\");

variable:rss(0);

variable:rssav(0);

if value1\<\>0 then rss=CLOSE/value1;

rssav=average(rss,10);

plot1(rss,\"RS指標\");

plot2(rssav,\"移動平均\");

## 場景 529：相對強度的程式寫法與應用 --- 相對強度的計算方式很單純，就是把商品A的收盤價除以商品B的收盤價，在XS的語法上，可以寫去指標如下

> 來源：[[相對強度的程式寫法與應用]{.underline}](https://www.xq.com.tw/xstrader/%e7%9b%b8%e5%b0%8d%e5%bc%b7%e5%ba%a6%e7%9a%84%e7%a8%8b%e5%bc%8f%e5%af%ab%e6%b3%95%e8%88%87%e6%87%89%e7%94%a8/)
> 說明：相對強度的計算方式很單純，就是把商品A的收盤價除以商品B的收盤價，在XS的語法上，可以寫去指標如下

input:symbol1(\"\",\"主商品代碼\");

input:symbol2(\"\",\"比較商品代碼\");

value1=GetSymbolField(symbol1,\"收盤價\",\"D\");

value2=GetSymbolField(symbol2,\"收盤價\",\"D\");

var:rss(0);

var:rssav(0);

if value2\<\>0 then rss=value1/value2;

plot1(rss,\"RS相對強度指標\");

## 場景 530：私房秘技之如何預估EPS --- 請大家先看以下的這個函數

> 來源：[[私房秘技之如何預估EPS]{.underline}](https://www.xq.com.tw/xstrader/%e7%a7%81%e6%88%bf%e7%a7%98%e6%8a%80%e4%b9%8b%e5%a6%82%e4%bd%95%e9%a0%90%e4%bc%b0eps/)
> 說明：請大家先看以下的這個函數

input:name(stringsimple);

input:sq1(numericsimple);//預估單季營收年增率

input:sq2(numericsimple);

input:sq3(numericsimple);

input:sq4(numericsimple);

input:gq1(numericsimple);//預估單季毛利率增減值

input:gq2(numericsimple);

input:gq3(numericsimple);

input:gq4(numericsimple);

input:fq1(numericsimple);//預估單季營業費用季增率

input:fq2(numericsimple);

input:fq3(numericsimple);

input:fq4(numericsimple);

//value1=GetField(\"營業收入淨額\",\"Q\");//單位:百萬

value2=GetField(\"營業毛利率\",\"Q\");

value3=GetField(\"營業費用\",\"Q\");//單位：百萬

value4=GetField(\"普通股股本\",\"Q\");//單位：億元

if name=symbolname then begin

//======計算未來四季營收===========

value5=GetField(\"營業收入淨額\",\"Q\")\[3\]\*(1+sq1/100);

//下一季預估營收

value6=GetField(\"營業收入淨額\",\"Q\")\[2\]\*(1+sq2/100);

//下下季預估營收

value7=GetField(\"營業收入淨額\",\"Q\")\[1\]\*(1+sq3/100);

//下下下季預估營收

value8=GetField(\"營業收入淨額\",\"Q\")\*(1+sq4/100);

//未來第四季預估營收

//======計算未來四季預估毛利率=====

value9=value2+gq1;

//下一季預估毛利率

value10=value9+gq2;

//下下季預估毛利率

value11=value10+gq3;

//下下下季預估毛利率

value12=value11+gq4;

//未來第四季預估毛利率

//=====計算未來四季營業費用======

value13=value3\*(1+fq1/100);

//下一季預估營業費用

value14=value13\*(1+fq2/100);

//下下季預估營業費用

value15=value14\*(1+fq3/100);

//下下下季預估營業費用

value16=value15\*(1+fq4/100);

//未來第四季預估營業費用

//=========計算未來四季的營業利益==========

value17=value5\*(value9/100)-value13;

value18=value6\*(value10/100)-value14;

value19=value7\*(value11/100)-value15;

value20=value8\*(value12/100)-value16;

//計算合計的營業利益

value21=(value17+value18+value19+value20)/100;//單位:億元

if value4\<\>0 then

value22=value21/(value4)\*10;

EEPS=value22;

end;

## 場景 531：私房秘技之如何預估EPS --- 我是把這函數拿來用在選股腳本上

> 來源：[[私房秘技之如何預估EPS]{.underline}](https://www.xq.com.tw/xstrader/%e7%a7%81%e6%88%bf%e7%a7%98%e6%8a%80%e4%b9%8b%e5%a6%82%e4%bd%95%e9%a0%90%e4%bc%b0eps/)
> 說明：我是把這函數拿來用在選股腳本上

input:name(\"\",\"請輸入公司名稱\");

input:sq1(-5,\"預估下一季營收年增率\");

input:sq2(-5,\"預估下下季營收年增率\");

input:sq3(0,\"預估下下下季營收年增率\");

input:sq4(-5,\"預估之後第四個季度營收年增率\");

input:gq1(0,\"預估下一季單季毛利率較上一季增減值\");

input:gq2(0,\"預估下下季單季毛利率較上一季增減值\");

input:gq3(0,\"預估下下下季單季毛利率較上一季增減值\");

input:gq4(0,\"預估之後第四個季度單季較上一季毛利率增減值\");

input:fq1(0,\"預估下一季單季營業費用季增率\");

input:fq2(0,\"預估下下季單季營業費用季增率\");

input:fq3(0,\"預估下下下季單季營業費用季增率\");

input:fq4(0,\"預估之後第四個季度單季營業費用季增率\");

value1=EEPS(name,sq1,sq2,sq3,sq4,gq1,gq2,gq3,gq4,fq1,fq2,fq3,fq4);

value7=close/value1;

ret=1;

outputfield(1,value1,1,\"預估EPS\");

outputfield(2,close,1,\"收盤價\");

outputfield(3,value7,1,\"本益比\");

## 場景 532：尋找剛剛冒出頭來的股票 --- 於是，我寫了以下的一個樣本腳本來處理這件事

> 來源：[[尋找剛剛冒出頭來的股票]{.underline}](https://www.xq.com.tw/xstrader/%e5%b0%8b%e6%89%be%e5%89%9b%e5%89%9b%e5%86%92%e5%87%ba%e9%a0%ad%e4%be%86%e7%9a%84%e8%82%a1%e7%a5%a8/)
> 說明：於是，我寫了以下的一個樣本腳本來處理這件事

var:count(0);

count=0;

//===========法人同步買超====================

variable: v1(0),v2(0),v3(0),c1(0);

v1=Getfield(\"外資買賣超\");

v2=Getfield(\"投信買賣超\");

v3=Getfield(\"自營商買賣超\");

c1= barslast(minlist2(v1,v2,v3)\>100);

if c1=0 and c1\[1\]\>20

then count=count+1;

//===========多頭起漲前的籌碼收集================

variable:c2(0);

value1=GetField(\"分公司買進家數\");

value2=GetField(\"分公司賣出家數\");

value3=value2-value1;

value4=countif(value3\>20,10);

c2=barslast(value4\>6 );

if c2=0 and c2\[1\]\>20

then count= count+1;

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

if c3=0 and c3\[1\]\>20

then count=count+1;

//===========淨力指標==============

variable:c4(0);

input:period2(10,\"長期參數\");

value12=summation(high-close,period2);//上檔賣壓

value13=summation(close-open,period2); //多空實績

value14=summation(close-low,period2);//下檔支撐

value15=summation(open-close\[1\],period2);//隔夜力道

if close\<\>0

then

value16=(value13+value14+value15-value12)/close\*100;

c4=barslast( value16 crosses over -4);

if c4=0 and c4\[1\]\>20

then count=count+1;

//==========日KD黃金交叉================

input: Length_D(9, \"日KD期間\");

input: Length_M(5, \"周KD期間\");

variable:rsv_d(0),kk_d(0),dd_d(0),c5(0);

stochastic(Length_D, 3, 3, rsv_d, kk_d, dd_d);

c5=barslast(kk_d crosses over dd_d);

if c5=0 and c5\[1\]\>20

then count=count+1;

//========DIF-MACD翻正=============

input: FastLength(12), SlowLength(26), MACDLength(9);

variable: difValue(0), macdValue(0), oscValue(0);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

variable:c6(0);

c6=barslast(oscValue Crosses Above 0);

if c6=0 and c6\[1\]\>20

then count=count+1;

//============主力多日買超==============

var:v7(0),c7(0);

v7=GetField(\"主力買賣超張數\",\"D\");

c7=barslast(trueall(v7\>500,3));

if c7=0 and c7\[1\]\>20

then count=count+1;

//=========總成交次數================

variable: t1(0),mat1(0),c8(0);

t1=GetField(\"總成交次數\",\"D\");

mat1=average(t1,20)\*1.5;

c8=barslast(t1 crosses over mat1 and close\>close\[1\]);

if c8=0 and c8\[1\]\>20

then count=count+1;

//========

var:v9(0),c9(0);

v9=GetField(\"綜合前十大券商買賣超張數\",\"D\");

c9=barslast(trueall(v9\>300,3));

if c9=0 and c9\[1\]\>20

then count=count+1;

//============開盤委買================

variable:b1(0),mab1(0),c10(0);

b1=GetField(\"主力買張\");

mab1=average(b1,10);

c10=barslast(b1 crosses over mab1);

if c10=0 and c10\[1\]\>10

then count=count+1;

if count\>2 or count+count\[1\]\>3 or count+count\[1\]+count\[2\]\>5
then ret=1;

## 場景 533：RVI指標的計算方法 --- 我試著寫了對應的XS自訂指標腳本如下

> 來源：[[RVI指標的計算方法]{.underline}](https://www.xq.com.tw/xstrader/rvi%e6%8c%87%e6%a8%99%e7%9a%84%e8%a8%88%e7%ae%97%e6%96%b9%e6%b3%95/)
> 說明：我試著寫了對應的XS自訂指標腳本如下

VAR:UP1(0),DN1(0),UPAVG(0),DNAVG(0),RVIORIG(0),RVI1(0);

IF CLOSE\>CLOSE\[1\] THEN BEGIN

UP1=standarddev(CLOSE,9,1);

DN1=0;

end else begin

UP1=0;

DN1=standarddev(CLOSE,9,1);

END;

INPUT:PERIOD(10,\"期別\");

UPAVG=(UPAVG\*(PERIOD-1)+UP1)/PERIOD;

DNAVG=(DNAVG\*(PERIOD-1)+DN1)/PERIOD;

RVIORIG=100\*(UPAVG/(UPAVG+DNAVG));

RVI1=(HIGHEST(RVIORIG,PERIOD)+LOWEST(RVIORIG,PERIOD))/2;

plot1(RVI1);

對應的圖如下

## 場景 534：答客問之MACD柱體反轉的寫法 --- 一，找出當天的柱狀體是 綠柱體第一天往上收

> 來源：[[答客問之MACD柱體反轉的寫法]{.underline}](https://www.xq.com.tw/xstrader/%e7%ad%94%e5%ae%a2%e5%95%8f%e4%b9%8bmacd%e6%9f%b1%e9%ab%94%e5%8f%8d%e8%bd%89%e7%9a%84%e5%af%ab%e6%b3%95/)
> 說明：一，找出當天的柱狀體是 綠柱體第一天往上收

input: FastLength(12, \"DIF短期期數\"), SlowLength(26, \"DIF長期期數\"),
MACDLength(9, \"MACD期數\");

//設定MACD相關的天期參數

variable: difValue(0), macdValue(0), oscValue(0);

//宣告MACD各指標的變數名稱

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue,
macdValue, oscValue);

//引用內建的MACD函數，以回傳MACD的dif,MACD,OSC的值

if oscvalue\<-0.1

//osc柱狀體跌的夠深

and oscvalue\[1\]\<oscvalue\[2\]

//前一期還在往下跌

and oscvalue\>oscvalue\[1\]

//這一期已回升

then ret=1;

## 場景 535：當沖之上漲後拉回的寫法 --- 針對這種型態，敝公司的高手寫的腳本如下

> 來源：[[當沖之上漲後拉回的寫法]{.underline}](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%b2%96%e4%b9%8b%e4%b8%8a%e6%bc%b2%e5%be%8c%e6%8b%89%e5%9b%9e%e7%9a%84%e5%af%ab%e6%b3%95/)
> 說明：針對這種型態，敝公司的高手寫的腳本如下

value1=highestbar(H,20);//抓出20期最高點

value2=lowestbar(L,20);//抓出20期最低點

value3=average(L,6);//近6期平均值

value4=standarddev(L,6,1)/value3;//近6期變異係數

if currentbar\<50 then return;//不要不完整的型態

condition1=value1\<value2 and value1\>6;

//在10期以前有最高點且最高點發生在最低點後

condition2=value3\>0.3\*H\[value1\]+0.7\*L\[value2\] and
value3\<0.6\*H\[value1\]+0.4\*L\[value2\] and value4\<0.05;

//近8期平均值回落到最高點與最低點的60%以下但在30%以上且近8日變異係數不足3%

if value2\>0 then condition3=H\[value1\]/L\[value2\]\>1.02;

//前面要漲超過2%

condition4=condition1 and condition2 and condition3;

//以上符合

if condition4 and not trueany(condition4\[1\],10) and close \>
close\[2\]\*1.015 then ret=1;

//首次開始符合出訊號

## 場景 536：短線交易之10分鐘K多次探底後回昇 --- 於是我請公司的高手高手高高手寫了以下的腳本

> 來源：[[短線交易之10分鐘K多次探底後回昇]{.underline}](https://www.xq.com.tw/xstrader/%e7%9f%ad%e7%b7%9a%e4%ba%a4%e6%98%93%e4%b9%8b10%e5%88%86%e9%90%98k%e5%a4%9a%e6%ac%a1%e6%8e%a2%e5%ba%95%e5%be%8c%e5%9b%9e%e6%98%87/)
> 說明：於是我請公司的高手高手高高手寫了以下的腳本

value1=lowest(C,5);

//5期最低收盤價

value5=average(C,10);

//5期均價

condition1=L\<value1 and minlist(C,O)\>L\*1.005;

//低比近5最低收盤價還低且影線長度要有

condition2=condition1 and C\>O;

//上面那個條件加上紅K

value3=countif(condition1,10);

//最近影線的次數

value4=countif(condition2,5);

//紅K且影線的次數

if value3 crosses over 2 and value4\>0 and C\<value5 and C\>value1\[1\]
then ret=1;

//如果影線次數三次或以上而且裡面有一個是紅K而且前一段為空頭且收盤不破收盤底就出訊號

## 場景 537：選股常用語的對應程式集(二)

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：一，RSI低檔回昇

input:period(12,\"計算天期\");

input:limitline(20,\"低點位置\");

if rsi(close,period) cross over limitline

then ret=1;

## 場景 538：選股常用語的對應程式集(二)

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：二，股價轉強

input:length(10);

variable: sumUp(0), sumDown(0), up(0), down(0),RS(0);

if CurrentBar = 1 then

begin

sumUp = Average(maxlist(close - close\[1\], 0), length);

sumDown = Average(maxlist(close\[1\] - close, 0), length);

end

else

begin

up = maxlist(close - close\[1\], 0);

down = maxlist(close\[1\] - close, 0);

sumUp = sumUp\[1\] + (up - sumUp\[1\]) / length;

sumDown = sumDown\[1\] + (down - sumDown\[1\]) / length;

end;

if sumdown\<\>0

then rs=sumup/sumdown;

if rs crosses over 4

then ret=1;

## 場景 539：選股常用語的對應程式集(二)

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：三，連續幾日都出量

input:z(20,\"均量計算天期\");

input:n(2000,\"均量上限\");

input:m(2,\"近幾日天期數\");

input:k(4000,\"近幾日量下限\");

if average(volume,z)\[m-1\]\<n

and trueall(volume\>k,m)

then ret=1;

## 場景 540：選股常用語的對應程式集(二)

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：四，RSI背離

value1=rsi(close,10);

if deviate(close,value1,10)=1

and linearregslope(value1,10)\>0.45

then ret=1;

## 場景 541：選股常用語的對應程式集(二) --- 這裡用到deviate這個自訂函數，函數的腳本如下

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：這裡用到deviate這個自訂函數，函數的腳本如下

input:price(numericsimple),index1(numericsimple),length(numericsimple);

if length\<5

then raiseruntimeerror(\"計算期別請超過五期\");

value1=linearregslope(price,length);

value2=linearregslope(index1,length);

if value1\>0 and value2\<0

then deviate=-1

else

if value1\<0 and value2\>0

then deviate=1

else

deviate=0;

## 場景 542：選股常用語的對應程式集(二) --- 五，盤整後價量都創區間新高

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：五，盤整後價量都創區間新高

input:period(20,\"盤整的天數\");

input:day(2,\"創高的期別\");

input:ratio(5,\"盤整的最大波動範圍\");

if highest(close,period)\[1\]\<lowest(close,period)\[1\]\*(1+ratio/100)

//過去一段期間上下震盪不到一定的百分比

and close \> highest(high,day)\[1\]

//價過兩日高

and volume \>average(volume,day)\[1\]

//量比兩日多

and close\>average(close,5)

//站上五日均線

then ret=1;

## 場景 543：選股常用語的對應程式集(二)

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：六，籌碼被收集中

value1=GetField(\"買進公司家數\",\"D\");

value2=GetField(\"賣出公司家數\",\"D\");

input:day(10,\"計算天數\");

input:count(6,\"符合條件天數\");

if countif(value1\<value2,day)\>=count

then ret=1;

## 場景 544：選股常用語的對應程式集(二) --- 七，排除特定行業的寫法

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：七，排除特定行業的寫法

settotalbar(1);

input:exclude_1(0, \"排除XQ建築\");

input:exclude_2(0, \"排除XQ金融\");

input:exclude_3(0, \"排除XQ航運\");

variable: XQ_group (callfunction(\"XQ_類股\"));

variable: XS_industry_group (callfunction(\"XS_行業組\"));

variable: XS_industry (callfunction(\"XS_行業\"));

variable: XS_sub_industry (callfunction(\"XS_子行業\"));

condition1 = true;

if exclude_1 = 1 and XQ_group = \"建材營造\" then condition1 = false;

if exclude_2 = 1 and XQ_group = \"金融保險\" then condition1 = false;

if exclude_3 = 1 and XQ_group = \"航運業\" then condition1 = false;

if condition1 = true then ret = 1;

outputfield(1, XQ_group, 0, \"XQ 類股\");

## 場景 545：選股常用語的對應程式集(二)

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：函數的腳本如下

Switch(Symbol)

Begin

case \"1101.TW\" : retval = \"水泥\";

case \"1102.TW\" : retval = \"水泥\";

case \"1103.TW\" : retval = \"水泥\";

case \"1104.TW\" : retval = \"水泥\";

case \"1108.TW\" : retval = \"水泥\";

case \"1109.TW\" : retval = \"水泥\";

case \"1110.TW\" : retval = \"水泥\";

case \"1201.TW\" : retval = \"食品\";

case \"1203.TW\" : retval = \"食品\";

case \"1210.TW\" : retval = \"食品\";

case \"1213.TW\" : retval = \"食品\";

case \"1215.TW\" : retval = \"食品\";

case \"1216.TW\" : retval = \"食品\";

case \"1217.TW\" : retval = \"食品\";

case \"1218.TW\" : retval = \"食品\";

case \"1219.TW\" : retval = \"食品\";

case \"1220.TW\" : retval = \"食品\";

case \"1225.TW\" : retval = \"食品\";

case \"1227.TW\" : retval = \"食品\";

case \"1229.TW\" : retval = \"食品\";

case \"1231.TW\" : retval = \"食品\";

case \"1232.TW\" : retval = \"食品\";

case \"1233.TW\" : retval = \"食品\";

case \"1234.TW\" : retval = \"食品\";

case \"1235.TW\" : retval = \"食品\";

case \"1236.TW\" : retval = \"食品\";

case \"1256.TW\" : retval = \"食品\";

case \"1702.TW\" : retval = \"食品\";

case \"1737.TW\" : retval = \"食品\";

case \"1258.TW\" : retval = \"食品\";

case \"1264.TW\" : retval = \"食品\";

case \"4205.TW\" : retval = \"食品\";

case \"4207.TW\" : retval = \"食品\";

case \"4712.TW\" : retval = \"食品\";

case \"1301.TW\" : retval = \"塑膠\";

case \"1303.TW\" : retval = \"塑膠\";

case \"1304.TW\" : retval = \"塑膠\";

case \"1305.TW\" : retval = \"塑膠\";

case \"1307.TW\" : retval = \"塑膠\";

case \"1308.TW\" : retval = \"塑膠\";

case \"1309.TW\" : retval = \"塑膠\";

case \"1310.TW\" : retval = \"塑膠\";

case \"1312.TW\" : retval = \"塑膠\";

case \"1313.TW\" : retval = \"塑膠\";

case \"1314.TW\" : retval = \"塑膠\";

case \"1315.TW\" : retval = \"塑膠\";

case \"1319.TW\" : retval = \"塑膠\";

case \"1321.TW\" : retval = \"塑膠\";

case \"1323.TW\" : retval = \"塑膠\";

case \"1324.TW\" : retval = \"塑膠\";

case \"1325.TW\" : retval = \"塑膠\";

case \"1326.TW\" : retval = \"塑膠\";

case \"1337.TW\" : retval = \"塑膠\";

case \"1339.TW\" : retval = \"塑膠\";

case \"1340.TW\" : retval = \"塑膠\";

case \"4306.TW\" : retval = \"塑膠\";

case \"4303.TW\" : retval = \"塑膠\";

case \"4304.TW\" : retval = \"塑膠\";

case \"4305.TW\" : retval = \"塑膠\";

case \"8354.TW\" : retval = \"塑膠\";

case \"9950.TW\" : retval = \"塑膠\";

case \"1402.TW\" : retval = \"紡織纖維\";

case \"1409.TW\" : retval = \"紡織纖維\";

case \"1410.TW\" : retval = \"紡織纖維\";

case \"1413.TW\" : retval = \"紡織纖維\";

case \"1414.TW\" : retval = \"紡織纖維\";

case \"1416.TW\" : retval = \"紡織纖維\";

case \"1417.TW\" : retval = \"紡織纖維\";

case \"1418.TW\" : retval = \"紡織纖維\";

case \"1419.TW\" : retval = \"紡織纖維\";

case \"1423.TW\" : retval = \"紡織纖維\";

case \"1434.TW\" : retval = \"紡織纖維\";

case \"1439.TW\" : retval = \"紡織纖維\";

case \"1440.TW\" : retval = \"紡織纖維\";

case \"1441.TW\" : retval = \"紡織纖維\";

case \"1443.TW\" : retval = \"紡織纖維\";

case \"1444.TW\" : retval = \"紡織纖維\";

case \"1445.TW\" : retval = \"紡織纖維\";

case \"1446.TW\" : retval = \"紡織纖維\";

case \"1447.TW\" : retval = \"紡織纖維\";

case \"1449.TW\" : retval = \"紡織纖維\";

case \"1451.TW\" : retval = \"紡織纖維\";

case \"1452.TW\" : retval = \"紡織纖維\";

case \"1453.TW\" : retval = \"紡織纖維\";

case \"1454.TW\" : retval = \"紡織纖維\";

case \"1455.TW\" : retval = \"紡織纖維\";

case \"1456.TW\" : retval = \"紡織纖維\";

case \"1457.TW\" : retval = \"紡織纖維\";

case \"1459.TW\" : retval = \"紡織纖維\";

case \"1460.TW\" : retval = \"紡織纖維\";

case \"1463.TW\" : retval = \"紡織纖維\";

case \"1464.TW\" : retval = \"紡織纖維\";

case \"1465.TW\" : retval = \"紡織纖維\";

case \"1466.TW\" : retval = \"紡織纖維\";

case \"1467.TW\" : retval = \"紡織纖維\";

case \"1468.TW\" : retval = \"紡織纖維\";

case \"1469.TW\" : retval = \"紡織纖維\";

case \"1470.TW\" : retval = \"紡織纖維\";

case \"1472.TW\" : retval = \"紡織纖維\";

case \"1473.TW\" : retval = \"紡織纖維\";

case \"1474.TW\" : retval = \"紡織纖維\";

case \"1475.TW\" : retval = \"紡織纖維\";

case \"1476.TW\" : retval = \"紡織纖維\";

case \"1477.TW\" : retval = \"紡織纖維\";

case \"4414.TW\" : retval = \"紡織纖維\";

case \"4426.TW\" : retval = \"紡織纖維\";

case \"4438.TW\" : retval = \"紡織纖維\";

case \"4401.TW\" : retval = \"紡織纖維\";

case \"4402.TW\" : retval = \"紡織纖維\";

case \"4406.TW\" : retval = \"紡織纖維\";

case \"4413.TW\" : retval = \"紡織纖維\";

case \"4417.TW\" : retval = \"紡織纖維\";

case \"4419.TW\" : retval = \"紡織纖維\";

case \"4420.TW\" : retval = \"紡織纖維\";

case \"4429.TW\" : retval = \"紡織纖維\";

case \"4432.TW\" : retval = \"紡織纖維\";

case \"4433.TW\" : retval = \"紡織纖維\";

case \"1503.TW\" : retval = \"電機機械\";

case \"1504.TW\" : retval = \"電機機械\";

case \"1506.TW\" : retval = \"電機機械\";

case \"1507.TW\" : retval = \"電機機械\";

case \"1512.TW\" : retval = \"電機機械\";

case \"1513.TW\" : retval = \"電機機械\";

case \"1514.TW\" : retval = \"電機機械\";

case \"1515.TW\" : retval = \"電機機械\";

case \"1517.TW\" : retval = \"電機機械\";

case \"1519.TW\" : retval = \"電機機械\";

case \"1521.TW\" : retval = \"電機機械\";

case \"1522.TW\" : retval = \"電機機械\";

case \"1524.TW\" : retval = \"電機機械\";

case \"1525.TW\" : retval = \"電機機械\";

case \"1526.TW\" : retval = \"電機機械\";

case \"1527.TW\" : retval = \"電機機械\";

case \"1528.TW\" : retval = \"電機機械\";

case \"1529.TW\" : retval = \"電機機械\";

case \"1530.TW\" : retval = \"電機機械\";

case \"1531.TW\" : retval = \"電機機械\";

case \"1532.TW\" : retval = \"電機機械\";

case \"1533.TW\" : retval = \"電機機械\";

case \"1535.TW\" : retval = \"電機機械\";

case \"1536.TW\" : retval = \"電機機械\";

case \"1537.TW\" : retval = \"電機機械\";

case \"1538.TW\" : retval = \"電機機械\";

case \"1539.TW\" : retval = \"電機機械\";

case \"1540.TW\" : retval = \"電機機械\";

case \"1541.TW\" : retval = \"電機機械\";

case \"1558.TW\" : retval = \"電機機械\";

case \"1560.TW\" : retval = \"電機機械\";

case \"1568.TW\" : retval = \"電機機械\";

case \"1583.TW\" : retval = \"電機機械\";

case \"1589.TW\" : retval = \"電機機械\";

case \"1590.TW\" : retval = \"電機機械\";

case \"1592.TW\" : retval = \"電機機械\";

case \"2049.TW\" : retval = \"電機機械\";

case \"2228.TW\" : retval = \"電機機械\";

case \"2231.TW\" : retval = \"電機機械\";

case \"2236.TW\" : retval = \"電機機械\";

case \"2371.TW\" : retval = \"電機機械\";

case \"3167.TW\" : retval = \"電機機械\";

case \"4526.TW\" : retval = \"電機機械\";

case \"4532.TW\" : retval = \"電機機械\";

case \"4551.TW\" : retval = \"電機機械\";

case \"4552.TW\" : retval = \"電機機械\";

case \"4555.TW\" : retval = \"電機機械\";

case \"4557.TW\" : retval = \"電機機械\";

case \"4560.TW\" : retval = \"電機機械\";

case \"4562.TW\" : retval = \"電機機械\";

case \"5288.TW\" : retval = \"電機機械\";

case \"6605.TW\" : retval = \"電機機械\";

case \"8222.TW\" : retval = \"電機機械\";

case \"8374.TW\" : retval = \"電機機械\";

case \"8996.TW\" : retval = \"電機機械\";

case \"1566.TW\" : retval = \"電機機械\";

case \"1570.TW\" : retval = \"電機機械\";

case \"1580.TW\" : retval = \"電機機械\";

case \"1586.TW\" : retval = \"電機機械\";

case \"1591.TW\" : retval = \"電機機械\";

case \"1597.TW\" : retval = \"電機機械\";

case \"1599.TW\" : retval = \"電機機械\";

case \"2066.TW\" : retval = \"電機機械\";

case \"2067.TW\" : retval = \"電機機械\";

case \"2230.TW\" : retval = \"電機機械\";

case \"2233.TW\" : retval = \"電機機械\";

case \"2235.TW\" : retval = \"電機機械\";

case \"3162.TW\" : retval = \"電機機械\";

case \"3226.TW\" : retval = \"電機機械\";

case \"3379.TW\" : retval = \"電機機械\";

case \"3426.TW\" : retval = \"電機機械\";

case \"4502.TW\" : retval = \"電機機械\";

case \"4503.TW\" : retval = \"電機機械\";

case \"4506.TW\" : retval = \"電機機械\";

case \"4510.TW\" : retval = \"電機機械\";

case \"4513.TW\" : retval = \"電機機械\";

case \"4523.TW\" : retval = \"電機機械\";

case \"4527.TW\" : retval = \"電機機械\";

case \"4528.TW\" : retval = \"電機機械\";

case \"4530.TW\" : retval = \"電機機械\";

case \"4533.TW\" : retval = \"電機機械\";

case \"4534.TW\" : retval = \"電機機械\";

case \"4535.TW\" : retval = \"電機機械\";

case \"4543.TW\" : retval = \"電機機械\";

case \"4549.TW\" : retval = \"電機機械\";

case \"4550.TW\" : retval = \"電機機械\";

case \"6122.TW\" : retval = \"電機機械\";

case \"6603.TW\" : retval = \"電機機械\";

case \"6609.TW\" : retval = \"電機機械\";

case \"8027.TW\" : retval = \"電機機械\";

case \"8083.TW\" : retval = \"電機機械\";

case \"8107.TW\" : retval = \"電機機械\";

case \"8255.TW\" : retval = \"電機機械\";

case \"9951.TW\" : retval = \"電機機械\";

case \"1603.TW\" : retval = \"電器電纜\";

case \"1604.TW\" : retval = \"電器電纜\";

case \"1605.TW\" : retval = \"電器電纜\";

case \"1608.TW\" : retval = \"電器電纜\";

case \"1609.TW\" : retval = \"電器電纜\";

case \"1611.TW\" : retval = \"電器電纜\";

case \"1612.TW\" : retval = \"電器電纜\";

case \"1614.TW\" : retval = \"電器電纜\";

case \"1615.TW\" : retval = \"電器電纜\";

case \"1616.TW\" : retval = \"電器電纜\";

case \"1617.TW\" : retval = \"電器電纜\";

case \"1618.TW\" : retval = \"電器電纜\";

case \"1626.TW\" : retval = \"電器電纜\";

case \"4930.TW\" : retval = \"電器電纜\";

case \"2061.TW\" : retval = \"電器電纜\";

case \"4609.TW\" : retval = \"電器電纜\";

case \"1316.TW\" : retval = \"化工\";

case \"1704.TW\" : retval = \"化工\";

case \"1708.TW\" : retval = \"化工\";

case \"1709.TW\" : retval = \"化工\";

case \"1710.TW\" : retval = \"化工\";

case \"1711.TW\" : retval = \"化工\";

case \"1712.TW\" : retval = \"化工\";

case \"1713.TW\" : retval = \"化工\";

case \"1714.TW\" : retval = \"化工\";

case \"1717.TW\" : retval = \"化工\";

case \"1718.TW\" : retval = \"化工\";

case \"1721.TW\" : retval = \"化工\";

case \"1722.TW\" : retval = \"化工\";

case \"1723.TW\" : retval = \"化工\";

case \"1724.TW\" : retval = \"化工\";

case \"1725.TW\" : retval = \"化工\";

case \"1726.TW\" : retval = \"化工\";

case \"1727.TW\" : retval = \"化工\";

case \"1730.TW\" : retval = \"化工\";

case \"1732.TW\" : retval = \"化工\";

case \"1735.TW\" : retval = \"化工\";

case \"1773.TW\" : retval = \"化工\";

case \"1776.TW\" : retval = \"化工\";

case \"3708.TW\" : retval = \"化工\";

case \"4720.TW\" : retval = \"化工\";

case \"4722.TW\" : retval = \"化工\";

case \"4725.TW\" : retval = \"化工\";

case \"4739.TW\" : retval = \"化工\";

case \"4755.TW\" : retval = \"化工\";

case \"4763.TW\" : retval = \"化工\";

case \"1742.TW\" : retval = \"化工\";

case \"1787.TW\" : retval = \"化工\";

case \"4702.TW\" : retval = \"化工\";

case \"4706.TW\" : retval = \"化工\";

case \"4707.TW\" : retval = \"化工\";

case \"4711.TW\" : retval = \"化工\";

case \"4714.TW\" : retval = \"化工\";

case \"4716.TW\" : retval = \"化工\";

case \"4721.TW\" : retval = \"化工\";

case \"4741.TW\" : retval = \"化工\";

case \"4754.TW\" : retval = \"化工\";

case \"6506.TW\" : retval = \"化工\";

case \"6509.TW\" : retval = \"化工\";

case \"1598.TW\" : retval = \"生技醫療\";

case \"1701.TW\" : retval = \"生技醫療\";

case \"1707.TW\" : retval = \"生技醫療\";

case \"1720.TW\" : retval = \"生技醫療\";

case \"1731.TW\" : retval = \"生技醫療\";

case \"1733.TW\" : retval = \"生技醫療\";

case \"1734.TW\" : retval = \"生技醫療\";

case \"1736.TW\" : retval = \"生技醫療\";

case \"1762.TW\" : retval = \"生技醫療\";

case \"1783.TW\" : retval = \"生技醫療\";

case \"1786.TW\" : retval = \"生技醫療\";

case \"1789.TW\" : retval = \"生技醫療\";

case \"3164.TW\" : retval = \"生技醫療\";

case \"3705.TW\" : retval = \"生技醫療\";

case \"4104.TW\" : retval = \"生技醫療\";

case \"4106.TW\" : retval = \"生技醫療\";

case \"4108.TW\" : retval = \"生技醫療\";

case \"4119.TW\" : retval = \"生技醫療\";

case \"4133.TW\" : retval = \"生技醫療\";

case \"4137.TW\" : retval = \"生技醫療\";

case \"4141.TW\" : retval = \"生技醫療\";

case \"4142.TW\" : retval = \"生技醫療\";

case \"4144.TW\" : retval = \"生技醫療\";

case \"4148.TW\" : retval = \"生技醫療\";

case \"4155.TW\" : retval = \"生技醫療\";

case \"4164.TW\" : retval = \"生技醫療\";

case \"4190.TW\" : retval = \"生技醫療\";

case \"4737.TW\" : retval = \"生技醫療\";

case \"4746.TW\" : retval = \"生技醫療\";

case \"6452.TW\" : retval = \"生技醫療\";

case \"6541.TW\" : retval = \"生技醫療\";

case \"1565.TW\" : retval = \"生技醫療\";

case \"1593.TW\" : retval = \"生技醫療\";

case \"1752.TW\" : retval = \"生技醫療\";

case \"1777.TW\" : retval = \"生技醫療\";

case \"1781.TW\" : retval = \"生技醫療\";

case \"1784.TW\" : retval = \"生技醫療\";

case \"1788.TW\" : retval = \"生技醫療\";

case \"1795.TW\" : retval = \"生技醫療\";

case \"1799.TW\" : retval = \"生技醫療\";

case \"1813.TW\" : retval = \"生技醫療\";

case \"3118.TW\" : retval = \"生技醫療\";

case \"3176.TW\" : retval = \"生技醫療\";

case \"3205.TW\" : retval = \"生技醫療\";

case \"3218.TW\" : retval = \"生技醫療\";

case \"4102.TW\" : retval = \"生技醫療\";

case \"4103.TW\" : retval = \"生技醫療\";

case \"4105.TW\" : retval = \"生技醫療\";

case \"4107.TW\" : retval = \"生技醫療\";

case \"4109.TW\" : retval = \"生技醫療\";

case \"4111.TW\" : retval = \"生技醫療\";

case \"4114.TW\" : retval = \"生技醫療\";

case \"4116.TW\" : retval = \"生技醫療\";

case \"4120.TW\" : retval = \"生技醫療\";

case \"4121.TW\" : retval = \"生技醫療\";

case \"4123.TW\" : retval = \"生技醫療\";

case \"4126.TW\" : retval = \"生技醫療\";

case \"4127.TW\" : retval = \"生技醫療\";

case \"4128.TW\" : retval = \"生技醫療\";

case \"4129.TW\" : retval = \"生技醫療\";

case \"4130.TW\" : retval = \"生技醫療\";

case \"4131.TW\" : retval = \"生技醫療\";

case \"4138.TW\" : retval = \"生技醫療\";

case \"4139.TW\" : retval = \"生技醫療\";

case \"4147.TW\" : retval = \"生技醫療\";

case \"4152.TW\" : retval = \"生技醫療\";

case \"4153.TW\" : retval = \"生技醫療\";

case \"4154.TW\" : retval = \"生技醫療\";

case \"4157.TW\" : retval = \"生技醫療\";

case \"4160.TW\" : retval = \"生技醫療\";

case \"4161.TW\" : retval = \"生技醫療\";

case \"4162.TW\" : retval = \"生技醫療\";

case \"4163.TW\" : retval = \"生技醫療\";

case \"4167.TW\" : retval = \"生技醫療\";

case \"4168.TW\" : retval = \"生技醫療\";

case \"4173.TW\" : retval = \"生技醫療\";

case \"4174.TW\" : retval = \"生技醫療\";

case \"4175.TW\" : retval = \"生技醫療\";

case \"4180.TW\" : retval = \"生技醫療\";

case \"4183.TW\" : retval = \"生技醫療\";

case \"4188.TW\" : retval = \"生技醫療\";

case \"4192.TW\" : retval = \"生技醫療\";

case \"4198.TW\" : retval = \"生技醫療\";

case \"4726.TW\" : retval = \"生技醫療\";

case \"4728.TW\" : retval = \"生技醫療\";

case \"4735.TW\" : retval = \"生技醫療\";

case \"4736.TW\" : retval = \"生技醫療\";

case \"4743.TW\" : retval = \"生技醫療\";

case \"4745.TW\" : retval = \"生技醫療\";

case \"4747.TW\" : retval = \"生技醫療\";

case \"4911.TW\" : retval = \"生技醫療\";

case \"6130.TW\" : retval = \"生技醫療\";

case \"6242.TW\" : retval = \"生技醫療\";

case \"6446.TW\" : retval = \"生技醫療\";

case \"6469.TW\" : retval = \"生技醫療\";

case \"6472.TW\" : retval = \"生技醫療\";

case \"6492.TW\" : retval = \"生技醫療\";

case \"6496.TW\" : retval = \"生技醫療\";

case \"6497.TW\" : retval = \"生技醫療\";

case \"6499.TW\" : retval = \"生技醫療\";

case \"6523.TW\" : retval = \"生技醫療\";

case \"6535.TW\" : retval = \"生技醫療\";

case \"6554.TW\" : retval = \"生技醫療\";

case \"6569.TW\" : retval = \"生技醫療\";

case \"6574.TW\" : retval = \"生技醫療\";

case \"8279.TW\" : retval = \"生技醫療\";

case \"8403.TW\" : retval = \"生技醫療\";

case \"8406.TW\" : retval = \"生技醫療\";

case \"8409.TW\" : retval = \"生技醫療\";

case \"8432.TW\" : retval = \"生技醫療\";

case \"8436.TW\" : retval = \"生技醫療\";

case \"1802.TW\" : retval = \"玻璃陶瓷\";

case \"1806.TW\" : retval = \"玻璃陶瓷\";

case \"1809.TW\" : retval = \"玻璃陶瓷\";

case \"1810.TW\" : retval = \"玻璃陶瓷\";

case \"1817.TW\" : retval = \"玻璃陶瓷\";

case \"1902.TW\" : retval = \"造紙\";

case \"1903.TW\" : retval = \"造紙\";

case \"1904.TW\" : retval = \"造紙\";

case \"1905.TW\" : retval = \"造紙\";

case \"1906.TW\" : retval = \"造紙\";

case \"1907.TW\" : retval = \"造紙\";

case \"1909.TW\" : retval = \"造紙\";

case \"2002.TW\" : retval = \"鋼鐵\";

case \"2006.TW\" : retval = \"鋼鐵\";

case \"2007.TW\" : retval = \"鋼鐵\";

case \"2008.TW\" : retval = \"鋼鐵\";

case \"2009.TW\" : retval = \"鋼鐵\";

case \"2010.TW\" : retval = \"鋼鐵\";

case \"2012.TW\" : retval = \"鋼鐵\";

case \"2013.TW\" : retval = \"鋼鐵\";

case \"2014.TW\" : retval = \"鋼鐵\";

case \"2015.TW\" : retval = \"鋼鐵\";

case \"2017.TW\" : retval = \"鋼鐵\";

case \"2020.TW\" : retval = \"鋼鐵\";

case \"2022.TW\" : retval = \"鋼鐵\";

case \"2023.TW\" : retval = \"鋼鐵\";

case \"2024.TW\" : retval = \"鋼鐵\";

case \"2025.TW\" : retval = \"鋼鐵\";

case \"2027.TW\" : retval = \"鋼鐵\";

case \"2028.TW\" : retval = \"鋼鐵\";

case \"2029.TW\" : retval = \"鋼鐵\";

case \"2030.TW\" : retval = \"鋼鐵\";

case \"2031.TW\" : retval = \"鋼鐵\";

case \"2032.TW\" : retval = \"鋼鐵\";

case \"2033.TW\" : retval = \"鋼鐵\";

case \"2034.TW\" : retval = \"鋼鐵\";

case \"2038.TW\" : retval = \"鋼鐵\";

case \"2069.TW\" : retval = \"鋼鐵\";

case \"3004.TW\" : retval = \"鋼鐵\";

case \"5007.TW\" : retval = \"鋼鐵\";

case \"5538.TW\" : retval = \"鋼鐵\";

case \"9958.TW\" : retval = \"鋼鐵\";

case \"2035.TW\" : retval = \"鋼鐵\";

case \"2063.TW\" : retval = \"鋼鐵\";

case \"2064.TW\" : retval = \"鋼鐵\";

case \"2065.TW\" : retval = \"鋼鐵\";

case \"5009.TW\" : retval = \"鋼鐵\";

case \"5011.TW\" : retval = \"鋼鐵\";

case \"5013.TW\" : retval = \"鋼鐵\";

case \"5014.TW\" : retval = \"鋼鐵\";

case \"5015.TW\" : retval = \"鋼鐵\";

case \"5016.TW\" : retval = \"鋼鐵\";

case \"6248.TW\" : retval = \"鋼鐵\";

case \"8349.TW\" : retval = \"鋼鐵\";

case \"8415.TW\" : retval = \"鋼鐵\";

case \"8930.TW\" : retval = \"鋼鐵\";

case \"9962.TW\" : retval = \"鋼鐵\";

case \"2101.TW\" : retval = \"橡膠\";

case \"2102.TW\" : retval = \"橡膠\";

case \"2103.TW\" : retval = \"橡膠\";

case \"2104.TW\" : retval = \"橡膠\";

case \"2105.TW\" : retval = \"橡膠\";

case \"2106.TW\" : retval = \"橡膠\";

case \"2107.TW\" : retval = \"橡膠\";

case \"2108.TW\" : retval = \"橡膠\";

case \"2109.TW\" : retval = \"橡膠\";

case \"2114.TW\" : retval = \"橡膠\";

case \"2115.TW\" : retval = \"橡膠\";

case \"6582.TW\" : retval = \"橡膠\";

case \"5102.TW\" : retval = \"橡膠\";

case \"1338.TW\" : retval = \"汽車\";

case \"2201.TW\" : retval = \"汽車\";

case \"2204.TW\" : retval = \"汽車\";

case \"2206.TW\" : retval = \"汽車\";

case \"2207.TW\" : retval = \"汽車\";

case \"2227.TW\" : retval = \"汽車\";

case \"2239.TW\" : retval = \"汽車\";

case \"2243.TW\" : retval = \"汽車\";

case \"3346.TW\" : retval = \"汽車\";

case \"1437.TW\" : retval = \"半導體\";

case \"2302.TW\" : retval = \"半導體\";

case \"2303.TW\" : retval = \"半導體\";

case \"2311.TW\" : retval = \"半導體\";

case \"2325.TW\" : retval = \"半導體\";

case \"2329.TW\" : retval = \"半導體\";

case \"2330.TW\" : retval = \"半導體\";

case \"2337.TW\" : retval = \"半導體\";

case \"2338.TW\" : retval = \"半導體\";

case \"2342.TW\" : retval = \"半導體\";

case \"2344.TW\" : retval = \"半導體\";

case \"2351.TW\" : retval = \"半導體\";

case \"2363.TW\" : retval = \"半導體\";

case \"2369.TW\" : retval = \"半導體\";

case \"2379.TW\" : retval = \"半導體\";

case \"2388.TW\" : retval = \"半導體\";

case \"2401.TW\" : retval = \"半導體\";

case \"2408.TW\" : retval = \"半導體\";

case \"2434.TW\" : retval = \"半導體\";

case \"2436.TW\" : retval = \"半導體\";

case \"2441.TW\" : retval = \"半導體\";

case \"2449.TW\" : retval = \"半導體\";

case \"2451.TW\" : retval = \"半導體\";

case \"2454.TW\" : retval = \"半導體\";

case \"2458.TW\" : retval = \"半導體\";

case \"2481.TW\" : retval = \"半導體\";

case \"3006.TW\" : retval = \"半導體\";

case \"3014.TW\" : retval = \"半導體\";

case \"3016.TW\" : retval = \"半導體\";

case \"3034.TW\" : retval = \"半導體\";

case \"3035.TW\" : retval = \"半導體\";

case \"3041.TW\" : retval = \"半導體\";

case \"3054.TW\" : retval = \"半導體\";

case \"3094.TW\" : retval = \"半導體\";

case \"3189.TW\" : retval = \"半導體\";

case \"3257.TW\" : retval = \"半導體\";

case \"3413.TW\" : retval = \"半導體\";

case \"3443.TW\" : retval = \"半導體\";

case \"3519.TW\" : retval = \"半導體\";

case \"3532.TW\" : retval = \"半導體\";

case \"3536.TW\" : retval = \"半導體\";

case \"3545.TW\" : retval = \"半導體\";

case \"3579.TW\" : retval = \"半導體\";

case \"3583.TW\" : retval = \"半導體\";

case \"3588.TW\" : retval = \"半導體\";

case \"3661.TW\" : retval = \"半導體\";

case \"3686.TW\" : retval = \"半導體\";

case \"4919.TW\" : retval = \"半導體\";

case \"4952.TW\" : retval = \"半導體\";

case \"4968.TW\" : retval = \"半導體\";

case \"5269.TW\" : retval = \"半導體\";

case \"5285.TW\" : retval = \"半導體\";

case \"5305.TW\" : retval = \"半導體\";

case \"5471.TW\" : retval = \"半導體\";

case \"6202.TW\" : retval = \"半導體\";

case \"6239.TW\" : retval = \"半導體\";

case \"6243.TW\" : retval = \"半導體\";

case \"6257.TW\" : retval = \"半導體\";

case \"6271.TW\" : retval = \"半導體\";

case \"6415.TW\" : retval = \"半導體\";

case \"6451.TW\" : retval = \"半導體\";

case \"6525.TW\" : retval = \"半導體\";

case \"6531.TW\" : retval = \"半導體\";

case \"6533.TW\" : retval = \"半導體\";

case \"6552.TW\" : retval = \"半導體\";

case \"6573.TW\" : retval = \"半導體\";

case \"8016.TW\" : retval = \"半導體\";

case \"8081.TW\" : retval = \"半導體\";

case \"8110.TW\" : retval = \"半導體\";

case \"8131.TW\" : retval = \"半導體\";

case \"8150.TW\" : retval = \"半導體\";

case \"8261.TW\" : retval = \"半導體\";

case \"8271.TW\" : retval = \"半導體\";

case \"3073.TW\" : retval = \"半導體\";

case \"3105.TW\" : retval = \"半導體\";

case \"3122.TW\" : retval = \"半導體\";

case \"3141.TW\" : retval = \"半導體\";

case \"3169.TW\" : retval = \"半導體\";

case \"3188.TW\" : retval = \"半導體\";

case \"3219.TW\" : retval = \"半導體\";

case \"3227.TW\" : retval = \"半導體\";

case \"3228.TW\" : retval = \"半導體\";

case \"3259.TW\" : retval = \"半導體\";

case \"3260.TW\" : retval = \"半導體\";

case \"3264.TW\" : retval = \"半導體\";

case \"3265.TW\" : retval = \"半導體\";

case \"3268.TW\" : retval = \"半導體\";

case \"3317.TW\" : retval = \"半導體\";

case \"3372.TW\" : retval = \"半導體\";

case \"3374.TW\" : retval = \"半導體\";

case \"3438.TW\" : retval = \"半導體\";

case \"3527.TW\" : retval = \"半導體\";

case \"3529.TW\" : retval = \"半導體\";

case \"3555.TW\" : retval = \"半導體\";

case \"3556.TW\" : retval = \"半導體\";

case \"3567.TW\" : retval = \"半導體\";

case \"3581.TW\" : retval = \"半導體\";

case \"3675.TW\" : retval = \"半導體\";

case \"3680.TW\" : retval = \"半導體\";

case \"3707.TW\" : retval = \"半導體\";

case \"4947.TW\" : retval = \"半導體\";

case \"4966.TW\" : retval = \"半導體\";

case \"4971.TW\" : retval = \"半導體\";

case \"4973.TW\" : retval = \"半導體\";

case \"4991.TW\" : retval = \"半導體\";

case \"5272.TW\" : retval = \"半導體\";

case \"5274.TW\" : retval = \"半導體\";

case \"5302.TW\" : retval = \"半導體\";

case \"5314.TW\" : retval = \"半導體\";

case \"5344.TW\" : retval = \"半導體\";

case \"5347.TW\" : retval = \"半導體\";

case \"5351.TW\" : retval = \"半導體\";

case \"5425.TW\" : retval = \"半導體\";

case \"5455.TW\" : retval = \"半導體\";

case \"5468.TW\" : retval = \"半導體\";

case \"5483.TW\" : retval = \"半導體\";

case \"5487.TW\" : retval = \"半導體\";

case \"6103.TW\" : retval = \"半導體\";

case \"6104.TW\" : retval = \"半導體\";

case \"6129.TW\" : retval = \"半導體\";

case \"6138.TW\" : retval = \"半導體\";

case \"6147.TW\" : retval = \"半導體\";

case \"6182.TW\" : retval = \"半導體\";

case \"6198.TW\" : retval = \"半導體\";

case \"6223.TW\" : retval = \"半導體\";

case \"6229.TW\" : retval = \"半導體\";

case \"6233.TW\" : retval = \"半導體\";

case \"6237.TW\" : retval = \"半導體\";

case \"6261.TW\" : retval = \"半導體\";

case \"6287.TW\" : retval = \"半導體\";

case \"6291.TW\" : retval = \"半導體\";

case \"6411.TW\" : retval = \"半導體\";

case \"6435.TW\" : retval = \"半導體\";

case \"6457.TW\" : retval = \"半導體\";

case \"6462.TW\" : retval = \"半導體\";

case \"6485.TW\" : retval = \"半導體\";

case \"6488.TW\" : retval = \"半導體\";

case \"6494.TW\" : retval = \"半導體\";

case \"6510.TW\" : retval = \"半導體\";

case \"6532.TW\" : retval = \"半導體\";

case \"6568.TW\" : retval = \"半導體\";

case \"6594.TW\" : retval = \"半導體\";

case \"8024.TW\" : retval = \"半導體\";

case \"8040.TW\" : retval = \"半導體\";

case \"8054.TW\" : retval = \"半導體\";

case \"8086.TW\" : retval = \"半導體\";

case \"8088.TW\" : retval = \"半導體\";

case \"8277.TW\" : retval = \"半導體\";

case \"2301.TW\" : retval = \"電腦及週邊設備\";

case \"2305.TW\" : retval = \"電腦及週邊設備\";

case \"2324.TW\" : retval = \"電腦及週邊設備\";

case \"2331.TW\" : retval = \"電腦及週邊設備\";

case \"2352.TW\" : retval = \"電腦及週邊設備\";

case \"2353.TW\" : retval = \"電腦及週邊設備\";

case \"2356.TW\" : retval = \"電腦及週邊設備\";

case \"2357.TW\" : retval = \"電腦及週邊設備\";

case \"2362.TW\" : retval = \"電腦及週邊設備\";

case \"2364.TW\" : retval = \"電腦及週邊設備\";

case \"2365.TW\" : retval = \"電腦及週邊設備\";

case \"2376.TW\" : retval = \"電腦及週邊設備\";

case \"2377.TW\" : retval = \"電腦及週邊設備\";

case \"2380.TW\" : retval = \"電腦及週邊設備\";

case \"2382.TW\" : retval = \"電腦及週邊設備\";

case \"2387.TW\" : retval = \"電腦及週邊設備\";

case \"2395.TW\" : retval = \"電腦及週邊設備\";

case \"2397.TW\" : retval = \"電腦及週邊設備\";

case \"2399.TW\" : retval = \"電腦及週邊設備\";

case \"2405.TW\" : retval = \"電腦及週邊設備\";

case \"2417.TW\" : retval = \"電腦及週邊設備\";

case \"2424.TW\" : retval = \"電腦及週邊設備\";

case \"2425.TW\" : retval = \"電腦及週邊設備\";

case \"2442.TW\" : retval = \"電腦及週邊設備\";

case \"2465.TW\" : retval = \"電腦及週邊設備\";

case \"3002.TW\" : retval = \"電腦及週邊設備\";

case \"3005.TW\" : retval = \"電腦及週邊設備\";

case \"3013.TW\" : retval = \"電腦及週邊設備\";

case \"3017.TW\" : retval = \"電腦及週邊設備\";

case \"3022.TW\" : retval = \"電腦及週邊設備\";

case \"3046.TW\" : retval = \"電腦及週邊設備\";

case \"3057.TW\" : retval = \"電腦及週邊設備\";

case \"3060.TW\" : retval = \"電腦及週邊設備\";

case \"3231.TW\" : retval = \"電腦及週邊設備\";

case \"3416.TW\" : retval = \"電腦及週邊設備\";

case \"3494.TW\" : retval = \"電腦及週邊設備\";

case \"3515.TW\" : retval = \"電腦及週邊設備\";

case \"3701.TW\" : retval = \"電腦及週邊設備\";

case \"3706.TW\" : retval = \"電腦及週邊設備\";

case \"4916.TW\" : retval = \"電腦及週邊設備\";

case \"4938.TW\" : retval = \"電腦及週邊設備\";

case \"5215.TW\" : retval = \"電腦及週邊設備\";

case \"5258.TW\" : retval = \"電腦及週邊設備\";

case \"5264.TW\" : retval = \"電腦及週邊設備\";

case \"6117.TW\" : retval = \"電腦及週邊設備\";

case \"6128.TW\" : retval = \"電腦及週邊設備\";

case \"6166.TW\" : retval = \"電腦及週邊設備\";

case \"6172.TW\" : retval = \"電腦及週邊設備\";

case \"6206.TW\" : retval = \"電腦及週邊設備\";

case \"6230.TW\" : retval = \"電腦及週邊設備\";

case \"6235.TW\" : retval = \"電腦及週邊設備\";

case \"6277.TW\" : retval = \"電腦及週邊設備\";

case \"6414.TW\" : retval = \"電腦及週邊設備\";

case \"6579.TW\" : retval = \"電腦及週邊設備\";

case \"6591.TW\" : retval = \"電腦及週邊設備\";

case \"8114.TW\" : retval = \"電腦及週邊設備\";

case \"8163.TW\" : retval = \"電腦及週邊設備\";

case \"8210.TW\" : retval = \"電腦及週邊設備\";

case \"9912.TW\" : retval = \"電腦及週邊設備\";

case \"1569.TW\" : retval = \"電腦及週邊設備\";

case \"3071.TW\" : retval = \"電腦及週邊設備\";

case \"3088.TW\" : retval = \"電腦及週邊設備\";

case \"3211.TW\" : retval = \"電腦及週邊設備\";

case \"3213.TW\" : retval = \"電腦及週邊設備\";

case \"3272.TW\" : retval = \"電腦及週邊設備\";

case \"3287.TW\" : retval = \"電腦及週邊設備\";

case \"3323.TW\" : retval = \"電腦及週邊設備\";

case \"3325.TW\" : retval = \"電腦及週邊設備\";

case \"3479.TW\" : retval = \"電腦及週邊設備\";

case \"3483.TW\" : retval = \"電腦及週邊設備\";

case \"3521.TW\" : retval = \"電腦及週邊設備\";

case \"3540.TW\" : retval = \"電腦及週邊設備\";

case \"3577.TW\" : retval = \"電腦及週邊設備\";

case \"3594.TW\" : retval = \"電腦及週邊設備\";

case \"3611.TW\" : retval = \"電腦及週邊設備\";

case \"3625.TW\" : retval = \"電腦及週邊設備\";

case \"3652.TW\" : retval = \"電腦及週邊設備\";

case \"3693.TW\" : retval = \"電腦及週邊設備\";

case \"3709.TW\" : retval = \"電腦及週邊設備\";

case \"4924.TW\" : retval = \"電腦及週邊設備\";

case \"4987.TW\" : retval = \"電腦及週邊設備\";

case \"5289.TW\" : retval = \"電腦及週邊設備\";

case \"5304.TW\" : retval = \"電腦及週邊設備\";

case \"5356.TW\" : retval = \"電腦及週邊設備\";

case \"5386.TW\" : retval = \"電腦及週邊設備\";

case \"5426.TW\" : retval = \"電腦及週邊設備\";

case \"5438.TW\" : retval = \"電腦及週邊設備\";

case \"5450.TW\" : retval = \"電腦及週邊設備\";

case \"5465.TW\" : retval = \"電腦及週邊設備\";

case \"5474.TW\" : retval = \"電腦及週邊設備\";

case \"5490.TW\" : retval = \"電腦及週邊設備\";

case \"6121.TW\" : retval = \"電腦及週邊設備\";

case \"6123.TW\" : retval = \"電腦及週邊設備\";

case \"6150.TW\" : retval = \"電腦及週邊設備\";

case \"6160.TW\" : retval = \"電腦及週邊設備\";

case \"6161.TW\" : retval = \"電腦及週邊設備\";

case \"6188.TW\" : retval = \"電腦及週邊設備\";

case \"6222.TW\" : retval = \"電腦及週邊設備\";

case \"6228.TW\" : retval = \"電腦及週邊設備\";

case \"6276.TW\" : retval = \"電腦及週邊設備\";

case \"6298.TW\" : retval = \"電腦及週邊設備\";

case \"6441.TW\" : retval = \"電腦及週邊設備\";

case \"6570.TW\" : retval = \"電腦及週邊設備\";

case \"6577.TW\" : retval = \"電腦及週邊設備\";

case \"8050.TW\" : retval = \"電腦及週邊設備\";

case \"8076.TW\" : retval = \"電腦及週邊設備\";

case \"8234.TW\" : retval = \"電腦及週邊設備\";

case \"8299.TW\" : retval = \"電腦及週邊設備\";

case \"8410.TW\" : retval = \"電腦及週邊設備\";

case \"2323.TW\" : retval = \"光電\";

case \"2340.TW\" : retval = \"光電\";

case \"2349.TW\" : retval = \"光電\";

case \"2374.TW\" : retval = \"光電\";

case \"2393.TW\" : retval = \"光電\";

case \"2406.TW\" : retval = \"光電\";

case \"2409.TW\" : retval = \"光電\";

case \"2426.TW\" : retval = \"光電\";

case \"2438.TW\" : retval = \"光電\";

case \"2448.TW\" : retval = \"光電\";

case \"2466.TW\" : retval = \"光電\";

case \"2475.TW\" : retval = \"光電\";

case \"2486.TW\" : retval = \"光電\";

case \"2489.TW\" : retval = \"光電\";

case \"2491.TW\" : retval = \"光電\";

case \"2499.TW\" : retval = \"光電\";

case \"3008.TW\" : retval = \"光電\";

case \"3019.TW\" : retval = \"光電\";

case \"3024.TW\" : retval = \"光電\";

case \"3031.TW\" : retval = \"光電\";

case \"3038.TW\" : retval = \"光電\";

case \"3049.TW\" : retval = \"光電\";

case \"3050.TW\" : retval = \"光電\";

case \"3051.TW\" : retval = \"光電\";

case \"3059.TW\" : retval = \"光電\";

case \"3149.TW\" : retval = \"光電\";

case \"3356.TW\" : retval = \"光電\";

case \"3383.TW\" : retval = \"光電\";

case \"3406.TW\" : retval = \"光電\";

case \"3437.TW\" : retval = \"光電\";

case \"3454.TW\" : retval = \"光電\";

case \"3481.TW\" : retval = \"光電\";

case \"3504.TW\" : retval = \"光電\";

case \"3514.TW\" : retval = \"光電\";

case \"3535.TW\" : retval = \"光電\";

case \"3557.TW\" : retval = \"光電\";

case \"3561.TW\" : retval = \"光電\";

case \"3576.TW\" : retval = \"光電\";

case \"3591.TW\" : retval = \"光電\";

case \"3622.TW\" : retval = \"光電\";

case \"3669.TW\" : retval = \"光電\";

case \"3673.TW\" : retval = \"光電\";

case \"3698.TW\" : retval = \"光電\";

case \"4934.TW\" : retval = \"光電\";

case \"4935.TW\" : retval = \"光電\";

case \"4942.TW\" : retval = \"光電\";

case \"4956.TW\" : retval = \"光電\";

case \"4960.TW\" : retval = \"光電\";

case \"4976.TW\" : retval = \"光電\";

case \"5234.TW\" : retval = \"光電\";

case \"5243.TW\" : retval = \"光電\";

case \"5259.TW\" : retval = \"光電\";

case \"5484.TW\" : retval = \"光電\";

case \"6116.TW\" : retval = \"光電\";

case \"6120.TW\" : retval = \"光電\";

case \"6131.TW\" : retval = \"光電\";

case \"6164.TW\" : retval = \"光電\";

case \"6168.TW\" : retval = \"光電\";

case \"6176.TW\" : retval = \"光電\";

case \"6209.TW\" : retval = \"光電\";

case \"6225.TW\" : retval = \"光電\";

case \"6226.TW\" : retval = \"光電\";

case \"6278.TW\" : retval = \"光電\";

case \"6289.TW\" : retval = \"光電\";

case \"6405.TW\" : retval = \"光電\";

case \"6431.TW\" : retval = \"光電\";

case \"6443.TW\" : retval = \"光電\";

case \"6456.TW\" : retval = \"光電\";

case \"6477.TW\" : retval = \"光電\";

case \"8072.TW\" : retval = \"光電\";

case \"8105.TW\" : retval = \"光電\";

case \"8215.TW\" : retval = \"光電\";

case \"3066.TW\" : retval = \"光電\";

case \"3128.TW\" : retval = \"光電\";

case \"3230.TW\" : retval = \"光電\";

case \"3297.TW\" : retval = \"光電\";

case \"3339.TW\" : retval = \"光電\";

case \"3362.TW\" : retval = \"光電\";

case \"3428.TW\" : retval = \"光電\";

case \"3434.TW\" : retval = \"光電\";

case \"3441.TW\" : retval = \"光電\";

case \"3452.TW\" : retval = \"光電\";

case \"3455.TW\" : retval = \"光電\";

case \"3490.TW\" : retval = \"光電\";

case \"3516.TW\" : retval = \"光電\";

case \"3522.TW\" : retval = \"光電\";

case \"3523.TW\" : retval = \"光電\";

case \"3531.TW\" : retval = \"光電\";

case \"3562.TW\" : retval = \"光電\";

case \"3615.TW\" : retval = \"光電\";

case \"3623.TW\" : retval = \"光電\";

case \"3629.TW\" : retval = \"光電\";

case \"3630.TW\" : retval = \"光電\";

case \"3666.TW\" : retval = \"光電\";

case \"3685.TW\" : retval = \"光電\";

case \"3691.TW\" : retval = \"光電\";

case \"4729.TW\" : retval = \"光電\";

case \"4933.TW\" : retval = \"光電\";

case \"4944.TW\" : retval = \"光電\";

case \"4972.TW\" : retval = \"光電\";

case \"4995.TW\" : retval = \"光電\";

case \"5230.TW\" : retval = \"光電\";

case \"5245.TW\" : retval = \"光電\";

case \"5251.TW\" : retval = \"光電\";

case \"5281.TW\" : retval = \"光電\";

case \"5315.TW\" : retval = \"光電\";

case \"5371.TW\" : retval = \"光電\";

case \"5392.TW\" : retval = \"光電\";

case \"5432.TW\" : retval = \"光電\";

case \"5443.TW\" : retval = \"光電\";

case \"6125.TW\" : retval = \"光電\";

case \"6167.TW\" : retval = \"光電\";

case \"6234.TW\" : retval = \"光電\";

case \"6244.TW\" : retval = \"光電\";

case \"6246.TW\" : retval = \"光電\";

case \"6419.TW\" : retval = \"光電\";

case \"6548.TW\" : retval = \"光電\";

case \"6556.TW\" : retval = \"光電\";

case \"6560.TW\" : retval = \"光電\";

case \"7402.TW\" : retval = \"光電\";

case \"8049.TW\" : retval = \"光電\";

case \"8064.TW\" : retval = \"光電\";

case \"8069.TW\" : retval = \"光電\";

case \"8087.TW\" : retval = \"光電\";

case \"8111.TW\" : retval = \"光電\";

case \"8240.TW\" : retval = \"光電\";

case \"2314.TW\" : retval = \"通信網路\";

case \"2321.TW\" : retval = \"通信網路\";

case \"2332.TW\" : retval = \"通信網路\";

case \"2345.TW\" : retval = \"通信網路\";

case \"2412.TW\" : retval = \"通信網路\";

case \"2419.TW\" : retval = \"通信網路\";

case \"2439.TW\" : retval = \"通信網路\";

case \"2444.TW\" : retval = \"通信網路\";

case \"2450.TW\" : retval = \"通信網路\";

case \"2455.TW\" : retval = \"通信網路\";

case \"2485.TW\" : retval = \"通信網路\";

case \"2496.TW\" : retval = \"通信網路\";

case \"2498.TW\" : retval = \"通信網路\";

case \"3025.TW\" : retval = \"通信網路\";

case \"3027.TW\" : retval = \"通信網路\";

case \"3045.TW\" : retval = \"通信網路\";

case \"3047.TW\" : retval = \"通信網路\";

case \"3062.TW\" : retval = \"通信網路\";

case \"3311.TW\" : retval = \"通信網路\";

case \"3380.TW\" : retval = \"通信網路\";

case \"3419.TW\" : retval = \"通信網路\";

case \"3596.TW\" : retval = \"通信網路\";

case \"3682.TW\" : retval = \"通信網路\";

case \"3694.TW\" : retval = \"通信網路\";

case \"3704.TW\" : retval = \"通信網路\";

case \"4904.TW\" : retval = \"通信網路\";

case \"4906.TW\" : retval = \"通信網路\";

case \"4977.TW\" : retval = \"通信網路\";

case \"4984.TW\" : retval = \"通信網路\";

case \"5388.TW\" : retval = \"通信網路\";

case \"6136.TW\" : retval = \"通信網路\";

case \"6142.TW\" : retval = \"通信網路\";

case \"6152.TW\" : retval = \"通信網路\";

case \"6216.TW\" : retval = \"通信網路\";

case \"6283.TW\" : retval = \"通信網路\";

case \"6285.TW\" : retval = \"通信網路\";

case \"6442.TW\" : retval = \"通信網路\";

case \"8011.TW\" : retval = \"通信網路\";

case \"8101.TW\" : retval = \"通信網路\";

case \"3068.TW\" : retval = \"通信網路\";

case \"3081.TW\" : retval = \"通信網路\";

case \"3095.TW\" : retval = \"通信網路\";

case \"3152.TW\" : retval = \"通信網路\";

case \"3163.TW\" : retval = \"通信網路\";

case \"3221.TW\" : retval = \"通信網路\";

case \"3234.TW\" : retval = \"通信網路\";

case \"3290.TW\" : retval = \"通信網路\";

case \"3299.TW\" : retval = \"通信網路\";

case \"3306.TW\" : retval = \"通信網路\";

case \"3363.TW\" : retval = \"通信網路\";

case \"3431.TW\" : retval = \"通信網路\";

case \"3466.TW\" : retval = \"通信網路\";

case \"3491.TW\" : retval = \"通信網路\";

case \"3499.TW\" : retval = \"通信網路\";

case \"3558.TW\" : retval = \"通信網路\";

case \"3564.TW\" : retval = \"通信網路\";

case \"3632.TW\" : retval = \"通信網路\";

case \"3664.TW\" : retval = \"通信網路\";

case \"3672.TW\" : retval = \"通信網路\";

case \"3684.TW\" : retval = \"通信網路\";

case \"4903.TW\" : retval = \"通信網路\";

case \"4905.TW\" : retval = \"通信網路\";

case \"4908.TW\" : retval = \"通信網路\";

case \"4909.TW\" : retval = \"通信網路\";

case \"4979.TW\" : retval = \"通信網路\";

case \"5348.TW\" : retval = \"通信網路\";

case \"5353.TW\" : retval = \"通信網路\";

case \"6109.TW\" : retval = \"通信網路\";

case \"6143.TW\" : retval = \"通信網路\";

case \"6163.TW\" : retval = \"通信網路\";

case \"6170.TW\" : retval = \"通信網路\";

case \"6190.TW\" : retval = \"通信網路\";

case \"6218.TW\" : retval = \"通信網路\";

case \"6241.TW\" : retval = \"通信網路\";

case \"6245.TW\" : retval = \"通信網路\";

case \"6263.TW\" : retval = \"通信網路\";

case \"6417.TW\" : retval = \"通信網路\";

case \"6426.TW\" : retval = \"通信網路\";

case \"6465.TW\" : retval = \"通信網路\";

case \"6470.TW\" : retval = \"通信網路\";

case \"6486.TW\" : retval = \"通信網路\";

case \"6514.TW\" : retval = \"通信網路\";

case \"8034.TW\" : retval = \"通信網路\";

case \"8048.TW\" : retval = \"通信網路\";

case \"8059.TW\" : retval = \"通信網路\";

case \"8097.TW\" : retval = \"通信網路\";

case \"8171.TW\" : retval = \"通信網路\";

case \"8176.TW\" : retval = \"通信網路\";

case \"1471.TW\" : retval = \"電子零組件\";

case \"1582.TW\" : retval = \"電子零組件\";

case \"2059.TW\" : retval = \"電子零組件\";

case \"2308.TW\" : retval = \"電子零組件\";

case \"2313.TW\" : retval = \"電子零組件\";

case \"2316.TW\" : retval = \"電子零組件\";

case \"2327.TW\" : retval = \"電子零組件\";

case \"2328.TW\" : retval = \"電子零組件\";

case \"2355.TW\" : retval = \"電子零組件\";

case \"2367.TW\" : retval = \"電子零組件\";

case \"2368.TW\" : retval = \"電子零組件\";

case \"2375.TW\" : retval = \"電子零組件\";

case \"2383.TW\" : retval = \"電子零組件\";

case \"2385.TW\" : retval = \"電子零組件\";

case \"2392.TW\" : retval = \"電子零組件\";

case \"2402.TW\" : retval = \"電子零組件\";

case \"2413.TW\" : retval = \"電子零組件\";

case \"2415.TW\" : retval = \"電子零組件\";

case \"2420.TW\" : retval = \"電子零組件\";

case \"2421.TW\" : retval = \"電子零組件\";

case \"2428.TW\" : retval = \"電子零組件\";

case \"2429.TW\" : retval = \"電子零組件\";

case \"2431.TW\" : retval = \"電子零組件\";

case \"2440.TW\" : retval = \"電子零組件\";

case \"2443.TW\" : retval = \"電子零組件\";

case \"2456.TW\" : retval = \"電子零組件\";

case \"2457.TW\" : retval = \"電子零組件\";

case \"2460.TW\" : retval = \"電子零組件\";

case \"2462.TW\" : retval = \"電子零組件\";

case \"2467.TW\" : retval = \"電子零組件\";

case \"2472.TW\" : retval = \"電子零組件\";

case \"2476.TW\" : retval = \"電子零組件\";

case \"2478.TW\" : retval = \"電子零組件\";

case \"2483.TW\" : retval = \"電子零組件\";

case \"2484.TW\" : retval = \"電子零組件\";

case \"2492.TW\" : retval = \"電子零組件\";

case \"2493.TW\" : retval = \"電子零組件\";

case \"3003.TW\" : retval = \"電子零組件\";

case \"3011.TW\" : retval = \"電子零組件\";

case \"3015.TW\" : retval = \"電子零組件\";

case \"3021.TW\" : retval = \"電子零組件\";

case \"3023.TW\" : retval = \"電子零組件\";

case \"3026.TW\" : retval = \"電子零組件\";

case \"3032.TW\" : retval = \"電子零組件\";

case \"3037.TW\" : retval = \"電子零組件\";

case \"3042.TW\" : retval = \"電子零組件\";

case \"3044.TW\" : retval = \"電子零組件\";

case \"3058.TW\" : retval = \"電子零組件\";

case \"3090.TW\" : retval = \"電子零組件\";

case \"3229.TW\" : retval = \"電子零組件\";

case \"3296.TW\" : retval = \"電子零組件\";

case \"3308.TW\" : retval = \"電子零組件\";

case \"3321.TW\" : retval = \"電子零組件\";

case \"3338.TW\" : retval = \"電子零組件\";

case \"3376.TW\" : retval = \"電子零組件\";

case \"3432.TW\" : retval = \"電子零組件\";

case \"3501.TW\" : retval = \"電子零組件\";

case \"3533.TW\" : retval = \"電子零組件\";

case \"3550.TW\" : retval = \"電子零組件\";

case \"3593.TW\" : retval = \"電子零組件\";

case \"3605.TW\" : retval = \"電子零組件\";

case \"3607.TW\" : retval = \"電子零組件\";

case \"3645.TW\" : retval = \"電子零組件\";

case \"3653.TW\" : retval = \"電子零組件\";

case \"3679.TW\" : retval = \"電子零組件\";

case \"4545.TW\" : retval = \"電子零組件\";

case \"4912.TW\" : retval = \"電子零組件\";

case \"4915.TW\" : retval = \"電子零組件\";

case \"4927.TW\" : retval = \"電子零組件\";

case \"4943.TW\" : retval = \"電子零組件\";

case \"4958.TW\" : retval = \"電子零組件\";

case \"4999.TW\" : retval = \"電子零組件\";

case \"5469.TW\" : retval = \"電子零組件\";

case \"6108.TW\" : retval = \"電子零組件\";

case \"6115.TW\" : retval = \"電子零組件\";

case \"6133.TW\" : retval = \"電子零組件\";

case \"6141.TW\" : retval = \"電子零組件\";

case \"6153.TW\" : retval = \"電子零組件\";

case \"6155.TW\" : retval = \"電子零組件\";

case \"6165.TW\" : retval = \"電子零組件\";

case \"6191.TW\" : retval = \"電子零組件\";

case \"6197.TW\" : retval = \"電子零組件\";

case \"6205.TW\" : retval = \"電子零組件\";

case \"6213.TW\" : retval = \"電子零組件\";

case \"6224.TW\" : retval = \"電子零組件\";

case \"6251.TW\" : retval = \"電子零組件\";

case \"6269.TW\" : retval = \"電子零組件\";

case \"6282.TW\" : retval = \"電子零組件\";

case \"6412.TW\" : retval = \"電子零組件\";

case \"6422.TW\" : retval = \"電子零組件\";

case \"6449.TW\" : retval = \"電子零組件\";

case \"8039.TW\" : retval = \"電子零組件\";

case \"8046.TW\" : retval = \"電子零組件\";

case \"8103.TW\" : retval = \"電子零組件\";

case \"8213.TW\" : retval = \"電子零組件\";

case \"8249.TW\" : retval = \"電子零組件\";

case \"1333.TW\" : retval = \"電子零組件\";

case \"1336.TW\" : retval = \"電子零組件\";

case \"1595.TW\" : retval = \"電子零組件\";

case \"1815.TW\" : retval = \"電子零組件\";

case \"3078.TW\" : retval = \"電子零組件\";

case \"3089.TW\" : retval = \"電子零組件\";

case \"3092.TW\" : retval = \"電子零組件\";

case \"3114.TW\" : retval = \"電子零組件\";

case \"3115.TW\" : retval = \"電子零組件\";

case \"3144.TW\" : retval = \"電子零組件\";

case \"3191.TW\" : retval = \"電子零組件\";

case \"3202.TW\" : retval = \"電子零組件\";

case \"3206.TW\" : retval = \"電子零組件\";

case \"3207.TW\" : retval = \"電子零組件\";

case \"3217.TW\" : retval = \"電子零組件\";

case \"3236.TW\" : retval = \"電子零組件\";

case \"3276.TW\" : retval = \"電子零組件\";

case \"3288.TW\" : retval = \"電子零組件\";

case \"3294.TW\" : retval = \"電子零組件\";

case \"3310.TW\" : retval = \"電子零組件\";

case \"3313.TW\" : retval = \"電子零組件\";

case \"3322.TW\" : retval = \"電子零組件\";

case \"3332.TW\" : retval = \"電子零組件\";

case \"3354.TW\" : retval = \"電子零組件\";

case \"3388.TW\" : retval = \"電子零組件\";

case \"3390.TW\" : retval = \"電子零組件\";

case \"3465.TW\" : retval = \"電子零組件\";

case \"3484.TW\" : retval = \"電子零組件\";

case \"3492.TW\" : retval = \"電子零組件\";

case \"3511.TW\" : retval = \"電子零組件\";

case \"3512.TW\" : retval = \"電子零組件\";

case \"3520.TW\" : retval = \"電子零組件\";

case \"3526.TW\" : retval = \"電子零組件\";

case \"3537.TW\" : retval = \"電子零組件\";

case \"3548.TW\" : retval = \"電子零組件\";

case \"3609.TW\" : retval = \"電子零組件\";

case \"3624.TW\" : retval = \"電子零組件\";

case \"3631.TW\" : retval = \"電子零組件\";

case \"3646.TW\" : retval = \"電子零組件\";

case \"3689.TW\" : retval = \"電子零組件\";

case \"4542.TW\" : retval = \"電子零組件\";

case \"4939.TW\" : retval = \"電子零組件\";

case \"4974.TW\" : retval = \"電子零組件\";

case \"5227.TW\" : retval = \"電子零組件\";

case \"5255.TW\" : retval = \"電子零組件\";

case \"5291.TW\" : retval = \"電子零組件\";

case \"5309.TW\" : retval = \"電子零組件\";

case \"5317.TW\" : retval = \"電子零組件\";

case \"5321.TW\" : retval = \"電子零組件\";

case \"5328.TW\" : retval = \"電子零組件\";

case \"5340.TW\" : retval = \"電子零組件\";

case \"5345.TW\" : retval = \"電子零組件\";

case \"5349.TW\" : retval = \"電子零組件\";

case \"5355.TW\" : retval = \"電子零組件\";

case \"5381.TW\" : retval = \"電子零組件\";

case \"5398.TW\" : retval = \"電子零組件\";

case \"5439.TW\" : retval = \"電子零組件\";

case \"5457.TW\" : retval = \"電子零組件\";

case \"5460.TW\" : retval = \"電子零組件\";

case \"5464.TW\" : retval = \"電子零組件\";

case \"5475.TW\" : retval = \"電子零組件\";

case \"5480.TW\" : retval = \"電子零組件\";

case \"5481.TW\" : retval = \"電子零組件\";

case \"5488.TW\" : retval = \"電子零組件\";

case \"5498.TW\" : retval = \"電子零組件\";

case \"6101.TW\" : retval = \"電子零組件\";

case \"6114.TW\" : retval = \"電子零組件\";

case \"6124.TW\" : retval = \"電子零組件\";

case \"6126.TW\" : retval = \"電子零組件\";

case \"6127.TW\" : retval = \"電子零組件\";

case \"6134.TW\" : retval = \"電子零組件\";

case \"6156.TW\" : retval = \"電子零組件\";

case \"6158.TW\" : retval = \"電子零組件\";

case \"6173.TW\" : retval = \"電子零組件\";

case \"6174.TW\" : retval = \"電子零組件\";

case \"6175.TW\" : retval = \"電子零組件\";

case \"6185.TW\" : retval = \"電子零組件\";

case \"6194.TW\" : retval = \"電子零組件\";

case \"6203.TW\" : retval = \"電子零組件\";

case \"6204.TW\" : retval = \"電子零組件\";

case \"6207.TW\" : retval = \"電子零組件\";

case \"6208.TW\" : retval = \"電子零組件\";

case \"6210.TW\" : retval = \"電子零組件\";

case \"6217.TW\" : retval = \"電子零組件\";

case \"6220.TW\" : retval = \"電子零組件\";

case \"6259.TW\" : retval = \"電子零組件\";

case \"6266.TW\" : retval = \"電子零組件\";

case \"6274.TW\" : retval = \"電子零組件\";

case \"6279.TW\" : retval = \"電子零組件\";

case \"6284.TW\" : retval = \"電子零組件\";

case \"6290.TW\" : retval = \"電子零組件\";

case \"6292.TW\" : retval = \"電子零組件\";

case \"6432.TW\" : retval = \"電子零組件\";

case \"6538.TW\" : retval = \"電子零組件\";

case \"8038.TW\" : retval = \"電子零組件\";

case \"8042.TW\" : retval = \"電子零組件\";

case \"8043.TW\" : retval = \"電子零組件\";

case \"8071.TW\" : retval = \"電子零組件\";

case \"8074.TW\" : retval = \"電子零組件\";

case \"8080.TW\" : retval = \"電子零組件\";

case \"8091.TW\" : retval = \"電子零組件\";

case \"8093.TW\" : retval = \"電子零組件\";

case \"8109.TW\" : retval = \"電子零組件\";

case \"8121.TW\" : retval = \"電子零組件\";

case \"8147.TW\" : retval = \"電子零組件\";

case \"8155.TW\" : retval = \"電子零組件\";

case \"8182.TW\" : retval = \"電子零組件\";

case \"8287.TW\" : retval = \"電子零組件\";

case \"8289.TW\" : retval = \"電子零組件\";

case \"8291.TW\" : retval = \"電子零組件\";

case \"8358.TW\" : retval = \"電子零組件\";

case \"2347.TW\" : retval = \"電子通路\";

case \"2414.TW\" : retval = \"電子通路\";

case \"2430.TW\" : retval = \"電子通路\";

case \"2459.TW\" : retval = \"電子通路\";

case \"3010.TW\" : retval = \"電子通路\";

case \"3028.TW\" : retval = \"電子通路\";

case \"3033.TW\" : retval = \"電子通路\";

case \"3036.TW\" : retval = \"電子通路\";

case \"3048.TW\" : retval = \"電子通路\";

case \"3055.TW\" : retval = \"電子通路\";

case \"3209.TW\" : retval = \"電子通路\";

case \"3312.TW\" : retval = \"電子通路\";

case \"3528.TW\" : retval = \"電子通路\";

case \"3702.TW\" : retval = \"電子通路\";

case \"5434.TW\" : retval = \"電子通路\";

case \"6145.TW\" : retval = \"電子通路\";

case \"6189.TW\" : retval = \"電子通路\";

case \"6281.TW\" : retval = \"電子通路\";

case \"8070.TW\" : retval = \"電子通路\";

case \"8112.TW\" : retval = \"電子通路\";

case \"3224.TW\" : retval = \"電子通路\";

case \"3232.TW\" : retval = \"電子通路\";

case \"3360.TW\" : retval = \"電子通路\";

case \"3444.TW\" : retval = \"電子通路\";

case \"6113.TW\" : retval = \"電子通路\";

case \"6118.TW\" : retval = \"電子通路\";

case \"6154.TW\" : retval = \"電子通路\";

case \"6227.TW\" : retval = \"電子通路\";

case \"6265.TW\" : retval = \"電子通路\";

case \"6270.TW\" : retval = \"電子通路\";

case \"8032.TW\" : retval = \"電子通路\";

case \"8067.TW\" : retval = \"電子通路\";

case \"8068.TW\" : retval = \"電子通路\";

case \"8084.TW\" : retval = \"電子通路\";

case \"8096.TW\" : retval = \"電子通路\";

case \"2427.TW\" : retval = \"資訊服務\";

case \"2453.TW\" : retval = \"資訊服務\";

case \"2468.TW\" : retval = \"資訊服務\";

case \"2471.TW\" : retval = \"資訊服務\";

case \"2480.TW\" : retval = \"資訊服務\";

case \"3029.TW\" : retval = \"資訊服務\";

case \"3130.TW\" : retval = \"資訊服務\";

case \"4994.TW\" : retval = \"資訊服務\";

case \"5203.TW\" : retval = \"資訊服務\";

case \"6112.TW\" : retval = \"資訊服務\";

case \"6183.TW\" : retval = \"資訊服務\";

case \"6214.TW\" : retval = \"資訊服務\";

case \"3085.TW\" : retval = \"資訊服務\";

case \"3570.TW\" : retval = \"資訊服務\";

case \"4953.TW\" : retval = \"資訊服務\";

case \"4965.TW\" : retval = \"資訊服務\";

case \"5201.TW\" : retval = \"資訊服務\";

case \"5202.TW\" : retval = \"資訊服務\";

case \"5209.TW\" : retval = \"資訊服務\";

case \"5210.TW\" : retval = \"資訊服務\";

case \"5211.TW\" : retval = \"資訊服務\";

case \"5212.TW\" : retval = \"資訊服務\";

case \"5287.TW\" : retval = \"資訊服務\";

case \"5310.TW\" : retval = \"資訊服務\";

case \"5403.TW\" : retval = \"資訊服務\";

case \"5410.TW\" : retval = \"資訊服務\";

case \"6140.TW\" : retval = \"資訊服務\";

case \"6148.TW\" : retval = \"資訊服務\";

case \"6221.TW\" : retval = \"資訊服務\";

case \"6231.TW\" : retval = \"資訊服務\";

case \"6240.TW\" : retval = \"資訊服務\";

case \"6404.TW\" : retval = \"資訊服務\";

case \"6593.TW\" : retval = \"資訊服務\";

case \"8044.TW\" : retval = \"資訊服務\";

case \"8099.TW\" : retval = \"資訊服務\";

case \"8416.TW\" : retval = \"資訊服務\";

case \"8472.TW\" : retval = \"資訊服務\";

case \"8477.TW\" : retval = \"資訊服務\";

case \"2312.TW\" : retval = \"其他電子\";

case \"2317.TW\" : retval = \"其他電子\";

case \"2354.TW\" : retval = \"其他電子\";

case \"2359.TW\" : retval = \"其他電子\";

case \"2360.TW\" : retval = \"其他電子\";

case \"2373.TW\" : retval = \"其他電子\";

case \"2390.TW\" : retval = \"其他電子\";

case \"2404.TW\" : retval = \"其他電子\";

case \"2423.TW\" : retval = \"其他電子\";

case \"2433.TW\" : retval = \"其他電子\";

case \"2461.TW\" : retval = \"其他電子\";

case \"2464.TW\" : retval = \"其他電子\";

case \"2474.TW\" : retval = \"其他電子\";

case \"2477.TW\" : retval = \"其他電子\";

case \"2482.TW\" : retval = \"其他電子\";

case \"2488.TW\" : retval = \"其他電子\";

case \"2495.TW\" : retval = \"其他電子\";

case \"2497.TW\" : retval = \"其他電子\";

case \"3018.TW\" : retval = \"其他電子\";

case \"3030.TW\" : retval = \"其他電子\";

case \"3043.TW\" : retval = \"其他電子\";

case \"3305.TW\" : retval = \"其他電子\";

case \"3450.TW\" : retval = \"其他電子\";

case \"3518.TW\" : retval = \"其他電子\";

case \"3617.TW\" : retval = \"其他電子\";

case \"3665.TW\" : retval = \"其他電子\";

case \"5225.TW\" : retval = \"其他電子\";

case \"6139.TW\" : retval = \"其他電子\";

case \"6192.TW\" : retval = \"其他電子\";

case \"6196.TW\" : retval = \"其他電子\";

case \"6201.TW\" : retval = \"其他電子\";

case \"6215.TW\" : retval = \"其他電子\";

case \"6409.TW\" : retval = \"其他電子\";

case \"8021.TW\" : retval = \"其他電子\";

case \"8201.TW\" : retval = \"其他電子\";

case \"1785.TW\" : retval = \"其他電子\";

case \"3067.TW\" : retval = \"其他電子\";

case \"3093.TW\" : retval = \"其他電子\";

case \"3131.TW\" : retval = \"其他電子\";

case \"3285.TW\" : retval = \"其他電子\";

case \"3289.TW\" : retval = \"其他電子\";

case \"3303.TW\" : retval = \"其他電子\";

case \"3324.TW\" : retval = \"其他電子\";

case \"3373.TW\" : retval = \"其他電子\";

case \"3402.TW\" : retval = \"其他電子\";

case \"3498.TW\" : retval = \"其他電子\";

case \"3508.TW\" : retval = \"其他電子\";

case \"3541.TW\" : retval = \"其他電子\";

case \"3551.TW\" : retval = \"其他電子\";

case \"3552.TW\" : retval = \"其他電子\";

case \"3563.TW\" : retval = \"其他電子\";

case \"3580.TW\" : retval = \"其他電子\";

case \"3587.TW\" : retval = \"其他電子\";

case \"3628.TW\" : retval = \"其他電子\";

case \"3642.TW\" : retval = \"其他電子\";

case \"3663.TW\" : retval = \"其他電子\";

case \"4554.TW\" : retval = \"其他電子\";

case \"5205.TW\" : retval = \"其他電子\";

case \"5452.TW\" : retval = \"其他電子\";

case \"5489.TW\" : retval = \"其他電子\";

case \"5493.TW\" : retval = \"其他電子\";

case \"5536.TW\" : retval = \"其他電子\";

case \"6146.TW\" : retval = \"其他電子\";

case \"6151.TW\" : retval = \"其他電子\";

case \"6187.TW\" : retval = \"其他電子\";

case \"6238.TW\" : retval = \"其他電子\";

case \"6247.TW\" : retval = \"其他電子\";

case \"6275.TW\" : retval = \"其他電子\";

case \"6438.TW\" : retval = \"其他電子\";

case \"6512.TW\" : retval = \"其他電子\";

case \"6613.TW\" : retval = \"其他電子\";

case \"8047.TW\" : retval = \"其他電子\";

case \"8085.TW\" : retval = \"其他電子\";

case \"8092.TW\" : retval = \"其他電子\";

case \"8183.TW\" : retval = \"其他電子\";

case \"8383.TW\" : retval = \"其他電子\";

case \"8431.TW\" : retval = \"其他電子\";

case \"8455.TW\" : retval = \"其他電子\";

case \"1436.TW\" : retval = \"建材營造\";

case \"1438.TW\" : retval = \"建材營造\";

case \"1442.TW\" : retval = \"建材營造\";

case \"1805.TW\" : retval = \"建材營造\";

case \"1808.TW\" : retval = \"建材營造\";

case \"2501.TW\" : retval = \"建材營造\";

case \"2504.TW\" : retval = \"建材營造\";

case \"2505.TW\" : retval = \"建材營造\";

case \"2506.TW\" : retval = \"建材營造\";

case \"2509.TW\" : retval = \"建材營造\";

case \"2511.TW\" : retval = \"建材營造\";

case \"2515.TW\" : retval = \"建材營造\";

case \"2516.TW\" : retval = \"建材營造\";

case \"2520.TW\" : retval = \"建材營造\";

case \"2524.TW\" : retval = \"建材營造\";

case \"2527.TW\" : retval = \"建材營造\";

case \"2528.TW\" : retval = \"建材營造\";

case \"2530.TW\" : retval = \"建材營造\";

case \"2534.TW\" : retval = \"建材營造\";

case \"2535.TW\" : retval = \"建材營造\";

case \"2536.TW\" : retval = \"建材營造\";

case \"2537.TW\" : retval = \"建材營造\";

case \"2538.TW\" : retval = \"建材營造\";

case \"2539.TW\" : retval = \"建材營造\";

case \"2540.TW\" : retval = \"建材營造\";

case \"2542.TW\" : retval = \"建材營造\";

case \"2543.TW\" : retval = \"建材營造\";

case \"2545.TW\" : retval = \"建材營造\";

case \"2546.TW\" : retval = \"建材營造\";

case \"2547.TW\" : retval = \"建材營造\";

case \"2548.TW\" : retval = \"建材營造\";

case \"2597.TW\" : retval = \"建材營造\";

case \"2841.TW\" : retval = \"建材營造\";

case \"2923.TW\" : retval = \"建材營造\";

case \"3052.TW\" : retval = \"建材營造\";

case \"3056.TW\" : retval = \"建材營造\";

case \"3266.TW\" : retval = \"建材營造\";

case \"3703.TW\" : retval = \"建材營造\";

case \"5515.TW\" : retval = \"建材營造\";

case \"5519.TW\" : retval = \"建材營造\";

case \"5521.TW\" : retval = \"建材營造\";

case \"5522.TW\" : retval = \"建材營造\";

case \"5525.TW\" : retval = \"建材營造\";

case \"5531.TW\" : retval = \"建材營造\";

case \"5533.TW\" : retval = \"建材營造\";

case \"5534.TW\" : retval = \"建材營造\";

case \"6177.TW\" : retval = \"建材營造\";

case \"9906.TW\" : retval = \"建材營造\";

case \"9946.TW\" : retval = \"建材營造\";

case \"2596.TW\" : retval = \"建材營造\";

case \"3489.TW\" : retval = \"建材營造\";

case \"4113.TW\" : retval = \"建材營造\";

case \"4416.TW\" : retval = \"建材營造\";

case \"4907.TW\" : retval = \"建材營造\";

case \"5206.TW\" : retval = \"建材營造\";

case \"5213.TW\" : retval = \"建材營造\";

case \"5324.TW\" : retval = \"建材營造\";

case \"5508.TW\" : retval = \"建材營造\";

case \"5511.TW\" : retval = \"建材營造\";

case \"5512.TW\" : retval = \"建材營造\";

case \"5514.TW\" : retval = \"建材營造\";

case \"5516.TW\" : retval = \"建材營造\";

case \"5520.TW\" : retval = \"建材營造\";

case \"5523.TW\" : retval = \"建材營造\";

case \"5529.TW\" : retval = \"建材營造\";

case \"5543.TW\" : retval = \"建材營造\";

case \"6171.TW\" : retval = \"建材營造\";

case \"6186.TW\" : retval = \"建材營造\";

case \"6212.TW\" : retval = \"建材營造\";

case \"6219.TW\" : retval = \"建材營造\";

case \"6264.TW\" : retval = \"建材營造\";

case \"8424.TW\" : retval = \"建材營造\";

case \"2208.TW\" : retval = \"航運業\";

case \"2603.TW\" : retval = \"航運業\";

case \"2605.TW\" : retval = \"航運業\";

case \"2606.TW\" : retval = \"航運業\";

case \"2607.TW\" : retval = \"航運業\";

case \"2608.TW\" : retval = \"航運業\";

case \"2609.TW\" : retval = \"航運業\";

case \"2610.TW\" : retval = \"航運業\";

case \"2611.TW\" : retval = \"航運業\";

case \"2612.TW\" : retval = \"航運業\";

case \"2613.TW\" : retval = \"航運業\";

case \"2615.TW\" : retval = \"航運業\";

case \"2617.TW\" : retval = \"航運業\";

case \"2618.TW\" : retval = \"航運業\";

case \"2633.TW\" : retval = \"航運業\";

case \"2634.TW\" : retval = \"航運業\";

case \"2636.TW\" : retval = \"航運業\";

case \"2637.TW\" : retval = \"航運業\";

case \"2642.TW\" : retval = \"航運業\";

case \"5607.TW\" : retval = \"航運業\";

case \"5608.TW\" : retval = \"航運業\";

case \"2641.TW\" : retval = \"航運業\";

case \"2643.TW\" : retval = \"航運業\";

case \"5601.TW\" : retval = \"航運業\";

case \"5603.TW\" : retval = \"航運業\";

case \"5604.TW\" : retval = \"航運業\";

case \"5609.TW\" : retval = \"航運業\";

case \"2701.TW\" : retval = \"觀光\";

case \"2702.TW\" : retval = \"觀光\";

case \"2704.TW\" : retval = \"觀光\";

case \"2705.TW\" : retval = \"觀光\";

case \"2706.TW\" : retval = \"觀光\";

case \"2707.TW\" : retval = \"觀光\";

case \"2712.TW\" : retval = \"觀光\";

case \"2722.TW\" : retval = \"觀光\";

case \"2723.TW\" : retval = \"觀光\";

case \"2727.TW\" : retval = \"觀光\";

case \"2731.TW\" : retval = \"觀光\";

case \"2739.TW\" : retval = \"觀光\";

case \"2748.TW\" : retval = \"觀光\";

case \"5706.TW\" : retval = \"觀光\";

case \"8940.TW\" : retval = \"觀光\";

case \"9943.TW\" : retval = \"觀光\";

case \"1259.TW\" : retval = \"觀光\";

case \"1268.TW\" : retval = \"觀光\";

case \"2718.TW\" : retval = \"觀光\";

case \"2719.TW\" : retval = \"觀光\";

case \"2726.TW\" : retval = \"觀光\";

case \"2729.TW\" : retval = \"觀光\";

case \"2732.TW\" : retval = \"觀光\";

case \"2734.TW\" : retval = \"觀光\";

case \"2736.TW\" : retval = \"觀光\";

case \"2740.TW\" : retval = \"觀光\";

case \"2928.TW\" : retval = \"觀光\";

case \"4804.TW\" : retval = \"觀光\";

case \"5301.TW\" : retval = \"觀光\";

case \"5364.TW\" : retval = \"觀光\";

case \"5701.TW\" : retval = \"觀光\";

case \"5703.TW\" : retval = \"觀光\";

case \"5704.TW\" : retval = \"觀光\";

case \"8077.TW\" : retval = \"觀光\";

case \"8462.TW\" : retval = \"觀光\";

case \"2801.TW\" : retval = \"金融保險\";

case \"2809.TW\" : retval = \"金融保險\";

case \"2812.TW\" : retval = \"金融保險\";

case \"2816.TW\" : retval = \"金融保險\";

case \"2820.TW\" : retval = \"金融保險\";

case \"2823.TW\" : retval = \"金融保險\";

case \"2832.TW\" : retval = \"金融保險\";

case \"2834.TW\" : retval = \"金融保險\";

case \"2836.TW\" : retval = \"金融保險\";

case \"2838.TW\" : retval = \"金融保險\";

case \"2845.TW\" : retval = \"金融保險\";

case \"2849.TW\" : retval = \"金融保險\";

case \"2850.TW\" : retval = \"金融保險\";

case \"2851.TW\" : retval = \"金融保險\";

case \"2852.TW\" : retval = \"金融保險\";

case \"2855.TW\" : retval = \"金融保險\";

case \"2856.TW\" : retval = \"金融保險\";

case \"2867.TW\" : retval = \"金融保險\";

case \"2880.TW\" : retval = \"金融保險\";

case \"2881.TW\" : retval = \"金融保險\";

case \"2882.TW\" : retval = \"金融保險\";

case \"2883.TW\" : retval = \"金融保險\";

case \"2884.TW\" : retval = \"金融保險\";

case \"2885.TW\" : retval = \"金融保險\";

case \"2886.TW\" : retval = \"金融保險\";

case \"2887.TW\" : retval = \"金融保險\";

case \"2888.TW\" : retval = \"金融保險\";

case \"2889.TW\" : retval = \"金融保險\";

case \"2890.TW\" : retval = \"金融保險\";

case \"2891.TW\" : retval = \"金融保險\";

case \"2892.TW\" : retval = \"金融保險\";

case \"2897.TW\" : retval = \"金融保險\";

case \"5880.TW\" : retval = \"金融保險\";

case \"6005.TW\" : retval = \"金融保險\";

case \"6024.TW\" : retval = \"金融保險\";

case \"5820.TW\" : retval = \"金融保險\";

case \"5878.TW\" : retval = \"金融保險\";

case \"6015.TW\" : retval = \"金融保險\";

case \"6016.TW\" : retval = \"金融保險\";

case \"6020.TW\" : retval = \"金融保險\";

case \"6021.TW\" : retval = \"金融保險\";

case \"6023.TW\" : retval = \"金融保險\";

case \"6026.TW\" : retval = \"金融保險\";

case \"1432.TW\" : retval = \"貿易百貨\";

case \"2601.TW\" : retval = \"貿易百貨\";

case \"2614.TW\" : retval = \"貿易百貨\";

case \"2901.TW\" : retval = \"貿易百貨\";

case \"2903.TW\" : retval = \"貿易百貨\";

case \"2905.TW\" : retval = \"貿易百貨\";

case \"2906.TW\" : retval = \"貿易百貨\";

case \"2908.TW\" : retval = \"貿易百貨\";

case \"2910.TW\" : retval = \"貿易百貨\";

case \"2911.TW\" : retval = \"貿易百貨\";

case \"2912.TW\" : retval = \"貿易百貨\";

case \"2913.TW\" : retval = \"貿易百貨\";

case \"2915.TW\" : retval = \"貿易百貨\";

case \"2929.TW\" : retval = \"貿易百貨\";

case \"2936.TW\" : retval = \"貿易百貨\";

case \"4807.TW\" : retval = \"貿易百貨\";

case \"5906.TW\" : retval = \"貿易百貨\";

case \"5907.TW\" : retval = \"貿易百貨\";

case \"8429.TW\" : retval = \"貿易百貨\";

case \"8443.TW\" : retval = \"貿易百貨\";

case \"8454.TW\" : retval = \"貿易百貨\";

case \"2916.TW\" : retval = \"貿易百貨\";

case \"2924.TW\" : retval = \"貿易百貨\";

case \"2937.TW\" : retval = \"貿易百貨\";

case \"3171.TW\" : retval = \"貿易百貨\";

case \"5902.TW\" : retval = \"貿易百貨\";

case \"5903.TW\" : retval = \"貿易百貨\";

case \"5904.TW\" : retval = \"貿易百貨\";

case \"5905.TW\" : retval = \"貿易百貨\";

case \"6195.TW\" : retval = \"貿易百貨\";

case \"8066.TW\" : retval = \"貿易百貨\";

case \"8433.TW\" : retval = \"貿易百貨\";

case \"8941.TW\" : retval = \"貿易百貨\";

case \"9960.TW\" : retval = \"貿易百貨\";

case \"2616.TW\" : retval = \"油電燃氣\";

case \"6505.TW\" : retval = \"油電燃氣\";

case \"8926.TW\" : retval = \"油電燃氣\";

case \"9908.TW\" : retval = \"油電燃氣\";

case \"9918.TW\" : retval = \"油電燃氣\";

case \"9926.TW\" : retval = \"油電燃氣\";

case \"9931.TW\" : retval = \"油電燃氣\";

case \"9937.TW\" : retval = \"油電燃氣\";

case \"8908.TW\" : retval = \"油電燃氣\";

case \"8917.TW\" : retval = \"油電燃氣\";

case \"8927.TW\" : retval = \"油電燃氣\";

case \"8931.TW\" : retval = \"油電燃氣\";

case \"2926.TW\" : retval = \"文化創意\";

case \"3064.TW\" : retval = \"文化創意\";

case \"3083.TW\" : retval = \"文化創意\";

case \"3086.TW\" : retval = \"文化創意\";

case \"3293.TW\" : retval = \"文化創意\";

case \"3546.TW\" : retval = \"文化創意\";

case \"3687.TW\" : retval = \"文化創意\";

case \"4803.TW\" : retval = \"文化創意\";

case \"4806.TW\" : retval = \"文化創意\";

case \"4946.TW\" : retval = \"文化創意\";

case \"5263.TW\" : retval = \"文化創意\";

case \"5278.TW\" : retval = \"文化創意\";

case \"5478.TW\" : retval = \"文化創意\";

case \"6111.TW\" : retval = \"文化創意\";

case \"6144.TW\" : retval = \"文化創意\";

case \"6169.TW\" : retval = \"文化創意\";

case \"6180.TW\" : retval = \"文化創意\";

case \"6482.TW\" : retval = \"文化創意\";

case \"6542.TW\" : retval = \"文化創意\";

case \"8446.TW\" : retval = \"文化創意\";

case \"8450.TW\" : retval = \"文化創意\";

case \"8489.TW\" : retval = \"文化創意\";

case \"8923.TW\" : retval = \"文化創意\";

case \"9949.TW\" : retval = \"文化創意\";

case \"4171.TW\" : retval = \"農業科技業\";

case \"6508.TW\" : retval = \"農業科技業\";

case \"9103.TW\" : retval = \"存託憑證\";

case \"910322.TW\" : retval = \"存託憑證\";

case \"910482.TW\" : retval = \"存託憑證\";

case \"9105.TW\" : retval = \"存託憑證\";

case \"910708.TW\" : retval = \"存託憑證\";

case \"910861.TW\" : retval = \"存託憑證\";

case \"9110.TW\" : retval = \"存託憑證\";

case \"911608.TW\" : retval = \"存託憑證\";

default : retval = \"XXX\";

End;

## 場景 546：選股常用語的對應程式集(二)

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：八，近幾日量縮拉回

input:day(5,\"量縮拉回天數\");

if average(volume,day)\<=average(volume,day+5)

and average(close,day)\<=average(close,day+5)

then ret=1;

## 場景 547：選股常用語的對應程式集(二)

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：九，投信剛剛開始買

input: day(30, \"計算期間\");

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

//近期股價尚未大漲

RET = condition1 and condition2 and condition3 and condition4 and
condition5;

## 場景 548：選股常用語的對應程式集(二)

> 來源：[[選股常用語的對應程式集(二)]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86%e4%ba%8c/)
> 說明：十，股票箱突破

input:length(12);

value1=NthHighest(1,high,length);

value3=nthhighest(3,high,length);

value4=Nthlowest(1,low,length);

value5=nthlowest(3,low,length);

if

value1\[1\]\<=1.03\*value3\[1\]

and value5\[1\]\<=value4\[1\]\*1.03

and value1\[1\]\<=value4\[1\]\*1.1

and close\>value1\[1\]

and average(volume,100)\>1000

and average(volume,10)\>average(volume,50)

then ret=1;

## 場景 549：選股常用語的對應程式集

> 來源：[[選股常用語的對應程式集]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86/)
> 說明：一，整理結束

//盤整後噴出

input: Periods(20,\"計算期數\");

input: Ratio(3,\"近期波動幅度%\");

settotalbar(300);

setbarback(50);

condition1 = false;

if (highest(high\[1\],Periods-1) -
lowest(low\[1\],Periods-1))/close\[1\] \<= ratio\*0.01

then condition1=true//近期波動在?%以內

else return;

if condition1 and high = highest(high, Periods)

and close\>close\[1\]\*1.02

then ret=1;//盤整後往上突破

## 場景 550：選股常用語的對應程式集

> 來源：[[選股常用語的對應程式集]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86/)
> 說明：二，下跌時價量背離

input:period(10);

input:times(5);

if close\[1\]\*1.1\<close\[40\]

and countif(c\>c\[1\]xor v\>v\[1\],period)

\>=times

and close=highest(close,period)

then ret=1;

## 場景 551：選股常用語的對應程式集

> 來源：[[選股常用語的對應程式集]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86/)
> 說明：三，KD進入超賣區

input: Length(9), RSVt(3), Kt(3);

variable: rsv(0), k(0), \_d(0);

SetBarBack(maxlist(Length,6));

SetTotalBar(maxlist(Length,6) \* 4);

SetInputName(1, \"天數\");

SetInputName(2, \"RSVt權數\");

SetInputName(3, \"Kt權數\");

Stochastic(Length, RSVt, Kt, rsv, k, \_d);

IF k\<20 and \_d\<30

then ret=1;

## 場景 552：選股常用語的對應程式集

> 來源：[[選股常用語的對應程式集]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86/)
> 說明：四，千張大戶增加

value1=GetField(\"大戶持股人數\",\"W\",param:=1000);

value2=GetField(\"散戶持股人數\",\"W\");

if value1\>value1\[1\]

and value2\<value2\[1\]

then ret=1;

outputfield(1,value1,0,\"本週大戶人數\");

outputfield(2,value1\[1\],0,\"上週大戶人數\");

outputfield(3,value1-value1\[1\],0,\"大戶增加數\");

outputfield(4,value2,0,\"本週散戶人數\");

outputfield(5,value2\[1\],0,\"上週散戶人數\");

## 場景 553：選股常用語的對應程式集 --- 五，BBand出現買進訊號

> 來源：[[選股常用語的對應程式集]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86/)
> 說明：五，BBand出現買進訊號

input:length(20);

variable:up1(0),down1(0),mid1(0),bbandwidth(0);

up1 = bollingerband(Close, Length, 1);

down1 = bollingerband(Close, Length, -1 );

mid1 = (up1 + down1) / 2;

bbandwidth = 100 \* (up1 - down1) / mid1;

if bbandwidth crosses above 5 and close \> up1 and close\> up1\[1\]

then ret=1;

## 場景 554：選股常用語的對應程式集 --- 六，本益比低於某個水準

> 來源：[[選股常用語的對應程式集]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86/)
> 說明：六，本益比低於某個水準

input:per(12,\"本益比上限\");

value1=GetField(\"本益比\",\"D\");

if value1\<per

then ret=1;

## 場景 555：選股常用語的對應程式集

> 來源：[[選股常用語的對應程式集]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86/)
> 說明：七，近期處於上昇趨勢

input:Length(20); //\"計算期間\"

LinearReg(close, Length, 0, value1, value2, value3, value4);

//做收盤價20天線性回歸

{value1:斜率,value4:預期值}

value5=rsquare(close,value4,20);//算收盤價與線性回歸值的R平方

if value1\>0 and value5\>0.2

then ret=1;

## 場景 556：選股常用語的對應程式集

> 來源：[[選股常用語的對應程式集]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86/)
> 說明：八，放量起漲

if average(volume,5) \> 200 and

C\> 10 and

volume \> average(V\[1\],20) \*2

and close\>close\[1\]\*1.01

then ret=1;

## 場景 557：選股常用語的對應程式集

> 來源：[[選股常用語的對應程式集]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86/)

condition1 = angle(date\[20\], date\[5\]) \< 0;

value1 = angle(date\[5\], date);

condition2 = value1 \> 0;

setoutputname1(\"angle\");

outputfield1(value1);

if condition1 and condition2 then ret=1;

## 場景 558：選股常用語的對應程式集

> 來源：[[選股常用語的對應程式集]{.underline}](https://www.xq.com.tw/xstrader/%e9%81%b8%e8%82%a1%e5%b8%b8%e7%94%a8%e8%aa%9e%e7%9a%84%e5%b0%8d%e6%87%89%e7%a8%8b%e5%bc%8f%e9%9b%86/)
> 說明：十，投信第一天大買進

value1=GetField(\"最新股本\");//單位:億

value2=GetField(\"投信買張\",\"D\");

value3=value2\*close/10; //單位:萬}

condition1=value3\>200 and value1\<80;

condition2=filter(condition1,5);

if condition2

then ret=1;

## 場景 559：均線剛往上彎且股價與均線黃金交叉的寫法

> 來源：[[均線剛往上彎且股價與均線黃金交叉的寫法]{.underline}](https://www.xq.com.tw/xstrader/%e5%9d%87%e7%b7%9a%e5%89%9b%e5%be%80%e4%b8%8a%e5%bd%8e%e4%b8%94%e8%82%a1%e5%83%b9%e8%88%87%e5%9d%87%e7%b7%9a%e9%bb%83%e9%87%91%e4%ba%a4%e5%8f%89%e7%9a%84%e5%af%ab%e6%b3%95/)
> 說明：腳本樣本如下

if barfreq\<\>\"Min\"and barinterval\<\>10 then
raiseruntimeerror(\"請使用十分鐘線\");

input:period(40,\"均線計算區間\");

//宣告均線期別的參數

var:ma(0);

//宣告移動平均線的變數名稱

ma=average(close,period);

//指定ma這個變數就是移動平均線的值

if trueall(ma\[1\]\<ma\[2\],10)

//過去十期前一根均線值都比前前根均線值還低

//代表過去十天的均線值都是下降的

and ma\>ma\[1\]

//今天的均線值大於前一根bar的均線值

//以上兩行敘述代表均線剛上彎

and close cross over ma

//最新價位突破移動平均線

then ret=1;

## 場景 560：如何計算兩個日期間的各項數值\~以區間千張大戶增加張數為例 --- 接下來我就寫了一個程式來尋找在這段期間內千張大戶有明顯回補股票的公司，選股腳本如下

> 來源：[[如何計算兩個日期間的各項數值\~以區間千張大戶增加張數為例]{.underline}](https://www.xq.com.tw/xstrader/%e5%a6%82%e4%bd%95%e8%a8%88%e7%ae%97%e5%85%a9%e5%80%8b%e6%97%a5%e6%9c%9f%e9%96%93%e7%9a%84%e5%90%84%e9%a0%85%e6%95%b8%e5%80%bc%e4%bb%a5%e5%8d%80%e9%96%93%e5%8d%83%e5%bc%b5%e5%a4%a7%e6%88%b6%e5%a2%9e/)
> 說明：接下來我就寫了一個程式來尋找在這段期間內千張大戶有明顯回補股票的公司，選股腳本如下

input:startdate(20181026,\"區間起始日\");

input:enddate(20190104,\"區間結束日\");

input:vl(2000,\"差額限數下限\");

value1=getbaroffset(startdate);

value2=getbaroffset(enddate);

value3=GetField(\"大戶持股張數\",\"W\",param := 1000)\[value1\];

value4=GetField(\"大戶持股張數\",\"W\",param := 1000)\[value2\];

value5=GetField(\"大戶持股比例\",\"W\",param := 1000)\[value1\];

value6=GetField(\"大戶持股比例\",\"W\",param := 1000)\[value2\];

if value4-value3\>vl and value6\>value5 then ret=1;

outputfield(1,value3,0,\"期初張數\");

outputfield(2,value4,0,\"期末張數\");

outputfield(3,value4-value3,0,\"差額張數\");

## 場景 561：結合多個選股條件的綜合選股方法 --- 我寫的綜合選股腳本如下

> 來源：[[結合多個選股條件的綜合選股方法]{.underline}](https://www.xq.com.tw/xstrader/%e7%b5%90%e5%90%88%e5%a4%9a%e5%80%8b%e9%81%b8%e8%82%a1%e6%a2%9d%e4%bb%b6%e7%9a%84%e7%b6%9c%e5%90%88%e9%81%b8%e8%82%a1%e6%96%b9%e6%b3%95/)
> 說明：我寫的綜合選股腳本如下

input:lowlimit(9,\"符合條件數下限\");

var:counts(0);//宣告計數器

counts=0;//每根bar計算前計數器要歸零

//條件一: 本益比小於12

value1=GetField(\"本益比\",\"D\");

if value1\<=12 then counts=counts+1;

//條件二：股價淨值比小於2

value2=GetField(\"股價淨值比\",\"D\");

if value2\<2 then counts=counts+1;

//條件三：殖利率大於4

value3=GetField(\"殖利率\",\"D\");

if value3\>4 then counts=counts+1;

//條件四：開盤委買量創20日高點

value4=GetField(\"開盤委買\",\"D\");

if value4=highest(value4,20)

then counts=counts+1;

//條件五：佔全市場成交量比創20日高點

value5=GetField(\"佔全市場成交量比\",\"D\");

if value5=highest(value5,20)

then counts=counts+1;

//條件六：月營收維持兩位數成長

value6=GetField(\"月營收年增率\",\"M\");

if value6\>=10 then counts=counts+1;

//條件七：現金股利超過一元

value7=GetField(\"現金股利\",\"Y\");

if value7\>=1 then counts=counts+1;

//條件八: 外資買超

value8=GetField(\"外資買賣超\",\"D\");

if value8\>=300 then counts=counts+1;

//條件九: 投信買超

value9=GetField(\"投信買賣超\",\"D\");

if value9\>=300 then counts=counts+1;

//條件十: 董監事持股高於一定比例

value10=GetField(\"董監持股佔股本比例\",\"D\");

if value10\>=25 then counts=counts+1;

//條件十一：主力連三日買超

value11=GetField(\"主力買賣超張數\",\"D\");

if trueall(value11\>300,3) then counts=counts+1;

//條件十二：近一週千張大戶比前一週多

if GetFieldDate(\"大戶持股人數\",\"W\") \<\> date then begin

value20 = GetField(\"大戶持股人數\",\"W\",param := 1000)\[1\];

value21 = GetField(\"大戶持股人數\",\"W\",param := 1000)\[2\];

end

else begin

value20 = GetField(\"大戶持股人數\",\"W\",param := 1000);

value21 = GetField(\"大戶持股人數\",\"W\",param := 1000)\[1\];

end;

if value20\>value21

then counts=counts+1;

//條件十三：地緣券商買超

value12=GetField(\"地緣券商買賣超張數\",\"D\");

if value12\>100 then counts=counts+1;

//條件十四：分公司淨賣超家數超過淨買超的兩倍

//代表籌碼被收集

value13=GetField(\"分公司淨買超金額家數\",\"D\");

value14=GetField(\"分公司淨賣超金額家數\",\"D\");

if value14\>2\*value13 then counts=counts+1;

//條件十五: 近三日動量指標有突破零

if barslast(Momentum(Close, 10) Crosses Above 0)\<=3

then counts=counts+1;

//條件十六：近三日有RSI黃金交叉

if barslast(RSI(Close, 5) Crosses Above RSI(Close, 10))\<=3

then counts=counts+1;

//條件十七：關鍵券商買超

value15=GetField(\"關鍵券商買賣超張數\",\"D\");

if value15\>0 then counts=counts+1;

//條件十八: 股價突破兩倍的真實波動區間

value16=average(truerange,20);

value17=average(close,20)+2\*value16;

if close crosses over value17

then counts=counts+1;

//條件十九：上漲角度突破30度

value18=rateofchange(close,20);

value19=arctangent(value18/20\*100);

if value19 crosses over 30

then counts=counts+1;

//條件二十： 出量

if volume \>=average(volume,20)\*1.3

then counts=counts+1;

if counts\>=lowlimit then ret=1;

outputfield(1,counts,0,\"符合條件數\");

## 場景 562：CVI累積成交量指標

> 來源：[[CVI累積成交量指標]{.underline}](https://www.xq.com.tw/xstrader/cvi%e7%b4%af%e7%a9%8d%e6%88%90%e4%ba%a4%e9%87%8f%e6%8c%87%e6%a8%99/)

// XQ: CVI指標

//

variable: \_cvi(0);

If CurrentBar \> 1 then

\_cvi = \_cvi\[1\] + GetField(\"UpVolume\") - GetField(\"DownVolume\");

Plot1(\_cvi, \"CVI\");

## 場景 563：CV指標

> 來源：[[CV指標]{.underline}](https://www.xq.com.tw/xstrader/cv%e6%8c%87%e6%a8%99/)

// XQ: CV指標

//

Variable: \_cv(0);

If CurrentBar = 1 then

\_cv = Close \* Volume

else

\_cv = \_cv\[1\] + (Close - Close\[1\]) \* Volume;

Plot1(\_cv, \"CV\");

## 場景 564：PSY心理線

> 來源：[[PSY心理線]{.underline}](https://www.xq.com.tw/xstrader/psy%e5%bf%83%e7%90%86%e7%b7%9a/)

// XQ: 心理線

//

input: Length1(12), Length2(24);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

Value1 = 100 \* CountIf(Close \> Close\[1\], Length1) / Length1;

Value2 = 100 \* CountIf(Close \> Close\[1\], Length2) / Length2;

Plot1(Value1, \"PSY1\");

Plot2(Value2, \"PSY2\");

## 場景 565：MO指標

> 來源：[[MO指標]{.underline}](https://www.xq.com.tw/xstrader/mo%e6%8c%87%e6%a8%99/)

// XQ: MO指標

//

input: Length(10);

variable: mo(0);

SetInputName(1, \"天數\");

mo = 100 \* Close / Close\[Length\];

Plot1(mo, \"MO\");

## 場景 566：NVI指標 --- 今日NVI = 昨日 NVI + 0

> 來源：[[NVI指標]{.underline}](https://www.xq.com.tw/xstrader/nvi%e6%8c%87%e6%a8%99/)
> 說明：今日NVI = 昨日 NVI + 0

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

## 場景 567：威廉多空力度線

> 來源：[[威廉多空力度線]{.underline}](https://www.xq.com.tw/xstrader/%e5%a8%81%e5%bb%89%e5%a4%9a%e7%a9%ba%e5%8a%9b%e5%ba%a6%e7%b7%9a/)

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

## 場景 568：威廉多空力度線

> 來源：[[威廉多空力度線]{.underline}](https://www.xq.com.tw/xstrader/%e5%a8%81%e5%bb%89%e5%a4%9a%e7%a9%ba%e5%8a%9b%e5%ba%a6%e7%b7%9a/)

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

## 場景 569：MA移動平均線

> 來源：[[MA移動平均線]{.underline}](https://www.xq.com.tw/xstrader/ma%e7%a7%bb%e5%8b%95%e5%b9%b3%e5%9d%87%e7%b7%9a/)
> 說明：配合其他指標使用.

SetBarMode(1);

input:thePrice(numericseries); //\"價格序列\"

input:Length(numericsimple); //\"計算期間\"

if Length \> 0 then

Average = Summation(thePrice, Length) / Length

else

Average =0;

## 場景 570：MACD

> 來源：[[MACD]{.underline}](https://www.xq.com.tw/xstrader/macd/)
> 說明：MACD的函數

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

## 場景 571：MACD

> 來源：[[MACD]{.underline}](https://www.xq.com.tw/xstrader/macd/)

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

## 場景 572：MA-Osc指標 --- 通常我們很少直接稱這個指標為MAO指標，而是稱為它為「MA1減MA2乖離指標」，特別注意這個指標並非乖離率，很多人誤稱它為乖離率，我們都知道乖離率必須要除以一個\...

> 來源：[[MA-Osc指標]{.underline}](https://www.xq.com.tw/xstrader/ma-osc%e6%8c%87%e6%a8%99/)
> 說明：通常我們很少直接稱這個指標為MAO指標，而是稱為它為「MA1減MA2乖離指標」，特別注意這個指標並非乖離率，很多人誤稱它為乖離率，我們都知道乖離率必須要除以一個成本(分母)，但這公式沒有，所以它顯然不是乖離率。

// XQ: MA-Osc

//

input: Length1(5), Length2(10);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

value1 = Average(close, Length1);

value2 = Average(close, Length2);

value3 = (value1 - value2);

Plot1(value3, \"MA-Osc\");

## 場景 573：HMA改良式移動平均 --- HMA的精神是在計算移動平均時，給予後面的幾根比較高的權重

> 來源：[[HMA改良式移動平均]{.underline}](https://www.xq.com.tw/xstrader/hma%e6%94%b9%e8%89%af%e5%bc%8f%e7%a7%bb%e5%8b%95%e5%b9%b3%e5%9d%87/)
> 說明：HMA的精神是在計算移動平均時，給予後面的幾根比較高的權重

inputs:Length(20) ;

vars:MA(0),HMA(0);

MA=2\*Xaverage(close,IntPortion(Length\*0.5))-xaverage(close,Length);

HMA=xAverage(MA,IntPortion(SquareRoot(Length)));

Plot1(HMA,\"HMA\") ;

## 場景 574：指數移動平均 --- 在XS中把這個移動平均寫成一個叫XAverage的函數，腳本如下

> 來源：[[指數移動平均]{.underline}](https://www.xq.com.tw/xstrader/%e6%8c%87%e6%95%b8%e7%a7%bb%e5%8b%95%e5%b9%b3%e5%9d%87/)
> 說明：在XS中把這個移動平均寫成一個叫XAverage的函數，腳本如下

SetBarMode(2);

input:thePrice(numericseries); //\"價格序列\"

input:Length(Numeric); //\"計算期間\"

variable: Factor(0);

if length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);

if CurrentBar = 1 then

XAverage = thePrice

else

XAverage = XAverage\[1\] + Factor \* (thePrice - XAverage\[1\]);

## 場景 575：Elder Ray 指標 --- Value1 = High -- XAverage(Close, Length); Plot1(Value1, "多頭");

> 來源：[[Elder Ray
> 指標]{.underline}](https://www.xq.com.tw/xstrader/elder-ray-%e6%8c%87%e6%a8%99/)
> 說明：Value1 = High -- XAverage(Close, Length); Plot1(Value1, "多頭");

//Elder 空頭力道指標

//

input: Length(13);

SetInputName(1, \"天數\");

Value1 = Low - XAverage(Close, Length);

Plot1(Value1, \"空頭\");

## 場景 576：唐安奇通道 --- 可以用以下的腳本畫出指標圖:

> 來源：[[唐安奇通道]{.underline}](https://www.xq.com.tw/xstrader/8549-2/)
> 說明：可以用以下的腳本畫出指標圖:

input:Period(13);

plot1(Highest(H\[1\], period),\"通道上緣\");

plot2(Lowest(L\[1\], period),\"通道下緣\" );

plot3((Highest(H, period)+Lowest(L, period))/2,\"通道中線\");

## 場景 577：唐安奇通道

> 來源：[[唐安奇通道]{.underline}](https://www.xq.com.tw/xstrader/8549-2/)
> 說明：警示則可以寫成

input:Period(13);

if H = Highest(H, period) then ret =1;//作多

if L = Lowest(L,period) then ret=1;//作空

## 場景 578：唐安奇通道 --- 當然這樣的期數調整會視情況而定,每一檔商品可能最佳的結果也都不一樣,不過通常每個交易員都會有一個習慣的參數, 可能是月線或季線加減。 我們先看一下加上買賣點指標\...

> 來源：[[唐安奇通道]{.underline}](https://www.xq.com.tw/xstrader/8549-2/)
> 說明：當然這樣的期數調整會視情況而定,每一檔商品可能最佳的結果也都不一樣,不過通常每個交易員都會有一個習慣的參數,
> 可能是月線或季線加減。
> 我們先看一下加上買賣點指標畫在圖上的情況,腳本加上以下的部份

Dupper = Highest(H\[1\], period);

DLower = Lowest(L\[1\], period);

if C \> Dupper then begin plot4(C\*1.01 ,\"作多\");

plot5(C\*1.02);

plot6(C\*1.03);

plot7(C\*1.04);

plot8(C\*1.05);

plot9(C\*1.06);

plot10(C\*1.07);

end;

if C \< DLower then begin plot11(C\*0.99 ,\"作空\");

plot12(C\*0.98);

plot13(C\*0.97);

plot14(C\*0.96);

plot15(C\*0.95);

plot16(C\*0.94);

plot17(C\*0.93);

end;

## 場景 579：DPO指標

> 來源：[[DPO指標]{.underline}](https://www.xq.com.tw/xstrader/dpo%e6%8c%87%e6%a8%99/)

input: Length(10);

variable: dpo(0);

SetInputName(1, \"天數\");

dpo = Close - Average(Close, Length)\[(Length /2) + 1\];

Plot1(dpo, \"DPO\");

## 場景 580：CCI指標 --- 這個CCI公式的設計，當典型價格等於其平均值時，CCI值會等於零。所以這個公式的原始設計比較像是在使用乖離率的觀念，因為只有當最後股價在極短期內作劇烈的向上或向\...

> 來源：[[CCI指標]{.underline}](https://www.xq.com.tw/xstrader/cci%e6%8c%87%e6%a8%99/)
> 說明：這個CCI公式的設計，當典型價格等於其平均值時，CCI值會等於零。所以這個公式的原始設計比較像是在使用乖離率的觀念，因為只有當最後股價在極短期內作劇烈的向上或向下運動時，CCI值才會出現突然向上或向下大幅擺盪的極端值。這個公式的發明者為了將CCI指標值限定在一定的範圍內波動，所以特別將分母部份乘上0.015的參數值。

// XQ: CCI指標

//

input: Length1(14), Length2(28), Length3(42);

SetInputName(1, \"天數一\");

SetInputName(2, \"天數二\");

SetInputName(3, \"天數三\");

Plot1(CommodityChannel(Length1), \"CCI1\");

Plot2(CommodityChannel(Length2), \"CCI2\");

Plot3(CommodityChannel(Length3), \"CCI3\");

## 場景 581：ADX指標 --- 由於DMI指標主要的用途在於作趨勢成立的判斷，因此是屬於較為長期交易的技術指標。而DMI指標的三條線中，ADX線可以說是相當奇特的一條線。ADX線在上昇趨勢開始\...

> 來源：[[ADX指標]{.underline}](https://www.xq.com.tw/xstrader/adx%e6%8c%87%e6%a8%99/)
> 說明：由於DMI指標主要的用途在於作趨勢成立的判斷，因此是屬於較為長期交易的技術指標。而DMI指標的三條線中，ADX線可以說是相當奇特的一條線。ADX線在上昇趨勢開始形成時，會從底部往上攀昇，直到上昇趨勢開始平緩而盤旋時，ADX線便回轉向下。而當下降趨勢開始時，ADX線同樣的又開始從底部往上爬昇，直到下降趨勢和緩而盤整時，ADX線又開始向下回轉。腳本的寫法如下

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

## 場景 582：ADI累積分配指標 --- ADI指標是一個累計值，所以是趨勢性的指標，它沒有一個固定的波動範圍，所以指標值的絕對數值沒有意義，重要的是指標線的方向．當指標線往上時，表示上漲力道在「凝聚」\...

> 來源：[[ADI累積分配指標]{.underline}](https://www.xq.com.tw/xstrader/adi%e7%b4%af%e7%a9%8d%e5%88%86%e9%85%8d%e6%8c%87%e6%a8%99/)
> 說明：ADI指標是一個累計值，所以是趨勢性的指標，它沒有一個固定的波動範圍，所以指標值的絕對數值沒有意義，重要的是指標線的方向．當指標線往上時，表示上漲力道在「凝聚」，上漲機會較大；反之，如果指標線往下的話，表示上漲力道在「消散」，股價下跌的機率較大．

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

## 場景 583：成交量擺動指標 --- Volume Oscillator（OSCV）成交量擺動指標顯示兩條成交量移動平均線之間的價格差異，差異可以點值或百分比在圖表中顯示。

> 來源：[[成交量擺動指標]{.underline}](https://www.xq.com.tw/xstrader/%e6%88%90%e4%ba%a4%e9%87%8f%e6%93%ba%e5%8b%95%e6%8c%87%e6%a8%99/)
> 說明：Volume
> Oscillator（OSCV）成交量擺動指標顯示兩條成交量移動平均線之間的價格差異，差異可以點值或百分比在圖表中顯示。

Input: length1(5); setinputname(1, \"短天期\");

Input: length2(20); setinputname(2, \"長天期\");

Value1 = Average(Volume, length1);

Value2 = Average(Volume, length2);

if value1 = 0 then value3 = 0 else Value3 = (Value1 - Value2) \* 100 /
Value1;

Plot1(Value3, \"OSCV\");

## 場景 584：KO能量潮指標 --- 累積克林格成交量擺動指標Cumulative Klinger Oscillator是一個與累積能量線OBV相似的指標， 它是利用根據日間股票平均價格的變動而對成\...

> 來源：[[KO能量潮指標]{.underline}](https://www.xq.com.tw/xstrader/ko%e8%83%bd%e9%87%8f%e6%bd%ae%e6%8c%87%e6%a8%99/)
> 說明：累積克林格成交量擺動指標Cumulative Klinger
> Oscillator是一個與累積能量線OBV相似的指標，
> 它是利用根據日間股票平均價格的變動而對成交量累積而成，而在累積能量線OBV中用的是日間股票的收盤價的變動來作為成交量累積的標準。
> 相對來說，累積克林格成交量擺動指標比KO指標更適合用於判斷股票價格趨勢的方向。

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

## 場景 585：克林波動指標 Chaikin Volatility --- 描述價格的波動程度的狀況有二種，一種是認為當股價向上時的波動程度將隨之上升，此種描述是認為價格上升時經常伴隨著成交量放大， 這表示此過程將吸引更多的市場參與者加\...

> 來源：[[克林波動指標 Chaikin
> Volatility]{.underline}](https://www.xq.com.tw/xstrader/%e5%85%8b%e6%9e%97%e6%b3%a2%e5%8b%95%e6%8c%87%e6%a8%99-chaikin-volatility/)
> 說明：描述價格的波動程度的狀況有二種，一種是認為當股價向上時的波動程度將隨之上升，此種描述是認為價格上升時經常伴隨著成交量放大，
> 這表示此過程將吸引更多的市場參與者加入，而更多人的參與交易隱含著波動程度放大。另一種狀況則是認為觀察短期的價格走勢，
> 則波動的訊雜幹擾會較長期來得大。

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

## 場景 586：Money flow Index (MFI)指標

> 來源：[[Money flow Index
> (MFI)指標]{.underline}](https://www.xq.com.tw/xstrader/money-flow-index-mfi%e6%8c%87%e6%a8%99/)
> 說明：MFI的計算方法如下

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

## 場景 587：市場便利指標(BW MFI) --- 市場便利指標的下跌，但是交易量的增加 (Squat)。存在牛力和熊力之間的鬥爭。主要特徵為大量的買進和大量的賣出。 但是價格沒有重大的變化，因為兩股勢力比較相當\...

> 來源：[[市場便利指標(BW
> MFI)]{.underline}](https://www.xq.com.tw/xstrader/%e5%b8%82%e5%a0%b4%e4%be%bf%e5%88%a9%e6%8c%87%e6%a8%99bw-mfi/)
> 說明：市場便利指標的下跌，但是交易量的增加
> (Squat)。存在牛力和熊力之間的鬥爭。主要特徵為大量的買進和大量的賣出。
> 但是價格沒有重大的變化，因為兩股勢力比較相當。競爭的其中一方（買家或賣家）將會最終贏得這次鬥爭的勝利。
> 通常，柱形的停滯讓你知道是否這個柱形決定了市場趨勢的連續性，或這個柱形終止了市場趨勢。Bill
> Williams 稱之為"Squat"。

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

## 場景 588：Ease of Movement(EMV)指標 --- 4.最後再把上述的值乘上10000，然後取平均值

> 來源：[[Ease of
> Movement(EMV)指標]{.underline}](https://www.xq.com.tw/xstrader/ease-of-movementemv%e6%8c%87%e6%a8%99/)
> 說明：4.最後再把上述的值乘上10000，然後取平均值

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

## 場景 589：CMO錢德動量擺盪指標 --- 3.把加總的上漲值減去加總的下跌值除以兩者的總和

> 來源：[[CMO錢德動量擺盪指標]{.underline}](https://www.xq.com.tw/xstrader/cmo%e9%8c%a2%e5%be%b7%e5%8b%95%e9%87%8f%e6%93%ba%e7%9b%aa%e6%8c%87%e6%a8%99/)
> 說明：3.把加總的上漲值減去加總的下跌值除以兩者的總和

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

value3 = (value1-value2)/(value1+value2)\*100;

plot1(value3, \"CMO\");

## 場景 590：IMI日內動量指標

> 來源：[[IMI日內動量指標]{.underline}](https://www.xq.com.tw/xstrader/imi%e6%97%a5%e5%85%a7%e5%8b%95%e9%87%8f%e6%8c%87%e6%a8%99/)
> 說明：對應的腳本如下

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

## 場景 591：加速指標 --- 4.取上述值的九日平均線

> 來源：[[加速指標]{.underline}](https://www.xq.com.tw/xstrader/%e5%8a%a0%e9%80%9f%e6%8c%87%e6%a8%99/)
> 說明：4.取上述值的九日平均線

variable:aspeed(0),dspeed(0),a1(0),d1(0),p1(0),ap1(0);

if close\>close\[1\]

then

aspeed=(close-close\[1\])/close\*100

else

aspeed=0;

if close\<close\[1\]

then

dspeed=(close\[1\]-close)/close\*100

else

dspeed=0;

a1=average(aspeed,5);

d1=average(dspeed,5);

p1=a1-d1;

ap1=average(p1,9);

plot1(p1,\"加速度\");

plot2(ap1,\"移動平均\");

## 場景 592：平均波幅通道STARC

> 來源：[[平均波幅通道STARC]{.underline}](https://www.xq.com.tw/xstrader/%e5%b9%b3%e5%9d%87%e6%b3%a2%e5%b9%85%e9%80%9a%e9%81%93starc/)
> 說明：指標的腳本如下

input : length(5); setinputname(1, \"天期\");

input : atrlength(15); setinputname(2, \"ATR天期\");

input : k(1.35); setinputname(3, \"通道常數\");

variable : hband(0),lband(0);

hband = average(close,length)+average(truerange,atrlength)\*k;

lband = average(close,length)-average(truerange,atrlength)\*k;

plot1(hband, \"通道上限\");

plot2(lband, \"通道下限\");

## 場景 593：力度指標(Force Index)

> 來源：[[力度指標(Force
> Index)]{.underline}](https://www.xq.com.tw/xstrader/%e5%8a%9b%e5%ba%a6%e6%8c%87%e6%a8%99force-index/)
> 說明：對應的腳本如下

input:length(10),length1(30);

variable:fis(0),fil(0);

fis=average(volume\*(close-close\[1\]),length);

fil=average(volume\*(close-close\[1\]),length1);

plot1(fis);

plot2(fil);

plot3(fis-fil);

## 場景 594：choppy market index --- input:period(10,\"計算區間\");

> 來源：[[choppy market
> index]{.underline}](https://www.xq.com.tw/xstrader/choppy-market-index/)
> 說明：input:period(10,\"計算區間\");

value1=(close-close\[period-1\])/(highest(high,period)-lowest(low,period))\*100;

## 場景 595：主力長期收集的股票 --- 其中的主力長期收集是一個選股腳本，腳本內容如下

> 來源：[[主力長期收集的股票]{.underline}](https://www.xq.com.tw/xstrader/%e4%b8%bb%e5%8a%9b%e9%95%b7%e6%9c%9f%e6%94%b6%e9%9b%86%e7%9a%84%e8%82%a1%e7%a5%a8/)
> 說明：其中的主力長期收集是一個選股腳本，腳本內容如下

input:period(60,\"計算區間\");

settotalbar(120);

condition1=false;

value1=GetField(\"分公司買進家數\",\"D\");

value2=GetField(\"分公司賣出家數\",\"D\");

if countif(value1\<value2,period)\>period/2

//賣出的分公司家數要比買進分公司家數多代表籌碼從

//各個分公司被收集到特定的分公司

then condition1=true;

value3=GetField(\"主力買賣超張數\",\"D\");

if value3\>0

and summation(value3,5)\>0

and summation(value3,20)\>0

and summation(value3,60)\>0

and summation(value3,120)\>0

//不同天期主力都買超，代表主力長期一直都站在買方

and close\>open\*1.03

and condition1

then ret=1;

## 場景 596：終極震盪指標

> 來源：[[終極震盪指標]{.underline}](https://www.xq.com.tw/xstrader/%e7%b5%82%e6%a5%b5%e9%9c%87%e7%9b%aa%e6%8c%87%e6%a8%99/)
> 說明：指標的腳本如下

Var : ruo(0),uo(0),bp(0);

bp=close-truelow;

input:l1(7),l2(14),l3(28);

Value1=summation(bp,l1);

Value2=summation(bp,l2);

Value3=summation(bp,l3);

Value4=summation(truerange,l1);

Value5=summation(truerange,l2);

Value6=summation(truerange,l3);

ruo=(value1/value4)\*4+(value2/value5)\*2+(value3/value2);

uo=ruo/7\*100;

plot1(uo);

## 場景 597：恰奇震盪指標 --- 根據上述的想法寫出來的指標腳本如下

> 來源：[[恰奇震盪指標]{.underline}](https://www.xq.com.tw/xstrader/%e6%81%b0%e5%a5%87%e9%9c%87%e7%9b%aa%e6%8c%87%e6%a8%99/)
> 說明：根據上述的想法寫出來的指標腳本如下

input:length(5),length1(10),length2(20);

Value1=((close-low)-(high-close))/(high-low)\* volume;

Value2=summation(Value1,length);

Value3=summation(volume,length);

Value4=Value2/value3;

Value5=average(value4,length1);

Value6=average(value4,length2);

Value7=value5-value6;

plot1(value7);

## 場景 598：當成長股突破久未突破的季線 --- 這個策略的名稱是大陸用語，概念就是找出有很長一陣子股價在季線之下，現在股價終於站上季線。

> 來源：[[當成長股突破久未突破的季線]{.underline}](https://www.xq.com.tw/xstrader/%e7%95%b6%e6%88%90%e9%95%b7%e8%82%a1%e7%aa%81%e7%a0%b4%e4%b9%85%e6%9c%aa%e7%aa%81%e7%a0%b4%e7%9a%84%e5%ad%a3%e7%b7%9a/)
> 說明：這個策略的名稱是大陸用語，概念就是找出有很長一陣子股價在季線之下，現在股價終於站上季線。

input:period(35,\"股價低於季線持續的時間\");

if trueall(close\[1\]\<average(close,66),period)

and close crosses over average(close,66)

then ret=1;

## 場景 599：當很少大漲的股票開始多次大漲時 --- 我根據這樣的想法，寫了腳本如下

> 來源：[[當很少大漲的股票開始多次大漲時]{.underline}](https://www.xq.com.tw/xstrader/%e7%95%b6%e5%be%88%e5%b0%91%e5%a4%a7%e6%bc%b2%e7%9a%84%e8%82%a1%e7%a5%a8%e9%96%8b%e5%a7%8b%e6%b2%92%e4%ba%8b%e5%b0%b1%e5%a4%a7%e6%bc%b2%e6%99%82/)
> 說明：我根據這樣的想法，寫了腳本如下

input:speriod(20,\"短期期區間\");

input:lperiod(200,\"長天期區間\");

input:count1(3,\"短期大漲次數下限\");

input:count2(5,\"長期大漲次數上限\");

input:ratio(7,\"大漲的漲幅下限%\");

value1=countif(close\>=close\[1\]\*(1+ratio/100),speriod);

//近期大漲次數

value2=countif(close\>=close\[1\]\*(1+ratio/100),lperiod);

value3=value2-value1;

//長期大漲次數（扣近期)

if value1 cross over count1 and value3\<=count2 then ret=1;

## 場景 600：累計值的寫法 --- 系統提供的腳本是這麼寫的

> 來源：[[累計值的寫法]{.underline}](https://www.xq.com.tw/xstrader/%e7%b4%af%e8%a8%88%e5%80%bc%e7%9a%84%e5%af%ab%e6%b3%95/)
> 說明：系統提供的腳本是這麼寫的

variable:tv(0);//當日累積量～　宣告要計算的累計值

if date\<\>date\[1\] then　//　當不同天期時的第一根要怎麼計算

tv=volume

else　　　　//非當天第一根的累計規則

tv=tv\[1\]+volume;

plot1(tv,\"累積量\");

## 場景 601：累計值的寫法 --- 所以根據這樣的例子，我們就可以來寫累計上漲量減下跌量的腳本了

> 來源：[[累計值的寫法]{.underline}](https://www.xq.com.tw/xstrader/%e7%b4%af%e8%a8%88%e5%80%bc%e7%9a%84%e5%af%ab%e6%b3%95/)
> 說明：所以根據這樣的例子，我們就可以來寫累計上漲量減下跌量的腳本了

//計算累積上漲量

variable:upvolume(0);//當日累積上漲量

//先定義累積上漲量的計算方法

if date\<\>date\[1\]and close\>=open

then upvolume=volume

//以上是定義當天第一根上漲量

else begin

//以下是定義從第二根起累計上漲量的寫法

if close\>=open then

upvolume=upvolume\[1\]+volume

else

upvolume=upvolume\[1\];

end;

//計算累計下跌量，作法跟累計上漲量一樣

variable:downvolume(0);//當日累計下漲量

if date\<\>date\[1\]and close\<open

then downvolume=volume

else begin

if close\<open then

downvolume=downvolume\[1\]+volume

else

downvolume=downvolume\[1\];

end;

//分別算出累計上漲量與下跌量後

//拿累計上漲量減去下跌量

value1=upvolume-downvolume;

plot1(value1,\"累計上漲減下跌量\");

## 場景 602：短空策略之長紅後的長黑 --- 所以我就寫了一個小小的程式來尋找符合大漲後隔日大跌的股票

> 來源：[[短空策略之長紅後的長黑]{.underline}](https://www.xq.com.tw/xstrader/%e9%95%b7%e7%b4%85%e5%be%8c%e7%9a%84%e9%95%b7%e9%bb%91/)
> 說明：所以我就寫了一個小小的程式來尋找符合大漲後隔日大跌的股票

if close\[2\]\*1.06\<close\[1\]

and close\*1.06\<close\[1\]

then ret=1;

## 場景 603：短空策略之長紅後的長黑 --- 所以我就修正一下腳本如下：

> 來源：[[短空策略之長紅後的長黑]{.underline}](https://www.xq.com.tw/xstrader/%e9%95%b7%e7%b4%85%e5%be%8c%e7%9a%84%e9%95%b7%e9%bb%91/)
> 說明：所以我就修正一下腳本如下：

if close\[2\]\*1.06\<close\[1\]

and close\*1.06\<close\[1\]

and open\[1\]\*1.06\<close\[1\]

and close\*1.06\<open

and volume\[1\]\>500

and close\[1\]\*1.07\<close\[20\]

then ret=1;

## 場景 604：投資英雄傳之Seykota --- 其中糾結均線突破的腳本如下

> 來源：[[投資英雄傳之Seykota]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e8%b3%87%e8%8b%b1%e9%9b%84%e5%82%b3%e4%b9%8bseykota/)
> 說明：其中糾結均線突破的腳本如下

input: shortlength(5); setinputname(1,\"短期均線期數\");

input: midlength(10); setinputname(2,\"中期均線期數\");

input: Longlength(20); setinputname(3,\"長期均線期數\");

input: Percent(2); setinputname(4,\"均線糾結區間%\");

input: Volpercent(25);
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

if C crosses above Kprice then ret=1;

## 場景 605：投資英雄傳之Victor Sperandeo --- 我根據這個法則， 寫了一個腳本如下

> 來源：[[投資英雄傳之Victor
> Sperandeo]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e8%b3%87%e8%8b%b1%e9%9b%84%e5%82%b3%e4%b9%8bvictor-sperandeo/)
> 說明：我根據這個法則， 寫了一個腳本如下

if linearregslope(close,90)\<0 and lowestbar(close,90)\<20

then begin

value1=countif(low\<low\[1\],10);

end;

if value1=0 then ret=1;

## 場景 606：投資英雄傳\~Mark D. Cook

> 來源：[[投資英雄傳\~Mark D.
> Cook]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e8%b3%87%e8%8b%b1%e9%9b%84%e5%82%b3mark-d-cook/)
> 說明：主力買超天數指標

value1=GetField(\"主力買進金額\");

value2=GetField(\"主力賣出金額\");

value3=value1-value2;

var:count(0);

count=0;

input:days(20,\"計算天期\");

var:x(0);

for x=1 to days

begin

if value3\[x-1\]\>0

then count=count+1;

end;

plot1(count,\"主力買超天數指標\");

## 場景 607：投資英雄傳\~Mark D. Cook

> 來源：[[投資英雄傳\~Mark D.
> Cook]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e8%b3%87%e8%8b%b1%e9%9b%84%e5%82%b3mark-d-cook/)
> 說明：大盤內外盤差天數指標

value1=GetField(\"內盤量\");

value2=GetField(\"外盤量\");

value3=value2-value1;

var:count(0);

count=0;

input:days(20,\"計算天期\");

var:x(0);

for x=1 to days

begin

if value3\[x-1\]\>0

then count=count+1;

end;

plot1(count,\"內外盤差天數指標\");

## 場景 608：投資英雄傳\~Mark D. Cook --- 大盤上漲下跌家數差指標

> 來源：[[投資英雄傳\~Mark D.
> Cook]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e8%b3%87%e8%8b%b1%e9%9b%84%e5%82%b3mark-d-cook/)
> 說明：大盤上漲下跌家數差指標

value1=GetField(\"上漲家數\",\"D\");

value2=GetField(\"下跌家數\",\"D\");

value3=value1-value2;

var:count(0);

count=0;

input:days(20,\"計算天期\");

var:x(0);

for x=1 to days

begin

if value3\[x-1\]\>0

then count=count+1;

end;

plot1(count,\"主力買超天數指標\");

## 場景 609：投資英雄傳\~Marty Schwartz --- 我照了上面的描述寫了一個腳本如下

> 來源：[[投資英雄傳\~Marty
> Schwartz]{.underline}](https://www.xq.com.tw/xstrader/%e6%8a%95%e8%b3%87%e8%8b%b1%e9%9b%84%e5%82%b3marty-schwartz/)
> 說明：我照了上面的描述寫了一個腳本如下

if
GetSymbolField(\"tse.tw\",\"收盤價\",\"D\")=lowest(GetSymbolField(\"tse.tw\",\"收盤價\",\"D\"),10)

then begin

if trueall(low\>low\[1\],5)

and close cross over average(close,10)

then ret=1;

end;

## 場景 610：總市值前300大繼續型態突破 --- 其中的突破繼續型態腳本如下

> 來源：[[總市值前300大繼續型態突破]{.underline}](https://www.xq.com.tw/xstrader/%e7%b8%bd%e5%b8%82%e5%80%bc%e5%89%8d300%e5%a4%a7%e7%b9%bc%e7%ba%8c%e5%9e%8b%e6%85%8b%e7%aa%81%e7%a0%b4/)
> 說明：其中的突破繼續型態腳本如下

variable:iHigh(0); iHigh=maxlist(iHigh,H);

variable:iLow(100000); iLow=minlist(iLow,L);

variable:hitlow(0),hitlowdate(0);

if iLow = Low then

begin

hitlow+=1;

hitlowdate =date;

//觸低次數與最後一次觸低日期

end;

if DateAdd(hitlowdate,\"M\",2) \< Date
and//如果自觸低點那天1個月後都沒有再觸低

iHigh/iLow \< 1.3 and //波動在三成以內

iHigh = High

//來到設定日期以來最高點

and average(volume,100)\>500

//有一定的成交量

then ret =1;

## 場景 611：基本面創佳績的公司放量起漲 --- 這個選股法的前三項代表本業的營運創下很久以來的最佳成績，最後一項的腳本如下

> 來源：[[基本面創佳績的公司放量起漲]{.underline}](https://www.xq.com.tw/xstrader/%e5%9f%ba%e6%9c%ac%e9%9d%a2%e5%89%b5%e4%bd%b3%e7%b8%be%e7%9a%84%e5%85%ac%e5%8f%b8%e6%94%be%e9%87%8f%e8%b5%b7%e6%bc%b2/)
> 說明：這個選股法的前三項代表本業的營運創下很久以來的最佳成績，最後一項的腳本如下

if TrueAll( GetField(\"營業利益率\",\"Q\")\>0,4) and

TrueAll(GetField(\"稅後淨利率\",\"Q\")\>0,4) and

average(volume,5) \> 200 and

C\> 10 and

volume \> average(V\[1\],20) \*3 and

GetField(\"法人持股\",\"D\")- GetField(\"法人持股\",\"D\")\[5\]
\>GetField(\"最新股本\")\*10

then ret=1;

## 場景 612：有價值型投資概念的成長股投資法

> 來源：[[有價值型投資概念的成長股投資法]{.underline}](https://www.xq.com.tw/xstrader/%e6%9c%89%e5%83%b9%e5%80%bc%e5%9e%8b%e6%8a%95%e8%b3%87%e6%a6%82%e5%bf%b5%e7%9a%84%e6%88%90%e9%95%b7%e8%82%a1%e6%8a%95%e8%b3%87%e6%b3%95/)
> 說明：本業推估本益比低於N

input:peuplimit(12,\"預估本益比上限\");

value3= summation(GetField(\"營業利益\",\"Q\"),4); //單位百萬;

value4= GetField(\"最新股本\");//單位億;

value5= value3/(value4\*10);//每股預估EPS

if value5\>0 and close/value5\<=peuplimit

then ret=1;

## 場景 613：有價值型投資概念的成長股投資法

> 來源：[[有價值型投資概念的成長股投資法]{.underline}](https://www.xq.com.tw/xstrader/%e6%9c%89%e5%83%b9%e5%80%bc%e5%9e%8b%e6%8a%95%e8%b3%87%e6%a6%82%e5%bf%b5%e7%9a%84%e6%88%90%e9%95%b7%e8%82%a1%e6%8a%95%e8%b3%87%e6%b3%95/)

Input: day(10,\"日期區間\");

Input: ratioLimit(5, \"區間最大漲幅%\");

Condition1 = C=highest(C,day);

//今日最高創區間最高價

Condition2 = V=highest(v,day);

//今日成交量創區間最大量

Condition3 = highest(H,day) \< lowest(L,day)\*(1 + ratioLimit\*0.01);

//今日最高價距離區間最低價漲幅尚不大

Ret = Condition1 And Condition2 And Condition3;

## 場景 614：籌碼集中度大增的股票 --- 其中籌碼集中度篩選的腳本如下

> 來源：[[籌碼集中度大增的股票]{.underline}](https://www.xq.com.tw/xstrader/%e7%b1%8c%e7%a2%bc%e9%9b%86%e4%b8%ad%e5%ba%a6%e5%a4%a7%e5%a2%9e%e7%9a%84%e8%82%a1%e7%a5%a8/)
> 說明：其中籌碼集中度篩選的腳本如下

input:day(10,\"天數\");

input:ratio(20,\"最低百分比\");

settotalbar(day);

value1=GetField(\"主力買賣超張數\",\"D\");

if volume\<\>0 then

value2=summation(value1,day)/summation(volume,day)\*100

else

value2=0;

if value2\>=ratio then ret=1;

outputfield(1,value2,2,\"籌碼集中度\");

## 場景 615：十年寒窗股的一朝成名日 --- 其中無量變有量這個腳本如下

> 來源：[[十年寒窗股的一朝成名日]{.underline}](https://www.xq.com.tw/xstrader/%e5%8d%81%e5%b9%b4%e5%af%92%e7%aa%97%e8%82%a1%e7%9a%84%e4%b8%80%e6%9c%9d%e6%88%90%e5%90%8d%e6%97%a5/)
> 說明：其中無量變有量這個腳本如下

input:v1(1000,\"前一根bar成交量\");

input:v2(1500,\"這根bar成交量\");

if trueall(volume\[1\]\<=v1,10) and volume\>v2

then ret=1;

## 場景 616：整理夠久的股票開始上揚 --- 我把上述的想法寫成以下的腳本

> 來源：[[整理夠久的股票開始上揚]{.underline}](https://www.xq.com.tw/xstrader/%e6%95%b4%e7%90%86%e5%a4%a0%e4%b9%85%e7%9a%84%e8%82%a1%e7%a5%a8%e9%96%8b%e5%a7%8b%e4%b8%8a%e6%8f%9a/)
> 說明：我把上述的想法寫成以下的腳本

if close\<\>0 then

value1=truerange/close\*100;

if trueall(volume\[1\]\<1000,50)

and trueall(value1\[1\]\<3,50)

and close\>close\[1\]\*1.025

then ret=1;

## 場景 617：好股票平台整理後突破 --- 我們可以用以下的腳本來代表來挑出平台整理後突破的股票

> 來源：[[好股票平台整理後突破]{.underline}](https://www.xq.com.tw/xstrader/%e5%a5%bd%e8%82%a1%e7%a5%a8%e5%b9%b3%e5%8f%b0%e6%95%b4%e7%90%86%e5%be%8c%e7%aa%81%e7%a0%b4/)
> 說明：我們可以用以下的腳本來代表來挑出平台整理後突破的股票

input:Period(20, \"平台區間\");

input:ratio(7, \"整理幅度(%)\");

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

## 場景 618：M頭的腳本怎麼寫？

> 來源：[[M頭的腳本怎麼寫？]{.underline}](https://www.xq.com.tw/xstrader/m%e9%a0%ad%e7%9a%84%e8%85%b3%e6%9c%ac%e6%80%8e%e9%ba%bc%e5%af%ab%ef%bc%9f/)
> 說明：我自己的寫法如下：

value1=swinghigh(high,30,10,10,1);

//這段時間的第一轉折最高點

value2=swinghigh(high,30,10,10,2);

//這段時間的第二轉折高點

value3=swinglow(low,30,10,10,1);

//這段時間的第一轉折低點

value4=swinghighbar(high,30,10,10,1);

//第一轉折高點距離現在幾根BAR

value5=swinghighbar(high,30,10,10,2);

//第二轉折高點距離現在幾根BAR

value6=swinghighbar(low,30,10,10,1);

//轉折低點距離現在幾根BAR

if absvalue(value1-value2)/value1\*100\<3

//兩個高點差小於3%

and value6\>value4 and value6\<value5

//兩個高點中間有一個這段時間的低點

and value2=highest(high,100)

//第一個高點是長期以來的最高點

and close crosses under value3

//收盤價跌破這段計算時間的低點

then ret=1;

## 場景 619：估值高折價股盤整後出量 --- 基於這樣的原理，我寫了以下的腳本，來挑出在這種簡單的估值下，折價高的股票

> 來源：[[估值高折價股盤整後出量]{.underline}](https://www.xq.com.tw/xstrader/%e4%bc%b0%e5%80%bc%e9%ab%98%e6%8a%98%e5%83%b9%e8%82%a1%e7%9b%a4%e6%95%b4%e5%be%8c%e5%87%ba%e9%87%8f/)
> 說明：基於這樣的原理，我寫了以下的腳本，來挑出在這種簡單的估值下，折價高的股票

input:ratio(30,\"折價比例%\");

value1=GetField(\"營業利益\",\"Y\");//百萬

value2=GetField(\"每股淨值(元)\",\"Y\");

value3=GetField(\"普通股股本\",\"Y\");//單位:億

value4=value1\*5/100/value3\*10;

//用最近一年營業利益乘以五當未來五年的獲利

//算出未來五年的每股淨值增加值\]

value5=value2+value4;

//以目前的每股淨值加上上述數字即是公司內含價值

//(不考慮折舊的issue)

if close\*(1+ratio/100)\<value5

then ret=1;

outputfield(1,value5,1,\"內含價值\");

outputfield(2,close,2,\"目前股價\");

outputfield(3,1-close/value5,\"折溢價情況\");
