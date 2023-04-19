//
//  EditSelectedSalesFloorViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/13.
//

import UIKit
/// 選択した売り場編集
class EditSelectedSalesFloorViewController: UIViewController {

    // MARK: - @IBOutlet & @IBAction
    /// 売り場の名称を入力するテキストフィールド
    @IBOutlet weak var nameOfSalesFloorTextField: UITextField!

    /// 選択された売り場の色を表示するview
    @IBOutlet weak var selectedSalesFloorColorView: UIView!

    /// 売り場のカラーをgreenで選択するbutton
    @IBOutlet weak var greenButton: UIButton!
    /// 売り場のカラーをgreenで選択する
    @IBAction func selectGreen(_ sender: Any) {
        selectColor(color: .green)
    }

    /// 売り場のカラーをsystemTealで選択するbutton
    @IBOutlet weak var systemTealButton: UIButton!
    /// 売り場のカラーをsystemTealで選択する
    @IBAction func selectSystemTeal(_ sender: Any) {
        selectColor(color: .systemTeal)
    }

    /// 売り場のカラーをblueで選択するbutton
    @IBOutlet weak var blueButton: UIButton!
    /// 売り場のカラーをblueで選択する
    @IBAction func selectBlue(_ sender: Any) {
        selectColor(color: .blue)
    }

    /// 売り場のカラーをsystemPurpleで選択するbutton
    @IBOutlet weak var systemPurpleButton: UIButton!
    /// 売り場のカラーをsystemPurpleで選択する
    @IBAction func selectSystemPurple(_ sender: Any) {
        selectColor(color: .systemPurple)
    }

    /// 売り場のカラーをsystemPinkで選択するbutton
    @IBOutlet weak var systemPinkButton: UIButton!
    /// 売り場のカラーをsystemPinkで選択する
    @IBAction func selectSystemPink(_ sender: Any) {
        selectColor(color: .systemPink)
    }

    /// 売り場のカラーをpurpleで選択するbutton
    @IBOutlet weak var purpleButton: UIButton!
    /// 売り場のカラーをpurpleで選択する
    @IBAction func selectPurple(_ sender: Any) {
        selectColor(color: .purple)
    }

    /// 売り場のカラーをbrownで選択するbutton
    @IBOutlet weak var brownButton: UIButton!
    /// 売り場のカラーをbrownで選択する
    @IBAction func selectBrown(_ sender: Any) {
        selectColor(color: .brown)
    }

    /// 売り場のカラーをredで選択するbutton
    @IBOutlet weak var redButton: UIButton!
    /// 売り場のカラーをredで選択する
    @IBAction func selectRed(_ sender: Any) {
        selectColor(color: .red)
    }

    /// 売り場のカラーをsystemRedで選択するbutton
    @IBOutlet weak var systemRedButton: UIButton!
    /// 売り場のカラーをsystemRedで選択する
    @IBAction func selectSystemRed(_ sender: Any) {
        selectColor(color: .systemRed)
    }

    /// 売り場のカラーをmagentaで選択するbutton
    @IBOutlet weak var magentaButton: UIButton!
    /// 売り場のカラーをmagentaで選択する
    @IBAction func selectMagenta(_ sender: Any) {
        selectColor(color: .magenta)
    }

    /// 売り場のカラーをsystemGrayで選択するbutton
    @IBOutlet weak var systemGrayButton: UIButton!
    /// 売り場のカラーをsystemGrayで選択する
    @IBAction func selectSystemGray(_ sender: Any) {
        selectColor(color: .systemGray)
    }

    /// 売り場のカラーをsystemGreenで選択するbutton
    @IBOutlet weak var systemGreenButton: UIButton!
    /// 売り場のカラーをsystemGreenで選択する
    @IBAction func selectSystemGreen(_ sender: Any) {
        selectColor(color: .systemGreen)
    }

    /// 売り場のカラーをsystemIndigoで選択するbutton
    @IBOutlet weak var systemIndigoButton: UIButton!
    /// 売り場のカラーをsystemIndigoで選択する
    @IBAction func selectSystemIndigo(_ sender: Any) {
        selectColor(color: .systemIndigo)
    }

    /// 売り場のカラーをcyanで選択するbutton
    @IBOutlet weak var cyanButton: UIButton!
    /// 売り場のカラーをcyanで選択する
    @IBAction func selectCyan(_ sender: Any) {
        selectColor(color: .cyan)
    }

    /// 売り場のカラーをsystemBlueで選択するbutton
    @IBOutlet weak var systemBlueButton: UIButton!
    /// 売り場のカラーをsystemBlueで選択する
    @IBAction func selectSystemBlue(_ sender: Any) {
        selectColor(color: .systemBlue)
    }

    /// 売り場のカラーをsystemYellowで選択するbutton
    @IBOutlet weak var systemYellowButton: UIButton!
    /// 売り場のカラーをsystemYellowで選択する
    @IBAction func selectSystemYellow(_ sender: Any) {
        selectColor(color: .systemYellow)
    }

    /// 売り場のカラーをorangeで選択するbutton
    @IBOutlet weak var orangeButton: UIButton!
    /// 売り場のカラーをorangeで選択する
    @IBAction func selectOrange(_ sender: Any) {
        selectColor(color: .orange)
    }

    /// キャンセルボタン
    @IBOutlet weak var cancelButton: UIButton!
    /// 編集をキャンセルして戻る
    @IBAction func cancelAction(_ sender: Any) {
        showCancelAlert()
    }

    /// 保存ボタン
    @IBOutlet weak var saveButton: UIButton!
    /// 保存して前の画面に戻る
    @IBAction func saveAction(_ sender: Any) {
        addOrReEnter()
    }

    // MARK: - property

    /// 売り場に対応するRawValue
    var customSalesFloorRawValue:Int = 0
    
    /// nameOfItemLabelに表示するテキスト
    private var nameOfSalesFloorTextFieldText:String = ""

    /// nameOfItemLabelに表示するテキスト
    private var selectedSalesFloorColorViewColor:UIColor = .white

    /// カスタム売り場マップのリスト
    private var customSalesFloorList: [CustomSalesFloorModel] = [CustomSalesFloorModel(customSalesFloorRawValue: 0, customNameOfSalesFloor: "コメ", customColorOfSalesFloor: .cyan),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 1, customNameOfSalesFloor: "味噌", customColorOfSalesFloor: .blue),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 2, customNameOfSalesFloor: "野菜", customColorOfSalesFloor: .magenta),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 3, customNameOfSalesFloor: "人参", customColorOfSalesFloor: .orange),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 4, customNameOfSalesFloor: "椎茸", customColorOfSalesFloor: .systemBlue),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 5, customNameOfSalesFloor: "しめじ", customColorOfSalesFloor: .systemFill),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 6, customNameOfSalesFloor: "のり", customColorOfSalesFloor: .systemPink),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 7, customNameOfSalesFloor: "砂糖", customColorOfSalesFloor: .systemTeal),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 8, customNameOfSalesFloor: "塩", customColorOfSalesFloor: .systemGray3),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 9, customNameOfSalesFloor: "坦々麺", customColorOfSalesFloor: .systemMint),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 10, customNameOfSalesFloor: "プリン", customColorOfSalesFloor: .systemIndigo),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 11, customNameOfSalesFloor: "冷凍おにぎり", customColorOfSalesFloor: .systemBrown),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 12, customNameOfSalesFloor: "八つ切りパン", customColorOfSalesFloor: .red),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 13, customNameOfSalesFloor: "ピザ", customColorOfSalesFloor: .yellow),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 14, customNameOfSalesFloor: "ビール", customColorOfSalesFloor: .green),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 15, customNameOfSalesFloor: "ポカリ", customColorOfSalesFloor: .magenta),
                                                                 CustomSalesFloorModel(customSalesFloorRawValue: 16, customNameOfSalesFloor: "午後ティー", customColorOfSalesFloor: .brown)
    ]


    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfSalesFloorTextField.delegate = self
        setColorForSelectionButtons()
        updateButtonAppearance()
        setViewAppearance()
        setCancelAndSaveButtonAppearance()
        setKeyboardCloseButton()
        displayData()
    }

    // MARK: - func

    /// 各カラー選択ボタンの背景色に色を設定
    private func setColorForSelectionButtons() {
        greenButton.backgroundColor = .green
        systemTealButton.backgroundColor = .systemTeal
        blueButton.backgroundColor = .blue
        systemPurpleButton.backgroundColor = .systemPurple
        systemPinkButton.backgroundColor = .systemPink
        purpleButton.backgroundColor = .purple
        brownButton.backgroundColor = .brown
        redButton.backgroundColor = .red
        systemRedButton.backgroundColor = .systemRed
        magentaButton.backgroundColor = .magenta
        systemGrayButton.backgroundColor = .systemGray
        systemGreenButton.backgroundColor = .systemGreen
        systemIndigoButton.backgroundColor = .systemIndigo
        cyanButton.backgroundColor = .cyan
        systemBlueButton.backgroundColor = .systemBlue
        systemYellowButton.backgroundColor = .systemYellow
        orangeButton.backgroundColor = .orange
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
            button?.setAppearanceWithShadow()
        }
    }

    /// 売り場選択からもらった情報を表示
    /// 受け渡されたデータをそれぞれのUI部品に表示
    /// - 商品名の表示
    /// - 必要数を表示
    /// - 必要数の単位を表示
    /// - 売り場を表示
    /// - 補足を表示
    /// - 写真を表示
    private func displayData() {

        nameOfSalesFloorTextField.text = nameOfSalesFloorTextFieldText
        selectedSalesFloorColorView.backgroundColor = selectedSalesFloorColorViewColor
    }

    /// データ受け渡し用のメソッド
    func configurer(detail: CustomSalesFloorModel) {
        customSalesFloorRawValue = detail.customSalesFloorRawValue
        nameOfSalesFloorTextFieldText = detail.customNameOfSalesFloor
        selectedSalesFloorColorViewColor = detail.customColorOfSalesFloor
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
        cancelButton.setAppearanceWithShadow()
        cancelButton.backgroundColor = .lightGray
        saveButton.setAppearanceWithShadow()
        saveButton.backgroundColor = .lightGray
    }

    /// 選択した色をUIViewに表示
    private func selectColor(color: UIColor) {
        selectedSalesFloorColorView.backgroundColor = color
    }

    /// アラートで確認するメソッド
    /// - 編集を中止て前の画面に戻るか
    /// - 中止をキャンセルして画面に止まるか
    func showCancelAlert() {
        let alertController = UIAlertController(title: "編集を中止", message:
                                                    "編集内容を破棄してもよろしいですか？", preferredStyle: .alert)
        // はいでEditSalesFloorMapViewに戻る
        let okAction = UIAlertAction(title: "はい", style: .default, handler:  { (action) in
            self.navigationController?.popViewController(animated: true)
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
    func addOrReEnter() {
        if nameOfSalesFloorTextField.text == "" {
            // 警告アラート
            let alertController = UIAlertController(title: nil, message:
                                                        "売り場の名称は必ず入力してください", preferredStyle: .alert)
            // 何もしない
            let reEnterAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(reEnterAction)
            present(alertController, animated: true)
        } else {
            // ここに追加の処理

            self.navigationController?.popViewController(animated: true)
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
    /// textFieldの文字数制限を１０文字以内に設定
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }
}
