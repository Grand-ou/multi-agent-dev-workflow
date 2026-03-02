#!/bin/bash

# Multi-Agent Dev Workflow - 合併任務腳本
# 用法: ./merge-task.sh <branch-name>

set -e

BRANCH_NAME=$1

if [ -z "$BRANCH_NAME" ]; then
    echo "用法: ./merge-task.sh <branch-name>"
    echo "範例: ./merge-task.sh feature/auth-system"
    exit 1
fi

echo "🔄 準備合併: $BRANCH_NAME"
echo ""

# 1. 切換到 feature branch 並更新
echo "1️⃣  切換到 $BRANCH_NAME 並更新..."
git checkout "$BRANCH_NAME"
git pull

# 2. 執行測試
echo "2️⃣  執行測試..."
if [ -f "package.json" ]; then
    npm test || {
        echo "❌ 測試失敗！請修復後再合併。"
        exit 1
    }
fi

# 3. 切換到 main 並更新
echo "3️⃣  切換到 main branch..."
git checkout main
git pull

# 4. 合併 feature branch
echo "4️⃣  合併 $BRANCH_NAME..."
git merge "$BRANCH_NAME" --no-ff -m "merge: Merge $BRANCH_NAME into main"

# 5. 推送到遠端
echo "5️⃣  推送到遠端..."
git push

# 6. 詢問是否刪除 feature branch
echo ""
read -p "是否刪除 feature branch $BRANCH_NAME? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "6️⃣  刪除本地 branch..."
    git branch -d "$BRANCH_NAME"
    
    echo "7️⃣  刪除遠端 branch..."
    git push origin --delete "$BRANCH_NAME"
    
    echo "✅ Branch 已刪除"
fi

echo ""
echo "✅ 合併完成！"
echo "📝 請更新 AGENTS_STATUS.md 標記任務為 completed"
