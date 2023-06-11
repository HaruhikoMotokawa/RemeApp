//
//  FirestoreManager.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/09.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Firestoreへのアクセスを管理するクラス
final class FirestoreManager {
    /// 他のクラスで使用できるようにstaticで定義
    static let shared = FirestoreManager()
    /// 外部アクセスを禁止
    private init() {}

    let db = Firestore.firestore()

    /// 自身のuidを元に登録したユーザー情報を取得して配置するメソッド
    /// - 非同期処理のためasyncキーワードつける
    /// - エラー処理は呼び出し元で実施するためthrowsキーワードつける
    func getUserInfo(uid: String, nameLabel: UILabel, mailLabel: UILabel,
                     passwordLabel: UILabel, uidLabel: UILabel) async throws {
        // メインスレッドで行うことを明示
        Task { @MainActor in
            // 非同期処理であるFirestoreへのアクセスにより、ユーザー情報をUserDataModelに変換して定数に入れる
            let document = try await db.collection("users").document(uid).getDocument(as: UserDataModel.self)
            // 各ラベルのテキストに配置
            nameLabel.text = document.name
            mailLabel.text = document.email
            passwordLabel.text = document.password
            uidLabel.text = document.id
        }
    }

    /// ユーザー情報を新規作成するメソッド
    /// - 非同期処理のためasyncキーワードつける
    /// - エラー処理は呼び出し元で実施するためthrowsキーワードつける
    func createUsers(name: String, email: String, password: String, uid: String) async throws {
        // UserDataModelをuserとして定義
        let user = UserDataModel(name: name, email: email, password: password)
        // userを元にFirestoreに保存実行
        try db.collection("users").document(uid).setData(from: user)
    }
}
