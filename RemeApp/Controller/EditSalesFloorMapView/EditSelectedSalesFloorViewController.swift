//
//  EditSelectedSalesFloorViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/13.
//

import UIKit
import RealmSwift

/// 選択した売り場編集
final class EditSelectedSalesFloorViewController: UIViewController {

    // MARK: - @IBOutlet & @IBAction
    /// 売り場の名称を入力するテキストフィールド
    @IBOutlet private weak var nameOfSalesFloorTextField: UITextField! {
        didSet {
            nameOfSalesFloorTextField.delegate = self
        }
    }

    /// 選択された売り場の色を表示するview
    @IBOutlet private weak var selectedSalesFloorColorView: UIView! {
        didSet {
            selectedSalesFloorColorView.layer.borderWidth = 1
            selectedSalesFloorColorView.layer.borderColor = UIColor.black.cgColor
            selectedSalesFloorColorView.layer.cornerRadius = 10
            selectedSalesFloorColorView.clipsToBounds = true
        }
    }

    /// 売り場のカラーをgreenで選択するbutton
    @IBOutlet private weak var greenButton: UIButton! {
        didSet {
            greenButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            greenButton.backgroundColor = CustomSalesFloorColor.green.color
        }
    }

    /// 売り場のカラーをsystemTealで選択するbutton
    @IBOutlet private weak var systemTealButton: UIButton! {
        didSet {
            systemTealButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            systemTealButton.backgroundColor = CustomSalesFloorColor.systemTeal.color
        }
    }


    /// 売り場のカラーをblueで選択するbutton
    @IBOutlet private weak var blueButton: UIButton! {
        didSet {
            blueButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            blueButton.backgroundColor = CustomSalesFloorColor.blue.color
        }
    }


    /// 売り場のカラーをsystemPurpleで選択するbutton
    @IBOutlet private weak var systemPurpleButton: UIButton! {
        didSet {
            systemPurpleButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            systemPurpleButton.backgroundColor = CustomSalesFloorColor.systemPurple.color
        }
    }

    /// 売り場のカラーをsystemPinkで選択するbutton
    @IBOutlet private weak var systemPinkButton: UIButton! {
        didSet {
            systemPinkButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            systemPinkButton.backgroundColor = CustomSalesFloorColor.systemPink.color
        }
    }

    /// 売り場のカラーをpurpleで選択するbutton
    @IBOutlet private weak var purpleButton: UIButton! {
        didSet {
            purpleButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            purpleButton.backgroundColor = CustomSalesFloorColor.purple.color
        }
    }

    /// 売り場のカラーをbrownで選択するbutton
    @IBOutlet private weak var brownButton: UIButton! {
        didSet {
            brownButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            brownButton.backgroundColor = CustomSalesFloorColor.brown.color
        }
    }


    /// 売り場のカラーをredで選択するbutton
    @IBOutlet private weak var redButton: UIButton! {
        didSet {
            redButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            redButton.backgroundColor = CustomSalesFloorColor.red.color
        }
    }


    /// 売り場のカラーをsystemRedで選択するbutton
    @IBOutlet private weak var yellowButton: UIButton! {
        didSet {
            yellowButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            yellowButton.backgroundColor = CustomSalesFloorColor.yellow.color

        }
    }


    /// 売り場のカラーをmagentaで選択するbutton
    @IBOutlet private weak var magentaButton: UIButton! {
        didSet {
            magentaButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            magentaButton.backgroundColor = CustomSalesFloorColor.magenta.color
        }
    }


    /// 売り場のカラーをsystemGrayで選択するbutton
    @IBOutlet private weak var systemMintButton: UIButton! {
        didSet {
            systemMintButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            systemMintButton.backgroundColor = CustomSalesFloorColor.systemMint.color
        }
    }

    /// 売り場のカラーをsystemGreenで選択するbutton
    @IBOutlet private weak var systemGreenButton: UIButton! {
        didSet {
            systemGreenButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            systemGreenButton.backgroundColor = CustomSalesFloorColor.systemGreen.color
        }
    }

    /// 売り場のカラーをsystemIndigoで選択するbutton
    @IBOutlet private weak var systemIndigoButton: UIButton! {
        didSet {
            systemIndigoButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            systemIndigoButton.backgroundColor = CustomSalesFloorColor.systemIndigo.color
        }
    }

    /// 売り場のカラーをcyanで選択するbutton
    @IBOutlet private weak var cyanButton: UIButton! {
        didSet {
            cyanButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            cyanButton.backgroundColor = CustomSalesFloorColor.cyan.color
        }
    }

    /// 売り場のカラーをsystemBlueで選択するbutton
    @IBOutlet private weak var systemBlueButton: UIButton! {
        didSet {
            systemBlueButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            systemBlueButton.backgroundColor = CustomSalesFloorColor.systemBlue.color

        }
    }


    /// 売り場のカラーをsystemYellowで選択するbutton
    @IBOutlet private weak var systemYellowButton: UIButton! {
        didSet {
            systemYellowButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            systemYellowButton.backgroundColor = CustomSalesFloorColor.systemYellow.color
        }
    }


    /// 売り場のカラーをorangeで選択するbutton
    @IBOutlet private weak var orangeButton: UIButton! {
        didSet {
            orangeButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            orangeButton.backgroundColor = CustomSalesFloorColor.orange.color
        }
    }


    /// キャンセルボタン
    @IBOutlet private weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setAppearanceWithShadow(fontColor: .black)
            cancelButton.backgroundColor = .lightGray
            cancelButton.addTarget(self, action: #selector(showCancelAlert), for: .touchUpInside)
        }
    }


    /// 保存ボタン
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.setAppearanceWithShadow(fontColor: .black)
            saveButton.backgroundColor = .lightGray
            saveButton.addTarget(self, action: #selector(addOrReEnter), for: .touchUpInside)
        }
    }


    // MARK: - property

    /// 売り場に対応するRawValue
    private var customSalesFloorRawValue:Int = 0
    
    /// nameOfItemLabelに表示するテキスト
    private var nameOfSalesFloorTextFieldText:String = ""

    /// selectedSalesFloorColorViewに表示する色
    private var selectedSalesFloorColorViewColor:CustomSalesFloorColor = .green

    /// カスタム売り場マップのリスト
    private var customSalesFloorData = CustomSalesFloorModel()

    // selectedFloorを受け取るプロパティを定義
    var selectedFloor: CustomSalesFloorModel?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNetWorkObserver()
        updateButtonAppearance()
        setKeyboardCloseButton()
        displayData()
    }

    // MARK: - func
    /// 選択した売り場の情報を持って画面遷移する
    @objc private func colorButtonTapped(_ sender: UIButton) {
        switch sender {
            case greenButton:
                return selectColor(type: .green)
            case systemTealButton:
                return selectColor(type: .systemTeal)
            case blueButton:
                return selectColor(type: .blue)
            case systemPurpleButton:
                return selectColor(type: .systemPurple)
            case systemPinkButton:
                return selectColor(type: .systemPink)
            case purpleButton:
                return selectColor(type: .purple)
            case brownButton:
                return selectColor(type: .brown)
            case redButton:
                return selectColor(type: .red)
            case yellowButton:
                return selectColor(type: .yellow)
            case magentaButton:
                return selectColor(type: .magenta)
            case systemMintButton:
                return selectColor(type: .systemMint)
            case systemGreenButton:
                return selectColor(type: .systemGreen)
            case systemIndigoButton:
                return selectColor(type: .systemIndigo)
            case cyanButton:
                return selectColor(type: .cyan)
            case systemBlueButton:
                return selectColor(type: .systemBlue)
            case systemYellowButton:
                return selectColor(type: .systemYellow)
            case orangeButton:
                return selectColor(type: .orange)
            default: break
        }
    }

    /// 選択した色をUIViewに表示
    private func selectColor(type: CustomSalesFloorColor) {
        selectedSalesFloorColorView.backgroundColor = type.color
        selectedSalesFloorColorViewColor = type
    }

    /// ネットワーク関連の監視の登録
    private func setNetWorkObserver() {
        // NotificationCenterに通知を登録する
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatusDidChange),
                                               name: .networkStatusDidChange, object: nil)
    }

    /// オフライン時の処理
    @objc func handleNetworkStatusDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            // オフラインになったらアラートを出す
            if !NetworkMonitor.shared.isConnected {
                AlertController.showOffLineAlert(tittle: "オフラインです",
                                                 message:
            """
            ① 最新の情報が反映されません
            ② 写真データは表示できません
            ③ アカウント関連の操作はできません
            ④ 買い物リストの作成と編集で
            　 写真添付と削除ができません
            ⑤ 買い物リスト作成と編集は
               できますが上限があります
            """, view: self)
            }
        }
    }

    /// 各カラー選択ボタンに背景色以外の項目を設定
    /// - テキストラベルに「選択」を表示
    /// - ボタンの基本装飾と影を設定
    private func updateButtonAppearance() {
        /// ボタンの配列を順番に設定
        let buttons = [greenButton, systemTealButton, blueButton, systemPurpleButton, systemPinkButton,
                       purpleButton, brownButton, redButton, yellowButton, magentaButton,
                       systemMintButton, systemGreenButton, systemIndigoButton, cyanButton, systemBlueButton,
                       systemYellowButton, orangeButton]
        // for文でbuttonsに順番にアクセス
        for button in buttons {
            button?.setTitle("選択", for: .normal)
            button?.setAppearanceWithShadow(fontColor: .black)
        }
    }

    /// 売り場選択からもらった情報を表示
    /// 受け渡されたデータをそれぞれのUI部品に表示

    private func displayData() {
        nameOfSalesFloorTextField.text = nameOfSalesFloorTextFieldText
        selectedSalesFloorColorView.backgroundColor = selectedSalesFloorColorViewColor.color
    }

    /// データ受け渡し用のメソッド
    func configurer(detail: CustomSalesFloorModel) {
        selectedFloor = detail
        customSalesFloorData = detail
        nameOfSalesFloorTextFieldText = detail.customNameOfSalesFloor
        selectedSalesFloorColorViewColor = detail.customSalesFloorColor
    }

    /// アラートで確認するメソッド
    /// - 編集を中止て前の画面に戻るか
    /// - 中止をキャンセルして画面に止まるか
    @objc private func showCancelAlert() {
        let alertController = UIAlertController(title: "編集を中止", message:
                                                    "編集内容を破棄してもよろしいですか？", preferredStyle: .alert)
        // はいでEditSalesFloorMapViewに戻る
        let okAction = UIAlertAction(title: "はい", style: .default, handler:  { (action) in
            self.dismiss(animated: true)
        })
        // キャンセル、何もしない
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    /// 追加ボタンをタップした時の処理
    /// - 商品名が未入力の場合はアラートを出す
    /// - 商品名が入力されていればデータを書き込み、画面を閉じる
    @objc private func addOrReEnter() {
        if nameOfSalesFloorTextField.text == "" {
            // 警告アラート
            let alertController = UIAlertController(title: nil, message:
                                                        "売り場の名称は必ず入力してください", preferredStyle: .alert)
            // 何も処理をしないで画面を閉じる
            let reEnterAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(reEnterAction)
            present(alertController, animated: true)
        } else {
            // 編集されたデータを保存する
            let realm = try! Realm()
            try! realm.write {
                selectedFloor!.customNameOfSalesFloor = nameOfSalesFloorTextField.text!
                selectedFloor!.customSalesFloorColor = selectedSalesFloorColorViewColor
            }
            // 画面を閉じて前画面に戻る
            dismiss(animated: true)
        }
    }

    /// キーボードの完了ボタン配置、完了ボタン押してキーボードを非表示に変更するメソッド
    private func setKeyboardCloseButton() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [doneButton]
        nameOfSalesFloorTextField.inputAccessoryView = toolbar
    }

    /// 閉じるボタンを押した時にキーボードを閉じるメソッド
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
}

// MARK: UITextFieldDelegate
extension EditSelectedSalesFloorViewController: UITextFieldDelegate {
    /// textFieldの文字数制限を８文字以内に設定
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        let maxLength = 8
        return newLength <= maxLength
    }
}
