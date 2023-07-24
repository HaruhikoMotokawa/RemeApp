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

    /// 自分のshoppingItemコレクションのshoppingListView専用リスナー
    internal var shoppingListMyItemListener: ListenerRegistration?
    /// 自分のshoppingItemコレクションのsalesFloorMapView専用リスナー
    internal var salesFloorMapMyItemListener: ListenerRegistration?
    /// 自分のshoppingItemコレクションのsalesFloorShoppingListView専用リスナー
    internal var salesFloorShoppingListMyItemListener: ListenerRegistration?
    /// 自分のshoppingItemコレクションのeditShoppingListView専用リスナー
    internal var editShoppingListMyItemListener: ListenerRegistration?

    /// 共有者のshoppingItemコレクションのsalesFloorMapView専用リスナー
    internal var shoppingListOtherItemListener: ListenerRegistration?
    /// 自分のshoppingItemコレクションのsalesFloorMapView専用リスナー
    internal var salesFloorMapOtherItemListener: ListenerRegistration?
    /// 自分のshoppingItemコレクションのsalesFloorShoppingListView専用リスナー
    internal var salesFloorShoppingListOtherItemListener: ListenerRegistration?
    /// 自分のshoppingItemコレクションのeditShoppingListView専用リスナー
    internal var editShoppingListOtherItemListener: ListenerRegistration?

    /// コレクションのパスを管理、Stringに準拠させると、指定しなければcase名を文字列で返す
    enum CollectionPathName: String {
        case users
        case shoppingItem
        case mapSettings
        case customSalesFloor
    }
    /// フィールドのパスを管理、Stringに準拠させると、指定しなければcase名を文字列で返す
    enum FieldPathName: String {
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
        case date
    }

    /// 自身のuidを元に登録した自分のユーザー情報を取得してUserDataModelで返却するメソッド
    /// - 非同期処理のためasyncキーワードつける
    /// - エラー処理は呼び出し元で実施するためthrowsキーワードつける
    internal func getUserInfo(uid: String) async throws -> UserDataModel? {
        // 非同期処理であるFirestoreへのアクセスにより、ユーザー情報をUserDataModelに変換して定数に入れる
        let document = try await db.collection(CollectionPathName.users.rawValue).document(uid).getDocument(as: UserDataModel.self)
        print("Firestoreからデータ取得成功")
        // UserDataModelで格納した値を返却
        return document
    }

    /// 自身のuidを共有者に登録している他のユーザーの情報をUserDataModelでリストにして返却するメソッド
    /// - 非同期処理のためasyncキーワードつける
    /// - エラー処理は呼び出し元で実施するためthrowsキーワードつける
    internal func getUsersList(deleteUid: String) async throws -> [UserDataModel] {
        // コレクションの参照先を定義
        let collectionRef = db.collection(CollectionPathName.users.rawValue)
        // deleteUidを登録している対象のユーザードキュメントを抽出
        let querySnapshot = try await collectionRef.whereField(FieldPathName.sharedUsers.rawValue, arrayContains: deleteUid).getDocuments()
        // 非同期処理であるFirestoreへのアクセスにより、ユーザー情報をUserDataModelに変換して定数に入れる
        let usersList = querySnapshot.documents.compactMap { document in
            try? document.data(as: UserDataModel.self)
        }
        print("Firestoreからデータ取得成功")
        // UserDataModelで格納した値を返却
        return usersList
    }

    /// ユーザー情報を新規作成するメソッド
    /// - 非同期処理のためasyncキーワードつける
    /// - エラー処理は呼び出し元で実施するためthrowsキーワードつける
    internal func createUsers(name: String, email: String, password: String, uid: String) async throws {
        // UserDataModelをuserとして定義
        let user = UserDataModel(name: name, email: email, password: password)
        // userを元にFirestoreに保存実行
        try db.collection(CollectionPathName.users.rawValue).document(uid).setData(from: user)
        print("ユーザー情報を新規作成")
    }

    /// ユーザー情報を削除するメソッド
    internal func deleteUsersDocument(uid: String) async throws {
        try await db.collection(CollectionPathName.users.rawValue).document(uid).delete()
    }

    /// 共有者に登録しているユーザーのuidを取得するメソッド
    internal func getSharedUsers(uid: String) async throws -> [String] {
        let document = try await db.collection(CollectionPathName.users.rawValue).document(uid).getDocument()
        let data = document.data()!
        let sharedUsers = data[FieldPathName.sharedUsers.rawValue] as? [String] ?? []
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
            let userDocRer = db.collection(CollectionPathName.users.rawValue).document(uid)
            // 該当するドキュメントからデータの取得を開始
            userDocRer.getDocument { (documentSnapshot, error) in
                // 該当のドキュメントがnilだったらエラーをスローして終了
                guard let documentSnapshot else {
                    continuation.resume(returning: "アカウントが存在しません")
                    return
                }
                // ドキュメントに登録されたnameを取得
                let name = documentSnapshot.get(FieldPathName.name.rawValue) as! String
                // 取得した値を返却
                continuation.resume(returning: name)
            }
        }
    }

    /// 共有者を更新するメソッド
    /// - 主に削除に使用
    /// - 削除する登録者を抜いた配列を引数のshardUsersに代入
    internal func upData(uid documentID: String?, shardUsers: [String]) async throws {
        guard let documentID else { return }
        try await db.collection(CollectionPathName.users.rawValue).document(documentID).updateData([FieldPathName.sharedUsers.rawValue: shardUsers])
    }

    // 共有者を追加するメソッド
    internal func addSharedUsers(inputUid: String, uid: String) async throws {
        let userRef = db.collection(CollectionPathName.users.rawValue)
        let inputUserQuery = userRef.whereField(FieldPath.documentID(), isEqualTo: inputUid)
        let querySnapshot = try await inputUserQuery.getDocuments()
        if querySnapshot.isEmpty {
            throw FirestoreError.notFound
        }
        let document = userRef.document(uid)
        try await document.updateData([FieldPathName.sharedUsers.rawValue: FieldValue.arrayUnion([inputUid])])
    }
}
// MARK: - shoppingItem関連
extension FirestoreManager {

    /// 自分が作成した買い物リストへの変更を監視する
    internal func getMyShoppingItemObserver(listener: inout ListenerRegistration?, uid: String,
                                            completion: @escaping ([ShoppingItemModel]) -> Void) {
        // 自分が作成した買い物商品のリスナーをセット
        listener = db.collection(CollectionPathName.shoppingItem.rawValue).whereField(FieldPathName.owner.rawValue, isEqualTo: uid)
            .addSnapshotListener { (querySnapshot, error) in
                guard  let querySnapshot else { return }
                // データをShoppingItemModelにマッピング
                let myShoppingItemList = querySnapshot.documents.map{ item -> ShoppingItemModel in
                    let data = item.data()
                    return ShoppingItemModel(id: item.documentID,
                                             isCheckBox: data[FieldPathName.isCheckBox.rawValue] as? Bool ?? false,
                                             nameOfItem: data[FieldPathName.nameOfItem.rawValue] as? String ?? "",
                                             numberOfItem: data[FieldPathName.numberOfItem.rawValue] as? String ?? "",
                                             unit: data[FieldPathName.unit.rawValue] as? String ?? "",
                                             salesFloorRawValue: data[FieldPathName.salesFloorRawValue.rawValue] as? Int ?? 1,
                                             supplement: data[FieldPathName.supplement.rawValue] as? String ?? "",
                                             photoURL: data[FieldPathName.photoURL.rawValue] as? String ?? "",
                                             owner: data[FieldPathName.owner.rawValue] as? String ?? "",
                                             sharedUsers: data[FieldPathName.sharedUsers.rawValue] as? [String] ?? [])
                }
                completion(myShoppingItemList)
            }
    }

    /// 共有者が作成した買い物リストへの変更を監視する
    internal func getOtherShoppingItemObserver(listener: inout ListenerRegistration?,
                                               uid: String,
                                               completion: @escaping ([ShoppingItemModel]) -> Void) {
        // 自分が作成した買い物商品のリスナーをセット
        listener = db.collection(CollectionPathName.shoppingItem.rawValue).whereField(FieldPathName.sharedUsers.rawValue, arrayContains: uid)
            .addSnapshotListener { (querySnapshot, error) in
                guard  let querySnapshot else { return }
                // データをShoppingItemModelにマッピング
                let myShoppingItemList = querySnapshot.documents.map{ item -> ShoppingItemModel in
                    let data = item.data()
                    return ShoppingItemModel(id: item.documentID,
                                             isCheckBox: data[FieldPathName.isCheckBox.rawValue] as? Bool ?? false,
                                             nameOfItem: data[FieldPathName.nameOfItem.rawValue] as? String ?? "",
                                             numberOfItem: data[FieldPathName.numberOfItem.rawValue] as? String ?? "",
                                             unit: data[FieldPathName.unit.rawValue] as? String ?? "",
                                             salesFloorRawValue: data[FieldPathName.salesFloorRawValue.rawValue] as? Int ?? 1,
                                             supplement: data[FieldPathName.supplement.rawValue] as? String ?? "",
                                             photoURL: data[FieldPathName.photoURL.rawValue] as? String ?? "",
                                             owner: data[FieldPathName.owner.rawValue] as? String ?? "",
                                             sharedUsers: data[FieldPathName.sharedUsers.rawValue] as? [String] ?? [])
                }
                completion(myShoppingItemList)
            }
    }

    /// 自分が作成した買い物リストへの変更を監視するsalesFloorShoppingListView専用
    internal func getMyShoppingItemObserverSearchSalesFloor(uid: String,
                                                            salesFloorRawValue: Int,
                                                            completion: @escaping ([ShoppingItemModel]) -> Void) {
        // 自分が作成した買い物商品のリスナーをセット
        salesFloorShoppingListMyItemListener = db.collection(CollectionPathName.shoppingItem.rawValue)
            .whereField(FieldPathName.sharedUsers.rawValue, arrayContains: uid)
            .whereField(FieldPathName.salesFloorRawValue.rawValue, isEqualTo: salesFloorRawValue)
            .addSnapshotListener { (querySnapshot, error) in
                guard  let querySnapshot else { return }
                // データをShoppingItemModelにマッピング
                let myShoppingItemList = querySnapshot.documents.map{ item -> ShoppingItemModel in
                    let data = item.data()
                    return ShoppingItemModel(id: item.documentID,
                                             isCheckBox: data[FieldPathName.isCheckBox.rawValue] as? Bool ?? false,
                                             nameOfItem: data[FieldPathName.nameOfItem.rawValue] as? String ?? "",
                                             numberOfItem: data[FieldPathName.numberOfItem.rawValue] as? String ?? "",
                                             unit: data[FieldPathName.unit.rawValue] as? String ?? "",
                                             salesFloorRawValue: data[FieldPathName.salesFloorRawValue.rawValue] as? Int ?? 1,
                                             supplement: data[FieldPathName.supplement.rawValue] as? String ?? "",
                                             photoURL: data[FieldPathName.photoURL.rawValue] as? String ?? "",
                                             owner: data[FieldPathName.owner.rawValue] as? String ?? "",
                                             sharedUsers: data[FieldPathName.sharedUsers.rawValue] as? [String] ?? [])
                }
                completion(myShoppingItemList)
            }
    }

    /// 共有者が作成した買い物リストへの変更を監視するsalesFloorShoppingListView専用
    internal func getOtherShoppingItemObserverSearchSalesFloor(uid: String,
                                                            salesFloorRawValue: Int,
                                                            completion: @escaping ([ShoppingItemModel]) -> Void) {
        // 自分が作成した買い物商品のリスナーをセット
        salesFloorShoppingListOtherItemListener = db.collection(CollectionPathName.shoppingItem.rawValue)
            .whereField(FieldPathName.owner.rawValue, isEqualTo: uid)
            .whereField(FieldPathName.salesFloorRawValue.rawValue, isEqualTo: salesFloorRawValue)
            .addSnapshotListener { (querySnapshot, error) in
                guard  let querySnapshot else { return }
                // データをShoppingItemModelにマッピング
                let otherShoppingItemList = querySnapshot.documents.map{ item -> ShoppingItemModel in
                    let data = item.data()
                    return ShoppingItemModel(id: item.documentID,
                                             isCheckBox: data[FieldPathName.isCheckBox.rawValue] as? Bool ?? false,
                                             nameOfItem: data[FieldPathName.nameOfItem.rawValue] as? String ?? "",
                                             numberOfItem: data[FieldPathName.numberOfItem.rawValue] as? String ?? "",
                                             unit: data[FieldPathName.unit.rawValue] as? String ?? "",
                                             salesFloorRawValue: data[FieldPathName.salesFloorRawValue.rawValue] as? Int ?? 1,
                                             supplement: data[FieldPathName.supplement.rawValue] as? String ?? "",
                                             photoURL: data[FieldPathName.photoURL.rawValue] as? String ?? "",
                                             owner: data[FieldPathName.owner.rawValue] as? String ?? "",
                                             sharedUsers: data[FieldPathName.sharedUsers.rawValue] as? [String] ?? [])
                }
                completion(otherShoppingItemList)
            }
    }

    /// 自分の買い物リストの監視を解除
    internal func removeShoppingItemObserver(listener: inout ListenerRegistration?) {
        listener?.remove()
    }

    /// 新規作成した買い物の商品を保存
    internal func addItem(uid: String, addItem: ShoppingItemModel) {
        db.collection(CollectionPathName.shoppingItem.rawValue).addDocument(data: [
            FieldPathName.isCheckBox.rawValue: addItem.isCheckBox ,
            FieldPathName.nameOfItem.rawValue: addItem.nameOfItem ,
            FieldPathName.numberOfItem.rawValue: addItem.numberOfItem ,
            FieldPathName.unit.rawValue:addItem.unit ,
            FieldPathName.salesFloorRawValue.rawValue: addItem.salesFloorRawValue ,
            FieldPathName.supplement.rawValue: addItem.supplement ,
            FieldPathName.photoURL.rawValue: addItem.photoURL ,
            FieldPathName.owner.rawValue: addItem.owner,
            FieldPathName.sharedUsers.rawValue: addItem.sharedUsers,
            FieldPathName.date.rawValue: Date()])
        { err in
            if err != nil {
                print("Firestoreへの保存に失敗")
            } else {
                print("Firestoreへの保存に成功")
            }
        }
    }

    /// 編集した買い物商品を保存
    internal func upDateItem(addItem: ShoppingItemModel) {
        guard let id = addItem.id else { return }
        db.collection(CollectionPathName.shoppingItem.rawValue).document(id).updateData([
            FieldPathName.isCheckBox.rawValue: addItem.isCheckBox ,
            FieldPathName.nameOfItem.rawValue: addItem.nameOfItem ,
            FieldPathName.numberOfItem.rawValue: addItem.numberOfItem ,
            FieldPathName.unit.rawValue:addItem.unit ,
            FieldPathName.salesFloorRawValue.rawValue: addItem.salesFloorRawValue ,
            FieldPathName.supplement.rawValue: addItem.supplement ,
            FieldPathName.photoURL.rawValue: addItem.photoURL ,
            FieldPathName.date.rawValue: Date()])
        { err in
            if err != nil {
                print("Firestoreへの保存に失敗")
            } else {
                print("Firestoreへの保存に成功")
            }
        }
    }

    /// 買い物商品のisCheckBoxにチェックを入れた時に書き込む処理
    internal func upDateItemForIsChecked(documentID: String?, isChecked: Bool) async throws {
        guard let documentID else { return }
        try await db.collection(CollectionPathName.shoppingItem.rawValue).document(documentID).updateData([
            FieldPathName.isCheckBox.rawValue: isChecked])
    }

    /// 既存の買い物商品のsharedUsersフィールドに共有者を追加で設定する
    internal func upDateItemForSharedUsers(documentID: String?, sharedUsersUid: [String]) async throws {
        guard let documentID else { return }
        try await db.collection(CollectionPathName.shoppingItem.rawValue).document(documentID).updateData([
            FieldPathName.sharedUsers.rawValue: sharedUsersUid])
    }

    // ドキュメントを削除する
    internal func deleteItem(id: String, completion: @escaping (Error?) -> ()) {
        db.collection(CollectionPathName.shoppingItem.rawValue).document(id).delete() { error in
            if let error {
                print("削除に失敗: \(error)")
                completion(error)
            } else {
                print("削除成功")
                completion(nil)
            }
        }
    }

    /// 自分の作成した買い物リストを取得して返却する
    internal func getMyShoppingItemList(uid: String) async throws -> [ShoppingItemModel]{
        let collectionRef = db.collection(CollectionPathName.shoppingItem.rawValue)
        let querySnapshot = try await collectionRef.whereField(FieldPathName.owner.rawValue, isEqualTo: uid).getDocuments()
        let itemList = querySnapshot.documents.compactMap { document in
            try? document.data(as: ShoppingItemModel.self)
        }
        return itemList
    }

    /// 自分を共有設定して作った買い物リストを取得して返却する
    internal func getOtherShoppingItemList(uid: String) async throws -> [ShoppingItemModel]{
        let collectionRef = db.collection(CollectionPathName.shoppingItem.rawValue)
        let querySnapshot = try await collectionRef.whereField(FieldPathName.sharedUsers.rawValue, arrayContains: uid).getDocuments()
        let itemList = querySnapshot.documents.compactMap { document in
            try? document.data(as: ShoppingItemModel.self)
        }
        return itemList
    }
}
