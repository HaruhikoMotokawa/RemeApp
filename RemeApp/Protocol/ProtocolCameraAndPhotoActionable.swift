//
//  ProtocolCameraAndPhotoActionable.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/10.
//

import UIKit
/// setCameraAndPhotoActionメソッドを流用するためのプロトコル
protocol CameraAndPhotoActionable {
    func setCameraAndPhotoAction()
}

extension CameraAndPhotoActionable where Self: UIViewController & UIImagePickerControllerDelegate
& UINavigationControllerDelegate{

    /// カメラ撮影とフォトライブラリーでの写真選択を実行する処理
    /// - アクションシートで選択
    /// - カメラ撮影アクション
    /// - フォトライブリーラリーから選択アクション
    /// - キャンセルアクション
    func setCameraAndPhotoAction() {
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
}

