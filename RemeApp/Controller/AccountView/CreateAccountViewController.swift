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

    /// 作成ボタン
    @IBOutlet weak var createButton: UIButton!

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        inputAccountTextField.delegate = self
        inputMailTextField.delegate = self
        inputPasswordTextField.delegate = self
        setCreatButton()
    }

    // MARK: - func

    @IBAction func createAccount(_ sender: Any) {
        guard let name = inputAccountTextField.text,
              let email = inputMailTextField.text,
              let password = inputPasswordTextField.text else { return }

        // 作成の処理
        AccountManager.shared.signUp(name: name, email: email, password: password, viewController: self)

    }

    func setCreatButton() {
        if inputAccountTextField.text?.isEmpty == false &&
            inputMailTextField.text?.isEmpty == false &&
            inputPasswordTextField.text?.isEmpty == false {
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
    }

}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        setCreatButton()
    }
}
