//
//  AccountManager.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/09.
//

//import UIKit
import FirebaseAuth
/// Firebaseの認証に関する処理を管理するシングルトンクラス
final class AccountManager {
    /// 他のクラスで使用できるようにstaticで定義
    static let shared = AccountManager()
    /// 外部アクセスを禁止
    private init() {}

    /// 現在の認証状況を取得する
    func getAuthStatus() -> String {
        print("アカウントチェック開始")
        guard let user = Auth.auth().currentUser else {
            return "ログイン情報なし"
        }
        let uid = user.uid
        print ("uid取得成功")
        return uid
    }

    /// 匿名認証でログイン
    func signInAnonymity() {
        Auth.auth().signInAnonymously() { authResult, error in
            guard (authResult?.user) != nil else {
                print("失敗です。")
                return
            }
            print ("ログイン成功")
        }
    }

    /// メールとパスワードでアカウント作成
    /// - 匿名アカウントから永続アカウントへ引き継ぐ
    /// - 成功したらFirestoreへ情報登録をするためにuidを発行して戻り値に返す
    func signUp(email: String, password: String) async throws -> String {
        // Firebase認証のために、メールアドレスとパスワードから認証資格情報を生成
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        // 現在ログインしているユーザーを取得
        let user = Auth.auth().currentUser
        // 現在ログインしているかチェック
        guard let anonymousUser = user else {
            throw AuthError.userNotFound
        }
        // アカウントを引き継ぐ、この処理は非同期処理なのでawaitをつけ、失敗の可能性があるからtry
        let result =  try await anonymousUser.link(with: credential)
        // 成功したらuidにユーザーIDを格納
        let uid = result.user.uid
        print("アカウントの作成に成功")
        // 返却
        return uid
    }

    /// ログアウトメソッド
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
            print("ログアウトできへんよ")
        }
    }

    func setErrorMessage(_ error:Error?) -> String {
        guard let error = error as? AuthError else {
            return "エラーが発生しました"
        }

        switch error {
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
                // 不明なエラー
            case .unknown:
                return AuthError.unknown.title
        }
    }
}

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
    // 不明なエラー
    case unknown

    //エラーによって表示する文字を定義
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
            case .unknown:
                return "エラーが起きました。"
        }
    }
}
