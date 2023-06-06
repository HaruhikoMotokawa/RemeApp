//
//  CreateAccountViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/06.
//

import UIKit

/// アカウント新規作成画面
class CreateAccountViewController: UIViewController {

    // MARK: - property

    /// アカウント名入力
    @IBOutlet weak var inputAccountTextField: UITextField!

    /// メールアドレス入力
    @IBOutlet weak var inputMailTextField: UITextField!

    /// パスワード入力
    @IBOutlet weak var inputPasswordTextField: UITextField!

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - func

    @IBAction func createAccount(_ sender: Any) {
        // 作成の処理

        // 終了したら画面を閉じる
        navigationController?.popViewController(animated: true)
    }


}
