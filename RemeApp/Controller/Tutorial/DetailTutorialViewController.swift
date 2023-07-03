//
//  DetailTutorialViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/03.
//

import UIKit

class DetailTutorialViewController: UIViewController {

    @IBOutlet weak var topCloseButton: UIButton!

    @IBOutlet weak var tutorialImageView: UIImageView!

    @IBOutlet weak var underCloseButton: UIButton!

    private var imageName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
    }

    

    @IBAction func returnHomeViewByTopButton(_ sender: Any) {
        dismiss(animated: true )
    }

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
