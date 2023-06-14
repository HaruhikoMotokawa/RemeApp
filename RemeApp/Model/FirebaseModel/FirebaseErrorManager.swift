//
//  FirebaseErrorManager.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/11.
//

import FirebaseAuth
import FirebaseFirestore

/// Firebaseに関するエラーを管理するクラス
final class FirebaseErrorManager {

    /// 他のクラスで使用できるようにstaticで定義
    static let shared = FirebaseErrorManager()
    /// 外部アクセスを禁止
    private init() {}

    /// AuthとFirestore両方のエラーメッシージ用メソッド
    func setErrorMessage(_ error: Error?) -> String {
        // NSError型、AuthErrorCode、FirestoreErrorCodeのどれにも該当しなければ抜ける
        guard let error = error as NSError?,
              let authErrorCode = AuthErrorCode.Code(rawValue: error._code),
              let firestoreErrorCode = FirestoreErrorCode.Code(rawValue: error._code) else {
            return "不明なエラーです"
        }
        // エラーの内容によって処理を切り替える
        switch error {
                // Auth関連の場合
            case authErrorCode:
                return setAuthErrorMessage(error)
                // Firestotr関連の場合
            case firestoreErrorCode:
                return setFirestoreErrorMessage(error)
            default:
                return "不明なエラーです"
        }
    }

    /// Authに関するエラーメッセージ出力メソッド
    func setAuthErrorMessage(_ error:Error?) -> String {
        // NSError型、AuthErrorCodeに該当しなければ抜ける
        guard let error = error as NSError?,
              let errorCode = AuthErrorCode.Code(rawValue: error._code) else {
            return "不明なエラーです"
        }
        // エラーの内容によってメッセージを切り替える
        switch errorCode {
                // ネットワークエラー
            case .networkError:
                return AuthError.networkError.title
                // パスワードが条件より脆弱であることを示します。
            case .weakPassword:
                return AuthError.weakPassword.title
                // ユーザーが間違ったパスワードでログインしようとしたことを示します。
            case .wrongPassword:
                return AuthError.wrongPassword.title
                // ユーザーのアカウントが無効になっていることを示します。
            case .userNotFound:
                return AuthError.userNotFound.title
                // メールアドレスの形式が正しくないことを示します。
            case .invalidEmail:
                return AuthError.invalidEmail.title
                // 既に登録されているメールアドレス
            case .emailAlreadyInUse:
                return AuthError.emailAlreadyInUse.title
                // その他のエラー
            default:
                return AuthError.other.title
        }
    }

    /// Firestoreに関するエラーメッセージ出力メソッド
    func setFirestoreErrorMessage(_ error:Error?) -> String {
        // NSError型、FirestoreErrorCodeに該当しなければ抜ける
        guard let error = error as NSError?,
              let errorCode = FirestoreErrorCode.Code(rawValue: error._code) else {
            return "不明なエラーです"
        }
        // エラーの内容によってメッセージを切り替える
        switch errorCode {
                // 操作はキャンセルされました
            case .cancelled:
                return FirestoreError.cancelled.title
                // 操作が完了する前に期限が切れました。
            case .deadlineExceeded:
                return FirestoreError.deadlineExceeded.title
                // 要求されたドキュメントが見つかりませんでした。
            case .notFound:
                return FirestoreError.notFound.title
                // 作成しようとしたドキュメントはすでに存在します
            case .alreadyExists:
                return FirestoreError.alreadyExists.title
                // 指定された操作を実行する権限がありません。
            case .permissionDenied:
                return FirestoreError.permissionDenied.title
                // 容量が不足している可能性があります。
            case .resourceExhausted:
                return FirestoreError.resourceExhausted.title
                // このサービスは現在ご利用いただけません。
            case .unavailable:
                return FirestoreError.unavailable.title
                // 回復不能なデータの損失または破損。
            case .dataLoss:
                return FirestoreError.dataLoss.title
                // その他のエラー
            default:
                return FirestoreError.unknown.title
        }
    }
}

/// FirebaseAuthに関するエラー
public enum AuthError: Error {
    // ネットワークエラー
    case networkError
    // パスワードが条件より脆弱であることを示します。
    case weakPassword
    // ユーザーが間違ったパスワードでログインしようとしたことを示します。
    case wrongPassword
    // ユーザーのアカウントが無効になっていることを示します。
    case userNotFound
    // メールアドレスの形式が正しくないことを示します。
    case invalidEmail
    // 既に登録されているメールアドレス
    case emailAlreadyInUse
    // その他のエラー
    case other

    /// エラーによって表示する文字を定義
    var title: String {
        switch self {
            case .networkError:
                return "通信エラーです。"
            case .weakPassword:
                return "パスワードが脆弱です。"
            case .wrongPassword:
                return "メールアドレス、もしくはパスワードが違います。"
            case .userNotFound:
                return "アカウントがありません。"
            case .invalidEmail:
                return "正しくないメールアドレスの形式です。"
            case .emailAlreadyInUse:
                return "既に登録されているメールアドレスです。"
            case .other:
                return "エラーが起きました。"
        }
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
