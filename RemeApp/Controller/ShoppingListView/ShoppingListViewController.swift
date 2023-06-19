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

    // MARK: - property

    /// チュートリアルを表示するボタン
    @IBOutlet private weak var helpButton: UIButton!

    /// 買い物リストを表示する
    @IBOutlet private weak var shoppingListTableView: UITableView!

    /// 買い物リストに表示するお使いデータのダミーデータ
    private var errandDataList: [ErrandDataModel] = []

    /// ユーザーが作成した買い物データを格納する配列
    private var myShoppingItemList: [ShoppingItemModel] = []


    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setShoppingItemObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setErrandData()
//        sortErrandDataList()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FirestoreManager.shared.removeShoppingItemObserver() // オブザーバを廃棄
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showTutorialPageOnFirstLaunch() // 初回起動時のチュートリアル表示
    }
    // MARK: - func

    /// チュートリアル画面にモーダル遷移
    @IBAction private func goTutorialView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TutorialPageView", bundle: nil)
        let tutorialPageVC = storyboard.instantiateViewController(
            withIdentifier: "TutorialPageView") as! TutorialPageViewController
        tutorialPageVC.modalPresentationStyle = .fullScreen
        self.present(tutorialPageVC, animated: true)
    }

    /// shoppingListTableView関連の設定
    private func setTableView() {
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "ShoppingListTableViewCell")
    }

    /// アプリ初回起動時のチュートリアル画面表示処理
    private func showTutorialPageOnFirstLaunch() {
        let ud = UserDefaults.standard
        let firstLunchKey = "firstLunch"
        if ud.bool(forKey: firstLunchKey) {
            ud.set(false, forKey: firstLunchKey)
            ud.synchronize()
            let storyboard = UIStoryboard(name: "TutorialPageView", bundle: nil)
            let tutorialPageVC = storyboard.instantiateViewController(
                withIdentifier: "TutorialPageView") as! TutorialPageViewController
            tutorialPageVC.modalPresentationStyle = .fullScreen
            self.present(tutorialPageVC, animated: true)
        }
    }

    /// 保存されたお使いデータをセットする
    func setErrandData() {
        let realm = try! Realm()
        let result = realm.objects(ErrandDataModel.self)
        errandDataList = Array(result)
    }

    /// 買い物リストの変更を監視、データを受け取り表示を更新する
    func setShoppingItemObserver() {
        let uid = AccountManager.shared.getAuthStatus()
        FirestoreManager.shared.getShoppingItemObserver(uid: uid, completion: { [weak self] itemList in
            guard let self else { return }
            self.myShoppingItemList = itemList
            print(itemList)
            self.sortMyShoppingItemList()
        })
    }

    /// cellをチェックがオフのものを一番上に、かつ売り場の順に並び替える
    /// - UserDefaultsに使用するキーを指定
    /// - UserDefaultsから設定を取得
    /// -  画面ローディング時の表示をif文で切り替え
    /// - 買い物開始位置が左回り設定の場合 -> cellをチェックがオフのものを一番上に、かつ売り場を降順に並び替える
    /// - 買い物開始位置が右回り設定の場合 -> ellをチェックがオフのものを一番上に、かつ売り場を昇順に並び替える
    private func sortMyShoppingItemList() {
        print("並び替え実行")
        let shoppingStartPositionKey = "shoppingStartPositionKey"
        let shoppingStartPositionInt = UserDefaults.standard.integer(forKey: shoppingStartPositionKey)
        if shoppingStartPositionInt == 0 {
            sortLeftMyShoppingItemList()
        } else {
            sortRightMyShoppingItemList()
        }
    }

    /// 買い物ルートを左回りに選択された場合の買い物リストを並び替える
    /// - cellをチェックがオフのものを一番上に、かつ売り場を降順に並び替える
    /// - shoppingListTableViewを再読み込み
    func sortLeftMyShoppingItemList() {
        myShoppingItemList = myShoppingItemList.sorted { (a, b) -> Bool in
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
    func sortRightMyShoppingItemList() {
        myShoppingItemList = myShoppingItemList.sorted { (a, b) -> Bool in
            if a.isCheckBox != b.isCheckBox {
                return !a.isCheckBox
            } else {
                return a.salesFloorRawValue < b.salesFloorRawValue
            }
        }
        shoppingListTableView.reloadData()
    }
    /// cellをチェックがオフのものを一番上に、かつ売り場の順に並び替える
    /// - UserDefaultsに使用するキーを指定
    /// - UserDefaultsから設定を取得
    /// -  画面ローディング時の表示をif文で切り替え
    /// - 買い物開始位置が左回り設定の場合 -> cellをチェックがオフのものを一番上に、かつ売り場を降順に並び替える
    /// - 買い物開始位置が右回り設定の場合 -> ellをチェックがオフのものを一番上に、かつ売り場を昇順に並び替える
//    private func sortErrandDataList() {
//        let shoppingStartPositionKey = "shoppingStartPositionKey"
//        let shoppingStartPositionInt = UserDefaults.standard.integer(forKey: shoppingStartPositionKey)
//        if shoppingStartPositionInt == 0 {
//            sortLeftErrandDataList()
//        } else {
//            sortRightErrandDataList()
//        }
//    }

    /// 買い物ルートを左回りに選択された場合の買い物リストを並び替える
    /// - cellをチェックがオフのものを一番上に、かつ売り場を降順に並び替える
    /// - shoppingListTableViewを再読み込み
//    func sortLeftErrandDataList() {
//        errandDataList = errandDataList.sorted { (a, b) -> Bool in
//            if a.isCheckBox != b.isCheckBox {
//                return !a.isCheckBox
//            } else {
//                return a.salesFloorRawValue > b.salesFloorRawValue
//            }
//        }
//        shoppingListTableView.reloadData()
//    }

    /// 買い物ルートを右回りに選択された場合の買い物リストを並び替える
    /// - cellをチェックがオフのものを一番上に、かつ売り場を昇順に並び替える
    /// - shoppingListTableViewを再読み込み
//    func sortRightErrandDataList() {
//        errandDataList = errandDataList.sorted { (a, b) -> Bool in
//            if a.isCheckBox != b.isCheckBox {
//                return !a.isCheckBox
//            } else {
//                return a.salesFloorRawValue < b.salesFloorRawValue
//            }
//        }
//        shoppingListTableView.reloadData()
//    }

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
//        return errandDataList.count
        return myShoppingItemList.count
    }
    
    /// shoppingListTableViewに使用するcellの内容を指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = shoppingListTableView.dequeueReusableCell(
            withIdentifier: "ShoppingListTableViewCell", for: indexPath) as? ShoppingListTableViewCellController {
            cell.delegate = self
//            let errandDataModel: ErrandDataModel = errandDataList[indexPath.row]
//            cell.setShoppingList(isCheckBox: errandDataModel.isCheckBox,
//                                 nameOfItem: errandDataModel.nameOfItem,
//                                 numberOfItem: errandDataModel.numberOfItem,
//                                 unit: errandDataModel.unit,
//                                 salesFloorRawValue: errandDataModel.salesFloorRawValue,
//                                 supplement: errandDataModel.supplement,
//                                 image: errandDataModel.getImage())
            let myData: ShoppingItemModel = myShoppingItemList[indexPath.row]
            var setImage:UIImage? = nil
            if let imageUrl:URL = URL(string: myData.photoURL) {
                let imageData:Data = try! Data(contentsOf: imageUrl)
                setImage = UIImage(data: imageData)   
            }
            cell.setShoppingList(isCheckBox: myData.isCheckBox,
                                 nameOfItem: myData.nameOfItem,
                                 numberOfItem: myData.numberOfItem,
                                 unit: myData.unit,
                                 salesFloorRawValue: myData.salesFloorRawValue,
                                 supplement: myData.supplement,
                                 image: setImage )

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
        detailShoppingListViewController.modalTransitionStyle = .crossDissolve // フェードイン・アウトのアニメーション
        self.present(detailShoppingListViewController, animated: true)
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
        try! realm.commitWrite()

        // タップされたcellだけにアニメーションを実行する
        UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionCrossDissolve], animations: {
            // cellをリロードする
            self.shoppingListTableView.reloadRows(at: [indexPath], with: .fade)
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
                    self.shoppingListTableView.moveRow(at: indexPath, to: IndexPath(row: lastRow, section: 0))
                }
            }
        }, completion: nil)
//        sortErrandDataList()
        completionAlert()
    }
}
