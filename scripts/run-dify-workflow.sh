#!/bin/bash

# Dify Workflow Execution Script
# このスクリプトはDifyワークフローを実行します
# GitHub Actionsとローカル実行の両方に対応しています

set -e

# 実行環境の判定
if [ -n "$GITHUB_ACTIONS" ]; then
    EXECUTION_CONTEXT="GitHub Actions Daily Run"
    USER_ID="github-actions-bot"
    echo "🤖 Running in GitHub Actions environment"
else
    EXECUTION_CONTEXT="Local Test Run"
    USER_ID="test-user"
    echo "💻 Running in local environment"
fi

echo "🔧 Dify Workflow Execution Script"
echo "=================================="

# 環境変数のチェック
if [ -z "$DIFY_API_KEY" ]; then
    echo "❌ Error: DIFY_API_KEY environment variable is not set"
    if [ -z "$GITHUB_ACTIONS" ]; then
        echo "Please set it with: export DIFY_API_KEY='your-api-key'"
    else
        echo "Please configure DIFY_API_KEY in GitHub Secrets"
    fi
    exit 1
fi

# Base URLの設定（デフォルト値）
DIFY_BASE_URL=${DIFY_BASE_URL:-"https://api.dify.ai/v1"}

echo "✅ API Key: Set (hidden for security)"
echo "✅ Base URL: $DIFY_BASE_URL"
echo "✅ Execution Context: $EXECUTION_CONTEXT"
echo "✅ User ID: $USER_ID"
echo ""

# 現在の日本時間を取得
JST_TIME=$(TZ=Asia/Tokyo date '+%Y-%m-%d %H:%M:%S JST')
echo "📅 Current JST time: $JST_TIME"
echo ""

# Dify ワークフローを実行
echo "🚀 Executing Dify workflow..."
echo "API Endpoint: ${DIFY_BASE_URL}/workflows/run"
echo "Request payload includes:"
echo "  - daily_trigger: $JST_TIME"
echo "  - execution_context: $EXECUTION_CONTEXT"
echo "  - user: $USER_ID"
echo ""

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "${DIFY_BASE_URL}/workflows/run" \
  --header "Authorization: Bearer ${DIFY_API_KEY}" \
  --header "Content-Type: application/json" \
  --data-raw '{
    "inputs": {
      "daily_trigger": "'"$JST_TIME"'",
      "execution_context": "'"$EXECUTION_CONTEXT"'"
    },
    "response_mode": "blocking",
    "user": "'"$USER_ID"'"
  }')

# レスポンスとHTTPステータスコードを分離
HTTP_BODY=$(echo "$RESPONSE" | sed '$d')
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

echo "📊 Results:"
echo "----------"
echo "HTTP Status Code: $HTTP_CODE"
echo ""

# HTTPステータスコードをチェック
if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ]; then
    echo "✅ Success! Dify workflow executed successfully"
    echo ""
    echo "📄 Response Body:"
    # JSONとして整形して表示を試行
    if command -v jq >/dev/null 2>&1; then
        echo "$HTTP_BODY" | jq '.' 2>/dev/null || echo "$HTTP_BODY"
    else
        echo "$HTTP_BODY"
        if [ -z "$GITHUB_ACTIONS" ]; then
            echo ""
            echo "💡 Tip: Install 'jq' for formatted JSON output"
        fi
    fi
else
    echo "❌ Error! Dify workflow execution failed"
    echo ""
    echo "📄 Error Response:"
    echo "$HTTP_BODY"
    echo ""
    echo "🔍 Troubleshooting:"
    case $HTTP_CODE in
        401)
            echo "  - Check if DIFY_API_KEY is correct"
            echo "  - Verify the API key has proper permissions"
            ;;
        404)
            echo "  - Check if DIFY_BASE_URL is correct"
            echo "  - Verify the workflow application is published"
            ;;
        429)
            echo "  - Rate limit exceeded, try again later"
            ;;
        500|502|503|504)
            echo "  - Server error, try again later"
            ;;
        *)
            echo "  - Unexpected error, check Dify service status"
            ;;
    esac
    exit 1
fi

echo ""
if [ -n "$GITHUB_ACTIONS" ]; then
    echo "🎉 GitHub Actions workflow completed successfully!"
else
    echo "🎉 Local test completed successfully!"
    echo "Your workflow is ready for GitHub Actions automation."
fi