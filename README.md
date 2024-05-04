# crawler

### 概要

[Apple のセキュリティリリース](https://support.apple.com/ja-jp/HT201222)にアクセスし、最新のiOSおよびiPadOSをチェックするプログラムです。  
チェック結果は標準出力またはメール送信できます。

> [!WARNING]
>本プログラムはAppleのサイトにアクセスします。（負荷をかけます。）  
>短い時間に繰り返し実行することのないようにお願いします。

---

### 環境

|言語|バージョン|
|---|---|
|<img src="https://camo.qiitausercontent.com/815b4bd43d5e5ba0bf116da6f5c2996abfa724d6/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f2d527562792d4343333432442e7376673f6c6f676f3d72756279267374796c653d666f722d7468652d6261646765">|3.3.1|

gemのバージョンはGemfile.lockを参照ください。  

---

### 使い方

1. リポジトリをクローン
```
$ git clone https://github.com/shirait/crawler.git
```
以下、「~/crawler」ディレクトリにクローンしたものとして進めます。環境に応じて適宜読み替えてください。

2. ruby3.3.1をインストール
```
$ rbenv install 3.3.1
$ cd ~/crawler
$ rbenv local 3.3.1
```
上記はrbenvを利用する場合の手順です。

3. gemをインストール
```
$ bundle install
```

4. 結果確認方法の設定

「ios_version_check.rb」最下部のコメントを外します。  
```
# puts IosVersionCheck.new.message
# IosVersionCheck.new.send_message('送信元メールアドレス', '送信先メールアドレス')
```
標準出力する場合は上の行の、メール送信したい場合は下の行のコメントを外してください。  
メールはpostfixを使います。postfixのセットアップを事前に行ってください。

5. プログラムの実行
```
$ ruby ios_version_check.rb
```

2024/05/04時点の実行結果は以下です。
```
最新のiOSおよびiPadOSのバージョンとリリース日は以下になります。
iOS 12.5.7(2023-01-23)
iOS 13.7(2020-09-01)
iOS 14.8.1(2021-10-26)
iOS 15.8.2(2024-03-05)
iOS 16.7.7(2024-03-21)
iOS 17.4.1(2024-03-21)
iPadOS 13.6(2020-07-15)
iPadOS 14.8.1(2021-10-26)
iPadOS 15.8.2(2024-03-05)
iPadOS 16.7.7(2024-03-21)
iPadOS 17.4.1(2024-03-21)
```

以上
