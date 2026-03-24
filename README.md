# XS-Claude-Code — 用 AI 寫 XScript 選股策略

> 讓 Claude Code 讀懂 XQ（嘉實資訊）的 XScript 語法，只需用自然語言描述策略邏輯，即可自動產生可直接匯入 XQ 的 `.xs` 選股腳本。

---

## 這個專案能做什麼？

| 你說的話 | Claude 產生的結果 |
|----------|-----------------|
| 「5日均線向上突破20日均線，成交量大於3000張」 | `scripts/ma5_cross_ma20_vol3000.xs` |
| 「依照威廉·歐尼爾 CAN SLIM 系統選股」 | `scripts/威廉歐尼爾_CANSLIM.xs` |
| 「德里豪斯動能投資：盈餘驚喜 + 營收加速 + 相對強勢」 | `scripts/德里豪斯_動能選股.xs` |

Claude Code 內建 XScript 語法規則與欄位對照表（`CLAUDE.md`），能自動處理：
- 正確的 `GetField` 欄位名稱與頻率對應
- 除法分母防呆
- 變數命名規範（禁止底線、禁止含 `daily`）
- 選股 / 警示 / 指標 / 自動交易 四種腳本類型的語法差異

---

## 快速開始

### 前置需求

- [Claude Code](https://docs.anthropic.com/claude-code)（需有 Anthropic API Key）
- [Git](https://git-scm.com/)
- VS Code（選用，建議安裝 **Claude Code for VS Code** 擴充套件）

### 安裝步驟

```bash
# 1. Clone 專案
git clone https://github.com/yingchauhuang/XS_Claude_Code.git
cd XS_Claude_Code

# 2a. 使用 Terminal 啟動
claude

# 2b. 使用 VS Code 啟動
#     File > Open Folder → 選擇 XS_Claude_Code 目錄
#     側邊欄點選 Claude Code 圖示即可對話
```

### 使用方式

啟動後，直接用中文描述你的選股邏輯：

```
把「威廉·歐尼爾 CAN SLIM 系統」寫成一個選股腳本，命名為「威廉歐尼爾」
```

Claude 會自動：
1. 解析邏輯並對應至 XScript 語法
2. 產生含逐行中文註解的完整腳本
3. 儲存至 `scripts/` 目錄（`.xs` 格式）

---

## 專案結構

```
XS-Claude-Code/
├── CLAUDE.md                          ← Claude Code 核心指令（語法規則、欄位字典）
├── README.md
├── docs/
│   ├── XScript_官方語法與核心說明文件.md   ← 官方語法、函數、欄位定義
│   ├── XScript_實戰範例寶典_上.md          ← 範例腳本 場景 1–619
│   ├── XScript_實戰範例寶典_下.md          ← 範例腳本 場景 620–1241
│   └── XScript_系統預設腳本庫.md           ← XQ 內建系統腳本
└── scripts/
    ├── ma5_cross_ma20_vol3000.xs          ← 均線黃金交叉 + 量能篩選
    ├── 威廉歐尼爾_CANSLIM.xs              ← CAN SLIM 七大準則
    └── 德里豪斯_動能選股.xs               ← 動能投資：盈餘驚喜 + 相對強勢
```

---

## 參考文件優化說明

原始 XScript 官方文件在轉換過程中含有大量 Pandoc 殘留符號與重複區塊，本專案已進行預處理：

| 文件 | 優化前 | 優化後 | 節省 |
|------|--------|--------|------|
| 實戰範例寶典（上） | 759 KB | 525 KB | −31% |
| 實戰範例寶典（下） | 594 KB | 586 KB | −1% |
| 系統預設腳本庫 | 890 KB | 856 KB | −4% |
| 官方語法文件 | 82 KB | 81 KB | ~0% |
| **合計** | **2.3 MB** | **2.0 MB** | **−13%** |

**處理項目：**
- 移除 `\[ \* \" \>` 等 Pandoc 逃脫字元
- 刪除 619 條重複的來源連結區塊
- 壓縮連續空行
- 程式碼、中文註解、函數簽名、場景編號**完整保留**

---

## 注意事項

- 所有產生的策略腳本僅供技術開發與研究參考，**不構成投資建議**
- XScript 語法以 XQ 官方文件為準，如有衝突以官方為依據
