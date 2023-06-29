//
//  IndicatorController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/29.
//

import Foundation
import UIKit

final class IndicatorController {

    /// 他のクラスで使用できるようにstaticで定義
    static let shared = IndicatorController()
    /// 外部アクセスを禁止
    private init() {}

    private let loadingView = UIView(frame: UIScreen.main.bounds)
    private let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    internal func startIndicator() {


        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        activityIndicator.center = loadingView.center
        activityIndicator.color = UIColor.white
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)

        // 現在アクティブな最初のシーンを取得
        if let scene =  UIApplication.shared.connectedScenes.first,
           // シーンのデリゲートをSceneDelegateにキャストして取得
           let delegate = scene.delegate as? SceneDelegate,
           // 表示されている最前面の画面に関連付けられたビューコントローラを取得
           let rootViewController = delegate.window?.rootViewController {
            rootViewController.view.addSubview(loadingView)
        }
    }

    internal func dismissIndicator() {
        loadingView.removeFromSuperview()

    }
}
