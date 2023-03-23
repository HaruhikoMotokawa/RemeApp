//
//  ShoppingListTableViewCellController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/22.
//

import UIKit

class ShoppingListTableViewCellController: UITableViewCell {


    @IBOutlet weak var isCheckBoxButton: UIButton!

    var isChecked:Bool = false
    let checkedImage = UIImage(named: "checkMark")
    let uncheckedImage = UIImage(named: "circle")
    @IBAction func isCheckBoxButton(_ sender: UIButton) {
        isChecked = !isChecked
        if isChecked {
            sender.setImage(checkedImage, for: .normal)
        } else {
            sender.setImage(uncheckedImage, for: .normal)
        }
    }

    @IBOutlet weak var nameOfItemLabel: UILabel!


    @IBOutlet weak var numberOfItemLabel: UILabel!


    @IBOutlet weak var unitLabel: UILabel!



    @IBOutlet weak var SalesFloorTypeButton: UIButton!


    @IBOutlet weak var supplementLabel: UILabel!


    @IBOutlet weak var photoPathImageView: UIImageView!

    var errandDataList: Array<ErrandDataModel> = []

    func setShoppingList(isCheckBox: Bool, nameOfItem: String, numberOfItem: String,
                         unit: String, salesFloorRawValue:Int ,supplement: String?,
                         photoPath: String?) {
        // ここにisCheckBox
        isChecked = isCheckBox
        nameOfItemLabel.text = nameOfItem
        numberOfItemLabel.text = numberOfItem
        unitLabel.text = unit
        let salesFloor = SalesFloorType(rawValue: salesFloorRawValue)
        SalesFloorTypeButton.setTitle(salesFloor?.nameOfSalesFloor, for: .normal)
        SalesFloorTypeButton.backgroundColor = salesFloor?.colorOfSalesFloor
        SalesFloorTypeButton.setTitleColor(.black, for: .normal)
        SalesFloorTypeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        supplementLabel.text = supplement
        if let photoPath = photoPath {
            let errandDataModel = ErrandDataModel(photoPath: photoPath)
            photoPathImageView.image = errandDataModel.getImage()
        }
    }
}
