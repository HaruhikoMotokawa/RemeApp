//
//  SalesFloorShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/02.
//

import UIKit

/// D-売り場の買い物リスト
class SalesFloorShoppingListViewController: UIViewController {

    // MARK: - @IBOutlet
    /// 売り場の買い物リストを表示
    @IBOutlet private weak var shoppingListTableView: UITableView!

    // MARK: - property

    /// 売り場のRawValue受け渡し用
    internal var salesFloorRawValue: Int = 0
    /// ユーザーが作成した買い物データを格納する配列
    private var myShoppingItemList: [ShoppingItemModel] = []
    /// 共有相手が作成した買い物データを格納する配列
    private var otherShoppingItemList: [ShoppingItemModel] = []
    /// 自分と相手のshoppingコレクションのドキュメント配列を合わせた配列
    private var allShoppingItemList: [ShoppingItemModel] = []

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNetWorkObserver()
        setTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMyShoppingItemObserver()
        setOtherShoppingItemObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeShoppingItemObserver()
    }
    // MARK: - func

    /// ネットワーク関連の監視の登録
    private func setNetWorkObserver() {
        // NotificationCenterに通知を登録する
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatusDidChange),
                                               name: .networkStatusDidChange, object: nil)
    }

    /// オフライン時の処理
    @objc func handleNetworkStatusDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            // ネットワーク状況が変わったらTableViewを再読み込み
            self.shoppingListTableView.reloadData()
        }
    }

    /// 自分と共有者の買い物リストを結合させて並び替えるメソッド
    private func combineShoppingItems() {
        allShoppingItemList = myShoppingItemList + otherShoppingItemList
        sortShoppingItemList()
    }
    /// 自分の買い物リストの変更を監視、データを受け取り表示を更新する
    private func setMyShoppingItemObserver() {
        IndicatorController.shared.startIndicator()
        let uid = AccountManager.shared.getAuthStatus()
        FirestoreManager.shared.getMyShoppingItemObserverSearchSalesFloor(
            uid: uid,
            salesFloorRawValue: salesFloorRawValue,
            completion: { [weak self] itemList in
                guard let self else { return }
                print("自分の買い物リストの取得を開始")
                self.myShoppingItemList = itemList
                self.combineShoppingItems()
                IndicatorController.shared.dismissIndicator()
            })
    }
    /// 共有者の買い物リストの変更を監視、データを受け取り表示を更新する
    private func setOtherShoppingItemObserver()  {
        IndicatorController.shared.startIndicator()
        let uid = AccountManager.shared.getAuthStatus()
        FirestoreManager.shared.getOtherShoppingItemObserverSearchSalesFloor(
            uid: uid,
            salesFloorRawValue: salesFloorRawValue,
            completion: { [weak self] itemList in
                guard let self else { return }
                print("他人の買い物リストの取得を開始")
                self.otherShoppingItemList = itemList
                self.combineShoppingItems()
                IndicatorController.shared.dismissIndicator()
            })
    }

    /// 買い物リストに関するオブザーバーを廃棄する
    private func removeShoppingItemObserver() {
        FirestoreManager.shared.removeShoppingItemObserver(
            listener: &FirestoreManager.shared.salesFloorShoppingListMyItemListener) // 自分のオブザーバを廃棄
        FirestoreManager.shared.removeShoppingItemObserver(
            listener: &FirestoreManager.shared.salesFloorMapOtherItemListener) // 他人のオブザーバーを廃棄
    }

    /// cellをチェックがオフのものを一番上に、かつ売り場の順に並び替える
    private func sortShoppingItemList() {
        allShoppingItemList = allShoppingItemList.sorted { (a, b) -> Bool in
            if a.isCheckBox != b.isCheckBox {
                return !a.isCheckBox
            } else {
                return a.salesFloorRawValue < b.salesFloorRawValue
            }
        }
        shoppingListTableView.reloadData()
    }

    /// 全てのセルがチェックされている場合にアラートを表示、OKをタップして一つ前の画面に戻る
    private func completionSalesFloorAlert() {
        if allShoppingItemList.allSatisfy({ $0.isCheckBox }) {
            let alertController = UIAlertController(title: "この売り場の買い物が完了しました！", message: nil,
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    /// salesFloorShoppingListTableView関連の設定
    private func setTableView() {
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil),
                                                 forCellReuseIdentifier: "ShoppingListTableViewCell")
    }

}

// MARK: - UITableViewDataSource&Delegate
extension SalesFloorShoppingListViewController: UITableViewDataSource, UITableViewDelegate {
    /// salesFloorShoppingListTableViewに表示するcell数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allShoppingItemList.count
    }
    /// salesFloorShoppingListTableViewに使用するcellの内容を指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = shoppingListTableView.dequeueReusableCell(
            withIdentifier: "ShoppingListTableViewCell", for: indexPath) as? ShoppingListTableViewCellController {
            cell.delegate = self
            let myData: ShoppingItemModel = allShoppingItemList[indexPath.row]
            if myData.photoURL.isEmpty { // 画像データがないセルの表示内容
                cell.setShoppingList(isCheckBox: myData.isCheckBox,
                                     nameOfItem: myData.nameOfItem,
                                     numberOfItem: myData.numberOfItem,
                                     unit: myData.unit,
                                     salesFloorRawValue: myData.salesFloorRawValue,
                                     supplement: myData.supplement,
                                     image: nil) // imageはnil
            } else { // 画像がある場合
                let primaryImage = UIImage(systemName: "photo.artframe") // 一旦仮表示のイメージ設置
                cell.setShoppingList(isCheckBox: myData.isCheckBox,
                                     nameOfItem: myData.nameOfItem,
                                     numberOfItem: myData.numberOfItem,
                                     unit: myData.unit,
                                     salesFloorRawValue: myData.salesFloorRawValue,
                                     supplement: myData.supplement,
                                     image: primaryImage)
                // 写真データをダウンロードまたはキャッシュから取得
                Cache.shared.getImage(photoURL: myData.photoURL) { [weak self] image in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        if let cell = self.shoppingListTableView.cellForRow(
                            at: indexPath) as? ShoppingListTableViewCellController {
                            cell.setShoppingList(isCheckBox: myData.isCheckBox,
                                                 nameOfItem: myData.nameOfItem,
                                                 numberOfItem: myData.numberOfItem,
                                                 unit: myData.unit,
                                                 salesFloorRawValue: myData.salesFloorRawValue,
                                                 supplement: myData.supplement,
                                                 image: image )
                        }
                    }
                }
            }
            return cell
        }
        return UITableViewCell()
    }

    /// salesFloorShoppingListTableViewのcellがタップされた時の挙動を定義
    /// - タップされた商品のデータをdetailShoppingListViewControllerに渡す
    /// - detailShoppingListViewControllerにモーダル遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailShoppingListView", bundle: nil)
        let detailShoppingListVC = storyboard.instantiateViewController(
            withIdentifier: "DetailShoppingListView") as! DetailShoppingListViewController
        let shoppingItemData = allShoppingItemList[indexPath.row]
        Cache.shared.getImage(photoURL: shoppingItemData.photoURL) { image in
            detailShoppingListVC.configurer(detail: shoppingItemData, image: image)
        }
        shoppingListTableView.deselectRow(at: indexPath, animated: true)
        detailShoppingListVC.modalTransitionStyle = .crossDissolve // フェードイン・アウトのアニメーション
        self.present(detailShoppingListVC, animated: true)
    }
}

// MARK: - ShoppingListTableViewCellDelegate
// cell内のチェックボックスをタップした際の処理
extension SalesFloorShoppingListViewController: ShoppingListTableViewCellDelegate {
    /// cell内のチェックボックスをタップした際の処理
    /// - チェックしたものは下に移動する
    /// - 全てのチェックがついたらアラートを出す
    /// - テーブルビューを再読み込みして表示する
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController) async {
        // 操作中のcellの行番号を取得
        guard let indexPath = shoppingListTableView.indexPath(for: cell) else { return }
        // 指定されたセルのisCheckBoxのBool値を反転させる
        let isChecked = !allShoppingItemList[indexPath.row].isCheckBox
        // 変更対象のデータのドキュメントIDを取得
        let targetID = allShoppingItemList[indexPath.row].id
        // targetIDと同じmyShoppingItemListのidが収納されているセルのインデックス番号を取得
        if let targetItemIndex = self.allShoppingItemList.firstIndex(where: { $0.id == targetID }) {
            // 対象のアイテムが見つかった場合、そのアイテムのisCheckBoxを更新する
            self.allShoppingItemList[targetItemIndex].isCheckBox = isChecked
        }
        // 全てがチェックされたらアラートを出す
        completionSalesFloorAlert()
        Task { @MainActor in
            // FirestoreにisCheckedだけ書き込み
            do {
                try await FirestoreManager.shared.upDateItemForIsChecked(documentID: targetID, isChecked: isChecked)
            } catch {
                print("エラー")
            }
        }
    }
}
