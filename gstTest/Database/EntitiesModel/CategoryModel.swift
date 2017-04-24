//
//  CategoryModel.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CategoryModel {
    
    var categoryId : String?
    var title : String?
    var boxLimit : Int16?
    var isDefault : Bool?
    var recentlyAdded : Bool?
    var hidden : Bool?
    var createdAt : String?
    var products = [ProductModel]()
    
    init(withJsonObject jsonObj: JSON) {
        categoryId = jsonObj["id"].string
        title = jsonObj["title"].string
        boxLimit = jsonObj["box_limit"].int16!
        isDefault = jsonObj["is_default"].bool!
        recentlyAdded = jsonObj["recently_added"].bool!
        hidden = jsonObj["hidden"].bool!
        createdAt = jsonObj["created_at"].string
    }
    
}
