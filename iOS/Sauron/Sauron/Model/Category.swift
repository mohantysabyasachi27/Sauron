//
//  Category.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import Foundation

struct Category {
    let categoryTitle: String
    let categoryId: Int
    let points: Int
    
    init?(_ json: Any) {
        guard let data = json as? [String:Any] else {
            return nil
        }
        if let categoryTitle = data["categoryTitle"] as? String, let categoryId = data["categoryId"] as? Int, let points = data["points"] as? Int{
            self.categoryTitle = categoryTitle
            self.categoryId = categoryId
            self.points = points
        } else {
            return nil
        }
    }
}
