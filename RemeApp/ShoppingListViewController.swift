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
                                             ErrandDataModel(nameOfItem: "豚バラ肉", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 1, supplement:  "総量５００gくらい", photoImage: nil),
                                             ErrandDataModel(nameOfItem: "おいしい牛乳", numberOfItem: "2" ,unit: "本", salesFloorRawValue: 0, supplement: nil, photoImage:UIImage(named: "testImage")),
                                             ErrandDataModel(nameOfItem: "卵", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 3, supplement: "なるべく賞味期限長いもの", photoImage:UIImage(named: "testImage")),
                                             ErrandDataModel(nameOfItem: "スタバのカフェラテっぽいやつ", numberOfItem: "１０" ,unit: "個", salesFloorRawValue: 5, supplement: nil, photoImage: nil),
                                             ErrandDataModel(nameOfItem: "マクドのいちごシェイク", numberOfItem: "１" ,unit: "個", salesFloorRawValue: 5, supplement: "子供用のストローをもらってきてください。", photoImage: nil)]

    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListTableView.dataSource = self
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListTableViewCell")


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
