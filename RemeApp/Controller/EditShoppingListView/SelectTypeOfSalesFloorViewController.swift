//
//  SelectTypeOfSalesFloorViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/06.
//

import UIKit
import RealmSwift

/// H-売り場選択
final class SelectTypeOfSalesFloorViewController: UIViewController {

    // MARK: - @IBOutlet & @IBAction
    /// 売り場のボタン：StoryboardのA-1
    @IBOutlet private weak var greenThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-1をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 14
    @IBAction private func selectGreenThree(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.greenThree.rawValue)
    }
    /// 売り場のボタン：StoryboardのA-2
    @IBOutlet private weak var blueThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-2をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 7
    @IBAction private func selectBlueThree(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.blueThree.rawValue)
    }
    /// 売り場のボタン：StoryboardのA-3
    @IBOutlet private weak var redThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-3をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 2
    @IBAction private func selectRedThree(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.redThree.rawValue)
    }
    /// 売り場のボタン：StoryboardのB-1
    @IBOutlet private weak var greenFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-1をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 15
    @IBAction private func selectGreenFour(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.greenFour.rawValue)
    }
    /// 売り場のボタン：StoryboardのB-2
    @IBOutlet private weak var greenTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-2をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 13
    @IBAction private func selectGreenTwo(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.greenTwo.rawValue)
    }
    /// 売り場のボタン：StoryboardのB-3
    @IBOutlet private weak var blueSevenButton: UIButton!
    /// 売り場のボタン：StoryboardのB-3をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 11
    @IBAction private func selectBlueSeven(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.blueSeven.rawValue)
    }
    /// 売り場のボタン：StoryboardのB-4
    @IBOutlet private weak var blueFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-4をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 8
    @IBAction private func selectBlueFour(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.blueFour.rawValue)
    }
    /// 売り場のボタン：StoryboardのB-5
    @IBOutlet private weak var blueTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-5をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 6
    @IBAction private func selectBlueTwo(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.blueTwo.rawValue)
    }
    /// 売り場のボタン：StoryboardのB-6
    @IBOutlet private weak var redFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-6をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 3
    @IBAction private func selectRedFour(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.redFour.rawValue)
    }
    /// 売り場のボタン：StoryboardのB-7
    @IBOutlet private weak var redTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-7をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 1
    @IBAction private func selectRedTwo(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.redTwo.rawValue)
    }
    /// 売り場のボタン：StoryboardのC-1
    @IBOutlet private weak var greenFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-1をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 16
    @IBAction private func selectGreenFive(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.greenFive.rawValue)
    }
    /// 売り場のボタン：StoryboardのC-2
    @IBOutlet private weak var greenOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-2をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 12
    @IBAction private func selectGreenOne(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.greenOne.rawValue)
    }
    /// 売り場のボタン：StoryboardのC-3
    @IBOutlet private weak var blueSixButton: UIButton!
    /// 売り場のボタン：StoryboardのC-3をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 10
    @IBAction private func selectBlueSix(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.blueSix.rawValue)
    }
    /// 売り場のボタン：StoryboardのC-4
    @IBOutlet private weak var blueFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-4をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 9
    @IBAction private func selectBlueFive(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.blueFive.rawValue)
    }
    /// 売り場のボタン：StoryboardのC-5
    @IBOutlet private weak var blueOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-5をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 5
    @IBAction private func selectBlueOne(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.blueOne.rawValue)
    }
    /// 売り場のボタン：StoryboardのC-6
    @IBOutlet private weak var redFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-6をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 4
    @IBAction private func selectRedFive(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.redFive.rawValue)
    }
    /// 売り場のボタン：StoryboardのC-7
    @IBOutlet private weak var redOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-7をタップして売り場の買い物リストに画面遷移
    /// salesFloorRawValue: 0
    @IBAction private func selectRedOne(_ sender: Any) {
        navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.redOne.rawValue)
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

    /// カスタム売り場マップのリスト
    private var customSalesFloorData = CustomSalesFloorModel()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNetWorkObserver()
        setHorizontalSalesFloorButtonAppearance()
        setVerticalSalesFloorButtonAppearance()
        setBorderForLabelAllLabel()
        setAllSalesFloorButton()
    }

    // MARK: - func

    /// ネットワーク関連の監視の登録
    private func setNetWorkObserver() {
        // NotificationCenterに通知を登録する
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatusDidChange),
                                               name: .networkStatusDidChange, object: nil)
    }

    /// オフライン時の処理
    @objc func handleNetworkStatusDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            // オフラインになったらアラートを出す
            if !NetworkMonitor.shared.isConnected {
                AlertController.showOffLineAlert(tittle: "オフラインです",
                                                 message:
            """
            ① 最新の情報が反映されません
            ② 写真データは表示できません
            ③ アカウント関連の操作はできません
            ④ 買い物リストの作成と編集で
            　 写真添付と削除ができません
            ⑤ 買い物リスト作成と編集は
               できますが上限があります
            """, view: self)
            }
        }
    }

    /// レジ、左出入り口、右出入り口のラベルに枠線を設定するメソッド
    private func setBorderForLabelAllLabel() {
        registerLabel.setBorder()
        leftEntranceLabel.setBorder()
        rightEntranceLabel.setBorder()
        setCartView()
    }

    /// 売り場の横長ボタンに設定する見た目
    private func setHorizontalSalesFloorButtonAppearance() {
        let horizontalButtons = [greenThreeButton, blueThreeButton, redThreeButton]
        horizontalButtons.forEach { button in
            button!.setHorizontalButtonAppearance()
        }
    }

    /// 売り場の縦長ボタンに設定する見た目
    private func setVerticalSalesFloorButtonAppearance() {
        let verticalButtons = [redOneButton, redTwoButton, redFourButton, redFiveButton,
                               blueOneButton, blueTwoButton, blueFourButton, blueFiveButton,
                               blueSixButton, blueSevenButton, greenOneButton, greenTwoButton,
                               greenFourButton, greenFiveButton]
        verticalButtons.forEach { button in
            button!.setVerticalButtonAppearance()
        }
    }
    /// 使用する売り場マップの設定によってマップのボタンタイトルと背景色を変更するメソッド
    /// - 各ボタンに売り場の名称を設定
    /// - 背景色の設定
    /// - 装飾の設定
    func setAllSalesFloorButton() {
        // 保存された設定によって切り替える
        if UserDefaults.standard.useSalesFloorType == SalesFloorMapType.custom.rawValue {
            setCustomAllSalesFloorButton() // カスタムマップタイプの処理
        } else {
            setDefaultSalesFloorButton() // デフォルトマップタイプの処理
        }
    }

    /// カスタム売り場マップの見た目に全てのボタンをセットする
    private func setCustomAllSalesFloorButton() {
        /// ボタンの配列を順番に設定
        let buttons = [redOneButton, redTwoButton, redThreeButton, redFourButton, redFiveButton,
                       blueOneButton, blueTwoButton, blueThreeButton, blueFourButton, blueFiveButton,
                       blueSixButton, blueSevenButton, greenOneButton, greenTwoButton, greenThreeButton,
                       greenFourButton, greenFiveButton]
        let realm = try! Realm()
        // カスタム売り場モデルのオブジェクトからフィルターメソッドを使ってcustomSalesFloorRawValueが０〜１６に合うモデルを抽出
        let results = realm.objects(CustomSalesFloorModel.self)
            .filter("customSalesFloorRawValue >= 0 AND customSalesFloorRawValue <= 16")

        // buttonsに対応するcustomSalesFloorListを順に設定
        for (index, button) in buttons.enumerated() {
            let customSalesFloor = results[index]
            button?.setTitle(customSalesFloor.customNameOfSalesFloor, for: .normal)
            let customSalesFloorColor = CustomSalesFloorColor(rawValue: customSalesFloor.customColorOfSalesFloorRawValue)
            button?.backgroundColor = customSalesFloorColor?.color
        }
    }

    /// デフォルト売り場マップの見た目にボタンをセットする
    /// - 名称を設定
    /// - 背景色を設定
    private func setDefaultSalesFloorButton() {
        /// ボタンの配列を順番に設定
        let buttons = [redOneButton, redTwoButton, redThreeButton, redFourButton, redFiveButton,
                       blueOneButton, blueTwoButton, blueThreeButton, blueFourButton, blueFiveButton,
                       blueSixButton, blueSevenButton, greenOneButton, greenTwoButton, greenThreeButton,
                       greenFourButton, greenFiveButton]
        // for文でbuttonsに順番にアクセス
        for (index, button) in buttons.enumerated() {
            let salesFloor = DefaultSalesFloorType(rawValue: index)!
            // 各ボタンに売り場の名称を設定
            button?.setTitle(salesFloor.nameOfSalesFloor, for: .normal)
            // バックグラウンドカラーを設定した色に変更し、ボタンを有効化する
            button?.backgroundColor = salesFloor.colorOfSalesFloor
        }
    }

    /// 選択した売り場のSalesFloorTypeを持って画面遷移する処理
    private func navigateToSelectedSalesFloor(salesFloorRawValue: DefaultSalesFloorType.RawValue) {
        print("\(salesFloorRawValue)")
        dismiss(animated: true)
        delegate?.salesFloorButtonDidTapDone(salesFloorRawValue: salesFloorRawValue)
    }

    /// 登録された買い物の開始位置によってカートのイメージの表示を切り替えるメソッド
    /// - NotificationCenterの通知受信を設定
    /// - UserDefaultsから設定を取得して画面ローディング時の表示をif文で切り替え
    private func setCartView() {
        NotificationCenter.default.addObserver(self, selector: #selector(showLeftCartView),
                                               name: .showLeftCartView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showRightCartView),
                                               name: .showRightCartView, object: nil)
        if UserDefaults.standard.shoppingStartPosition == ShoppingStartPositionType.left.rawValue {
            showLeftCartView()
        } else {
            showRightCartView()
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
protocol SelectTypeOfSalesFloorViewControllerDelegate: AnyObject {
    func salesFloorButtonDidTapDone(salesFloorRawValue: DefaultSalesFloorType.RawValue)
}
