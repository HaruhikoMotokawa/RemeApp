//
//  ShoppingListTableViewCellControllerTableViewCell.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/23.
//

import UIKit
import RealmSwift

class ShoppingListTableViewCellController: UITableViewCell  {

    // MARK: - @IBOutlet,@IBAction

    /// チェックボックスのUIButton
    @IBOutlet  weak var checkBoxButton: CheckBox!
    /// チェックボックスがタプされた際のメソッド
    /// - cellのバックグラウンドカラーをグレイに変更
        @IBAction private func isCheckBoxButton(_ sender: Any) {
        changeBackgroundColor(isCheckBox: checkBoxButton.isChecked)
        isChecked = !isChecked
        delegate?.didTapCheckBoxButton(self)
    }
    
    /// 商品名を表示する
    @IBOutlet private weak var nameOfItemLabel: UILabel!
    /// 商品の必要数を表示
    @IBOutlet private weak var numberOfItemLabel: UILabel!
    /// 必要数の単位を表示
    @IBOutlet private weak var unitLabel: UILabel!
    /// 売り場を表示
    @IBOutlet private weak var salesFloorTypeButton: UIButton!
    /// 補足を表示
    @IBOutlet private weak var supplementLabel: UILabel!
    /// 写真を表示
    @IBOutlet private weak var photoPathImageView: UIImageView!

    // MARK: - property

    /// tableViewのcellがタップされた際のデリーゲート
    weak var delegate: ShoppingListTableViewCellDelegate?

    /// チェックボックスのフラグ
    private var isChecked:Bool = false

    /// お使いデータモデル
    var errandDataList: Array<ErrandDataModel> = []

    /// カスタム売り場マップのリスト
    private var customSalesFloorData = CustomSalesFloorModel()

    static var count = 0

    var id = 0

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        id = Self.count
        Self.count += 1
        print("[\(id)] 🔴\(#function)")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        print("[\(id)] 🟢\(#function)")
    }

    // MARK: - awakeFromNib

    override func awakeFromNib() {
        super.awakeFromNib()
        // UIButtonの基本設定
        salesFloorTypeButton.setAppearance(fontColor: .black)
    }

    // MARK: - setSelected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - func

    /// 買い物リストのデータをセルの各パーツにセットする
     func setShoppingList(isCheckBox: Bool,
                          nameOfItem: String,
                          numberOfItem: String,
                          unit: String,
                          salesFloorRawValue:Int,
                          supplement: String?,
                          image: UIImage?) {
        changeBackgroundColor(isCheckBox: isCheckBox)
        nameOfItemLabel.text = nameOfItem
        numberOfItemLabel.text = numberOfItem
        unitLabel.text = unit
        setSalesFloorTypeButton(salesFloorRawValue: salesFloorRawValue)
        setPhotoPathImageView(image: image)
        setSupplementLabel(supplement: supplement)
    }

    /// isCheckBoxのオンオフによってバックグラウンドカラーを変更する
    /// - オフで通常表示
    /// - オンでバックグラウンドカラーをライトグレイにする
    func changeBackgroundColor(isCheckBox: Bool) {
        isChecked = isCheckBox
        if isCheckBox == false {
            checkBoxButton.isChecked = false
            self.contentView.backgroundColor = .clear
        }else{
            checkBoxButton.isChecked = true
            self.contentView.backgroundColor = UIColor.lightGray
        }
    }

    /// salesFloorTypeButtonに売り場の内容を反映させる
    /// - 売り場の名称を設定
    /// - 売り場の色を設定
    func setSalesFloorTypeButton(salesFloorRawValue: Int) {
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
     func setCustomSalesFloorButton(salesFloorRawValue: Int) {
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
    func getCustomSalesFloorModelList(for salesFloorRawValue: Int) -> [CustomSalesFloorModel] {
        let realm = try! Realm()
        // カスタム売り場モデルのオブジェクトからフィルターメソッドを使って条件に合うモデルを抽出
        let results = realm.objects(CustomSalesFloorModel.self)
            .filter("customSalesFloorRawValue == %@", salesFloorRawValue)
        // 抽出した結果を戻り値に返却
        return Array(results)
    }

    /// 引数で指定されたrawValueに対応するデフォルト売り場を反映させる
    /// - Parameter salesFloorRawValue: 反映させたい売り場のrawValue
    func setDefaultSalesFloorButton(salesFloorRawValue: Int) {
        // 引数で指定されたrawValueに対応するDefaultSalesFloorTypeを取得する
        let salesFloor = DefaultSalesFloorType(rawValue: salesFloorRawValue)
        // ボタンのタイトルと背景色を設定する
        salesFloorTypeButton.setTitle(salesFloor?.nameOfSalesFloor, for: .normal)
        salesFloorTypeButton.backgroundColor = salesFloor?.colorOfSalesFloor
    }

    /// cellのsetPhotoPathImageViewに内容を反映させる
    /// - 写真がなければそのままnilを入れる
    /// - 写真がある場合はサイズを縦横幅50にリサイズして表示する

    func setPhotoPathImageView(image: UIImage?) {
        if image == nil {
            photoPathImageView.image = image
        } else {
            let resizedImage = image?.resize(to: CGSize(width: 50, height: 50))
            photoPathImageView.image = resizedImage
        }
    }

    /// cellのsetSupplementLabelに内容を反映させる
    /// - 補足がnilならそのままnilで入れる
    /// - 補足があるなら文字色を灰色にし、「 補足： 」を先頭につけて表示する
    func setSupplementLabel(supplement: String?) {
        if supplement == nil {
            supplementLabel.text = ""
        } else {
            supplementLabel.textColor = UIColor.gray
            supplementLabel.text = "補足：" + (supplement ?? "")
        }
    }
}

/// チェックボックスがタップされた場合の挙動を指定するデリゲート
protocol ShoppingListTableViewCellDelegate: AnyObject {
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController)
}


