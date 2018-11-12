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
    var totalPoints: Double = 0.0
//    let auth: String
    
    init(firstName: String, lastName: String, emailId: String, mobile: String){//}, auth: String){
        self.firstName = firstName
        self.lastName = lastName
        self.emailId = emailId
        self.mobile = mobile
//        self.auth = auth
    }
    
    init?(data: Any?) {
        if let user = data as? [String:Any]{
            self.firstName = user["firstName"] as? String ?? "No"
            self.lastName = user["lastName"] as? String ?? "Name"
            self.emailId = user["emailId"] as? String ?? ""
            self.mobile = user["mobile"] as? String ?? ""
            self.totalPoints = user["totalPoints"] as? Double ?? 0.0
//            self.auth = auth
        } else {
            return nil
        }
        
        
    }
}
