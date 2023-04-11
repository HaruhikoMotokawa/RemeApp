//
//  ProtocolTest.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/11.
//

import UIKit

protocol TextActionable {
    func testFunction()
}

extension TextActionable where Self: UIViewController {
    
//    func testFunction() {
//        errandDataList = errandDataList.sorted { (a, b) -> Bool in
//            if a.isCheckBox != b.isCheckBox {
//                return !a.isCheckBox
//            } else {
//                return a.salesFloorRawValue < b.salesFloorRawValue
//            }
//        }
//    }
}
