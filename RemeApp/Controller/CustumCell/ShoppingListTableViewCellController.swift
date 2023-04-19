//
//  ShoppingListTableViewCellControllerTableViewCell.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/23.
//

import UIKit

class ShoppingListTableViewCellController: UITableViewCell  {
    /// tableViewのcellがタップされた際のデリーゲート
    weak var delegate: ShoppingListTableViewCellDelegate?
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
    // !!!: 現状は使用していない、後で消すかも
    @IBAction private func salesFloorTypeButton(_ sender: Any) {
    }
    /// 補足を表示
    @IBOutlet private weak var supplementLabel: UILabel!
    /// 写真を表示
    @IBOutlet private weak var photoPathImageView: UIImageView!
    /// チェックボックスのフラグ
    private var isChecked:Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // UIButtonの基本設定
        salesFloorTypeButton.setAppearance()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    /// お使いデータモデル
    var errandDataList: Array<ErrandDataModel> = []

    /// カスタム売り場マップのリスト
    private var customSalesFloorList: [CustomSalesFloorModel] = [CustomSalesFloorModel(customSalesFloorRawValue: 0, customNameOfSalesFloor: "コメ", customColorOfSalesFloor: .cyan),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 1, customNameOfSalesFloor: "味噌", customColorOfSalesFloor: .blue),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 2, customNameOfSalesFloor: "野菜", customColorOfSalesFloor: .magenta),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 3, customNameOfSalesFloor: "人参", customColorOfSalesFloor: .orange),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 4, customNameOfSalesFloor: "椎茸", customColorOfSalesFloor: .systemBlue),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 5, customNameOfSalesFloor: "しめじ", customColorOfSalesFloor: .systemFill),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 6, customNameOfSalesFloor: "のり", customColorOfSalesFloor: .systemPink),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 7, customNameOfSalesFloor: "砂糖", customColorOfSalesFloor: .systemTeal),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 8, customNameOfSalesFloor: "塩", customColorOfSalesFloor: .systemGray3),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 9, customNameOfSalesFloor: "坦々麺", customColorOfSalesFloor: .systemMint),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 10, customNameOfSalesFloor: "プリン", customColorOfSalesFloor: .systemIndigo),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 11, customNameOfSalesFloor: "冷凍おにぎり", customColorOfSalesFloor: .systemBrown),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 12, customNameOfSalesFloor: "八つ切りパン", customColorOfSalesFloor: .red),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 13, customNameOfSalesFloor: "ピザ", customColorOfSalesFloor: .yellow),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 14, customNameOfSalesFloor: "ビール", customColorOfSalesFloor: .green),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 15, customNameOfSalesFloor: "ポカリ", customColorOfSalesFloor: .magenta),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 16, customNameOfSalesFloor: "午後ティー", customColorOfSalesFloor: .brown)
    ]


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
        salesFloorTypeButton.backgroundColor = customSalesFloorModel?.customColorOfSalesFloor
    }

    /// 引数で指定された値に対応するCustomSalesFloorModelのリストを返す関数
    /// - Parameter salesFloorRawValue: 検索したいCustomSalesFloorModelのrawValue
    /// - Returns: 検索にマッチしたCustomSalesFloorModelのリスト
    func getCustomSalesFloorModelList(for salesFloorRawValue: Int) -> [CustomSalesFloorModel] {
        // 指定されたrawValueにマッチするCustomSalesFloorModelのみを保持する配列を作成する
        let filteredList = customSalesFloorList.filter { $0.customSalesFloorRawValue == salesFloorRawValue }
        // 絞り込まれた配列を返す
        return filteredList
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
        // realm導入時にはこちらに差し替え
        //        if let photoPath = photoPath {
        //             let errandDataModel = ErrandDataModel(photoPath: photoPath)
        //            photoPathImageView.image = errandDataModel.getImage()
        //        }
    }
}
/// チェックボックスがタップされた場合の挙動を指定するデリゲート
protocol ShoppingListTableViewCellDelegate: AnyObject {
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController)
}


