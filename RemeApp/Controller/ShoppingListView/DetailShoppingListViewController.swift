//
//  DetailShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/27.
//

import UIKit
import RealmSwift

/// B-買い物リスト詳細
class DetailShoppingListViewController: UIViewController {

    // MARK: - @IBOutlet

    /// 売り場を表示
    @IBOutlet private weak var salesFloorTypeButton: UIButton!
    /// 詳細のView
    @IBOutlet weak var detailView: UIView!
    /// 写真を表示
    @IBOutlet private weak var photoPathImageView: UIImageView!
    /// 商品名を表示
    @IBOutlet private weak var nameOfItemLabel: UILabel!
    /// 必要数を表示
    @IBOutlet private weak var numberOfItemLabel: UILabel!
    /// 必要数の単位を表示
    @IBOutlet private weak var unitLabel: UILabel!
    /// 補足を表示
    @IBOutlet private weak var supplementLabel: UILabel!

    // MARK: - property
    /// ドキュメントID
    private var id:String? = nil
    /// nameOfItemLabelに表示するテキスト
    private var nameOfItemLabelText:String = ""
    /// numberOfItemLabelに表示するテキスト
    private var numberOfItemLabelText:String = ""
    /// unitLabelに表示するテキスト
    private var unitLabelText:String = ""
    /// salesFloorTypeButtonに表示する売り場の種類を指定するためのRawValue
    private var salesFloorButtonRawValue:Int = 0
    /// supplementLabelに表示するテキスト
    private var supplementLabelText:String? = nil
    /// photoImageViewに表示する画像
    private var photoURL:String = ""
    /// photoPathImageViewに表示する画像
//    private var photoPathImage:UIImage? = nil

    /// カスタム売り場マップのリスト
    private var customSalesFloorData = CustomSalesFloorModel()

    /// ユーザーが作成した買い物データを格納する配列
    private var myShoppingItemList: [ShoppingItemModel] = []
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
        salesFloorTypeButton.setAppearanceWithShadow(fontColor: .black)
        nameOfItemLabel.setAppearance()
        setDetailView()
        numberOfItemLabel.setAppearance()
        unitLabel.setAppearance()
        supplementLabel.setAppearance()
    }

    // MARK: - func

    /// 買い物リストから詳細画面に遷移中の場合、画面を閉じてマップ閲覧画面に画面遷移する
    @IBAction private func goSalesFloorMapView(_ sender: Any) {
        self.dismiss(animated: true) {
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let tabBarController = windowScene.windows.first?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 1
            }
        }
    }

    /// 画面閉じて戻る
    @IBAction private func closeView(_ sender: Any) {
        dismiss(animated: true)
    }
//    /// データ受け渡し用のメソッド
//    func configurer(detail: ErrandDataModel) {
//        nameOfItemLabelText = detail.nameOfItem
//        numberOfItemLabelText = detail.numberOfItem
//        unitLabelText = detail.unit
//        salesFloorButtonRawValue = detail.salesFloorRawValue
//        supplementLabelText = detail.supplement
//        photoPathImage = detail.getImage()
//    }

    /// データ受け渡し用のメソッド
    internal func configurer(detail: ShoppingItemModel) {
        myShoppingItemList = [detail]
        id = detail.id
        nameOfItemLabelText = detail.nameOfItem
        numberOfItemLabelText = detail.numberOfItem
        unitLabelText = detail.unit
        salesFloorButtonRawValue = detail.salesFloorRawValue
        supplementLabelText = detail.supplement
        photoURL = detail.photoURL
    }

    /// detailViewに枠線をつけるメソッド
    private func setDetailView() {
        detailView.layer.borderColor = UIColor.black.cgColor
        detailView.layer.borderWidth = 2
        detailView.layer.cornerRadius = 10
        detailView.clipsToBounds = true
    }

    /// 受け渡されたデータをそれぞれのUI部品に表示
    /// - 商品名の表示
    /// - 必要数を表示
    /// - 必要数の単位を表示
    /// - 売り場を表示
    /// - 補足を表示
    /// - 写真を表示
    private func displayData() {
        nameOfItemLabel.text = nameOfItemLabelText
        numberOfItemLabel.text = numberOfItemLabelText
        unitLabel.text = unitLabelText
        setSalesFloorTypeButton(salesFloorRawValue: salesFloorButtonRawValue)
        setSupplementLabelText(supplement: supplementLabelText)
        setPhotoPathImageView(photoURL: photoURL)
    }

    /// salesFloorTypeButtonに売り場の内容を反映させる
    /// - 売り場の名称を設定
    /// - 売り場の色を設定
    private func setSalesFloorTypeButton(salesFloorRawValue: Int) {
        let useSalesFloorTypeKey = "useSalesFloorTypeKey"
        let salesFloorTypeInt = UserDefaults.standard.integer(forKey: useSalesFloorTypeKey)
        // 0 -> カスタム、1(else) -> デフォルト
        if salesFloorTypeInt == 0 {
            // カスタムマップタイプの処理
            setCustomSalesFloorButton(salesFloorRawValue: salesFloorRawValue)
        } else {
            // デフォルトマップタイプの処理
            setDefaultSalesFloorButton(salesFloorRawValue: salesFloorRawValue)
        }
    }

    /// 引数で指定されたrawValueに対応するカスタム売り場を反映させる
    /// - Parameter salesFloorRawValue: 反映させたいカスタム売り場のrawValue
    private func setCustomSalesFloorButton(salesFloorRawValue: Int) {
        // 指定されたrawValueにマッチするCustomSalesFloorModelを取得する
        let customSalesFloorModelList = getCustomSalesFloorModelList(for: salesFloorRawValue)
        let customSalesFloorModel = customSalesFloorModelList.first
        // ボタンのタイトルと背景色を設定する
        salesFloorTypeButton.setTitle(customSalesFloorModel?.customNameOfSalesFloor, for: .normal)
        salesFloorTypeButton.backgroundColor = customSalesFloorModel?.customSalesFloorColor.color
    }

    /// 引数で指定された値に対応するCustomSalesFloorModelのリストを返す関数
    /// - Parameter salesFloorRawValue: 検索したいCustomSalesFloorModelのrawValue
    /// - Returns: 検索にマッチしたCustomSalesFloorModelのリスト
    private func getCustomSalesFloorModelList(for salesFloorRawValue: Int) -> [CustomSalesFloorModel] {
        let realm = try! Realm()
        // カスタム売り場モデルのオブジェクトからフィルターメソッドを使って条件に合うモデルを抽出
        let results = realm.objects(CustomSalesFloorModel.self)
            .filter("customSalesFloorRawValue == %@", salesFloorRawValue)
        // 抽出した結果を戻り値に返却
        return Array(results)
    }

    /// 引数で指定されたrawValueに対応するデフォルト売り場を反映させる
    /// - Parameter salesFloorRawValue: 反映させたい売り場のrawValue
    private func setDefaultSalesFloorButton(salesFloorRawValue: Int) {
        // 引数で指定されたrawValueに対応するDefaultSalesFloorTypeを取得する
        let salesFloor = DefaultSalesFloorType(rawValue: salesFloorRawValue)
        // ボタンのタイトルと背景色を設定する
        salesFloorTypeButton.setTitle(salesFloor?.nameOfSalesFloor, for: .normal)
        salesFloorTypeButton.backgroundColor = salesFloor?.colorOfSalesFloor
    }
    
    /// 受け渡されたデータをsetSupplementLabelTextに表示
    /// - 補足がなければ灰色の文字色で「なし」を表示
    /// - 補足がある場合はそのまま表示
    private func setSupplementLabelText(supplement: String? ) {
        if supplementLabelText == nil {
            supplementLabel.text = supplementLabelText
        } else {
            supplementLabel.text = "補足：" + supplementLabelText!
        }
    }

    /// 受け渡されたデータをphotoPathImageViewに表示
    /// - 画像がなければ抜ける
    /// - 画像があればリサイズと角丸処理をして表示する
    private func setPhotoPathImageView(photoURL: String) {
        if photoURL == "" {
            photoPathImageView.image = nil
        } else {
            let setImage = StorageManager.shared.setImageWithUrl(photoURL: photoURL)
            let resizedImage = setImage?.resize(to: CGSize(width: 410, height: 410))
            let roundedAndBorderedImage = resizedImage?.roundedAndBordered(
                cornerRadius: 10, borderWidth: 1, borderColor: UIColor.black)
            photoPathImageView.image = roundedAndBorderedImage
        }
    }
}
