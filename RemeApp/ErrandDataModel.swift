//
//  ErrandDataModel.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/21.
//

import UIKit

struct ErrandDataModel {
    var id:String = UUID().uuidString
    var checkBox:Bool = false
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

enum SalesFloorType: Int { // Realm実装時に追記-> , CaseIterable, PersistableEnum
    case First
    case AOne
    case ATwo
    case ATree
    case BOne
    case BTwo
    case BThree
    case BFour
    case BFive
    case BSix
    case BSeven
    case COne
    case CTwo
    case CTree
    case CFour
    case CFive
    case CSix
    case CSeven

    var nameOfSalesFloor: String {
        switch self {
            case .First: return "売り場を選択"
            case .AOne: return "乳製品"
            case .ATwo: return "肉"
            case .ATree: return "魚介"
            case .BOne: return "卵"
            case .BTwo: return "冷凍品"
            case .BThree: return "お茶・コーヒー"
            case .BFour: return "乾麺・パスタ"
            case .BFive: return "レトルト"
            case .BSix: return "調味料"
            case .BSeven: return "惣菜"
            case .COne: return "パン"
            case .CTwo: return "飲料・酒"
            case .CTree: return "米"
            case .CFour: return "菓子"
            case .CFive: return "事務用品"
            case .CSix: return "日用品"
            case .CSeven: return "野菜"
        }
    }

    var colorOfSalesFloor: UIColor {
        switch self {
            case .First: return .gray
            case .AOne: return .red
            case .ATwo: return .blue
            case .ATree: return .green
            case .BOne: return .purple
            case .BTwo: return .orange
            case .BThree: return .brown
            case .BFour: return .magenta
            case .BFive: return .cyan
            case .BSix: return .systemPink
            case .BSeven: return .systemTeal
            case .COne: return .systemIndigo
            case .CTwo: return .systemYellow
            case .CTree: return .systemGreen
            case .CFour: return .systemRed
            case .CFive: return .systemGray
            case .CSix: return .systemPurple
            case .CSeven: return .systemBlue
        }
    }

    var addressOfSalesFloor: String {
        switch self {
            case .First: return ""
            case .AOne: return "A-1"
            case .ATwo: return "A-2"
            case .ATree: return "A-3"
            case .BOne: return "B-1"
            case .BTwo: return "B-2"
            case .BThree: return "B-3"
            case .BFour: return "B-4"
            case .BFive: return "B-5"
            case .BSix: return "B-6"
            case .BSeven: return "B-7"
            case .COne: return "C-1"
            case .CTwo: return "C-2"
            case .CTree: return "C-3"
            case .CFour: return "C-4"
            case .CFive: return "C-5"
            case .CSix: return "C-6"
            case .CSeven: return "C-7"

        }
    }

    var intValue: Int {
        return self.rawValue
    }

    init?(intValue: Int) {
        self.init(rawValue: intValue)
    }
}
