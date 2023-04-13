//
//  EditSelectedSalesFloorViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/13.
//

import UIKit
/// 選択した売り場編集
class EditSelectedSalesFloorViewController: UIViewController {

    @IBOutlet weak var nameOfSalesFloorTextField: UITextField!

    @IBOutlet weak var selectedSalesFloorColorView: UIView!


    @IBOutlet weak var greenButton: UIButton!

    @IBAction func selectGreen(_ sender: Any) {
        selectColor(color: .green)
    }


    @IBOutlet weak var systemTealButton: UIButton!

    @IBAction func selectSystemTeal(_ sender: Any) {
        selectColor(color: .systemTeal)
    }


    @IBOutlet weak var blueButton: UIButton!
    @IBAction func selectBlue(_ sender: Any) {
        selectColor(color: .blue)
    }


    @IBOutlet weak var systemPurpleButton: UIButton!

    @IBAction func selectSystemPurple(_ sender: Any) {
        selectColor(color: .systemPurple)
    }

    @IBOutlet weak var systemPinkButton: UIButton!

    @IBAction func selectSystemPink(_ sender: Any) {
        selectColor(color: .systemPink)
    }


    @IBOutlet weak var purpleButton: UIButton!

    @IBAction func selectPurple(_ sender: Any) {
        selectColor(color: .purple)
    }

    @IBOutlet weak var brownButton: UIButton!

    @IBAction func selectBrown(_ sender: Any) {
        selectColor(color: .brown)
    }

    @IBOutlet weak var redButton: UIButton!

    @IBAction func selectRed(_ sender: Any) {
        selectColor(color: .red)
    }


    @IBOutlet weak var systemRedButton: UIButton!

    @IBAction func selectSystemRed(_ sender: Any) {
        selectColor(color: .systemRed)
    }


    @IBOutlet weak var magentaButton: UIButton!

    @IBAction func selectMagenta(_ sender: Any) {
        selectColor(color: .magenta)
    }


    @IBOutlet weak var systemGrayButton: UIButton!

    @IBAction func selectSystemGray(_ sender: Any) {
        selectColor(color: .systemGray)
    }


    @IBOutlet weak var systemGreenButton: UIButton!

    @IBAction func selectSystemGreen(_ sender: Any) {
        selectColor(color: .systemGreen)
    }


    @IBOutlet weak var systemIndigoButton: UIButton!

    @IBAction func selectSystemIndigo(_ sender: Any) {
        selectColor(color: .systemIndigo)
    }


    @IBOutlet weak var cyanButton: UIButton!

    @IBAction func selectCyan(_ sender: Any) {
        selectColor(color: .cyan)
    }


    @IBOutlet weak var systemBlueButton: UIButton!

    @IBAction func selectSystemBlue(_ sender: Any) {
        selectColor(color: .systemBlue)
    }


    @IBOutlet weak var systemYellowButton: UIButton!

    @IBAction func selectSystemYellow(_ sender: Any) {
        selectColor(color: .systemYellow)
    }


    @IBOutlet weak var orangeButton: UIButton!

    @IBAction func selectOrange(_ sender: Any) {
        selectColor(color: .orange)
    }


    @IBOutlet weak var cancelButton: UIButton!

    @IBAction func cancelAction(_ sender: Any) {
        showCancelAlert()
    }


    @IBOutlet weak var saveButton: UIButton!

    @IBAction func saveAction(_ sender: Any) {
        addOrReEnter()
    }

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfSalesFloorTextField.delegate = self
        setColorForSelectionButtons()
        updateButtonAppearance()
        viewAppearance()
        setCancelAndSaveButtonAppearance()
        setKeyboardCloseButton()
    }

    /// 売り場選択からもらった情報を表示
    

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

    private func viewAppearance() {
        selectedSalesFloorColorView.layer.borderWidth = 1
        selectedSalesFloorColorView.layer.borderColor = UIColor.black.cgColor
        selectedSalesFloorColorView.layer.cornerRadius = 10
        selectedSalesFloorColorView.clipsToBounds = true
    }

    private func setCancelAndSaveButtonAppearance() {
        cancelButton.setAppearanceWithShadow()
        cancelButton.backgroundColor = .lightGray
        saveButton.setAppearanceWithShadow()
        saveButton.backgroundColor = .lightGray
    }

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
