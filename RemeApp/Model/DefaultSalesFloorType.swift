//
//  DefaultSalesFloorType.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/17.
//

import Foundation
import UIKit
/// 売り場の詳細データ
enum DefaultSalesFloorType: Int, CaseIterable {

    /// 売り場の番地、赤１〜５と青１〜７、緑１〜５
    case redOne //0
    case redTwo //1
    case redThree //2
    case redFour //3
    case redFive //4
    case blueOne  //5
    case blueTwo // 6
    case blueThree //7
    case blueFour //8
    case blueFive //9
    case blueSix //10
    case blueSeven //11
    case greenOne //12
    case greenTwo //13
    case greenThree //14
    case greenFour //15
    case greenFive //16

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
            case .blueFour: return .yellow
            case .blueFive: return .magenta
            case .blueSix: return .systemMint
            case .blueSeven: return .systemGreen
            case .greenOne: return .systemIndigo
            case .greenTwo: return .cyan
            case .greenThree: return .systemBlue
            case .greenFour: return .systemYellow
            case .greenFive: return .orange
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
