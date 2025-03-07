<!-- Prompt: #file:index.md には疑問点ややることの骨子が書かれています。それぞれの作業内容について、技術的知識がない初心者でもわかるように丁寧な説明を追記してください。可能な限り有用な情報ソースを付け加えてください。 -->

# Dify 入門

## Dify のキャッチアップ

### Q. どういうソリューションなのか？誰向けのなんのツールなのか？想定するユーザーは誰でどういう課題を達成できるツールなのか？機能として何があって何がないのか？

Dify は、AI アプリケーションの開発と運用を簡単にするためのオープンソースプラットフォームです。プログラミング知識がなくても、大規模言語モデル（LLM）を活用したアプリケーションを構築できることが特徴です。
[Dify へようこそ](https://docs.dify.ai/ja-jp) のページにより詳細な情報が記載されています。

**ターゲットユーザー**:

- プログラミングスキルがない非技術者やビジネスユーザー
- AI アプリ開発を効率化したい開発者
- LLM を活用したソリューションを素早くプロトタイピングしたいプロダクトマネージャー

**解決できる課題**:

- プログラミングなしで AI アプリケーションを作成できる
- 複雑な AI ワークフローをビジュアルに構築できる
- 独自のデータを使用した RAG（Retrieval Augmented Generation）システムの構築
- 既存のシステムとの API ベースの統合

**主な機能**:

- ノーコードで AI アプリケーション開発
- チャットボット・テキスト生成アプリの構築
- ビジュアルなワークフローエディタ
- RAG（Retrieval Augmented Generation）機能
- API 統合機能
- データセット管理
- 複数の LLM（OpenAI、Claude、Llama 等）へのインターフェース
- カスタムコード実行機能

**現時点での制限**:

- 一部の高度なカスタマイズにはコーディングが必要
- 大規模なエンタープライズ統合には追加設定が必要になる場合がある
- 処理速度はバックエンドの LLM に依存

### Q. クイックに動かせる環境を構築するには何をしたらいいのか？環境構築方法として何があるのか?

Dify を始めるための環境構築には、主に 3 つの方法があります。初心者には [クラウドサービス
](https://docs.dify.ai/ja-jp/getting-started/cloud) の利用がおすすめです。以下にそれぞれの方法を簡単に説明します。

**[1. クラウドサービスを利用する方法](https://cloud.dify.ai)**

Dify.AI が提供するクラウドサービスを利用すると、インストール不要ですぐに利用を開始できます。

- アカウント登録
- API キーの設定
- すぐに利用開始可能

**[2. Docker Compose を使う方法](https://github.com/langgenius/dify?tab=readme-ov-file#quick-start)**

必要なもの:

- Docker と docker-compose がインストールされていること
- 最低 8GB の RAM
- Git

手順:

```bash
# リポジトリをクローン
git clone https://github.com/langgenius/dify.git
cd dify/docker

# .envファイルをコピー
cp .env.example .env

# .envファイルを編集し、必要なAPIキーを設定
# 特にOPENAI_API_KEYなどのLLM APIキーを設定する

# Dockerコンテナを起動
docker compose up -d

# ブラウザで以下のURLにアクセス
# http://localhost:3000
```

**3. Kubernetes などの環境にデプロイする方法**

オープンソースの Helm チャートを使用して、Kubernetes クラスターに Dify をデプロイする方法があります。

- [nikawang/dify-azure-terraform](https://github.com/nikawang/dify-azure-terraform)
- [Dify Enterprise Helm Chart](https://langgenius.github.io/dify-helm/#/?id=dify-enterprise-helm-chart)
- [BorisPolonsky/dify-helm](https://github.com/BorisPolonsky/dify-helm)
- [douban/dify](https://artifacthub.io/packages/helm/douban/dify)

## ハンズオン

まずは以下の動画を参考にしながら、Dify の使い方を学びましょう。

- [生成 AI アプリが作れる「Dify」の入門＆ビジネス活用～ビジネスパーソン必見！GPTs を超える業務特化アプリが簡単につくれて配布もできちゃう…！ Dify の使い方](https://www.youtube.com/watch?v=p56_8JTvu8M)
- [OpenAI の GPTs より凄い！無料で使える Dify を徹底解説してみた](https://www.youtube.com/watch?v=O_bmmDWIjTc)

### 公式チュートリアル

- [初級編](https://docs.dify.ai/ja-jp/workshop/basic)
- [中級編](https://docs.dify.ai/ja-jp/workshop/intermediate)

### hello world 的アプリを何個か作って雰囲気を掴むためにやること

1. チャットが使える
1. ワークフローが作れる
1. RAG ができる
1. Web API をコールできる
1. 自前のカスタムコードを利用できる

### 自分のビジネス課題を定義して実装する

1. 要件定義

   **ビジネス課題の明確化手順**:

   - 解決したい具体的な問題は何か？
   - 誰がユーザーになるか？
   - ユーザーがアプリを使って達成したいことは？
   - 成功の基準は何か？

   要件定義テンプレート:

   ```
   アプリケーション名:
   目的:
   ターゲットユーザー:
   主な機能:
   成功基準:
   ```

   例: 営業資料から素早く質問に答えられるアシスタントの作成

2. 入出力の定義

   **入出力設計のポイント**:

   - ユーザー入力: どのような質問や指示を受け付けるか？
   - システム出力: どのようなフォーマットで回答するか？
   - エラーケース: 入力が不適切な場合の対応は？

   入出力定義例:

   ```
   入力: ユーザーからの製品に関する質問テキスト
   内部処理: 質問を分類し、関連資料を検索、回答を生成
   出力: 製品情報の要約と詳細へのリンク
   ```

3. 利用するデータの定義

   **データ準備のステップ**:

   - 必要なデータは何か？（ドキュメント、FAQ、製品情報など）
   - データのフォーマットとクレンジング方法
   - データのチャンク化とインデックス作成方法
   - データの更新頻度と方法

   データ準備チェックリスト:

   - [ ] データの収集
   - [ ] 不要な情報の削除
   - [ ] 適切なサイズにチャンク化
   - [ ] メタデータの付与
   - [ ] インデックスの作成

4. ワークフローのデザイン

   **ワークフロー設計プロセス**:

   1. 主要なユーザーの行動パスを特定
   2. 各ステップで必要な処理を定義
   3. 分岐条件を特定
   4. 外部システム連携の要件を確認
   5. エラー処理を設計

   ワークフローのスケッチ例:

   ```
   開始 → 入力受付 → 質問意図分析 →
   条件分岐（製品質問/サポート質問/その他） →
   関連情報検索 → 回答生成 → フォローアップ提案 → 終了
   ```

# 参考リンク

- [langgenius/dify](https://github.com/langgenius/dify)
- [世界一わかりみの深い Dify](https://tech-lab.sios.jp/archives/46102)
- [Dify 公式ドキュメント](https://docs.dify.ai/ja-jp)
- [Discord](https://discord.com/invite/FngNHpbcY7)
- [X > Dify.AI](https://x.com/dify_ai)
- [Compass 勉強会 > `Dify` で検索](https://connpass.com/search/?q=Dify)
