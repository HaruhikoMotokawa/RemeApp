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

    /// Firestoreのインスタン化
    private let db = Firestore.firestore()

    /// 自分のshoppingItemコレクションのリスナー
     internal var shoppingListMyItemListener: ListenerRegistration?

     internal var salesFloorMapMyItemListener: ListenerRegistration?

     internal var editShoppingListMyItemListener: ListenerRegistration?

    /// 自身のuidを元に登録したユーザー情報を取得してUserDataModelで返却するメソッド
    /// - 非同期処理のためasyncキーワードつける
    /// - エラー処理は呼び出し元で実施するためthrowsキーワードつける
    internal func getUserInfo(uid: String) async throws -> UserDataModel? {
        // 非同期処理であるFirestoreへのアクセスにより、ユーザー情報をUserDataModelに変換して定数に入れる
        let document = try await db.collection(Collection.users.path).document(uid).getDocument(as: UserDataModel.self)
        print("Firestoreからデータ取得成功")
        // UserDataModelで格納した値を返却
        return document
    }

    /// ユーザー情報を新規作成するメソッド
    /// - 非同期処理のためasyncキーワードつける
    /// - エラー処理は呼び出し元で実施するためthrowsキーワードつける
    internal func createUsers(name: String, email: String, password: String, uid: String) async throws {
        // UserDataModelをuserとして定義
        let user = UserDataModel(name: name, email: email, password: password)
        // userを元にFirestoreに保存実行
        try db.collection(Collection.users.path).document(uid).setData(from: user)
    }

    /// ユーザー情報を削除するメソッド
    internal func deleteUsersDocument(uid: String) async throws {
        try await db.collection(Collection.users.path).document(uid).delete()
    }

    /// 共有者に登録しているユーザーのuidを取得するメソッド
    internal func getSharedUsers(uid: String) async throws -> [String] {
        let document = try await db.collection(Collection.users.path).document(uid).getDocument()
        let data = document.data()!
        let sharedUsers = data[Field.sharedUsers.path] as? [String] ?? []
        return sharedUsers
    }

    /// 共有者のuidからアカウント名を取得するメソッド
    internal func getUserName(uid: String?) async throws -> String {
        // uidがnilだったらテキストを返却して終了
        guard let uid else {
            return "登録者なし"
        }
        // 非同期処理の実行結果を返却する
        return try await withCheckedThrowingContinuation { continuation in
            // usersコレクションのuidと同じドキュメントidのドキュメントにアクセス
            let userDocRer = db.collection(Collection.users.path).document(uid)
            // 該当するドキュメントからデータの取得を開始
            userDocRer.getDocument { (documentSnapshot, error) in
                // 該当のドキュメントがnilだったらエラーをスローして終了
                guard let documentSnapshot else {
                    continuation.resume(throwing: error ?? FirestoreError.unknown)
                    return
                }
                // ドキュメントに登録されたnameを取得
                let name = documentSnapshot.get(Field.name.path) as! String
                // 取得した値を返却
                continuation.resume(returning: name)
            }
        }
    }

    /// 共有者を更新するメソッド
    /// - 主に削除に使用
    /// - 削除する登録者を抜いた配列を引数のshardUsersに代入
    func upData(uid: String, shardUsers: [String]) async throws {
        try await db.collection(Collection.users.path).document(uid).updateData([Field.sharedUsers.path:shardUsers])
    }

    // 共有者を追加するメソッド
    func addSharedUsers(inputUid: String, uid: String) async throws {
        let userRef = db.collection(Collection.users.path)
        let inputUserQuery = userRef.whereField(FieldPath.documentID(), isEqualTo: inputUid)
        let querySnapshot = try await inputUserQuery.getDocuments()
        if querySnapshot.isEmpty {
            throw FirestoreError.notFound
        }
        let document = userRef.document(uid)
        try await document.updateData([Field.sharedUsers.path: FieldValue.arrayUnion([inputUid])])
    }
}
// MARK: - shoppingItem関連
extension FirestoreManager {

    /// 自分が作成した買い物リストへの変更を監視する
    internal func getShoppingItemObserver(listener: inout ListenerRegistration?, uid: String,completion: @escaping ([ShoppingItemModel]) -> Void) {
        // 自分が作成した買い物商品のリスナーをセット
        listener = db.collection(Collection.shoppingItem.path).whereField(Field.owner.path, isEqualTo: uid)
            .addSnapshotListener { (querySnapshot, error) in
                guard  let querySnapshot else { return }
                // データをShoppingItemModelにマッピング
                let myShoppingItemList = querySnapshot.documents.map{ item -> ShoppingItemModel in
                    let data = item.data()
                    return ShoppingItemModel(id: item.documentID,
                                             isCheckBox: data[Field.isCheckBox.path] as? Bool ?? false,
                                             nameOfItem: data[Field.nameOfItem.path] as? String ?? "",
                                             numberOfItem: data[Field.numberOfItem.path] as? String ?? "",
                                             unit: data[Field.unit.path] as? String ?? "",
                                             salesFloorRawValue: data[Field.salesFloorRawValue.path] as? Int ?? 1,
                                             supplement: data[Field.supplement.path] as? String ?? "",
                                             photoURL: data[Field.photoURL.path] as? String ?? "",
                                             owner: data[Field.owner.path] as? String ?? "",
                                             sharedUsers: data[Field.sharedUsers.path] as? [String] ?? [])
                }
                completion(myShoppingItemList)
            }
    }

    /// 自分の買い物リストの監視を解除
    internal func removeShoppingItemObserver(listener: inout ListenerRegistration?) {
        listener?.remove()
    }

    /// 新規作成した買い物の商品を保存
    internal func addItem(uid: String, addItem: ShoppingItemModel) {
        db.collection(Collection.shoppingItem.path).addDocument(data: [
            "isCheckBox": addItem.isCheckBox ,
            "nameOfItem": addItem.nameOfItem ,
            "numberOfItem": addItem.numberOfItem ,
            "unit":addItem.unit ,
            "salesFloorRawValue": addItem.salesFloorRawValue ,
            "supplement": addItem.supplement ,
            "photoURL": addItem.photoURL ,
            "owner": addItem.owner,
            "sharedUsers": addItem.sharedUsers])
        { err in
            if err != nil {
                print("Firestoreへの保存に失敗")
            } else {
                print("Firestoreへの保存に成功")
            }
        }
    }

    /// 編集した買い物商品を保存
    internal func upDateItem(uid: String, addItem: ShoppingItemModel) {
        guard let id = addItem.id else { return }
        db.collection(Collection.shoppingItem.path).document(id).updateData([
            "isCheckBox": addItem.isCheckBox ,
            "nameOfItem": addItem.nameOfItem ,
            "numberOfItem": addItem.numberOfItem ,
            "unit":addItem.unit ,
            "salesFloorRawValue": addItem.salesFloorRawValue ,
            "supplement": addItem.supplement ,
            "photoURL": addItem.photoURL ,
            "owner": addItem.owner,
            "sharedUsers": addItem.sharedUsers])
        { err in
            if err != nil {
                print("Firestoreへの保存に失敗")
            } else {
                print("Firestoreへの保存に成功")
            }
        }
    }

    // ドキュメントを削除する
    internal func deleteItem(id: String, completion: @escaping (Error?) -> ()) {
        db.collection(Collection.shoppingItem.path).document(id).delete() { error in
            if let error {
                print("削除に失敗: \(error)")
                completion(error)
            } else {
                print("削除成功")
                completion(nil)
            }
        }
    }

    
}

/// コレクションのパスを管理
enum Collection {
    case users
    case shoppingItem
    case mapSettings
    case customSalesFloor

    // パスを返却
    var path: String {
        switch self {
            case .users:
                return "users"
            case .shoppingItem:
                return "shoppingItem"
            case .mapSettings:
                return "mapSettings"
            case .customSalesFloor:
                return "customSalesFloor"
        }
    }
}

/// フィールドのパスを管理
enum Field {
    case name
    case isCheckBox
    case nameOfItem
    case numberOfItem
    case unit
    case salesFloorRawValue
    case supplement
    case photoURL
    case owner
    case sharedUsers

    ///パスを返却
    var path: String {
        switch self {
            case .name:
                return "name"
            case .isCheckBox:
                return "isCheckBox"
            case .nameOfItem:
                return "nameOfItem"
            case .numberOfItem:
                return "numberOfItem"
            case .unit:
                return "unit"
            case .salesFloorRawValue:
                return "salesFloorRawValue"
            case .supplement:
                return "supplement"
            case .photoURL:
                return "photoURL"
            case .owner:
                return "owner"
            case .sharedUsers:
                return "sharedUsers"
        }
    }
}
