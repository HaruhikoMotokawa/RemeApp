//
//  EditSalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/23.
//

import UIKit
import RealmSwift

/// K-売り場マップ編集
final class EditSalesFloorMapViewController: UIViewController {

  // MARK: - @IBOutlet
  /// チュートリアルを表示するボタン
  @IBOutlet private weak var helpButton: UIButton! {
    didSet {
      helpButton.addTarget(self, action: #selector(goTutorialView), for: .touchUpInside)
    }
  }
  /// 使用する売り場マップのセレクター
  @IBOutlet private weak var useSalesFloorMapSelector: UISegmentedControl! {
    didSet {
      // UserDefaultsから取得した値をセグメントインデックスに代入
      useSalesFloorMapSelector.selectedSegmentIndex = UserDefaults.standard.useSalesFloorType
      // セグメント左のタイトル
      useSalesFloorMapSelector.setTitle("カスタム", forSegmentAt: 0)
      // セグメント右のタイトル
      useSalesFloorMapSelector.setTitle("デフォルト", forSegmentAt: 1)
      // セグメントの背景色
      useSalesFloorMapSelector.backgroundColor = UIColor.lightGray
      useSalesFloorMapSelector.addTarget(self, action: #selector(changeSalesFloorMap), for: .valueChanged)
    }
  }

  /// 買い物の開始位置を決めるセレクター
  @IBOutlet private weak var shoppingStartPositionSelector: UISegmentedControl! {
    didSet {
      // UserDefaultsから取得した値をセグメントインデックスに代入
      shoppingStartPositionSelector.selectedSegmentIndex = UserDefaults.standard.shoppingStartPosition
      // セグメント左のタイトル
      shoppingStartPositionSelector.setTitle("左回り", forSegmentAt: 0)
      // セグメント右のタイトル
      shoppingStartPositionSelector.setTitle("右回り", forSegmentAt: 1)
      // セグメントの背景色
      shoppingStartPositionSelector.backgroundColor = UIColor.lightGray
      shoppingStartPositionSelector.addTarget(self, action: #selector(changeShoppingStartPosition), for: .valueChanged)

    }
  }

  /// リセットボタン
  @IBOutlet weak var resetButton: UIButton! {
    didSet {
      resetButton.setAppearanceWithShadow(fontColor: .black)
      resetButton.addTarget(self, action: #selector(resetCustomMap), for: .touchUpInside)
    }
  }

  @IBOutlet weak var containerView: UIView! {
    didSet {
      containerView.layer.borderWidth = 1
      containerView.layer.borderColor = UIColor.black.cgColor
      containerView.layer.cornerRadius = 10
      containerView.clipsToBounds = true
    }
  }

  // MARK: - property
  /// カスタムマップの初期値
  static var resetCustomSalesFloors: [CustomSalesFloorModel] {[
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
  ]}
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - func
  /// チュートリアル画面にモーダル遷移
  @objc private func goTutorialView() {
    Router.shared.showTutorialMenu(from: self)
  }

  /// 使用する売り場マップを変更するメソッド
  @objc private func changeSalesFloorMap() {
    // ユーザーデフォルトにセグメント番号を保存
    UserDefaults.standard.useSalesFloorType = useSalesFloorMapSelector.selectedSegmentIndex
    // セグメントナンバーによってチェックマーク表示の切り替え
    if useSalesFloorMapSelector.selectedSegmentIndex == SalesFloorMapType.custom.rawValue {
      NotificationCenter.default.post(name: .showCustomSelectCheckMark, object: nil)
      NotificationCenter.default.post(name: .hideDefaultSelectCheckMark, object: nil)
    } else {
      NotificationCenter.default.post(name: .hideCustomSelectCheckMark, object: nil)
      NotificationCenter.default.post(name: .showDefaultSelectCheckMark, object: nil)
    }
  }

  /// 買い物の開始位置を変更するメソッド
  @objc private func changeShoppingStartPosition() {
    // ユーザーデフォルトにセグメント番号を保存
    UserDefaults.standard.shoppingStartPosition = shoppingStartPositionSelector.selectedSegmentIndex
    // セグメントナンバーによってカート画像の表示切り替え
    if shoppingStartPositionSelector.selectedSegmentIndex == ShoppingStartPositionType.left.rawValue {
      NotificationCenter.default.post(name: .showLeftCartView, object: nil)
    } else {
      NotificationCenter.default.post(name: .showRightCartView, object: nil)
    }
  }

  /// カスタムマップの設定をリセットする
  @objc private func resetCustomMap() {
    let alertController =
    UIAlertController(title: "確認", message:
"""
カスタムマップの設定を初期状態に
戻してもよろしいですか？
""", preferredStyle: .alert)
    /// リセットする処理
    let resetAction = UIAlertAction(title: "リセット", style: .default) { [weak self] (action) in
      guard self != nil else { return }
      let realm = try! Realm()
      let customSalesFloors = Array(realm.objects(CustomSalesFloorModel.self)) // 編集した売り場のデータを取得
      try! realm.write {
        realm.delete(customSalesFloors) // 変更されたデータを削除
        realm.add(EditSalesFloorMapViewController.resetCustomSalesFloors) // 作成した初期値を書き込み
      }
    }
    /// 何もしない処理
    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

    alertController.addAction(resetAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
  }
}
