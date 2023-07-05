//
//  AlertController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/17.
//

import UIKit

class AlertController {

    /// エラーメッセージごとにアラートを出す
    static func showAlert(tittle: String, errorMessage: String,completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: tittle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  _ in
            completion?()
        }))

        // 現在アクティブな最初のシーンを取得
        if let scene =  UIApplication.shared.connectedScenes.first,
           // シーンのデリゲートをSceneDelegateにキャストして取得
           let delegate = scene.delegate as? SceneDelegate,
           // 表示されている最前面の画面に関連付けられたビューコントローラを取得
           let rootViewController = delegate.window?.rootViewController {
            // rootViewControllerにアラートを表示
            rootViewController.present(alert, animated: true)
        }
    }

    /// オフライン時のアラート
    static func showOffLineAlert(tittle: String, message: String,
                                 view:UIViewController, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  _ in
            completion?()
        }))
        // rootViewControllerにアラートを表示
        view.present(alert, animated: true)
    }

    static func showExitAlert(tittle: String, message: String,
                              completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // アプリを終了する
            exit(0)
        }))
        // 現在アクティブな最初のシーンを取得
        if let scene =  UIApplication.shared.connectedScenes.first,
           // シーンのデリゲートをSceneDelegateにキャストして取得
           let delegate = scene.delegate as? SceneDelegate,
           // 表示されている最前面の画面に関連付けられたビューコントローラを取得
           let rootViewController = delegate.window?.rootViewController {
            // rootViewControllerにアラートを表示
            rootViewController.present(alert, animated: true)
        }
    }

}

