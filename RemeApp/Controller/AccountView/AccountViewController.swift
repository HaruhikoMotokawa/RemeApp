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
    @IBOutlet private weak var displaySwitchButton: UIButton!

    /// uidをコピーするボタン
    @IBOutlet private weak var uidCopyButton: UIButton!

    /// ログアウトボタン
    @IBOutlet private weak var signOutButton: UIButton!

    /// 共有設定ボタン
    @IBOutlet private weak var sherdUsersSettingsButton: UIButton!

    /// アカウント削除ボタン
    @IBOutlet private weak var accountDeleteButton: UIButton!

    /// passwordLabelの表示を切り替えるフラグ
    private var isLabelDisplay: Bool = false

    /// ユーザーが作成した買い物データを格納する配列
    private var myShoppingItemList: [ShoppingItemModel] = []

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordLabel.textColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await setUserInfo()
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
        displaySwitchButton.setTitle(isLabelDisplay ? "表示" : "非表示", for: .normal)
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
        let alert = UIAlertController(title: "ログアウト",
                                      message: "アカウントに紐づく情報は全て表示されなくなりますがよろしいですか？",
                                      preferredStyle: .actionSheet)
        // キャンセル
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        // サインアウトの実行
        let signOutAction = UIAlertAction(title: "ログアウト", style: .destructive, handler: { [weak self] (action) in
            Task { @MainActor in
                do {
                    guard let self else { return }
                    // ログアウト
                    try AccountManager.shared.signOut()
                    // 匿名認証でログイン
                    try await AccountManager.shared.signInAnonymity()
                    // 現在のuidを取得
                    let uid = AccountManager.shared.getAuthStatus()
                    // 匿名認証用のusersデータ作成
                    try await FirestoreManager.shared.createUsers(
                        name: "",
                        email: "",
                        password: "",
                        uid: uid)
                    // 各ラベルのユーザー情報を更新
                    await self.setUserInfo()
                } catch let error {
                    // エラーメッセージを生成
                    let errorMessage = FirebaseErrorManager.shared.setAuthErrorMessage(error)
                    // アラート表示
                    AlertController.showAlert(tittle: "エラー", errorMessage: errorMessage)
                    print(error.localizedDescription)
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(signOutAction)
        present(alert, animated: true)
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
        let alert = UIAlertController(
            title: "アカウント削除", message: "アカウントに関わる全てのデータが削除されます", preferredStyle: .actionSheet)
        // キャンセル
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        // 削除の実行
        let deleteAction = UIAlertAction(title: "削除", style: .destructive, handler: { [weak self] (action) in
            Task { @MainActor in
                do {
                    guard let self else { return }
                    // ユーザーのUidを取得
                    let deleteUid = AccountManager.shared.getAuthStatus()
                    // ユーザーが作成したshoppingItemのデータ削除
                    // 現在作成済みの自分の買い物リストを取得
                    self.myShoppingItemList = try await FirestoreManager.shared.getMyShoppingItemList(uid: deleteUid)
                    self.myShoppingItemList.forEach { taget in
                        guard let id = taget.id else { return }
                        StorageManager.shared.deletePhoto(photoURL: taget.photoURL) { error in }
                        FirestoreManager.shared.deleteItem(id: id) { error in
                            if error != nil {
                                print("削除に失敗")
                                let errorMassage = FirebaseErrorManager.shared.setErrorMessage(error)
                                AlertController.showAlert(tittle: "エラー", errorMessage: errorMassage)
                                self.myShoppingItemList = []
                                return
                            }
                            self.myShoppingItemList = []
                        }
                    }

                    // ユーザーが作成したmapSettingsの削除

                    // ユーザーが作成したCustomSalesFloorの削除

                    // ユーザー情報の削除
                    try await FirestoreManager.shared.deleteUsersDocument(uid: deleteUid)
                    // アカウントの削除
                    try await AccountManager.shared.deleteAccount()
                    // 匿名認証でログイン
                    try await AccountManager.shared.signInAnonymity()
                    // 現在のuidを取得
                    let uid = AccountManager.shared.getAuthStatus()
                    // 匿名認証用のusersデータ作成
                    try await FirestoreManager.shared.createUsers(
                        name: "",
                        email: "",
                        password: "",
                        uid: uid)
                    // 各ラベルのユーザー情報を更新
                    await self.setUserInfo()
                    // アラート
                    AlertController.showAlert(tittle: "完了", errorMessage: "アカウントを削除しました")

                } catch let error {
                    // エラーメッセージを生成
                    let errorMessage = FirebaseErrorManager.shared.setErrorMessage(error)
                    // アラート表示
                    AlertController.showAlert(tittle: "エラー", errorMessage: errorMessage)
                    print(error.localizedDescription)
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }

    /// ユーザー情報を表示する非同期処理を内包するメソッド
    private func setUserInfo() async {
        Task { @MainActor in
            // ログイン中のuidを取得
            let uid = AccountManager.shared.getAuthStatus()
            do {
                // uidを使ってFirestoreからユーザー情報を取得しラベルに表示
                let userInfo = try await FirestoreManager.shared.getUserInfo(uid: uid)
                if userInfo?.name != "" {
                    nameLabel.text = userInfo?.name
                    mailLabel.text = userInfo?.email
                    passwordLabel.text = userInfo?.password
                    uidLabel.text = userInfo?.id
                    displaySwitchButton.isEnabled = true
                    uidCopyButton.isEnabled = true
                    signOutButton.isEnabled = true
                    sherdUsersSettingsButton.isEnabled = true
                    accountDeleteButton.isEnabled = true
                } else {
                    nameLabel.text = "匿名"
                    mailLabel.text = "登録なし"
                    passwordLabel.text = ""
                    uidLabel.text = "登録なし"
                    displaySwitchButton.isEnabled = false
                    uidCopyButton.isEnabled = false
                    signOutButton.isEnabled = false
                    sherdUsersSettingsButton.isEnabled = false
                    accountDeleteButton.isEnabled = false
                }
            } catch {
                print("取得失敗")
                nameLabel.text = "エラーにより読み込めません"
                mailLabel.text = "エラーにより読み込めません"
                passwordLabel.text = "エラーにより読み込めません"
                uidLabel.text = "エラーにより読み込めません"
            }
        }
    }

}
