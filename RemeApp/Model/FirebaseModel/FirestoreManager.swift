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

    // FireStoreのsharedUsersの配列を保持するための変数
//    var sharedUsers: [String] = []


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

    // 共有者に登録しているユーざーのuidを取得するメソッド
    func getSharedUsers(uid: String) async throws -> [String] {
        return try await withCheckedThrowingContinuation { continuation in
            db.collection("users").document(uid).addSnapshotListener { (documentSnapshot ,err) in
                print("Firestoreにアクセス開始")
                guard let documentSnapshot else {
                    continuation.resume(throwing: err ?? FirestoreError.unknown)
                    return
                }
                let data = documentSnapshot.data()!
                let sharedUsers = data["sharedUsers"] as? [String] ?? []
                print("取得共有者：　\(sharedUsers)")
                continuation.resume(returning: sharedUsers)
            }
        }
    }

    // 共有者のuidからアカウント名を取得するメソッド
    func getUserName(uid: String?) async throws -> String {
        guard let uid else {
            return "登録者なし"
        }

        return try await withCheckedThrowingContinuation { continuation in
            let userDocRer = db.collection("users").document(uid)
            userDocRer.getDocument { (documentSnapshot, error) in
                guard let documentSnapshot else {
                    continuation.resume(throwing: error ?? FirestoreError.unknown)
                    return
                }
                let name = documentSnapshot.get("name") as! String
                continuation.resume(returning: name)
            }
        }
    }
}
