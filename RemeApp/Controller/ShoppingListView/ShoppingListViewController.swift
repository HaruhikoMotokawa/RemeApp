//
//  ShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/[03/20.]
//

import UIKit

/// A-買い物リスト
class ShoppingListViewController: UIViewController {

    /// 買い物リストを表示する
    @IBOutlet private weak var shoppingListTableView: UITableView!

    /// 買い物リストに表示するお使いデータのダミーデータ
    private var errandDataList: [ErrandDataModel] =
    [ErrandDataModel(isCheckBox: false ,nameOfItem: "あそこで売ってるうまいやつ", numberOfItem: "１０" ,unit: "パック", salesFloorRawValue: 6, supplement: nil, photoImage: nil),
     ErrandDataModel(isCheckBox: false ,nameOfItem: "牛肉", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 7, supplement:  "総量５００gくらい", photoImage:UIImage(named: "beef")),
     ErrandDataModel(isCheckBox: false ,nameOfItem: "おいしい牛乳", numberOfItem: "2" ,unit: "本", salesFloorRawValue: 14, supplement: nil, photoImage:UIImage(named: "milk")),
     ErrandDataModel(isCheckBox: false ,nameOfItem: "卵", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 15, supplement: "なるべく賞味期限長いもの", photoImage: nil),
     ErrandDataModel(isCheckBox: false ,nameOfItem: "スタバのカフェラテっぽいやつ", numberOfItem: "１０" ,unit: "個", salesFloorRawValue: 12, supplement: nil, photoImage: nil),
     ErrandDataModel(isCheckBox: false ,nameOfItem: "マクドのいちごシェイク", numberOfItem: "１" ,unit: "個", salesFloorRawValue: 15, supplement: "子供用のストローをもらってきてください。", photoImage: nil),
     ErrandDataModel(isCheckBox: false ,nameOfItem: "玉ねぎ", numberOfItem: "３" ,unit: "個", salesFloorRawValue: 0, supplement: nil, photoImage:UIImage(named: "onion")),
     ErrandDataModel(isCheckBox: false ,nameOfItem: "カラフルゼリー５種", numberOfItem: "５" ,unit: "袋", salesFloorRawValue: 9, supplement: "種類が沢山入ってるやつ", photoImage:UIImage(named: "jelly")),
     ErrandDataModel(isCheckBox: false ,nameOfItem: "インスタントコーヒー", numberOfItem: "２" ,unit: "袋", salesFloorRawValue: 11, supplement: "詰め替えよう", photoImage:UIImage(named: "coffee"))]

    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "ShoppingListTableViewCell")
        sortErrandDataList()
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
   private func completionAlert() {
        if errandDataList.allSatisfy({ $0.isCheckBox }) {
            let alertController = UIAlertController(title: "買い物が完了しました！", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension ShoppingListViewController: UITableViewDataSource {
    /// shoppingListTableViewに表示するcell数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errandDataList.count
    }
    /// shoppingListTableViewに使用するcellの内容を指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = shoppingListTableView.dequeueReusableCell(
            withIdentifier: "ShoppingListTableViewCell", for: indexPath) as? ShoppingListTableViewCellController {
            cell.delegate = self
            let errandDataModel: ErrandDataModel = errandDataList[indexPath.row]
            cell.setShoppingList(isCheckBox: errandDataModel.isCheckBox,
                                 nameOfItem: errandDataModel.nameOfItem,
                                 numberOfItem: errandDataModel.numberOfItem,
                                 unit: errandDataModel.unit,
                                 salesFloorRawValue: errandDataModel.salesFloorRawValue,
                                 supplement: errandDataModel.supplement,
                                 image: errandDataModel.photoImage)
            return cell
        }
        return UITableViewCell()
    }
}

extension ShoppingListViewController: UITableViewDelegate {
    /// shoppingListTableViewのcellがタップされた時の挙動を定義
    /// - タップされた商品のデータをdetailShoppingListViewControllerに渡す
    /// - detailShoppingListViewControllerにプッシュ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailShoppingListView", bundle: nil)
        let detailShoppingListViewController = storyboard.instantiateViewController(
            withIdentifier: "DetailShoppingListView") as! DetailShoppingListViewController
        let errandData = errandDataList[indexPath.row]
        detailShoppingListViewController.configurerDetailShoppingListView(detail: errandData)
        shoppingListTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(detailShoppingListViewController, animated: true)
    }
}

// cell内のチェックボックスをタップした際の処理
extension ShoppingListViewController: ShoppingListTableViewCellDelegate {
    /// cell内のチェックボックスをタップした際の処理
    /// - チェックしたものは下に移動する
    /// - 全てのチェックがついたらアラートを出す
    /// - テーブルビューを再読み込みして表示する
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController) {
        guard let indexPath = shoppingListTableView.indexPath(for: cell) else { return }
        let isChecked = !errandDataList[indexPath.row].isCheckBox
        errandDataList[indexPath.row].isCheckBox = isChecked
        sortErrandDataList()
        completionAlert()
        shoppingListTableView.reloadData()
    }
}



