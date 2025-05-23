# Agent 実装入門

## はじめに

仮想データを作成して、エージェントを実装する方法を説明します。エージェントは、特定のタスクを実行するために設計されたプログラムです。エージェントは、特定の環境で動作し、環境からの入力に基づいて行動を決定します。

### 仮想データ作成

実験用に仮想データを作成します。仮想データは、実際のデータを模倣したデータです。仮想データは、エージェントの動作をテストするために使用されます。
ここでは Gemini に以下のプロンプトを投げて、仮想データを作成しました。

[stores.md](../datasets/stores.md) の作成

> EC サイトや実店舗から取得した情報元にアパレル用品のブランドに関する情報を提供するボットを開発します。まずはモックデータとして空想上の会社名とその品揃えなどを記載した情報を 10 社分、それぞれ 2000 文字で、markdown フォーマットで作成して。

[stores.md](../datasets/stores.md) の社名ごとに販売実績の架空データとして [sales.md](../datasets/sales.md) を作成。本来 RDBMS などで管理するべきですが、ここでは簡素化のために markdown フォーマットで作成します。

> 以下の文章を参考に、モックデータとしてそれぞれの会社における過去販売実績(カテゴリーごと、ブランドごと、時期別など)として、架空の売上データを作成してください。markdown フォーマットで作成してください。---はい、承知いたしました。アパレル用品のブランドに関するモックデータを 10 社分、それぞれ 2000 文字で作成します。

---

### Knowledge を作成する

[ナレッジベース](https://docs.dify.ai/ja-jp/guides/knowledge-base)を参考に、Knowledge を作成します。Knowledge は、エージェントが情報を取得するためのデータベースです。Knowledge は、エージェントが質問に答えるための情報を提供します。

### Workflow を作成する

[ワークフロー](https://docs.dify.ai/ja-jp/guides/workflow)を参考に、Workflow を作成します。Workflow は、エージェントがタスクを実行するための手順です。Workflow は、エージェントが質問に答えるための手順を提供します。

- START ノード
  - ユーザーからの質問を受け取る Input Field を作成します
- Knowledge retrieval ノード
  - Knowledge を選択します
  - Knowledge の情報を取得するためのクエリを作成します
- LLM ノード
  - LLM を選択します
  - LLM のプロンプトを作成します

**プロンプトの例**

```
コンテキストを踏まえ、ユーザーの質問に回答してください。

## ユーザーの質問
{{#PLACEHOLDER.question#}}

## コンテキスト
{{#context#}}
```

- END ノード
  - ユーザーに回答を返す Output Field を作成します

### Workflow を tool として公開する

[Dify でワークフローを別のワークフローで利用する方法](https://note.com/vcube_technote/n/n3805f8f53023) を参考に、Workflow を tool として公開します。Workflow を tool として公開することで、他のエージェントから Workflow を呼び出すことができます。

TODO: Workflow を tool として公開する際には強い権限が必要？

### エージェントを作成する

これまで作成した Workflow をつなぎ合わせて、エージェントを作成します。エージェントは、特定のタスクを実行するために設計されたプログラムです。エージェントは、特定の環境で動作し、環境からの入力に基づいて行動を決定します。
