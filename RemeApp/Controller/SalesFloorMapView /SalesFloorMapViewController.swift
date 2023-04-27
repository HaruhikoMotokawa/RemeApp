//
//  SalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit
import RealmSwift

/// C-売り場マップ閲覧
class SalesFloorMapViewController: UIViewController {

    // MARK: - @IBOutlet & @IBAction
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

    /// 買い物ルート設定で左回りを選択した場合に表示するView
    @IBOutlet private weak var leftCartView: UIImageView!

    /// 買い物ルート設定で右回りを選択した場合に表示するView
    @IBOutlet private weak var rightCartView: UIImageView!

    // MARK: - property
    /// 使いデータのダミーデータ
    var errandDataList: [ErrandDataModel] = []

    /// カスタム売り場マップのリスト
    private var customSalesFloorData = CustomSalesFloorModel()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorderAllLabel()
       
        setCartView()
        NotificationCenter.default.addObserver(self, selector: #selector(exchangeAllSalesFloorButton),
                                               name: .exchangeAllSalesFloorButton, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setErrandData()
        exchangeAllSalesFloorButton()
    }

    
    // MARK: - func

    /// 保存されたお使いデータをセットする
    func setErrandData() {
        let realm = try! Realm()
        let result = realm.objects(ErrandDataModel.self)
        errandDataList = Array(result)
    }

    /// レジ、左出入り口、右出入り口のラベルに枠線を設定するメソッド
    private func setBorderAllLabel() {
        registerLabel.setBorder()
        leftEntranceLabel.setBorder()
        rightEntranceLabel.setBorder()
    }

    /// 使用する売り場マップの設定によってマップのボタンタイトルと背景色を変更し、購入商品の有無によって装飾を設定するメソッド
    /// - 各ボタンに売り場の名称を設定
    /// - 対象の売り場に購入商品がある場合は
    ///    - 売り場に対応したバックグラウンドカラーを設定
    ///    - ボタンの活性化
    ///  - 対象の売り場に購入商品がない場合は
    ///    - バックグラウンドカラーを白に設定
    ///    - ボタンの非活性化
    ///  - 購入商品の有無に関わらない装飾の設定
    @objc func exchangeAllSalesFloorButton() {
        // - UserDefaultsに使用するキーを指定
        let useSalesFloorTypeKey = "useSalesFloorTypeKey"
        // - UserDefaultsから設定を取得
        let salesFloorTypeInt = UserDefaults.standard.integer(forKey: useSalesFloorTypeKey)
        // 0 -> カスタム、1(else) -> デフォルト
        if salesFloorTypeInt == 0 {
            // カスタムマップタイプの処理
            setCustomAllSalesFloorButton()
        } else {
            // デフォルトマップタイプの処理
            setDefaultSalesFloorButton()
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
            button?.setAppearanceWithShadow()
        }
        // salesFloorRawValueがerrandDataListに存在しないボタンを無効にして背景色を白にする
        for (index, button) in buttons.enumerated() {
            guard let salesFloor = DefaultSalesFloorType(rawValue: index) else {
                button?.setTitle("", for: .normal)
                button?.backgroundColor = .white
                button?.isEnabled = false
                continue
            }

            if errandDataList.contains(where: { $0.salesFloorRawValue == salesFloor.intValue }) &&
                (errandDataList.first(where: {$0.salesFloorRawValue == index})?.isCheckBox == false) {
                button?.isEnabled = true
            } else {
                button?.isEnabled = false
                button?.backgroundColor = .white
            }
        }
    }

    /// デフォルト売り場マップを全てのボタンをセットする
    /// - 名称を設定
    /// - お使いデータに対象の売り場の品目の有無によって背景色を設定
    /// - お使いデータに対象の売り場の品目の有無によってボタンの有効化と無効化を設定
    /// - 基本装飾と影を設定
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
            // お使いデータの中に対象の売り場があるかどうかで、ボタンの状態を変更する
            if (errandDataList.first(where: {$0.salesFloorRawValue == index})?.salesFloorRawValue) != nil &&
                (errandDataList.first(where: {$0.salesFloorRawValue == index})?.isCheckBox == false) {
                // ある場合はバックグラウンドカラーを設定した色に変更し、ボタンを有効化する
                button?.backgroundColor = salesFloor.colorOfSalesFloor
                button?.isEnabled = true
            } else {
                // ない場合はバックグラウンドカラーを白に設定し、ボタンを無効化する
                button?.backgroundColor = UIColor.white
                button?.isEnabled = false
            }
            // 最後に全てのボタンに基本の装飾と影を設定する
            button?.setAppearanceWithShadow()
        }
    }

    /// SalesFloorShoppingListViewに選択した売り場のrawValueを持って画面遷移する関数
    /// - 引数：売り場に対応したSalesFloorTypeのrawValue
    private func goSalesFloorShoppingListView(salesFloorRawValue: Int) {
        let storyboard = UIStoryboard(name: "SalesFloorShoppingListView", bundle: nil)
        let salesFloorShoppingListVC = storyboard.instantiateViewController(
            withIdentifier: "SalesFloorShoppingListView") as! SalesFloorShoppingListViewController
        // 選択した売り場のrawValueをSalesFloorShoppingListViewのsalesFloorRawValueに渡す
        salesFloorShoppingListVC.salesFloorRawValue = salesFloorRawValue
        /// SalesFloorShoppingListViewにプッシュ遷移
        self.navigationController?.pushViewController(salesFloorShoppingListVC, animated: true)
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



