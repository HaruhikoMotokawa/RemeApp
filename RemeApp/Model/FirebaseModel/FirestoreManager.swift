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

    /// 自身のuidを元に登録したユーザー情報を取得してUserDataModelで返却するメソッド
    /// - 非同期処理のためasyncキーワードつける
    /// - エラー処理は呼び出し元で実施するためthrowsキーワードつける
    func getUserInfo(uid: String) async throws -> UserDataModel? {
        // 非同期処理であるFirestoreへのアクセスにより、ユーザー情報をUserDataModelに変換して定数に入れる
        let document = try await db.collection("users").document(uid).getDocument(as: UserDataModel.self)
        print("Firestoreからデータ取得成功")
        // UserDataModelで格納した値を返却
        return document
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

    // ユーザー情報を上書きするメソッド

    // ユーザー情報を削除するメソッド
    func deleteUsersDocument(uid: String) async throws {
        try await db.collection("users").document(uid).delete()
    }

}
