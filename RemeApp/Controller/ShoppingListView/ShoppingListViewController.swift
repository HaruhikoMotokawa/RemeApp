//
//  ShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/[03/20.]
//
import UIKit
import RealmSwift

/// A-買い物リスト
class ShoppingListViewController: UIViewController {

    // MARK: - @IBOutlet
    /// 買い物リストを表示する
    @IBOutlet private weak var shoppingListTableView: UITableView!

    // MARK: - property
    /// 買い物リストに表示するお使いデータのダミーデータ
    private var errandDataList: [ErrandDataModel] = []

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "ShoppingListTableViewCell")

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .reloadTableView, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setErrandData()
        shoppingListTableView.reloadData()
        sortErrandDataList()
    }
    // MARK: - func

    /// 保存されたお使いデータをセットする
    func setErrandData() {
        let realm = try! Realm()
        let result = realm.objects(ErrandDataModel.self)
        errandDataList = Array(result)
    }

    /// EditSalesFloorMapViewControllerのchangeSalesFloorMapメソッドからNotificationCenterの受信を受けた時の処理
    @objc func reloadTableView() {
        shoppingListTableView.reloadData()
    }

    /// cellをチェックがオフのものを一番上に、かつ売り場の順に並び替える
    /// - NotificationCenterの受診をセット
    /// - UserDefaultsに使用するキーを指定
    /// - UserDefaultsから設定を取得
    /// -  画面ローディング時の表示をif文で切り替え
    /// - 買い物開始位置が左回り設定の場合 -> cellをチェックがオフのものを一番上に、かつ売り場を降順に並び替える
    /// - 買い物開始位置が右回り設定の場合 -> ellをチェックがオフのものを一番上に、かつ売り場を昇順に並び替える
    private func sortErrandDataList() {
        NotificationCenter.default.addObserver(self, selector: #selector(sortLeftErrandDataList),
                                               name: .sortLeftErrandDataList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sortRightErrandDataList),
                                               name: .sortRightErrandDataList, object: nil)
        let shoppingStartPositionKey = "shoppingStartPositionKey"
        let shoppingStartPositionInt = UserDefaults.standard.integer(forKey: shoppingStartPositionKey)
        if shoppingStartPositionInt == 0 {
            sortLeftErrandDataList()
        } else {
            sortRightErrandDataList()
        }
    }

    /// NotificationCenterによって買い物ルートを左回りに選択された場合の買い物リストを並び替える
    /// - cellをチェックがオフのものを一番上に、かつ売り場を降順に並び替える
    /// - shoppingListTableViewを再読み込み
    @objc func sortLeftErrandDataList() {
        errandDataList = errandDataList.sorted { (a, b) -> Bool in
            if a.isCheckBox != b.isCheckBox {
                return !a.isCheckBox
            } else {
                return a.salesFloorRawValue > b.salesFloorRawValue
            }
        }
        shoppingListTableView.reloadData()
    }

    /// NotificationCenterによって買い物ルートを右回りに選択された場合の買い物リストを並び替える
    /// - cellをチェックがオフのものを一番上に、かつ売り場を昇順に並び替える
    /// - shoppingListTableViewを再読み込み
    @objc func sortRightErrandDataList() {
        errandDataList = errandDataList.sorted { (a, b) -> Bool in
            if a.isCheckBox != b.isCheckBox {
                return !a.isCheckBox
            } else {
                return a.salesFloorRawValue < b.salesFloorRawValue
            }
        }
        shoppingListTableView.reloadData()
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

// MARK: - UITableViewDataSource&Delegate
extension ShoppingListViewController: UITableViewDataSource, UITableViewDelegate {
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
                                 image: errandDataModel.getImage())
            return cell
        }
        return UITableViewCell()
    }

    /// shoppingListTableViewのcellがタップされた時の挙動を定義
    /// - タップされた商品のデータをdetailShoppingListViewControllerに渡す
    /// - detailShoppingListViewControllerにプッシュ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailShoppingListView", bundle: nil)
        let detailShoppingListViewController = storyboard.instantiateViewController(
            withIdentifier: "DetailShoppingListView") as! DetailShoppingListViewController
        let errandData = errandDataList[indexPath.row]
        detailShoppingListViewController.configurer(detail: errandData)
        shoppingListTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(detailShoppingListViewController, animated: true)
    }
}

// MARK: - ShoppingListTableViewCellDelegate
// cell内のチェックボックスをタップした際の処理
extension ShoppingListViewController: ShoppingListTableViewCellDelegate {
    /// cell内のチェックボックスをタップした際の処理
    /// - チェックしたものは下に移動する
    /// - 全てのチェックがついたらアラートを出す
    /// - テーブルビューを再読み込みして表示する
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController) {
        guard let indexPath = shoppingListTableView.indexPath(for: cell) else { return }
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
        completionAlert()
        shoppingListTableView.reloadData()
    }
}



