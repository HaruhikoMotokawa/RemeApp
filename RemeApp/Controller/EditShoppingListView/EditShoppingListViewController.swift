//
//  EditShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/20.
//

import UIKit

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
    @IBOutlet private weak var shoppingListTableView: UITableView!
    /// 新規作成ボタン
    @IBOutlet private weak var createNewItemButton: UIButton!
    /// 編集モードのフラグ
    private var isEditingMode: Bool = false

    /// ユーザーが作成した買い物データを格納する配列
    private var myShoppingItemList: [ShoppingItemModel] = []
    /// 共有相手が作成した買い物データを格納する配列
    private var otherShoppingItemList: [ShoppingItemModel] = []
    /// 自分と相手のshoppingコレクションのドキュメント配列を合わせた配列
    private var allShoppingItemList: [ShoppingItemModel] = []
    /// デリートするショッピングアイテムをセットする.
    private var deleteShoppingItem: [ShoppingItemModel] = []


    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNetWorkObserver()
        setTableVIew()
        setCreateNewItemButtonAppearance()
        setEditButtonAppearance(multipleDeletionsButton, title: "複数削除")
        setEditButtonAppearance(cancelEditButton, title: "キャンセル")
        multipleDeletionsButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        cancelEditButton.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMyShoppingItemObserver()
        setOtherShoppingItemObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("離れるで")
        removeShoppingItemObserver()
    }

    // MARK: - @IBAction func

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
        shoppingListTableView.indexPathsForSelectedRows?.forEach {
            // TableViewで選択されている行の選択を解除する
            shoppingListTableView.deselectRow(at: $0, animated: true)
        }
        isEditingMode = false
    }

    /// 「G-品目新規作成」画面にモーダル遷移
    @IBAction private func goCreateNewItemView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EditItemView", bundle: nil)
        let editItemVC = storyboard.instantiateViewController(
            withIdentifier: "EditItemView") as! EditItemViewController
        editItemVC.isNewItem = true // 新規編集フラグをオンにする
        present(editItemVC, animated: true)
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
            self.shoppingListTableView.reloadData()
        }
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
        shoppingListTableView.allowsMultipleSelectionDuringEditing = true
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil),
                                           forCellReuseIdentifier: "ShoppingListTableViewCell")
    }

    /// CreateNewItemButtonの装飾処理をするメソッド
    private func setCreateNewItemButtonAppearance() {
        createNewItemButton.layer.borderWidth = 1 // 枠線の幅を１で設定
        createNewItemButton.layer.borderColor = UIColor.black.cgColor // 枠線のカラーを黒に設定
        createNewItemButton.layer.cornerRadius = 25 // 角丸の値
        createNewItemButton.addShadow() // 影
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
            listener: &FirestoreManager.shared.editShoppingListMyItemListener,
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
            listener: &FirestoreManager.shared.editShoppingListOtherItemListener,
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
            listener: &FirestoreManager.shared.editShoppingListMyItemListener) // 自分のオブザーバを廃棄
        FirestoreManager.shared.removeShoppingItemObserver(
            listener: &FirestoreManager.shared.editShoppingListOtherItemListener) // 他人のオブザーバーを廃棄
    }

    /// cellをチェックがオフのものを一番上に、かつ売り場の順に並び替える
    /// - UserDefaultsに使用するキーを指定
    /// - UserDefaultsから設定を取得
    /// -  画面ローディング時の表示をif文で切り替え
    /// - 買い物開始位置が左回り設定の場合 -> cellをチェックがオフのものを一番上に、かつ売り場を降順に並び替える
    /// - 買い物開始位置が右回り設定の場合 -> ellをチェックがオフのものを一番上に、かつ売り場を昇順に並び替える
    private func sortShoppingItemList() {
        print("並び替え実行")
        let shoppingStartPositionKey = "shoppingStartPositionKey"
        let shoppingStartPositionInt = UserDefaults.standard.integer(forKey: shoppingStartPositionKey)
        if shoppingStartPositionInt == 0 {
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


    // MARK: - 編集モードに関する処理
    /// 編集モードの設定==multipleDeletionsButtonをタップした時の動作
    @objc func buttonTapped() {
        // オフラインだったらアラート出して終了
        guard NetworkMonitor.shared.isConnected else {
            AlertController.showAlert(tittle: "エラー", errorMessage: "オフライン時はスワイプ削除のみ有効です")
            return
        }
        isEditingMode = !isEditingMode
        setEditing(isEditingMode, animated: true)
    }

    override func setEditing(_ editing: Bool, animated: Bool)  {
        super.setEditing(editing, animated: animated)
        let section = 0
        // 0からTableViewの指定されたセクションの行数未満までの整数rowに対して以下の処理を実行する。
        for row in 0..<shoppingListTableView.numberOfRows(inSection: section) {
            // TableViewのIndexPathで指定された位置のセルをShoppingListTableViewCellControllerにダウンキャストし、cellに代入する。
            if let cell = shoppingListTableView.cellForRow(at: IndexPath(row: row, section: section))
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
            // デリートアイテムがある場合は削除処理をする
            deleteFirebase()
            // multipleDeletionsButtonのタイトルを変更
            multipleDeletionsButton.setTitle("複数削除", for: .normal)
            viewTitleLabel.text = "買い物リスト編集"
            cancelEditButton.isHidden = true
            helpButton.isHidden = false
        }
        // 編集モード時のみ複数選択可能とする
        shoppingListTableView.isEditing = editing
    }

    /// 選択したセルの行を削除する
    private func deleteRows() {
        // ユーザーが何も選択していない場合には抜ける
        guard let selectedIndexPaths = shoppingListTableView.indexPathsForSelectedRows else { return }
        // 配列の要素削除で、indexの矛盾を防ぐため、降順にソートする
        let sortedIndexPaths =  selectedIndexPaths.sorted { $0.row > $1.row }
        // for-in文で一つずつ削除
        for indexPathList in sortedIndexPaths {
            // 選択したセルのインデックス番号を取得
            let target = allShoppingItemList[indexPathList.row]
            // 削除対象のidが見つからなければ抜ける
            guard let id = target.id else { return }
            // 対象の削除アイテムをデリートアイテム配列に追加
            deleteShoppingItem.append(target)
            // ローカルデータmyShoppingItemList配列から同じidに該当するデータを取得
            if let index = self.allShoppingItemList.firstIndex(where: { $0.id == id }) {
                // ローカルデータmyShoppingItemList配列から対象を削除
                allShoppingItemList.remove(at: index)
                // tableViewの行を視覚的に削除
                shoppingListTableView.deleteRows(at: [indexPathList], with: .left)
            }
        }
    }

    /// 複数削除の時のFirebase関連削除処理
    private func deleteFirebase() {
        // 削除対象の配列全てにアクセス
        deleteShoppingItem.forEach { target in
            guard let id = target.id else { return }
            // FirebaseStorageから写真を削除
            StorageManager.shared.deletePhoto(photoURL: target.photoURL, completion: { error in })
            // firestoreからドキュメント削除
            FirestoreManager.shared.deleteItem(id: id, completion: { [weak self] error in
                guard let self else { return }
                if error != nil {
                    // エラーの場合
                    print("削除に失敗")
                    let errorMassage = FirebaseErrorManager.shared.setFirestoreErrorMessage(error)
                    AlertController.showAlert(tittle: "エラー", errorMessage: errorMassage)
                    // 削除対象の配列を空に戻す
                    self.deleteShoppingItem = []

                    return
                }
                // 成功の場合
                // 削除が成功したら削除対象の配列を空に戻す
                self.deleteShoppingItem = []
            })
        }
    }
}

// MARK: - UITableViewDataSource&Delegate
extension EditShoppingListViewController: UITableViewDataSource, UITableViewDelegate {
    /// editShoppingListTableViewに表示するcell数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allShoppingItemList.count
        //        return errandDataList.count
    }

    /// editShoppingListTableViewに使用するcellの内容を指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = shoppingListTableView.dequeueReusableCell(
            withIdentifier: "ShoppingListTableViewCell", for: indexPath) as? ShoppingListTableViewCellController {
            // 編集モードの状態によってチェックボックスの表示を切り替える
            cell.checkBoxButton.isHidden = isEditingMode
            cell.delegate = self
            let myData: ShoppingItemModel = allShoppingItemList[indexPath.row]
            let setImage = StorageManager.shared.setImageWithUrl(photoURL: myData.photoURL)
            cell.setShoppingList(isCheckBox: myData.isCheckBox,
                                 nameOfItem: myData.nameOfItem,
                                 numberOfItem: myData.numberOfItem,
                                 unit: myData.unit,
                                 salesFloorRawValue: myData.salesFloorRawValue,
                                 supplement: myData.supplement,
                                 image: setImage)

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
        guard !shoppingListTableView.isEditing else { return }
        // 通常時の処理
        let storyboard = UIStoryboard(name: "EditItemView", bundle: nil)
        let editItemVC = storyboard.instantiateViewController(
            withIdentifier: "EditItemView") as! EditItemViewController
        let shoppingItemData = allShoppingItemList[indexPath.row]
        let targetPhotoURL = shoppingItemData.photoURL
        let image = StorageManager.shared.setImageWithUrl(photoURL: targetPhotoURL)
        editItemVC.configurer(detail: shoppingItemData, image: image)
        editItemVC.isNewItem = false // 新規編集フラグをオフにする
        shoppingListTableView.deselectRow(at: indexPath, animated: true)
        present(editItemVC, animated: true)
    }

    // MARK: 単品で削除する場合の処理

    /// 削除対象のセルを一時的に保存し、もしも実行された場合の処理を定義
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // デリートするアイテムを一時的にプロパティに保存
        deleteShoppingItem.append(allShoppingItemList[indexPath.row])
        // オフラインで尚且つダウンロードURLを持っているデータだったらアラート出して終了
        if !NetworkMonitor.shared.isConnected && !deleteShoppingItem.contains(where: { $0.photoURL == "" }) {
            deleteShoppingItem = []
            AlertController.showAlert(tittle: "エラー", errorMessage: "オフライン中は画像データのあるリストを削除できません")
        } else {
            // 通常時の処理
            allShoppingItemList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    /// セルの削除が行われた後に呼び出される、ここでFirebase関連の削除を行う
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        // デリートアイテムがない場合はリターン
        guard !deleteShoppingItem.isEmpty else { return }
        // 選択したセルのインデックス番号を取得
        guard let target = deleteShoppingItem.first, let id = target.id else { return }
        // FirebaseStorageの写真データを削除
        StorageManager.shared.deletePhoto(photoURL: target.photoURL) { [weak self] error in
            guard let self else { return }
            // firestoreからドキュメント削除
            FirestoreManager.shared.deleteItem(id: id, completion: { error in
                // 通信が終了したらデリートアイテムを[]にする
                self.deleteShoppingItem = []
            })
        }
    }
}

// MARK: - ShoppingListTableViewCellDelegate
// cell内のチェックボックスをタップした際の処理
extension EditShoppingListViewController: ShoppingListTableViewCellDelegate {
    /// cell内のチェックボックスをタップした際の処理
    /// - チェックしたものは下に移動する
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
