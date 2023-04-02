//
//  ErrandDataModel.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/21.
//

import UIKit

struct ErrandDataModel {
    var id:String = UUID().uuidString
    var isCheckBox:Bool = false
    var nameOfItem:String = ""
    var numberOfItem = "1"
    var unit:String = "個"
    var salesFloorRawValue:Int = 0
    var supplement:String? = nil
    var photoPath:String? = nil
    var photoImage:UIImage? = nil // テスト用であとで削除
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

enum SalesFloorType: Int, CaseIterable { // Realm実装時に追記-> , PersistableEnum
//    case first
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

    var nameOfSalesFloor: String {
        switch self {
//            case .first: return "売り場を選択"
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

    var colorOfSalesFloor: UIColor {
        switch self {
//            case .first: return .gray
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

    var addressOfSalesFloor: String {
        switch self {
//            case .first: return ""
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

    var intValue: Int {
        return self.rawValue
    }

    init?(intValue: Int) {
        self.init(rawValue: intValue)

    }
}
