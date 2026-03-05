# IntradayLab Knowledge Base - 開發計劃範例

## 專案資訊
- **專案名稱**: IntradayLab Knowledge Base
- **專案描述**: 投資交易知識 RAG 系統，含前端、後端、認證、訂閱等完整功能
- **開始日期**: 2026-03-02
- **預計完成**: 2026-03-30 (4 週)
- **技術棧**: React, TypeScript, Node.js, Express, PostgreSQL, pgvector, OpenAI

---

## 任務列表

### Task 1: 前端框架搭建
- **Label**: `frontend-setup`
- **Branch**: `feature/frontend-setup`
- **優先級**: P0 | **預計**: 3h | **依賴**: 無

**工作範圍**:
1. Vite + React + TypeScript 設置
2. Tailwind CSS + shadcn/ui 整合
3. React Router 路由系統
4. Layout 組件 (Header, Sidebar, Content)
5. 深色/淺色主題系統

**完成標準**:
- [ ] Dev server 正常運行
- [ ] Tailwind + shadcn/ui 整合完成
- [ ] 至少 3 頁路由
- [ ] 主題切換正常

---

### Task 2: 認證系統整合
- **Label**: `auth-system`
- **Branch**: `feature/auth-system`
- **優先級**: P0 | **預計**: 4h | **依賴**: Task 1

**工作範圍**:
1. Passport.js + Google OAuth 2.0
2. Express Session 管理
3. 用戶表 CRUD
4. Auth 頁面 + useAuth Hook + PrivateRoute

**API**:
- `GET /api/auth/google` — 啟動 OAuth
- `GET /api/auth/google/callback` — 回調
- `GET /api/auth/user` — 取得用戶
- `POST /api/auth/logout` — 登出

---

### Task 3: RAG 聊天介面
- **Label**: `chat-ui`
- **Branch**: `feature/chat-ui`
- **優先級**: P1 | **預計**: 5h | **依賴**: Task 1, 2

**工作範圍**:
1. ChatPage + MessageBubble + ChatInput
2. Server-Sent Events 串流
3. 來源引用 Accordion
4. Markdown 渲染 (react-markdown)
5. 整合 `/api/ask`

---

### Task 4: 對話管理系統
- **Label**: `conversation-management`
- **Branch**: `feature/conversation-management`
- **優先級**: P1 | **依賴**: Task 2, 3

### Task 5: Persona 系統
- **Label**: `persona-system`
- **Branch**: `feature/persona-system`
- **優先級**: P2 | **依賴**: Task 4

---

## 依賴關係圖

```
Task 1 (前端框架) [P0]
  │
  ├─> Task 2 (認證系統) [P0]
  │     ├─> Task 3 (聊天介面) [P1]
  │     │     └─> Task 4 (對話管理) [P1]
  │     │           └─> Task 5 (Persona) [P2]
  │     ├─> Task 6 (文件上傳) [P2]
  │     └─> Task 7 (訂閱系統) [P2]
  │
  └─> Task 8 (學習輔助) [P3]
        └─> Task 9 (管理後台) [P3]
              └─> Task 10 (匯出功能) [P3]
```

## 時程

| Week | Phase | Tasks |
|------|-------|-------|
| 1 | 基礎架構 | Task 1, 2 |
| 2 | 核心功能 | Task 3, 4 |
| 3 | 進階功能 | Task 5, 6, 7 |
| 4 | 收尾優化 | Task 8-10 + 整合測試 |

## 風險評估

| 風險 | 可能性 | 影響 | 應對 |
|------|--------|------|------|
| Google OAuth 設定錯誤 | 中 | 高 | 提前測試 |
| pgvector 效能問題 | 低 | 中 | 建立索引 |
| 前後端整合困難 | 中 | 中 | TypeScript + 明確 API 規格 |
| Sub-Agent 衝突 | 低 | 低 | 明確任務邊界 |
