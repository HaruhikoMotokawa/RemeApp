//
//  Cache.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/01.
//

import Foundation
import UIKit

final class Cache: NSCache<AnyObject, AnyObject> {
    
    static let shared = Cache()

    private let cache = NSCache<NSString, UIImage>()

    private override init() {}

    func getImage(photoURL url: String, completion: @escaping (UIImage?) -> Void) {
        // すでにキャッシュされている画像があればcachedImageを返却
        if let cachedImage = cache.object(forKey: url as NSString) {
            print("👍🏻キャッシュ画像を表示するで")
            completion(cachedImage)
        } else {
            print("🧐キャッシュしてないからダウンロードするで")
            // オフラインだったらシステムの画像を返却
            guard NetworkMonitor.shared.isConnected else {
                let primaryImage = UIImage(systemName: "photo.artframe")
                completion(primaryImage)
                return
            }
            // もしimageUrlがURL型に変換できなかったら抜ける
            guard let imageURL = URL(string: url) else {
                completion(nil)
                return
            }
            //URLSessionのデータタスクを開始
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                // 強参照だった場合、エラーが出た場合、データが存在しない,画像が存在しない場合は抜ける
                guard let self, error == nil, let data, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                // ダウンロードURLを鍵としてキャッシュに保存
                print("💽キャッシュに保存")
                self.cache.setObject(image, forKey: url as NSString)
                completion(image) // 画像を返却
            }.resume() // タスクを終了
        }
    }

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
}
