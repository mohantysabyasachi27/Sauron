//
//  User.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import Foundation

class User{
    let firstName: String
    let lastName: String
    let emailId: String
    let mobile: String
//    let auth: String
    
    init(firstName: String, lastName: String, emailId: String, mobile: String){//}, auth: String){
        self.firstName = firstName
        self.lastName = lastName
        self.emailId = emailId
        self.mobile = mobile
//        self.auth = auth
    }
    
    init?(data: Any?) {
        if let user = data as? [String:String]{
            self.firstName = user["firstName"] ?? ""
            self.lastName = user["lastName"] ?? ""
            self.emailId = user["emailId"] ?? ""
            self.mobile = user["mobile"] ?? ""
//            self.auth = auth
        } else {
            return nil
        }
        
        
    }
}
