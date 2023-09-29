//
//  TutorialMenuViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/09/26.
//

import UIKit
/// 操作手順を説明するチュートリアルをまとめたサイドメニュー
final class TutorialMenuViewController: UIViewController {
  /// baseViewの右側の制約
  private var baseViewTrailingConstraint: NSLayoutConstraint!
  /// baseViewの左側の制約
  private var baseViewLeadingConstraint: NSLayoutConstraint!
  /// 画面全体に広がるビュー、タップ操作あり
  private lazy var touchView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0.5 // 透明度を上げて下のビューを見えるようにする
    view.translatesAutoresizingMaskIntoConstraints = false

    let touch = UITapGestureRecognizer(
      target: self, action: #selector(touchDismiss))
    view.addGestureRecognizer(touch)
    return view
  }()
  /// サイドメニューの土台のビュー
  private var baseView: UIView = {
    let view = UIView()
    view.backgroundColor = .darkGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  /// チュートリアル一覧を表示するテーブルビュー
  private lazy var menuTableView: UITableView = {
    let tableview = UITableView()
    tableview.translatesAutoresizingMaskIntoConstraints = false
    tableview.register(TutorialTableViewCell.self,
                       forCellReuseIdentifier: TutorialTableViewCell.className)
    tableview.dataSource = self
    tableview.delegate = self
    return tableview
  }()
  // MARK: -viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear // 大元のビューは透明にする
    setUpViews()
  }
  /// モーダルメニューを表示させる
  internal func showModal() {
    // baseView左右の制約を変更して、画面外の左側にあるbaseViewを画面内に移動する
    baseViewTrailingConstraint.constant = -(view.bounds.width / 3)
    baseViewLeadingConstraint.constant = 0
    UIView.animate(withDuration: 0.2) { // アニメーションをさせながら
      self.view.layoutIfNeeded() // レイアウト変更を実行
    }
  }
  // MARK: - struct Tutorial
  struct Tutorial {
    var icon: Icon
    var title: Title
    var imageName: ImageName
    /// menuTableViewに表示するデータ配列
    static var tutorials: [[Tutorial]] {
      return [
        [ // セクション0
          Tutorial(icon: .dismissView, title: .dismissView, imageName: .dismissView)
        ],
        [ // セクション1
          Tutorial(icon: .shoppingList, title: .shoppingList, imageName: .shoppingList),
          Tutorial(icon: .salesFloorMap, title: .salesFloorMap, imageName: .salesFloorMap),
          Tutorial(icon: .editShoppingList, title: .editShoppingList, imageName: .editShoppingList),
          Tutorial(icon: .editSalesFloorMap, title: .editSalesFloorMap, imageName: .editSalesFloorMap),
        ],
        [ // セクション2
          Tutorial(icon: .accountDescription, title: .accountDescription, imageName: .accountDescription),
          Tutorial(icon: .accountCreate, title: .accountCreate, imageName: .accountCreate),
          Tutorial(icon: .shareSettings, title: .shareSettings, imageName: .shareSettings),
          Tutorial(icon: .accountDelete, title: .accountDelete, imageName: .accountDelete),
        ],
        [ // セクション3
          Tutorial(icon: .offLine, title: .offLine, imageName: .offLine),
          Tutorial(icon: .legalNotice, title: .legalNotice, imageName: .legalNotice)
        ],
      ]
    }
  }
  // MARK: - enum Icon,Title,ImageName
  /// アイコンの画像名を管理
  enum Icon: String {
    case shoppingList = "list.clipboard"
    case salesFloorMap = "map"
    case editShoppingList = "rectangle.and.pencil.and.ellipsis"
    case editSalesFloorMap = "square.and.pencil"
    case accountDescription = "person.fill"
    case accountCreate = "person.fill1"
    case shareSettings = "person.fill2"
    case accountDelete = "person.fill3"
    case offLine = "wifi.slash"
    case legalNotice = "doc.fill"
    case dismissView = "xmark"
  }
  /// ラベルのタイトル
  enum Title: String {
    case shoppingList = "買い物リスト"
    case salesFloorMap = "売り場マップ"
    case editShoppingList = "買い物リスト編集"
    case editSalesFloorMap = "売り場マップ編集"
    case accountDescription = "アカウントの概要"
    case accountCreate = "アカウント作成"
    case shareSettings = "共有設定"
    case accountDelete = "アカウントの削除"
    case offLine = "オフライン対応"
    case legalNotice = "法的表示"
    case dismissView = "画面を閉じる"
  }
  /// チュートリアルに表示する画像名を管理
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
    case legalNotice = "legalNoticeはイメージなし" //いらないけど一応設定
    case dismissView = "dismissViewはイメージなし" //いらないけど一応設定
  }
}

// MARK: -オートレイアウト関連
private extension TutorialMenuViewController {
  /// 全てのviewの制約をセット
  func setUpViews() {
    makeTouchView()
    makeBaseView()
    makeMenuTableView()
  }
  /// touchViewのオートレイアウト
  func makeTouchView() {
    view.addSubview(touchView)
    NSLayoutConstraint.activate([
      touchView.topAnchor.constraint(equalTo: view.topAnchor),
      touchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      touchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      touchView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  /// baseViewのオートレイアウト
  func makeBaseView() {
    baseViewTrailingConstraint = baseView.trailingAnchor.constraint(
      equalTo: view.trailingAnchor,
      constant: -view.bounds.width
    )
    baseViewLeadingConstraint = baseView.leadingAnchor.constraint(
      equalTo: view.leadingAnchor,
      constant: -view.bounds.width
    )
    view.addSubview(baseView)
    NSLayoutConstraint.activate([
      baseView.topAnchor.constraint(equalTo: view.topAnchor),
      baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      baseViewLeadingConstraint,
      baseViewTrailingConstraint,
    ])
  }
  /// menuTableViewのオートレイアウト
  func makeMenuTableView() {
    baseView.addSubview(menuTableView)
    NSLayoutConstraint.activate([
      menuTableView.topAnchor.constraint(
        equalTo: baseView.safeAreaLayoutGuide.topAnchor,
        constant: 47
      ),
      menuTableView.bottomAnchor.constraint(
        equalTo: baseView.safeAreaLayoutGuide.bottomAnchor,
        constant: -48
      ),
      menuTableView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
      menuTableView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
    ])
  }
}
// MARK: - private func
private extension TutorialMenuViewController {
  /// touchViewのタッチアクション
  @objc func touchDismiss() {
    dismissModal()
  }
  /// 画面を閉じる処理
  func dismissModal() {
    // baseView左右の制約を変更して、画面外の左側に移動させる
    baseViewTrailingConstraint.constant = -view.bounds.width
    baseViewLeadingConstraint.constant = -view.bounds.width
    UIView.animate(withDuration: 0.2) { // アニメーションを実行させながら
      self.view.layoutIfNeeded() // レイアウト変更を実行
    }
    dismiss(animated: true) // レイアウト変更後にこの画面自体を閉じる
  }
}
// MARK: - UITableViewDataSource
extension TutorialMenuViewController: UITableViewDataSource {
  /// セクションのタイトル
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
      case 1:
        return "操作説明"
      case 2:
        return "アカウント関連"
      case 3:
        return "注意事項と法的表示"
      default:
        return ""
    }
  }
  /// 表示するセクション数
  func numberOfSections(in tableView: UITableView) -> Int {
    return Tutorial.tutorials.count
  }
  /// セクションごとに表示する行数
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Tutorial.tutorials[section].count
  }
  /// セルに表示する内容
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(
      withIdentifier: TutorialTableViewCell.className, for: indexPath)
        as? TutorialTableViewCell {
      let tutorial = Tutorial.tutorials[indexPath.section][indexPath.row]
      cell.setData(
        icon: tutorial.icon.rawValue,
        title: tutorial.title.rawValue,
        imageName: tutorial.imageName.rawValue
      )
      return cell
    }
    return UITableViewCell()
  }
}
// MARK: - UITableViewDelegate
extension TutorialMenuViewController: UITableViewDelegate {
  /// セル選択時の処理
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dismissViewSection = 0
    let dismissViewIndexPath = 0
    let legalNoticeSection = 3
    let legalNoticeIndexPath = 1

    let tutorial = Tutorial.tutorials[indexPath.section][indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true) // 選択後に選択状態解除
    // セクションとインデックパスによってセルごとの挙動を変える
    switch (indexPath.section, indexPath.row) {
      case (dismissViewSection, dismissViewIndexPath): // 画面を閉じる
        return dismissModal()
      case (legalNoticeSection, legalNoticeIndexPath): // 設定画面に移動
        guard
          let settingsUrl = URL(string: UIApplication.openSettingsURLString)
        else { return }
        return UIApplication.shared.open(settingsUrl)
      default : // 個別のチュートリアルを表示
        return Router.shared.showDetailTutorial(
          from: self,
          imageName: tutorial.imageName.rawValue
        )
    }
  }
}
