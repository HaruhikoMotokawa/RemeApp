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


    @IBAction func resetSalesFloorSettings(_ sender: Any) {
        let alertController =
        UIAlertController(title: "確認", message:"""
売り場の設定を初期状態に
戻してもよろしいですか？
""", preferredStyle: .alert)

        let resetAction = UIAlertAction(title: "リセット", style: .default) { (action) in
            // OKが押された時の処理
            print("💀リセット実行💀")
        }
        // 何もしない
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }


    @IBOutlet weak var useSalesFloorMapSelector: UISegmentedControl!

    @IBAction func changeSalesFloorMap(_ sender: Any) {
    }

    @IBOutlet weak var shoppingStartDirectionSelector: UISegmentedControl!
    @IBAction func changeShoppingStartDirection(_ sender: UISegmentedControl) {

    }


  


    var defaultSegmentIndex = 1

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()


        shoppingStartDirectionSelector.selectedSegmentIndex = defaultSegmentIndex

        shoppingStartDirectionSelector.setTitle("左周り", forSegmentAt: 0)
        shoppingStartDirectionSelector.setTitle("右周り", forSegmentAt: 1)

        shoppingStartDirectionSelector.backgroundColor = UIColor.lightGray

    }
 
    



  


  
}
