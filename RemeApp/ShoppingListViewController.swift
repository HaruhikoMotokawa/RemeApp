//
//  ShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var shoppingListTableView: UITableView!

    var errandDataList: [ErrandDataModel] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListTableView.dataSource = self
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListTableViewCell")
        setErrandData()
    }
    // ダミーデータ表示用
    func setErrandData() {
        for _ in 1...10 {
            let errandDataModel = ErrandDataModel(nameOfItem: "あそこで売ってるうまいやつ", numberOfItem: "１０" ,unit: "パック", salesFloorRawValue: 6, supplement: nil, photoPath: nil)
            errandDataList.append(errandDataModel)
        }
    }
}

extension ShoppingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errandDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = shoppingListTableView.dequeueReusableCell(withIdentifier: "ShoppingListTableViewCell", for: indexPath) as? ShoppingListTableViewCellController {
            let errandDataModel: ErrandDataModel = errandDataList[indexPath.row]
            cell.setShoppingList(nameOfItem: errandDataModel.nameOfItem, numberOfItem: errandDataModel.numberOfItem, unit: errandDataModel.unit, salesFloorRawValue: errandDataModel.salesFloorRawValue, supplement: errandDataModel.supplement, photoPath: errandDataModel.photoPath)
            return cell
        }
        return UITableViewCell()
    }

}
