//
//  PageViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/15.
//

import UIKit

class PageViewController: UIPageViewController {

    // ① PageView上で表示するViewControllerを管理する配列
    private var controllers: [UIViewController] = []

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // ②初期化
        self.initPageView()
    }

    /// ②初期化（PageViewで表示するViewをセット）
    func initPageView(){
        // PageViewControllerで表示するViewControllerをインスタンス化
        let customSalesFloorMapViewStoryboard = UIStoryboard(name: "CustomSalesFloorMapView", bundle: nil)
        let customSalesFloorMapVC = customSalesFloorMapViewStoryboard.instantiateViewController(
            withIdentifier: "CustomSalesFloorMapView") as! CustomSalesFloorMapViewController

        let defaultSalesFloorMapViewStoryboard = UIStoryboard(name: "DefaultSalesFloorMapView", bundle: nil)
        let defaultSalesFloorMapVC = defaultSalesFloorMapViewStoryboard.instantiateViewController(
            withIdentifier: "DefaultSalesFloorMapView") as! DefaultSalesFloorMapViewController

        // インスタンス化したViewControllerを配列に追加
        self.controllers = [ customSalesFloorMapVC, defaultSalesFloorMapVC ]

        // 最初に表示するViewControllerを指定する
        setViewControllers([self.controllers[0]],
                           direction: .forward,
                           animated: true,
                           completion: nil)

        // PageViewControllerのDataSourceとの関連付け
        self.dataSource = self
    }
}

// MARK: - UIPageViewController DataSource
extension PageViewController: UIPageViewControllerDataSource {
    // スクロールするページ数
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.controllers.count
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
