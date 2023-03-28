//
//  ShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var shoppingListTableView: UITableView!

    var errandDataList: [ErrandDataModel] = [ErrandDataModel(nameOfItem: "あそこで売ってるうまいやつ", numberOfItem: "１０" ,unit: "パック", salesFloorRawValue: 6, supplement: nil, photoImage: nil),
                                             ErrandDataModel(nameOfItem: "牛肉", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 1, supplement:  "総量５００gくらい", photoImage:UIImage(named: "beef")),
                                             ErrandDataModel(nameOfItem: "おいしい牛乳", numberOfItem: "2" ,unit: "本", salesFloorRawValue: 0, supplement: nil, photoImage:UIImage(named: "milk")),
                                             ErrandDataModel(nameOfItem: "卵", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 3, supplement: "なるべく賞味期限長いもの", photoImage: nil),
                                             ErrandDataModel(nameOfItem: "スタバのカフェラテっぽいやつ", numberOfItem: "１０" ,unit: "個", salesFloorRawValue: 3, supplement: nil, photoImage: nil),
                                             ErrandDataModel(nameOfItem: "マクドのいちごシェイク", numberOfItem: "１" ,unit: "個", salesFloorRawValue: 5, supplement: "子供用のストローをもらってきてください。", photoImage: nil),
                                             ErrandDataModel(nameOfItem: "玉ねぎ", numberOfItem: "３" ,unit: "個", salesFloorRawValue: 5, supplement: nil, photoImage:UIImage(named: "onion")),
                                             ErrandDataModel(nameOfItem: "カラフルゼリー５種", numberOfItem: "５" ,unit: "袋", salesFloorRawValue: 12, supplement: "種類が沢山入ってるやつ", photoImage:UIImage(named: "jelly")),
                                             ErrandDataModel(nameOfItem: "インスタントコーヒー", numberOfItem: "２" ,unit: "袋", salesFloorRawValue: 5, supplement: "詰め替えよう", photoImage:UIImage(named: "coffee"))]

    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListTableView.dataSource = self
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListTableViewCell")
        shoppingListTableView.delegate = self

    }
}


extension ShoppingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errandDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = shoppingListTableView.dequeueReusableCell(withIdentifier: "ShoppingListTableViewCell", for: indexPath) as? ShoppingListTableViewCellController {
            let errandDataModel: ErrandDataModel = errandDataList[indexPath.row]
            cell.setShoppingList(nameOfItem: errandDataModel.nameOfItem, numberOfItem: errandDataModel.numberOfItem, unit: errandDataModel.unit, salesFloorRawValue: errandDataModel.salesFloorRawValue, supplement: errandDataModel.supplement, image: errandDataModel.photoImage)
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
