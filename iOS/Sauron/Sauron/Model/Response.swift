//
//  Response.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import Foundation

struct Response {
    let statusCode: Int
    let success: Bool
    let errorReason: String?
    
    init?(_ json: Any?) {
        guard let json = json as? [String:Any] else {
            return nil
        }
        if let statusCode = json["statusCode"] as? String, let code = Int(statusCode), let success = json["success"] as? Bool{
            self.statusCode = code
            self.success = success
        } else {
            return nil
        }
        self.errorReason = json["errorReason"] as? String
    }
}
