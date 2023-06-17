//
//  EditShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit
import RealmSwift

/// F-買い物リスト編集
class EditShoppingListViewController: UIViewController {

    // MARK: - property

    /// チュートリアルを表示するボタン
    @IBOutlet private weak var helpButton: UIButton!
    /// 複数削除モードの解除ボタン
    @IBOutlet private weak var cancelEditButton: UIButton!
    /// 複数削除ボタン
    @IBOutlet private weak var multipleDeletionsButton: UIButton!
    /// 画面タイトルラベル
    @IBOutlet private weak var viewTitleLabel: UILabel!
    /// 買い物リストを表示
    @IBOutlet private weak var editShoppingListTableView: UITableView!
    /// 新規作成ボタン
    @IBOutlet private weak var createNewItemButton: UIButton!
    /// 編集モードのフラグ
    private var isEditingMode: Bool = false
    /// お使いデータのインスタンス化
    private let errandData = ErrandDataModel()
    /// お使いデータ
    private var errandDataList: [ErrandDataModel] = []
    /// Realmから取得したErrandDataModelの結果セットを保持するプロパティ
    private var errandDataModel: Results<ErrandDataModel>?
    /// Realmの監視用トークン
    private var notificationToken: NotificationToken?

    /// ユーザーが作成した買い物データを格納する配列
    private var myShoppingItemList: [ShoppingItemModel] = []

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableVIew()
        setCreateNewItemButtonAppearance()
        setEditButtonAppearance(multipleDeletionsButton, title: "複数削除")
        setEditButtonAppearance(cancelEditButton, title: "キャンセル")
        multipleDeletionsButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        cancelEditButton.isHidden = true
//        setErrandData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setupNotification() // realmのNotificationをセット
        setShoppingItemObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("離れるで")
//        notificationToken?.invalidate() // realmのNotificationの解除
        FirestoreManager.shared.removeShoppingItemObserver() // オブザーバを廃棄
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

    /// 複数削除モードを中断して終了する
    @IBAction private func isCancelEdit(_ sender: Any) {
        // 選択された行のIndexPathの配列を取得し、一つ一つのIndexPathに対して以下の処理を実行する。
        editShoppingListTableView.indexPathsForSelectedRows?.forEach {
            // TableViewで選択されている行の選択を解除する
            editShoppingListTableView.deselectRow(at: $0, animated: true)
        }
        isEditingMode = false
    }

    /// 「G-品目新規作成」画面にモーダル遷移
    @IBAction private func goCreateNewItemView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EditItemView", bundle: nil)
        let editItemVC = storyboard.instantiateViewController(
            withIdentifier: "EditItemView") as! EditItemViewController
        self.present(editItemVC, animated: true)
    }

    /// 編集モード用のUIButtonの装飾基本設定
    private func setEditButtonAppearance(_ button: UIButton ,title: String) {
        button.setTitle(title, for: .normal)
        // 文字色を黒に設定
        button.setTitleColor(.white, for: .normal)
        // フォントをボールド、サイズを２０に設定
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        // 枠線の幅を１で設定
        button.layer.borderWidth = 1
        // 枠線のカラーを黒に設定
        button.layer.borderColor = UIColor.white.cgColor
        // バックグラウンドを角丸１０に設定
        button.layer.cornerRadius = 10.0
    }

    /// UITableViewの初期設定関連
    private func setTableVIew() {
        editShoppingListTableView.allowsMultipleSelectionDuringEditing = true
        editShoppingListTableView.dataSource = self
        editShoppingListTableView.delegate = self
        editShoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil),
                                           forCellReuseIdentifier: "ShoppingListTableViewCell")
    }

    /// CreateNewItemButtonの装飾処理をするメソッド
    private func setCreateNewItemButtonAppearance() {
        createNewItemButton.layer.borderWidth = 1 // 枠線の幅を１で設定
        createNewItemButton.layer.borderColor = UIColor.black.cgColor // 枠線のカラーを黒に設定
        createNewItemButton.layer.cornerRadius = 25 // 角丸の値
        createNewItemButton.addShadow() // 影
    }

    /// 買い物リストの変更を監視、データを受け取り表示を更新する
    func setShoppingItemObserver() {
        let uid = AccountManager.shared.getAuthStatus()
        FirestoreManager.shared.getShoppingItemObserver(uid: uid, completion: { [weak self] itemList in
            guard let self else { return }
            print("買い物リストの取得を開始")
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
        editShoppingListTableView.reloadData()
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
        editShoppingListTableView.reloadData()
    }

    /// 保存されたお使いデータをセットする
//    private func setErrandData() {
//        let realm = try! Realm()
//        let result = realm.objects(ErrandDataModel.self)
//        errandDataModel = realm.objects(ErrandDataModel.self)
//        errandDataList = Array(result)
//    }

    /// CustomSalesFloorModelの監視用メソッド
//    private func setupNotification() {
//        // Realmの通知機能で変更を監視する
//        // 変更通知を受け取る
//        notificationToken = errandDataModel?.observe{ [weak self] (changes: RealmCollectionChange) in
//            switch changes {
//                    //　画面遷移時の初回実行処理（画面移動後に毎回実施）
//                case .initial:
//                    self?.setErrandData()
//                    self?.sortErrandDataList()
//                    // 新規と追加処理の際の処理
//                case .update(let errandDataModel,let deletions,let insertions,let modifications):
//                    print(errandDataModel)
//                    print(deletions)
//                    print(insertions)
//                    print(modifications)
//                    self?.setErrandData()
//                    self?.sortErrandDataList()
//                    // エラー時の処理
//                case .error:
//                    print("困ったことが起きました😱")
//            }
//        }
//    }

    /// cellをチェックがオフのものを一番上に、かつ売り場の順に並び替える
    /// - NotificationCenterの受診をセット
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
//    private func sortLeftErrandDataList() {
//        errandDataList = errandDataList.sorted { (a, b) -> Bool in
//            if a.isCheckBox != b.isCheckBox {
//                return !a.isCheckBox
//            } else {
//                return a.salesFloorRawValue > b.salesFloorRawValue
//            }
//        }
//        editShoppingListTableView.reloadData()
//    }

    /// 買い物ルートを右回りに選択された場合の買い物リストを並び替える
    /// - cellをチェックがオフのものを一番上に、かつ売り場を昇順に並び替える
    /// - shoppingListTableViewを再読み込み
//    private func sortRightErrandDataList() {
//        errandDataList = errandDataList.sorted { (a, b) -> Bool in
//            if a.isCheckBox != b.isCheckBox {
//                return !a.isCheckBox
//            } else {
//                return a.salesFloorRawValue < b.salesFloorRawValue
//            }
//        }
//        editShoppingListTableView.reloadData()
//    }

    // MARK: - 編集モードに関する処理
    /// 編集モードの設定==multipleDeletionsButtonをタップした時の動作
    @objc func buttonTapped() {
        isEditingMode = !isEditingMode
        setEditing(isEditingMode, animated: true)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        let section = 0
        // 0からTableViewの指定されたセクションの行数未満までの整数rowに対して以下の処理を実行する。
        for row in 0..<editShoppingListTableView.numberOfRows(inSection: section) {
            // TableViewのIndexPathで指定された位置のセルをShoppingListTableViewCellControllerにダウンキャストし、cellに代入する。
            if let cell = editShoppingListTableView.cellForRow(at: IndexPath(row: row, section: section))
                as? ShoppingListTableViewCellController {
                cell.checkBoxButton.isHidden = editing
            }
        }
        // 編集開始
        if editing {
            // multipleDeletionsButtonのタイトルを変更
            multipleDeletionsButton.setTitle("削除実行", for: .normal)
            viewTitleLabel.text = "複数削除モード"
            helpButton.isHidden = true
            cancelEditButton.isHidden = false
            // 編集終了
        } else {
            // 選択した行を削除する
            deleteRows()
            // multipleDeletionsButtonのタイトルを変更
            multipleDeletionsButton.setTitle("複数削除", for: .normal)
            viewTitleLabel.text = "買い物リスト編集"
            cancelEditButton.isHidden = true
            helpButton.isHidden = false
        }
        // 編集モード時のみ複数選択可能とする
        editShoppingListTableView.isEditing = editing
    }

    /// 選択した行を削除する
    private func deleteRows() {
        // ユーザーが何も選択していない場合には抜ける
        guard let selectedIndexPaths = editShoppingListTableView.indexPathsForSelectedRows else { return }
        // 配列の要素削除で、indexの矛盾を防ぐため、降順にソートする
        let sortedIndexPaths =  selectedIndexPaths.sorted { $0.row > $1.row }
        let realm = try! Realm()
        try! realm.write {
            // 降順に繰り返す
            for indexPathList in sortedIndexPaths {
                // indexPathListに該当するidのErrandDataModelを取得
                let errandData = realm.objects(ErrandDataModel.self).filter("id = %@",
                                                                            errandDataList[indexPathList.row].id).first
                // 削除
                realm.delete(errandData!)
                // indexPathListに該当するerrandDataListの配列の要素を削除
                errandDataList.remove(at: indexPathList.row)
            }
        }
        // tableViewの行を削除
        editShoppingListTableView.deleteRows(at: sortedIndexPaths, with: UITableView.RowAnimation.automatic)
    }
}

// MARK: - UITableViewDataSource&Delegate
extension EditShoppingListViewController: UITableViewDataSource, UITableViewDelegate {
    /// editShoppingListTableViewに表示するcell数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myShoppingItemList.count
//        return errandDataList.count
    }

    /// editShoppingListTableViewに使用するcellの内容を指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = editShoppingListTableView.dequeueReusableCell(
            withIdentifier: "ShoppingListTableViewCell", for: indexPath) as? ShoppingListTableViewCellController {
            // 編集モードの状態によってチェックボックスの表示を切り替える
            cell.checkBoxButton.isHidden = isEditingMode
            cell.delegate = self
            let myData: ShoppingItemModel = myShoppingItemList[indexPath.row]
            cell.setShoppingList(isCheckBox: myData.isCheckBox,
                                 nameOfItem: myData.nameOfItem,
                                 numberOfItem: myData.numberOfItem,
                                 unit: myData.unit,
                                 salesFloorRawValue: myData.salesFloorRawValue,
                                 supplement: myData.supplement,
                                 image: nil)
//            let errandDataModel: ErrandDataModel = errandDataList[indexPath.row]
//            cell.setShoppingList(isCheckBox: errandDataModel.isCheckBox,
//                                 nameOfItem: errandDataModel.nameOfItem,
//                                 numberOfItem: errandDataModel.numberOfItem,
//                                 unit: errandDataModel.unit,
//                                 salesFloorRawValue: errandDataModel.salesFloorRawValue,
//                                 supplement: errandDataModel.supplement ?? "",
//                                 image: errandDataModel.getImage())
            return cell
        }
        return UITableViewCell()
    }

    /// editShoppingListTableViewのcellがタップされた時の挙動を定義
    /// - 編集モードのとき
    ///     - 何もしない
    /// - 編集モードではないとき
    ///     - タップされた商品のデータをEditItemViewに渡す
    ///     - EditItemViewにプッシュ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 編集モード時の処理を行わない
        guard !editShoppingListTableView.isEditing else { return }
        // 通常時の処理
        let storyboard = UIStoryboard(name: "EditItemView", bundle: nil)
        let editItemVC = storyboard.instantiateViewController(
            withIdentifier: "EditItemView") as! EditItemViewController
        let errandData = errandDataList[indexPath.row]
        editItemVC.configurer(detail: errandData)
        editShoppingListTableView.deselectRow(at: indexPath, animated: true)
        self.present(editItemVC, animated: true)
    }

    /// スワイプして削除する処理
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
    UISwipeActionsConfiguration? {
        /// スワイプした時の処理を定義
        let destructiveAction = UIContextualAction(style: .destructive, title: "削除") { [self]
            (action, view, completionHandler) in
            let realm = try! Realm()
            let target = self.errandDataList[indexPath.row]
            try! realm.write(withoutNotifying: [self.notificationToken!]) {
                realm.delete(target)
            }
            // お使いデータの対象のインデックス番号を削除
            self.errandDataList.remove(at: indexPath.row)
            // テーブルビューから視覚的に削除
            self.editShoppingListTableView.deleteRows(at: [indexPath], with: .automatic)
            // アクション完了を報告
            completionHandler(true)
        }
        // スワイプアクション時の画像を設定
        destructiveAction.image = UIImage(systemName: "trash.fill")
        // 定義した削除処理を設定
        let configuration = UISwipeActionsConfiguration(actions: [destructiveAction])
        // 実行するように返却
        return configuration
    }
}

// MARK: - ShoppingListTableViewCellDelegate
// cell内のチェックボックスをタップした際の処理
extension EditShoppingListViewController: ShoppingListTableViewCellDelegate {
    /// cell内のチェックボックスをタップした際の処理
    /// - チェックしたものは下に移動する
    func didTapCheckBoxButton(_ cell: ShoppingListTableViewCellController) {
        guard let indexPath = editShoppingListTableView.indexPath(for: cell) else { return }
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
            self.editShoppingListTableView.reloadRows(at: [indexPath], with: .fade)
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
                    self.editShoppingListTableView.moveRow(at: indexPath, to: IndexPath(row: lastRow, section: 0))
                }
            }
        }, completion: nil)
    }
}

