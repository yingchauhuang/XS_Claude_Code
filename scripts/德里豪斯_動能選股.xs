// ================================================================
// 策略名稱：德里豪斯 動能選股系統
// 腳本類型：選股腳本 (Scanner)
// 作    者：依據 Richard Driehaus 動能投資哲學實作
//
// 六大核心準則：
// 一、盈餘驚喜   : 最新季EPS 較前一季或去年同期 成長 ≥ 20%
// 二、營收動能   : 近三個月營收年增率均為正，且逐月加速（月增率遞增）
// 三、股價趨勢   : 多頭排列(Close>MA5>MA20>MA60)，且近20日曾創52週新高
// 四、相對強度   : 近65日（約3個月）漲幅排市場前20%（以≥15%近似）
// 五、量能確認   : 近5日均量 ≥ 近20日均量 × 150%
// 六、停損紀律   : 輸出買入停損參考價（現價 × 92%，即8%停損線）
// ================================================================

SetTotalBar(260);   // 讀取260根K棒（確保250日最高價與長均線計算足夠）

// ── 輸入參數（可於XQ介面調整）──────────────────────────────────
Input: threshEpsGrowth(20,   "一: EPS成長門檻(%)，超越前季或去年同期");
Input: threshRsRate(15,      "四: 近65日漲幅門檻(%)，相對強度篩選");
Input: threshVolAccel(1.5,   "五: 均量加速倍數，5日均量/20日均量");
Input: stopLossPct(8,        "六: 停損百分比(%)，買入價下方幾%出場");

// ── 變數宣告（無底線、無daily）──────────────────────────────────
// 一、盈餘驚喜
Var: epsNow(0), epsPrevQ(0), epsPrevY(0);
Var: growthQoQ(0), growthYoY(0);

// 二、營收動能（用月營收原始值手動計算年增率）
Var: revM0(0), revM1(0), revM2(0);     // 近三個月月營收
Var: revM12(0), revM13(0), revM14(0);  // 去年同期月營收
Var: revYoy0(0), revYoy1(0), revYoy2(0);

// 三、股價趨勢
Var: ma5(0), ma20(0), ma60(0);
Var: highRecent(0), highN52(0), isNewHigh(false);

// 四、相對強度
Var: rsRate65(0);

// 五、量能確認
Var: vol5(0), vol20(0), volAccelRatio(0);

// 六、停損
Var: stopPrice(0);

// ================================================================
// 一、盈餘驚喜
//     最新季EPS 超越「前一季」或「去年同季」任一項 ≥ 20%
//     且本季EPS為正值（非虧損）
// ================================================================
epsNow  = GetField("每股稅後淨利(元)", "Q");     // 最新一季 EPS
epsPrevQ = GetField("每股稅後淨利(元)", "Q")[1]; // 前一季 EPS
epsPrevY = GetField("每股稅後淨利(元)", "Q")[4]; // 去年同季 EPS

// 計算環比（QoQ）成長率，分母防呆
if epsPrevQ <> 0 then growthQoQ = (epsNow - epsPrevQ) / epsPrevQ * 100
else growthQoQ = 0;

// 計算年比（YoY）成長率，分母防呆
if epsPrevY <> 0 then growthYoY = (epsNow - epsPrevY) / epsPrevY * 100
else growthYoY = 0;

// 觸發條件：兩者中任一超越門檻，且當季獲利
Condition1 = (growthQoQ >= threshEpsGrowth or growthYoY >= threshEpsGrowth)
             and epsNow > 0;

// ================================================================
// 二、營收動能
//     選股腳本不支援 GetField("營收年增率","M")，
//     改取「月營收」原始值，手動比較去年同月計算年增率
// ================================================================
revM0  = GetField("月營收", "M");      // 最新月營收
revM1  = GetField("月營收", "M")[1];   // 前1個月營收
revM2  = GetField("月營收", "M")[2];   // 前2個月營收
revM12 = GetField("月營收", "M")[12];  // 去年同月營收
revM13 = GetField("月營收", "M")[13];  // 去年前1月營收
revM14 = GetField("月營收", "M")[14];  // 去年前2月營收

// 手動計算各月年增率，分母防呆
if revM12 <> 0 then revYoy0 = (revM0 - revM12) / revM12 * 100 else revYoy0 = 0;
if revM13 <> 0 then revYoy1 = (revM1 - revM13) / revM13 * 100 else revYoy1 = 0;
if revM14 <> 0 then revYoy2 = (revM2 - revM14) / revM14 * 100 else revYoy2 = 0;

// 三個月年增率均為正，且逐月加速（revYoy0 最新，應最大）
Condition2 = revYoy0 > 0 and revYoy1 > 0 and revYoy2 > 0
             and revYoy0 > revYoy1 and revYoy1 > revYoy2;

// ================================================================
// 三、股價趨勢
//     均線多頭排列：Close > MA5 > MA20 > MA60
//     且近20日內曾觸及52週最高點（突破整理確認）
// ================================================================
ma5  = Average(Close, 5);   // 5日均線
ma20 = Average(Close, 20);  // 20日均線
ma60 = Average(Close, 60);  // 60日均線

highRecent = Highest(High, 20);   // 近20日最高點
highN52    = Highest(High, 250);  // 近250日（52週）最高點

// 近20日最高 = 52週最高，代表本股在近20日內曾創年度新高
if highRecent = highN52 then isNewHigh = true
else isNewHigh = false;

// 多頭排列 且 近20日曾創52週新高
Condition3 = Close > ma5 and ma5 > ma20 and ma20 > ma60
             and isNewHigh = true;

// ================================================================
// 四、相對強度
//     近65個交易日（約3個月）漲幅，作為市場前20%的近似篩選門檻
//     （XScript無法直接跨股排名，以絕對漲幅門檻近似替代）
// ================================================================
if Close[65] <> 0 then rsRate65 = (Close - Close[65]) / Close[65] * 100
else rsRate65 = 0;

// 近3個月漲幅達門檻（強勢領先股的近似條件）
Condition4 = rsRate65 >= threshRsRate;

// ================================================================
// 五、成交量確認
//     近5日平均量 ≥ 近20日平均量 × 1.5
//     代表市場資金正在積極追捧，非縮量假突破
// ================================================================
vol5  = Average(Volume, 5);   // 近5日平均成交量
vol20 = Average(Volume, 20);  // 近20日平均成交量

// 計算量能加速比，分母防呆
if vol20 <> 0 then volAccelRatio = vol5 / vol20
else volAccelRatio = 0;

// 5日均量 ≥ 20日均量 × 倍數門檻
Condition5 = vol20 > 0 and vol5 >= vol20 * threshVolAccel;

// ================================================================
// 六、停損參考價（不作為篩選條件，僅輸出供交易紀律參考）
//     買入當下以收盤價計算，跌破此價位應嚴格出場
// ================================================================
stopPrice = Close * (1 - stopLossPct / 100);

// ================================================================
// 最終觸發：五大選股準則全部成立
// ================================================================
if Condition1 and Condition2 and Condition3 and Condition4 and Condition5 then
begin
    ret = 1;

    // 輸出九宮格欄位（可用於結果排序與比較）
    OutputField(1, growthQoQ,      1, "一 EPS環比%");     // 環比成長率
    OutputField(2, growthYoY,      1, "一 EPS年比%");     // 年比成長率
    OutputField(3, revYoy0,        1, "二 最新月營收年增%"); // 最新月營收年增率
    OutputField(4, rsRate65,       1, "四 65日漲幅%");    // 近3個月相對強度
    OutputField(5, volAccelRatio,  2, "五 量能加速倍數");  // 5日/20日均量比
    OutputField(6, ma60,           2, "MA60均線價");      // 最後一道均線支撐參考
    OutputField(7, stopPrice,      2, "六 停損參考價");    // 8%停損線（元）
    OutputField(8, epsNow,         2, "最新季EPS(元)");   // 盈餘絕對值參考
end;
