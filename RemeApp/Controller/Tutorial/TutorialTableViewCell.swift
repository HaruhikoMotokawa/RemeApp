//
//  TutorialTableViewCell.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/09/27.
//

import UIKit
/// チュートリアルのメニュー画面に使用するカスタムセル
final class TutorialTableViewCell: UITableViewCell {
  /// セル登録時に使用するプロパティ
  static var className: String { String(describing: TutorialTableViewCell.self) }
  /// チュートリアル詳細画面に渡すアセッツ名を保持するプロパティ
  private var imageName: String = ""
  /// 大元のスタックビュー
  private lazy var mainStackView: UIStackView = {
    let mainStackView = UIStackView()
    mainStackView.axis = .horizontal
    mainStackView.alignment = .fill
    mainStackView.distribution = .equalSpacing
    mainStackView.spacing = 8
    mainStackView.addArrangedSubview(subStackView)
    mainStackView.addArrangedSubview(arrowIcon)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    return mainStackView
  }()
  /// 左側のアイコンとタイトルを配置するスタックビュー
  private lazy var subStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .leading
    stackView.distribution = .fill
    stackView.spacing = 8
    stackView.addArrangedSubview(iconImage)
    stackView.addArrangedSubview(titleLabel)
    return stackView
  }()
  /// 各コンテンツ用のアイコン
  private var iconImage: UIImageView! = {
    let image = UIImageView()
    image.image = UIImage(systemName: "list.clipboard")
    image.contentMode = .scaleAspectFit
    image.tintColor = .black
    return image
  }()
  /// タイトル
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "これはテストです"
    label.numberOfLines = 0
    return label
  }()
  /// 右端の矢印アイコン
  private let arrowIcon: UIImageView! = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    image.image = UIImage(systemName: "chevron.forward.circle")
    image.tintColor = .black
    return image
  }()
  /// セルが初期化された際の表示を決める
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }
  /// セルの再利用時の表示を決める
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
  }
  /// 制約を決める
  private func setupViews() {
    addSubview(mainStackView)
    NSLayoutConstraint.activate([
      mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
      mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
      mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
    ])
  }
  /// 表示するデータを配置する
  func setData(icon: String, title: String, imageName: String) {
    // enumは同一文字列指定できないので、ここで帳尻合わせ
    if icon == "person.fill1" ||
        icon == "person.fill2" ||
        icon == "person.fill3" {
      iconImage.image = UIImage(systemName: "person.fill")
    } else {
      iconImage.image = UIImage(systemName: icon)
    }
    titleLabel.text = title
    self.imageName = imageName
  }
}
