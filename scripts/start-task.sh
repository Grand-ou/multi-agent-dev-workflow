#!/bin/bash
# Multi-Agent Dev Workflow — Start Task
# Usage: ./start-task.sh <task-name> <branch-name> [description]
# Example: ./start-task.sh auth-system feature/auth-system "Implement Google OAuth"

set -e

TASK_NAME=$1
BRANCH_NAME=$2
DESCRIPTION=${3:-"$TASK_NAME"}

if [ -z "$TASK_NAME" ] || [ -z "$BRANCH_NAME" ]; then
    echo "Usage: ./start-task.sh <task-name> <branch-name> [description]"
    echo "Example: ./start-task.sh auth-system feature/auth-system \"Implement OAuth\""
    exit 1
fi

echo "🚀 Starting task: $TASK_NAME"
echo "📁 Branch: $BRANCH_NAME"
echo ""

echo "1️⃣  Switching to main and pulling latest..."
git checkout main
git pull

echo "2️⃣  Creating feature branch: $BRANCH_NAME..."
git checkout -b "$BRANCH_NAME"

echo "3️⃣  Pushing to remote..."
git push -u origin "$BRANCH_NAME"

if [ -f "AGENTS_STATUS.md" ]; then
    echo "4️⃣  Updating status tracker..."
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
    echo "| $TASK_NAME | $DESCRIPTION | $BRANCH_NAME | pending | - | $TIMESTAMP | - |" >> AGENTS_STATUS.md
fi

echo ""
echo "✅ Branch created and pushed!"
echo ""
echo "📝 Next: spawn Sub-Agent with:"
echo ""
echo "sessions_spawn("
echo "  task=\"$DESCRIPTION\","
echo "  label=\"$TASK_NAME\","
echo "  cleanup=\"keep\""
echo ")"
