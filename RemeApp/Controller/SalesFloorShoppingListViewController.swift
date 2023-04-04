//
//  SalesFloorShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/02.
//

import UIKit

class SalesFloorShoppingListViewController: UIViewController {


    @IBOutlet weak var salesFloorShoppingListTableView: UITableView!

    var errandDataList: [ErrandDataModel] = [ErrandDataModel(isCheckBox: false ,nameOfItem: "あそこで売ってるうまいやつ", numberOfItem: "１０" ,unit: "パック", salesFloorRawValue: 6, supplement: nil, photoImage: nil),
                                                     ErrandDataModel(isCheckBox: false ,nameOfItem: "牛肉", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 7, supplement:  "総量５００gくらい", photoImage:UIImage(named: "beef")),
                                                     ErrandDataModel(isCheckBox: false ,nameOfItem: "おいしい牛乳", numberOfItem: "2" ,unit: "本", salesFloorRawValue: 14, supplement: nil, photoImage:UIImage(named: "milk")),
                                                     ErrandDataModel(isCheckBox: false ,nameOfItem: "卵", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 15, supplement: "なるべく賞味期限長いもの", photoImage: nil),
                                                     ErrandDataModel(isCheckBox: false ,nameOfItem: "スタバのカフェラテっぽいやつ", numberOfItem: "１０" ,unit: "個", salesFloorRawValue: 12, supplement: nil, photoImage: nil),
                                                     ErrandDataModel(isCheckBox: false ,nameOfItem: "マクドのいちごシェイク", numberOfItem: "１" ,unit: "個", salesFloorRawValue: 15, supplement: "子供用のストローをもらってきてください。", photoImage: nil),
                                                     ErrandDataModel(isCheckBox: false ,nameOfItem: "玉ねぎ", numberOfItem: "３" ,unit: "個", salesFloorRawValue: 0, supplement: nil, photoImage:UIImage(named: "onion")),
                                                     ErrandDataModel(isCheckBox: false ,nameOfItem: "カラフルゼリー５種", numberOfItem: "５" ,unit: "袋", salesFloorRawValue: 9, supplement: "種類が沢山入ってるやつ", photoImage:UIImage(named: "jelly")),
                                                     ErrandDataModel(isCheckBox: false ,nameOfItem: "インスタントコーヒー", numberOfItem: "２" ,unit: "袋", salesFloorRawValue: 11, supplement: "詰め替えよう", photoImage:UIImage(named: "coffee"))]

    var setSalesFloorRawValue: Int = 0

     var isCheckBoxContainer:Bool = false
     var nameOfItemContainer:String = ""
     var numberOfItemContainer:String = ""
     var unitLabelContainer:String = ""
     var salesFloorButtonRawValueContainer:Int = 0
     var supplementContainer:String? = nil
     var photoPathImageContainer:UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        sendErrandDataList(salesFloorRawValue: setSalesFloorRawValue)
        salesFloorShoppingListTableView.dataSource = self
        salesFloorShoppingListTableView.delegate = self
        salesFloorShoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListTableViewCell")
        sortErrandDataList()
    }

    // データ受け渡し用のメソッド
    func configurerSalesFloorShoppingListView(detail: ErrandDataModel) {
        isCheckBoxContainer = detail.isCheckBox
        nameOfItemContainer = detail.nameOfItem
        numberOfItemContainer = detail.numberOfItem
        unitLabelContainer = detail.unit
        salesFloorButtonRawValueContainer = detail.salesFloorRawValue
        supplementContainer = detail.supplement
        photoPathImageContainer = detail.photoImage
    }

    // cellをチェックがオフのものを一番上に、かつ売り場の順に並び替える
    func sortErrandDataList() {
        errandDataList = errandDataList.sorted { (a, b) -> Bool in
            if a.isCheckBox != b.isCheckBox {
                return !a.isCheckBox
            } else {
                return a.salesFloorRawValue < b.salesFloorRawValue
            }
        }
    }

    // 全てのセルがチェックされている場合にアラートを表示する
    func completionSalesFloorAlert() {
        if errandDataList.allSatisfy({ $0.isCheckBox }) {
            let alertController = UIAlertController(title: "この売り場の買い物が完了しました！", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    func sendErrandDataList(salesFloorRawValue: Int) {
        let salesFloorList = errandDataList.filter { $0.salesFloorRawValue == salesFloorRawValue }
        print("😃\(salesFloorList)")
    }
}

extension SalesFloorShoppingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errandDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = salesFloorShoppingListTableView.dequeueReusableCell(withIdentifier: "ShoppingListTableViewCell", for: indexPath) as? ShoppingListTableViewCellController {
            cell.delegate = self
            let errandDataModel: ErrandDataModel = errandDataList[indexPath.row]
            cell.setShoppingList(isCheckBox: errandDataModel.isCheckBox,nameOfItem: errandDataModel.nameOfItem, numberOfItem: errandDataModel.numberOfItem, unit: errandDataModel.unit, salesFloorRawValue: errandDataModel.salesFloorRawValue, supplement: errandDataModel.supplement, image: errandDataModel.photoImage)
            return cell
        }
        return UITableViewCell()
    }
}

extension SalesFloorShoppingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailSalesFloorShoppingListView", bundle: nil)
        let detailSalesFloorShoppingListViewController = storyboard.instantiateViewController(withIdentifier: "DetailSalesFloorShoppingListView") as! DetailSalesFloorShoppingListViewController
        let errandData = errandDataList[indexPath.row]
        detailSalesFloorShoppingListViewController.configurerDetailSalesFloorShoppingListView(detail: errandData)
        salesFloorShoppingListTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(detailSalesFloorShoppingListViewController, animated: true)
    }
}

extension SalesFloorShoppingListViewController: ShoppingListTableViewCellDelegate {
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController) {
        guard let indexPath = salesFloorShoppingListTableView.indexPath(for: cell) else { return }
        let isChecked = !errandDataList[indexPath.row].isCheckBox
        errandDataList[indexPath.row].isCheckBox = isChecked
        sortErrandDataList()
        completionSalesFloorAlert()
        salesFloorShoppingListTableView.reloadData()
    }
}
