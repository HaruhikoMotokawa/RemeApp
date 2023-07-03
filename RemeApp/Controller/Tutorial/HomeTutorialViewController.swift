//
//  HomeTutorialViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/02.
//

import UIKit
/// チュートリアルの一覧を表示する
class HomeTutorialViewController: UITableViewController {
    /// チュートリアルの一覧を表示するTableView
    @IBOutlet var tutorialTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// タップしてモーダル遷移
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セクションと行番号でDetailTutorialViewに表示するチュートリアルの画像を切り替える
        switch (indexPath.section, indexPath.row) {
            case (0, 0):
                return presentDetailTutorialView(imageName: Tutorial.shoppingList.imageName)
            case (0, 1):
                return presentDetailTutorialView(imageName: Tutorial.salesFloorMap.imageName)
            case (0, 2):
                return presentDetailTutorialView(imageName: Tutorial.editShoppingList.imageName)
            case (0, 3):
                return presentDetailTutorialView(imageName: Tutorial.editSalesFloorMap.imageName)

            case (1, 0):
                return presentDetailTutorialView(imageName: Tutorial.accountDescription.imageName)
            case (1, 1):
                return presentDetailTutorialView(imageName: Tutorial.accountCreate.imageName)
            case (1, 2):
                return presentDetailTutorialView(imageName: Tutorial.shareSettings.imageName)
            case (1, 3):
                return presentDetailTutorialView(imageName: Tutorial.accountDelete.imageName)

            case (2, 0):
                return presentDetailTutorialView(imageName: Tutorial.offLine.imageName)

            default:
                dismiss(animated: true)

        }
    }

    /// DetailTutorialViewにモーダル遷移する、引数に表示するイメージ名を入力
    private func presentDetailTutorialView(imageName: String) {
        let storyboard = UIStoryboard(name: "DetailTutorialView", bundle: nil)
        let detailTutorialVC = storyboard.instantiateViewController(
            withIdentifier: "DetailTutorialView") as! DetailTutorialViewController
        detailTutorialVC.configurer(imageName: imageName)
        detailTutorialVC.modalPresentationStyle = .fullScreen
        self.present(detailTutorialVC, animated: true)
    }

}

/// チュートリアルの表示する画像名を管理
enum Tutorial {
    case shoppingList
    case salesFloorMap
    case editShoppingList
    case editSalesFloorMap
    case accountDescription
    case accountCreate
    case shareSettings
    case accountDelete
    case offLine

    /// Assetsの名称を返却
    var imageName: String {
        switch self {
            case .shoppingList:
                return "TutorialShppingListVer2.0.0"
            case .salesFloorMap:
                return "TutorialSalesFloorMapVer2.0.0"
            case .editShoppingList:
                return "TutorialEditShoppingListVer2.0.0"
            case .editSalesFloorMap:
                return "TutorialEditSalesFloorMapVer2.0.0"
            case .accountDescription:
                return "TutorialAccountDescriptionVer2.0.0"
            case .accountCreate:
                return "TutorialAccountCreateVer2.0.0"
            case .shareSettings:
                return "TutorialShareSettingsVer2.0.0"
            case .accountDelete:
                return "TutorialAccountDeleteVer2.0.0"
            case .offLine:
                return "TutorialOffLineVer2.0.0"
        }
    }
}


