//
//  Authentication.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import Foundation
import Alamofire

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
    
    var email: String? {
        return UserDefaults.standard.object(forKey: "email") as? String
    }
    
//    var user: [String:Any]? {
//        if isLoggedIn == true {
//            return UserDefaults.standard.object(forKey: "UserDetails") as! [String : Any]
//        }
//        return nil
//    }
    
    var categories: [Category] = []
    var isProfileFetched = false
    
    var allTickets:[Ticket] = []
    var pendingTickets:[Ticket] = []
    var approvedTickets:[Ticket] = []
    var rejectedTickets:[Ticket] = []
    
    func logout() {
        self.isLoggedIn = false
    }
    
    func fetchCategories() {
        Alamofire.request(Constants.categories, method: .get).responseJSON { (data) in
            if let response = data.result.value as? [Any]{
                self.categories = response.map({ (val) -> Category in
                    return Category(val)!
                })
            }
        }
    }
    
    func fetchTickets(completion: @escaping () -> ()) {
        guard isLoggedIn == true else {
            completion()
            return
        }
        Alamofire.request(Constants.ticketStatus, method: .get).responseJSON { (data) in
            if let response = data.result.value as? [Any]{
                print(response)

                self.allTickets = response.compactMap({ (val) -> Ticket in
                    return Ticket(val)!
                })
                self.pendingTickets = self.allTickets.filter({ (tick) -> Bool in
                    return tick.status == 2
                })
                self.approvedTickets = self.allTickets.filter({ (tick) -> Bool in
                    return tick.status == 1
                })
                self.rejectedTickets = self.allTickets.filter({ (tick) -> Bool in
                    return tick.status == 0
                })
                completion()
            }
            completion()
        }
    }
    
    var profile: User?
    
    func fetchUserProfile(completion: @escaping () -> ()) {
        guard isLoggedIn == true else {
            completion()
            return
        }
        
        Alamofire.request(Constants.profile, method: .get).responseJSON { (data) in
            if let response = data.result.value {
                print(response)
                self.profile = User(data: response)
//                UserDefaults.standard.set(response, forKey: "UserDetails")
                self.isProfileFetched = true
                completion()
            }
            completion()
        }
    }
}
