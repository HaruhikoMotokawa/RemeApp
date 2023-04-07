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
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "インスタントコーヒー", numberOfItem: "２" ,unit: "袋", salesFloorRawValue: 11, supplement: "詰め替えよう", photoImage:UIImage(named: "coffee")),
                                             ErrandDataModel(isCheckBox: false ,nameOfItem: "０１２３４５６７８９０１２３４５６７８９", numberOfItem: "２０" ,unit: "グラム", salesFloorRawValue: 3, supplement: "０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９", photoImage:nil)]

    override func viewDidLoad() {
        super.viewDidLoad()
        editShoppingListTableView.dataSource = self
        editShoppingListTableView.delegate = self
        editShoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "ShoppingListTableViewCell")
        sortErrandDataList()
        setAppearanceButton(button: shareShoppingListButton)
        setAppearanceButton(button: createNewItemButton)
    }

    /// ボタンの背景色を変更するメソッド
    private func setAppearanceButton(button: UIButton) {
        button.backgroundColor = .gray
        button.layer.cornerRadius = 20
        button.tintColor = .black
        addShadow(to: button)
    }

    /// UIButtonに影をつけるメソッド
    private func addShadow(to button: UIButton) {
        // 影の色
        button.layer.shadowColor = UIColor.black.cgColor
        // 影の透明度
        button.layer.shadowOpacity = 0.5
        // 影のオフセット、影の位置
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        // 影の半径
        button.layer.shadowRadius = 2
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

extension EditShoppingListViewController: UITableViewDataSource {
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
}

// TODO: 画面遷移作が買い物リスト詳細になっているので、いずれ変更する
extension EditShoppingListViewController: UITableViewDelegate {
    /// shoppingListTableViewのcellがタップされた時の挙動を定義
    /// - タップされた商品のデータをdetailShoppingListViewControllerに渡す
    /// - detailShoppingListViewControllerにプッシュ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailShoppingListView", bundle: nil)
        let detailShoppingListViewController = storyboard.instantiateViewController(
            withIdentifier: "DetailShoppingListView") as! DetailShoppingListViewController
        let errandData = errandDataList[indexPath.row]
        detailShoppingListViewController.configurerDetailShoppingListView(detail: errandData)
        editShoppingListTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(detailShoppingListViewController, animated: true)
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
