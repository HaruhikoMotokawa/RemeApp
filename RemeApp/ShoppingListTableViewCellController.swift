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

    var isChecked:Bool = false
    let checkedImage = UIImage(named: "checkMark")
    let uncheckedImage = UIImage(named: "circle")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var errandDataList: Array<ErrandDataModel> = []

    func setShoppingList(nameOfItem: String, numberOfItem: String,
                         unit: String, salesFloorRawValue:Int ,supplement: String?,
                         photoPath: String?) {
        // ここにisCheckBox
//        isChecked = isCheckBox
        nameOfItemLabel.text = nameOfItem
        numberOfItemLabel.text = numberOfItem
        unitLabel.text = unit
        let salesFloor = SalesFloorType(rawValue: salesFloorRawValue)
        salesFloorTypeButton.setTitle(salesFloor?.nameOfSalesFloor, for: .normal)
        salesFloorTypeButton.backgroundColor = salesFloor?.colorOfSalesFloor
        salesFloorTypeButton.setTitleColor(.black, for: .normal)
        salesFloorTypeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        supplementLabel.text = supplement
//        if let photoPath = photoPath {
//            let errandDataModel = ErrandDataModel(photoPath: photoPath)
//            photoPathImageView.image = errandDataModel.getImage()
//        }
    }
    
}
