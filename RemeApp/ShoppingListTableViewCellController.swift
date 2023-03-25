//
//  ShoppingListTableViewCellControllerTableViewCell.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/23.
//

import UIKit

class ShoppingListTableViewCellController: UITableViewCell {



    @IBAction func isCheckBoxButton(_ sender: Any) {
    }

    @IBOutlet weak var nameOfItemLabel: UILabel!



    @IBOutlet weak var numberOfItemLabel: UILabel!


    @IBOutlet weak var unitLabel: UILabel!



    @IBOutlet weak var salesFloorTypeButton: UIButton!
    @IBAction func salesFloorTypeButton(_ sender: Any) {
    }

    @IBOutlet private weak var supplementLabel: UILabel!


    @IBOutlet weak private var photoPathImageView: UIImageView!


    var isChecked:Bool = false
    let checkedImage = UIImage(named: "checkMark")
    let uncheckedImage = UIImage(named: "circle")

    override func awakeFromNib() {
        super.awakeFromNib()


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var errandDataList: Array<ErrandDataModel> = []

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
        salesFloorTypeButton.setTitleColor(.black, for: .normal)
        salesFloorTypeButton.layer.cornerRadius = 10.0
        salesFloorTypeButton.titleLabel?.minimumScaleFactor = 0.5 // 縮小率を指定する
        salesFloorTypeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        salesFloorTypeButton.titleLabel?.numberOfLines = 1
        photoPathImageView.image = image
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

