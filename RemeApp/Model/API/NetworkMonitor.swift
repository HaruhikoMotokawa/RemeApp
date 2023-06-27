//
//  NetworkMonitor.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/27.
//

import Foundation
import Network

/// ネットワーク接続状態を監視するシングルトンクラス
final class NetworkMonitor {
    /// シングルトンインスタンス
    static let shared = NetworkMonitor()
    /// NWPathMonitorインスタンス
    private let monitor = NWPathMonitor()
    /// グローバルな実行キューを定数として宣言
    private let queue = DispatchQueue.global()

    /// ネットワークに接続されているかどうか(set)で読み取りだけ可能にする
    private(set) var isConnected: Bool = false {
        // didsetは値が変更された際の処理を記述する
        didSet {
            // isConnectedプロパティが変化した場合に通知を送信する
            NotificationCenter.default.post(name: .networkStatusDidChange, object: nil)
        }
    }
    /// インスタンスの生成を禁止するprivateイニシャライザ
    private init() {}

    /// ネットワークの監視を開始する
    func startMonitoring() {
        // 監視を開始
        monitor.start(queue: queue)
        // NWPathMonitorのpathUpdateHandlerを定義する
        monitor.pathUpdateHandler = { [weak self] path in
            // ネットワークに接続されているかどうかを更新する
            self?.isConnected = path.status == .satisfied
            // ネットワーク接続状態をログに出力する
            print("isConnected: \(self?.isConnected ?? false)")
        }
    }
    /// ネットワークの監視を停止する
    func stopMonitoring() {
        // 監視を終了する
        monitor.cancel()
    }

}

