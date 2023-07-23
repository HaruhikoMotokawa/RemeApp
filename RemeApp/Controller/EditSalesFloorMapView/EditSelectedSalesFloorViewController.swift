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
    @IBOutlet private weak var nameOfSalesFloorTextField: UITextField!

    /// 選択された売り場の色を表示するview
    @IBOutlet private weak var selectedSalesFloorColorView: UIView!

    /// 売り場のカラーをgreenで選択するbutton
    @IBOutlet private weak var greenButton: UIButton!
    /// 売り場のカラーをgreenで選択する
    @IBAction private func selectGreen(_ sender: Any) {
        selectColor(type: .green)
    }

    /// 売り場のカラーをsystemTealで選択するbutton
    @IBOutlet private weak var systemTealButton: UIButton!
    /// 売り場のカラーをsystemTealで選択する
    @IBAction private func selectSystemTeal(_ sender: Any) {
        selectColor(type: .systemTeal)
    }

    /// 売り場のカラーをblueで選択するbutton
    @IBOutlet private weak var blueButton: UIButton!
    /// 売り場のカラーをblueで選択する
    @IBAction private func selectBlue(_ sender: Any) {
        selectColor(type: .blue)
    }

    /// 売り場のカラーをsystemPurpleで選択するbutton
    @IBOutlet private weak var systemPurpleButton: UIButton!
    /// 売り場のカラーをsystemPurpleで選択する
    @IBAction private func selectSystemPurple(_ sender: Any) {
        selectColor(type: .systemPurple)
    }

    /// 売り場のカラーをsystemPinkで選択するbutton
    @IBOutlet private weak var systemPinkButton: UIButton!
    /// 売り場のカラーをsystemPinkで選択する
    @IBAction private func selectSystemPink(_ sender: Any) {
        selectColor(type: .systemPink)
    }

    /// 売り場のカラーをpurpleで選択するbutton
    @IBOutlet private weak var purpleButton: UIButton!
    /// 売り場のカラーをpurpleで選択する
    @IBAction private func selectPurple(_ sender: Any) {
        selectColor(type: .purple)
    }

    /// 売り場のカラーをbrownで選択するbutton
    @IBOutlet private weak var brownButton: UIButton!
    /// 売り場のカラーをbrownで選択する
    @IBAction private func selectBrown(_ sender: Any) {
        selectColor(type: .brown)
    }

    /// 売り場のカラーをredで選択するbutton
    @IBOutlet private weak var redButton: UIButton!
    /// 売り場のカラーをredで選択する
    @IBAction private func selectRed(_ sender: Any) {
        selectColor(type: .red)
    }

    /// 売り場のカラーをsystemRedで選択するbutton
    @IBOutlet private weak var systemRedButton: UIButton!
    /// 売り場のカラーをsystemRedで選択する
    @IBAction private func selectSystemRed(_ sender: Any) {
        selectColor(type: .yellow)
    }

    /// 売り場のカラーをmagentaで選択するbutton
    @IBOutlet private weak var magentaButton: UIButton!
    /// 売り場のカラーをmagentaで選択する
    @IBAction func selectMagenta(_ sender: Any) {
        selectColor(type: .magenta)
    }

    /// 売り場のカラーをsystemGrayで選択するbutton
    @IBOutlet private weak var systemGrayButton: UIButton!
    /// 売り場のカラーをsystemGrayで選択する
    @IBAction private func selectSystemGray(_ sender: Any) {
        selectColor(type: .systemGray)
    }

    /// 売り場のカラーをsystemGreenで選択するbutton
    @IBOutlet private weak var systemGreenButton: UIButton!
    /// 売り場のカラーをsystemGreenで選択する
    @IBAction private func selectSystemGreen(_ sender: Any) {
        selectColor(type: .systemGreen)
    }

    /// 売り場のカラーをsystemIndigoで選択するbutton
    @IBOutlet private weak var systemIndigoButton: UIButton!
    /// 売り場のカラーをsystemIndigoで選択する
    @IBAction private func selectSystemIndigo(_ sender: Any) {
        selectColor(type: .systemIndigo)
    }

    /// 売り場のカラーをcyanで選択するbutton
    @IBOutlet private weak var cyanButton: UIButton!
    /// 売り場のカラーをcyanで選択する
    @IBAction private func selectCyan(_ sender: Any) {
        selectColor(type: .cyan)
    }

    /// 売り場のカラーをsystemBlueで選択するbutton
    @IBOutlet private weak var systemBlueButton: UIButton!
    /// 売り場のカラーをsystemBlueで選択する
    @IBAction private func selectSystemBlue(_ sender: Any) {
        selectColor(type: .systemBlue)
    }

    /// 売り場のカラーをsystemYellowで選択するbutton
    @IBOutlet private weak var systemYellowButton: UIButton!
    /// 売り場のカラーをsystemYellowで選択する
    @IBAction private func selectSystemYellow(_ sender: Any) {
        selectColor(type: .systemYellow)
    }

    /// 売り場のカラーをorangeで選択するbutton
    @IBOutlet private weak var orangeButton: UIButton!
    /// 売り場のカラーをorangeで選択する
    @IBAction private func selectOrange(_ sender: Any) {
        selectColor(type: .orange)
    }

    /// キャンセルボタン
    @IBOutlet private weak var cancelButton: UIButton!
    /// 編集をキャンセルして戻る
    @IBAction private func cancelAction(_ sender: Any) {
        showCancelAlert()
    }

    /// 保存ボタン
    @IBOutlet private weak var saveButton: UIButton!
    /// 保存して前の画面に戻る
    @IBAction private func saveAction(_ sender: Any) {
        addOrReEnter()
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
        nameOfSalesFloorTextField.delegate = self
        setColorForSelectionButtons()
        updateButtonAppearance()
        setViewAppearance()
        setCancelAndSaveButtonAppearance()
        setKeyboardCloseButton()
        displayData()
    }

    // MARK: - func

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

    // 各カラー選択ボタンの背景色に色を設定
    private func setColorForSelectionButtons() {
        greenButton.backgroundColor = CustomSalesFloorColor.green.color
        systemTealButton.backgroundColor = CustomSalesFloorColor.systemTeal.color
        blueButton.backgroundColor = CustomSalesFloorColor.blue.color
        systemPurpleButton.backgroundColor = CustomSalesFloorColor.systemPurple.color
        systemPinkButton.backgroundColor = CustomSalesFloorColor.systemPink.color
        purpleButton.backgroundColor = CustomSalesFloorColor.purple.color
        brownButton.backgroundColor = CustomSalesFloorColor.brown.color
        redButton.backgroundColor = CustomSalesFloorColor.red.color
        systemRedButton.backgroundColor = CustomSalesFloorColor.yellow.color
        magentaButton.backgroundColor = CustomSalesFloorColor.magenta.color
        systemGrayButton.backgroundColor = CustomSalesFloorColor.systemGray.color
        systemGreenButton.backgroundColor = CustomSalesFloorColor.systemGreen.color
        systemIndigoButton.backgroundColor = CustomSalesFloorColor.systemIndigo.color
        cyanButton.backgroundColor = CustomSalesFloorColor.cyan.color
        systemBlueButton.backgroundColor = CustomSalesFloorColor.systemBlue.color
        systemYellowButton.backgroundColor = CustomSalesFloorColor.systemYellow.color
        orangeButton.backgroundColor = CustomSalesFloorColor.orange.color
    }

    /// 各カラー選択ボタンに背景色以外の項目を設定
    /// - テキストラベルに「選択」を表示
    /// - ボタンの基本装飾と影を設定
    private func updateButtonAppearance() {
        /// ボタンの配列を順番に設定
        let buttons = [greenButton, systemTealButton, blueButton, systemPurpleButton, systemPinkButton,
                       purpleButton, brownButton, redButton, systemRedButton, magentaButton,
                       systemGrayButton, systemGreenButton, systemIndigoButton, cyanButton, systemBlueButton,
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

    /// UIViewに見た目を設定
    /// - 枠線を１で設定
    /// - 枠線の色を黒に設定
    /// - 枠線を角丸10で設定
    /// - 境界の外側を非表示
    private func setViewAppearance() {
        selectedSalesFloorColorView.layer.borderWidth = 1
        selectedSalesFloorColorView.layer.borderColor = UIColor.black.cgColor
        selectedSalesFloorColorView.layer.cornerRadius = 10
        selectedSalesFloorColorView.clipsToBounds = true
    }

    /// キャンセルボタンと保存ボタンの見た目を設定
    /// - 両方のボタンに基本設定と影を設定
    /// - 両方のボタンの背景色を灰色に設定
    private func setCancelAndSaveButtonAppearance() {
        cancelButton.setAppearanceWithShadow(fontColor: .black)
        cancelButton.backgroundColor = .lightGray
        saveButton.setAppearanceWithShadow(fontColor: .black)
        saveButton.backgroundColor = .lightGray
    }

    /// 選択した色をUIViewに表示
    private func selectColor(type: CustomSalesFloorColor) {
        selectedSalesFloorColorView.backgroundColor = type.color
        selectedSalesFloorColorViewColor = type
    }

    /// アラートで確認するメソッド
    /// - 編集を中止て前の画面に戻るか
    /// - 中止をキャンセルして画面に止まるか
    private func showCancelAlert() {
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
    private func addOrReEnter() {
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
