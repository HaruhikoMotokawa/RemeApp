//
//  SignInViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/06.
//

import UIKit

/// ログイン画面
class SignInViewController: UIViewController {

    // MARK: - property

    /// メールアドレス入力
    @IBOutlet weak var inputMailTextField: UITextField!

    /// パスワード入力
    @IBOutlet weak var inputPasswordTextField: UITextField!

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    // MARK: - func

    @IBAction func signIn(_ sender: Any) {
        // ログインの処理

        // 終了したら画面を閉じる
        navigationController?.popViewController(animated: true)
    }

}
