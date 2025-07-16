#!/bin/bash

# Dify Workflow Test Script
# このスクリプトはGitHub Actions workflowと同じAPIコールをローカルでテストできます

set -e

echo "🔧 Dify Workflow Test Script"
echo "=================================="

# 環境変数のチェック
if [ -z "$DIFY_API_KEY" ]; then
    echo "❌ Error: DIFY_API_KEY environment variable is not set"
    echo "Please set it with: export DIFY_API_KEY='your-api-key'"
    exit 1
fi

# Base URLの設定（デフォルト値）
DIFY_BASE_URL=${DIFY_BASE_URL:-"https://api.dify.ai/v1"}

echo "✅ API Key: Set (hidden for security)"
echo "✅ Base URL: $DIFY_BASE_URL"
echo ""

# 現在の日本時間を取得
JST_TIME=$(TZ=Asia/Tokyo date '+%Y-%m-%d %H:%M:%S JST')
echo "📅 Current JST time: $JST_TIME"
echo ""

# Dify ワークフローを実行
echo "🚀 Executing Dify workflow..."
echo "Calling: POST $DIFY_BASE_URL/workflows/run"
echo ""

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "${DIFY_BASE_URL}/workflows/run" \
  --header "Authorization: Bearer ${DIFY_API_KEY}" \
  --header "Content-Type: application/json" \
  --data-raw '{
    "inputs": {
      "daily_trigger": "'"$JST_TIME"'",
      "execution_context": "Local Test Run"
    },
    "response_mode": "blocking",
    "user": "test-user"
  }')

# レスポンスとHTTPステータスコードを分離
HTTP_BODY=$(echo "$RESPONSE" | head -n -1)
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
        echo ""
        echo "💡 Tip: Install 'jq' for formatted JSON output"
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
echo "🎉 Test completed successfully!"
echo "Your workflow is ready for GitHub Actions automation."