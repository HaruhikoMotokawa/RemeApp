//
//  CustomSalesFloorColor.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/20.
//

import Foundation
import UIKit

enum CustomSalesFloorColor: Int {
    case green
    case systemTeal
    case blue
    case systemPurple
    case systemPink
    case purple
    case brown
    case red
    case systemRed
    case magenta
    case systemGray
    case systemGreen
    case systemIndigo
    case cyan
    case systemBlue
    case systemYellow
    case orange

    var color: UIColor {
        switch self {
            case .green:
                return UIColor.green
            case .systemTeal:
                return UIColor.systemTeal
            case .blue:
                return UIColor.blue
            case .systemPurple:
                return UIColor.systemPurple
            case .systemPink:
                return UIColor.systemPink
            case .purple:
                return UIColor.purple
            case .brown:
                return UIColor.brown
            case .red:
                return UIColor.red
            case .systemRed:
                return UIColor.systemRed
            case .magenta:
                return UIColor.magenta
            case .systemGray:
                return UIColor.systemGray
            case .systemGreen:
                return UIColor.systemGreen
            case .systemIndigo:
                return UIColor.systemIndigo
            case .cyan:
                return UIColor.cyan
            case .systemBlue:
                return UIColor.systemBlue
            case .systemYellow:
                return UIColor.systemYellow
            case .orange:
                return UIColor.orange
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
