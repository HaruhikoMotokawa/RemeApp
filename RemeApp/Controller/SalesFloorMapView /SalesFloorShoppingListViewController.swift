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
    private var errandDataList: [ErrandDataModel] = []

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

    private func setSelectedErrandDataList(salesFloorRawValue: Int) {
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
        salesFloorShoppingListTableView.reloadData()
    }

    /// 全てのセルがチェックされている場合にアラートを表示、OKをタップして一つ前の画面に戻る
    private func completionSalesFloorAlert() {
        if errandDataList.allSatisfy({ $0.isCheckBox }) {
            let alertController = UIAlertController(title: "この売り場の買い物が完了しました！", message: nil,
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
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
    /// - detailShoppingListViewControllerにモーダル遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailShoppingListView", bundle: nil)
        let detailShoppingListViewController = storyboard.instantiateViewController(
            withIdentifier: "DetailShoppingListView") as! DetailShoppingListViewController
        let errandData = errandDataList[indexPath.row]
        detailShoppingListViewController.configurer(detail: errandData)
        salesFloorShoppingListTableView.deselectRow(at: indexPath, animated: true)
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
        try! realm.commitWrite()

        // タップされたcellだけにアニメーションを実行する
        UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionCrossDissolve], animations: {
            // cellをリロードする
            self.salesFloorShoppingListTableView.reloadRows(at: [indexPath], with: .fade)
            if isChecked {
                // 一番下にあるisCheckBoxがfalseのcellのindexPathを取得する
                var lastUncheckedRowIndex: Int?
                // self.errandDataListという配列の中身を順番に取り出し、各要素に対して指定した処理を行う
                for (index, errandData) in self.errandDataList.enumerated() {
                    // !errandData.isCheckBoxかつindex < indexPath.rowの場合に、lastUncheckedRowIndexにindexが代入されます
                    if !errandData.isCheckBox && index < indexPath.row {
                        lastUncheckedRowIndex = index
                    }
                }
                // 移動するcellの範囲が決定したら、移動する
                guard let lastRow = lastUncheckedRowIndex else { return }

                if lastRow < indexPath.row {
                    // indexPath.rowからlastRowまでの範囲で、-1ずつ値を減少させながらループを実行する
                    for i in stride(from: indexPath.row, to: lastRow, by: -1) {
                        // iとi-1の要素を入れ替える
                        self.errandDataList.swapAt(i, i - 1)
                    }
                    // 指定されたindexPathの行を、別のindexPathの行に移動する
                    self.salesFloorShoppingListTableView.moveRow(at: indexPath, to: IndexPath(row: lastRow, section: 0))
                }
            }
        }, completion: nil)
        sortErrandDataList()
        completionSalesFloorAlert()
    }
}

