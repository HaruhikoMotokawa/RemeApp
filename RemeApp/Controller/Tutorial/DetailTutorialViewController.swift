//
//  DetailTutorialViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/03.
//

import UIKit

/// チュートリアル画像を表示を管理する
class DetailTutorialViewController: UIViewController {

    /// 画面上部の閉じるボタン
    @IBOutlet private weak var topCloseButton: UIButton!
    /// チュートリアルの画像を表示するimgeView
    @IBOutlet private weak var tutorialImageView: UIImageView!
    /// 画面下部の閉じるボタン
    @IBOutlet private weak var underCloseButton: UIButton!
    /// 表示するイメージのAssets名
    private var imageName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
    }

    /// 上部のボタンによって前の画面に戻る
    @IBAction func returnHomeViewByTopButton(_ sender: Any) {
        dismiss(animated: true )
    }
    /// 下部のボタンによって前の画面に戻る
    @IBAction func returnHomeViewByUnderButton(_ sender: Any) {
        dismiss(animated: true )
    }

    /// データ受け渡し用のメソッド
    internal func configurer(imageName: String) {
        self.imageName = imageName
    }

    /// 受け渡されたデータを表示
    private func displayData() {
        tutorialImageView.image = UIImage(named: imageName)
    }
}
