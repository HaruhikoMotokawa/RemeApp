![スクリーンショット 2023-07-11 23 24 37](https://github.com/HaruhikoMotokawa/RemeApp/assets/123522778/8031e15b-c98a-45fb-a1bc-0cf44bdb5f14)
# iOS Application「お使いーじー」

[https://apps.apple.com/jp/app/お使いーじー/id6449246683](https://apps.apple.com/jp/app/%E3%81%8A%E4%BD%BF%E3%81%84%E3%83%BC%E3%81%98%E3%83%BC/id6449246683)

## 1. 概要

「お使いーじー」は買い物リスト作成アプリです。

主にスーパーでの買い物を行うために自分で買い物をしにいくことはもちろん、

誰かに買い物のお使いをお願いすることを前提に作成されています。

アプリの主な機能は以下の通りです。

- 買い物リスト
    - 作成、編集、単品削除、複数削除
    - 写真の添付機能
    - 売り場タグによる自動整列機能
    - 整列順を２通りから切り替え機能
- 店内の売り場をマップ形式で確認できる「売り場マップ」
    - 購入商品の有無でマップのボタンが変化し、目的地を確認
    - 売り場の名称をデフォルト設定とカスタム設定で切り替え
    - カスタム設定の編集機能
- リストの共有を行うための「アカウント」
    - アカウントの作成、削除、ログイン、ログアウト
    - 買い物リストの共有設定機能
- 操作方法や注意点を閲覧できる「ヘルプ」

アプリはリリースだけではなくアップデートを行なっています。

ver1.0.0 ← リリース

ver1.0.1 ← 表示のバグとiOS Deployment Targetを修正

ver1.1.0 ← アプリ起動時のチュートリアルとヘルプボタンの実装

ver1.1.1 ← RealmからFirebaseに移行するためのアプリバージョン管理実装

ver2.0.0 ← 買い物リストの共有機能とアカウント機能実装

ver2.0.1 ← リファクタリングの実施とライセンス認証の表示を実装

ver2.0.2 ← 【現在】共有者設定に自分自身を設定できてしまう不具合を修正
           Firebase CrashlyticsとAnalyticsを導入

## 2. 作成動機

もっと簡単に共有できて、お使いに特化した、さらにはスーパーでの買い物に慣れていない人でも買い物が効率的にできるアプリがあればいいのにと思っていました。

妻が長男を出産した際に私が慣れないスーパーでの買い物を担当していました。

どこに何があるか分からず困った経験があります。

当時はLINEに妻が書いたメモを見ながら購入するスタイルでしたが抜けがあったり、間違ったものを購入したりしました。

なので、このアプリは自分でメモして買いに行くというよりは、買い物を頼む人が作成し、それに沿って頼まれた人が買い物をするシーンを想定して作成しています。

## 3. 使用技術

### 3-1 Framework

UIKit

### 3-2 Library

ライブラリ導入ツール
CocoaPods

- IQKeyboardManager
　ver1.0.0から導入
　買い物リスト編集でのキーボード位置の自動調整

- RealmSwift
  ver1.0.0から導入
  全てのデータベースとして使用
  ver2.0.0からはカスタムマップの名称と色情報の保存のみに使用

- FirebaseAuthentication
  ver2.0.0から導入
  匿名認証とアカウント作成に使用

- Cloud Firestore
  ver2.0.0から導入
  アカウント情報の保存と買い物リストの情報を保存

- Cloud Storage
　ver2.0.0から導入
　買い物リストに添付する写真データを保存

- FirebaseFirestoreSwift
　ver2.0.0から導入
  Swiftのstructで作成したデータモデルをFirestoreのデータベースのドキュメントに変換
  
- FirebaseCrashlytics
　ver2.0.2から導入
  クラッシュログを取得するために使用
  
- FirebaseAnalytics
　ver2.0.2から導入
　ユーザーのアプリ使用状況を把握するために使用
　今回は実験で「買い物リストの新規作成回数」と「買い物リスト作成時に写真を添付して保存」
　の２つについて収集

- LicensePlist
　ver2.0.1から導入
　外部ライブラリのラインセンス情報の表示のために使用

まずは早期リリースを目標に情報リソースが多く比較的学習コストの低いRealmSwiftをデータベースとして採用しました。

苦労した点は、写真の保存と表示です。

解決に向けてRealmの写真保存の仕組み、iOSの写真の保存と読み込みの仕組みを学びました。

ソフトウェアキーボードの自動調整についてはIQKeyboardManagerを使用しています。

Apple純正の機能としてAdjusting Your Layout with Keyboard Layout Guideの存在は認知しています。

実装コストを考えライブラリの導入をしました。ここは純正の機能でも実装できるようにするのが今後の課題です。

Firebase関連は買い物リストをアプリ間で共有する為に選定しました。

学習コストはやや高いものの、個人開発でクラウド機能を比較的簡単に導入できるために選定しました。こちらはバージョン２にて導入しています。

苦労した点は多々あります。「非同期処理の理解」「写真の保存、削除」「セルの削除」「ネットワークの監視」「画像のキャッシュ」などです。

この解決にあたってアプリケーションの仕組み、ネットワークの仕組み、解決するためのSDKの知識を学ぶことができました。

また、アプリのバージョン１から２に上げる際に買い物リストの保存データベースを

RealmSwiftからFirebaseに切り替えるにあたって、アップデート時の移行処理を

組み込み、ユーザーのデータ資産を守ることを意識ました。

### 3-3 標準SDK

UIViewController

UITabBarController

UINavigationController

UITableViewController

StaticCell

UIScrollView

UITableView

xibファイル

UITableViewCell

UIStackView

UILabel

UIButton

UIImageView

UITextField

UITextView

UIPickerView

UISegmentedControl

UIImagePickerController

ContainerView

UIPageViewController

UserDefaults

URLSession

NSCache

NWPathMonitor


レイアウトに関してはなるべくUIStackViewを使用して制約を少なくすることを意識しました。

AlignmentとDistribution、Spacingの調整方法を学び使いこなすまでに苦労しました。

UITableViewの取り扱いが非常に苦労しました。

セルの再利用、セルの削除のルールや配列との関係について学ぶことができました。

UIPickerViewは買い物リストを作成から保存まで入力を素早く行えるよう採用しました。

NWPathMonitorによってネットワーク状況を監視して、オフライン状況での機能制限やアラートによる注意喚起を行う為に実装しました。

URLSessionとNSCacheは画像のダウンロードと表示に使用しています。

キャッシュ関連はKingfisherやAlamofireImage、Nukeなどがあります。

まずは原理を学ぶ為にもあえて標準で実装しました。

### 3-4 設計と開発で意識したこと

MVCを元に設計しています。

また、Main.Storyboardを削除して、１Storyboard１viewControllerを原則として開発してきました。

個人開発の段階からチーム開発を意識し、コンフリクトを防ぎ、ファイル管理をしやすくすることができました。

## 4. 自身の課題

- Swift言語のさらなる習熟：配列操作、クロージャなど
- コードでレイアウトを組む
- APIの取り扱い方法の習熟
- ネットワーク知識の習熟
- 外部ライブラリの習得：Kingfisher、Alamofire、lottie-iOSなど
- MVC以外のアーキテクチャの知識と技術：MVP、MVVM、VIPER
- SwiftUIの学習
