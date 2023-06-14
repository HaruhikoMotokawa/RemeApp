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

    var sharedUsersListener: ListenerRegistration?

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

    /// ユーザー情報を削除するメソッド
    func deleteUsersDocument(uid: String) async throws {
        try await db.collection("users").document(uid).delete()
    }

    /// 共有者に登録しているユーザーのuidを取得するメソッド
    func getSharedUsers(uid: String) async throws -> [String] {
        let document = try await db.collection("users").document(uid).getDocument()
        let data = document.data()!
        let sharedUsers = data["sharedUsers"] as? [String] ?? []
        return sharedUsers
    }

    /// 共有者のuidからアカウント名を取得するメソッド
    func getUserName(uid: String?) async throws -> String {
        // uidがnilだったらテキストを返却して終了
        guard let uid else {
            return "登録者なし"
        }
        // 非同期処理の実行結果を返却する
        return try await withCheckedThrowingContinuation { continuation in
            // usersコレクションのuidと同じドキュメントidのドキュメントにアクセス
            let userDocRer = db.collection("users").document(uid)
            // 該当するドキュメントからデータの取得を開始
            userDocRer.getDocument { (documentSnapshot, error) in
                // 該当のドキュメントがnilだったらエラーをスローして終了
                guard let documentSnapshot else {
                    continuation.resume(throwing: error ?? FirestoreError.unknown)
                    return
                }
                // ドキュメントに登録されたnameを取得
                let name = documentSnapshot.get("name") as! String
                // 取得した値を返却
                continuation.resume(returning: name)
            }
        }
    }

    /// 共有者を更新するメソッド
    /// - 主に削除に使用
    /// - 削除する登録者を抜いた配列を引数のshardUsersに代入
    func upData(uid: String, shardUsers: [String]) async throws {
        try await db.collection("users").document(uid).updateData(["sharedUsers":shardUsers])
    }

    // 共有者を追加するメソッド
    func addSharedUsers(inputUid: String, uid: String) async throws {
        let userRef = db.collection("users")
        let inputUserQuery = userRef.whereField(FieldPath.documentID(), isEqualTo: inputUid)
        let querySnapshot = try await inputUserQuery.getDocuments()
        if querySnapshot.isEmpty {
            throw FirestoreError.notFound
        }
        let document = userRef.document(uid)
        try await document.updateData(["sharedUsers": FieldValue.arrayUnion([inputUid])])
    }

}
