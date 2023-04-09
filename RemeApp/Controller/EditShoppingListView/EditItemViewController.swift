//
//  EditItemViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/09.
//

import UIKit
/// I-品目編集
class EditItemViewController: UIViewController {
    /// 商品名入力
    @IBOutlet private weak var nameOfItemTextField: UITextField!
    /// 個数入力
    @IBOutlet private weak var numberOfItemPickerView: UIPickerView!
    /// 単位入力
    @IBOutlet private weak var unitPickerView: UIPickerView!
    /// 売り場選択
    @IBOutlet private weak var selectTypeOfSalesFloorButton: UIButton!
    /// 売り場選択画面に遷移するメソッド
    ///  -　遷移処理
    ///  - 遷移後に自身のボタンの見た目を変更するためにデリゲートをセット
    @IBAction private func goSelectTypeOfSalesFloorView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SelectTypeOfSalesFloorView", bundle: nil)
        let selectTypeOfSalesFloorVC = storyboard.instantiateViewController(
            withIdentifier: "SelectTypeOfSalesFloorView") as! SelectTypeOfSalesFloorViewController
        selectTypeOfSalesFloorVC.delegate = self
        self.present(selectTypeOfSalesFloorVC, animated: true)
    }
    /// 補足入力
    @IBOutlet private weak var supplementTextView: UITextView!
    /// 写真選択ボタン
    @IBOutlet private weak var selectPhotoButton: UIButton!
    /// 写真を追加するアクションを実行
    @IBAction private func addPhoto(_ sender: Any) {
        // カメラまたはフォトライブラリー、キャンセルを選択するメソッド
        setCameraAndPhotoAction()
    }
    /// 写真削除ボタン
    @IBOutlet private weak var deletePhotoButton: UIButton!
    /// 添付した写真データを削除する
    @IBAction private func deletePhoto(_ sender: Any) {
        // 添付した写真を削除するメソッド
        setDeletePhotoAction()
    }
    /// 選択した写真を添付する
    @IBOutlet private weak var photoImageView: UIImageView!
    /// キャンセルボタン
    @IBOutlet private weak var cancelButton: UIButton!
    /// 編集を終了してEditShoppingListViewに戻る遷移
    @IBAction private func cancelAndReturn(_ sender: Any) {
        let alertController = UIAlertController(title: "作成を中止", message:
                                                    "編集内容を破棄してもよろしいですか？", preferredStyle: .alert)
        // はいでEditShoppingListViewに戻る
        let okAction = UIAlertAction(title: "はい", style: .default, handler:  { (action) in
            self.dismiss(animated: true)
        })
        // キャンセル、何もしない
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    /// 追加ボタン
    @IBOutlet private weak var addButton: UIButton!
    /// 編集内容を保存、追加して、EditShoppingListViewに戻る遷移
    @IBAction private func addAndReturn(_ sender: Any) {
        dismiss(animated: true)
    }
    /// numberOfItemPickerViewに表示する値
    /// - １〜２０で設定
    private let numberOfItemArray: Array<String> = ["１","２","３","４","５","６","７","８","９","１０",
                                                    "１１","１２","１３","１４","１５","１６","１７","１８","１９","２０"]
    /// unitPickerViewに表示する値
    /// -　個、本、袋、グラム、パックで設定
    private let unitArray: Array<String> = ["個", "本", "袋", "グラム", "パック"]
    /// 写真のURLパス
    private var imageFilePath: URL?

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "品目編集"
        numberOfItemPickerView.delegate = self
        numberOfItemPickerView.dataSource = self
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        nameOfItemTextField.delegate = self
        setCloseButton()
        setAppearanceAllButton()
        setDisableThreeButton()
        setAppearance(textView: supplementTextView)
        setPlaceholder(textView: supplementTextView)
    }
    /// 売り場ボタン、追加ボタン、写真の削除ボタンを非活性化
    private func setDisableThreeButton() {
        setDisable(button: selectTypeOfSalesFloorButton)
        setDisable(button: addButton)
        setDisable(button: deletePhotoButton)
    }
    /// ボタンの初期状態
    /// - ボタンの非活性化
    /// - バックグラウンドカラーを白に設定
    private func setDisable(button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = .white
    }
    /// 条件によってボタンを有効にする
    /// - nameOfItemTextFieldに入力さている
    /// - selectTypeOfSalesFloorButtonに売り場が選択されている
    private func setEnable(button: UIButton) {
        button.backgroundColor = .lightGray
        button.isEnabled = true
    }
    /// 画面上の全てのButtonの見た目の設定メソッド
    private func setAppearanceAllButton() {
        setAppearance(button: selectTypeOfSalesFloorButton)
        setAppearance(button: selectPhotoButton)
        setAppearance(button: cancelButton)
        setAppearance(button: addButton)
        setAppearance(button: deletePhotoButton)
    }
    /// UIButtonの見た目を変更する
    /// - 文字の色
    /// - 角丸
    /// - 文字の縮小
    /// - 縮小率
    /// - １行で表示を設定
    /// - 枠線の幅
    /// - 枠線の色
    /// - ボタンに影をつける
    private func setAppearance(button: UIButton) {
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10.0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5 // 縮小率を指定する
        button.titleLabel?.numberOfLines = 1
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        addShadow(to: button)
    }
    /// UIButtonに影をつけるメソッド
    private func addShadow(to button: UIButton) {
        // 影の色
        button.layer.shadowColor = UIColor.black.cgColor
        // 影の透明度
        button.layer.shadowOpacity = 0.5
        // 影のオフセット、影の位置
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        // 影の半径
        button.layer.shadowRadius = 2
    }
    /// キーボードの完了ボタン配置、完了ボタン押してキーボードを非表示に変更するメソッド
    private func setCloseButton() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [doneButton]
        nameOfItemTextField.inputAccessoryView = toolbar
        supplementTextView.inputAccessoryView = toolbar
    }
    /// 閉じるボタンを押した時にキーボードを閉じるメソッド
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    /// TextViewにプレースホルダーを設置するメソッド
    private func setPlaceholder(textView: UITextView) {
        textView.text = "任意：３０文字以内で入力して下さい"
        textView.textColor = UIColor.lightGray
        textView.delegate = self
    }
    /// TextViewに枠線を設置
    private func setAppearance(textView: UITextView) {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10.0
    }
}

extension EditItemViewController: UIPickerViewDelegate {
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

extension EditItemViewController: UIPickerViewDataSource {
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

extension EditItemViewController: UITextFieldDelegate {
    /// textFieldの文字数制限を１５文字以内に設定
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 15
    }
    /// 商品名が入力された時に売り場選択ボタンを活性化するメソッド
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if nameOfItemTextField.text == "" { return }
        else {
            selectTypeOfSalesFloorButton.isEnabled = true
        }
    }
}

extension EditItemViewController:SelectTypeOfSalesFloorViewControllerDelegate {
    /// SelectTypeOfSalesFloorViewで各Buttonをタップした際のメソッド
    /// - selectTypeOfSalesFloorButtonのタイトルを該当する売り場の名称に変更
    /// - selectTypeOfSalesFloorButtonのバックグラウンドカラーを該当する売り場の色に変更
    func salesFloorButtonDidTapDone(type: SalesFloorType) {
        selectTypeOfSalesFloorButton?.setTitle(type.nameOfSalesFloor, for: .normal)
        selectTypeOfSalesFloorButton?.backgroundColor = type.colorOfSalesFloor
        setEnable(button: addButton)
    }
}

extension EditItemViewController: UITextViewDelegate {
    /// 入力があったらプレースホルダー削除、フォントカラーをブラックにする
    func textViewDidBeginEditing(_ textView: UITextView) {
        if supplementTextView.text == "任意：３０文字以内で入力して下さい" {
            supplementTextView.text = ""
            supplementTextView.textColor = .black
        }
    }
    /// 何も入力されていなかったらプレースホルダーをセット、フォントカラーライトグレー
    func textViewDidEndEditing(_ textView: UITextView) {
        if supplementTextView.text == "" {
            supplementTextView.text = "任意：３０文字以内で入力して下さい"
            supplementTextView.textColor = .lightGray
        }
    }
    /// 入力制限を３０文字以内で設定
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 30
        let currentString: NSString = supplementTextView.text as NSString
        let updatedString = currentString.replacingCharacters(in: range, with: text)
        return updatedString.count <= maxLength
    }
}
// !!!: いずれPHPickerに変更しないといけないかも
// 写真添付と削除の処理関連
extension EditItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// 撮影または写真選択が終了した際のメソッド
    /// - 撮影または選択した画像をUIImageViewに表示させる
    /// - 写真の取り消しボタンを有効化する
    /// - 画面を閉じてCreateNewItemViewに戻る
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        setEnable(button: deletePhotoButton)
        dismiss(animated: true)
    }
    /// カメラ撮影とフォトライブラリーでの写真選択を実行する処理
    /// - アクションシートで選択
    /// - カメラ撮影アクション
    /// - フォトライブリーラリーから選択アクション
    /// - キャンセルアクション
    private func setCameraAndPhotoAction() {
        /// アラートコントローラーをインスタンス化
        let alertController = UIAlertController(title: "選択して下さい", message: nil, preferredStyle: .actionSheet)
        // カメラ撮影アクション定義
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: { (action) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        // フォトラーブラリーから選択アクションを定義
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default,handler: { (action) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true)
            })
            alertController.addAction(photoLibraryAction)
        }
        // キャンセルアクションを定義
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        // iPadでの処理落ち防止処置
        alertController.popoverPresentationController?.sourceView = view
        present(alertController, animated: true)
    }
    /// 添付した写真を削除するメソッド
    /// - アラートで確認
    /// - 削除する -> 写真の削除とdeletePhotoButtonの非活性化
    /// - キャンセル -> 何もせずに戻る
    private func setDeletePhotoAction() {
        let alertController = UIAlertController(title: "写真の削除", message: "削除してもよろしいですか？",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "削除する", style: .default) { (action) in
            // OKが押された時の処理
            self.photoImageView.image = nil
            self.setDisable(button: self.deletePhotoButton)
            if let filePath = self.imageFilePath {
                do {
                    try FileManager.default.removeItem(at: filePath)
                } catch {
                    print("Error deleting image: \\(error.localizedDescription)")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
