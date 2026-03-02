# Multi-Agent Development Workflow

**Version**: 1.0.0  
**Author**: Grand-ou  
**Created**: 2026-03-02  
**Last Updated**: 2026-03-02

---

## 📖 Skill Description

這個 Skill 定義了一個標準化的多 Agent 協作開發流程，適用於大型專案的功能開發。

**核心理念**：
- 每個功能/任務由獨立的 Sub-Agent 負責
- 每個 Sub-Agent 在自己的 feature branch 上開發
- 開發完成後透過 Pull Request 合併到 main branch
- 主 Agent 負責協調、審核與整合

**適用場景**：
- ✅ 大型專案的功能開發
- ✅ 需要多個獨立功能同時進行
- ✅ 需要版本控制與程式碼審核
- ✅ 團隊協作開發

---

## 🎯 Workflow 步驟

### Phase 0: 專案準備

**主 Agent 工作**：

1. **分析需求並建立開發計劃**
   - 檢視需求文件或現有專案
   - 識別所有需要開發的功能
   - 建立詳細的開發計劃文檔 (PLAN.md)

2. **任務拆分與優先級設定**
   - 將專案拆分為獨立的功能任務
   - 為每個任務定義：
     - 任務名稱 (Task Name)
     - 負責 Agent ID (Agent ID)
     - 優先級 (P0/P1/P2/P3)
     - 工作範圍 (Scope)
     - 預計時間 (Estimated Time)
     - 依賴關係 (Dependencies)

3. **確保 Git 環境就緒**
   ```bash
   # 切換到 main branch
   git checkout main
   
   # 更新到最新
   git pull
   
   # 確認狀態乾淨
   git status
   ```

---

### Phase 1: 啟動 Sub-Agents

**主 Agent 工作**：

對每個任務執行以下流程：

1. **建立 Feature Branch**
   ```bash
   # Branch 命名規則：feature/任務簡稱
   # 例如：feature/auth-system, feature/chat-ui
   git checkout -b feature/任務簡稱
   git push -u origin feature/任務簡稱
   ```

2. **準備任務指令**
   建立詳細的任務描述，包含：
   - 功能需求
   - 技術規格
   - 檔案結構
   - API 規格
   - 測試需求
   - 完成標準

3. **啟動 Sub-Agent**
   ```bash
   sessions_spawn(
     task="[詳細任務描述]",
     agentId="code-agent",
     label="任務簡稱",
     cleanup="keep"  # 保留 session 以便追蹤
   )
   ```

4. **記錄 Sub-Agent 資訊**
   在 AGENTS_STATUS.md 記錄：
   - Agent Label
   - 任務名稱
   - Branch 名稱
   - 啟動時間
   - 狀態 (running/completed/failed)

---

### Phase 2: Sub-Agent 執行

**Sub-Agent 工作流程**：

1. **確認 Branch**
   ```bash
   git checkout feature/任務簡稱
   git pull
   ```

2. **開發功能**
   - 按照任務描述實作功能
   - 遵循專案的程式碼規範
   - 撰寫必要的註解與文檔

3. **測試功能**
   - 單元測試
   - 整合測試
   - 手動測試

4. **Commit 變更**
   ```bash
   git add .
   git commit -m "feat: [功能描述]"
   
   # Commit Message 規範：
   # - feat: 新功能
   # - fix: 修復
   # - docs: 文檔
   # - style: 格式
   # - refactor: 重構
   # - test: 測試
   # - chore: 維護
   ```

5. **推送到遠端**
   ```bash
   git push
   ```

6. **回報完成**
   向主 Agent 回報任務完成狀態

---

### Phase 3: 審核與整合

**主 Agent 工作**：

1. **檢查 Sub-Agent 完成狀態**
   ```bash
   sessions_list(kinds=["isolated"], limit=20)
   ```

2. **審核程式碼**
   ```bash
   # 切換到 feature branch 檢視
   git checkout feature/任務簡稱
   
   # 檢視變更
   git diff main
   
   # 執行測試
   npm test
   ```

3. **合併到 Main Branch**
   
   **選項 A：直接合併 (小型專案)**
   ```bash
   git checkout main
   git pull
   git merge feature/任務簡稱
   git push
   ```
   
   **選項 B：Pull Request (團隊協作)**
   ```bash
   # 使用 GitHub API 建立 PR
   gh pr create --base main --head feature/任務簡稱 \
     --title "[任務名稱]" \
     --body "[功能說明]"
   ```

4. **處理衝突**（如有）
   ```bash
   # 如果有衝突，手動解決後
   git add .
   git commit -m "merge: Resolve conflicts from feature/任務簡稱"
   git push
   ```

5. **清理 Feature Branch**（可選）
   ```bash
   # 刪除本地 branch
   git branch -d feature/任務簡稱
   
   # 刪除遠端 branch
   git push origin --delete feature/任務簡稱
   ```

6. **更新狀態文檔**
   在 AGENTS_STATUS.md 標記任務為 "completed" 並記錄合併時間

---

### Phase 4: 整合測試

**主 Agent 工作**：

1. **拉取最新 Main Branch**
   ```bash
   git checkout main
   git pull
   ```

2. **執行完整測試**
   ```bash
   npm install  # 確保依賴最新
   npm test     # 單元測試
   npm run build  # 建置測試
   ```

3. **功能驗證**
   - 啟動開發環境測試所有新功能
   - 確保沒有迴歸問題
   - 驗證功能間的整合

4. **建立整合報告**
   記錄整合後的狀態到 INTEGRATION_REPORT.md

---

## 📁 目錄結構

建議在專案根目錄建立以下文件：

```
project-root/
├── PLAN.md                 # 開發計劃
├── AGENTS_STATUS.md        # Sub-Agent 狀態追蹤
├── INTEGRATION_REPORT.md  # 整合測試報告
├── .gitignore
└── (專案檔案)
```

---

## 📝 範本文件

### PLAN.md 範本

```markdown
# 專案開發計劃

## 專案資訊
- **專案名稱**: [專案名稱]
- **開始日期**: YYYY-MM-DD
- **預計完成**: YYYY-MM-DD

## 任務列表

### Task 1: [任務名稱]
- **Agent ID**: code-agent
- **Label**: task-1-name
- **Branch**: feature/task-1-name
- **優先級**: P0
- **預計時間**: X 小時
- **依賴**: 無
- **狀態**: pending

**工作範圍**:
1. 項目 1
2. 項目 2

**完成標準**:
- [ ] 標準 1
- [ ] 標準 2
```

### AGENTS_STATUS.md 範本

```markdown
# Sub-Agent 狀態追蹤

| Agent Label | 任務 | Branch | 狀態 | 啟動時間 | 完成時間 |
|------------|------|--------|------|----------|----------|
| auth-system | 認證系統 | feature/auth-system | completed | 2026-03-02 10:00 | 2026-03-02 14:00 |
| chat-ui | 聊天介面 | feature/chat-ui | running | 2026-03-02 14:30 | - |
```

---

## 🔧 常用指令

### 查看所有 Feature Branches
```bash
git branch -a | grep feature/
```

### 查看某個 Branch 的變更
```bash
git diff main..feature/branch-name
```

### 查看所有進行中的 Sub-Agents
```bash
sessions_list(kinds=["isolated"])
```

### 檢查特定 Sub-Agent 的進度
```bash
sessions_history(sessionKey="agent:main:isolated:label")
```

### 批次合併多個 Feature Branches
```bash
# 依優先級順序合併
git checkout main
for branch in feature/auth feature/db feature/api; do
  git merge $branch
  git push
done
```

---

## ⚠️ 注意事項

### 1. Branch 命名規範
- ✅ `feature/功能名稱` - 新功能
- ✅ `fix/問題描述` - Bug 修復
- ✅ `refactor/重構描述` - 程式碼重構
- ✅ `docs/文檔描述` - 文檔更新
- ❌ 不使用中文或特殊字元

### 2. Commit Message 規範
遵循 Conventional Commits:
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Type**:
- `feat`: 新功能
- `fix`: 修復
- `docs`: 文檔
- `style`: 格式調整
- `refactor`: 重構
- `test`: 測試
- `chore`: 維護

### 3. 衝突處理策略
- **預防**: 任務設計時避免修改相同檔案
- **發現**: 定期從 main pull 到 feature branch
- **解決**: 主 Agent 負責解決衝突，必要時諮詢相關 Sub-Agent

### 4. Sub-Agent 溝通
- 使用 `sessions_send()` 向特定 Sub-Agent 發送訊息
- 定期檢查 Sub-Agent 狀態
- 保留 session (cleanup="keep") 以便追蹤與除錯

### 5. 程式碼審核檢查項目
- [ ] 程式碼符合專案規範
- [ ] 通過所有測試
- [ ] 沒有明顯的效能問題
- [ ] 註解與文檔充足
- [ ] 沒有安全漏洞
- [ ] 與現有功能整合良好

---

## 🚀 快速開始範例

假設要開發一個包含 3 個功能的專案：

```bash
# 1. 準備專案
cd /path/to/project
git checkout main
git pull

# 2. 建立開發計劃
cat > PLAN.md << 'EOF'
# 專案開發計劃

## Task 1: 認證系統
- Branch: feature/auth-system
- 優先級: P0
...
EOF

# 3. 啟動第一個 Sub-Agent
git checkout -b feature/auth-system
git push -u origin feature/auth-system

sessions_spawn(
  task="實作 Google OAuth 認證系統...",
  agentId="code-agent",
  label="auth-system",
  cleanup="keep"
)

# 4. 重複步驟 3 給其他任務

# 5. 等待 Sub-Agents 完成

# 6. 審核並合併
git checkout main
git merge feature/auth-system
git push

# 7. 整合測試
npm test
npm run build
```

---

## 📊 效益

使用此 Workflow 可以獲得：

1. **平行開發**: 多個功能同時進行
2. **版本控制**: 每個功能有清楚的歷史記錄
3. **風險隔離**: 問題功能不影響主幹
4. **易於回滾**: 可輕易撤銷有問題的功能
5. **可追蹤性**: 清楚記錄每個功能的開發過程
6. **團隊協作**: 標準化流程便於多人協作

---

## 🔗 相關資源

- [Git Feature Branch Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow)
- [OpenClaw Sessions Documentation](https://docs.openclaw.ai)

---

## 📌 版本歷史

- **v1.0.0** (2026-03-02): 初始版本
