//
//  AccountViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/06.
//

import UIKit

/// アカウント画面
class AccountViewController: UIViewController {

    // MARK: -property
    /// 登録したアカウント名を表示
    @IBOutlet weak var nameLabel: UILabel!

    /// 登録したメールアドレスを表示
    @IBOutlet weak var mailLabel: UILabel!

    /// 登録したパスワードを表示
    @IBOutlet weak var passwordLabel: UILabel!

    /// 登録したユーザーIDを表示
    @IBOutlet weak var userIDLabel: UILabel!

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setPasswordLabel()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setPasswordLabel()
    }
    // MARK: - func
    /// 非表示になっているパスワードを表示する
    @IBAction func showPassword(_ sender: Any) {
        passwordLabel.text = "ログインしていません"
        passwordLabel.textColor = .black
    }

    /// ユーザーIDをクリップボードにコピー
    @IBAction func copyUserID(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = userIDLabel.text
    }

    /// アカウント作成画面にプッシュ遷移
    @IBAction func goCreateAccountView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreateAccountView", bundle: nil)
        let createAccountVC = storyboard.instantiateViewController(
            withIdentifier: "CreateAccountView") as! CreateAccountViewController
        self.navigationController?.pushViewController(createAccountVC, animated: true)
    }

    /// ログイン画面にプッシュ遷移
    @IBAction func goSignInView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignInView", bundle: nil)
        let signInVC = storyboard.instantiateViewController(
            withIdentifier: "SignInView") as! SignInViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
    }

    /// ログイン中であればサインアウト
    @IBAction func signOut(_ sender: Any) {
        AccountManager.shared.signInAnonymity()
    }

    /// 共有設定画面にプッシュ遷移
    @IBAction func goShareSettingsView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ShareSettingsView", bundle: nil)
        let shareSettingsVC = storyboard.instantiateViewController(
            withIdentifier: "ShareSettingsView") as! ShareSettingsViewController
        self.navigationController?.pushViewController(shareSettingsVC, animated: true)
    }

    /// アカウントを削除
    @IBAction func deleteAccount(_ sender: Any) {
    }

    func setPasswordLabel() {
        passwordLabel.text = "非表示中"
        passwordLabel.textColor = .lightGray
    }
}
