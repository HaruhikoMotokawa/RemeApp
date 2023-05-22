//
//  TutorialPageViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/05/22.
//

import UIKit

class TutorialPageViewController: UIPageViewController {
    // ① PageView上で表示するViewControllerを管理する配列
    private var controllers: [UIViewController] = []

    //var currentPageでページ番号を管理
    private var currentPage = 0

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // ②初期化
        self.initPageView()
    }

    /// ②初期化（PageViewで表示するViewをセット）
    private func initPageView(){
        // PageViewControllerで表示するViewControllerをインスタンス化
        // TutorialEditShoppingListView
        let tutorialEditShoppingListViewStoryboard = UIStoryboard(name: "TutorialEditShoppingListView", bundle: nil)
        let tutorialEditShoppingListVC = tutorialEditShoppingListViewStoryboard.instantiateViewController(
            withIdentifier: "TutorialEditShoppingListView") as! TutorialEditShoppingListViewController

        // TutorialEditSalesFloorMapView
        let tutorialEditSalesFloorMapViewStoryboard = UIStoryboard(name: "TutorialEditSalesFloorMapView", bundle: nil)
        let tutorialEditSalesFloorMapVC = tutorialEditSalesFloorMapViewStoryboard.instantiateViewController(
            withIdentifier: "TutorialEditSalesFloorMapView") as! TutorialEditSalesFloorMapViewController

        // TutorialShoppingView
        let tutorialShoppingViewStoryboard = UIStoryboard(name: "TutorialShoppingView", bundle: nil)
        let tutorialShoppingViewVC = tutorialShoppingViewStoryboard.instantiateViewController(
            withIdentifier: "TutorialShoppingView") as! TutorialShoppingViewController

        // インスタンス化したViewControllerを配列に追加
        self.controllers = [ tutorialEditShoppingListVC, tutorialEditSalesFloorMapVC, tutorialShoppingViewVC]

        // 最初に表示するViewControllerを指定する
        setViewControllers([self.controllers[0]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        // それぞれの画面で移動するページを指定
        // TutorialEditShoppingListView
        tutorialEditShoppingListVC.onNextButtonTapped = {
            self.currentPage = 1
            self.setViewControllers([tutorialEditSalesFloorMapVC], direction: .forward, animated: true)
        }

        // TutorialEditSalesFloorMapView
        tutorialEditSalesFloorMapVC.onBackButtonTapped = {
            self.currentPage = 0
            self.setViewControllers([tutorialEditShoppingListVC], direction: .reverse, animated: true)
        }
        tutorialEditSalesFloorMapVC.onNextButtonTapped = {
            self.currentPage = 2
            self.setViewControllers([tutorialShoppingViewVC], direction: .forward, animated: true)
        }

        // TutorialShoppingView
        tutorialShoppingViewVC.onBackButtonTapped = {
            self.currentPage = 1
            self.setViewControllers([tutorialEditSalesFloorMapVC], direction: .reverse, animated: true)
        }
        tutorialShoppingViewVC.onNextButtonTapped = {
            self.currentPage = 0
            self.setViewControllers([tutorialEditShoppingListVC], direction: .forward, animated: true)
        }

        // PageViewControllerのDataSourceとの関連付け
        self.dataSource = self
    }
    
}

// MARK: - UIPageViewController DataSource
extension TutorialPageViewController: UIPageViewControllerDataSource {
    // スクロールするページ数
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.controllers.count
    }

    //現在のページを返すメソッド
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPage
    }

    // 左にスワイプした時の処理
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.controllers.firstIndex(of: viewController),
           index < self.controllers.count - 1 {
            return self.controllers[index + 1]
        } else {
            return nil
        }
    }

    // 右にスワイプした時の処理
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.controllers.firstIndex(of: viewController),
           index > 0 {
            return self.controllers[index - 1]
        } else {
            return nil
        }
    }
}

