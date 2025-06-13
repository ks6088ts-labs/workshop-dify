# Dify API 連携ガイド

## はじめに

このガイドでは、Difyで作成したAIアプリケーションを外部のウェブアプリやCLIツールから呼び出す方法について説明します。

### 想定読者

- [docs/index.md](./index.md) を読んでDifyの基本機能を理解している
- Difyのコンソールでワークフローやチャットアプリを構築した経験がある
- プログラミング未経験だが、外部システムとの連携に興味がある

### このガイドで学べること

- DifyアプリのAPI化の基本概念
- 最小限の技術知識でAPIを呼び出す方法
- シンプルなツール（curl、Python）を使った実例
- よくあるトラブルと解決方法

## 1. Dify APIの概要

### 1.1 APIとは何か？

API（Application Programming Interface）は、異なるソフトウェア同士が情報をやり取りするための仕組みです。DifyのAPIを使うことで、以下のようなことが可能になります：

- 自社のウェブサイトにDifyのチャットボットを組み込む
- 既存の業務システムからDifyの機能を呼び出す
- 定期的にDifyを実行して結果をメールで送信する

### 1.2 Dify APIの特徴

Difyでは、作成したアプリケーションを簡単にAPI化することができます：

- **REST API**: 一般的なHTTPリクエストで利用可能
- **認証**: APIキーによる簡単な認証方式
- **リアルタイム**: ストリーミング応答にも対応
- **多言語対応**: 様々なプログラミング言語から利用可能

## 2. 事前準備

### 2.1 DifyアプリケーションのAPI化

まず、Difyで作成したアプリケーションをAPI経由で利用できるように設定します。

1. **Difyコンソールにログイン**
   - [https://cloud.dify.ai](https://cloud.dify.ai) にアクセス
   - または自分でホストしているDifyインスタンスにアクセス

2. **アプリケーションを選択**
   - API化したいアプリケーションを開く
   - サイドメニューから「API」を選択

3. **APIキーを取得**
   - 「APIキーを作成」ボタンをクリック
   - 生成されたAPIキーをコピーして安全な場所に保存
   - ⚠️ **重要**: APIキーは他人に見せないように注意

### 2.2 APIエンドポイントの確認

APIページで以下の情報を確認します：

- **Base URL**: あなたのDifyインスタンスのURL（例：`https://api.dify.ai/v1`）
- **App ID**: アプリケーション固有の識別子
- **API Key**: 認証用のキー

## 3. CLIツールでの基本的な使い方

### 3.1 コマンドライン環境の準備

curlコマンドを使用する前に、お使いのオペレーティングシステムに応じてコマンドライン環境を開く必要があります。

#### Windows の場合
以下のいずれかの方法でコマンドライン環境を開いてください：

- **コマンドプロンプト**: 
  - `Win + R` を押して「cmd」と入力し、Enterキーを押す
  - または、スタートメニューで「cmd」と検索
- **PowerShell**:
  - `Win + X` を押して「Windows PowerShell」を選択
  - または、スタートメニューで「PowerShell」と検索
- **Windows Terminal**（Windows 10/11）:
  - スタートメニューで「Windows Terminal」と検索

#### macOS の場合
- **Terminal アプリケーション**:
  - `Cmd + Space` を押してSpotlight検索を開き、「Terminal」と入力
  - または、Finderで「アプリケーション」→「ユーティリティ」→「Terminal」を開く
  - Dockに追加しておくと便利です

#### Linux の場合
ディストリビューションに応じて以下のいずれかの方法を使用：
- **Ubuntu/Debian**: `Ctrl + Alt + T` キーボードショートカット
- **その他**: アプリケーションメニューから「Terminal」や「端末」を検索

### 3.2 curlコマンドを使った基本例

最もシンプルな方法として、コマンドラインツール「curl」を使ってDify APIを呼び出してみましょう。

#### 前提条件
- コンピューターにcurlがインストールされていること（多くのシステムで標準装備）
- 上記の手順でコマンドライン環境が開かれていること

#### 基本的なチャット呼び出し

```bash
curl -X POST 'https://api.dify.ai/v1/chat-messages' \
  --header 'Authorization: Bearer YOUR_API_KEY' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "inputs": {},
    "query": "こんにちは、調子はどうですか？",
    "response_mode": "blocking",
    "conversation_id": "",
    "user": "example-user"
  }'
```

**パラメータの説明**:
- `YOUR_API_KEY`: 2.1で取得したAPIキーに置き換える
- `query`: Difyに送信したい質問やメッセージ
- `response_mode`: `blocking`（一度に全回答）または `streaming`（リアルタイム）
- `user`: ユーザーを識別する任意の文字列

#### 実行例

```bash
# 実際の例（APIキーは仮のものです）
curl -X POST 'https://api.dify.ai/v1/chat-messages' \
  --header 'Authorization: Bearer app-1234567890abcdef' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "inputs": {},
    "query": "東京の天気について教えて",
    "response_mode": "blocking",
    "conversation_id": "",
    "user": "test-user"
  }'
```

### 3.3 ワークフローの実行

ワークフロータイプのアプリケーションの場合は、異なるエンドポイントを使用します：

```bash
curl -X POST 'https://api.dify.ai/v1/workflows/run' \
  --header 'Authorization: Bearer YOUR_API_KEY' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "inputs": {
      "input_field_name": "入力値"
    },
    "response_mode": "blocking",
    "user": "example-user"
  }'
```

## 4. Pythonを使った実装例

### 4.1 Python環境の準備

Pythonを使う場合、まず環境を準備します：

```bash
# requestsライブラリのインストール
pip install requests
```

### 4.2 基本的なPythonスクリプト

```python
import requests
import json

# 設定
API_KEY = "YOUR_API_KEY"  # ここに実際のAPIキーを入力
BASE_URL = "https://api.dify.ai/v1"
HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}

def send_message_to_dify(message, user_id="default-user"):
    """
    Difyにメッセージを送信して回答を取得する関数
    """
    url = f"{BASE_URL}/chat-messages"
    
    data = {
        "inputs": {},
        "query": message,
        "response_mode": "blocking",
        "conversation_id": "",
        "user": user_id
    }
    
    try:
        response = requests.post(url, headers=HEADERS, json=data)
        response.raise_for_status()  # エラーがあれば例外を発生
        
        result = response.json()
        return result["answer"]
        
    except requests.exceptions.RequestException as e:
        print(f"エラーが発生しました: {e}")
        return None

# 使用例
if __name__ == "__main__":
    user_message = "Pythonプログラミングについて教えて"
    answer = send_message_to_dify(user_message)
    
    if answer:
        print(f"質問: {user_message}")
        print(f"回答: {answer}")
    else:
        print("回答を取得できませんでした")
```

### 4.3 会話の継続

連続した会話を行う場合は、`conversation_id`を保存して使い回します：

```python
import requests
import json

class DifyChatClient:
    def __init__(self, api_key, base_url="https://api.dify.ai/v1"):
        self.api_key = api_key
        self.base_url = base_url
        self.headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        }
        self.conversation_id = ""
    
    def send_message(self, message, user_id="default-user"):
        """メッセージを送信"""
        url = f"{self.base_url}/chat-messages"
        
        data = {
            "inputs": {},
            "query": message,
            "response_mode": "blocking",
            "conversation_id": self.conversation_id,
            "user": user_id
        }
        
        try:
            response = requests.post(url, headers=self.headers, json=data)
            response.raise_for_status()
            
            result = response.json()
            
            # conversation_idを更新（継続した会話のため）
            if "conversation_id" in result:
                self.conversation_id = result["conversation_id"]
            
            return result["answer"]
            
        except requests.exceptions.RequestException as e:
            print(f"エラーが発生しました: {e}")
            return None

# 使用例：連続した会話
chat_client = DifyChatClient("YOUR_API_KEY")

# 最初の質問
response1 = chat_client.send_message("私の名前はタロウです")
print(f"回答1: {response1}")

# 二番目の質問（名前を覚えているかテスト）
response2 = chat_client.send_message("私の名前は何でしたか？")
print(f"回答2: {response2}")
```

### 4.4 ストリーミング応答の処理

リアルタイムで回答を受け取りたい場合：

```python
import requests
import json

def stream_chat_response(message, api_key):
    """ストリーミングで回答を受け取る"""
    url = "https://api.dify.ai/v1/chat-messages"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    
    data = {
        "inputs": {},
        "query": message,
        "response_mode": "streaming",
        "conversation_id": "",
        "user": "stream-user"
    }
    
    try:
        response = requests.post(url, headers=headers, json=data, stream=True)
        response.raise_for_status()
        
        print("回答: ", end="", flush=True)
        
        for line in response.iter_lines():
            if line:
                # Server-Sent Events形式のデータを解析
                line_str = line.decode('utf-8')
                if line_str.startswith('data: '):
                    data_str = line_str[6:]  # 'data: 'を除去
                    if data_str.strip() == '[DONE]':
                        break
                    
                    try:
                        data_json = json.loads(data_str)
                        if 'answer' in data_json:
                            print(data_json['answer'], end="", flush=True)
                    except json.JSONDecodeError:
                        continue
        
        print()  # 改行
        
    except requests.exceptions.RequestException as e:
        print(f"エラーが発生しました: {e}")

# 使用例
stream_chat_response("AIについて詳しく説明してください", "YOUR_API_KEY")
```

## 5. ウェブアプリケーションでの利用

### 5.1 HTMLとJavaScriptでの簡単な実装

```html
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dify チャットボット</title>
    <style>
        .chat-container {
            max-width: 600px;
            margin: 50px auto;
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 20px;
        }
        .messages {
            height: 400px;
            overflow-y: auto;
            border: 1px solid #eee;
            padding: 10px;
            margin-bottom: 10px;
        }
        .message {
            margin: 10px 0;
            padding: 8px;
            border-radius: 5px;
        }
        .user-message {
            background-color: #007bff;
            color: white;
            text-align: right;
        }
        .bot-message {
            background-color: #f8f9fa;
            color: #333;
        }
        .input-container {
            display: flex;
            gap: 10px;
        }
        #messageInput {
            flex: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        #sendButton {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="chat-container">
        <h2>Dify AI チャット</h2>
        <div id="messages" class="messages"></div>
        <div class="input-container">
            <input type="text" id="messageInput" placeholder="メッセージを入力してください..." />
            <button id="sendButton">送信</button>
        </div>
    </div>

    <script>
        // 設定（実際のAPIキーに置き換えてください）
        const API_KEY = 'YOUR_API_KEY';
        const BASE_URL = 'https://api.dify.ai/v1';
        
        let conversationId = '';
        
        // DOM要素の取得
        const messagesDiv = document.getElementById('messages');
        const messageInput = document.getElementById('messageInput');
        const sendButton = document.getElementById('sendButton');
        
        // メッセージを画面に表示する関数
        function addMessage(text, isUser = false) {
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${isUser ? 'user-message' : 'bot-message'}`;
            messageDiv.textContent = text;
            messagesDiv.appendChild(messageDiv);
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
        }
        
        // Dify APIにメッセージを送信する関数
        async function sendToDify(message) {
            try {
                const response = await fetch(`${BASE_URL}/chat-messages`, {
                    method: 'POST',
                    headers: {
                        'Authorization': `Bearer ${API_KEY}`,
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        inputs: {},
                        query: message,
                        response_mode: 'blocking',
                        conversation_id: conversationId,
                        user: 'web-user'
                    })
                });
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                const data = await response.json();
                
                // conversation_idを更新
                if (data.conversation_id) {
                    conversationId = data.conversation_id;
                }
                
                return data.answer;
                
            } catch (error) {
                console.error('エラーが発生しました:', error);
                return 'エラーが発生しました。しばらくしてから再度お試しください。';
            }
        }
        
        // メッセージ送信処理
        async function handleSendMessage() {
            const message = messageInput.value.trim();
            if (!message) return;
            
            // ユーザーメッセージを表示
            addMessage(message, true);
            messageInput.value = '';
            
            // 送信ボタンを無効化
            sendButton.disabled = true;
            sendButton.textContent = '送信中...';
            
            // Difyに送信して回答を取得
            const response = await sendToDify(message);
            addMessage(response, false);
            
            // 送信ボタンを有効化
            sendButton.disabled = false;
            sendButton.textContent = '送信';
        }
        
        // イベントリスナーの設定
        sendButton.addEventListener('click', handleSendMessage);
        messageInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                handleSendMessage();
            }
        });
        
        // 初期メッセージ
        addMessage('こんにちは！何かお手伝いできることはありますか？', false);
    </script>
</body>
</html>
```

### 5.2 Node.js/Express での実装例

サーバーサイドでDify APIを使用する場合の例：

```javascript
// package.json に以下を追加してから npm install
// "dependencies": { "express": "^4.18.0", "axios": "^1.0.0" }

const express = require('express');
const axios = require('axios');

const app = express();
app.use(express.json());
app.use(express.static('public')); // 静的ファイル用

const DIFY_API_KEY = 'YOUR_API_KEY';
const DIFY_BASE_URL = 'https://api.dify.ai/v1';

// Difyとのやり取りを処理するエンドポイント
app.post('/api/chat', async (req, res) => {
    try {
        const { message, conversationId, userId } = req.body;
        
        const response = await axios.post(`${DIFY_BASE_URL}/chat-messages`, {
            inputs: {},
            query: message,
            response_mode: 'blocking',
            conversation_id: conversationId || '',
            user: userId || 'express-user'
        }, {
            headers: {
                'Authorization': `Bearer ${DIFY_API_KEY}`,
                'Content-Type': 'application/json'
            }
        });
        
        res.json({
            answer: response.data.answer,
            conversationId: response.data.conversation_id
        });
        
    } catch (error) {
        console.error('Dify API エラー:', error);
        res.status(500).json({ 
            error: 'サーバーエラーが発生しました' 
        });
    }
});

app.listen(3000, () => {
    console.log('サーバーがポート3000で起動しました');
});
```

## 6. 認証とセキュリティ

### 6.1 APIキーの管理

APIキーは重要な認証情報です。以下の点に注意してください：

**良い例**:
```bash
# 環境変数で管理
export DIFY_API_KEY="your-api-key-here"
```

```python
import os
API_KEY = os.environ.get('DIFY_API_KEY')
```

**悪い例**:
```python
# コードに直接書く（危険）
API_KEY = "app-1234567890abcdef"  # ❌ これはNG
```

### 6.2 レート制限への対応

Dify APIには利用制限があります。制限に達した場合の対応：

```python
import time
import requests

def call_dify_with_retry(url, headers, data, max_retries=3):
    """リトライ機能付きのDify API呼び出し"""
    for attempt in range(max_retries):
        try:
            response = requests.post(url, headers=headers, json=data)
            
            # レート制限の場合
            if response.status_code == 429:
                wait_time = 2 ** attempt  # 指数バックオフ
                print(f"レート制限に達しました。{wait_time}秒待機します...")
                time.sleep(wait_time)
                continue
                
            response.raise_for_status()
            return response.json()
            
        except requests.exceptions.RequestException as e:
            if attempt == max_retries - 1:
                raise e
            time.sleep(1)
    
    return None
```

## 7. よくあるトラブルと解決方法

### 7.1 認証エラー

**症状**: `401 Unauthorized` エラー

**原因と解決策**:
- APIキーが間違っている → 正しいAPIキーを確認
- Authorizationヘッダーの形式が間違っている → `Bearer YOUR_API_KEY`の形式を確認
- APIキーの権限が不足している → Difyコンソールで権限を確認

### 7.2 接続エラー

**症状**: `Connection timeout` や `Connection refused`

**原因と解決策**:
- ネットワークの問題 → インターネット接続を確認
- URLが間違っている → Base URLを確認
- ファイアウォールでブロック → ネットワーク管理者に確認

### 7.3 レスポンスが返らない

**症状**: APIは成功するが期待した回答が得られない

**原因と解決策**:
- 入力パラメータが不正 → `inputs`フィールドの内容を確認
- アプリケーションの設定問題 → Difyコンソールでアプリの動作を確認
- LLMの応答問題 → Difyコンソールで同じ質問を試してみる

### 7.4 文字化け

**症状**: 日本語が正しく表示されない

**解決策**:
```python
# リクエスト時にUTF-8を明示
headers = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json; charset=utf-8"
}

# レスポンスの文字エンコーディングを指定
response = requests.post(url, headers=headers, json=data)
response.encoding = 'utf-8'
```

## 8. パフォーマンスの最適化

### 8.1 レスポンス時間の改善

```python
# 接続プールを使用してレスポンス時間を改善
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

session = requests.Session()

# リトライ戦略の設定
retry_strategy = Retry(
    total=3,
    status_forcelist=[429, 500, 502, 503, 504],
    backoff_factor=1
)

adapter = HTTPAdapter(max_retries=retry_strategy)
session.mount("http://", adapter)
session.mount("https://", adapter)

# セッションを使用してリクエスト
response = session.post(url, headers=headers, json=data, timeout=30)
```

### 8.2 ストリーミングの活用

長い回答の場合、ストリーミングを使用してユーザー体験を向上：

```python
def stream_response(message):
    """ストリーミングレスポンスでリアルタイム表示"""
    # ... (前述のストリーミングコードを参照)
    pass
```

## 9. 実用的な活用例

### 9.1 Slackボット

```python
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

def handle_slack_message(event, client, dify_client):
    """Slackメッセージを処理してDifyの回答を返す"""
    try:
        user_message = event['text']
        channel = event['channel']
        
        # Difyから回答を取得
        dify_response = dify_client.send_message(user_message)
        
        # Slackに回答を投稿
        client.chat_postMessage(
            channel=channel,
            text=dify_response
        )
        
    except SlackApiError as e:
        print(f"Slackエラー: {e}")
```

### 9.2 定期実行スクリプト

```python
import schedule
import time

def daily_report():
    """毎日のレポートを生成"""
    dify_client = DifyChatClient("YOUR_API_KEY")
    response = dify_client.send_message("今日の売上サマリーを教えて")
    
    # メール送信やファイル保存などの処理
    print(f"日次レポート: {response}")

# 毎日午前9時に実行
schedule.every().day.at("09:00").do(daily_report)

while True:
    schedule.run_pending()
    time.sleep(60)
```

### 9.3 カスタマーサポート自動化

```python
def auto_support_system(customer_inquiry):
    """カスタマーサポートの自動応答"""
    dify_client = DifyChatClient("YOUR_API_KEY")
    
    # 問い合わせ内容を分析
    classification = dify_client.send_message(
        f"以下の問い合わせを分類してください: {customer_inquiry}"
    )
    
    # 分類に基づいて適切な回答を生成
    if "技術的" in classification.lower():
        response = dify_client.send_message(
            f"技術サポート担当として回答してください: {customer_inquiry}"
        )
    elif "料金" in classification.lower():
        response = dify_client.send_message(
            f"料金について回答してください: {customer_inquiry}"
        )
    else:
        response = dify_client.send_message(
            f"一般的なサポートとして回答してください: {customer_inquiry}"
        )
    
    return {
        "classification": classification,
        "response": response
    }
```

## 10. 次のステップとコミュニティ

### 10.1 さらに学習したい場合

- [Dify公式API Documentation](https://docs.dify.ai/ja-jp/guides/application-publishing/launch-your-webapp-quickly)
- [Dify GitHub リポジトリ](https://github.com/langgenius/dify)
- [Dify Discord コミュニティ](https://discord.com/invite/FngNHpbcY7)

### 10.2 質問整理テンプレート

このガイドを読んだ後、疑問点を整理して今後の学習に活用しましょう。以下のテンプレートを使って疑問をまとめてください：

#### 技術的な疑問

```
【疑問のカテゴリ】
□ API の基本概念について
□ 認証・セキュリティについて
□ プログラミング実装について
□ パフォーマンス・最適化について
□ エラー対応について
□ その他: ___________

【具体的な疑問内容】
疑問: 
背景: 
期待している結果: 
現在の状況: 

【urgency】（優先度）
□ 高（すぐに解決したい）
□ 中（近いうちに解決したい）
□ 低（時間があるときに解決したい）

【試したこと】
- 
- 
- 
```

#### ビジネス活用に関する疑問

```
【活用シーン】
□ ウェブサイトへの組み込み
□ 既存システムとの連携
□ 業務自動化
□ カスタマーサポート
□ データ分析・レポート
□ その他: ___________

【具体的な用途】
現在の業務: 
解決したい課題: 
Difyで実現したいこと: 
想定する利用頻度: 
関係者: 

【技術的制約】
利用可能な技術: 
予算: 
期限: 
その他の制約: 
```

#### 学習に関する疑問

```
【学習目標】
短期目標（1-2週間）: 
中期目標（1-2ヶ月）: 
長期目標（3ヶ月以上）: 

【現在のスキルレベル】
□ プログラミング未経験
□ 基本的なコマンドライン操作ができる
□ 簡単なスクリプトが書ける
□ ウェブ開発の基礎知識がある
□ その他: ___________

【学習したい項目】
□ API の基本概念
□ curl コマンドの使い方
□ Python プログラミング
□ JavaScript/ウェブ開発
□ セキュリティ・認証
□ パフォーマンス最適化
□ その他: ___________

【学習の障害】
時間的制約: 
技術的な不安: 
環境的な制約: 
その他: 
```

### 10.3 フォローアップセッションの準備

上記のテンプレートを記入した後、以下の形式でまとめて質問セッションに備えましょう：

1. **最優先で解決したい問題（1-3個）**
2. **実現したい具体的なシナリオ（1-2個）**
3. **技術的に不安な点（制限なし）**
4. **次回までに試してみたいこと**

このガイドが、Difyの外部連携の第一歩として役立つことを願っています。技術的な課題に直面したときは、公式ドキュメントやコミュニティを活用して、一歩ずつ前進していきましょう。