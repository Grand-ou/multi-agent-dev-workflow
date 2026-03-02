# Multi-Agent Development Workflow Skill

標準化的多 Agent 協作開發流程，適用於大型專案的功能開發。

## 📁 文件結構

```
multi-agent-dev-workflow/
├── SKILL.md                       # 主要 Skill 文檔（完整流程說明）
├── BORIS_TANE_METHOD.md          # Boris Tane 三步法整合（⭐ 核心方法論）
├── README.md                      # 本文件
├── templates/                     # 範本文件
│   ├── PLAN_TEMPLATE.md          # 開發計劃範本
│   └── AGENTS_STATUS_TEMPLATE.md # Agent 狀態追蹤範本
├── scripts/                       # 輔助腳本
│   ├── start-task.sh             # 啟動任務腳本
│   └── merge-task.sh             # 合併任務腳本
└── examples/                      # 範例專案
    └── example-plan.md           # 完整範例計劃
```

## ⭐ 重點：Boris Tane 方法論

**強烈建議先閱讀 [`BORIS_TANE_METHOD.md`](BORIS_TANE_METHOD.md)**

這份文檔整合了 Boris Tane 花 9 個月摸索出的核心工作流：
- **先不要寫代碼** - 強制分離思考與執行
- **三步法**: 理解 → 計劃（批注迭代）→ 執行
- **research.md + plan.md** - 持久化 AI 的理解與計劃
- **對齊重於生成** - AI 的價值在對齊，不在執行速度

## 🚀 快速開始

### 1. 讀取 Skill 文檔

```bash
cat SKILL.md
```

### 2. 複製範本到專案

```bash
# 複製開發計劃範本
cp templates/PLAN_TEMPLATE.md /path/to/your/project/PLAN.md

# 複製狀態追蹤範本
cp templates/AGENTS_STATUS_TEMPLATE.md /path/to/your/project/AGENTS_STATUS.md
```

### 3. 編輯開發計劃

在 `PLAN.md` 中定義所有任務。

### 4. 使用腳本啟動任務

```bash
# 給腳本執行權限
chmod +x scripts/*.sh

# 啟動任務
cd /path/to/your/project
/path/to/skills/multi-agent-dev-workflow/scripts/start-task.sh \
  auth-system \
  feature/auth-system \
  "實作 Google OAuth 認證系統"
```

### 5. 啟動 Sub-Agent

```bash
sessions_spawn(
  task="[從 PLAN.md 複製詳細任務描述]",
  agentId="code-agent",
  label="auth-system",
  cleanup="keep"
)
```

### 6. 合併完成的任務

```bash
/path/to/skills/multi-agent-dev-workflow/scripts/merge-task.sh \
  feature/auth-system
```

## 📚 核心概念

### Workflow 流程

```
準備階段 → 啟動 Sub-Agents → 開發 → 審核 → 合併 → 整合測試
```

### Branch 策略

- `main` - 主幹分支，永遠保持可部署狀態
- `feature/功能名稱` - 功能開發分支
- `fix/問題描述` - Bug 修復分支

### Agent 角色

- **主 Agent** (Main Agent)
  - 建立開發計劃
  - 啟動與管理 Sub-Agents
  - 審核程式碼
  - 合併 feature branches
  - 執行整合測試

- **Sub-Agent** (Code Agent)
  - 在指定 feature branch 開發功能
  - 實作、測試、提交程式碼
  - 回報完成狀態

## 🔧 常用指令

### 檢視所有 Feature Branches
```bash
git branch -a | grep feature/
```

### 查看所有進行中的 Sub-Agents
```bash
sessions_list(kinds=["isolated"])
```

### 檢查特定 Sub-Agent 的狀態
```bash
sessions_history(sessionKey="agent:main:isolated:auth-system")
```

### 向 Sub-Agent 發送訊息
```bash
sessions_send(
  sessionKey="agent:main:isolated:auth-system",
  message="請問進度如何？"
)
```

## 📖 範例專案

請參考 `examples/example-plan.md` 查看完整的開發計劃範例。

## 🔗 相關文檔

- [Git Feature Branch Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [OpenClaw Sessions Documentation](https://docs.openclaw.ai)

## 📝 版本歷史

- **v1.0.0** (2026-03-02): 初始版本
  - 完整的 Workflow 定義
  - 範本文件
  - 輔助腳本
  - 範例專案

## 📄 授權

MIT License

## 👤 作者

Grand-ou

## 🤝 貢獻

歡迎提交 Issue 或 Pull Request！
