//
//  EditSalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/23.
//

import UIKit
import RealmSwift

/// K-売り場マップ編集
class EditSalesFloorMapViewController: UIViewController {

    // MARK: - @IBOutlet & @IBAction
    /// 使用する売り場マップのセレクター
    @IBOutlet private weak var useSalesFloorMapSelector: UISegmentedControl!
    /// 使用する売り場マップを変更するメソッド
    @IBAction private func changeSalesFloorMap(_ sender: Any) {
        // もしもセグメントが０だったら売り場の設定をカスタムにする
        if useSalesFloorMapSelector.selectedSegmentIndex == 0 {
            saveUseSalesFloorMap(type: SalesFloorMapType.custom)
            NotificationCenter.default.post(name: .showCustomSelectCheckMark, object: nil)
            NotificationCenter.default.post(name: .hideDefaultSelectCheckMark, object: nil)
            // （違うのであれば）つまりセグメントが１だったら売り場の設定をデフォルトにする
        } else {
            saveUseSalesFloorMap(type: SalesFloorMapType.default)
            NotificationCenter.default.post(name: .hideCustomSelectCheckMark, object: nil)
            NotificationCenter.default.post(name: .showDefaultSelectCheckMark, object: nil)
        }

        NotificationCenter.default.post(name: .exchangeAllSalesFloorButton, object: nil)
    }

    /// 買い物の開始位置を決めるセレクター
    @IBOutlet private weak var shoppingStartPositionSelector: UISegmentedControl!
    /// 買い物の開始位置を変更するメソッド
    @IBAction private func changeShoppingStartPosition(_ sender: UISegmentedControl) {
        // もしもセグメントが０だったら買い物の開始位置を左回りにする
        if shoppingStartPositionSelector.selectedSegmentIndex == 0 {
            saveShoppingStartDirection(type: ShoppingStartPositionType.left)
            NotificationCenter.default.post(name: .showLeftCartView, object: nil)
            NotificationCenter.default.post(name: .sortLeftErrandDataList, object: nil)
            // （違うのであれば）つまりセグメントが１だったら買い物の開始位置を右回りにする
        } else {
            saveShoppingStartDirection(type: ShoppingStartPositionType.right)
            NotificationCenter.default.post(name: .showRightCartView, object: nil)
            NotificationCenter.default.post(name: .sortRightErrandDataList, object: nil)
        }
    }

    /// リセットボタン
    @IBOutlet weak var resetButton: UIButton!
    /// カスタムマップの設定をリセットする
    @IBAction func resetCustomMap(_ sender: Any) {
        let alertController =
        UIAlertController(title: "確認", message:
"""
カスタムマップの設定を初期状態に
戻してもよろしいですか？
""", preferredStyle: .alert)
        /// リセットする処理
        let resetAction = UIAlertAction(title: "リセット", style: .default) { (action) in
            // データベースの初期化のデータを作成
            let customSalesFloors: [CustomSalesFloorModel] = [
                CustomSalesFloorModel(salesFloorRawValue: 0, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 0),
                CustomSalesFloorModel(salesFloorRawValue: 1, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 1),
                CustomSalesFloorModel(salesFloorRawValue: 2, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 2),
                CustomSalesFloorModel(salesFloorRawValue: 3, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 3),
                CustomSalesFloorModel(salesFloorRawValue: 4, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 4),
                CustomSalesFloorModel(salesFloorRawValue: 5, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 5),
                CustomSalesFloorModel(salesFloorRawValue: 6, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 6),
                CustomSalesFloorModel(salesFloorRawValue: 7, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 7),
                CustomSalesFloorModel(salesFloorRawValue: 8, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 8),
                CustomSalesFloorModel(salesFloorRawValue: 9, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 9),
                CustomSalesFloorModel(salesFloorRawValue: 10, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 10),
                CustomSalesFloorModel(salesFloorRawValue: 11, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 11),
                CustomSalesFloorModel(salesFloorRawValue: 12, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 12),
                CustomSalesFloorModel(salesFloorRawValue: 13, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 13),
                CustomSalesFloorModel(salesFloorRawValue: 14, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 14),
                CustomSalesFloorModel(salesFloorRawValue: 15, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 15),
                CustomSalesFloorModel(salesFloorRawValue: 16, nameOfSalesFloor: "未設定", customColorOfSalesFloorRawValue: 16)
            ]
            // カスタムした売り場のデータを一旦削除
            let realm = try! Realm()
            try! realm.write {
                realm.delete(realm.objects(CustomSalesFloorModel.self))
            }
            // 初期化のデータを書き込み
            try! realm.write {
                realm.add(customSalesFloors)
            }

            NotificationCenter.default.post(name: .exchangeAllSalesFloorButton, object: nil)
            NotificationCenter.default.post(name: .updateButtonAppearance, object: nil)
            print("💀リセット実行💀")
        }
        // 何もしない処理
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBOutlet weak var containerView: UIView!

    // MARK: - property
    /// 売り場マップの設定を保存するためのUserDefaultsに使用するキー
    let useSalesFloorTypeKey = "useSalesFloorTypeKey"

    /// 買い物の開始位置の設定を保存するためのUserDefaultsに使用するキー
    let shoppingStartPositionKey = "shoppingStartPositionKey"

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUseSalesFloorMapSelector()
        setShoppingStartPositionSelector()
        resetButton.setAppearanceWithShadow()
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.cornerRadius = 10
    }

    // MARK: - func
    /// 使用マップ設定のセグメントを設定する
    /// - UserDefaultsから設定を取得し、セグメントインデックスに代入
    /// - セグメント左のタイトルを「カスタム」に設定
    /// - セグメント右のタイトルを「デフォルト」に設定
    /// - セグメントの背景色を「ライトグレー」に設定
    private func setUseSalesFloorMapSelector() {
        /// UserDefaultsから設定を取得
        let salesFloorTypeInt = UserDefaults.standard.integer(forKey: useSalesFloorTypeKey)
        /// 取得した値をセグメントインデックスに代入
        useSalesFloorMapSelector.selectedSegmentIndex = salesFloorTypeInt
        // セグメント左のタイトル
        useSalesFloorMapSelector.setTitle("カスタム", forSegmentAt: 0)
        // セグメント右のタイトル
        useSalesFloorMapSelector.setTitle("デフォルト", forSegmentAt: 1)
        // セグメントの背景色
        useSalesFloorMapSelector.backgroundColor = UIColor.lightGray
    }

    /// UserDefaultsに使用する売り場のマップ種類を登録するメソッド
    private func saveUseSalesFloorMap(type: SalesFloorMapType) {
        UserDefaults.standard.setValue(type.rawValue, forKey: useSalesFloorTypeKey)
    }

    /// 買い物ルート設定のセグメントを設定する
    /// - UserDefaultsから設定を取得し、セグメントインデックスに代入
    /// - セグメント左のタイトルを「左回り」に設定
    /// - セグメント右のタイトルを「右回り」に設定
    /// - セグメントの背景色を「ライトグレー」に設定
    private func setShoppingStartPositionSelector() {
        /// UserDefaultsから設定を取得
        let shoppingStartPositionInt = UserDefaults.standard.integer(forKey: shoppingStartPositionKey)
        /// 取得した値をセグメントインデックスに代入
        shoppingStartPositionSelector.selectedSegmentIndex = shoppingStartPositionInt
        // セグメント左のタイトル
        shoppingStartPositionSelector.setTitle("左回り", forSegmentAt: 0)
        // セグメント右のタイトル
        shoppingStartPositionSelector.setTitle("右回り", forSegmentAt: 1)
        // セグメントの背景色
        shoppingStartPositionSelector.backgroundColor = UIColor.lightGray
    }

    /// UserDefaultsに買い物ルート設定を登録するメソッド
    private func saveShoppingStartDirection(type: ShoppingStartPositionType) {
        UserDefaults.standard.setValue(type.rawValue, forKey: shoppingStartPositionKey)
    }
}
