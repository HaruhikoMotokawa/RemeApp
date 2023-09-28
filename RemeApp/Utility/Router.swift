//
//  Router.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/21.
//

import UIKit

// 開発時にホットリロードするならコメントアウト解除
//import Inject

/// 画面遷移に関する処理を担うクラス
final class Router {
    static let shared = Router()
    private init() {}

//  let vc = Inject.ViewControllerHost(TutorialMenuViewController())

    /// 起動経路メソッド
    internal func showRoot(windowScene: UIWindowScene) -> UIWindow {
        //Windowをインスタンス化
        let window = UIWindow(windowScene: windowScene)
        //rootViewControllerに指定したいControllerを指定
        //StoryboardからViewControllerを生成
        window.rootViewController = UIStoryboard(name: "UITabBarControllerView", bundle: nil)
            .instantiateInitialViewController()
//      let rootVC = vc
//      window.rootViewController = rootVC
        window.makeKeyAndVisible()
        return window
    }

    /// アプリダウンロード初回起動後の導入画面へ遷移
    internal func showIntroduction(from: UIViewController) {
        guard let introductionVC = UIStoryboard(name: "IntroductionPageView" , bundle: nil)
            .instantiateInitialViewController() as? IntroductionPageViewController else { return }
        introductionVC.modalPresentationStyle = .fullScreen
        show(from: from, to: introductionVC)
    }

    /// チュートリアルの詳細画面へ画面遷移
    /// - 第１引数from：遷移元のUIViewController
    /// - 第２引数imageName : imageViewに表示するスクショのアセット名
    internal func showDetailTutorial(from: UIViewController, imageName: String) {
        guard let detailTutorialVC = UIStoryboard(name: "DetailTutorialView" , bundle: nil)
            .instantiateInitialViewController() as? DetailTutorialViewController else { return }
        detailTutorialVC.configurer(imageName: imageName)
        detailTutorialVC.modalPresentationStyle = .fullScreen
        show(from: from, to: detailTutorialVC)
    }

    /// HomeTutorialViewへモーダル遷移
    internal func showHomeTutorial(from: UIViewController) {
        guard let toVC = UIStoryboard(name: "HomeTutorialView", bundle: nil)
            .instantiateInitialViewController() as? HomeTutorialViewController else { return }
        toVC.modalPresentationStyle = .fullScreen
        from.present(toVC, animated: true)
    }

  /// TutorialMenuへモーダル遷移
  internal func showTutorialMenu(from: UIViewController) {
    let toVC = TutorialMenuViewController()
    toVC.modalPresentationStyle = .overCurrentContext
    toVC.modalTransitionStyle = .crossDissolve
    from.present(toVC, animated: false) {
      toVC.showModal()
    }
  }

    /// 買い物リスト詳細画面へ遷移
    internal func showDetailShoppingList(from: UIViewController, shoppingItemData: ShoppingItemModel) {
        guard let toVC = UIStoryboard(name: "DetailShoppingListView", bundle: nil)
            .instantiateInitialViewController() as? DetailShoppingListViewController else { return }
        Cache.shared.getImage(photoURL: shoppingItemData.photoURL) { image in
            toVC.configurer(detail: shoppingItemData, image: image)
        }
        toVC.modalTransitionStyle = .crossDissolve
        from.present(toVC, animated: true)
    }

    /// 売り場買い物リストへ遷移
    internal func showSalesFloorShoppingList(from: UIViewController, salesFloorRawValue: Int) {
        guard let toVC = UIStoryboard(name: "SalesFloorShoppingListView", bundle: nil)
            .instantiateInitialViewController() as? SalesFloorShoppingListViewController else { return }
        toVC.salesFloorRawValue = salesFloorRawValue
        show(from: from, to: toVC)
    }

    /// CreateAccountViewに画面遷移、デリゲートセット
    internal func showCreateAccount(from: AccountViewController) {
        guard
            let toVC = UIStoryboard(name: "CreateAccountView", bundle: nil)
            .instantiateInitialViewController() as? CreateAccountViewController
        else { return }
        toVC.delegate = from
        show(from: from, to: toVC)
    }

    /// SignInViewの画面遷移、デリゲートセット
    internal func showSignIn(from: AccountViewController) {
        guard
            let toVC = UIStoryboard(name: "SignInView", bundle: nil)
                .instantiateInitialViewController() as? SignInViewController
        else { return }
        toVC.delegate = from
        show(from: from, to: toVC)
    }

    /// 共有設定画面に画面遷移
    internal func showShareSettingsView(from: UIViewController) {
        guard let toVC = UIStoryboard(name: "ShareSettingsView", bundle: nil)
            .instantiateInitialViewController() as? ShareSettingsViewController else { return }
        show(from: from, to: toVC)
    }

    /// 編集画面に遷移
    /// 新規作成フラグをtrueで新規、falseで編集
    /// 第３引数のshoppingItemDataはデフォルトでnil、編集時は代入する
    internal func showEditItem(from: UIViewController, isNewItem: Bool , shoppingItemData: ShoppingItemModel? = nil) {
        guard let toVC = UIStoryboard(name: "EditItemView", bundle: nil)
            .instantiateInitialViewController() as? EditItemViewController else { return }
        toVC.isNewItem = isNewItem
        if !isNewItem {
            guard let shoppingItemData else { return }
            Cache.shared.getImage(photoURL: shoppingItemData.photoURL) { image in
                toVC.configurer(detail: shoppingItemData, image: image)
            }
        }
        show(from: from, to: toVC)
    }

    /// 売り場選択画面に遷移
    /// 選択後にボタンの見た目を変更するためにデリデートをセット
    internal func showSelectTypeOfSalesFloorView(from: EditItemViewController) {
        guard let toVC = UIStoryboard(name: "SelectTypeOfSalesFloorView", bundle: nil)
            .instantiateInitialViewController() as? SelectTypeOfSalesFloorViewController else { return }
        toVC.delegate = from
        show(from: from, to: toVC)
    }

    internal func showEditSelectedSalesFloorView(from: UIViewController, selectedFloor: CustomSalesFloorModel) {
        guard let toVC = UIStoryboard(name: "EditSelectedSalesFloorView", bundle: nil)
            .instantiateInitialViewController() as? EditSelectedSalesFloorViewController else { return }
        toVC.configurer(detail: selectedFloor)
        show(from: from, to: toVC)
    }
}

private extension Router {

    func show(from: UIViewController, to: UIViewController, completion:(() -> Void)? = nil){
        if let nav = from.navigationController {
            nav.pushViewController(to, animated: true)
            completion?()
        } else {
            from.present(to, animated: true, completion: completion)
        }
    }
}
