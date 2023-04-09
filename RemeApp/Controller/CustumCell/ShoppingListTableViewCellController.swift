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
    @IBOutlet private weak var checkBoxButton: CheckBox!
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
    /// 買い物リストのデータをセルの各パーツにセットする
     func setShoppingList(isCheckBox: Bool ,nameOfItem: String, numberOfItem: String,
                         unit: String, salesFloorRawValue:Int ,supplement: String?,
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
            self.contentView.backgroundColor = UIColor.systemBackground
        }else{
            checkBoxButton.isChecked = true
            self.contentView.backgroundColor = UIColor.lightGray
        }
    }
    /// salesFloorTypeButtonに売り場の内容を反映させる
    /// - 売り場の名称を設定
    /// - 売り場の色を設定
    func setSalesFloorTypeButton(salesFloorRawValue: Int) {
        let salesFloor = SalesFloorType(rawValue: salesFloorRawValue)
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


