//
//  HomeTutorialViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/02.
//

import UIKit
/// チュートリアルの一覧を表示する
final class HomeTutorialViewController: UITableViewController {
    /// チュートリアルの一覧を表示するTableView
    @IBOutlet private weak var tutorialTableView: UITableView!

    /// チュートリアルの表示する画像名を管理
    enum ImageName: String {
        case shoppingList = "TutorialShppingListVer2.0.0"
        case salesFloorMap = "TutorialSalesFloorMapVer2.0.0"
        case editShoppingList = "TutorialEditShoppingListVer2.0.0"
        case editSalesFloorMap = "TutorialEditSalesFloorMapVer2.0.0"
        case accountDescription = "TutorialAccountDescriptionVer2.0.0"
        case accountCreate = "TutorialAccountCreateVer2.0.0"
        case shareSettings = "TutorialShareSettingsVer2.0.0"
        case accountDelete = "TutorialAccountDeleteVer2.0.0"
        case offLine = "TutorialOffLineVer2.0.0"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    /// タップしてモーダル遷移
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セクションと行番号でDetailTutorialViewに表示するチュートリアルの画像を切り替える
        switch (indexPath.section, indexPath.row) {
            case (0, 0):
                return Router.shared.showDetailTutorial(from: self, imageName: ImageName.shoppingList.rawValue)
            case (0, 1):
                return Router.shared.showDetailTutorial(from: self, imageName: ImageName.salesFloorMap.rawValue)
            case (0, 2):
                return Router.shared.showDetailTutorial(from: self, imageName: ImageName.editShoppingList.rawValue)
            case (0, 3):
                return Router.shared.showDetailTutorial(from: self, imageName: ImageName.editSalesFloorMap.rawValue)

            case (1, 0):
                return Router.shared.showDetailTutorial(from: self, imageName: ImageName.accountDescription.rawValue)
            case (1, 1):
                return Router.shared.showDetailTutorial(from: self, imageName: ImageName.accountCreate.rawValue)
            case (1, 2):
                return Router.shared.showDetailTutorial(from: self, imageName: ImageName.shareSettings.rawValue)
            case (1, 3):
                return Router.shared.showDetailTutorial(from: self, imageName: ImageName.accountDelete.rawValue)

            case (2, 0):
                return Router.shared.showDetailTutorial(from: self, imageName: ImageName.offLine.rawValue)

            case (3, 0):
                // アプリの設定画面に画面遷移し、ライセンス画面を表示
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                return UIApplication.shared.open(settingsUrl)

            default:
                dismiss(animated: true)
        }
    }
}




