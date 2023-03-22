//
//  ShoppingListTableViewCellController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/22.
//

import UIKit

class ShoppingListTableViewCellController: UITableViewCell {


    @IBOutlet weak var isCheckBoxButton: UIButton!


    @IBOutlet weak var nameOfItemLabel: UILabel!


    @IBOutlet weak var numberOfItemLabel: UILabel!


    @IBOutlet weak var unitLabel: UILabel!



    @IBOutlet weak var SalesFloorTypeButton: UIButton!


    @IBOutlet weak var supplementLabel: UILabel!


    @IBOutlet weak var photoPathLabel: UIImageView!

    var errandDataList: Array<ErrandDataModel> = []

    func setShoppingList(isCheckBox: Bool, nameOfItem: String, numberOfItem: String,
                         unit: String, salesFloorRawValue:Int ,supplement: String?,
                         photoPath: String?) {
        // ここにisCeckBox

        nameOfItemLabel.text = nameOfItem
        numberOfItemLabel.text = numberOfItem
        unitLabel.text = unit

    }
}
