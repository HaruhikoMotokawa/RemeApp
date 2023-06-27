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
        setKeyboardCloseButton()
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
                AlertController.showAlert(tittle: "成功", errorMessage: "ログインしました",completion: { [weak self]  in
                    guard let self else { return }
                    self.navigationController?.popViewController(animated: true)
                })
            } catch let error {
                // エラーメッセージを生成
                let errorMessage = FirebaseErrorManager.shared.setAuthErrorMessage(error)
                // アラート表示
                AlertController.showAlert(tittle: "エラー", errorMessage: errorMessage)
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
            signInButton.setAppearanceForAccountView(backgroundColor: .lightGray)
            signInButton.addShadow()
        } else {
            // 全て入力されていなれば無効化
            signInButton.isEnabled = false
            signInButton.setAppearanceForAccountView(backgroundColor: .white)
        }
    }

    /// キーボードの完了ボタン配置、完了ボタン押してキーボードを非表示に変更するメソッド
    private func setKeyboardCloseButton() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [doneButton]
        inputMailTextField.inputAccessoryView = toolbar
        inputPasswordTextField.inputAccessoryView = toolbar
    }
    /// 閉じるボタンを押した時にキーボードを閉じるメソッド
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        setSignInButton()
    }
}
