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
    @IBOutlet private weak var inputMailTextField: UITextField!

    /// パスワード入力
    @IBOutlet private weak var inputPasswordTextField: UITextField!

    /// ログインボタン
    @IBOutlet private weak var signInButton: UIButton!

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        inputMailTextField.delegate = self
        inputPasswordTextField.delegate = self
        setSignInButton()
    }
    
    // MARK: - func
    /// メールとパスワードでログインするメソッド
    @IBAction private func signIn(_ sender: Any) {
        // ログインの処理
        Task { @MainActor in
            do {
                // メール、パスワードの入力がnilであれば抜ける
                guard let email = inputMailTextField.text,
                      let password = inputPasswordTextField.text else { return }
                // ログイン実施
                try await AccountManager.shared.signIn(email: email, password: password)
                // 終了したら画面を閉じる
                navigationController?.popViewController(animated: true)
            } catch let error {
                // エラーメッセージを生成
                let errorMessage = FirebaseErrorManager.shared.setAuthErrorMessage(error)
                // アラート表示
                showAlert(errorMessage: errorMessage)
                print(error.localizedDescription)
            }
        }
    }

    /// ログインボタンの有効化を切り替えるメソッド
    private func setSignInButton() {
        // メール、パスワードの全てが入力されている場合、作成ボタンを有効化
        if inputMailTextField.text?.isEmpty == false &&
            inputPasswordTextField.text?.isEmpty == false {
            signInButton.isEnabled = true
        } else {
            // 全て入力されていなれば無効化
            signInButton.isEnabled = false
        }
    }

    /// エラーメッセージごとにアラートを出す
    func showAlert(errorMessage: String) {
        let alert = UIAlertController(title: "エラー", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        setSignInButton()
    }
}
