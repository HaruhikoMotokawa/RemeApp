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

    // FireStoreのsharedUsersの配列を保持するための変数
//    private var sharedUsers: [String] = []


    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardCloseButton()
        setAddButton()
        Task {
           await setSharedUsers()
        }
    }
    
    // MARK: - func

    /// １番目に登録されている共有者を解除するメソッド
    @IBAction private func deleteFirstSharedUsers(_ sender: Any) {
    }

    /// ２番目に登録されている共有者を解除するメソッド
    @IBAction private func deleteSecondSharedUsers(_ sender: Any) {
    }

    /// ３番目に登録されている共有者を解除するメソッド
    @IBAction private func deleteThirdSharedUsers(_ sender: Any) {
    }

    /// inputUIDTextFieldの入力内容を使って共有者に追加するメソッド
    @IBAction private func addSharedUsers(_ sender: Any) {

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
        // アカウント名、メール、パスワードの全てが入力されている場合、作成ボタンを有効化
        if inputUIDTextField.text?.isEmpty == false {
            addButton.isEnabled = true
        } else {
            // 全て入力されていなれば無効化
            addButton.isEnabled = false
        }
    }

    /// 共有アカウントを表示するメソッド
    func setSharedUsers() async {

            do {
                let uid = AccountManager.shared.getAuthStatus()
                let sharedUsers = try await FirestoreManager.shared.getSharedUsers(uid: uid)
                switch sharedUsers.count {
                    case 1:
                        firstSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: sharedUsers[0])
                        secondSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)
                        thirdSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)
                    case 2:
                        firstSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: sharedUsers[0])
                        secondSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: sharedUsers[1])
                        thirdSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)
                    case 3:
                        firstSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: sharedUsers[0])
                        secondSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: sharedUsers[1])
                        thirdSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: sharedUsers[2])
                    default:
                        firstSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)
                        secondSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)
                        thirdSharedUsersNameLabel.text = try await FirestoreManager.shared.getUserName(uid: nil)
                }
                firstDeleteButton.isEnabled = sharedUsers.count >= 1
                secondDeleteButton.isEnabled = sharedUsers.count >= 2
                thirdDeleteButton.isEnabled = sharedUsers.count >= 3
                print(sharedUsers)


            } catch let error {
                print("\(error)")
            }
        }

}

extension ShareSettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        setAddButton()
    }
}
