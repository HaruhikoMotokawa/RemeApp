//
//  RealmFirebaseMigrationManager.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/01.
//

import Foundation
import RealmSwift
import UIKit

final class RealmFirebaseMigrationManager {

    static let shared = RealmFirebaseMigrationManager()

    private init() {}

    private var myShoppingItemList: [ShoppingItemModel] = []

    /// RealmからFirebaseへ保存し直す処理
    internal func migration() async throws {
        try await AccountManager.shared.signInAnonymity() // 匿名認証でログイン

        let uid = AccountManager.shared.getAuthStatus() // ログイン後のuid取得
        // 匿名認証用のusersデータ作成
        try await FirestoreManager.shared.createUsers(
            name: "",
            email: "",
            password: "",
            uid: uid)

        let realm = try! await Realm()
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
        // myShoppingItemListの要素分だけ順番に回す
        for item in myShoppingItemList {
            // 写真の保存処理、realmのファイルパスから画像を取得して保存
            StorageManager.shared.upLoadShoppingItemPhoto(uid: uid, image: getImage(photoURL: item.photoURL)) { url in
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
    }

    /// 保存したファイル名を使って写真データを検索し、UIImageとして出力する
    /// - ドキュメントディレクトリのURLを取得
    /// - ファイルのURLを取得
    /// - ファイルからデータを読み込み、UIImageに変換して返却する
    func getImage(photoURL photoFileName: String) -> UIImage? {
        // photoFileNameがnilならnilを返却して抜ける
        guard !photoFileName.isEmpty else { return nil }
        // ドキュメントディレクトリのURLを取得
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // ファイルのURLを取得
        let fileURL = documentsDirectoryURL.appendingPathComponent(photoFileName)
        // ファイルからデータを読み込む
        do {
            let imageData = try Data(contentsOf: fileURL)
            // データをUIImageに変換して返却する
            return UIImage(data: imageData)
        } catch {
            print("💀エラー")
            return nil
        }
    }
}
