//
//  Authentication.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import Foundation

class Authentication {
    
    static let shared: Authentication = Authentication()
    
    private init(){}
    
    var isLoggedIn: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
        }
    }
    
    var user: User? {
        return User(data: UserDefaults.standard.object(forKey: "UserDetails"))
    }
    
    func logout() {
        self.isLoggedIn = false
    }
}
