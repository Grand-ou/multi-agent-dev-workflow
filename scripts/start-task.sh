#!/bin/bash

# Multi-Agent Dev Workflow - 啟動任務腳本
# 用法: ./start-task.sh <task-name> <branch-name> <description>

set -e

TASK_NAME=$1
BRANCH_NAME=$2
DESCRIPTION=$3

if [ -z "$TASK_NAME" ] || [ -z "$BRANCH_NAME" ]; then
    echo "用法: ./start-task.sh <task-name> <branch-name> [description]"
    echo "範例: ./start-task.sh auth-system feature/auth-system \"實作 Google OAuth\""
    exit 1
fi

echo "🚀 啟動任務: $TASK_NAME"
echo "📁 Branch: $BRANCH_NAME"
echo ""

# 1. 確保在 main branch 且是最新
echo "1️⃣  切換到 main branch 並更新..."
git checkout main
git pull

# 2. 建立並切換到 feature branch
echo "2️⃣  建立 feature branch: $BRANCH_NAME..."
git checkout -b "$BRANCH_NAME"

# 3. 推送到遠端
echo "3️⃣  推送到遠端..."
git push -u origin "$BRANCH_NAME"

# 4. 記錄到狀態檔案
echo "4️⃣  更新狀態追蹤..."
if [ -f "AGENTS_STATUS.md" ]; then
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
    echo "| $TASK_NAME | $DESCRIPTION | $BRANCH_NAME | pending | - | $TIMESTAMP | - |" >> AGENTS_STATUS.md
fi

echo ""
echo "✅ Branch 已建立並推送！"
echo "📝 接下來請使用以下指令啟動 Sub-Agent:"
echo ""
echo "sessions_spawn("
echo "  task=\"$DESCRIPTION\","
echo "  agentId=\"code-agent\","
echo "  label=\"$TASK_NAME\","
echo "  cleanup=\"keep\""
echo ")"
