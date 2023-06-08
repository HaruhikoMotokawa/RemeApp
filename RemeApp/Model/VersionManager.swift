//
//  VersionManager.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/08.
//

import Foundation

/// バージョンの保存、変更を関するクラス
class VersionManager {

    /// VersionManagerクラスのシングルトンインスタンスにアクセスするためのエントリーポイント
    static let shared = VersionManager()

    /// 外部アクセスを禁止
    private init() {}

    /// アプリの現在バージョンを取得
    func getCurrentVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    /// 前回UserDefaultsに保存したアプリバージョンを取得
    func getSavedVersion() -> String? {
        return UserDefaults.standard.string(forKey: "appVersion")
    }

    /// 取得した現在のアプリバージョンをUserDefaultsに保存
    func saveCurrentVersion() {
        let defaults = UserDefaults.standard
        let currentVersion = getCurrentVersion()
        defaults.set(currentVersion, forKey: "appVersion")
    }

}
