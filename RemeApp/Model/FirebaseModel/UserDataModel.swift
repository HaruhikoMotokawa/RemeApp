//
//  UserDataModel.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/09.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserDataModel: Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var password: String
    var sharedUsers = [String]()
    var date = Date()
}
