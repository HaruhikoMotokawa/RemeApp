//
//  TutorialEditMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/05/21.
//

import UIKit

class TutorialEditSalesFloorMapViewController: UIViewController {
    /// 画面を閉じる
    @IBAction private func closeView(_ sender: Any) {
        dismiss(animated: true)
    }
    /// 買い物リスト編集画面の説明ページに戻る
    @IBAction private func goBackView(_ sender: Any) {
        onBackButtonTapped()
    }
    /// 買い物画面の説明ページに進む
    @IBAction private func goNextView(_ sender: Any) {
        onNextButtonTapped()
    }
    /// 戻るボタン、定義はTutorialPageViewControllerに記載
    var onNextButtonTapped: () -> Void = {}
    /// 進むボタン、定義はTutorialPageViewControllerに記載
    var onBackButtonTapped: () -> Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
