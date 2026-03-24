// ================================================================
// 策略名稱：威廉·歐尼爾 CAN SLIM 選股系統
// 腳本類型：選股腳本 (Scanner)
// 作    者：依據 William J. O'Neil《笑傲股市》原著邏輯實作
//
// CAN SLIM 七大準則：
// C — Current Earnings   : 當季 EPS 年增率 ≥ 25%，且為正值
// A — Annual Earnings    : 近三年年度 EPS 逐年成長，當年增率 ≥ 25%
// N — New Highs          : 股價突破整理，處於 52 週高點的 85% 以上
// S — Supply and Demand  : 突破當日成交量 ≥ 50 日均量的 150%
// L — Leader or Laggard  : 近 12 個月（約 250 日）漲幅 ≥ 25%（強勢領導股）
// I — Institutional      : 三大法人近日合計淨買超 > 0
// M — Market Direction   : 股價站上 200 日均線（順勢操作）
// ================================================================

SetTotalBar(260);   // 確保讀取 260 根 K 棒（計算 200MA 及 52 週高點所需）

// ── 輸入參數（可在 XQ 介面調整）──────────────────────────────
Input: threshGrowthQ(25,  "C: 當季EPS年增率門檻(%)");
Input: threshGrowthY(25,  "A: 年度EPS成長率門檻(%)");
Input: threshHighRatio(0.85, "N: 距52週高點最低比例(0~1)");
Input: threshVolMulti(1.5,   "S: 突破量能倍數門檻");
Input: threshRsRate(25,   "L: 近12個月漲幅門檻(%)");

// ── 變數宣告（無底線、無 daily）───────────────────────────────
// C
Var: epsQCur(0), epsQPrior(0), growthQ(0);
// A
Var: epsYCur(0), epsYPrior(0), growthY(0);
// N
Var: highN52(0), nearHighPct(0);
// S
Var: avgVol50(0), volRatio(0);
// L
Var: rsRate(0);
// I
Var: instBuy(0);
// M
Var: ma200(0), ma200Gap(0);

// ================================================================
// C — Current Earnings：當季 EPS 年增率 ≥ 門檻，且 EPS > 0
// ================================================================
epsQCur   = GetField("每股稅後淨利(元)", "Q");      // 最新一季 EPS
epsQPrior = GetField("每股稅後淨利(元)", "Q")[4];   // 去年同季 EPS（4 季前）

if epsQPrior <> 0 then
    growthQ = (epsQCur - epsQPrior) / epsQPrior * 100
else
    growthQ = 0;

// 條件：成長率達標、且本季獲利（非虧損）
Condition1 = growthQ >= threshGrowthQ and epsQCur > 0;

// ================================================================
// A — Annual Earnings：年度 EPS 成長率 ≥ 門檻
// ================================================================
epsYCur   = GetField("每股稅後淨利(元)", "Y");      // 最新年度 EPS
epsYPrior = GetField("每股稅後淨利(元)", "Y")[1];   // 前一年度 EPS

if epsYPrior <> 0 then
    growthY = (epsYCur - epsYPrior) / epsYPrior * 100
else
    growthY = 0;

// 條件：年度成長率達標、且去年也是獲利
Condition2 = growthY >= threshGrowthY and epsYCur > 0 and epsYPrior > 0;

// ================================================================
// N — New Highs：股價處於 52 週高點附近（突破整理區間）
// ================================================================
highN52 = Highest(High, 250);   // 近 250 根 K 棒（約 1 年）最高價

if highN52 <> 0 then
    nearHighPct = Close / highN52 * 100
else
    nearHighPct = 0;

// 條件：收盤價 ≥ 52 週高點的 85%（處於高位突破區，非腰斬股）
Condition3 = nearHighPct >= threshHighRatio * 100;

// ================================================================
// S — Supply and Demand：突破當日量能放大
// ================================================================
avgVol50 = Average(Volume, 50);   // 50 日平均成交量

if avgVol50 <> 0 then
    volRatio = Volume / avgVol50
else
    volRatio = 0;

// 條件：成交量 ≥ 50 日均量 × 門檻倍數（量能確認突破有效）
Condition4 = avgVol50 > 0 and Volume >= avgVol50 * threshVolMulti;

// ================================================================
// L — Leader：近 12 個月相對強度（漲幅 ≥ 門檻，領導股非落後股）
// ================================================================
if Close[250] <> 0 then
    rsRate = (Close - Close[250]) / Close[250] * 100
else
    rsRate = 0;

// 條件：近一年漲幅 ≥ 門檻（動能強勢的領導股）
Condition5 = rsRate >= threshRsRate;

// ================================================================
// I — Institutional Sponsorship：三大法人近日合計淨買超
// ================================================================
instBuy = GetField("法人買賣超張數", "D");   // 三大法人合計買賣超（張）

// 條件：法人為淨買方（機構持續進場）
Condition6 = instBuy > 0;

// ================================================================
// M — Market Direction：股價站上 200 日均線（順大盤多頭操作）
// ================================================================
ma200 = Average(Close, 200);

if ma200 <> 0 then
    ma200Gap = (Close / ma200 - 1) * 100
else
    ma200Gap = 0;

// 條件：收盤價高於 200 日均線（個股處於多頭格局）
Condition7 = Close > ma200;

// ================================================================
// 最終觸發：CAN SLIM 七大準則全部成立
// ================================================================
if Condition1 and Condition2 and Condition3
   and Condition4 and Condition5 and Condition6 and Condition7 then
begin
    ret = 1;

    // 輸出九宮格欄位（方便結果排序與比較）
    OutputField(1, growthQ,      1, "C 季EPS成長%");    // 當季 EPS 年增率
    OutputField(2, growthY,      1, "A 年EPS成長%");    // 年度 EPS 成長率
    OutputField(3, nearHighPct,  1, "N 距高點%");       // 佔52週高點比例
    OutputField(4, volRatio,     2, "S 量能倍數");      // 成交量 / 50日均量
    OutputField(5, rsRate,       1, "L RS強度%");       // 近12月漲幅
    OutputField(6, instBuy,      0, "I 法人買超(張)");  // 三大法人買超張數
    OutputField(7, ma200Gap,     1, "M 距MA200%");      // 超越200日均線幅度
    OutputField(8, epsQCur,      2, "最新季EPS");       // 參考用：最新季EPS
end;
