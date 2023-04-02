//
//  SalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit

class SalesFloorMapViewController: UIViewController {

    @IBOutlet weak var greenThreeButton: UIButton!
    @IBAction func goGreenThreeList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var blueThreeButton: UIButton!
    @IBAction func goBlueThreeList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var redThreeButton: UIButton!
    @IBAction func goRedThreeList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var greenFourButton: UIButton!
    @IBAction func goGreenFourList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var greenTwoButton: UIButton!
    @IBAction func goGreenTwoList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }


    @IBOutlet weak var blueSevenButton: UIButton!
    @IBAction func goBlueSevenList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var blueFourButton: UIButton!
    @IBAction func goBlueFourList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var blueTwoButton: UIButton!
    @IBAction func goBlueTwoList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var redFourButton: UIButton!
    @IBAction func goRedFourList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var redTwoButton: UIButton!
    @IBAction func goRedTwoList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var greenFiveButton: UIButton!
    @IBAction func goGreenFiveList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var greenOneButton: UIButton!
    @IBAction func goGreenOneList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var blueSixButton: UIButton!
    @IBAction func goBlueSixList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var blueFiveButton: UIButton!
    @IBAction func goBlueFiveList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var blueOneButton: UIButton!
    @IBAction func goBlueOneList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var redFiveButton: UIButton!
    @IBAction func goRedFiveList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    @IBOutlet weak var redOneButton: UIButton!
    @IBAction func goRedOneList(_ sender: Any) {
        goSalesFloorShoppingListView()
    }

    // レジ、左出入り口、右出入り口のラベル
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var leftEntranceLabel: UILabel!
    @IBOutlet weak var rightEntranceLabel: UILabel!

    public var errandDataList: [ErrandDataModel] = [ErrandDataModel(isCheckBox: false ,nameOfItem: "あそこで売ってるうまいやつ", numberOfItem: "１０" ,unit: "パック", salesFloorRawValue: 6, supplement: nil, photoImage: nil),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "牛肉", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 7, supplement:  "総量５００gくらい", photoImage:UIImage(named: "beef")),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "おいしい牛乳", numberOfItem: "2" ,unit: "本", salesFloorRawValue: 14, supplement: nil, photoImage:UIImage(named: "milk")),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "卵", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 15, supplement: "なるべく賞味期限長いもの", photoImage: nil),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "スタバのカフェラテっぽいやつ", numberOfItem: "１０" ,unit: "個", salesFloorRawValue: 12, supplement: nil, photoImage: nil),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "マクドのいちごシェイク", numberOfItem: "１" ,unit: "個", salesFloorRawValue: 15, supplement: "子供用のストローをもらってきてください。", photoImage: nil),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "玉ねぎ", numberOfItem: "３" ,unit: "個", salesFloorRawValue: 0, supplement: nil, photoImage:UIImage(named: "onion")),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "カラフルゼリー５種", numberOfItem: "５" ,unit: "袋", salesFloorRawValue: 9, supplement: "種類が沢山入ってるやつ", photoImage:UIImage(named: "jelly")),
                                                    ErrandDataModel(isCheckBox: false ,nameOfItem: "インスタントコーヒー", numberOfItem: "２" ,unit: "袋", salesFloorRawValue: 11, supplement: "詰め替えよう", photoImage:UIImage(named: "coffee"))]

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
        let buttons = [redOneButton, redTwoButton, redThreeButton, redFourButton, redFiveButton,
                       blueOneButton, blueTwoButton, blueThreeButton, blueFourButton, blueFiveButton,
                       blueSixButton, blueSevenButton, greenOneButton, greenTwoButton, greenThreeButton,
                       greenFourButton, greenFiveButton]

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

    // SalesFloorShoppingListViewに画面遷移する関数
    func goSalesFloorShoppingListView() {
        let storyboard = UIStoryboard(name: "SalesFloorShoppingListView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SalesFloorShoppingListView") as! SalesFloorShoppingListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


