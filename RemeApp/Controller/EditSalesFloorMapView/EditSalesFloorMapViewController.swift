//
//  EditSalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/23.
//

import UIKit

/// K-売り場マップ編集
class EditSalesFloorMapViewController: UIViewController {

    // MARK: - @IBOutlet & @IBAction
    /// カスタムマップの設定をリセットする
    @IBAction func resetSalesFloorSettings(_ sender: Any) {
        let alertController =
        UIAlertController(title: "確認", message:"""
カスタムマップの設定を初期状態に
戻してもよろしいですか？
""", preferredStyle: .alert)
        /// リセットする処理
        let resetAction = UIAlertAction(title: "リセット", style: .default) { (action) in
            // TODO: リセットする処理を記述
            print("💀リセット実行💀")
        }
        // 何もしない処理
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    /// 使用する売り場マップのセレクター
    @IBOutlet weak var useSalesFloorMapSelector: UISegmentedControl!
    /// 使用する売り場マップを変更するメソッド
    @IBAction func changeSalesFloorMap(_ sender: Any) {
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
    }

    /// 買い物の開始位置を決めるセレクター
    @IBOutlet weak var shoppingStartPositionSelector: UISegmentedControl!
    /// 買い物の開始位置を変更するメソッド
    @IBAction func changeShoppingStartPosition(_ sender: UISegmentedControl) {
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
    }

    // MARK: - func
    /// 使用マップ設定のセグメントを設定する
    /// - UserDefaultsから設定を取得し、セグメントインデックスに代入
    /// - セグメント左のタイトルを「カスタム」に設定
    /// - セグメント右のタイトルを「デフォルト」に設定
    /// - セグメントの背景色を「ライトグレー」に設定
    func setUseSalesFloorMapSelector() {
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
    func saveUseSalesFloorMap(type: SalesFloorMapType) {
        UserDefaults.standard.setValue(type.rawValue, forKey: useSalesFloorTypeKey)
    }

    /// 買い物ルート設定のセグメントを設定する
    /// - UserDefaultsから設定を取得し、セグメントインデックスに代入
    /// - セグメント左のタイトルを「左回り」に設定
    /// - セグメント右のタイトルを「右回り」に設定
    /// - セグメントの背景色を「ライトグレー」に設定
    func setShoppingStartPositionSelector() {
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
    func saveShoppingStartDirection(type: ShoppingStartPositionType) {
        UserDefaults.standard.setValue(type.rawValue, forKey: shoppingStartPositionKey)
    }
}
