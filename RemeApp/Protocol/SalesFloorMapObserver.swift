//
//  SalesFloorMapObserver.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/16.
//

import UIKit

protocol SalesFloorMapObserver: AnyObject {
    func updateSelectCheckMarkVisibility(isCustomMapSelected: Bool)
}
