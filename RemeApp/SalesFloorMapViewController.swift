//
//  SalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit

class SalesFloorMapViewController: UIViewController {



    @IBOutlet weak var aOneButton: UIButton!
    @IBAction func goAOneList(_ sender: Any) {
    }

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

    // レジ、左出入り口、右出入り口のラベル
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var leftEntranceLabel: UILabel!
    @IBOutlet weak var rightEntranceLabel: UILabel!

    public var errandDataList: [ErrandDataModel] = [ErrandDataModel(isCheckBox: false ,nameOfItem: "あそこで売ってるうまいやつ", numberOfItem: "１０" ,unit: "パック", salesFloorRawValue: 6, supplement: nil, photoImage: nil),
                                                    ErrandDataModel(isCheckBox: true ,nameOfItem: "牛肉", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 1, supplement:  "総量５００gくらい", photoImage:UIImage(named: "beef")),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "おいしい牛乳", numberOfItem: "2" ,unit: "本", salesFloorRawValue: 0, supplement: nil, photoImage:UIImage(named: "milk")),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "卵", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 3, supplement: "なるべく賞味期限長いもの", photoImage: nil),
                                                    ErrandDataModel(isCheckBox: true ,nameOfItem: "スタバのカフェラテっぽいやつ", numberOfItem: "１０" ,unit: "個", salesFloorRawValue: 3, supplement: nil, photoImage: nil),
                                                    ErrandDataModel(isCheckBox: true ,nameOfItem: "マクドのいちごシェイク", numberOfItem: "１" ,unit: "個", salesFloorRawValue: 5, supplement: "子供用のストローをもらってきてください。", photoImage: nil),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "玉ねぎ", numberOfItem: "３" ,unit: "個", salesFloorRawValue: 5, supplement: nil, photoImage:UIImage(named: "onion")),
                                                    ErrandDataModel(isCheckBox: true ,nameOfItem: "カラフルゼリー５種", numberOfItem: "５" ,unit: "袋", salesFloorRawValue: 12, supplement: "種類が沢山入ってるやつ", photoImage:UIImage(named: "jelly")),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "インスタントコーヒー", numberOfItem: "２" ,unit: "袋", salesFloorRawValue: 5, supplement: "詰め替えよう", photoImage:UIImage(named: "coffee"))]

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

    // 各UIButtonに名称と色を設定するメソッド
    private func updateButtonAppearance() {
        let buttons = [aOneButton, aTwoButton, aThreeButton, bOneButton, bTwoButton, bThreeButton, bFourButton, bFiveButton, bSixButton, bSevenButton, cOneButton, cTwoButton, cThreeButton, cFourButton, cFiveButton, cSixButton, cSevenButton]

        for (index, button) in buttons.enumerated() {
            let salesFloor = SalesFloorType(rawValue: index)!
            button?.setTitle(salesFloor.nameOfSalesFloor, for: .normal)
            if (errandDataList.first(where: {$0.salesFloorRawValue == index})?.salesFloorRawValue) != nil {
                button?.backgroundColor = salesFloor.colorOfSalesFloor
                button?.isEnabled = true
            } else {
                button?.backgroundColor = UIColor.white
                button?.isEnabled = false
            }
            setSalesFloorButtonAppearance(button: button)
        }
    }

    // UIButtonの文字色、フォントサイズと種類、ボタンの枠線、枠線の色を設定
    private func setSalesFloorButtonAppearance(button: UIButton?) {
        button?.setTitleColor(.black, for: .normal)
        button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button?.layer.borderWidth = 1
        button?.layer.borderColor = UIColor.black.cgColor
    }
}
