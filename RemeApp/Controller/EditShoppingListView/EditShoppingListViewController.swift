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

    // MARK: - @IBOutlet & @IBAction

    /// 複数削除ボタン
    @IBOutlet weak var multipleDeletionsButton: UIButton!

    /// 買い物リストを表示
    @IBOutlet private weak var editShoppingListTableView: UITableView!

    /// 新規作成ボタン
    @IBOutlet private weak var createNewItemButton: UIButton!
    /// 「G-品目新規作成」画面にモールダ遷移
    @IBAction private func goCreateNewItemView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EditItemView", bundle: nil)
        let editItemVC = storyboard.instantiateViewController(
            withIdentifier: "EditItemView") as! EditItemViewController
        self.present(editItemVC, animated: true)
    }

    // MARK: - property
    /// 編集モードのフラグ
    private var isEditingMode: Bool = false

    /// お使いデータ
    private var errandDataList: [ErrandDataModel] = []

    /// Realmから取得したErrandDataModelの結果セットを保持するプロパティ
    private var errandDataModel: Results<ErrandDataModel>?

    // Realmの監視用トークン
    private var notificationToken: NotificationToken?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableVIew()
        setAppearance(createNewItemButton)
        multipleDeletionsButton.setTitle("複数削除", for: .normal)
        multipleDeletionsButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setErrandData()
        sortErrandDataList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 通知の解除
        print("解除やで")
        notificationToken?.invalidate()
    }

    // MARK: - func

    /// UITableViewの初期設定関連
    private func setTableVIew() {
        editShoppingListTableView.allowsMultipleSelectionDuringEditing = true
        editShoppingListTableView.dataSource = self
        editShoppingListTableView.delegate = self
        editShoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil),
                                           forCellReuseIdentifier: "ShoppingListTableViewCell")
    }

    /// 保存されたお使いデータをセットする
    private func setErrandData() {
        let realm = try! Realm()
        let result = realm.objects(ErrandDataModel.self)
        errandDataModel = realm.objects(ErrandDataModel.self)
        errandDataList = Array(result)
    }

    /// CustomSalesFloorModelの監視用メソッド
    private func setupNotification() {
        // Realmの通知機能で変更を監視する
        // 変更通知を受け取る
        notificationToken = errandDataModel?.observe{ [weak self] (changes: RealmCollectionChange) in
            switch changes {
                case .initial:
                    self?.setErrandData()
                    self?.sortErrandDataList()
                    print("初めてなんだなぁ😊")

                case .update(let errandDataModel,let deletions,let insertions,let modifications):
                    print(errandDataModel)
                    print(deletions)
                    print(insertions)
                    print(modifications)
                    self?.setErrandData()
                    self?.sortErrandDataList()
                    print("変更があったデー✋🏻")

                case .error:
                    print("困ったことが起きました😱")
            }
        }
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
    /// - NotificationCenterの受診をセット
    /// - UserDefaultsに使用するキーを指定
    /// - UserDefaultsから設定を取得
    /// -  画面ローディング時の表示をif文で切り替え
    /// - 買い物開始位置が左回り設定の場合 -> cellをチェックがオフのものを一番上に、かつ売り場を降順に並び替える
    /// - 買い物開始位置が右回り設定の場合 -> ellをチェックがオフのものを一番上に、かつ売り場を昇順に並び替える
    private func sortErrandDataList() {
        let shoppingStartPositionKey = "shoppingStartPositionKey"
        let shoppingStartPositionInt = UserDefaults.standard.integer(forKey: shoppingStartPositionKey)
        if shoppingStartPositionInt == 0 {
            sortLeftErrandDataList()
        } else {
            sortRightErrandDataList()
        }
    }

    /// 買い物ルートを左回りに選択された場合の買い物リストを並び替える
    /// - cellをチェックがオフのものを一番上に、かつ売り場を降順に並び替える
    /// - shoppingListTableViewを再読み込み
    func sortLeftErrandDataList() {
        errandDataList = errandDataList.sorted { (a, b) -> Bool in
            if a.isCheckBox != b.isCheckBox {
                return !a.isCheckBox
            } else {
                return a.salesFloorRawValue > b.salesFloorRawValue
            }
        }
        editShoppingListTableView.reloadData()
    }

    /// 買い物ルートを右回りに選択された場合の買い物リストを並び替える
    /// - cellをチェックがオフのものを一番上に、かつ売り場を昇順に並び替える
    /// - shoppingListTableViewを再読み込み
    func sortRightErrandDataList() {
        errandDataList = errandDataList.sorted { (a, b) -> Bool in
            if a.isCheckBox != b.isCheckBox {
                return !a.isCheckBox
            } else {
                return a.salesFloorRawValue < b.salesFloorRawValue
            }
        }
        editShoppingListTableView.reloadData()
    }

    // MARK: - 編集モードに関する処理
    /// 編集モードの設定==multipleDeletionsButtonをタップした時の動作
    @objc func buttonTapped() {
        isEditingMode = !isEditingMode
        setEditing(isEditingMode, animated: true)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // 編集開始
        if editing {
            // multipleDeletionsButtonのタイトルを変更
            multipleDeletionsButton.setTitle("完了", for: .normal)

            for cell in editShoppingListTableView.visibleCells {
                if let shoppingListCell = cell as? ShoppingListTableViewCellController {
                    //アニメーションの設定
                    UIView.animate(withDuration: 0.5, animations: {
                        shoppingListCell.checkBoxButton.alpha = 0.0
                    }, completion: { _ in
                        // checkBoxButtonを非表示にする
                        shoppingListCell.checkBoxButton.isHidden = true
                    })
                }
            }
            // 編集終了
        } else {
            // 選択した行を削除する
            deleteRows()
            // multipleDeletionsButtonのタイトルを変更
            multipleDeletionsButton.setTitle("複数削除", for: .normal)
            for cell in editShoppingListTableView.visibleCells {
                if let shoppingListCell = cell as? ShoppingListTableViewCellController {
                    //アニメーションの設定
                    UIView.animate(withDuration: 0.5, animations: {
                        shoppingListCell.checkBoxButton.alpha = 1.0
                    }, completion: { _ in
                        // checkBoxButtonを表示する
                        shoppingListCell.checkBoxButton.isHidden = false
                    })
                }
            }
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
                let errandData = realm.objects(ErrandDataModel.self).filter("id = %@", errandDataList[indexPathList.row].id).first
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
        return errandDataList.count
    }

    /// editShoppingListTableViewに使用するcellの内容を指定
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
                                 image: errandDataModel.getImage())
            
            return cell
        }
        return UITableViewCell()
    }

    /// editShoppingListTableViewのcellがタップされた時の挙動を定義
    /// - 編集モードのとき
    ///     - 一つでもセルがタップされたらeditButtonItemのタイトルを"削除"にする
    ///     - 何もタップされていなければ"完了"にする
    /// - 編集モードではないとき
    ///     - タップされた商品のデータをEditItemViewに渡す
    ///     - EditItemViewにプッシュ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editShoppingListTableView.isEditing {
            if let _ = self.editShoppingListTableView.indexPathsForSelectedRows {
                _ = self.editShoppingListTableView.cellForRow(at: indexPath)
                // 選択肢にチェックが一つでも入ってたら「削除」を表示する。
                self.editButtonItem.title = "削除"
            } else {
                // 何もチェックされていないときは完了を表示
                self.editButtonItem.title = "完了"
            }
        } else {
            let storyboard = UIStoryboard(name: "EditItemView", bundle: nil)
            let editItemVC = storyboard.instantiateViewController(
                withIdentifier: "EditItemView") as! EditItemViewController
            let errandData = errandDataList[indexPath.row]
            editItemVC.configurer(detail: errandData)
            editShoppingListTableView.deselectRow(at: indexPath, animated: true)
            self.present(editItemVC, animated: true)
        }
    }

    /// スワイプして削除する処理
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
    UISwipeActionsConfiguration? {
        /// スワイプした時の処理を定義
        let destructiveAction = UIContextualAction(style: .destructive, title: "削除") {
            (action, view, completionHandler) in
            // お使いデータの対象のインデックス番号を削除
            self.errandDataList.remove(at: indexPath.row)
            // Realmのデータベースからも削除
            let realm = try! Realm()
            let target = realm.objects(ErrandDataModel.self)[indexPath.row]
            try! realm.write {
                realm.delete(target)
            }
            // テーブルビューから視覚的に削除
            tableView.deleteRows(at: [indexPath], with: .automatic)
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

    /// 編集モード時に削除する処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        // もし編集モードが削除だったら
        if editingStyle == .delete {
            // お使いデータから指定されたインデックス番号を削除する
            errandDataList.remove(at: indexPath.row)
            // テーブルビューから指定されたインデックス番号を削除する
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /// テーブルビューのセルがタップされるたびに呼ばれる処理
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 編集モードじゃない場合はreturn
        guard editShoppingListTableView.isEditing else { return }

        if let _ = self.editShoppingListTableView.indexPathsForSelectedRows {
            self.editButtonItem.title = "削除"
        } else {
            // 何もチェックされていないときは完了を表示
            self.editButtonItem.title = "完了"
        }
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
    }
}

