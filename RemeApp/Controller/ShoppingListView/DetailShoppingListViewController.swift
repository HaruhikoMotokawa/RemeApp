//
//  DetailShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/27.
//

import UIKit
/// B-買い物リスト詳細
class DetailShoppingListViewController: UIViewController {

    // MARK: - @IBOutlet
    /// 商品名を表示
    @IBOutlet private weak var nameOfItemLabel: UILabel!
    /// 必要数を表示
    @IBOutlet private weak var numberOfItemLabel: UILabel!
    /// 必要数の単位を表示
    @IBOutlet private weak var unitLabel: UILabel!
    /// 売り場を表示
    @IBOutlet private weak var salesFloorTypeButton: UIButton!
    /// 補足を表示
    @IBOutlet private weak var supplementLabel: UILabel!
    /// 写真を表示
    @IBOutlet private weak var photoPathImageView: UIImageView!

    // MARK: - property
    /// nameOfItemLabelに表示するテキスト
    private var nameOfItemLabelText:String = ""
    /// numberOfItemLabelに表示するテキスト
    private var numberOfItemLabelText:String = ""
    /// unitLabelに表示するテキスト
    private var unitLabelText:String = ""
    /// salesFloorTypeButtonに表示する売り場の種類を指定するためのRawValue
    private var salesFloorButtonRawValue:Int = 0
    /// supplementLabelに表示するテキスト
    private var supplementLabelText:String? = nil
    /// photoPathImageViewに表示する画像
    private var photoPathImage:UIImage? = nil


    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // UIButtonの基本設定
        salesFloorTypeButton.setAppearance()
        displayData()
        self.title = "詳細"
    }

    // MARK: - func
    /// データ受け渡し用のメソッド
    func configurer(detail: ErrandDataModel) {
        nameOfItemLabelText = detail.nameOfItem
        numberOfItemLabelText = detail.numberOfItem
        unitLabelText = detail.unit
        salesFloorButtonRawValue = detail.salesFloorRawValue
        supplementLabelText = detail.supplement
        photoPathImage = detail.photoImage
    }

    /// 受け渡されたデータをそれぞれのUI部品に表示
    /// - 商品名の表示
    /// - 必要数を表示
    /// - 必要数の単位を表示
    /// - 売り場を表示
    /// - 補足を表示
    /// - 写真を表示
    private func displayData() {
        nameOfItemLabel.text = nameOfItemLabelText
        numberOfItemLabel.text = numberOfItemLabelText
        unitLabel.text = unitLabelText
        setSalesFloorTypeButton(salesFloorButtonRawValue: self.salesFloorButtonRawValue)
        setSupplementLabelText(supplement: supplementLabelText)
        photoPathImageView.image = photoPathImage

    }

    /// 受け渡されたデータをSalesFloorTypeButtonに表示
    /// - 商品名をタイトルに設定
    /// - ボタンの背景色を設定
    private func setSalesFloorTypeButton(salesFloorButtonRawValue: Int) {
        let salesFloor = SalesFloorType(rawValue: salesFloorButtonRawValue)
        salesFloorTypeButton.setTitle(salesFloor?.nameOfSalesFloor, for: .normal)
        salesFloorTypeButton.backgroundColor = salesFloor?.colorOfSalesFloor
    }
    
    /// 受け渡されたデータをsetSupplementLabelTextに表示
    /// - 補足がなければ灰色の文字色で「なし」を表示
    /// - 補足がある場合はそのまま表示
    private func setSupplementLabelText(supplement: String? ) {
        if supplementLabelText == nil {
            supplementLabel.textColor = UIColor.gray
            supplementLabel.text = "なし"
        }else{
            supplementLabel.text = supplementLabelText
        }
    }
}
