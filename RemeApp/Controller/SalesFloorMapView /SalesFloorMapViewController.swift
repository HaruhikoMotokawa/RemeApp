//
//  SalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit

/// C-売り場マップ閲覧
class SalesFloorMapViewController: UIViewController {

    /// 売り場のボタン：StoryboardのA-1
    @IBOutlet private weak var greenThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-1をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenThreeList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 14)
    }

    /// 売り場のボタン：StoryboardのA-2
    @IBOutlet private weak var blueThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-2をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueThreeList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 7)
    }

    /// 売り場のボタン：StoryboardのA-3
    @IBOutlet private weak var redThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-3をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedThreeList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 2)
    }

    /// 売り場のボタン：StoryboardのB-1
    @IBOutlet private weak var greenFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-1をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenFourList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 15)
    }

    /// 売り場のボタン：StoryboardのB-2
    @IBOutlet private weak var greenTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-2をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenTwoList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 13)
    }

    /// 売り場のボタン：StoryboardのB-3
    @IBOutlet private weak var blueSevenButton: UIButton!
    /// 売り場のボタン：StoryboardのB-3をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueSevenList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 11)
    }

    /// 売り場のボタン：StoryboardのB-4
    @IBOutlet private weak var blueFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-4をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueFourList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 8)
    }

    /// 売り場のボタン：StoryboardのB-5
    @IBOutlet private weak var blueTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-5をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueTwoList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 6)
    }

    /// 売り場のボタン：StoryboardのB-6
    @IBOutlet private weak var redFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-6をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedFourList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 3)
    }

    /// 売り場のボタン：StoryboardのB-7
    @IBOutlet private weak var redTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-7をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedTwoList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 1)
    }

    /// 売り場のボタン：StoryboardのC-1
    @IBOutlet private weak var greenFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-1をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenFiveList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 16)
    }

    /// 売り場のボタン：StoryboardのC-2
    @IBOutlet private weak var greenOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-2をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenOneList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 12)
    }

    /// 売り場のボタン：StoryboardのC-3
    @IBOutlet private weak var blueSixButton: UIButton!
    /// 売り場のボタン：StoryboardのC-3をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueSixList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 10)
    }

    /// 売り場のボタン：StoryboardのC-4
    @IBOutlet private weak var blueFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-4をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueFiveList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 9)
    }

    /// 売り場のボタン：StoryboardのC-5
    @IBOutlet private weak var blueOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-5をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueOneList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 5)
    }

    /// 売り場のボタン：StoryboardのC-6
    @IBOutlet private weak var redFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-6をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedFiveList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 4)
    }

    /// 売り場のボタン：StoryboardのC-7
    @IBOutlet private weak var redOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-7をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedOneList(_ sender: Any) {
        goSalesFloorShoppingListView(salesFloorRawValue: 0)
    }

    /// レジのラベル
    @IBOutlet private weak var registerLabel: UILabel!

    /// 左出入り口のラベル
    @IBOutlet private weak var leftEntranceLabel: UILabel!

    /// 右出入り口のラベル
    @IBOutlet private weak var rightEntranceLabel: UILabel!

    /// 使いデータのダミーデータ
    var errandDataList: [ErrandDataModel] = [ErrandDataModel(isCheckBox: false ,nameOfItem: "あそこで売ってるうまいやつ", numberOfItem: "１０" ,unit: "パック", salesFloorRawValue: 6, supplement: nil, photoImage: nil),
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
        setBorderForLabelAllLabel()
        updateButtonAppearance()
    }

    /// レジ、左出入り口、右出入り口のラベルに枠線を設定するメソッド
    private func setBorderForLabelAllLabel() {
        setBorderForLabel(label: registerLabel)
        setBorderForLabel(label: leftEntranceLabel)
        setBorderForLabel(label: rightEntranceLabel)
    }

    /// UILabelに枠線を設定するメソッド
    /// - 枠線の色を黒に
    /// - 枠線の太さ
    /// - 枠線を角丸に
    /// - ラベルのサイズを枠線に合わせる
    private func setBorderForLabel(label: UILabel) {
        let borderColor = UIColor.black.cgColor
        label.layer.borderColor = borderColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 10
        label.sizeToFit()
    }

    /// 各UIButtonに購入商品の有無によって装飾を設定するメソッド
    /// - 各ボタンに売り場の名称を設定
    /// - 対象の売り場に購入商品がある場合は
    ///    - 売り場に対応したバックグラウンドカラーを設定
    ///    - ボタンの活性化
    ///  - 対象の売り場に購入商品がない場合は
    ///    - バックグラウンドカラーを白に設定
    ///    - ボタンの非活性化
    ///  - 購入商品の有無に関わらない装飾の設定
    private func updateButtonAppearance() {
        /// ボタンの配列を順番に設定
        let buttons = [redOneButton, redTwoButton, redThreeButton, redFourButton, redFiveButton,
                       blueOneButton, blueTwoButton, blueThreeButton, blueFourButton, blueFiveButton,
                       blueSixButton, blueSevenButton, greenOneButton, greenTwoButton, greenThreeButton,
                       greenFourButton, greenFiveButton]
        // for文でbuttonsに順番にアクセス
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

    /// UIButtonの装飾の設定
    /// - 文字色
    /// - フォントサイズと種類
    /// - ボタンの枠線
    /// - 枠線の色を設定
    private func setSalesFloorButtonAppearance(button: UIButton?) {
        button?.setTitleColor(.black, for: .normal)
        button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button?.layer.borderWidth = 1
        button?.layer.borderColor = UIColor.black.cgColor
    }

    /// SalesFloorShoppingListViewに選択した売り場のリストを持って画面遷移する関数
    /// - 引数：売り場に対応したSalesFloorTypeのrawValue
    func goSalesFloorShoppingListView(salesFloorRawValue: Int) {
        let storyboard = UIStoryboard(name: "SalesFloorShoppingListView", bundle: nil)
        let salesFloorShoppingListVC = storyboard.instantiateViewController(
            withIdentifier: "SalesFloorShoppingListView") as! SalesFloorShoppingListViewController
        /// 引数に対応した売り場に該当するお使いデータをクロージャで抽出
        let salesFloorList = errandDataList.filter { $0.salesFloorRawValue == salesFloorRawValue }
        /// 抽出したお使いデータをSalesFloorShoppingListViewControllerのお使いデータに代入
        salesFloorShoppingListVC.selectedErrandDataList = salesFloorList
        /// SalesFloorShoppingListViewにプッシュ遷移
        self.navigationController?.pushViewController(salesFloorShoppingListVC, animated: true)
    }
}




