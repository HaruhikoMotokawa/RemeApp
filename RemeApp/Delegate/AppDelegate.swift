//
//  AppDelegate.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true

        // アプリインストール後の初回起動時に使用マップ設定をデフォルトにする処理
        let useSalesFloorTypeKey = "useSalesFloorTypeKey"
        let shoppingStartPositionKey = "shoppingStartPositionKey"
        let isInitialLaunch = UserDefaults.standard.bool(forKey: "isInitialLaunch")

        if !isInitialLaunch {
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

