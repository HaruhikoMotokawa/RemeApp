//
//  SalesFloorShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/02.
//

import UIKit
import RealmSwift

/// D-売り場の買い物リスト
class SalesFloorShoppingListViewController: UIViewController {

    // MARK: - @IBOutlet
    /// 売り場の買い物リストを表示
    @IBOutlet private weak var salesFloorShoppingListTableView: UITableView!

    // MARK: - property
    /// お使いデータ
    var errandDataList: [ErrandDataModel] = []

    var salesFloorRawValue: Int = 0

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        salesFloorShoppingListTableView.dataSource = self
        salesFloorShoppingListTableView.delegate = self
        salesFloorShoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil),
                                                 forCellReuseIdentifier: "ShoppingListTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSelectedErrandDataList(salesFloorRawValue: salesFloorRawValue)
        sortErrandDataList()
        salesFloorShoppingListTableView.reloadData()
    }

    // MARK: - func

    func setSelectedErrandDataList(salesFloorRawValue: Int) {
        let realm = try! Realm()
        let result = realm.objects(ErrandDataModel.self)
        errandDataList = Array(result.filter { $0.salesFloorRawValue == salesFloorRawValue })
    }

    /// cellをチェックがオフのものを一番上に、かつ売り場の順に並び替える
    private func sortErrandDataList() {
        errandDataList = errandDataList.sorted { (a, b) -> Bool in
            if a.isCheckBox != b.isCheckBox {
                return !a.isCheckBox
            } else {
                return a.salesFloorRawValue < b.salesFloorRawValue
            }
        }
    }

    /// 全てのセルがチェックされている場合にアラートを表示する
    private func completionSalesFloorAlert() {
        if errandDataList.allSatisfy({ $0.isCheckBox }) {
            let alertController = UIAlertController(title: "この売り場の買い物が完了しました！", message: nil,
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }

}

// MARK: - UITableViewDataSource&Delegate
extension SalesFloorShoppingListViewController: UITableViewDataSource, UITableViewDelegate {
    /// salesFloorShoppingListTableViewに表示するcell数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errandDataList.count
    }
    /// salesFloorShoppingListTableViewに使用するcellの内容を指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = salesFloorShoppingListTableView.dequeueReusableCell(
            withIdentifier: "ShoppingListTableViewCell", for: indexPath) as? ShoppingListTableViewCellController {
            cell.delegate = self
            let errandDataModel: ErrandDataModel = errandDataList[indexPath.row]
            cell.setShoppingList(isCheckBox: errandDataModel.isCheckBox,
                                 nameOfItem: errandDataModel.nameOfItem,
                                 numberOfItem: errandDataModel.numberOfItem,
                                 unit: errandDataModel.unit,
                                 salesFloorRawValue: errandDataModel.salesFloorRawValue,
                                 supplement: errandDataModel.supplement,
                                 image: errandDataModel.getImage())
            return cell
        }
        return UITableViewCell()
    }

    /// salesFloorShoppingListTableViewのcellがタップされた時の挙動を定義
    /// - タップされた商品のデータをdetailShoppingListViewControllerに渡す
    /// - detailShoppingListViewControllerにプッシュ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailShoppingListView", bundle: nil)
        let detailShoppingListViewController = storyboard.instantiateViewController(
            withIdentifier: "DetailShoppingListView") as! DetailShoppingListViewController
        let errandData = errandDataList[indexPath.row]
        detailShoppingListViewController.configurer(detail: errandData)
        salesFloorShoppingListTableView.deselectRow(at: indexPath, animated: true)
        detailShoppingListViewController.modalPresentationStyle = .overCurrentContext // 重なり合うように表示
        detailShoppingListViewController.modalTransitionStyle = .crossDissolve // フェードイン・アウトのアニメーション
        self.present(detailShoppingListViewController, animated: true)
    }
}

// MARK: - ShoppingListTableViewCellDelegate
// cell内のチェックボックスをタップした際の処理
extension SalesFloorShoppingListViewController: ShoppingListTableViewCellDelegate {
    /// cell内のチェックボックスをタップした際の処理
    /// - チェックしたものは下に移動する
    /// - 全てのチェックがついたらアラートを出す
    /// - テーブルビューを再読み込みして表示する
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController) {
        guard let indexPath = salesFloorShoppingListTableView.indexPath(for: cell) else { return }
        let isChecked = !errandDataList[indexPath.row].isCheckBox
        // Realmのトランザクションを開始
        let realm = try! Realm()
        realm.beginWrite()
        errandDataList[indexPath.row].isCheckBox = isChecked
        realm.add(errandDataList[indexPath.row], update: .modified)
        do {
            try realm.commitWrite()
        } catch {
            print("Error committing write transaction: \\(error)")
        }
        sortErrandDataList()
        completionSalesFloorAlert()
        salesFloorShoppingListTableView.reloadData()
    }
}

