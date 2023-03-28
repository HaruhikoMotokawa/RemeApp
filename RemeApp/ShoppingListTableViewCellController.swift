//
//  ShoppingListTableViewCellControllerTableViewCell.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/23.
//

import UIKit

class ShoppingListTableViewCellController: UITableViewCell  {


    weak var delegate: ShoppingListTableViewCellDelegate?
    @IBOutlet weak var checkBoxButton: CheckBox!
    @IBAction private func isCheckBoxButton(_ sender: Any) {
        if checkBoxButton.isChecked == true {
            self.contentView.backgroundColor = UIColor.systemBackground
        } else {
            self.contentView.backgroundColor = UIColor.lightGray
        }
        isChecked = !isChecked

//        errandDataList[indexPath.row].isCheckBox = isChecked
        delegate?.didTapCheckBoxButton(self)
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
    var itemImage:UIImage? = nil

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
    func setShoppingList(isCheckBox: Bool ,nameOfItem: String, numberOfItem: String,
                         unit: String, salesFloorRawValue:Int ,supplement: String?,
                         image: UIImage?) {

        isChecked = isCheckBox
        if isCheckBox == false {
            checkBoxButton.isChecked = false
            self.contentView.backgroundColor = UIColor.systemBackground
        }else{
            checkBoxButton.isChecked = true
            self.contentView.backgroundColor = UIColor.lightGray
        }
        nameOfItemLabel.text = nameOfItem
        numberOfItemLabel.text = numberOfItem
        unitLabel.text = unit
        let salesFloor = SalesFloorType(rawValue: salesFloorRawValue)
        salesFloorTypeButton.setTitle(salesFloor?.nameOfSalesFloor, for: .normal)
        salesFloorTypeButton.backgroundColor = salesFloor?.colorOfSalesFloor
        photoPathImageView.image = image
        if image == nil {
            photoPathImageView.translatesAutoresizingMaskIntoConstraints = false
            photoPathImageView.widthAnchor.constraint(equalToConstant: 50).isActive = false
            photoPathImageView.heightAnchor.constraint(equalToConstant: 50).isActive = false
        }else{
            photoPathImageView.translatesAutoresizingMaskIntoConstraints = false
            photoPathImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            photoPathImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            photoPathImageView.image = image
            photoPathImageView.heightAnchor.constraint(equalToConstant: 50).priority = .defaultHigh // 優先度を変更
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

protocol ShoppingListTableViewCellDelegate: AnyObject {
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController)
}

