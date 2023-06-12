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
    @IBOutlet private weak var inputAccountTextField: UITextField!

    /// メールアドレス入力
    @IBOutlet private weak var inputMailTextField: UITextField!

    /// パスワード入力
    @IBOutlet private weak var inputPasswordTextField: UITextField!

    /// 作成ボタン
    @IBOutlet private weak var createButton: UIButton!

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        inputAccountTextField.delegate = self
        inputMailTextField.delegate = self
        inputPasswordTextField.delegate = self
        setCreatButton()
    }

    // MARK: - func
    /// アカウント作成のメソッド
    /// - 匿名アカウントからメールとパスワードを使っての永続アカウントに引き継ぐ
    /// - 引き継がれたアカウントを使ってユーザー情報をFirestoreに保存する
    @IBAction private func createAccount(_ sender: Any) {
        // 全体をメインスレッドで行うことを明示
        Task { @MainActor in
            // 実行内容
            do {
                // アカウント名、メール、パスワードの入力がnilであれば抜ける
                guard let name = inputAccountTextField.text,
                      let email = inputMailTextField.text,
                      let password = inputPasswordTextField.text else { return }
                /// アカウント作成を実施してuidにユーザーIDを代入
                /// 非同期処理でthrowsキーワード付きのメソッドなので、tryをつけて、完了まで待機するためawait
                let uid =  try await AccountManager.shared.signUp(email: email, password: password)
                // ユーザー情報をFirestoreに保存
                // 非同期処理で完了まで待機させるのでawait、かつthrows付きメソッドなのでtry
                try await FirestoreManager.shared.createUsers(name: name, email: email, password: password, uid: uid)
                // 全てが問題なく完了した場合は前の画面に戻る
                showAlert(tittle: "成功", errorMessage: "ログインしました", completion: { [weak self] in
                    guard let self else { return }
                    self.navigationController?.popViewController(animated: true)
                })
            } catch let error {
                // エラーメッセージを生成
                let errorMessage = FirebaseErrorManager.shared.setErrorMessage(error)
                // アラート表示
                showAlert(tittle: "エラー", errorMessage: errorMessage)
                print(error.localizedDescription)
            }
        }
    }

    /// 作成ボタンの有効化を切り替えるメソッド
    private func setCreatButton() {
        // アカウント名、メール、パスワードの全てが入力されている場合、作成ボタンを有効化
        if inputAccountTextField.text?.isEmpty == false &&
            inputMailTextField.text?.isEmpty == false &&
            inputPasswordTextField.text?.isEmpty == false {
            createButton.isEnabled = true
        } else {
            // 全て入力されていなれば無効化
            createButton.isEnabled = false
        }
    }

    /// エラーメッセージごとにアラートを出す
    func showAlert(tittle: String, errorMessage: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: tittle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }

}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        setCreatButton()
    }
}
