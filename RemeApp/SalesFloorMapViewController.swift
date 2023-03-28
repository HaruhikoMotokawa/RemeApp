//
//  SalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit

class SalesFloorMapViewController: UIViewController {


    @IBOutlet weak var aOneButton: UIButton!


    @IBOutlet weak var aTwoButton: UIButton!


    @IBOutlet weak var aThreeButton: UIButton!


    @IBOutlet weak var bOneButton: UIButton!


    @IBOutlet weak var bTwoButton: UIButton!


    @IBOutlet weak var bThreeButton: UIButton!


    @IBOutlet weak var bFourButton: UIButton!


    @IBOutlet weak var bFiveButton: UIButton!


    @IBOutlet weak var bSixButton: UIButton!


    @IBOutlet weak var bSevenButton: UIButton!


    @IBOutlet weak var cOneButton: UIButton!


    @IBOutlet weak var cTwoButton: UIButton!


    @IBOutlet weak var cThreeButton: UIButton!


    @IBOutlet weak var cFourButton: UIButton!


    @IBOutlet weak var cFiveButton: UIButton!


    @IBOutlet weak var cSixButton: UIButton!


    @IBOutlet weak var cSevenButton: UIButton!


    @IBOutlet weak var registerLabel: UILabel!

    @IBOutlet weak var leftEntranceLabel: UILabel!

    @IBOutlet weak var rightEntranceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 各UILabelに枠線を設定
        setBorderForLabel(label: registerLabel)
        setBorderForLabel(label: leftEntranceLabel)
        setBorderForLabel(label: rightEntranceLabel)
        updateButtonAppearance()
    }

    // UILabelに枠線を設定するメソッド
    private func setBorderForLabel(label: UILabel) {
        let borderColor = UIColor.black.cgColor
        label.layer.borderColor = borderColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 10
        label.sizeToFit()
    }

    //     各UIButtonに名称と色を設定するメソッド
    private func updateButtonAppearance() {
        let buttons = [aOneButton, aTwoButton, aThreeButton, bOneButton, bTwoButton, bThreeButton, bFourButton, bFiveButton, bSixButton, bSevenButton, cOneButton, cTwoButton, cThreeButton, cFourButton, cFiveButton, cSixButton, cSevenButton]

        for (index, button) in buttons.enumerated() {
            let salesFloor = SalesFloorType(rawValue: index)!
            button?.setTitle(salesFloor.nameOfSalesFloor, for: .normal)
            button?.backgroundColor = salesFloor.colorOfSalesFloor
            button?.setTitleColor(.black, for: .normal)
            button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
}
