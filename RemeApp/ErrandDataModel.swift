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
    case aOne
    case aTwo
    case aTree
    case bOne
    case bTwo
    case bThree
    case bFour
    case bFive
    case bSix
    case bSeven
    case cOne
    case cTwo
    case cTree
    case cFour
    case cFive
    case cSix
    case cSeven

    var nameOfSalesFloor: String {
        switch self {
//            case .first: return "売り場を選択"
            case .aOne: return "乳製品"
            case .aTwo: return "肉類"
            case .aTree: return "魚介"
            case .bOne: return "卵"
            case .bTwo: return "冷凍"
            case .bThree: return "お茶・珈琲"
            case .bFour: return "乾麺・パスタ"
            case .bFive: return "レトルト"
            case .bSix: return "調味料"
            case .bSeven: return "惣菜"
            case .cOne: return "パン"
            case .cTwo: return "飲料・酒"
            case .cTree: return "米"
            case .cFour: return "菓子"
            case .cFive: return "事務用品"
            case .cSix: return "日用品"
            case .cSeven: return "野菜"
        }
    }

    var colorOfSalesFloor: UIColor {
        switch self {
//            case .first: return .gray
            case .aOne: return .red
            case .aTwo: return .blue
            case .aTree: return .green
            case .bOne: return .purple
            case .bTwo: return .orange
            case .bThree: return .brown
            case .bFour: return .magenta
            case .bFive: return .cyan
            case .bSix: return .systemPink
            case .bSeven: return .systemTeal
            case .cOne: return .systemIndigo
            case .cTwo: return .systemYellow
            case .cTree: return .systemGreen
            case .cFour: return .systemRed
            case .cFive: return .systemGray
            case .cSix: return .systemPurple
            case .cSeven: return .systemBlue
        }
    }

    var addressOfSalesFloor: String {
        switch self {
//            case .first: return ""
            case .aOne: return "A-1"
            case .aTwo: return "A-2"
            case .aTree: return "A-3"
            case .bOne: return "B-1"
            case .bTwo: return "B-2"
            case .bThree: return "B-3"
            case .bFour: return "B-4"
            case .bFive: return "B-5"
            case .bSix: return "B-6"
            case .bSeven: return "B-7"
            case .cOne: return "C-1"
            case .cTwo: return "C-2"
            case .cTree: return "C-3"
            case .cFour: return "C-4"
            case .cFive: return "C-5"
            case .cSix: return "C-6"
            case .cSeven: return "C-7"

        }
    }

    var intValue: Int {
        return self.rawValue
    }

    init?(intValue: Int) {
        self.init(rawValue: intValue)

    }
}
