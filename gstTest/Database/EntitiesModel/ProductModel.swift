//
//  ProductModel.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
 * ProductModel
 * is in charge to retrieve all the values
 * from the json object coming from the api call
 */
struct ProductModel {
    
    var productId : String?
    var sku : String?
    var title : String?
    var productDescription : String?
    var listPrice : String?
    var isVatable : Bool?
    var isForSale : Bool?
    var ageRestricted : Bool?
    var boxLimit : Int16?
    var alwaisOnMenu : Bool?
    var createdAt : String?
    var imageUrl : String?
    var categories = [CategoryModel]()
    var attributes = [ProductAttributeModel]()
    
    init(withJsonObject jsonObj : JSON) {
        productId = jsonObj["id"].string
        sku = jsonObj["sku"].string
        title = jsonObj["title"].string
        productDescription = jsonObj["description"].string
        listPrice = jsonObj["list_price"].string
        isVatable = jsonObj["is_vatable"].bool!
        isForSale = jsonObj["is_for_sale"].bool!
        ageRestricted = jsonObj["age_restricted"].bool!
        boxLimit = jsonObj["box_limit"] != JSON.null ? Int16(jsonObj["box_limit"].string!) : 0
        alwaisOnMenu = jsonObj["always_on_menu"].bool!
        createdAt = jsonObj["created_at"].string
        
        //Getting the image Url:
        let screenWidth = String(describing: Int(UIScreen.main.bounds.size.width * UIScreen.main.scale))
        
        if jsonObj["images"][screenWidth] != JSON.null {
            imageUrl = jsonObj["images"][screenWidth]["url"].string
        } else {
            imageUrl = nil
        }
        
    }
    
}
