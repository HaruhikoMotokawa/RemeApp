//
//  Router.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/21.
//

import UIKit

final class Router {
    static let shared = Router()
    private init() {}

    /// 起動経路メソッド
    internal func showRoot(windowScene: UIWindowScene) -> UIWindow {
        //Windowをインスタンス化
        let window = UIWindow(windowScene: windowScene)
        //rootViewControllerに指定したいControllerを指定
        //StoryboardからViewControllerを生成
        window.rootViewController = UIStoryboard(name: "UITabBarControllerView", bundle: nil)
            .instantiateInitialViewController()
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

    /// 買い物リストから買い物リスト詳細画面へ遷移
    internal func showDetailShoppingList(from: UIViewController, shoppingItemData: ShoppingItemModel) {
        guard let toVC = UIStoryboard(name: "DetailShoppingListView", bundle: nil)
            .instantiateInitialViewController() as? DetailShoppingListViewController else { return }
        Cache.shared.getImage(photoURL: shoppingItemData.photoURL) { image in
            toVC.configurer(detail: shoppingItemData, image: image)
        }
        toVC.modalTransitionStyle = .crossDissolve
        from.present(toVC, animated: true)
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
