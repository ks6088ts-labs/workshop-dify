# workshop-dify
Workshop for Dify

## GitHub Actions Workflow

このリポジトリには、毎日日本時間06:00にDifyワークフローを自動実行するGitHub Actionsが含まれています。

### 主な機能
- 毎日日本時間06:00の自動実行
- GitHub Secretsを使用したAPIトークンの安全な管理
- 手動実行機能
- エラーハンドリングとログ出力

## セットアップ手順

### 1. GitHub Secretsの設定

ワークフローを実行するために、以下のsecretsをGitHubリポジトリに設定する必要があります。

#### 必須のSecrets

1. **DIFY_API_KEY** (必須)
   - DifyアプリケーションのAPIキー
   - Difyコンソール → アプリケーション → API → APIキーを作成からAPIキーを取得

2. **DIFY_BASE_URL** (オプション)
   - DifyのAPI base URL
   - デフォルト: `https://api.dify.ai/v1`
   - セルフホストしている場合のみ設定が必要

#### Secretsの設定方法

1. GitHubリポジトリのページに移動
2. `Settings` タブをクリック
3. 左サイドバーの `Secrets and variables` → `Actions` をクリック
4. `New repository secret` ボタンをクリック
5. 以下のsecretsを追加:
   - Name: `DIFY_API_KEY`, Value: [DifyのAPIキー]
   - Name: `DIFY_BASE_URL`, Value: [カスタムURL] (オプション)

### 2. ワークフローの設定

ワークフローファイル `.github/workflows/daily-dify-workflow.yml` では以下が設定されています:

- **実行スケジュール**: 毎日日本時間 06:00 (UTC 21:00)
- **手動実行**: GitHub上から手動でワークフローを実行可能
- **エラーハンドリング**: API呼び出しの失敗時は適切なエラーメッセージを表示

### 3. ワークフローの実行確認

#### ローカルテスト（推奨）
ワークフローをGitHub Actionsで実行する前に、ローカルでテストすることを推奨します：

```bash
# 環境変数を設定
export DIFY_API_KEY="your-api-key-here"
export DIFY_BASE_URL="https://api.dify.ai/v1"  # オプション

# スクリプトを実行
./scripts/run-dify-workflow.sh
```

#### 自動実行の確認
- ワークフローは毎日日本時間06:00に自動実行されます
- 実行結果はGitHubの `Actions` タブで確認できます

#### 手動実行の方法
1. GitHubリポジトリの `Actions` タブに移動
2. `Daily Dify Workflow Execution` ワークフローを選択
3. `Run workflow` ボタンをクリック
4. `Run workflow` を再度クリックして実行

## ワークフローの詳細

### 入力パラメータ

ワークフローでは以下のパラメータがDifyに送信されます:

```json
{
  "inputs": {
    "daily_trigger": "2024-01-15 06:00:00 JST",
    "execution_context": "GitHub Actions Daily Run"
  },
  "response_mode": "blocking",
  "user": "github-actions-bot"
}
```

### カスタマイズ

ワークフローをカスタマイズする場合は、以下のファイルを編集してください:

1. **実行時間の変更**:
   `.github/workflows/daily-dify-workflow.yml` の cron スケジュール
   ```yaml
   schedule:
     - cron: '0 21 * * *'  # UTC時間で指定
   ```

2. **入力パラメータの変更**:
   `scripts/run-dify-workflow.sh` の JSON ペイロード部分

### エラー対応

#### よくあるエラー

1. **DIFY_API_KEY environment variable is not set**
   - GitHub SecretsでDIFY_API_KEYが設定されていません
   - 上記のセットアップ手順に従ってAPIキーを設定してください

2. **HTTP 401 Unauthorized**
   - APIキーが無効か、権限が不足しています
   - Difyコンソールで新しいAPIキーを生成し、Secretsを更新してください

3. **HTTP 404 Not Found**
   - ワークフローエンドポイントが見つかりません
   - DIFY_BASE_URLが正しく設定されているか確認してください
   - ワークフローアプリケーションが正しく公開されているか確認してください

#### ログの確認方法

1. GitHubの `Actions` タブに移動
2. 失敗したワークフロー実行をクリック
3. `execute-dify-workflow` ジョブをクリック
4. エラーメッセージとレスポンス内容を確認

## セキュリティ上の注意

- APIキーは必ずGitHub Secretsを使用して管理してください
- APIキーをコードやログに直接記載しないでください
- 定期的にAPIキーをローテーションすることを推奨します

## 関連リンク

- [Dify API Documentation](https://docs.dify.ai/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
