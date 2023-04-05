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
    var salesFloor: SalesFloorType {
        get {
            return SalesFloorType(rawValue: salesFloorRawValue)!
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

/// 売り場の詳細データ
enum SalesFloorType: Int, CaseIterable { // Realm実装時に追記-> , PersistableEnum

    /// 売り場の番地、赤１〜５と青１〜７、緑１〜５
    case redOne
    case redTwo
    case redThree
    case redFour
    case redFive
    case blueOne
    case blueTwo
    case blueThree
    case blueFour
    case blueFive
    case blueSix
    case blueSeven
    case greenOne
    case greenTwo
    case greenThree
    case greenFour
    case greenFive

    /// 売り場の名称
    var nameOfSalesFloor: String {
        switch self {
            case .redOne: return "野菜・果物"
            case .redTwo: return "惣菜"
            case .redThree: return "魚介類"
            case .redFour: return "調味料"
            case .redFive: return "日用品"
            case .blueOne: return "事務用品"
            case .blueTwo: return "レトルト"
            case .blueThree: return "肉類"
            case .blueFour: return "乾麺・パスタ"
            case .blueFive: return "菓子"
            case .blueSix: return "米"
            case .blueSeven: return "お茶・珈琲"
            case .greenOne: return "飲料・酒"
            case .greenTwo: return "冷凍品"
            case .greenThree: return "乳製品"
            case .greenFour: return "卵・冷蔵洋菓子"
            case .greenFive: return "パン"
        }
    }

    /// 売り場に対応する色、UIButtonの背景色に使用する
    var colorOfSalesFloor: UIColor {
        switch self {
            case .redOne: return .green
            case .redTwo: return .systemTeal
            case .redThree: return .blue
            case .redFour: return .systemPurple
            case .redFive: return .systemPink
            case .blueOne: return .purple
            case .blueTwo: return .brown
            case .blueThree: return .red
            case .blueFour: return .systemRed
            case .blueFive: return .magenta
            case .blueSix: return .systemGray
            case .blueSeven: return .systemGreen
            case .greenOne: return .systemIndigo
            case .greenTwo: return .cyan
            case .greenThree: return .systemBlue
            case .greenFour: return .systemYellow
            case .greenFive: return .orange
        }
    }

    /// 売り場の番地、もしかしたら使わないかも？
    var addressOfSalesFloor: String {
        switch self {
            case .redOne: return "赤①"
            case .redTwo: return "赤②"
            case .redThree: return "赤③"
            case .redFour: return "赤④"
            case .redFive: return "赤⑤"
            case .blueOne: return "青①"
            case .blueTwo: return "青②"
            case .blueThree: return "青③"
            case .blueFour: return "青④"
            case .blueFive: return "青⑤"
            case .blueSix: return "青⑥"
            case .blueSeven: return "青⑦"
            case .greenOne: return "緑①"
            case .greenTwo: return "緑②"
            case .greenThree: return "緑③"
            case .greenFour: return "緑④"
            case .greenFive: return "緑⑤"

        }
    }

    /// enumにintValueを設定
    var intValue: Int {
        return self.rawValue
    }

    /// intValueからenumを設定する
    init?(intValue: Int) {
        self.init(rawValue: intValue)

    }
}
