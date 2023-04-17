//
//  SelectTypeOfSalesFloorViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/06.
//

import UIKit

/// H-売り場選択
class SelectTypeOfSalesFloorViewController: UIViewController {

    // MARK: - @IBOutlet & @IBAction
    /// 売り場のボタン：StoryboardのA-1
    @IBOutlet private weak var greenThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-1をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 14
    @IBAction private func selectGreenThree(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.greenThree)
    }
    /// 売り場のボタン：StoryboardのA-2
    @IBOutlet private weak var blueThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-2をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 7
    @IBAction private func selectBlueThree(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.blueThree)
    }
    /// 売り場のボタン：StoryboardのA-3
    @IBOutlet private weak var redThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-3をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 2
    @IBAction private func selectRedThree(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.redThree)
    }
    /// 売り場のボタン：StoryboardのB-1
    @IBOutlet private weak var greenFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-1をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 15
    @IBAction private func selectGreenFour(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.greenFour)
    }
    /// 売り場のボタン：StoryboardのB-2
    @IBOutlet private weak var greenTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-2をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 13
    @IBAction private func selectGreenTwo(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.greenTwo)
    }
    /// 売り場のボタン：StoryboardのB-3
    @IBOutlet private weak var blueSevenButton: UIButton!
    /// 売り場のボタン：StoryboardのB-3をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 11
    @IBAction private func selectBlueSeven(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.blueSeven)
    }
    /// 売り場のボタン：StoryboardのB-4
    @IBOutlet private weak var blueFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-4をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 8
    @IBAction private func selectBlueFour(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.blueFour)
    }
    /// 売り場のボタン：StoryboardのB-5
    @IBOutlet private weak var blueTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-5をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 6
    @IBAction private func selectBlueTwo(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.blueTwo)
    }
    /// 売り場のボタン：StoryboardのB-6
    @IBOutlet private weak var redFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-6をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 3
    @IBAction private func selectRedFour(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.redFour)
    }
    /// 売り場のボタン：StoryboardのB-7
    @IBOutlet private weak var redTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-7をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 1
    @IBAction private func selectRedTwo(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.redTwo)
    }
    /// 売り場のボタン：StoryboardのC-1
    @IBOutlet private weak var greenFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-1をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 16
    @IBAction private func selectGreenFive(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.greenFive)
    }
    /// 売り場のボタン：StoryboardのC-2
    @IBOutlet private weak var greenOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-2をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 12
    @IBAction private func selectGreenOne(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.greenOne)
    }
    /// 売り場のボタン：StoryboardのC-3
    @IBOutlet private weak var blueSixButton: UIButton!
    /// 売り場のボタン：StoryboardのC-3をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 10
    @IBAction private func selectBlueSix(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.blueSix)
    }
    /// 売り場のボタン：StoryboardのC-4
    @IBOutlet private weak var blueFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-4をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 9
    @IBAction private func selectBlueFive(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.blueFive)
    }
    /// 売り場のボタン：StoryboardのC-5
    @IBOutlet private weak var blueOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-5をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 5
    @IBAction private func selectBlueOne(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.blueOne)
    }
    /// 売り場のボタン：StoryboardのC-6
    @IBOutlet private weak var redFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-6をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 4
    @IBAction private func selectRedFive(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.redFive)
    }
    /// 売り場のボタン：StoryboardのC-7
    @IBOutlet private weak var redOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-7をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 0
    @IBAction private func selectRedOne(_ sender: Any) {
        navigateToSelectedSalesFloor(type: DefaultSalesFloorType.redOne)
    }

    /// レジのラベル
    @IBOutlet private weak var registerLabel: UILabel!
    /// 左出入り口のラベル
    @IBOutlet private weak var leftEntranceLabel: UILabel!
    /// 右出入り口のラベル
    @IBOutlet private weak var rightEntranceLabel: UILabel!

    /// 買い物ルート設定で左回りを選択した場合に表示するView
    @IBOutlet weak var leftCartView: UIImageView!
    /// 買い物ルート設定で右回りを選択した場合に表示するView
    @IBOutlet weak var rightCartView: UIImageView!

    // MARK: - property
    /// CreateNewItemViewControllerのselectTypeOfSalesFloorButtonの見た目を変更するデリゲート
    var delegate: SelectTypeOfSalesFloorViewControllerDelegate?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorderForLabelAllLabel()
        updateButtonAppearance()
    }

    // MARK: - func
    /// レジ、左出入り口、右出入り口のラベルに枠線を設定するメソッド
    private func setBorderForLabelAllLabel() {
        registerLabel.setBorder()
        leftEntranceLabel.setBorder()
        rightEntranceLabel.setBorder()
        setCartView()
    }

    /// 各UIButtonに購入商品の有無によって装飾を設定するメソッド
    /// - 各ボタンに売り場の名称を設定
    /// - 各ボタンに売り場の色を設定
    /// - 各ボタンに装飾の設定
    private func updateButtonAppearance() {
        /// ボタンの配列を順番に設定
        let buttons = [redOneButton, redTwoButton, redThreeButton, redFourButton, redFiveButton,
                       blueOneButton, blueTwoButton, blueThreeButton, blueFourButton, blueFiveButton,
                       blueSixButton, blueSevenButton, greenOneButton, greenTwoButton, greenThreeButton,
                       greenFourButton, greenFiveButton]
        // for文でbuttonsに順番にアクセス
        for (index, button) in buttons.enumerated() {
            let salesFloor = DefaultSalesFloorType(rawValue: index)!
            button?.setTitle(salesFloor.nameOfSalesFloor, for: .normal)
            button?.backgroundColor = salesFloor.colorOfSalesFloor
            button?.setAppearanceWithShadow()
        }
    }

    /// 選択した売り場のSalesFloorTypeを持って画面遷移する処理
    private func navigateToSelectedSalesFloor(type: DefaultSalesFloorType) {
        print("\(type)")
        dismiss(animated: true)
        delegate?.salesFloorButtonDidTapDone(type: type)
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
            leftCartView.isHidden = false
            rightCartView.isHidden = true
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
}

// MARK: - SelectTypeOfSalesFloorViewControllerDelegate
/// 「売り場選択」画面でボタンをタップした後に、
/// 「品目新規作成」画面のボタンの見た目を変更するためのDelegate
protocol SelectTypeOfSalesFloorViewControllerDelegate {
    func salesFloorButtonDidTapDone(type: DefaultSalesFloorType)
}
