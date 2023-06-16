//
//  StorageManager.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/15.
//

import FirebaseStorage

final class StorageManager {
    /// 他のクラスで使用できるようにstaticで定義
    static let shared = StorageManager()
    /// 外部アクセスを禁止
    private init() {}

    private let storage = Storage.storage()

    private let storageRef = Storage.storage().reference()


    private let folderPath: String = "shoppingItem"


    func upLoadShoppingItemPhoto(uid: String, image: UIImage?, completion: @escaping (_ url: String?) -> Void)  {
        guard let image else {
            print("写真のデータがないよん")
            completion("")
            return
        }
        guard let jpegData = image.jpegData(compressionQuality: 0.8) else {
            print("jpegの変換に失敗")
            completion(nil)
            return
        }

        let ImageName = "\(uid).\(Date().timeIntervalSince1970).jpeg"
        let userRef = storageRef.child(folderPath)
        let imageRef = userRef.child(ImageName)
        imageRef.putData(Data(jpegData), metadata: nil) { (metadata, error) in
            if error != nil {
                print("アップロード失敗: \(error!.localizedDescription)")
                completion(nil)
            } else {
                imageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("ダウンロードURL取得失敗")
                        completion(nil)
                    }
                        completion(url?.absoluteString)
                    })
                }
            }
        }


}
