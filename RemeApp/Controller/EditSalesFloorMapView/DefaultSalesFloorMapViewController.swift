//
//  DefaultSalesFloorMapViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/15.
//

import UIKit

final class DefaultSalesFloorMapViewController: UIViewController {

    // MARK: - @IBOutlet
    /// 売り場のマップでデフォルトを選択した場合に表示するView
    @IBOutlet private weak var defaultSelectCheckMark: UIImageView!

    /// 売り場のボタン：StoryboardのA-1
    @IBOutlet private weak var greenThreeButton: UIButton!

    /// 売り場のボタン：StoryboardのA-2
    @IBOutlet private weak var blueThreeButton: UIButton!

    /// 売り場のボタン：StoryboardのA-3
    @IBOutlet private weak var redThreeButton: UIButton!

    /// 売り場のボタン：StoryboardのB-1
    @IBOutlet private weak var greenFourButton: UIButton!

    /// 売り場のボタン：StoryboardのB-2
    @IBOutlet private weak var greenTwoButton: UIButton!

    /// 売り場のボタン：StoryboardのB-3
    @IBOutlet private weak var blueSevenButton: UIButton!

    /// 売り場のボタン：StoryboardのB-4
    @IBOutlet private weak var blueFourButton: UIButton!

    /// 売り場のボタン：StoryboardのB-5
    @IBOutlet private weak var blueTwoButton: UIButton!

    /// 売り場のボタン：StoryboardのB-6
    @IBOutlet private weak var redFourButton: UIButton!

    /// 売り場のボタン：StoryboardのB-7
    @IBOutlet private weak var redTwoButton: UIButton!

    /// 売り場のボタン：StoryboardのC-1
    @IBOutlet private weak var greenFiveButton: UIButton!

    /// 売り場のボタン：StoryboardのC-2
    @IBOutlet private weak var greenOneButton: UIButton!

    /// 売り場のボタン：StoryboardのC-3
    @IBOutlet private weak var blueSixButton: UIButton!

    /// 売り場のボタン：StoryboardのC-4
    @IBOutlet private weak var blueFiveButton: UIButton!

    /// 売り場のボタン：StoryboardのC-5
    @IBOutlet private weak var blueOneButton: UIButton!

    /// 売り場のボタン：StoryboardのC-6
    @IBOutlet private weak var redFiveButton: UIButton!

    /// 売り場のボタン：StoryboardのC-7
    @IBOutlet private weak var redOneButton: UIButton!

    /// レジのラベル
    @IBOutlet private weak var registerLabel: UILabel!
    /// 左出入り口のラベル
    @IBOutlet private weak var leftEntranceLabel: UILabel!
    /// 右出入り口のラベル
    @IBOutlet private weak var rightEntranceLabel: UILabel!

    /// 買い物ルート設定で左回りを選択した場合に表示するView
    @IBOutlet private weak var leftCartView: UIImageView!
    /// 買い物ルート設定で右回りを選択した場合に表示するView
    @IBOutlet private weak var rightCartView: UIImageView!

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setHorizontalSalesFloorButtonAppearance()
        setVerticalSalesFloorButtonAppearance()
        setDefaultSalesFloorButton()
        setBorderAllLabel()
        setDefaultSelectCheckMark()
        setCartView()
    }

    // MARK: - func
    /// レジ、左出入り口、右出入り口のラベルに枠線を設定するメソッド
    private func setBorderAllLabel() {
        registerLabel.setBorder()
        leftEntranceLabel.setBorder()
        rightEntranceLabel.setBorder()
    }

    /// 登録された使用マップ設定によってチェックマークの表示を切り替えるメソッド
    /// - NotificationCenterの通知受信を設定
    /// - UserDefaultsから設定を取得して画面ローディング時の表示をif文で切り替え
    private func setDefaultSelectCheckMark() {
        NotificationCenter.default.addObserver(self, selector: #selector(showDefaultSelectCheckMark),
                                               name: .showDefaultSelectCheckMark, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideDefaultSelectCheckMark),
                                               name: .hideDefaultSelectCheckMark, object: nil)
        if UserDefaults.standard.useSalesFloorType == SalesFloorMapType.custom.rawValue {
            hideDefaultSelectCheckMark()
        } else {
            showDefaultSelectCheckMark()
        }
    }

    /// NotificationCenterによって使用する売り場のマップをデフォルト選択された場合にdefaultSelectCheckMarkを表示にする
    @objc func showDefaultSelectCheckMark() {
        defaultSelectCheckMark.isHidden = false
    }

    /// NotificationCenterによって使用する売り場のマップをカスタムが選択された場合にdefaultSelectCheckMarkを非表示にする
    @objc func hideDefaultSelectCheckMark() {
        defaultSelectCheckMark.isHidden = true
    }

    /// 登録された買い物の開始位置によってカートのイメージの表示を切り替えるメソッド
    /// - NotificationCenterの通知受信を設定
    /// - UserDefaultsから設定を取得して画面ローディング時の表示をif文で切り替え
    private func setCartView() {
        NotificationCenter.default.addObserver(self, selector: #selector(showLeftCartView),
                                               name: .showLeftCartView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showRightCartView),
                                               name: .showRightCartView, object: nil)
        if UserDefaults.standard.shoppingStartPosition == ShoppingStartPositionType.left.rawValue {
            showLeftCartView() // 左回り設定
        } else {
            showRightCartView() // 右回り設定
        }
    }

    /// NotificationCenterによって買い物ルートを左回りに選択された場合の処理
    /// - leftCartViewを表示にする
    /// - rightCartViewを非表示にする
    @objc func showLeftCartView() {
        leftCartView.isHidden = false
        rightCartView.isHidden = true
    }

    /// NotificationCenterによって買い物ルートを右回りに選択された場合の処理
    /// - rightCartViewを表示にする
    /// - leftCartViewを非表示にする
    @objc func showRightCartView() {
        rightCartView.isHidden = false
        leftCartView.isHidden = true
    }

    /// 売り場の横長ボタンに設定する見た目
    private func setHorizontalSalesFloorButtonAppearance() {
        let horizontalButtons = [greenThreeButton, blueThreeButton, redThreeButton]
        horizontalButtons.forEach { button in
            button!.setHorizontalButtonAppearance()
        }
    }

    /// 売り場の縦長ボタンに設定する見た目
    private func setVerticalSalesFloorButtonAppearance() {
        let verticalButtons = [redOneButton, redTwoButton, redFourButton, redFiveButton,
                               blueOneButton, blueTwoButton, blueFourButton, blueFiveButton,
                               blueSixButton, blueSevenButton, greenOneButton, greenTwoButton,
                               greenFourButton, greenFiveButton]
        verticalButtons.forEach { button in
            button!.setVerticalButtonAppearance()
        }
    }
    /// デフォルト売り場マップの見た目にボタンをセットする
    /// - 名称を設定
    /// - 背景色を設定
    private func setDefaultSalesFloorButton() {
        /// ボタンの配列を順番に設定
        let buttons = [redOneButton, redTwoButton, redThreeButton, redFourButton, redFiveButton,
                       blueOneButton, blueTwoButton, blueThreeButton, blueFourButton, blueFiveButton,
                       blueSixButton, blueSevenButton, greenOneButton, greenTwoButton, greenThreeButton,
                       greenFourButton, greenFiveButton]
        // for文でbuttonsに順番にアクセス
        for (index, button) in buttons.enumerated() {
            let salesFloor = DefaultSalesFloorType(rawValue: index)!
            // 各ボタンに売り場の名称を設定
            button?.setTitle(salesFloor.nameOfSalesFloor, for: .normal)
            // バックグラウンドカラーを設定した色に変更し、ボタンを有効化する
            button?.backgroundColor = salesFloor.colorOfSalesFloor
        }
    }
}
