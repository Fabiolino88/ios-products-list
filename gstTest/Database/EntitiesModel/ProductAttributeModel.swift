//
//  ProductAttributeModel.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ProductAttributeModel {
    
    var attributeId : String?
    var productId : String?
    var title : String?
    var unit : String?
    var value : String?
    
    init(withJsonObject jsonObj: JSON, andProductId prodId: String) {
        attributeId = jsonObj["id"].string
        productId = prodId
        title = jsonObj["title"].string
        unit = jsonObj["unit"] != JSON.null ? jsonObj["unit"].string : ""
        value = jsonObj["value"].string
    }
    
}
