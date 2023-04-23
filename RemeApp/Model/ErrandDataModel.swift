//
//  ErrandDataModel.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/21.
//

import UIKit
import RealmSwift

/// お使いデータモデル
class ErrandDataModel: Object {

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
    /// 商品の写真データパス、nilを許容
    @objc dynamic var photoPath:String? = nil

    // !!!: テスト用であとで削除
//    var photoImage:UIImage? = nil

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

    ///
    func setImage(image: UIImage?, path: String?) {
        if let image = image {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = UUID().uuidString + ".jpeg"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            if let data = image.jpegData(compressionQuality: 1.0) {
                do {
                    try data.write(to: fileURL)
                    self.photoPath = fileName
                } catch {
                    print("Error saving image: \\(error.localizedDescription)")
                }
            }
        }
    }

    func getImage() -> UIImage? {
        if let path = self.photoPath {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsDirectory.appendingPathComponent(path)
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {
                print("Error loading image: \\(error.localizedDescription)")
            }
        }
        return nil
    }
}
