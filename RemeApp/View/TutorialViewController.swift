//
//  TutorialViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/05/20.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var closeBitton: UIButton!

    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
