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
    @IBOutlet weak var firstSharedUsersNameLabel: UILabel!

    ///　２番目に登録されている共有者名を表示するラベル
    @IBOutlet weak var secondSharedUsersNameLabel: UILabel!

    ///　３番目に登録されている共有者名を表示するラベル
    @IBOutlet weak var thirdSharedUsersNameLabel: UILabel!

    /// １番目に登録されている共有者を解除するボタン
    @IBOutlet weak var firstDeleteButton: UIButton!

    /// ２番目に登録されている共有者を解除するボタン
    @IBOutlet weak var secondDeleteButton: UIButton!

    /// ３番目に登録されている共有者を解除するボタン
    @IBOutlet weak var thirdDeleteButton: UIButton!

    /// 共有するユーザーのuidを入力するtextField
    @IBOutlet weak var inputUIDTextField: UITextField!

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - func

    /// １番目に登録されている共有者を解除するメソッド
    @IBAction func deleteFirstSharedUsers(_ sender: Any) {
    }

    /// ２番目に登録されている共有者を解除するメソッド
    @IBAction func deleteSecondSharedUsers(_ sender: Any) {
    }

    /// ３番目に登録されている共有者を解除するメソッド
    @IBAction func deleteThirdSharedUsers(_ sender: Any) {
    }

    /// inputUIDTextFieldの入力内容を使って共有者に追加するメソッド
    @IBAction func addSharedUsers(_ sender: Any) {
    }

}
