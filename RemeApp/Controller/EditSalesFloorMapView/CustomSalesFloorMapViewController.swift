//
//  CustomSalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/15.
//

import UIKit
import RealmSwift

final class CustomSalesFloorMapViewController: UIViewController {

    // MARK: - @IBOutlet & @IBAction
    /// 売り場のマップでカスタムを選択した場合に表示するView
    @IBOutlet private weak var customSelectCheckMark: UIImageView!

    /// 売り場のボタン：StoryboardのA-1
    @IBOutlet private weak var greenThreeButton: UIButton! {
        didSet {
            greenThreeButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのA-2
    @IBOutlet private weak var blueThreeButton: UIButton! {
        didSet {
            blueThreeButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのA-3
    @IBOutlet private weak var redThreeButton: UIButton! {
        didSet {
            redThreeButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのB-1
    @IBOutlet private weak var greenFourButton: UIButton! {
        didSet {
            greenFourButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのB-2
    @IBOutlet private weak var greenTwoButton: UIButton! {
        didSet {
            greenTwoButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのB-3
    @IBOutlet private weak var blueSevenButton: UIButton! {
        didSet {
            blueSevenButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのB-4
    @IBOutlet private weak var blueFourButton: UIButton! {
        didSet {
            blueFourButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのB-5
    @IBOutlet private weak var blueTwoButton: UIButton! {
        didSet {
            blueTwoButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのB-6
    @IBOutlet private weak var redFourButton: UIButton! {
        didSet {
            redFourButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのB-7
    @IBOutlet private weak var redTwoButton: UIButton! {
        didSet {
            redTwoButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのC-1
    @IBOutlet private weak var greenFiveButton: UIButton! {
        didSet {
            greenFiveButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのC-2
    @IBOutlet private weak var greenOneButton: UIButton! {
        didSet {
            greenOneButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのC-3
    @IBOutlet private weak var blueSixButton: UIButton! {
        didSet {
            blueSixButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのC-4
    @IBOutlet private weak var blueFiveButton: UIButton! {
        didSet {
            blueFiveButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのC-5
    @IBOutlet private weak var blueOneButton: UIButton! {
        didSet {
            blueOneButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのC-6
    @IBOutlet private weak var redFiveButton: UIButton! {
        didSet {
            redFiveButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
    }
    /// 売り場のボタン：StoryboardのC-7
    @IBOutlet private weak var redOneButton: UIButton! {
        didSet {
            redOneButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        }
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
    private var customSalesFloorData = CustomSalesFloorModel()

    /// Realmから取得したErrandDataModelの結果セットを保持するプロパティ
    private var customSalesFloorList: Results<CustomSalesFloorModel>?

    // Realmの監視用トークン
    private var notificationToken: NotificationToken?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorderAllLabel()
        setCustomSelectCheckMark()
        setCartView()
        setVerticalSalesFloorButtonAppearance()
        setHorizontalSalesFloorButtonAppearance()
        updateButtonAppearance(with: fetchCustomSalesFloors())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 通知の解除
        notificationToken?.invalidate()
    }

    // MARK: - func
    /// 選択した売り場の情報を持って画面遷移する
    @objc private func mapButtonTapped(_ sender: UIButton) {
        switch sender {
            case greenOneButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.greenOne.rawValue)
            case greenTwoButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.greenTwo.rawValue)
            case greenThreeButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.greenThree.rawValue)
            case greenFourButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.greenFour.rawValue)
            case greenFiveButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.greenFive.rawValue)
            case blueOneButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.blueOne.rawValue)
            case blueTwoButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.blueTwo.rawValue)
            case blueThreeButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.blueThree.rawValue)
            case blueFourButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.blueFour.rawValue)
            case blueFiveButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.blueFive.rawValue)
            case blueSixButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.blueSix.rawValue)
            case blueSevenButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.blueSeven.rawValue)
            case redOneButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.redOne.rawValue)
            case redTwoButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.redTwo.rawValue)
            case redThreeButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.redThree.rawValue)
            case redFourButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.redFour.rawValue)
            case redFiveButton:
                return goEditSelectedSalesFloorView(salesFloorRawValue: DefaultSalesFloorType.redFive.rawValue)
            default: break
        }
    }

    /// EditSelectedSalesFloorViewに選択した売り場のリストを持って画面遷移する関数
    /// - 引数：売り場に対応したSalesFloorTypeのrawValue
    private func goEditSelectedSalesFloorView(salesFloorRawValue: Int) {
        /// 引数に渡した値に該当するカスタム売り場のデータを取得
        let realm = try! Realm()
        guard
            let selectedFloor = realm.objects(CustomSalesFloorModel.self)
                .filter("customSalesFloorRawValue == %@",salesFloorRawValue).first else { return }
        Router.shared.showEditSelectedSalesFloorView(from: self, selectedFloor: selectedFloor)
    }

    /// レジ、左出入り口、右出入り口のラベルに枠線を設定するメソッド
    private func setBorderAllLabel() {
        registerLabel.setBorder()
        leftEntranceLabel.setBorder()
        rightEntranceLabel.setBorder()
    }

    /// CustomSalesFloorModelの監視用メソッド
    /// - カスタムマップ設定が上書き、リセットされた場合にボタンの表示を再配置する
    private func setupNotification() {
        // Realmの通知機能で変更を監視する
        notificationToken = customSalesFloorList?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
                case .initial:
                    self?.updateButtonAppearance(with: (self?.fetchCustomSalesFloors())!)
                    print("初めてなんだなぁ😊")

                case .update(let errandDataModel,let deletions,let insertions,let modifications):
                    print(errandDataModel)
                    print(deletions)
                    print(insertions)
                    print(modifications)
                    self?.updateButtonAppearance(with: (self?.fetchCustomSalesFloors())!)
                    print("変更があったデー✋🏻")
                case .error:
                    print("困ったことが起きました😱")
            }
        }
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

    // MARK: 仮で修正
    /// 各UIButtonにカスタム売り場を表示するメソッド
    /// - 引数にfetchCustomSalesFloorsメソッドで取得した配列を使用する
    /// - 各ボタンに売り場の名称を設定
    /// - 売り場に対応したバックグラウンドカラーを設定
    private func updateButtonAppearance(with results: Results<CustomSalesFloorModel>) {
        /// ボタンの配列をに設定
        let buttons = [redOneButton, redTwoButton, redThreeButton, redFourButton, redFiveButton,
                       blueOneButton, blueTwoButton, blueThreeButton, blueFourButton, blueFiveButton,
                       blueSixButton, blueSevenButton, greenOneButton, greenTwoButton, greenThreeButton,
                       greenFourButton, greenFiveButton]

        // for文でbuttonsに順番にアクセス
        for (index, button) in buttons.enumerated() {
            let customSalesFloor = results[index]
            button?.setTitle(customSalesFloor.customNameOfSalesFloor, for: .normal)
            button?.backgroundColor = customSalesFloor.customSalesFloorColor.color
        }
    }

    /// カスタムマップ設定の売り場オブジェクトを取得して昇順に並べて、返却する
    private func fetchCustomSalesFloors() -> Results<CustomSalesFloorModel> {
        let realm = try! Realm()
        let results = realm.objects(CustomSalesFloorModel.self)
            .filter("customSalesFloorRawValue >= 0 AND customSalesFloorRawValue <= 16")
            .sorted(byKeyPath: "customSalesFloorRawValue")
        customSalesFloorList = results
        return customSalesFloorList!
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
    /// - UserDefaultsから設定を取得して画面ローディング時の表示をif文で切り替え
    private func setCartView() {
        NotificationCenter.default.addObserver(self, selector: #selector(showLeftCartView),
                                               name: .showLeftCartView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showRightCartView),
                                               name: .showRightCartView, object: nil)
        if UserDefaults.standard.shoppingStartPosition == ShoppingStartPositionType.left.rawValue {
            showLeftCartView() // 左回り設定
        } else {
            showRightCartView() // 右回り設定
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
