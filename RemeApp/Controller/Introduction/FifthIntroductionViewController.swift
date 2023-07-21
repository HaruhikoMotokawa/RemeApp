//
//  FifthIntroductionViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/04.
//

import UIKit

final class FifthIntroductionViewController: UIViewController {

    @IBOutlet private weak var closeButton: UIButton! {
        didSet {
            // 文字色を黒に設定
            closeButton.setTitleColor(.white, for: .normal)
            // フォントをボールド、サイズを２０に設定
            closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            // 枠線の幅を１で設定
            closeButton.layer.borderWidth = 1
            // 枠線のカラーを黒に設定
            closeButton.layer.borderColor = UIColor.white.cgColor
            // バックグラウンドを角丸１０に設定
            closeButton.layer.cornerRadius = 10.0
            closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc private func closeView() {
        dismiss(animated: true)
    }

}
