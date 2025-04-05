# Dify x Slack bot 連携

## 設定手順

### Dify 側の設定

- ChatFlow アプリを公開
- [Plugin Marketplace](https://cloud.dify.ai/plugins?category=discover) から Slack Plugin をインストール
- Plugins > Slack Bot > Endpoints から ChatFlow アプリを追加 (要 Bot User OAuth Token)

### Slack 側の設定

- Slack App の作成: [Your Apps](https://api.slack.com/apps) から `Create New App` > `From scratch` を選択
- Incoming Webhooks の有効化: Activate Incoming Webhooks
- OAuth & Permissions: Scope += incoming-webhook, app_mentions:read, channels:read, chat:write
- Slack Bot を workspace にインストール
- Event Subscriptions
  - Request URL を Dify Plugin の Endpoint で指定
  - Subscribe to bot events に `app_mention` を追加

## 参考文献

- [コーディング不要で毎日の仕事が 5 倍速くなる！Dify で作る生成 AI アプリ完全入門 / 第 7 章　プラグインを活用して Slack から RAG を利用するアプリ](https://bookplus.nikkei.com/atcl/catalog/25/03/21/01919/)
- [GenerativeAgents/dify-book](https://github.com/GenerativeAgents/dify-book)
