# XScript Trading Script Project — Claude Code Instructions

> **Purpose**: This file instructs Claude Code how to write XScript for the XQ (嘉實資訊) trading platform.
> Read ALL reference documents before generating any script.

---

## 📁 Reference Documents (Read Before Writing)

| File | Contents |
|------|----------|
| `docs/XScript_官方語法與核心說明文件.md` | ✅ Official syntax — variables, operators, functions, data fields |
| `docs/XScript_實戰範例寶典_上.md` | ✅ Real examples: Scenes 1–619 (619 scripts) |
| `docs/XScript_實戰範例寶典_下.md` | ✅ Real examples: Scenes 620–1241 (622 scripts) |
| `docs/XScript_系統預設腳本庫.md` | ✅ Built-in system script library |

**When writing any script, always:**
1. **確認執行環境**：判斷使用者要寫的是「選股(Screener)」、「警示(Sensor)」、「指標(Indicator)」還是「自動交易(AutoTrade)」
2. Read the syntax doc for correct function signatures
3. Search the 實戰範例寶典 for similar patterns
4. Use the 系統預設腳本庫 if a built-in script covers the use case

---

## 🚨 Core Rules — Hard Constraints (違反將導致編譯失敗)

### 1. 變數命名鐵律
- 只能使用**純英文字母與數字**，強烈建議駝峰式命名（CamelCase）
- **絕對禁止**使用底線 `_`（例如：`my_vol` 錯誤，應寫 `myVol`）
- **絕對禁止**變數名稱中包含系統保留字串 `daily`（例如：`dailyVol` 錯誤，必須改成 `volToday`）

| 錯誤命名 | 正確命名 |
|---------|---------|
| `daily_vol` | `volToday` |
| `ma_20` | `ma20` |
| `is_match` | `isMatch` |
| `dailyHigh` | `highToday` |

### 2. 邏輯判斷符號
- XScript 的「等於」判斷是**單一等號** `=`
- **絕對不可**使用雙等號 `==`

### 3. 變數宣告
- 所有自訂變數必須在腳本最上方的 `var:` 區塊中事先宣告並給予初始值
- 範例：`var: isMatch(false), myVol(0), revRate(0);`

### 4. 防呆與運算保護
- 除法運算**必須**加上分母不為零的防呆機制：
```xscript
if denominator <> 0 then result = numerator / denominator
else result = 0;
```
- 若腳本需讀取長天期歷史資料（如 200日均線、過去 5年財報），**必須**在腳本開頭加上：
```xscript
SetTotalBar(N);   // N 為所需最大 K 棒數
```

---

## 🧱 XScript Language Rules

### Core Syntax
- Every statement ends with **semicolon** `;`
- Language is **case-insensitive** (`Close` = `close` = `CLOSE`)
- Equal sign `=` is used for BOTH assignment AND comparison (NOT `==`)
- Historical K-bar reference: `Close[1]` = previous bar, `Close[5]` = 5 bars ago
- Comments: `//` single-line, `{ }` multi-line block

### Variable & Input Declaration
```xscript
Input: length(20);            // parameter — fixed, user-adjustable in UI
Input: length(20, "期數");    // parameter with Chinese label

Var: ma(0);                   // numeric variable, initial 0
Var: flag(false);             // boolean variable
Var: msg("hello");            // string variable
Var: x(0), y(0), z(0);       // multiple variables in one line
```

### System Variables (no declaration needed)
```xscript
Value1 ~ Value99        // numeric (e.g. Value1 = Average(Close, 20);)
Condition1 ~ Condition99  // boolean (e.g. Condition1 = Close > Value1;)
```

### Reserved Data Words (K-bar data)
```xscript
Open / O      // opening price
High / H      // high price
Low / L       // low price
Close / C     // closing price
Volume / V    // volume
Date / D      // date (YYYYMMDD)
Time / T      // time (HHMMSS)
Uplimit       // upper limit price (daily freq only)
Downlimit     // lower limit price (daily freq only)
```

### Real-time Quote Fields (q_ prefix)
```xscript
q_DailyOpen, q_DailyHigh, q_DailyLow, q_DailyVolume
q_RefPrice, q_AvgPrice, q_Last
q_Bid, q_Ask, q_BidAskFlag
q_InSize, q_OutSize          // buy/sell tick volume
q_SumBidSize, q_SumAskSize   // total bid/ask 5-level sum
q_BestBid1~5, q_BestAsk1~5  // 5-level bid/ask prices
q_BestBidSize1~5, q_BestAskSize1~5
q_DailyUplimit, q_DailyDownlimit
q_PriceChangeRatio           // intraday change %
```

---

## 📊 Data Dictionary — 精確欄位正名 (GetField)

XQ 系統對財報欄位名稱要求極度精確，請嚴格使用以下字串。

### 基本語法
```xscript
GetField("欄位名稱")              // latest value
GetField("外資買賣超", "D")       // daily frequency
GetField("每股稅後淨利(元)", "Q") // quarterly
GetField("營收年增率", "M")       // monthly
```

### 欄位正名對照表

| 類別 | 正確欄位名稱 | 錯誤寫法 | 備註 |
|------|------------|---------|------|
| EPS | `每股稅後淨利(元)` | `每股稅後淨利` | 必須含 `(元)` |
| 企業價值 | `企業價值` | — | — |
| 現金流估值 | `股價自由現金流比` | `股價現金流比` | 不支援後者 |
| 負債 | `負債總額` | `總負債` | — |
| 資產 | `資產總額` | `總資產` | — |
| 內部人持股 | `董監持股佔股本比例` | — | — |
| 外資 | `外資買賣超` | — | 單位：股 |
| 外資持股 | `外資持股比例` | — | — |
| 主力 | `主力買賣超張數` | — | — |
| 融資 | `融資餘額` | — | — |
| 融券 | `融券餘額` | — | — |
| 淨值 | `每股淨值` | — | — |
| ROE | `股東權益報酬率` | — | — |
| 關鍵券商 | `關鍵券商買賣超張數` | — | 頻率 "D" |

### ⚠️ 營收成長率欄位依頻率變形（極度重要）

| 頻率參數 | 正確欄位名稱 | 錯誤寫法 |
|---------|------------|---------|
| `"Y"` (年) 或 `"Q"` (季) | `營收成長率` | `營收年增率` |
| `"M"` (月) | `營收年增率` | `營收成長率` |

```xscript
// 正確範例
GetField("營收成長率", "Y")   // 年頻率
GetField("營收成長率", "Q")   // 季頻率
GetField("營收年增率", "M")   // 月頻率 ← 不同欄位名！
```

---

## 📦 Script Types & Output Methods

### Type A：選股腳本 (Scanner / 盤後篩選)
- 觸發條件成立時：`ret = 1;`
- **支援** `OutputField` 語法輸出九宮格欄位
- 可以使用 `GetField("漲跌幅", "D")` 等系統計算好之行情欄位

```xscript
if condition then ret = 1;
OutputField(1, GetField("每股稅後淨利(元)", "Q"), 2, "EPS");
OutputField(2, Close / (GetField("每股稅後淨利(元)", "Q") * 4), 1, "本益比");
```

### Type B：警示腳本 (Strategy Radar / 盤中即時)
- 觸發條件成立時：`ret = 1;`
- **絕對禁止**使用 `OutputField`。推播資訊必須改用：
```xscript
retmsg = "漲幅：" + NumToStr(changeRate, 2) + "%";
```
- **絕對禁止**直接呼叫漲跌幅等延遲運算欄位。需手動計算：
```xscript
// 手動計算漲跌幅
Var: refPrice(0), changeRate(0);
refPrice = GetField("參考價", "D");
if refPrice <> 0 then changeRate = (Close - refPrice) / refPrice * 100
else changeRate = 0;
```

### Type C：指標腳本 (Indicator)
- Ends with: `Plot1(value, "label");`
```xscript
Plot1(Average(Close, 20), "MA20");
Plot2(Average(Close, 60), "MA60");
```

### Type D：策略雷達 (AutoTrade)
- Uses `SetPosition` for order signals:
```xscript
if condition then SetPosition(1, Market);   // buy 1 unit at market
if condition then SetPosition(0, Market);   // close position
```

---

## 🔄 Flow Control

```xscript
// Single condition
if Close > Close[1] then ret = 1;

// With Else — NO semicolon before else
if Close[1] > High then TrueHigh = Close[1]
else TrueHigh = High;

// Multiple statements — use Begin...End
if Open > High[1] then
begin
    Value1 = (1 - Close[1] / Close[3]) * 100;
    Value2 = (Open - High[1]) / Close * 100;
end;

// For loop
for Value1 = 1 to 10
begin
    total = total + Close[Value1];
end;

// While loop
while i < 10
begin
    Value1 = Value1 + Close[i];
    i = i + 1;
end;

// Return early (common guard)
if BarFreq <> "D" then Return;      // only run on daily bars
if Date <> CurrentDate then Return; // only run today's bars
```

---

## 📋 Script Writing — 6-Step Structure (ALWAYS follow this order)

```xscript
// Step 1: SetTotalBar (若需長天期資料)
SetTotalBar(250);

// Step 2: Declare Input parameters
Input: length(20, "均線期數");
Input: minVol(1000, "最小成交量(張)");

// Step 3: Declare Variables (所有自訂變數，禁止底線、禁止 daily)
Var: maVal(0), maYest(0), fBuy(0), outRatio(0);

// Step 4: GetField — end-of-day/fundamental data
Value1 = GetField("外資買賣超", "D");
Value2 = GetField("每股稅後淨利(元)", "Q");

// Step 5: Build calculations (含除法防呆)
maVal = Average(Close, length);
maYest = Average(Close[1], length);
if Value3 <> 0 then outRatio = Value2 / Value3
else outRatio = 0;

Condition1 = Close > maVal and maVal > maYest;
Condition2 = Value1 > 0;
Condition3 = Volume > minVol;

// Step 6: Set trigger or plot output
if Condition1 and Condition2 and Condition3 then ret = 1;
```

---

## ⚠️ Common Mistakes to Avoid

| Wrong | Correct |
|-------|---------|
| `if Close == High` | `if Close = High` |
| `Close > Close[1] > Close[2]` | `Close > Close[1] and Close[1] > Close[2]` |
| `GetField("每股稅後淨利", "Q")` | `GetField("每股稅後淨利(元)", "Q")` |
| `GetField("營收年增率", "Q")` | `GetField("營收成長率", "Q")` |
| 選股腳本用 `GetField("營收年增率","M")` | 改用 `GetField("月營收","M")` 自行計算年增率 |
| `GetField("總負債")` | `GetField("負債總額")` |
| `GetField("總資產")` | `GetField("資產總額")` |
| `Var: daily_vol(0)` | `Var: volToday(0)` |
| `Var: isMatch_flag(false)` | `Var: isMatchFlag(false)` |
| Semicolon before `else` | No semicolon before `else` |
| Multiple statements without `Begin...End` | Wrap in `begin ... end;` |
| Division without zero-check | `if denom <> 0 then x = a / denom else x = 0;` |
| `OutputField` in 警示腳本 | Use `retmsg = "..." + NumToStr(val, 2);` |

---

## 🔧 Useful Built-in Functions

```xscript
// Technical
Average(Close, 20)              // simple moving average
Highest(High, 20)               // highest value in N bars
Lowest(Low, 20)                 // lowest value in N bars
RSI(Close, 14)                  // RSI
MACD(Close, 12, 26, 9)         // MACD
BollingerBands(Close, 20, 2)   // Bollinger Bands
StandardDev(Close, 20, 1)      // standard deviation (1 = sample)
CrossOver(a, b)                 // a crosses above b
CrossUnder(a, b)                // a crosses below b
TrueAll(condition, n)           // condition true for all N bars
TrueOnce(condition, n)          // condition true at least once in N bars

// System
SetTotalBar(n)                  // set max historical bars to load (long-period data)
SetBackBar(n)                   // alternative: set back bar count
RaiseRunTimeError("msg")        // throw error with message
BarFreq                         // "Tick", "Min", "Hour", "D", "W", "M"
BarInterval                     // e.g. 5 for 5-minute bars
CurrentDate                     // today's date YYYYMMDD
CurrentTime                     // current time HHMMSS

// Cross signals
CrossOver(shortMA, longMA)      // golden cross
CrossUnder(shortMA, longMA)     // death cross
// Alternative syntax:
// shortMA Crosses Above longMA
// shortMA Crosses Below longMA
```

---

## 💡 Golden Example：完整選股腳本 (標準範本)

```xscript
// 策略：月營收創高與多頭排列
SetTotalBar(60);

Var: revYoy(0), isMaUp(false);  // 無底線、無 daily

revYoy = GetField("營收年增率", "M");  // 月頻率正確使用「營收年增率」

if Close > Average(Close, 20) and Average(Close, 20) > Average(Close, 60)
then isMaUp = true
else isMaUp = false;

if revYoy > 20.0 and isMaUp = true then
begin
    ret = 1;
    OutputField(1, revYoy, 1, "營收年增率(%)");
end;
```

---

## 💡 Example：Complete Screening Script Pattern

```xscript
// Foreign buying + high outside volume + price up
Input: days(10, "法人買超均線期數");
Input: minBuy(1000, "最小買超張數");

Var: avgBuy(0), outRatio(0);

Value1 = GetField("外資買賣超", "D");
Value2 = q_OutSize;
Value3 = q_DailyVolume;

avgBuy = Average(Value1, days);          // N-day avg foreign buy
if Value3 <> 0 then outRatio = Value2 / Value3   // 除法防呆
else outRatio = 0;

Condition1 = avgBuy > minBuy;            // buying above threshold
Condition2 = outRatio > 0.5;            // outside volume > 50%
Condition3 = Close > Close[1];           // price up today

if Condition1 and Condition2 and Condition3 then ret = 1;

OutputField(1, avgBuy, 0, "外資均買超");
OutputField(2, outRatio * 100, 1, "外盤比%");
```

---

## 📝 Output Format (回覆規範)

當使用者提出策略需求時，回覆應包含：

1. **邏輯解構**：簡短說明如何將需求轉化為 XScript 條件
2. **程式碼區塊**：提供加上**逐行中文註解**的完整程式碼
3. **除錯說明**（若為除錯任務）：先說明**錯誤原因**，再給出**修正後的完整程式碼**
4. **自我檢查清單 (Self-Check)**：在回覆最後聲明已確認：
   - [ ] 變數無底線 `_`
   - [ ] 變數名稱不含 `daily`
   - [ ] 等號為單一等號 `=`（無 `==`）
   - [ ] 除法已加分母不為零防呆
   - [ ] 符合該腳本類型的特殊限制（OutputField / retmsg）
   - [ ] 財報欄位名稱精確（含頻率對應正確）

> 所有策略僅供技術開發參考，不構成投資建議。如官方文件與一般程式邏輯有衝突，以官方文件為準。

---

## 🗂️ Output Location

Save generated scripts to: `scripts/` folder
File extension: `.xs` (e.g. `scripts/my_strategy.xs`)
