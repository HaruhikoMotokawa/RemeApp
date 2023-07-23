//
//  ErrandDataModel.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/21.
//

import Foundation
import RealmSwift

/// お使いデータモデル
final class ErrandDataModel: Object {

    /// データのID
    @objc dynamic var id:String = UUID().uuidString
    /// 商品の購入判定
    @objc dynamic var isCheckBox:Bool = false
    /// 商品名
    @objc dynamic var nameOfItem:String = ""
    /// 商品の必要数
    @objc dynamic var numberOfItem = "1"
    /// 商品の必要数に対する単位
    @objc dynamic var unit:String = "個"
    /// 売り場に対応するRawValue
    @objc dynamic var salesFloorRawValue:Int = 0
    /// 商品に対する補足文、nilを許容
    @objc dynamic var supplement:String? = nil
    /// 商品の写真データのファイル名、nilを許容
    @objc dynamic var photoFileName:String? = nil

    /// enum DefaultSalesFloorTypeをお使いデータに登録
    var defaultSalesFloor: DefaultSalesFloorType {
        get {
            return DefaultSalesFloorType(rawValue: salesFloorRawValue)!
        }
        set {
            salesFloorRawValue = newValue.intValue
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

    /// 写真データを保存するためのファイル名を出力するメソッド
    /// - 保存するドキュメントディレクトリのURLを取得
    /// - ファイルを保存するURLを作成
    /// - 保存するデータをjpegに変換
    /// - ファイルURLにデータを保存
    /// - ファイル名を出力
    func setImage(image: UIImage?) -> String? {
        // 画像がnilだったらnilを返却して処理から抜ける
        guard let image = image else { return nil }
        // ファイル名をUUIDで生成し、拡張子を".jpeg"にする
        let fileName = UUID().uuidString + ".jpeg"
        // ドキュメントディレクトリのURLを取得
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // ファイルのURLを作成
        let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
        // UIImageをJPEGデータに変換
        let data = image.jpegData(compressionQuality: 1.0)
        // JPEGデータをファイルに書き込み
        do {
            try data!.write(to: fileURL)
            print(fileName)
        } catch {
            print("💀エラー")
        }
        return fileName
    }

    /// 保存したファイル名を使って写真データを検索し、UIImageとして出力する
    /// - ドキュメントディレクトリのURLを取得
    /// - ファイルのURLを取得
    /// - ファイルからデータを読み込み、UIImageに変換して返却する
    func getImage() -> UIImage? {
        // photoFileNameがnilならnilを返却して抜ける
        guard let path = self.photoFileName else { return nil }
            // ドキュメントディレクトリのURLを取得
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            // ファイルのURLを取得
            let fileURL = documentsDirectoryURL.appendingPathComponent(path)
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
