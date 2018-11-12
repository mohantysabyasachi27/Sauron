//
//  Tickets.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/11/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import Foundation
import UIKit

enum TicketStatus: Int{
    case rejected = 0
    case approved
    case pending
    
    func getButtonImage()->UIImage {
        switch self {
        case .rejected:
            return UIImage(named: "noSeatError")!
        case .approved:
            return UIImage(named: "icgreenTickWC")!
        case .pending:
            return UIImage(named: "info_dark_gray")!
        }
    }
    
    init?(id: Int){
        switch id {
        case 0:
            self = .rejected
        case 1:
            self = .approved
        case 2:
            self = .pending
        default:
            self = .pending
        }
    }
}


struct Ticket {
    let ticketId: String
    let date: String
    let isVideo: Bool
    let link: String?
    let status: Int
    
    init?(_ json: Any) {
        guard let data = json as? [String:Any] else { return nil}
        
        if let ticketId = data["ticketId"] as? String, let date = data["date"] as? String, let isVideo = data["isVideo"] as? Bool,  let status = data["status"] as? Int {
            self.ticketId = ticketId
            self.date = date
            self.isVideo = isVideo
            self.status = status
        } else {
            return nil
        }
        
        self.link = data["link"] as? String
        
    }
}
