//
//  EditSalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/23.
//

import Foundation
import UIKit

/// K-売り場マップ編集
class EditSalesFloorMapViewController: UIViewController {

    /// カスタムマップの設定をリセットする
    @IBAction func resetSalesFloorSettings(_ sender: Any) {
        let alertController =
        UIAlertController(title: "確認", message:"""
カスタムマップの設定を初期状態に
戻してもよろしいですか？
""", preferredStyle: .alert)
        /// リセットする処理
        let resetAction = UIAlertAction(title: "リセット", style: .default) { (action) in
            // OKが押された時の処理
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
        if useSalesFloorMapSelector.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: .showCustomSelectCheckMark, object: nil)
            NotificationCenter.default.post(name: .hideDefaultSelectCheckMark, object: nil)
        } else {
            NotificationCenter.default.post(name: .hideCustomSelectCheckMark, object: nil)
            NotificationCenter.default.post(name: .showDefaultSelectCheckMark, object: nil)
        }
    }

    /// 買い物の開始位置を決めるセレクター
    @IBOutlet weak var shoppingStartDirectionSelector: UISegmentedControl!
    /// 買い物の開始位置を変更するメソッド
    @IBAction func changeShoppingStartDirection(_ sender: UISegmentedControl) {

    }


    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance(useSalesFloorMapSelector, startIndexNumber: 1, leftTitle: "カスタム", rightTitle: "デフォルト")
        setAppearance(shoppingStartDirectionSelector, startIndexNumber: 1, leftTitle: "左回り", rightTitle: "右回り")
    }
 
    func setAppearance(_ segment: UISegmentedControl, startIndexNumber: Int, leftTitle: String, rightTitle: String) {
        segment.selectedSegmentIndex = startIndexNumber
        segment.setTitle(leftTitle, forSegmentAt: 0)
        segment.setTitle(rightTitle, forSegmentAt: 1)
        segment.backgroundColor = UIColor.lightGray
    }





}

extension NSNotification.Name {
    static let showCustomSelectCheckMark = NSNotification.Name("showCustomSelectCheckMark")
    static let hideCustomSelectCheckMark = NSNotification.Name("hideCustomSelectCheckMark")
    static let showDefaultSelectCheckMark = NSNotification.Name("showDefaultSelectCheckMark")
    static let hideDefaultSelectCheckMark = NSNotification.Name("hideDefaultSelectCheckMark")
}

