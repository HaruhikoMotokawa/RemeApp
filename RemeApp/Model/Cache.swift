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

    /// ダウンロードURLからUIImageを取得して返却する
    /// キャッシュにあればそこから返却、なければダウンロードしてキャッシュに保存しつつ返却
    internal func getImage(photoURL url: String, completion: @escaping (UIImage?) -> Void) {
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

    /// キャッシュに保存された画像データを削除
    internal func deleteCache(photoURL url: String) {
        if url.isEmpty {
            return
        }
        cache.removeObject(forKey: url as NSString)
        print("🗑️キャッシュ削除")
    }

    /// 全てのキャッシュを削除
    internal func deleteAllCache() {
        cache.removeAllObjects()
    }
}
