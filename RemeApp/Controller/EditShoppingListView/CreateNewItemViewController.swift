//
//  CreateNewItemViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/05.
//

import UIKit

/// G-品目新規作成
class CreateNewItemViewController: UIViewController {


    @IBOutlet weak var nameOfItemTextField: UITextField!

    @IBOutlet weak var numberOfItemPickerView: UIPickerView!


    @IBOutlet weak var unitPickerView: UIPickerView!


    @IBOutlet weak var selectTypeOfSalesFloorButton: UIButton!

    @IBAction func goSelectTypeOfSalesFloorView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SelectTypeOfSalesFloorView", bundle: nil)
        let selectTypeOfSalesFloorVC = storyboard.instantiateViewController(
            withIdentifier: "SelectTypeOfSalesFloorView") as! SelectTypeOfSalesFloorViewController
        selectTypeOfSalesFloorVC.delegate = self
        self.present(selectTypeOfSalesFloorVC, animated: true)
    }

    @IBOutlet weak var supplementTextField: UITextField!


    @IBOutlet weak var selectPhotoButton: UIButton!


    @IBOutlet weak var photoImageView: UIImageView!


    @IBOutlet weak var cancelButton: UIButton!

    @IBAction func cancelAndReturn(_ sender: Any) {
        dismiss(animated: true)
    }


    @IBOutlet weak var addButton: UIButton!
    @IBAction func addAndReturn(_ sender: Any) {
        dismiss(animated: true)
    }

    /// numberOfItemPickerViewに表示する値
    /// - １〜２０で設定
    let numberOfItemArray: Array<String> = ["１","２","３","４","５","６","７","８","９","１０",
                                            "１１","１２","１３","１４","１５","１６","１７","１８","１９","２０"]

    /// unitPickerViewに表示する値
    /// -　個、本、袋、グラム、パックで設定
    let unitArray: Array<String> = ["個", "本", "袋", "グラム", "パック"]

    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfItemPickerView.delegate = self
        numberOfItemPickerView.dataSource = self
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        nameOfItemTextField.delegate = self
        supplementTextField.delegate = self
        setCloseButton(textField: nameOfItemTextField)
        setCloseButton(textField: supplementTextField)
        setAppearanceAllButton()
        initialAddButton()
    }

    /// 追加ボタンの初期状態
    /// - ボタンの非活性化
    /// - バックグラウンドカラーを白に設定
    private func initialAddButton() {
        addButton.isEnabled = false
        addButton.backgroundColor = .white
    }

    /// 条件によってボタンを有効にする
    private func activationAddButton() {
    }

    /// 画面上の全てのButtonの見た目の設定メソッド
    private func setAppearanceAllButton() {
        setAppearanceButton(button: selectTypeOfSalesFloorButton)
        setAppearanceButton(button: selectPhotoButton)
        setAppearanceButton(button: cancelButton)
        setAppearanceButton(button: addButton)

    }

    /// UIButtonの見た目を変更する
    /// - 文字の色
    /// - 角丸
    /// - 文字の縮小
    /// - 縮小率
    /// - １行で表示を設定
    /// - 枠線の幅
    /// - 枠線の色
    private func setAppearanceButton(button: UIButton) {
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10.0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5 // 縮小率を指定する
        button.titleLabel?.numberOfLines = 1
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }

    /// キーボードの完了ボタン配置、完了ボタン押してキーボードを非表示に変更するメソッド
    private func setCloseButton(textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexSpace, doneButton]
        textField.inputAccessoryView = toolbar
    }
    /// 閉じるボタンを押した時にキーボードを閉じるメソッド
    @objc func doneButtonTapped() {
        nameOfItemTextField.resignFirstResponder()
        supplementTextField.resignFirstResponder()
    }
}

extension CreateNewItemViewController: UIPickerViewDelegate {
    /// pickerViewに表示する内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
    -> String? {
        switch pickerView {
            case numberOfItemPickerView:
                return numberOfItemArray[row]
            case unitPickerView:
                return unitArray[row]
            default:
                return nil
        }
    }
}

extension CreateNewItemViewController: UIPickerViewDataSource {
    /// pickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    /// pickerViewの行数（要素の数）
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
            case numberOfItemPickerView:
                return numberOfItemArray.count
            case unitPickerView:
                return unitArray.count
            default:
                return 0
        }
    }
}

extension CreateNewItemViewController: UITextFieldDelegate {
    /// textFieldの文字数制限
    /// - 商品名：１５文字以内
    /// - 補足：２０文字以内
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        switch textField {
            case nameOfItemTextField:
                return newLength <= 15
            case supplementTextField:
                return newLength <= 20
            default:
                return true
        }
    }
}

extension CreateNewItemViewController:SelectTypeOfSalesFloorViewControllerDelegate {
    /// SelectTypeOfSalesFloorViewで各Buttonをタップした際のメソッド
    /// - selectTypeOfSalesFloorButtonのタイトルを該当する売り場の名称に変更
    /// - selectTypeOfSalesFloorButtonのバックグラウンドカラーを該当する売り場の色に変更
    func salesFloorButtonDidTapDone(type: SalesFloorType) {
        selectTypeOfSalesFloorButton?.setTitle(type.nameOfSalesFloor, for: .normal)
        selectTypeOfSalesFloorButton?.backgroundColor = type.colorOfSalesFloor
    }
}
