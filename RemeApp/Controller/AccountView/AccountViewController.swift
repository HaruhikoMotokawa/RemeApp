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
    @IBOutlet private weak var nameLabel: UILabel!

    /// 登録したメールアドレスを表示
    @IBOutlet private weak var mailLabel: UILabel!

    /// 登録したパスワードを表示
    @IBOutlet private weak var passwordLabel: UILabel!

    /// 登録したユーザーIDを表示
    @IBOutlet private weak var uidLabel: UILabel!

    /// ラベルの表示を切り替えるボタン
    @IBOutlet weak var displaySwitchButton: UIButton!

    /// passwordLabelの表示を切り替えるフラグ
    private var isLabelDisplay: Bool = false

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordLabel.textColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await setUserStatus()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        passwordLabel.textColor = .clear
    }
    // MARK: - func
    /// 非表示になっているパスワードを表示する
    @IBAction private func showPassword(_ sender: Any) {
        passwordLabel.textColor = isLabelDisplay ? .clear : .black

        isLabelDisplay.toggle()
    }

    /// ユーザーIDをクリップボードにコピー
    @IBAction private func copyUserID(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = uidLabel.text
    }

    /// アカウント作成画面にプッシュ遷移
    @IBAction private func goCreateAccountView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreateAccountView", bundle: nil)
        let createAccountVC = storyboard.instantiateViewController(
            withIdentifier: "CreateAccountView") as! CreateAccountViewController
        self.navigationController?.pushViewController(createAccountVC, animated: true)
    }

    /// ログイン画面にプッシュ遷移
    @IBAction private func goSignInView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignInView", bundle: nil)
        let signInVC = storyboard.instantiateViewController(
            withIdentifier: "SignInView") as! SignInViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
    }

    /// ログイン中であればサインアウトし、匿名認証でログイン
    @IBAction private func signOut(_ sender: Any) {
        AccountManager.shared.signOut()
        AccountManager.shared.signInAnonymity()
    }

    /// 共有設定画面にプッシュ遷移
    @IBAction private func goShareSettingsView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ShareSettingsView", bundle: nil)
        let shareSettingsVC = storyboard.instantiateViewController(
            withIdentifier: "ShareSettingsView") as! ShareSettingsViewController
        self.navigationController?.pushViewController(shareSettingsVC, animated: true)
    }

    /// アカウントを削除
    @IBAction private func deleteAccount(_ sender: Any) {
    }

    /// ユーザー情報を表示する非同期処理を内包するメソッド
    private func setUserStatus() async {
        // ログイン中のuidを取得
        let uid = AccountManager.shared.getAuthStatus()
        do {
            // uidを使ってFirestoreからユーザー情報を取得しラベルに表示
            try await FirestoreManager.shared.getUserInfo(uid: uid, nameLabel: nameLabel, mailLabel: mailLabel,
                                                            passwordLabel: passwordLabel, uidLabel: uidLabel)
        } catch {
            print("取得失敗")
            nameLabel.text = "現在読み込めません"
            mailLabel.text = "現在読み込めません"
            passwordLabel.text = "現在読み込めません"
            uidLabel.text = "現在読み込めません"
        }
    }
}
