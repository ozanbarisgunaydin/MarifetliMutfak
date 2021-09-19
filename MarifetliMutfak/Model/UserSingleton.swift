//
//  UserSingleton.swift
//  MarifetliMutfak
//
//  Created by Ozan Barış Günaydın on 11.09.2021.
//

import Foundation
import Firebase

class UserSingleton {

    static let sharedUserInfo = UserSingleton()
    var email = Auth.auth().currentUser?.email
    private init() {

    }
}
