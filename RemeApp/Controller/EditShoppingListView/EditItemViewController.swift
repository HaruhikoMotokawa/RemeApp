//
//  CreateNewItemViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/05.
//

import UIKit
import RealmSwift
/// G-品目新規作成
class EditItemViewController: UIViewController {

    // MARK: - property

    /// タイトル
    @IBOutlet weak var titleLabel: UILabel!
    /// 商品名入力
    @IBOutlet private weak var nameOfItemTextField: UITextField!
    /// 個数入力
    @IBOutlet private weak var numberOfItemPickerView: UIPickerView!
    /// 単位入力
    @IBOutlet private weak var unitPickerView: UIPickerView!
    /// 売り場選択
    @IBOutlet private weak var selectTypeOfSalesFloorButton: UIButton!
    /// 補足文のプレースホルダー
    @IBOutlet weak var placeholderLabel: UILabel!
    /// 補足入力
    @IBOutlet private weak var supplementTextView: UITextView!
    /// 写真選択ボタン
    @IBOutlet private weak var selectPhotoButton: UIButton!
    /// 写真削除ボタン
    @IBOutlet private weak var deletePhotoButton: UIButton!
    /// 写真の背景
    @IBOutlet private weak var photoBackgroundImage: UIImageView!
    /// 選択した写真を添付する
    @IBOutlet private weak var photoPathImageView: UIImageView!
    /// キャンセルボタン
    @IBOutlet private weak var cancelButton: UIButton!
    /// 追加ボタン
    @IBOutlet private weak var addButton: UIButton!

    /// numberOfItemPickerViewに表示する値を「１〜２０」で設定
    private let numberOfItemArray: Array<String> = ["１","２","３","４","５","６","７","８","９","１０",
                                                    "１１","１２","１３","１４","１５","１６","１７","１８","１９","２０"]
    /// unitPickerViewに表示する値を「個、本、袋、グラム、パック」で設定
    private let unitArray: Array<String> = ["個", "本", "袋", "パック"]
    /// 写真のURLパス
    private var imageFilePath: URL?
    /// カスタム売り場マップのリスト
    private var customSalesFloorData = CustomSalesFloorModel()
    /// お使いデータ
    var errandData = ErrandDataModel()
    /// nameOfItemTextFieldに表示するテキスト
    private var nameOfItemTextFieldText:String? = nil
    /// numberOfItemPickerViewに表示する文字列
    private var numberOfItemPickerViewString:String = "１"
    /// unitPickerViewに表示する文字列
    private var unitPickerViewString:String = "個"
    ///  売り場を保存するための一時置き場
    private var selectedSalesFloorRawValue:Int? = nil
    /// supplementTextViewに表示するテキスト
    private var supplementTextViewText:String? = nil
    /// photoImageViewに表示する画像
    private var photoPathImage:UIImage? = nil

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSourceAndDelegate()
        setKeyboardCloseButton()
        setAppearanceAllButton()
        displayData()
        setTitleLabel()
        setDisableOrEnable()
        supplementTextView.setAppearance()
    }

    // MARK: - func

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

    /// カメラ撮影とフォトライブラリーでの写真選択を実行する処理
    /// - アクションシートで選択
    /// - カメラ撮影アクション
    /// - フォトライブリーラリーから選択アクション
    /// - キャンセルアクション
    @IBAction private func addPhoto(_ sender: Any) {
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

    /// 添付した写真データを削除する
    @IBAction private func deletePhoto(_ sender: Any) {
        // 添付した写真を削除するメソッド
        setDeletePhotoAction()
    }

    /// 編集を終了してEditShoppingListViewに戻る遷移
    @IBAction private func cancelAndReturn(_ sender: Any) {
        showCancelAlert()
    }

    /// 編集内容を保存、追加して、EditShoppingListViewに戻る遷移
    @IBAction private func addAndReturn(_ sender: Any) {
        Task { @MainActor in
            await addOrReEnter()
        }
    }

    /// データソースとデリゲートをセット
    private func setDataSourceAndDelegate() {
        numberOfItemPickerView.delegate = self
        numberOfItemPickerView.dataSource = self
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        nameOfItemTextField.delegate = self
        supplementTextView.delegate = self
    }

    /// 画面上の全てのButtonの見た目の設定メソッド
    private func setAppearanceAllButton() {
        selectTypeOfSalesFloorButton.setAppearanceWithShadow(fontColor: .black)
        selectPhotoButton.setAppearanceWithShadow(fontColor: .black)
        cancelButton.setAppearanceWithShadow(fontColor: .black)
        addButton.setAppearanceWithShadow(fontColor: .black)
        deletePhotoButton.setAppearanceWithShadow(fontColor: .black)
    }

    /// 遷移時にヘッダータイトルを変更するメソッド
    /// - nameOfItemTextField.textの有無で変更
    private func setTitleLabel() {
        if nameOfItemTextField.text == "" {
            titleLabel.text = "新規作成"
        } else {
            titleLabel.text = "編集"
        }
    }

    /// 画面遷移してきた際にデータの有無によってボタンの活性化を切り替えるメソッド
    /// - 商品名のデータがある場合はaddButtonを活性化
    /// - 写真データがある場合はdeletePhotoButtonを活性化、photoBackgroundImageを非表示
    private func setDisableOrEnable() {
        // 追加ボタンの切り替え
        if nameOfItemTextField.text == "" {
            selectTypeOfSalesFloorButton.setDisable()
            addButton.setDisable()
        } else {
            addButton.setEnable()
        }
        // 添付写真削除ボタンの切り替えと背景写真イメージの切り替え
        if photoPathImageView.image == nil {
            deletePhotoButton.setDisable()
            photoBackgroundImage.isHidden = false
        } else {
            deletePhotoButton.setEnable()
            photoBackgroundImage.isHidden = true
        }
    }

    /// データ受け渡し用のメソッド
    func configurer(detail: ErrandDataModel) {
        errandData = detail
        nameOfItemTextFieldText = detail.nameOfItem
        numberOfItemPickerViewString = detail.numberOfItem
        unitPickerViewString = detail.unit
        selectedSalesFloorRawValue = detail.salesFloorRawValue
        supplementTextViewText = detail.supplement
        photoPathImage = detail.getImage()
    }

    /// 受け渡されたデータをそれぞれのUI部品に表示
    private func displayData() {
        nameOfItemTextField.text = nameOfItemTextFieldText
        selectNumberOfItemRow(selectedNumberOfItem: numberOfItemPickerViewString)
        selectUnitRow(selectedUnit: unitPickerViewString)
        setSalesFloorTypeButton(salesFloorRawValue: selectedSalesFloorRawValue)
        setSupplementLabelText(supplement: supplementTextViewText)
        setPhotoPathImageView(image: photoPathImage)
    }

    /// numberOfItemPickerViewに表示できるように変換する
    private func selectNumberOfItemRow(selectedNumberOfItem: String) {
        let numberOfItemIndex = numberOfItemArray.firstIndex(of: selectedNumberOfItem) ?? 0
        numberOfItemPickerView.selectRow(numberOfItemIndex, inComponent: 0, animated: true)
    }

    /// unitPickerViewに表示できるように変換する
    private func selectUnitRow(selectedUnit: String) {
        let selectedUnitIndex = unitArray.firstIndex(of: selectedUnit) ?? 0
        unitPickerView.selectRow(selectedUnitIndex, inComponent: 0, animated: true)
    }

    /// salesFloorTypeButtonに売り場の内容を反映させる
    /// - 売り場の名称を設定
    /// - 売り場の色を設定
    private func setSalesFloorTypeButton(salesFloorRawValue: Int?) {
        guard let salesFloorRawValue else { return }
        let useSalesFloorTypeKey = "useSalesFloorTypeKey"
        let salesFloorTypeInt = UserDefaults.standard.integer(forKey: useSalesFloorTypeKey)
        // 0 -> カスタム、1(else) -> デフォルト
        if salesFloorTypeInt == 0 {
            // カスタムマップタイプの処理
            setCustomSalesFloorButton(salesFloorRawValue: salesFloorRawValue)
        } else {
            // デフォルトマップタイプの処理
            setDefaultSalesFloorButton(salesFloorRawValue: salesFloorRawValue)
        }
    }

    /// 引数で指定されたrawValueに対応するカスタム売り場を反映させる
    /// - Parameter salesFloorRawValue: 反映させたいカスタム売り場のrawValue
    private func setCustomSalesFloorButton(salesFloorRawValue: Int) {
        // 指定されたrawValueにマッチするCustomSalesFloorModelを取得する
        let customSalesFloorModelList = getCustomSalesFloorModelList(for: salesFloorRawValue)
        let customSalesFloorModel = customSalesFloorModelList.first
        // ボタンのタイトルと背景色を設定する
        selectTypeOfSalesFloorButton.setTitle(customSalesFloorModel?.customNameOfSalesFloor, for: .normal)
        selectTypeOfSalesFloorButton.backgroundColor = customSalesFloorModel?.customSalesFloorColor.color
    }

    /// 引数で指定された値に対応するCustomSalesFloorModelのリストを返す関数
    /// - Parameter salesFloorRawValue: 検索したいCustomSalesFloorModelのrawValue
    /// - Returns: 検索にマッチしたCustomSalesFloorModelのリスト
    private func getCustomSalesFloorModelList(for salesFloorRawValue: Int) -> [CustomSalesFloorModel] {
        let realm = try! Realm()
        // カスタム売り場モデルのオブジェクトからフィルターメソッドを使って条件に合うモデルを抽出
        let results = realm.objects(CustomSalesFloorModel.self)
            .filter("customSalesFloorRawValue == %@", salesFloorRawValue)
        // 抽出した結果を戻り値に返却
        return Array(results)
    }

    /// 引数で指定されたrawValueに対応するデフォルト売り場を反映させる
    /// - Parameter salesFloorRawValue: 反映させたい売り場のrawValue
    private func setDefaultSalesFloorButton(salesFloorRawValue: Int) {
        // 引数で指定されたrawValueに対応するDefaultSalesFloorTypeを取得する
        let salesFloor = DefaultSalesFloorType(rawValue: salesFloorRawValue)
        // ボタンのタイトルと背景色を設定する
        selectTypeOfSalesFloorButton.setTitle(salesFloor?.nameOfSalesFloor, for: .normal)
        selectTypeOfSalesFloorButton.backgroundColor = salesFloor?.colorOfSalesFloor
    }

    /// 受け渡されたデータをsetSupplementLabelTextに表示
    /// - 補足がなければ「""」を表示 == textViewDidBeginEditingによってプレースホルダーがセットされる
    /// - 補足がある場合はフォントを黒にしてそのまま表示
    private func setSupplementLabelText(supplement: String? ) {
        if supplementTextViewText == nil {
            placeholderLabel.isHidden = false
        } else {
            supplementTextView.text = supplementTextViewText
            supplementTextView.textColor = .black
            placeholderLabel.isHidden = true
        }
    }

    /// 受け取った写真データを変換して表示するためのメソッド
    ///  - イメージがnilだったらそのままからを表示
    ///  - イメージがある場合はサイズを調整し、角丸にして表示する
    private func setPhotoPathImageView(image: UIImage?) {
        if image == nil {
            photoPathImageView.image = image
        } else {
            let resizedImage = image?.resize(to: CGSize(width: 355, height: 500))
            let roundedAndBorderedImage = resizedImage?.roundedAndBordered(
                cornerRadius: 10, borderWidth: 1, borderColor: UIColor.black)
            photoPathImageView.image = roundedAndBorderedImage
        }
    }

    /// キーボードの完了ボタン配置、完了ボタン押してキーボードを非表示に変更するメソッド
    private func setKeyboardCloseButton() {
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
}

// MARK: - ボタンタップ時のアラート関連
extension EditItemViewController {
    /// アラートで確認するメソッド
    /// - 編集を中止て前の画面に戻るか
    /// - 中止をキャンセルして画面に止まるか
    private func showCancelAlert() {
        let alertController = UIAlertController(title: "編集を中止", message:
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

    /// 追加ボタンをタップした時の処理
    /// - 商品名が未入力の場合はアラートを出す
    /// - 商品名が入力されていればデータを書き込み、画面を閉じる
    private func addOrReEnter() async {
        if nameOfItemTextField.text == "" {
            // 警告アラート
            let alertController = UIAlertController(title: nil, message:
                                                        "商品名は必ず入力してください", preferredStyle: .alert)
            // 何もしない
            let reEnterAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(reEnterAction)
            present(alertController, animated: true)
        } else {
            await saveData()
            self.dismiss(animated: true)
        }
    }

    /// 保存の処理
    private func saveData() async {
        do {
            // numberOfItemPickerViewで選択された値を取得
            let selectedNumberOfItem = numberOfItemArray[numberOfItemPickerView.selectedRow(inComponent: 0)]
            // numberOfItemPickerViewで選択された値を取得
            let selectedUnit = unitArray[unitPickerView.selectedRow(inComponent: 0)]
            // データベースに保存
            let uid = AccountManager.shared.getAuthStatus()
            // ユーザー共有者のuidを取得
            let sharedUsers = try await FirestoreManager.shared.getSharedUsers(uid: uid)
            // 写真をアップロードして、ダウンロードURLを取得
            StorageManager.shared.upLoadShoppingItemPhoto(uid: uid, image: photoPathImageView.image,
                                                          completion: { [weak self] photoURL in
                guard let photoURL else { return }
                guard let self else { return }
                // 保存するリストを作成
                let addItem = ShoppingItemModel(isCheckBox: false,
                                                nameOfItem: self.nameOfItemTextField.text!,
                                                numberOfItem: selectedNumberOfItem,
                                                unit: selectedUnit,
                                                salesFloorRawValue: self.selectedSalesFloorRawValue!,
                                                supplement: self.supplementTextView.text,
                                                photoURL: photoURL,
                                                owner: uid,
                                                sharedUsers: sharedUsers)
                FirestoreManager.shared.addItem(uid: uid, addItem: addItem)
            })

        } catch let error {
            print(error)
        }
    }

    /// 保存の処理(Realm)
//    private func saveData() {
//        // numberOfItemPickerViewで選択された値を取得
//        let selectedNumberOfItem = numberOfItemArray[numberOfItemPickerView.selectedRow(inComponent: 0)]
//        // numberOfItemPickerViewで選択された値を取得
//        let selectedUnit = unitArray[unitPickerView.selectedRow(inComponent: 0)]
//        // データベースに保存
//        let realm = try! Realm()
//        try! realm.write {
//            errandData.nameOfItem = nameOfItemTextField.text!
//            errandData.numberOfItem = selectedNumberOfItem
//            errandData.unit = selectedUnit
//            errandData.salesFloorRawValue = selectedSalesFloorRawValue!
//            if supplementTextView.text == "" {
//                errandData.supplement = nil
//            } else {
//                errandData.supplement = supplementTextView.text
//            }
//            errandData.photoFileName = errandData.setImage(image: photoPathImageView.image)
//            realm.add(errandData)
//        }
//    }
}

// MARK: - UIPickerViewDataSource&Delegate
extension EditItemViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

// MARK: - UITextFieldDelegate
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

// MARK: - SelectTypeOfSalesFloorViewControllerDelegate
extension EditItemViewController:SelectTypeOfSalesFloorViewControllerDelegate {
    /// SelectTypeOfSalesFloorViewで各Buttonをタップした際のメソッド
    /// - selectTypeOfSalesFloorButtonのタイトルを該当する売り場の名称に変更
    /// - selectTypeOfSalesFloorButtonのバックグラウンドカラーを該当する売り場の色に変更
    /// - addButtonを活性化
    func salesFloorButtonDidTapDone(salesFloorRawValue: DefaultSalesFloorType.RawValue) {
        let useSalesFloorTypeKey = "useSalesFloorTypeKey"
        let salesFloorTypeInt = UserDefaults.standard.integer(forKey: useSalesFloorTypeKey)
        // 0 -> カスタム、1(else) -> デフォルト
        if salesFloorTypeInt == 0 {
            // カスタムマップタイプの処理
            setCustomSalesFloorButton(salesFloorRawValue: salesFloorRawValue)
            addButton.setEnable()
        } else {
            // デフォルトマップタイプの処理
            setDefaultSalesFloorButton(salesFloorRawValue: salesFloorRawValue)
            addButton.setEnable()
        }
        selectedSalesFloorRawValue = salesFloorRawValue
    }
}

// MARK: - UITextViewDelegate
extension EditItemViewController: UITextViewDelegate {
    /// 入力があったらプレースホルダーのラベルを非表示
    func textViewDidBeginEditing(_ textView: UITextView) {
            placeholderLabel.isHidden = true
    }
    /// 編集終了後、何も入力されていなかったらプレースホルダーをセット
    func textViewDidEndEditing(_ textView: UITextView) {
        if supplementTextView.text == "" {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    /// 入力制限を３０文字以内で設定
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let maxLength = 30
        let currentString: NSString = supplementTextView.text as NSString
        let updatedString = currentString.replacingCharacters(in: range, with: text)
        return updatedString.count <= maxLength
    }
}

// MARK: - UIImagePickerDelegate,UINavigationControllerDelegate
// !!!: いずれPHPickerに変更しないといけないかも
// 写真添付と削除の処理関連
extension EditItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// 撮影または写真選択が終了した際のメソッド
    /// - 撮影または選択した画像をUIImageViewに表示させる
    /// - 写真の取り消しボタンを活性化する
    /// - 画面を閉じてCreateNewItemViewに戻る
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        setPhotoPathImageView(image: image)
        deletePhotoButton.setEnable()
        photoBackgroundImage.isHidden = true
        dismiss(animated: true)
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
            self.photoPathImageView.image = nil
            self.deletePhotoButton.setDisable()
            self.photoBackgroundImage.isHidden = false
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

