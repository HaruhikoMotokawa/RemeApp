//
//  ShoppingListTableViewCellControllerTableViewCell.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/23.
//

import UIKit

class ShoppingListTableViewCellController: UITableViewCell  {


    weak var delegate: ShoppingListTableViewCellDelegate?
    @IBOutlet private weak var checkBoxButton: CheckBox!
    @IBAction private func isCheckBoxButton(_ sender: Any) {
        changeBackgroundColor(isCheckBox: checkBoxButton.isChecked)
        isChecked = !isChecked
        delegate?.didTapCheckBoxButton(self)
    }

    @IBOutlet private weak var nameOfItemLabel: UILabel!

    @IBOutlet private weak var numberOfItemLabel: UILabel!

    @IBOutlet private weak var unitLabel: UILabel!

    @IBOutlet private weak var salesFloorTypeButton: UIButton!

    @IBAction private func salesFloorTypeButton(_ sender: Any) {
    }

    @IBOutlet private weak var supplementLabel: UILabel!

    @IBOutlet private weak var photoPathImageView: UIImageView!

    private var isChecked:Bool = false

    private var itemImage:UIImage? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        setAppearanceSalesFloorTypeButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var errandDataList: Array<ErrandDataModel> = []

    //SalesFloorTypeButtonの文字の色、角丸、文字の縮小、縮小率、１行で表示を設定
    private func setAppearanceSalesFloorTypeButton() {
        salesFloorTypeButton.setTitleColor(.black, for: .normal)
        salesFloorTypeButton.layer.cornerRadius = 10.0
        salesFloorTypeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        salesFloorTypeButton.titleLabel?.minimumScaleFactor = 0.5 // 縮小率を指定する
        salesFloorTypeButton.titleLabel?.numberOfLines = 1
    }

    // 買い物リストのデータをセルの各パーツにセットする
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

    // isCheckBoxのオンオフによってバックグラウンドカラーを変更する
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

    // cellのsalesFloorTypeButtonに売り場の内容を反映させる
    func setSalesFloorTypeButton(salesFloorRawValue: Int) {
        let salesFloor = SalesFloorType(rawValue: salesFloorRawValue)
        salesFloorTypeButton.setTitle(salesFloor?.nameOfSalesFloor, for: .normal)
        salesFloorTypeButton.backgroundColor = salesFloor?.colorOfSalesFloor
    }

    // cellのsetPhotoPathImageViewに内容を反映させる
    func setPhotoPathImageView(image: UIImage?) {
        if image == nil {
            photoPathImageView.image = image
        } else {
            let resizedImage = image?.resize(to: CGSize(width: 50, height: 50))
            photoPathImageView.image = resizedImage
        }
    }

    // cellのsetSupplementLabelに内容を反映させる
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

protocol ShoppingListTableViewCellDelegate: AnyObject {
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController)
}


