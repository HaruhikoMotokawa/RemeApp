//
//  CustomSalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/15.
//

import UIKit

class CustomSalesFloorMapViewController: UIViewController {

    // MARK: - @IBOutlet & @IBAction
    /// 売り場のマップでカスタムを選択した場合に表示するView
    @IBOutlet private weak var customSelectCheckMark: UIImageView!

    /// 売り場のボタン：StoryboardのA-1
    @IBOutlet private weak var greenThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-1をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenThreeList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 14)
    }

    /// 売り場のボタン：StoryboardのA-2
    @IBOutlet private weak var blueThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-2をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueThreeList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 7)
    }

    /// 売り場のボタン：StoryboardのA-3
    @IBOutlet private weak var redThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-3をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedThreeList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 2)
    }

    /// 売り場のボタン：StoryboardのB-1
    @IBOutlet private weak var greenFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-1をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenFourList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 15)
    }

    /// 売り場のボタン：StoryboardのB-2
    @IBOutlet private weak var greenTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-2をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenTwoList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 13)
    }

    /// 売り場のボタン：StoryboardのB-3
    @IBOutlet private weak var blueSevenButton: UIButton!
    /// 売り場のボタン：StoryboardのB-3をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueSevenList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 11)
    }

    /// 売り場のボタン：StoryboardのB-4
    @IBOutlet private weak var blueFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-4をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueFourList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 8)
    }

    /// 売り場のボタン：StoryboardのB-5
    @IBOutlet private weak var blueTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-5をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueTwoList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 6)
    }

    /// 売り場のボタン：StoryboardのB-6
    @IBOutlet private weak var redFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-6をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedFourList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 3)
    }

    /// 売り場のボタン：StoryboardのB-7
    @IBOutlet private weak var redTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-7をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedTwoList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 1)
    }

    /// 売り場のボタン：StoryboardのC-1
    @IBOutlet private weak var greenFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-1をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenFiveList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 16)
    }

    /// 売り場のボタン：StoryboardのC-2
    @IBOutlet private weak var greenOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-2をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenOneList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 12)
    }

    /// 売り場のボタン：StoryboardのC-3
    @IBOutlet private weak var blueSixButton: UIButton!
    /// 売り場のボタン：StoryboardのC-3をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueSixList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 10)
    }

    /// 売り場のボタン：StoryboardのC-4
    @IBOutlet private weak var blueFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-4をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueFiveList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 9)
    }

    /// 売り場のボタン：StoryboardのC-5
    @IBOutlet private weak var blueOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-5をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueOneList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 5)
    }

    /// 売り場のボタン：StoryboardのC-6
    @IBOutlet private weak var redFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-6をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedFiveList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 4)
    }

    /// 売り場のボタン：StoryboardのC-7
    @IBOutlet private weak var redOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-7をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedOneList(_ sender: Any) {
        goEditSelectedSalesFloorView(salesFloorRawValue: 0)
    }

    /// レジのラベル
    @IBOutlet private weak var registerLabel: UILabel!
    /// 左出入り口のラベル
    @IBOutlet private weak var leftEntranceLabel: UILabel!
    /// 右出入り口のラベル
    @IBOutlet private weak var rightEntranceLabel: UILabel!


    /// 買い物ルート設定で左回りを選択した場合に表示するView
    @IBOutlet private weak var leftCartView: UIImageView!

    /// 買い物ルート設定で右回りを選択した場合に表示するView
    @IBOutlet private weak var rightCartView: UIImageView!


    // MARK: - property
    private var customSalesFloorList: [CustomSalesFloorModel] = []

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonAppearance()
        setBorderAllLabel()
        setCustomSelectCheckMark()
        setCartView()
    }

    // MARK: - func
    /// レジ、左出入り口、右出入り口のラベルに枠線を設定するメソッド
    private func setBorderAllLabel() {
        registerLabel.setBorder()
        leftEntranceLabel.setBorder()
        rightEntranceLabel.setBorder()
    }
    // MARK: 仮で修正
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
            let customSalesFloor = customSalesFloorList[index]
            button?.setTitle(customSalesFloor.customNameOfSalesFloor, for: .normal)
            button?.backgroundColor = customSalesFloor.customColorOfSalesFloor
            button?.setAppearanceWithShadow()
        }
    }

    /// 登録された使用マップ設定によってチェックマークの表示を切り替えるメソッド
    /// - NotificationCenterの通知受信を設定
    /// - UserDefaultsに使用するキーを指定
    /// - UserDefaultsから設定を取得
    /// -  画面ローディング時の表示をif文で切り替え
    private func setCustomSelectCheckMark() {
        NotificationCenter.default.addObserver(self, selector: #selector(showCustomSelectCheckMark),
                                               name: .showCustomSelectCheckMark, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideCustomSelectCheckMark),
                                               name: .hideCustomSelectCheckMark, object: nil)
        let useSalesFloorTypeKey = "useSalesFloorTypeKey"
        let salesFloorTypeInt = UserDefaults.standard.integer(forKey: useSalesFloorTypeKey)
        if salesFloorTypeInt == 0 {
            // カスタム売り場マップの処理
            customSelectCheckMark.isHidden = false
        } else {
            // デフォルト売り場マップの処理
            customSelectCheckMark.isHidden = true
        }
    }

    /// NotificationCenterによって使用する売り場のマップをカスタムが選択された場合にcustomSelectCheckMarkを表示にする
    @objc func showCustomSelectCheckMark() {
        customSelectCheckMark.isHidden = false
    }

    /// NotificationCenterによって使用する売り場のマップをデフォルトが選択された場合にcustomSelectCheckMarkを非表示にする
    @objc func hideCustomSelectCheckMark() {
        customSelectCheckMark.isHidden = true
    }

    /// 登録された買い物の開始位置によってカートのイメージの表示を切り替えるメソッド
    /// - NotificationCenterの通知受信を設定
    /// - UserDefaultsに使用するキーを指定
    /// - UserDefaultsから設定を取得
    /// - 画面ローディング時の表示をif文で切り替え
    private func setCartView() {
        NotificationCenter.default.addObserver(self, selector: #selector(showLeftCartView),
                                               name: .showLeftCartView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showRightCartView),
                                               name: .showRightCartView, object: nil)
        let shoppingStartPositionKey = "shoppingStartPositionKey"
        let shoppingStartPositionInt = UserDefaults.standard.integer(forKey: shoppingStartPositionKey)
        if shoppingStartPositionInt == 0 {
            // 左回り設定
            leftCartView.isHidden = false
            rightCartView.isHidden = true
            // 右回り設定
        } else {
            rightCartView.isHidden = false
            leftCartView.isHidden = true
        }
    }

    /// NotificationCenterによって買い物ルートを左回りに選択された場合の処理
    /// - leftCartViewを表示にする
    /// - rightCartViewを非表示にする
    @objc func showLeftCartView() {
        leftCartView.isHidden = false
        rightCartView.isHidden = true
    }

    /// NotificationCenterによって買い物ルートを右回りに選択された場合の処理
    /// - rightCartViewを表示にする
    /// - leftCartViewを非表示にする
    @objc func showRightCartView() {
        rightCartView.isHidden = false
        leftCartView.isHidden = true
    }

    /// EditSelectedSalesFloorViewに選択した売り場のリストを持って画面遷移する関数
    /// - 引数：売り場に対応したSalesFloorTypeのrawValue
    private func goEditSelectedSalesFloorView(salesFloorRawValue: Int) {
        let storyboard = UIStoryboard(name: "EditSelectedSalesFloorView", bundle: nil)
        let editSelectedSalesFloorVC = storyboard.instantiateViewController(
            withIdentifier: "EditSelectedSalesFloorView") as! EditSelectedSalesFloorViewController
        /// 引数に渡した値に該当するカスタム売り場のデータを取得
        let selectedFloor = customSalesFloorList.first(where: { $0.customSalesFloorRawValue == salesFloorRawValue })
        // editSelectedSalesFloorVCに該当のカスタム売り場のデータを渡す
        if let selectedFloor = selectedFloor {
            editSelectedSalesFloorVC.configurer(detail: selectedFloor)
            // EditSelectedSalesFloorViewにプッシュ遷移
            self.navigationController?.pushViewController(editSelectedSalesFloorVC, animated: true)
        }
    }
}
