//
//  ShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/[03/20.]
//

import UIKit

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var shoppingListTableView: UITableView!

    var errandDataList: [ErrandDataModel] = [ErrandDataModel(isCheckBox: false ,nameOfItem: "あそこで売ってるうまいやつ", numberOfItem: "１０" ,unit: "パック", salesFloorRawValue: 6, supplement: nil, photoImage: nil),
                                             ErrandDataModel(isCheckBox: true ,nameOfItem: "牛肉", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 1, supplement:  "総量５００gくらい", photoImage:UIImage(named: "beef")),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "おいしい牛乳", numberOfItem: "2" ,unit: "本", salesFloorRawValue: 0, supplement: nil, photoImage:UIImage(named: "milk")),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "卵", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 3, supplement: "なるべく賞味期限長いもの", photoImage: nil),
                                             ErrandDataModel(isCheckBox: true ,nameOfItem: "スタバのカフェラテっぽいやつ", numberOfItem: "１０" ,unit: "個", salesFloorRawValue: 3, supplement: nil, photoImage: nil),
                                             ErrandDataModel(isCheckBox: true ,nameOfItem: "マクドのいちごシェイク", numberOfItem: "１" ,unit: "個", salesFloorRawValue: 5, supplement: "子供用のストローをもらってきてください。", photoImage: nil),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "玉ねぎ", numberOfItem: "３" ,unit: "個", salesFloorRawValue: 5, supplement: nil, photoImage:UIImage(named: "onion")),
                                             ErrandDataModel(isCheckBox: true ,nameOfItem: "カラフルゼリー５種", numberOfItem: "５" ,unit: "袋", salesFloorRawValue: 12, supplement: "種類が沢山入ってるやつ", photoImage:UIImage(named: "jelly")),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "インスタントコーヒー", numberOfItem: "２" ,unit: "袋", salesFloorRawValue: 5, supplement: "詰め替えよう", photoImage:UIImage(named: "coffee"))]

    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListTableViewCell")
        sortErrandDataList()
    }

    // cellをチェックがオフのものを一番上に、かつ売り場順に並び替える関数
    private func sortErrandDataList() {
        errandDataList = errandDataList.sorted { (a, b) -> Bool in
            if a.isCheckBox != b.isCheckBox {
                return !a.isCheckBox
            } else {
                return a.salesFloorRawValue < b.salesFloorRawValue
            }
        }
    }
}


extension ShoppingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errandDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = shoppingListTableView.dequeueReusableCell(withIdentifier: "ShoppingListTableViewCell", for: indexPath) as? ShoppingListTableViewCellController {
            cell.delegate = self
            let errandDataModel: ErrandDataModel = errandDataList[indexPath.row]
            cell.setShoppingList(isCheckBox: errandDataModel.isCheckBox,nameOfItem: errandDataModel.nameOfItem, numberOfItem: errandDataModel.numberOfItem, unit: errandDataModel.unit, salesFloorRawValue: errandDataModel.salesFloorRawValue, supplement: errandDataModel.supplement, image: errandDataModel.photoImage)
            return cell
        }
        return UITableViewCell()
    }
}

extension ShoppingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailShoppingListView", bundle: nil)
        let detailShoppingListViewController = storyboard.instantiateViewController(withIdentifier: "DetailShoppingListView") as! DetailShoppingListViewController
        let errandData = errandDataList[indexPath.row]
        detailShoppingListViewController.configure(detail: errandData)
        shoppingListTableView.deselectRow(at: indexPath, animated: true)
        self.present(detailShoppingListViewController, animated: true)
    }
}

extension ShoppingListViewController: ShoppingListTableViewCellDelegate {
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController) {
        guard let indexPath = shoppingListTableView.indexPath(for: cell) else { return }
        let isChecked = !errandDataList[indexPath.row].isCheckBox
        errandDataList[indexPath.row].isCheckBox = isChecked
        sortErrandDataList()
        shoppingListTableView.reloadData()
    }
}
