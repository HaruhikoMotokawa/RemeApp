//
//  ErrandDataModel.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/21.
//

import UIKit

/// お使いデータモデル
struct ErrandDataModel {
    /// データのID
    var id:String = UUID().uuidString
    /// 商品の購入判定
    var isCheckBox:Bool = false
    /// 商品名
    var nameOfItem:String = ""
    /// 商品の必要数
    var numberOfItem = "1"
    /// 商品の必要数に対する単位
    var unit:String = "個"
    /// 売り場に対応するRawValue
    var salesFloorRawValue:Int = 0

    /// 商品に対する補足文、nilを許容
    var supplement:String? = nil
    /// 商品の写真データパス、nilを許容
    var photoPath:String? = nil
    var photoImage:UIImage? = nil // テスト用であとで削除
    /// enum SalesFloorTypeをお使いデータに登録
    var salesFloor: DefaultSalesFloorType {
        get {
            return DefaultSalesFloorType(rawValue: salesFloorRawValue)!
        }
        set {
            salesFloorRawValue = newValue.intValue
        }
    }

//    override static func primaryKey() -> String? {
//        return "id"
//    }

    ///
    mutating func setImage(image: UIImage?, path: String?) {
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
