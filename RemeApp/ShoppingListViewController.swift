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
        setErrandData()
    }
    // ダミーデータ表示用
    func setErrandData() {
        for _ in 1...10 {
            let errandDataModel = ErrandDataModel(checkBox: false, nameOfItem: "テスト", numberOfItem: "１" ,unit: "個", salesFloorRawValue: 1)
            errandDataList.append(errandDataModel)
        }
    }
}

extension ShoppingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errandDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let errandDataModel: ErrandDataModel = errandDataList[indexPath.row]
        cell.textLabel?.text = errandDataModel.nameOfItem
        return cell
    }


}
