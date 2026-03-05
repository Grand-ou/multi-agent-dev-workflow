#!/bin/bash
# Multi-Agent Dev Workflow — Merge Task
# Usage: ./merge-task.sh <branch-name>
# Example: ./merge-task.sh feature/auth-system

set -e

BRANCH_NAME=$1

if [ -z "$BRANCH_NAME" ]; then
    echo "Usage: ./merge-task.sh <branch-name>"
    echo "Example: ./merge-task.sh feature/auth-system"
    exit 1
fi

echo "🔄 Merging: $BRANCH_NAME"
echo ""

echo "1️⃣  Switching to $BRANCH_NAME and pulling..."
git checkout "$BRANCH_NAME"
git pull

echo "2️⃣  Running tests..."
if [ -f "package.json" ]; then
    npm test || { echo "❌ Tests failed! Fix before merging."; exit 1; }
elif [ -f "Makefile" ]; then
    make test || { echo "❌ Tests failed! Fix before merging."; exit 1; }
fi

echo "3️⃣  Switching to main..."
git checkout main
git pull

echo "4️⃣  Merging $BRANCH_NAME..."
git merge "$BRANCH_NAME" --no-ff -m "merge: $BRANCH_NAME into main"

echo "5️⃣  Pushing..."
git push

echo ""
read -p "Delete branch $BRANCH_NAME? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git branch -d "$BRANCH_NAME"
    git push origin --delete "$BRANCH_NAME"
    echo "✅ Branch deleted"
fi

echo ""
echo "✅ Merge complete!"
echo "📝 Update AGENTS_STATUS.md → mark as completed"
