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

/// Firestoreに関するエラー
public enum FirestoreError: Error {

    // 操作はキャンセルされました
    case cancelled
    // 不明なエラー
    case unknown
    // クライアントが無効な引数を指定しました。
    case invalidArgument
    // 操作が完了する前に期限が切れました。
    case deadlineExceeded
    // 要求されたドキュメントが見つかりませんでした。
    case notFound
    // 作成しようとしたドキュメントはすでに存在します
    case alreadyExists
    // 指定された操作を実行する権限がありません。
    case permissionDenied
    // 容量が不足している可能性があります。
    case resourceExhausted
    // システムが操作の実行に必要な状態にないため、操作は拒否されました。
    case failedPrecondition
    // 同時実行の問題が原因で、操作が中止されました。
    case aborted
    // 有効範囲を超えて操作を試みました。
    case outOfRange
    // サポート/有効化されていません。
    case unimplemented
    // 内部エラー。
    case `internal`
    // このサービスは現在ご利用いただけません。
    case unavailable
    // 回復不能なデータの損失または破損。
    case dataLoss
    // 操作の有効な認証クレデンシャルがありません。
    case unauthenticated

    //エラーによって表示する文字を定義
    var title: String {
        switch self {

            case .cancelled:
                return "操作はキャンセルされました"
            case .unknown:
                return "不明なエラー"
            case .invalidArgument:
                return "クライアントが無効な引数を指定しました。"
            case .deadlineExceeded:
                return "操作が完了する前に期限が切れました。"
            case .notFound:
                return "要求されたドキュメントが見つかりませんでした。"
            case .alreadyExists:
                return "作成しようとしたドキュメントはすでに存在します"
            case .permissionDenied:
                return "指定された操作を実行する権限がありません。"
            case .resourceExhausted:
                return "容量が不足している可能性があります。"
            case .failedPrecondition:
                return "システムが操作の実行に必要な状態にないため、操作は拒否されました。"
            case .aborted:
                return "同時実行の問題が原因で、操作が中止されました。"
            case .outOfRange:
                return "有効範囲を超えて操作を試みました。"
            case .unimplemented:
                return "サポート/有効化されていません。"
            case .internal:
                return "内部エラー。"
            case .unavailable:
                return "このサービスは現在ご利用いただけません。"
            case .dataLoss:
                return "回復不能なデータの損失または破損。"
            case .unauthenticated:
                return "操作の有効な認証クレデンシャルがありません。"
        }
    }
}
