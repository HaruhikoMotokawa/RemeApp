//
//  AccountManager.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/09.
//

import UIKit
import FirebaseAuth
/// Firebaseの認証に関する処理を管理するシングルトンクラス
final class AccountManager {
    /// 他のクラスで使用できるようにstaticで定義
    static let shared = AccountManager()
    /// 外部アクセスを禁止
    private init() {}

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

    /// メールとパスワードでログイン
    /// - エラーが出たらアラートを出す
    /// - 成功したら画面を閉じる
    func signUp(name: String, email: String, password: String, viewController: UIViewController){
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self else { return }
            if error == nil {
                //サインアップ成功
                print("アカウントの作成に成功")
                viewController.navigationController?.popViewController(animated: true)
            } else {
                if let errorCode = AuthErrorCode.Code(rawValue: error!._code) {
                    switch errorCode {
                        case .invalidEmail:
                            //メールアドレスの形式によるエラー
                            print("メールアドレスの形式によるエラー")
                            self.showAlert(errorCode: .invalidEmail, viewController: viewController)
                        case .weakPassword:
                            //パスワードが脆弱(５文字以下)
                            print("パスワードが脆弱(５文字以下)")
                            self.showAlert(errorCode: .weakPassword, viewController: viewController)
                        case .emailAlreadyInUse:
                            //メールアドレスが既に登録されている
                            print("メールアドレスが既に登録されている")
                            self.showAlert(errorCode: .emailAlreadyInUse, viewController: viewController)
                        case .networkError:
                            //通信エラー
                            print("通信エラー")
                            self.showAlert(errorCode: .networkError, viewController: viewController)
                        default:
                            //その他エラー
                            print("その他エラー")
                    }
                }
            }
        }
    }

    /// エラーメッセージごとにアラートを出す
    func showAlert(errorCode: AuthErrorCode.Code, viewController: UIViewController) {
        var errorMessage: String
        switch errorCode {
            case .invalidEmail:
                errorMessage = "メールアドレスの形式が正しくありません。"
            case .weakPassword:
                errorMessage = "パスワードは6文字以上である必要があります。"
            case .emailAlreadyInUse:
                errorMessage = "このメールアドレスは既に使用されています。"
            case .networkError:
                errorMessage = "ネットワークエラーが発生しました。通信環境を確認してください。"
            default:
                errorMessage = "エラーが発生しました。"
        }
        let alert = UIAlertController(title: "エラー", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}


