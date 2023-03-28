//
//  ShoppingListTableViewCellControllerTableViewCell.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/23.
//

import UIKit

class ShoppingListTableViewCellController: UITableViewCell  {



    @IBAction private func isCheckBoxButton(_ sender: Any) {
    }

    @IBOutlet private weak var nameOfItemLabel: UILabel!



    @IBOutlet private weak var numberOfItemLabel: UILabel!


    @IBOutlet weak var unitLabel: UILabel!



    @IBOutlet private weak var salesFloorTypeButton: UIButton!
    @IBAction private func salesFloorTypeButton(_ sender: Any) {
    }

    @IBOutlet private weak var supplementLabel: UILabel!


    @IBOutlet weak var photoPathImageView: UIImageView!



    var isChecked:Bool = false


    override func awakeFromNib() {
        super.awakeFromNib()
        setAppearanceSalesFloorTypeButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var errandDataList: Array<ErrandDataModel> = []

    //SalesFloorTypeButtonの文字の色、角丸、文字の縮小、縮小率、１行で表示を設定
    func setAppearanceSalesFloorTypeButton() {
        salesFloorTypeButton.setTitleColor(.black, for: .normal)
        salesFloorTypeButton.layer.cornerRadius = 10.0
        salesFloorTypeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        salesFloorTypeButton.titleLabel?.minimumScaleFactor = 0.5 // 縮小率を指定する
        salesFloorTypeButton.titleLabel?.numberOfLines = 1

    }

    // 買い物リストのデータをセルにセットする
    func setShoppingList(nameOfItem: String, numberOfItem: String,
                         unit: String, salesFloorRawValue:Int ,supplement: String?,
                         image: UIImage?) {
        // ここにisCheckBox
//        isChecked = isCheckBox
        nameOfItemLabel.text = nameOfItem
        numberOfItemLabel.text = numberOfItem
        unitLabel.text = unit
        let salesFloor = SalesFloorType(rawValue: salesFloorRawValue)
        salesFloorTypeButton.setTitle(salesFloor?.nameOfSalesFloor, for: .normal)
        salesFloorTypeButton.backgroundColor = salesFloor?.colorOfSalesFloor
        if image == nil {
            photoPathImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }else{
            photoPathImageView.translatesAutoresizingMaskIntoConstraints = false
            photoPathImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            photoPathImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            photoPathImageView.image = image
        }
        if supplement == nil {
            return
        } else {
            supplementLabel.textColor = UIColor.gray
            supplementLabel.text = "補足：" + (supplement ?? "")
        }

//        if let photoPath = photoPath {
//             let errandDataModel = ErrandDataModel(photoPath: photoPath)
//            photoPathImageView.image = errandDataModel.getImage()
//        }
    }
}



