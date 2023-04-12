//
//  EditShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit

/// F-買い物リスト編集
class EditShoppingListViewController: UIViewController {

    @IBOutlet weak var editShoppingListTableView: UITableView!

    @IBOutlet weak var shareShoppingListButton: UIButton!

    @IBAction func shareShoppingList(_ sender: Any) {
    }

    @IBOutlet weak var createNewItemButton: UIButton!
    @IBAction func goCreateNewItemView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreateNewItemView", bundle: nil)
        let createNewItemVC = storyboard.instantiateViewController(withIdentifier: "CreateNewItemView") as! CreateNewItemViewController
        self.present(createNewItemVC, animated: true)
    }

    /// お使いデータ
    var errandDataList: [ErrandDataModel] = [ErrandDataModel(isCheckBox: false ,nameOfItem: "あそこで売ってるうまいやつ", numberOfItem: "１０" ,unit: "パック", salesFloorRawValue: 6, supplement: nil, photoImage: nil),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "牛肉", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 7, supplement:  "総量５００gくらい", photoImage:UIImage(named: "beef")),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "おいしい牛乳", numberOfItem: "2" ,unit: "本", salesFloorRawValue: 14, supplement: nil, photoImage:UIImage(named: "milk")),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "卵", numberOfItem: "１" ,unit: "パック", salesFloorRawValue: 15, supplement: "なるべく賞味期限長いもの", photoImage: nil),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "スタバのカフェラテっぽいやつ", numberOfItem: "１０" ,unit: "個", salesFloorRawValue: 12, supplement: nil, photoImage: nil),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "マクドのいちごシェイク", numberOfItem: "１" ,unit: "個", salesFloorRawValue: 15, supplement: "子供用のストローをもらってきてください。", photoImage: nil),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "玉ねぎ", numberOfItem: "３" ,unit: "個", salesFloorRawValue: 0, supplement: nil, photoImage:UIImage(named: "onion")),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "カラフルゼリー５種", numberOfItem: "５" ,unit: "袋", salesFloorRawValue: 9, supplement: "種類が沢山入ってるやつ", photoImage:UIImage(named: "jelly")),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "インスタントコーヒー", numberOfItem: "２" ,unit: "袋", salesFloorRawValue: 11, supplement: "詰め替えよう", photoImage:UIImage(named: "coffee"))]

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        editShoppingListTableView.dataSource = self
        editShoppingListTableView.delegate = self
        editShoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "ShoppingListTableViewCell")
        sortErrandDataList()
        setAppearance(shareShoppingListButton)
        setAppearance(createNewItemButton)
    }

    /// ボタンの背景色を変更するメソッド
    ///- 背景色を灰色に設定
    ///- 背景を角丸２０に設定
    ///- tintColorを黒に設定
    ///- 影を追加
    private func setAppearance(_ button: UIButton) {
        button.backgroundColor = .gray
        button.layer.cornerRadius = 20
        button.tintColor = .black
        button.addShadow()
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
}

extension EditShoppingListViewController: UITableViewDataSource, UITableViewDelegate {
    /// shoppingListTableViewに表示するcell数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errandDataList.count
    }
    /// shoppingListTableViewに使用するcellの内容を指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = editShoppingListTableView.dequeueReusableCell(
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

    /// editShoppingListTableViewのcellがタップされた時の挙動を定義
    /// - タップされた商品のデータをEditItemViewに渡す
    /// - EditItemViewにプッシュ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "EditItemView", bundle: nil)
        let editItemVC = storyboard.instantiateViewController(
            withIdentifier: "EditItemView") as! EditItemViewController
        let errandData = errandDataList[indexPath.row]
        editItemVC.configurer(detail: errandData)
        editShoppingListTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(editItemVC, animated: true)
    }

    /// スワイプして削除する処理
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
    UISwipeActionsConfiguration? {
        let destructiveAction = UIContextualAction(style: .destructive, title: "削除") {
            (action, view, completionHandler) in
            self.errandDataList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        destructiveAction.image = UIImage(systemName: "trash.fill")
        let configuration = UISwipeActionsConfiguration(actions: [destructiveAction])
        return configuration
    }
}

// cell内のチェックボックスをタップした際の処理
extension EditShoppingListViewController: ShoppingListTableViewCellDelegate {
    /// cell内のチェックボックスをタップした際の処理
    /// - チェックしたものは下に移動する
    /// - テーブルビューを再読み込みして表示する
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController) {
        guard let indexPath = editShoppingListTableView.indexPath(for: cell) else { return }
        let isChecked = !errandDataList[indexPath.row].isCheckBox
        errandDataList[indexPath.row].isCheckBox = isChecked
        sortErrandDataList()
        editShoppingListTableView.reloadData()
    }
}
