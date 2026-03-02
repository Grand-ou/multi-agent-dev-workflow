# IntradayLab Knowledge Base - 開發計劃範例

## 專案資訊
- **專案名稱**: IntradayLab Knowledge Base
- **專案描述**: 投資交易知識 RAG 系統，包含前端、後端、認證、訂閱等完整功能
- **開始日期**: 2026-03-02
- **預計完成**: 2026-03-30 (4 週)
- **主要技術棧**: React, TypeScript, Node.js, Express, PostgreSQL, pgvector, OpenAI

---

## 任務列表

### Task 1: 前端框架搭建
- **Agent ID**: code-agent
- **Label**: frontend-setup
- **Branch**: feature/frontend-setup
- **優先級**: P0 (最高)
- **預計時間**: 3 小時
- **依賴**: 無
- **狀態**: pending

**工作範圍**:
1. 在 `/var/www/fmg-knowledge/web/` 設置 Vite + React + TypeScript
2. 整合 Tailwind CSS + shadcn/ui
3. 設置 React Router 路由系統
4. 建立基本 Layout 組件 (Header, Sidebar, Content)
5. 設置深色/淺色主題系統

**技術規格**:
- Package Manager: npm
- Build Tool: Vite 5.x
- Framework: React 18 + TypeScript
- UI: Tailwind CSS + shadcn/ui
- Router: React Router 6

**完成標準**:
- [x] Vite 專案建立且可正常 dev server
- [x] Tailwind CSS 正確設定並可使用
- [x] shadcn/ui 組件庫整合
- [x] 基本路由系統運作（至少 3 個頁面）
- [x] 主題切換功能正常

**注意事項**:
- 需要與現有 Node.js 後端（index.js）共存
- 前端打包後放在 `web/dist/`，後端 serve 靜態檔案

---

### Task 2: 認證系統整合
- **Agent ID**: code-agent
- **Label**: auth-system
- **Branch**: feature/auth-system
- **優先級**: P0
- **預計時間**: 4 小時
- **依賴**: Task 1 (前端框架)
- **狀態**: pending

**工作範圍**:
1. 後端：實現 Passport.js + Google OAuth 2.0
2. 後端：Express Session 管理
3. 後端：用戶表設計與 CRUD
4. 前端：Auth 頁面（登入/註冊 UI）
5. 前端：useAuth Hook
6. 前端：受保護路由機制（PrivateRoute）

**技術規格**:
- 後端: Passport.js + passport-google-oauth20
- Session: express-session + connect-pg-simple
- 資料庫:
  ```sql
  CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    name TEXT,
    avatar_url TEXT,
    google_id TEXT UNIQUE,
    subscription_tier TEXT DEFAULT 'free',
    quota_used INTEGER DEFAULT 0,
    quota_limit INTEGER DEFAULT 10,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );
  ```
- API Endpoints:
  - `GET /api/auth/google` - 啟動 Google OAuth
  - `GET /api/auth/google/callback` - OAuth 回調
  - `GET /api/auth/user` - 取得當前用戶
  - `POST /api/auth/logout` - 登出

**完成標準**:
- [ ] Google OAuth 流程完整運作
- [ ] Session 正確儲存與管理
- [ ] 用戶資料正確寫入資料庫
- [ ] 前端可取得用戶資訊
- [ ] 受保護路由正確阻擋未登入用戶
- [ ] 登出功能正常

**注意事項**:
- 需要設定環境變數: GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET
- Redirect URI: https://intradaylab.vividoo.com.tw/api/auth/google/callback

---

### Task 3: RAG 聊天介面
- **Agent ID**: code-agent
- **Label**: chat-ui
- **Branch**: feature/chat-ui
- **優先級**: P1
- **預計時間**: 5 小時
- **依賴**: Task 1, Task 2
- **狀態**: pending

**工作範圍**:
1. 聊天頁面主體結構
2. MessageBubble 組件（用戶/助理訊息氣泡）
3. 輸入框組件（支援多行、Enter 發送）
4. 串流訊息顯示（Server-Sent Events）
5. 來源引用 Accordion（顯示 RAG 來源）
6. Markdown 渲染（react-markdown）
7. 整合現有 `/api/ask` 端點

**技術規格**:
- 前端組件:
  - `ChatPage.tsx` - 主頁面
  - `MessageBubble.tsx` - 訊息氣泡
  - `ChatInput.tsx` - 輸入框
  - `SourcesAccordion.tsx` - 來源顯示
- 串流處理: EventSource API
- Markdown: react-markdown + remark-gfm

**完成標準**:
- [ ] 聊天介面美觀且響應式
- [ ] 可正常發送訊息到 `/api/ask`
- [ ] 串流回應正確顯示
- [ ] Markdown 正確渲染（代碼、列表、連結等）
- [ ] 來源引用可摺疊展開
- [ ] Loading 狀態友善

**注意事項**:
- 需要處理長串流訊息的效能
- 確保 Markdown 安全渲染（防 XSS）

---

### Task 4: 對話管理系統
- **Agent ID**: code-agent
- **Label**: conversation-management
- **Branch**: feature/conversation-management
- **優先級**: P1
- **預計時間**: 4 小時
- **依賴**: Task 2, Task 3
- **狀態**: pending

**工作範圍**:
1. 後端：conversations 表與 messages 表設計
2. 後端：對話 CRUD API
3. 前端：對話側邊欄組件
4. 前端：新增/刪除對話功能
5. 前端：對話搜尋功能
6. 前端：對話標題自動生成（使用 OpenAI）

**技術規格**:
- 資料庫:
  ```sql
  CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    persona_id UUID REFERENCES personas(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );
  
  CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
    role TEXT NOT NULL,
    content TEXT NOT NULL,
    sources JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
  );
  ```
- API Endpoints:
  - `GET /api/conversations` - 列出對話
  - `POST /api/conversations` - 新增對話
  - `GET /api/conversations/:id` - 取得對話詳情
  - `GET /api/conversations/:id/messages` - 取得訊息
  - `DELETE /api/conversations/:id` - 刪除對話
  - `PATCH /api/conversations/:id/title` - 更新標題

**完成標準**:
- [ ] 對話列表正確顯示
- [ ] 可新增/刪除對話
- [ ] 訊息正確儲存與讀取
- [ ] 對話搜尋功能正常
- [ ] 標題自動生成合理
- [ ] 切換對話時訊息正確載入

---

### Task 5: Persona 系統
- **Agent ID**: code-agent
- **Label**: persona-system
- **Branch**: feature/persona-system
- **優先級**: P2
- **預計時間**: 3 小時
- **依賴**: Task 4
- **狀態**: pending

**工作範圍**:
1. 後端：personas 表設計
2. 後端：Persona CRUD API
3. 後端：整合 Persona 到 RAG 查詢
4. 前端：PersonaSelector 組件
5. 前端：Persona FAQ 按鈕（快速問題）

**技術規格**:
- 資料庫:
  ```sql
  CREATE TABLE personas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    faq_questions JSONB,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
  );
  ```
- API Endpoints:
  - `GET /api/personas` - 列出所有 Persona
  - `POST /api/personas` - 新增 Persona（管理員）
  - `PUT /api/personas/:id` - 更新 Persona
  - `DELETE /api/personas/:id` - 刪除 Persona

**完成標準**:
- [ ] Persona 列表正確顯示
- [ ] 可切換不同 Persona
- [ ] Persona 的 system prompt 正確應用到 AI
- [ ] FAQ 按鈕可快速填入問題
- [ ] 管理員可新增/編輯 Persona

---

## 時程規劃

### Week 1: 基礎架構
- **Day 1-2**: Task 1 (前端框架)
- **Day 3-5**: Task 2 (認證系統)

### Week 2: 核心功能
- **Day 1-3**: Task 3 (聊天介面)
- **Day 4-5**: Task 4 (對話管理)

### Week 3: 進階功能
- **Day 1-2**: Task 5 (Persona)
- **Day 3-5**: Task 6-7 (文件、訂閱)

### Week 4: 收尾與優化
- **Day 1-3**: Task 8-10 (學習、後台、匯出)
- **Day 4-5**: 整合測試與 Bug 修復

---

## 依賴關係圖

```
Task 1 (前端框架) [P0]
  │
  ├─> Task 2 (認證系統) [P0]
  │     │
  │     ├─> Task 3 (聊天介面) [P1]
  │     │     └─> Task 4 (對話管理) [P1]
  │     │           └─> Task 5 (Persona) [P2]
  │     │
  │     ├─> Task 6 (文件上傳) [P2]
  │     │
  │     └─> Task 7 (訂閱系統) [P2]
  │
  └─> Task 8 (學習輔助) [P3]
        └─> Task 9 (管理後台) [P3]
              └─> Task 10 (匯出功能) [P3]
```

---

## 風險評估

| 風險 | 可能性 | 影響 | 應對策略 |
|------|--------|------|----------|
| Google OAuth 設定錯誤 | 中 | 高 | 提前測試，準備文檔 |
| pgvector 查詢效能問題 | 低 | 中 | 建立適當索引，監控查詢時間 |
| 前後端整合困難 | 中 | 中 | 明確定義 API 規格，使用 TypeScript |
| Sub-Agent 衝突 | 低 | 低 | 明確任務邊界，避免修改相同檔案 |

---

## 資源需求

- **Sub-Agents**: 10 個（並行最多 3 個）
- **時間**: 4 週
- **第三方服務**: 
  - OpenAI API（已有）
  - Google OAuth（需申請）
  - 綠界金流（需申請）

---

**建立時間**: 2026-03-02 16:00
**最後更新**: 2026-03-02 16:00
