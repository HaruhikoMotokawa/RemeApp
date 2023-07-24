//
//  DetailTutorialViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/03.
//

import UIKit

/// チュートリアル画像を表示を管理する
final class DetailTutorialViewController: UIViewController {

    /// 画面上部の閉じるボタン
    @IBOutlet private weak var topCloseButton: UIButton! {
        didSet {
            topCloseButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        }
    }

    /// チュートリアルの画像を表示するimgeView
    @IBOutlet private weak var tutorialImageView: UIImageView! {
        didSet {
            tutorialImageView.image = UIImage(named: imageName)
        }
    }

    /// 画面下部の閉じるボタン
    @IBOutlet private weak var underCloseButton: UIButton! {
        didSet {
            underCloseButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        }
    }

    /// 表示するイメージのAssets名
    private var imageName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// データ受け渡し用のメソッド
    internal func configurer(imageName: String) {
        self.imageName = imageName
    }

    /// 画面を閉じる
    @objc private func closeView() {
        dismiss(animated: true)
    }
}
