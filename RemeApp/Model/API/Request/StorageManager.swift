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
    /// 参照のためのインスタンス
    private let storageRef = Storage.storage().reference()
    /// フォルダーのパス
    private let folderPath: String = "shoppingItem"

    /// 写真を保存し、ダウンロードURLを取得して返却する
    internal func upLoadShoppingItemPhoto(uid: String, image: UIImage?, completion: @escaping (_ url: String?) -> Void)  {
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
                print("アップロード成功")
                imageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("ダウンロードURL取得失敗")
                        completion(nil)
                    }
                    print("ダウンロードURLの取得成功")
                    completion(url?.absoluteString)
                })
            }
        }
    }

    // TODO: 後で削除
    /// ダウンロードURLからUIImageに変換
    internal func setImageWithUrl(photoURL: String) -> UIImage? {
        //　もしphotoURLが""でないのならURLとして変換
        if let imageUrl:URL = URL(string: photoURL) {
            do {
                // オフラインだったらシステムの画像を返却
                guard NetworkMonitor.shared.isConnected else {
                    return UIImage(systemName: "photo.artframe")
                }
                // ダウンロードURLから画像を取得
                let imageData:Data = try Data(contentsOf: imageUrl)
                return UIImage(data: imageData)
            } catch {
                 print(error)
                return UIImage(systemName: "photo.artframe")
            }
        } else {
            // photoURLが""だったらnilを返却
            return nil
        }
    }

    // TODO: 後で削除
    /// ダウンロードURLからUIImageに変換
    internal func setDownloadImage(photoURL: String, completion: @escaping (UIImage?) -> Void) {
        // もしimageUrlがURL型に変換できなかったら抜ける
        guard let imageUrl = URL(string: photoURL) else {
            completion(nil)
            return
        }
        // オフラインだったらシステムの画像を返却
        guard NetworkMonitor.shared.isConnected else {
            let primaryImage = UIImage(systemName: "photo.artframe")
            completion(primaryImage)
            return
        }
        //URLSessionのデータタスクを開始
        let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            // データがない、、またはエラーだった場合は抜ける
            guard let data, error == nil else {
                completion(nil)
                print(error ?? "不明なエラー")
                return
            }
            // 取得したデータをUIImageにセット
            let setImage = UIImage(data: data)
            completion(setImage) // 画像を返却
        }
        task.resume() // 全体のタスクを終了
    }

    /// 写真をStorageから削除
    internal func deletePhoto(photoURL: String, completion: ((Error?) -> Void)? = nil) {
        print("ダウンロードURL：　\(photoURL)")
        if photoURL.isEmpty {
            completion?(nil)
            return
        }
        let targetRef = storage.reference(forURL: photoURL)
        targetRef.delete { error in
            completion?(error)
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidData
}
