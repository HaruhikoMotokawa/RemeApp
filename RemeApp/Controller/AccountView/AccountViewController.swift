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
    /// アカウント作成ボタン
    @IBOutlet weak var createAccountButton: UIButton!
    /// ログインボタン
    @IBOutlet weak var signInButton: UIButton!
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
    /// 共有相手が作成した買い物データを格納する配列
    private var otherShoppingItemList: [ShoppingItemModel] = []
    /// ユーザー情報のリスト
    private var usersList:[UserDataModel] = []


    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNetWorkObserver()
        passwordLabel.textColor = .clear
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
        // オフラインだったらアラート出して終了
        guard NetworkMonitor.shared.isConnected else {
            AlertController.showAlert(tittle: "エラー", errorMessage: AuthError.networkError.title)
            return
        }
        let storyboard = UIStoryboard(name: "CreateAccountView", bundle: nil)
        let createAccountVC = storyboard.instantiateViewController(
            withIdentifier: "CreateAccountView") as! CreateAccountViewController
        createAccountVC.delegate = self
        self.navigationController?.pushViewController(createAccountVC, animated: true)
    }

    /// ログイン画面にプッシュ遷移
    @IBAction private func goSignInView(_ sender: Any) {
        // オフラインだったらアラート出して終了
        guard NetworkMonitor.shared.isConnected else {
            AlertController.showAlert(tittle: "エラー", errorMessage: AuthError.networkError.title)
            return
        }
        let storyboard = UIStoryboard(name: "SignInView", bundle: nil)
        let signInVC = storyboard.instantiateViewController(
            withIdentifier: "SignInView") as! SignInViewController
        signInVC.delegate = self
        self.navigationController?.pushViewController(signInVC, animated: true)
    }

    /// ログイン中であればサインアウトし、匿名認証でログイン
    @IBAction private func signOut(_ sender: Any) {
        // オフラインだったらアラート出して終了
        guard NetworkMonitor.shared.isConnected else {
            AlertController.showAlert(tittle: "エラー", errorMessage: AuthError.networkError.title)
            return
        }
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
                    // オフラインだったらアラート出して終了
                    guard NetworkMonitor.shared.isConnected else {
                        AlertController.showAlert(tittle: "エラー", errorMessage: AuthError.networkError.title)
                        return
                    }
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
        guard NetworkMonitor.shared.isConnected else {
            AlertController.showAlert(tittle: "エラー", errorMessage: AuthError.networkError.title)
            return
        }
        let storyboard = UIStoryboard(name: "ShareSettingsView", bundle: nil)
        let shareSettingsVC = storyboard.instantiateViewController(
            withIdentifier: "ShareSettingsView") as! ShareSettingsViewController
        self.navigationController?.pushViewController(shareSettingsVC, animated: true)
    }

    /// アカウントを削除
    @IBAction private func deleteAccount(_ sender: Any) {
        // オフラインだったらアラート出して終了
        guard NetworkMonitor.shared.isConnected else {
            AlertController.showAlert(tittle: "エラー", errorMessage: AuthError.networkError.title)
            return
        }

        let alert = UIAlertController(
            title: "アカウント削除", message: "アカウントに関わる全てのデータが削除されます", preferredStyle: .actionSheet)
        // キャンセル
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        // 削除の実行
        let deleteAction = UIAlertAction(title: "削除", style: .destructive, handler: { [weak self] (action) in
            Task { @MainActor in
                do {
                    guard let self else { return }
                    // オフラインだったらアラート出して終了
                    guard NetworkMonitor.shared.isConnected else {
                        AlertController.showAlert(tittle: "エラー", errorMessage: AuthError.networkError.title)
                        return
                    }
                    // ユーザーのUidを取得
                    let deleteUid = AccountManager.shared.getAuthStatus()
                    // 自身が作成した買い物リストを削除
                    try await self.deleteMyShoppingList(uid: deleteUid)
                    // アカウント削除時に自身を共有先に指定したユーザーのユーザー情報から、自身のuidを削除する
                    try await self.deleteMyUidFromUsers(deleteUid: deleteUid)
                    // アカウント削除時に自身を共有先に指定したユーザーの買い物情報から、自身のuidを削除する
                    try await self.deleteMyUidFromOtherShoppingItem(deleteUid: deleteUid)
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

    /// ネットワーク関連の監視の登録
    private func setNetWorkObserver() {
        print("👀オブザーバーセット")
        // NotificationCenterに通知を登録する
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatusDidChange),
                                               name: .networkStatusDidChange, object: nil)
    }

    /// オフライン時の処理
    @objc func handleNetworkStatusDidChange() {
        DispatchQueue.main.async { [weak self] in
            print("👨‍💻ハンドラー開始")
            guard let self else { return }
            // オンラインなら通常通りにユザー情報とボタンを設定する
            if NetworkMonitor.shared.isConnected {
                Task {
                    print("🔥オンラインや！")
                    await self.setUserInfo()
                }
            } else {
                print("😮‍💨せやかてオフライン")
                // オフラインで全てのボタンを無効化
                self.setAllButtonEnabled()
            }
        }
    }

    /// 全てのボタンを無効化して、背景色を白にする
    private func setAllButtonEnabled() {
        // この画面の全てのbuttonを収納
        let buttons = [displaySwitchButton, uidCopyButton, createAccountButton, signInButton, signOutButton,
                       sherdUsersSettingsButton, accountDeleteButton]
        // 全てのボタンにアクセス、無効化して背景色を白にする
        buttons.forEach { button in
            button?.isEnabled = false
            button?.setAppearanceForAccountView(backgroundColor: .white)
        }
    }

    /// ユーザーが作成したshoppingItemのデータ削除
    private func deleteMyShoppingList(uid: String) async throws {
        // 現在作成済みの自分の買い物リストを取得
        myShoppingItemList = try await FirestoreManager.shared.getMyShoppingItemList(uid: uid)
        // 現在作成済みの自分の買い物リストがなかった場合は抜ける
        guard !myShoppingItemList.isEmpty else { return }
        // myShoppingItemListの全てにアクセス
        myShoppingItemList.forEach { target in
            guard let id = target.id else { return }
            // 写真データをFirebaseStorageから削除
            StorageManager.shared.deletePhoto(photoURL: target.photoURL) { error in }
            // Firestoreから買い物リストを削除
            FirestoreManager.shared.deleteItem(id: id) { [weak self] error in
                guard let self else { return }
                if error != nil {
                    print("削除に失敗")
                    let errorMassage = FirebaseErrorManager.shared.setErrorMessage(error)
                    AlertController.showAlert(tittle: "エラー", errorMessage: errorMassage)
                    self.myShoppingItemList = []
                    return
                }
                self.myShoppingItemList = [] // 配列を空に戻す
            }
        }
    }

    /// アカウント削除時に自身を共有先に指定したユーザーの買い物情報から、自身のuidを削除する
    private func deleteMyUidFromOtherShoppingItem(deleteUid: String) async throws {
        // 共有先に自身を登録している他のユーザーの買い物リストを取得
        otherShoppingItemList = try await FirestoreManager.shared.getOtherShoppingItemList(uid: deleteUid)
        // もしも共有先に自身を登録している他のユーザーの買い物リストがなかった場合はこのメソッドを終了する
        guard !otherShoppingItemList.isEmpty else { return }
        // 買い物リストから削除対象のuidを削除
        let updateItemList = otherShoppingItemList.map { item -> ShoppingItemModel in
            var newItem = item
            if let deleteIndex = newItem.sharedUsers.firstIndex(of: deleteUid) {
                newItem.sharedUsers.remove(at: deleteIndex)
            }
            return newItem
        }
        // 買い物リストの全てのsharedUsersに削除後のデータをFirestoreに上書きする
        for item in updateItemList {
            try await FirestoreManager.shared.upDateItemForSharedUsers(
                documentID: item.id, sharedUsersUid: item.sharedUsers)
        }
        otherShoppingItemList = [] // 配列を空に戻す
    }

    /// アカウント削除時に自身を共有先に指定したユーザーのユーザー情報から、自身のuidを削除する
    private func deleteMyUidFromUsers(deleteUid: String) async throws {
        // 共有先に自身を登録している他のユーザーのユーザーリストを取得
        usersList = try await FirestoreManager.shared.getUsersList(deleteUid: deleteUid)
        // もしも共有先に自身を登録している他のユーザーのユーザーリストがなかった場合はこのメソッドを終了する
        guard !usersList.isEmpty else { return }
        // ユーザーリストから削除対象のuidを削除
        let updateUsersList = usersList.map { users -> UserDataModel in
            var newUsers = users
            if let deleteIndex = newUsers.sharedUsers.firstIndex(of: deleteUid) {
                newUsers.sharedUsers.remove(at: deleteIndex)
            }
            return newUsers
        }
        // ユーザーリストの全てのsharedUsersに削除後のデータをFirestoreに上書きする
        for user in updateUsersList {
            try await FirestoreManager.shared.upData(uid: user.id, shardUsers: user.sharedUsers)
        }
        usersList = []  // 配列を空に戻す
    }

    /// ユーザー情報を表示する非同期処理を内包するメソッド
    private func setUserInfo() async {
        print("🟥setUserInfoが呼び出されたよ")
        Task { @MainActor in

            // ログイン中のuidを取得
            let uid = AccountManager.shared.getAuthStatus()
            do {
                // uidを使ってFirestoreからユーザー情報を取得しラベルに表示
                let userInfo = try await FirestoreManager.shared.getUserInfo(uid: uid)
                print("🟦userInfo: \(String(describing: userInfo))")
                // サインインしているならnameはからではない
                if userInfo?.name != "" {
                    print("🔸ラベルを変更開始が呼び出されたよ")
                    nameLabel.text = userInfo?.name
                    mailLabel.text = userInfo?.email
                    passwordLabel.text = userInfo?.password
                    uidLabel.text = userInfo?.id
                    // アカウントでサインインの場合
                    setButtonsWithSignIn()
                } else {
                    // 匿名認証であればnameは""で登録されている
                    nameLabel.text = "匿名"
                    mailLabel.text = "登録なし"
                    passwordLabel.text = ""
                    uidLabel.text = "登録なし"
                    // 匿名認証での場合
                    setButtonsWithAnonymous()
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

    /// 匿名認証でログインしている状態でのボタン設定、合計７個
    /// - アカウント作成とログインボタンを有効化
    /// - パスワード表示、uidコピー、ログアウト、共有設定、アカウント削除を無効化
    /// - ボタンの基本設定
    /// - バックグラウンドカラー
    /// - 影の有無
    private func setButtonsWithAnonymous() {
        displaySwitchButton.setAppearanceForAccountView(backgroundColor: .white)
        displaySwitchButton.isEnabled = false

        uidCopyButton.setAppearanceForAccountView(backgroundColor: .white)
        uidCopyButton.isEnabled = false

        createAccountButton.setAppearanceForAccountView(backgroundColor: .lightGray)
        createAccountButton.addShadow()
        createAccountButton.isEnabled = true

        signInButton.setAppearanceForAccountView(backgroundColor: .lightGray)
        signInButton.addShadow()
        signInButton.isEnabled = true

        signOutButton.setAppearanceForAccountView(backgroundColor: .white)
        signOutButton.isEnabled = false

        sherdUsersSettingsButton.setAppearanceForAccountView(backgroundColor: .white)
        sherdUsersSettingsButton.isEnabled = false

        accountDeleteButton.setAppearanceForAccountView(backgroundColor: .white)
        accountDeleteButton.isEnabled = false
    }

    /// 作成したアカウントでログインしている状態でのボタン設定、合計７個
    /// - パスワード表示、uidコピー、ログアウト、共有設定、アカウント削除を有効化
    /// - アカウント作成とログインボタンを無効化
    /// - ボタンの基本設定
    /// - バックグラウンドカラー
    /// - 影の有無
    private func setButtonsWithSignIn() {
        displaySwitchButton.setAppearanceForAccountView(backgroundColor: .lightGray)
        displaySwitchButton.addShadow()
        displaySwitchButton.isEnabled = true

        uidCopyButton.setAppearanceForAccountView(backgroundColor: .lightGray)
        uidCopyButton.addShadow()
        uidCopyButton.isEnabled = true

        createAccountButton.setAppearanceForAccountView(backgroundColor: .white)
        createAccountButton.isEnabled = false

        signInButton.setAppearanceForAccountView(backgroundColor: .white)
        signInButton.isEnabled = false

        signOutButton.setAppearanceForAccountView(backgroundColor: .lightGray)
        signOutButton.addShadow()
        signOutButton.isEnabled = true

        sherdUsersSettingsButton.setAppearanceForAccountView(backgroundColor: .lightGray)
        sherdUsersSettingsButton.addShadow()
        sherdUsersSettingsButton.isEnabled = true

        accountDeleteButton.setAppearanceForAccountView(backgroundColor: .lightGray)
        accountDeleteButton.addShadow()
        accountDeleteButton.isEnabled = true
    }

}


extension AccountViewController: CreateAccountViewControllerDelegate {
    func updateUserInfoFromCreateAccountView() async {
        await setUserInfo()
    }
}

extension AccountViewController: SignInViewControllerDelegate {
    func updateUserInfoFromSignInView() async {
        await setUserInfo()
    }
}
