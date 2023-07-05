//
//  TutorialPageViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/05/22.
//

import UIKit

class IntroductionPageViewController: UIPageViewController {
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
        // FirstIntroductionView
        let firstIntroductionStoryboard = UIStoryboard(name: "FirstIntroductionView", bundle: nil)
        let firstIntroductionVC = firstIntroductionStoryboard.instantiateViewController(
            withIdentifier: "FirstIntroductionView") as! FirstIntroductionViewController

        // SecondIntroductionView
        let secondIntroductionStoryboard = UIStoryboard(name: "SecondIntroductionView", bundle: nil)
        let secondIntroductionVC = secondIntroductionStoryboard.instantiateViewController(
            withIdentifier: "SecondIntroductionView") as! SecondIntroductionViewController

        // ThirdIntroductionView
        let thirdIntroductionStoryboard = UIStoryboard(name: "ThirdIntroductionView", bundle: nil)
        let thirdIntroductionVC = thirdIntroductionStoryboard.instantiateViewController(
            withIdentifier: "ThirdIntroductionView") as! ThirdIntroductionViewController

        // ForceIntroductionView
        let forceIntroductionStoryboard = UIStoryboard(name: "ForceIntroductionView", bundle: nil)
        let forceIntroductionVC = forceIntroductionStoryboard.instantiateViewController(
            withIdentifier: "ForceIntroductionView") as! ForceIntroductionViewController

        // FifthIntroductionView
        let fifthIntroductionStoryboard = UIStoryboard(name: "FifthIntroductionView", bundle: nil)
        let fifthIntroductionVC = fifthIntroductionStoryboard.instantiateViewController(
            withIdentifier: "FifthIntroductionView") as! FifthIntroductionViewController

        // インスタンス化したViewControllerを配列に追加
        self.controllers = [ firstIntroductionVC, secondIntroductionVC, thirdIntroductionVC,
                             forceIntroductionVC, fifthIntroductionVC]

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
extension IntroductionPageViewController: UIPageViewControllerDataSource {
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

