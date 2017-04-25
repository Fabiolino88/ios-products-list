//
//  ProductAttribute.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import Foundation
import CoreData

class ProductAttribute: NSManagedObject {
    
    class func findOrCreateProductAttributes(matching attributes: [ProductAttributeModel], with context: NSManagedObjectContext) throws -> Set<ProductAttribute> {
        
        var newSetOfAttributes = Set<ProductAttribute>()
        
        for attribute in attributes {
        
            let request : NSFetchRequest<ProductAttribute> = ProductAttribute.fetchRequest()
            
            let attributeIdPredicate = NSPredicate(format: "attributeId = %@", attribute.attributeId!)
            let productIdPredicate = NSPredicate(format: "productId = %@", attribute.productId!)
            
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [attributeIdPredicate, productIdPredicate])
            
            do {
                
                let matches = try context.fetch(request)
                if matches.count == 1 {
                    newSetOfAttributes.insert(updateProductAttribute(withAttribute: matches[0], fromModel: attribute, withContext: context))
                    continue
                }
            } catch {
                throw error
            }
            
            let newAttribute = retrieveNewProductAttribute(fromModel: attribute, withContext: context)
            newSetOfAttributes.insert(newAttribute)
        }
        
        return newSetOfAttributes   
    }
    
    class func updateProductAttribute(withAttribute currentAttribute: ProductAttribute, fromModel newAttribute: ProductAttributeModel, withContext context: NSManagedObjectContext) -> ProductAttribute {
        
        currentAttribute.attributeId = newAttribute.attributeId
        currentAttribute.productId = newAttribute.productId
        currentAttribute.title = newAttribute.title
        currentAttribute.unit = newAttribute.unit
        currentAttribute.value = newAttribute.value
        
        return currentAttribute
    }
    
    class func retrieveNewProductAttribute(fromModel attribute: ProductAttributeModel, withContext context: NSManagedObjectContext) -> ProductAttribute {
        
        let newAttribute = ProductAttribute(context: context)
        newAttribute.attributeId = attribute.attributeId
        newAttribute.productId = attribute.productId
        newAttribute.title = attribute.title
        newAttribute.unit = attribute.unit
        newAttribute.value = attribute.value
        
        return newAttribute
    }
    
}
