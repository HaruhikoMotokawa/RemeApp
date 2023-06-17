//
//  AlertController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/17.
//

import UIKit

class AlertController {

    /// 他のクラスで使用できるようにstaticで定義
    static let shared = AlertController()
    /// 外部アクセスを禁止
    private init() {}

    /// エラーメッセージごとにアラートを出す
    func showAlert(viewController:UIViewController,tittle: String, errorMessage: String,completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: tittle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  _ in
            completion?()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
