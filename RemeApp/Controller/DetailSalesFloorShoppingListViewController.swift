//
//  DetailSalesFloorShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/04.
//

import UIKit

class DetailSalesFloorShoppingListViewController: UIViewController {

    @IBOutlet weak var nameOfItemLabel: UILabel!

    @IBOutlet weak var numberOfItemLabel: UILabel!

    @IBOutlet weak var unitLabel: UILabel!

    @IBOutlet weak var salesFloorTypeButton: UIButton!

    @IBOutlet weak var supplementLabel: UILabel!

    @IBOutlet weak var photoPathImageView: UIImageView!

    private var nameOfItemLabelText:String = ""
    private var numberOfItemLabelText:String = ""
    private var unitLabelText:String = ""
    private var salesFloorButtonRawValue:Int = 0
    private var supplementLabelText:String? = nil
    private var photoPathImage:UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearanceSalesFloorTypeButton()
        displayData()
        self.title = "詳細"
    }

    //SalesFloorTypeButtonの文字の色、角丸、文字の縮小、縮小率、１行で表示を設定
    private func setAppearanceSalesFloorTypeButton() {
        salesFloorTypeButton.setTitleColor(.black, for: .normal)
        salesFloorTypeButton.layer.cornerRadius = 10.0
        salesFloorTypeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        salesFloorTypeButton.titleLabel?.minimumScaleFactor = 0.5 // 縮小率を指定する
        salesFloorTypeButton.titleLabel?.numberOfLines = 1
    }

    // データ受け渡し用のメソッド
    func configurerDetailSalesFloorShoppingListView(detail: ErrandDataModel) {
        nameOfItemLabelText = detail.nameOfItem
        numberOfItemLabelText = detail.numberOfItem
        unitLabelText = detail.unit
        salesFloorButtonRawValue = detail.salesFloorRawValue
        supplementLabelText = detail.supplement
        photoPathImage = detail.photoImage
    }

    // 受け渡されたデータをそれぞれのUI部品に表示
    private func displayData() {
        nameOfItemLabel.text = nameOfItemLabelText
        numberOfItemLabel.text = numberOfItemLabelText
        unitLabel.text = unitLabelText
        setSalesFloorTypeButton(salesFloorButtonRawValue: self.salesFloorButtonRawValue)
        setSupplementLabelText(supplement: supplementLabelText)
        photoPathImageView.image = photoPathImage

    }

    // 受け渡されたデータをSalesFloorTypeButtonに表示
    private func setSalesFloorTypeButton(salesFloorButtonRawValue: Int) {
        let salesFloor = SalesFloorType(rawValue: salesFloorButtonRawValue)
        salesFloorTypeButton.setTitle(salesFloor?.nameOfSalesFloor, for: .normal)
        salesFloorTypeButton.backgroundColor = salesFloor?.colorOfSalesFloor
    }

    // 受け渡されたデータをsetSupplementLabelTextに表示
    private func setSupplementLabelText(supplement: String? ) {
        if supplementLabelText == nil {
            supplementLabel.textColor = UIColor.gray
            supplementLabel.text = "なし"
        }else{
            supplementLabel.text = supplementLabelText
        }
    }
}
