//
//  SalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit
import RealmSwift

/// C-売り場マップ閲覧
final class SalesFloorMapViewController: UIViewController {

    // MARK: - @IBOutlet & @IBAction

    /// チュートリアル画面にモーダル遷移
    @IBAction private func goTutorialView(_ sender: Any) {
        Router.shared.showHomeTutorial(from: self)
    }

    /// 売り場のボタン：StoryboardのA-1
    @IBOutlet private weak var greenThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-1をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenThreeList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.greenThree.rawValue)
    }

    /// 売り場のボタン：StoryboardのA-2
    @IBOutlet private weak var blueThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-2をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueThreeList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.blueThree.rawValue)
    }

    /// 売り場のボタン：StoryboardのA-3
    @IBOutlet private weak var redThreeButton: UIButton!
    /// 売り場のボタン：StoryboardのA-3をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedThreeList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.redThree.rawValue)
    }

    /// 売り場のボタン：StoryboardのB-1
    @IBOutlet private weak var greenFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-1をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenFourList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.greenFour.rawValue)
    }

    /// 売り場のボタン：StoryboardのB-2
    @IBOutlet private weak var greenTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-2をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenTwoList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.greenTwo.rawValue)

    }

    /// 売り場のボタン：StoryboardのB-3
    @IBOutlet private weak var blueSevenButton: UIButton!
    /// 売り場のボタン：StoryboardのB-3をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueSevenList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.blueSeven.rawValue)
    }

    /// 売り場のボタン：StoryboardのB-4
    @IBOutlet private weak var blueFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-4をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueFourList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.blueFour.rawValue)
    }

    /// 売り場のボタン：StoryboardのB-5
    @IBOutlet private weak var blueTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-5をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueTwoList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.blueTwo.rawValue)
    }

    /// 売り場のボタン：StoryboardのB-6
    @IBOutlet private weak var redFourButton: UIButton!
    /// 売り場のボタン：StoryboardのB-6をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedFourList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.redFour.rawValue)
    }

    /// 売り場のボタン：StoryboardのB-7
    @IBOutlet private weak var redTwoButton: UIButton!
    /// 売り場のボタン：StoryboardのB-7をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedTwoList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.redTwo.rawValue)
    }

    /// 売り場のボタン：StoryboardのC-1
    @IBOutlet private weak var greenFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-1をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenFiveList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.greenFive.rawValue)
    }

    /// 売り場のボタン：StoryboardのC-2
    @IBOutlet private weak var greenOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-2をタップして売り場の買い物リストに画面遷移
    @IBAction private func goGreenOneList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.greenOne.rawValue)
    }

    /// 売り場のボタン：StoryboardのC-3
    @IBOutlet private weak var blueSixButton: UIButton!
    /// 売り場のボタン：StoryboardのC-3をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueSixList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.blueSix.rawValue)
    }

    /// 売り場のボタン：StoryboardのC-4
    @IBOutlet private weak var blueFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-4をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueFiveList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.blueFive.rawValue)
    }

    /// 売り場のボタン：StoryboardのC-5
    @IBOutlet private weak var blueOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-5をタップして売り場の買い物リストに画面遷移
    @IBAction private func goBlueOneList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.blueOne.rawValue)
    }

    /// 売り場のボタン：StoryboardのC-6
    @IBOutlet private weak var redFiveButton: UIButton!
    /// 売り場のボタン：StoryboardのC-6をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedFiveList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.redFive.rawValue)
    }

    /// 売り場のボタン：StoryboardのC-7
    @IBOutlet private weak var redOneButton: UIButton!
    /// 売り場のボタン：StoryboardのC-7をタップして売り場の買い物リストに画面遷移
    @IBAction private func goRedOneList(_ sender: Any) {
        Router.shared.showSalesFloorShoppingList(from: self,
                                                 salesFloorRawValue: DefaultSalesFloorType.redOne.rawValue)
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

    /// カスタム売り場マップのリスト
    private var customSalesFloorData = CustomSalesFloorModel()

    /// ユーザーが作成した買い物データを格納する配列
    private var myShoppingItemList: [ShoppingItemModel] = []
    /// 共有相手が作成した買い物データを格納する配列
    private var otherShoppingItemList: [ShoppingItemModel] = []
    /// 自分と相手のshoppingコレクションのドキュメント配列を合わせた配列
    private var allShoppingItemList: [ShoppingItemModel] = []

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorderAllLabel()
        setCartView()
        setVerticalSalesFloorButtonAppearance()
        setHorizontalSalesFloorButtonAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMyShoppingItemObserver()
        setOtherShoppingItemObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeShoppingItemObserver()
    }

    // MARK: - func

    /// 自分と共有者の買い物リストを結合させて並び替えるメソッド
    private func combineShoppingItems() {
        allShoppingItemList = myShoppingItemList + otherShoppingItemList
        exchangeAllSalesFloorButton()
    }
    /// 自分の買い物リストの変更を監視、データを受け取り表示を更新する
    private func setMyShoppingItemObserver() {
        IndicatorController.shared.startIndicator()
        let uid = AccountManager.shared.getAuthStatus()
        FirestoreManager.shared.getMyShoppingItemObserver(
            listener: &FirestoreManager.shared.salesFloorMapMyItemListener,
            uid: uid,
            completion: { [weak self] itemList in
                guard let self else { return }
                print("自分の買い物リストの取得を開始")
                self.myShoppingItemList = itemList
                self.combineShoppingItems()
                IndicatorController.shared.dismissIndicator()
            })
    }

    /// 共有者の買い物リストの変更を監視、データを受け取り表示を更新する
    private func setOtherShoppingItemObserver()  {
        IndicatorController.shared.startIndicator()
        let uid = AccountManager.shared.getAuthStatus()
        FirestoreManager.shared.getOtherShoppingItemObserver(
            listener: &FirestoreManager.shared.salesFloorMapOtherItemListener,
            uid: uid,
            completion: { [weak self] itemList in
                guard let self else { return }
                print("他人の買い物リストの取得を開始")
                self.otherShoppingItemList = itemList
                self.combineShoppingItems()
                IndicatorController.shared.dismissIndicator()
            })
    }

    /// 買い物リストに関するオブザーバーを廃棄する
    private func removeShoppingItemObserver() {
        FirestoreManager.shared.removeShoppingItemObserver(
            listener: &FirestoreManager.shared.salesFloorMapMyItemListener) // 自分のオブザーバを廃棄
        FirestoreManager.shared.removeShoppingItemObserver(
            listener: &FirestoreManager.shared.salesFloorMapOtherItemListener) // 他人のオブザーバーを廃棄
    }

    /// レジ、左出入り口、右出入り口のラベルに枠線を設定するメソッド
    private func setBorderAllLabel() {
        registerLabel.setBorder()
        leftEntranceLabel.setBorder()
        rightEntranceLabel.setBorder()
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

    /// 使用する売り場マップの設定によってマップのボタンタイトルと背景色を変更し、購入商品の有無によって装飾を設定するメソッド
    /// - 各ボタンに売り場の名称を設定
    /// - 対象の売り場に購入商品がある場合は
    ///    - 売り場に対応したバックグラウンドカラーを設定
    ///    - ボタンの活性化
    ///  - 対象の売り場に購入商品がない場合は
    ///    - バックグラウンドカラーを白に設定
    ///    - ボタンの非活性化
    private func exchangeAllSalesFloorButton() {
        // - UserDefaultsに使用するキーを指定
        let useSalesFloorTypeKey = "useSalesFloorTypeKey"
        // - UserDefaultsから設定を取得
        let salesFloorTypeInt = UserDefaults.standard.integer(forKey: useSalesFloorTypeKey)
        // 0 -> カスタム、1(else) -> デフォルト
        if salesFloorTypeInt == 0 {
            // カスタムマップタイプの処理
            setCustomSalesFloorButton()
        } else {
            // デフォルトマップタイプの処理
            setDefaultSalesFloorButton()
        }
    }

    /// カスタム売り場マップの見た目に全てのボタンをセットする
    private func setCustomSalesFloorButton() {
        /// ボタンの配列を順番に設定
        let buttons = [redOneButton, redTwoButton, redThreeButton, redFourButton, redFiveButton,
                       blueOneButton, blueTwoButton, blueThreeButton, blueFourButton, blueFiveButton,
                       blueSixButton, blueSevenButton, greenOneButton, greenTwoButton, greenThreeButton,
                       greenFourButton, greenFiveButton]

        let realm = try! Realm()
        // カスタム売り場モデルのオブジェクトからフィルターメソッドを使ってcustomSalesFloorRawValueが０〜１６に合うモデルを抽出
        let results = realm.objects(CustomSalesFloorModel.self)
            .filter("customSalesFloorRawValue >= 0 AND customSalesFloorRawValue <= 16")

        // for文でbuttonsに順番にアクセス
        for (index, button) in buttons.enumerated() {
            // 取得したカスタム売り場を配列として定義
            let customSalesFloor = results[index]
            button?.setTitle(customSalesFloor.customNameOfSalesFloor, for: .normal)
            // customSalesFloorのcustomColorOfSalesFloorRawValueの値から対応する色を取得
            let customSalesFloorColor = CustomSalesFloorColor(rawValue: customSalesFloor.customColorOfSalesFloorRawValue)
            // errandDataListにsalesFloorRawValueに該当するものがある場合は、背景色を設定、ボタンを有効にする
            if allShoppingItemList.contains(where: { $0.salesFloorRawValue == customSalesFloor.customSalesFloorRawValue }) {
                button?.backgroundColor = customSalesFloorColor?.color
                button?.isEnabled = true
                // お使いデータに存在する売り場データを持っているものの中で、全てのisCheckBoxがtrueであった場合は無効化にする
                if allShoppingItemList.filter({ $0.salesFloorRawValue == customSalesFloor.customSalesFloorRawValue })
                    .allSatisfy({ $0.isCheckBox }) {
                    button?.backgroundColor = UIColor.white
                    button?.isEnabled = false
                }
            } else { // ない場合は、ボタンを無効にして、背景色を白に設定
                button?.isEnabled = false
                button?.backgroundColor = .white
            }
        }
    }

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

            // errandDataListにsalesFloorRawValueに該当するものがある場合は、背景色を設定、ボタンを有効にする
            if allShoppingItemList.contains(where: { $0.salesFloorRawValue == salesFloor.rawValue }) {
                button?.backgroundColor = salesFloor.colorOfSalesFloor
                button?.isEnabled = true
                // お使いデータに存在する売り場データを持っているものの中で、全てのisCheckBoxがtrueであった場合は無効化にする
                if allShoppingItemList.filter({ $0.salesFloorRawValue == salesFloor.rawValue })
                    .allSatisfy({ $0.isCheckBox }) {
                    button?.backgroundColor = UIColor.white
                    button?.isEnabled = false
                }
            } else { // errandDataListにsalesFloorRawValueに該当するものがない場合は、ボタンを無効にして、背景色を白に設定
                button?.backgroundColor = UIColor.white
                button?.isEnabled = false
            }
        }
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



