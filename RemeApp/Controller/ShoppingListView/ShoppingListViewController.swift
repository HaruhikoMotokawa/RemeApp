//
//  ShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/[03/20.]
//
import UIKit
/// A-買い物リスト、継承を禁止するためにfinalキーワードつける
final class ShoppingListViewController: UIViewController {
    // MARK: - @IBOutlet
    /// チュートリアルを表示するボタン
    @IBOutlet private weak var helpButton: UIButton! {
        didSet {
            helpButton.addTarget(self, action: #selector(helpButtonTapped), for: .touchUpInside)
        }
    }

    /// 買い物リストを表示する
    @IBOutlet private weak var shoppingListTableView: UITableView! {
        didSet { // 基本設定関連などはなるべくdidSetにすると見やすい
            shoppingListTableView.dataSource = self
            shoppingListTableView.delegate = self
            // セルの登録などは文字を直接使わずにハードコーディングを避ける
            shoppingListTableView.register(UINib(nibName: ShoppingListTableViewCell.className, bundle: nil),
                                           forCellReuseIdentifier: ShoppingListTableViewCell.className)
        }
    }

    // MARK: - property
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showIntroduction() // 初回起動時のチュートリアル表示
    }
    // MARK: - func
    /// チュートリアル画面へ遷移
    @objc private func helpButtonTapped() {
      Router.shared.showTutorialMenu(from: self)
    }

    /// アプリ初回起動時のチュートリアル画面表示処理
    private func showIntroduction() {
        if !UserDefaults.standard.isIntroductionSeen {
            UserDefaults.standard.isIntroductionSeen = true
            Router.shared.showIntroduction(from: self)
        }
    }

    /// ネットワーク関連の監視の登録
    private func setNetWorkObserver() {
        // NotificationCenterに通知を登録する
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatusDidChange),
                                               name: .networkStatusDidChange, object: nil)
    }

    /// オフライン時の処理
    @objc private func handleNetworkStatusDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            // ネットワーク状況が変わったらTableViewを再読み込み
            self.shoppingListTableView.reloadData()
            // オフラインになったらアラートを出す
            if !NetworkMonitor.shared.isConnected {
                AlertController.showAlert(tittle: "オフラインです",
                                          errorMessage:
            """
            ① 最新の情報が反映されません
            ② 写真データは表示できません
            ③ アカウント関連の操作はできません
            ④ 買い物リストの作成と編集で
            　 写真添付と削除ができません
            ⑤ 買い物リスト作成と編集は
               できますが上限があります
            """)
            }
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
        FirestoreManager.shared.getMyShoppingItemObserver(
            listener: &FirestoreManager.shared.shoppingListMyItemListener,
            uid: uid,
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
        FirestoreManager.shared.getOtherShoppingItemObserver(
            listener: &FirestoreManager.shared.shoppingListOtherItemListener,
            uid: uid,
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
            listener: &FirestoreManager.shared.shoppingListMyItemListener) // 自分のオブザーバを廃棄
        FirestoreManager.shared.removeShoppingItemObserver(
            listener: &FirestoreManager.shared.shoppingListOtherItemListener) // 他人のオブザーバーを廃棄
    }

    /// cellをチェックがオフのものを一番上に、かつ売り場の順に並び替える
    /// - UserDefaultsから設定を取得して画面ローディング時の表示をif文で切り替え
    /// - 買い物開始位置が左回り設定の場合 -> cellをチェックがオフのものを一番上に、かつ売り場を降順に並び替える
    /// - 買い物開始位置が右回り設定の場合 -> ellをチェックがオフのものを一番上に、かつ売り場を昇順に並び替える
    private func sortShoppingItemList() {
        print("並び替え実行")
        if UserDefaults.standard.shoppingStartPosition == ShoppingStartPositionType.left.rawValue {
            sortLeftShoppingItemList()
        } else {
            sortRightShoppingItemList()
        }
    }

    /// 買い物ルートを左回りに選択された場合の買い物リストを並び替える
    /// - cellをチェックがオフのものを一番上に、かつ売り場を降順に並び替える
    /// - shoppingListTableViewを再読み込み
    private func sortLeftShoppingItemList() {
        allShoppingItemList = allShoppingItemList.sorted { (a, b) -> Bool in
            if a.isCheckBox != b.isCheckBox {
                return !a.isCheckBox
            } else {
                return a.salesFloorRawValue > b.salesFloorRawValue
            }
        }
        shoppingListTableView.reloadData()
    }

    /// 買い物ルートを右回りに選択された場合の買い物リストを並び替える
    /// - cellをチェックがオフのものを一番上に、かつ売り場を昇順に並び替える
    /// - shoppingListTableViewを再読み込み
    private func sortRightShoppingItemList() {
        allShoppingItemList = allShoppingItemList.sorted { (a, b) -> Bool in
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
        if allShoppingItemList.allSatisfy({ $0.isCheckBox }) {
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
        return allShoppingItemList.count
    }
    
    /// shoppingListTableViewに使用するcellの内容を指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = shoppingListTableView.dequeueReusableCell(
            withIdentifier: ShoppingListTableViewCell.className, for: indexPath) as? ShoppingListTableViewCell {
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
                            at: indexPath) as? ShoppingListTableViewCell {
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

    /// shoppingListTableViewのcellがタップされた時の挙動を定義
    /// - タップされた商品のデータをdetailShoppingListViewControllerに渡す
    /// - detailShoppingListViewControllerに遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shoppingItemData = allShoppingItemList[indexPath.row]
        shoppingListTableView.deselectRow(at: indexPath, animated: true)
        Router.shared.showDetailShoppingList(from: self, shoppingItemData: shoppingItemData)
    }
}

// MARK: - ShoppingListTableViewCellDelegate
// cell内のチェックボックスをタップした際の処理
extension ShoppingListViewController: ShoppingListTableViewCellDelegate {
    /// cell内のチェックボックスをタップした際の処理
    /// - チェックしたものは下に移動する
    /// - 全てのチェックがついたらアラートを出す
    /// - テーブルビューを再読み込みして表示する
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCell) async {
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
        completionAlert()
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

