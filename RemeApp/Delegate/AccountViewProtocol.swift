//
//  AccountViewProtocol.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/28.
//

import Foundation

protocol CreateAccountViewControllerDelegate: AnyObject {
    func updateUserInfoFromCreateAccountView() async
}

protocol SignInViewControllerDelegate: AnyObject {
    func updateUserInfoFromSignInView() async
}
