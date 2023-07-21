//
//  Router.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/21.
//

import UIKit

final class Router {
    static let shared = Router()
    private init() {}

    internal func showRoot(windowScene: UIWindowScene) -> UIWindow {
        //Windowをインスタンス化
        let window = UIWindow(windowScene: windowScene)
        //rootViewControllerに指定したいControllerを指定
        //StoryboardからViewControllerを生成
        window.rootViewController = UIStoryboard(name: "UITabBarControllerView", bundle: nil).instantiateInitialViewController()
        window.makeKeyAndVisible()
        return window
    }
}
