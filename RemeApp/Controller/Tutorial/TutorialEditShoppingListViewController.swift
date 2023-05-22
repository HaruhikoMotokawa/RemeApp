//
//  TutorialEditShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/05/20.
//

import UIKit

class TutorialEditShoppingListViewController: UIViewController {
    /// 画面を閉じる
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true)
    }
    /// 買い物画面の説明ページに進む
    @IBAction func goNextView(_ sender: Any) {
        onNextButtonTapped()
    }
    /// 進むボタン、定義はTutorialPageViewControllerに記載
    var onNextButtonTapped: () -> Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
