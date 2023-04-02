//
//  DetailShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/27.
//

import UIKit

class DetailShoppingListViewController: UIViewController {

    @IBOutlet weak var nameOfItemLabel: UILabel!

    @IBOutlet weak var numberOfItemLabel: UILabel!

    @IBOutlet weak var unitLabel: UILabel!

    @IBOutlet weak var salesFloorTypeButton: UIButton!

    @IBOutlet weak var supplementLabel: UILabel!

    @IBOutlet weak var photoPathImageView: UIImageView!

    var nameOfItemLabelText:String = ""
    var numberOfItemLabelText:String = ""
    var unitLabelText:String = ""
    var salesFloorButtonRawValue:Int = 0
    var supplementLabelText:String? = nil
    var photoPathImage:UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearanceSalesFloorTypeButton()
        displayData()
        self.title = "詳細"
    }

    //SalesFloorTypeButtonの文字の色、角丸、文字の縮小、縮小率、１行で表示を設定
    func setAppearanceSalesFloorTypeButton() {
        salesFloorTypeButton.setTitleColor(.black, for: .normal)
        salesFloorTypeButton.layer.cornerRadius = 10.0
        salesFloorTypeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        salesFloorTypeButton.titleLabel?.minimumScaleFactor = 0.5 // 縮小率を指定する
        salesFloorTypeButton.titleLabel?.numberOfLines = 1
    }

    // データ受け渡し用のメソッド
    func configure(detail: ErrandDataModel) {
        nameOfItemLabelText = detail.nameOfItem
        numberOfItemLabelText = detail.numberOfItem
        unitLabelText = detail.unit
        salesFloorButtonRawValue = detail.salesFloorRawValue
        supplementLabelText = detail.supplement
        photoPathImage = detail.photoImage
    }

    // 受け渡されたデータをそれぞれのUI部品に表示
    func displayData() {
        nameOfItemLabel.text = nameOfItemLabelText
        numberOfItemLabel.text = numberOfItemLabelText
        unitLabel.text = unitLabelText
        setSalesFloorTypeButton(salesFloorButtonRawValue: self.salesFloorButtonRawValue)
        setSupplementLabelText(supplement: supplementLabelText)
        photoPathImageView.image = photoPathImage

    }

    // 受け渡されたデータをSalesFloorTypeButtonに表示
    func setSalesFloorTypeButton(salesFloorButtonRawValue: Int) {
        let salesFloor = SalesFloorType(rawValue: salesFloorButtonRawValue)
        salesFloorTypeButton.setTitle(salesFloor?.nameOfSalesFloor, for: .normal)
        salesFloorTypeButton.backgroundColor = salesFloor?.colorOfSalesFloor
    }

    // 受け渡されたデータをsetSupplementLabelTextに表示
    func setSupplementLabelText(supplement: String? ) {
        if supplementLabelText == nil {
            supplementLabel.textColor = UIColor.gray
            supplementLabel.text = "なし"
        }else{
            supplementLabel.text = supplementLabelText
        }
    }
}
