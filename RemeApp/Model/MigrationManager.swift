//
//  RealmFirebaseMigrationManager.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/01.
//

import Foundation
import RealmSwift
import UIKit

final class MigrationManager {

    static let shared = MigrationManager()

    private init() {}

    private var myShoppingItemList: [ShoppingItemModel] = []

    
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
