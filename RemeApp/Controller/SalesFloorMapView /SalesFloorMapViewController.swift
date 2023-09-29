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
  /// チュートリアルを表示するボタン
  @IBOutlet private weak var helpButton: UIButton! {
    didSet {
      helpButton.addTarget(self, action: #selector(helpButtonTapped), for: .touchUpInside)
    }
  }

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
  /// 売り場ボタンを配列として順番に設定
  private var salesFloorButtons: [UIButton] {
    [redOneButton, redTwoButton, redThreeButton, redFourButton, redFiveButton,
     blueOneButton, blueTwoButton, blueThreeButton, blueFourButton, blueFiveButton,
     blueSixButton, blueSevenButton, greenOneButton, greenTwoButton, greenThreeButton,
     greenFourButton, greenFiveButton]
  }

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
  /// チュートリアル画面にモーダル遷移
  @objc private func helpButtonTapped() {
    Router.shared.showTutorialMenu(from: self)
  }

  /// 選択した売り場の情報を持って画面遷移する
  @objc private func mapButtonTapped(_ sender: UIButton) {
    switch sender {
      case greenOneButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.greenOne.rawValue)
      case greenTwoButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.greenTwo.rawValue)
      case greenThreeButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.greenThree.rawValue)
      case greenFourButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.greenFour.rawValue)
      case greenFiveButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.greenFive.rawValue)
      case blueOneButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.blueOne.rawValue)
      case blueTwoButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.blueTwo.rawValue)
      case blueThreeButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.blueThree.rawValue)
      case blueFourButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.blueFour.rawValue)
      case blueFiveButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.blueFive.rawValue)
      case blueSixButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.blueSix.rawValue)
      case blueSevenButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.blueSeven.rawValue)
      case redOneButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.redOne.rawValue)
      case redTwoButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.redTwo.rawValue)
      case redThreeButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.redThree.rawValue)
      case redFourButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.redFour.rawValue)
      case redFiveButton:
        return Router.shared.showSalesFloorShoppingList(
          from: self, salesFloorRawValue: DefaultSalesFloorType.redFive.rawValue)
      default: break
    }
  }

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
    // 保存されている設定によって処理を切り替え
    if UserDefaults.standard.useSalesFloorType == SalesFloorMapType.custom.rawValue {
      setCustomSalesFloorButton() // カスタムマップタイプの処理
    } else {
      setDefaultSalesFloorButton() // デフォルトマップタイプの処理
    }
  }

  /// カスタム売り場マップの見た目に全てのボタンをセットする
  private func setCustomSalesFloorButton() {
    let realm = try! Realm()
    // カスタム売り場モデルのオブジェクトからフィルターメソッドを使ってcustomSalesFloorRawValueが０〜１６に合うモデルを抽出
    let results = realm.objects(CustomSalesFloorModel.self)
      .filter("customSalesFloorRawValue >= 0 AND customSalesFloorRawValue <= 16")
    // for文でsalesFloorButtonsに順番にアクセス
    for (index, button) in salesFloorButtons.enumerated() {
      // 取得したカスタム売り場を配列として定義
      let customSalesFloor = results[index]
      button.setTitle(customSalesFloor.customNameOfSalesFloor, for: .normal)
      // customSalesFloorのcustomColorOfSalesFloorRawValueの値から対応する色を取得
      let customSalesFloorColor = CustomSalesFloorColor(rawValue: customSalesFloor.customColorOfSalesFloorRawValue)
      // errandDataListにsalesFloorRawValueに該当するものがある場合は、背景色を設定、ボタンを有効にする
      if allShoppingItemList.contains(where: { $0.salesFloorRawValue == customSalesFloor.customSalesFloorRawValue }) {
        button.backgroundColor = customSalesFloorColor?.color
        button.isEnabled = true
        // お使いデータに存在する売り場データを持っているものの中で、全てのisCheckBoxがtrueであった場合は無効化にする
        if allShoppingItemList.filter({ $0.salesFloorRawValue == customSalesFloor.customSalesFloorRawValue })
          .allSatisfy({ $0.isCheckBox }) {
          button.backgroundColor = UIColor.white
          button.isEnabled = false
        }
      } else { // ない場合は、ボタンを無効にして、背景色を白に設定
        button.isEnabled = false
        button.backgroundColor = .white
      }
    }
  }

  private func setDefaultSalesFloorButton() {
    // for文でsalesFloorButtonsに順番にアクセス
    for (index, button) in salesFloorButtons.enumerated() {
      let salesFloor = DefaultSalesFloorType(rawValue: index)!
      // 各ボタンに売り場の名称を設定
      button.setTitle(salesFloor.nameOfSalesFloor, for: .normal)
      // errandDataListにsalesFloorRawValueに該当するものがある場合は、背景色を設定、ボタンを有効にする
      if allShoppingItemList.contains(where: { $0.salesFloorRawValue == salesFloor.rawValue }) {
        button.backgroundColor = salesFloor.colorOfSalesFloor
        button.isEnabled = true
        // お使いデータに存在する売り場データを持っているものの中で、全てのisCheckBoxがtrueであった場合は無効化にする
        if allShoppingItemList.filter({ $0.salesFloorRawValue == salesFloor.rawValue })
          .allSatisfy({ $0.isCheckBox }) {
          button.backgroundColor = UIColor.white
          button.isEnabled = false
        }
      } else { // errandDataListにsalesFloorRawValueに該当するものがない場合は、ボタンを無効にして、背景色を白に設定
        button.backgroundColor = UIColor.white
        button.isEnabled = false
      }
    }
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



