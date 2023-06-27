//
//  ShareSettingsViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/06.
//

import UIKit

/// 共有設定画面
class ShareSettingsViewController: UIViewController {

    // MARK: - property

    ///　１番目に登録されている共有者名を表示するラベル
    @IBOutlet private weak var firstSharedUsersNameLabel: UILabel!

    ///　２番目に登録されている共有者名を表示するラベル
    @IBOutlet private weak var secondSharedUsersNameLabel: UILabel!

    ///　３番目に登録されている共有者名を表示するラベル
    @IBOutlet private weak var thirdSharedUsersNameLabel: UILabel!

    /// １番目に登録されている共有者を解除するボタン
    @IBOutlet private weak var firstDeleteButton: UIButton!

    /// ２番目に登録されている共有者を解除するボタン
    @IBOutlet private weak var secondDeleteButton: UIButton!

    /// ３番目に登録されている共有者を解除するボタン
    @IBOutlet private weak var thirdDeleteButton: UIButton!

    /// 共有するユーザーのuidを入力するtextField
    @IBOutlet private weak var inputUIDTextField: UITextField!

    /// 追加ボタン
    @IBOutlet private weak var addButton: UIButton!
    /// ユーザーが作成した買い物データを格納する配列
    private var myShoppingItemList: [ShoppingItemModel] = []
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        inputUIDTextField.delegate = self
        setKeyboardCloseButton()
        setAddButton()
        Task {
            await setSharedUsers()
        }
    }

    
    // MARK: - func

    /// １番目に登録されている共有者を解除するメソッド
    @IBAction private func deleteFirstSharedUsers(_ sender: Any) {
        Task { @MainActor in
            await deleteSharedUsers(deleteNumber:SharedUsers.one.arrayNumber)
            await setSharedUsers()
        }
    }

    /// ２番目に登録されている共有者を解除するメソッド
    @IBAction private func deleteSecondSharedUsers(_ sender: Any) {
        Task { @MainActor in
            await deleteSharedUsers(deleteNumber:SharedUsers.two.arrayNumber)
            await setSharedUsers()
        }
    }

    /// ３番目に登録されている共有者を解除するメソッド
    @IBAction private func deleteThirdSharedUsers(_ sender: Any) {
        Task { @MainActor in
            await deleteSharedUsers(deleteNumber:SharedUsers.three.arrayNumber)
            await setSharedUsers()
        }
    }

    /// inputUIDTextFieldの入力内容を使って共有者に追加するメソッド
    @IBAction private func addSharedUsers(_ sender: Any) {
        Task { @MainActor in
            do {
                // 入力された値がないかnilチェック
                guard let inputUid = inputUIDTextField.text else { return }
                // ユーザーのuidを取得
                let uid = AccountManager.shared.getAuthStatus()
                // 入力したuidのチェックと追加処理
                try await FirestoreManager.shared.addSharedUsers(inputUid: inputUid, uid: uid)
                // 現在作成済みの自分の買い物リストを取得
                myShoppingItemList = try await FirestoreManager.shared.getMyShoppingItemList(uid: uid)
                // 取得した自分の買い物リストの全てにinputUidを追加する
                let updateItemList = myShoppingItemList.map { item -> ShoppingItemModel in
                    var newItem = item
                    newItem.sharedUsers.append(inputUid)
                    return newItem
                }
                // 取得した買い物リストの全てのsharedUsersにinputUidを追加
                for item in updateItemList {
                    try await FirestoreManager.shared.upDateItemForSharedUsers(
                        documentID: item.id, sharedUsersUid: item.sharedUsers)
                }
                // 共有者のラベルを更新
                await setSharedUsers()
                // uidの入力欄を空白に戻す
                inputUIDTextField.text = ""
                setAddButton()
                // 完了のアラート
                AlertController.showAlert(tittle: "完了", errorMessage: "登録しました")
            } catch FirestoreError.notFound {
                AlertController.showAlert(tittle: "エラー", errorMessage: FirestoreError.notFound.title)
            } catch let error {
                // 失敗のアラート
                print("追加失敗だよー")
                let errorMessage = FirebaseErrorManager.shared.setErrorMessage(error)
                AlertController.showAlert(tittle: "エラー", errorMessage: errorMessage)
            }
        }
    }

    /// キーボードの完了ボタン配置、完了ボタン押してキーボードを非表示に変更するメソッド
    private func setKeyboardCloseButton() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [doneButton]
        inputUIDTextField.inputAccessoryView = toolbar
    }
    /// 閉じるボタンを押した時にキーボードを閉じるメソッド
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }

    /// 作成ボタンの有効化を切り替えるメソッド
    private func setAddButton() {
        // uidが入力されている場合、追加ボタンを有効化
        if inputUIDTextField.text?.isEmpty == false {
            addButton.isEnabled = true
            addButton.setAppearanceForAccountView(backgroundColor: .lightGray)
            addButton.addShadow()
        } else {
            // 全て入力されていなれば無効化
            addButton.isEnabled = false
            addButton.setAppearanceForAccountView(backgroundColor: .white)
        }
    }

    /// 共有アカウントを表示するメソッド
    private func setSharedUsers() async {
        do {
            // ログイン中のユーザーのuidを取得
            let uid = AccountManager.shared.getAuthStatus()
            // 共有者のuidを[String]型で取得
            let sharedUsers = try await FirestoreManager.shared.getSharedUsers(uid: uid)
            // 共有者のuidから登録されたアカウント名を取得して表示する。共有者の登録数によって処理を切り替える
            switch sharedUsers.count {
                case SharedUsers.one.numberOfRegistrations:
                    firstSharedUsersNameLabel.text = try await FirestoreManager.shared
                        .getUserName(uid: sharedUsers[SharedUsers.one.arrayNumber])
                    secondSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)
                    thirdSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)

                case SharedUsers.two.numberOfRegistrations:
                    firstSharedUsersNameLabel.text = try await FirestoreManager.shared
                        .getUserName(uid: sharedUsers[SharedUsers.one.arrayNumber])
                    secondSharedUsersNameLabel.text = try await FirestoreManager.shared
                        .getUserName(uid: sharedUsers[SharedUsers.two.arrayNumber])
                    thirdSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)

                case SharedUsers.three.numberOfRegistrations:
                    firstSharedUsersNameLabel.text = try await FirestoreManager.shared
                        .getUserName(uid: sharedUsers[SharedUsers.one.arrayNumber])
                    secondSharedUsersNameLabel.text = try await FirestoreManager.shared
                        .getUserName(uid: sharedUsers[SharedUsers.two.arrayNumber])
                    thirdSharedUsersNameLabel.text = try await FirestoreManager.shared
                        .getUserName(uid: sharedUsers[SharedUsers.three.arrayNumber])
                default:
                    firstSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)
                    secondSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)
                    thirdSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)
            }
            // 共有者の登録があるボタンだけ有効化
            firstDeleteButton.isEnabled = sharedUsers.count >= SharedUsers.one.numberOfRegistrations
            secondDeleteButton.isEnabled = sharedUsers.count >= SharedUsers.two.numberOfRegistrations
            thirdDeleteButton.isEnabled = sharedUsers.count >= SharedUsers.three.numberOfRegistrations
            // 登録者数によって見た目を変更
            setDeleteButton(count: sharedUsers.count)
            print(sharedUsers)
        } catch let error {
            print("\(error)")
        }
    }

    /// 共有者の登録を解除する
    private func deleteSharedUsers(deleteNumber: Int) async {
        let alert = UIAlertController(title: "共有登録の解除",
                                      message: "共有を解除すると相手に買い物リストが表示されなくなります。",
                                      preferredStyle: .actionSheet)
        // キャンセル
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        // 削除の実行
        let deleteAction = UIAlertAction(title: "登録解除", style: .destructive, handler: { [weak self] (action) in
            Task { @MainActor in
                do {
                    guard let self else { return }
                    // 現在のログインしているユーザーのuidを取得
                    let uid = AccountManager.shared.getAuthStatus()
                    // usersコレクションのsharedUsersフィールドの値を取得
                    var sharedUsers = try await FirestoreManager.shared.getSharedUsers(uid: uid)
                    // sharedUsersから対象の値を削除
                    sharedUsers.remove(at: deleteNumber)
                    // sharedUsersを上書き
                    try await FirestoreManager.shared.upData(uid: uid, shardUsers: sharedUsers)
                    // 現在作成済みの自分の買い物リストを取得
                    self.myShoppingItemList = try await FirestoreManager.shared.getMyShoppingItemList(uid: uid)
                    // 買い物リストから削除対象のuidを削除
                    let updateItemList = self.myShoppingItemList.map { item -> ShoppingItemModel in
                        var newItem = item
                        newItem.sharedUsers.remove(at: deleteNumber)
                        return newItem
                    }
                    // 買い物リストの全てのsharedUsersに削除後のデータをFirestoreに上書きする
                    for item in updateItemList {
                        try await FirestoreManager.shared.upDateItemForSharedUsers(
                            documentID: item.id, sharedUsersUid: item.sharedUsers)
                    }
                    // ラベルの更新
                    await self.setSharedUsers()
                    AlertController.showAlert(tittle: "完了", errorMessage: "共有登録を解除しました")
                } catch let error {
                    print("エラー")
                    let errorMessage = FirebaseErrorManager.shared.setErrorMessage(error)
                    AlertController.showAlert(tittle: "エラー", errorMessage: errorMessage)
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }

    /// 共有登録者数によってボタンの見た目を変える
    private func setDeleteButton(count: Int) {
        if count >= 0 {
            firstDeleteButton.setAppearanceForAccountView(backgroundColor: .white)
            secondDeleteButton.setAppearanceForAccountView(backgroundColor: .white)
            thirdDeleteButton.setAppearanceForAccountView(backgroundColor: .white)
        }

        if count >= SharedUsers.one.numberOfRegistrations {
            firstDeleteButton.setAppearanceForAccountView(backgroundColor: .lightGray)
            firstDeleteButton.addShadow()
        }

        if count >= SharedUsers.two.numberOfRegistrations {
            secondDeleteButton.setAppearanceForAccountView(backgroundColor: .lightGray)
            secondDeleteButton.addShadow()
        }

        if count >= SharedUsers.three.numberOfRegistrations {
            thirdDeleteButton.setAppearanceForAccountView(backgroundColor: .lightGray)
            thirdDeleteButton.addShadow()
        }

    }

}

extension ShareSettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        setAddButton()
    }
}

/// 共有者の番号管理
enum SharedUsers {
    case one
    case two
    case three

    /// 共有者の配列番号
    var arrayNumber: Int {
        switch self {
            case .one:
                return 0
            case .two:
                return 1
            case .three:
                return 2
        }
    }

    /// 共有者の登録人数
    var numberOfRegistrations:Int {
        switch self {
            case .one:
                return 1
            case .two:
                return 2
            case .three:
                return 3
        }
    }
}
