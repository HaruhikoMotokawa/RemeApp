//
//  MainTabBarController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 画像と文字の選択時の色を指定（未選択字の色はデフォルトのまま）
        UITabBar.appearance().tintColor = UIColor.white

    }
}

