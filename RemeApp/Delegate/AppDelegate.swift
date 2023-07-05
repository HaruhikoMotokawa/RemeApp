//
//  AppDelegate.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?)  -> Bool {
        // ネットワークの監視を開始
        NetworkMonitor.shared.startMonitoring()

        // Firebaseの初期設定
        FirebaseApp.configure()

        // IQKeyboardManagerを設定
        IQKeyboardManager.shared.enable = true

        let defaults = UserDefaults.standard

        /// 現在起動しているアプリバージョンを取得
        let currentVersion = VersionManager.shared.getCurrentVersion()
        print(currentVersion ?? "取得できません")
        let savedVersion = VersionManager.shared.getSavedVersion()
        print(savedVersion ?? "記録されていません")

        // バージョンが異なる場合の処理
        if let savedVersionArray = savedVersion?.components(separatedBy: ".").compactMap({ Int($0) }),
           savedVersionArray.first == 1 {
            // 保存されたバージョンが1.x.xの場合の処理
            print("前バージョンが１なのでFirestore移行処理するで")
            // もしオフラインだったらアラート出してアプリを強制終了
            if !NetworkMonitor.shared.isConnected {
                AlertController.showExitAlert(tittle: "オフラインです", message: "初期設定にはオンライン環境が必要です。")
            }

            Task { @MainActor in
                do {
                    AlertController.showAlert(tittle: "移行処理中",
                                              errorMessage:
                    """
                    この処理はオンライン上で必ず行なってください。
                    画面が表示されたら以降は完了です
                    """
                    )
                    let realm = try await Realm()

                    try await AccountManager.shared.signInAnonymity() // 匿名認証でログイン

                    let uid = AccountManager.shared.getAuthStatus() // ログイン後のuid取得
                    // 匿名認証用のusersデータ作成
                    try await FirestoreManager.shared.createUsers(
                        name: "",
                        email: "",
                        password: "",
                        uid: uid)
                    var myShoppingItemList: [ShoppingItemModel] = []

                    // ShoppingItemModelに沿う形にerrandDataModelの情報をマッピングして収納
                    myShoppingItemList = realm.objects(ErrandDataModel.self).map { (errandDataModel) -> ShoppingItemModel in
                        return ShoppingItemModel(isCheckBox: errandDataModel.isCheckBox,
                                                 nameOfItem: errandDataModel.nameOfItem,
                                                 numberOfItem: errandDataModel.numberOfItem,
                                                 unit: errandDataModel.unit,
                                                 salesFloorRawValue: errandDataModel.salesFloorRawValue,
                                                 supplement: errandDataModel.supplement ?? "",
                                                 photoURL: errandDataModel.photoFileName ?? "",
                                                 owner: uid,
                                                 sharedUsers: [],
                                                 date: Date())
                    }

                    if myShoppingItemList.isEmpty {
                        return
                    }
                    // myShoppingItemListの要素分だけ順番に回す
                    for item in myShoppingItemList {
                        // 写真の保存処理、realmのファイルパスから画像を取得して保存
                        StorageManager.shared.upLoadShoppingItemPhoto(
                            uid: uid,
                            image: MigrationManager.shared.getImage(photoURL: item.photoURL)) { url in
                                guard let photoURL = url else { return }
                                // 保存するリストを作成
                                let addItem:ShoppingItemModel = ShoppingItemModel(
                                    isCheckBox: item.isCheckBox,
                                    nameOfItem: item.nameOfItem,
                                    numberOfItem: item.numberOfItem,
                                    unit: item.unit,
                                    salesFloorRawValue: item.salesFloorRawValue,
                                    supplement: item.supplement,
                                    photoURL: photoURL,
                                    owner: uid,
                                    sharedUsers: item.sharedUsers)
                                // Firestoreに保存
                                FirestoreManager.shared.addItem(uid: uid, addItem: addItem)
                            }
                    }
                    // realmのErrandDataModelを削除する
                    let errandDatalist = realm.objects(ErrandDataModel.self)
                    try! realm.write {
                        realm.delete(errandDatalist)
                    }
                    print("✨✨✨移　行　完　了✨✨✨")
                } catch let error {
                    let errorMessage = FirebaseErrorManager.shared.setAuthErrorMessage(error)
                    // アラート表示
                    AlertController.showAlert(tittle: "エラー", errorMessage: errorMessage)
                    print(error.localizedDescription)
                }
            }
        }
        // 現在のバージョンをUserDefaultsに保存
        VersionManager.shared.saveCurrentVersion()

        //初期起動のチュートリアル表示
        let firstLunchKey = "firstLunch"
        let firstLunch = [firstLunchKey: true]
        defaults.register(defaults: firstLunch)

        // アプリインストール後の初回起動時に使用マップ設定をデフォルトにする処理
        let useSalesFloorTypeKey = "useSalesFloorTypeKey"
        let shoppingStartPositionKey = "shoppingStartPositionKey"
        let isInitialLaunch = UserDefaults.standard.bool(forKey: "isInitialLaunch")

        // アプリインストール後の初回起動時の処理
        if !isInitialLaunch {
            Task { @MainActor in
                do {
                    // もしオフラインだったらアラート出してアプリを強制終了
                    if !NetworkMonitor.shared.isConnected {
                        AlertController.showExitAlert(tittle: "オフラインです", message: "初期設定にはオンライン環境が必要です。")
                    }
                    try await AccountManager.shared.signInAnonymity()
                    // 現在のuidを取得
                    let uid = AccountManager.shared.getAuthStatus()
                    // 匿名認証用のusersデータ作成
                    try await FirestoreManager.shared.createUsers(
                        name: "",
                        email: "",
                        password: "",
                        uid: uid)
                } catch {
                    print("失敗")
                }
            }

            UserDefaults.standard.set(true, forKey: "isInitialLaunch")
            UserDefaults.standard.setValue(SalesFloorMapType.default.rawValue, forKey: useSalesFloorTypeKey)
            UserDefaults.standard.setValue(ShoppingStartPositionType.right.rawValue, forKey: shoppingStartPositionKey)

            let realm = try! Realm()
            // 17個のカスタム売り場データを作成
            let customSalesFloors: [CustomSalesFloorModel] = [
                CustomSalesFloorModel(salesFloorRawValue: 0, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 0),
                CustomSalesFloorModel(salesFloorRawValue: 1, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 1),
                CustomSalesFloorModel(salesFloorRawValue: 2, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 2),
                CustomSalesFloorModel(salesFloorRawValue: 3, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 3),
                CustomSalesFloorModel(salesFloorRawValue: 4, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 4),
                CustomSalesFloorModel(salesFloorRawValue: 5, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 5),
                CustomSalesFloorModel(salesFloorRawValue: 6, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 6),
                CustomSalesFloorModel(salesFloorRawValue: 7, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 7),
                CustomSalesFloorModel(salesFloorRawValue: 8, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 8),
                CustomSalesFloorModel(salesFloorRawValue: 9, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 9),
                CustomSalesFloorModel(salesFloorRawValue: 10, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 10),
                CustomSalesFloorModel(salesFloorRawValue: 11, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 11),
                CustomSalesFloorModel(salesFloorRawValue: 12, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 12),
                CustomSalesFloorModel(salesFloorRawValue: 13, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 13),
                CustomSalesFloorModel(salesFloorRawValue: 14, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 14),
                CustomSalesFloorModel(salesFloorRawValue: 15, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 15),
                CustomSalesFloorModel(salesFloorRawValue: 16, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 16)
            ]
            try! realm.write {
                realm.add(customSalesFloors)
            }
        }
        sleep(1)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

