//
//  Product.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import Foundation
import CoreData

class Product: NSManagedObject {
    
    class func findOrCreateProduct(matching product: ProductModel, with context: NSManagedObjectContext) throws -> Product {
        
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(format: "productId = %@", product.productId!)
        
        do {
            let matches = try context.fetch(request)
            if matches.count == 1 {
                //There is no update date or timestamp in the object
                //to understand if the object has changed or not
                //Unlsess is not the created_at
                //So i'm updating the object anyway with the new coming from the api
                return self.updateNewProduct(withCurrentProduct: matches[0], fromModel: product, withContext: context)
            }
        } catch {
            throw error
        }
        
        let newProduct = self.retrieveNewProduct(fromModel: product, withContext: context)
        return newProduct
    }
    
    class func updateNewProduct(withCurrentProduct currentProduct : Product, fromModel newProduct : ProductModel, withContext context: NSManagedObjectContext) -> Product {
        
        currentProduct.productId = newProduct.productId
        currentProduct.sku = newProduct.sku
        currentProduct.title = newProduct.title
        currentProduct.productDescription = newProduct.productDescription
        currentProduct.listPrice = newProduct.listPrice
        currentProduct.isVatable = newProduct.isVatable!
        currentProduct.isForSale = newProduct.isForSale!
        currentProduct.ageRestricted = newProduct.ageRestricted!
        currentProduct.boxLimit = newProduct.boxLimit!
        currentProduct.alwaisOnMenu = newProduct.alwaisOnMenu!
        currentProduct.imageUrl = newProduct.imageUrl
        currentProduct.createdAt = newProduct.createdAt
        
        currentProduct.categories = try? Category.findOrCreateCategories(matching: newProduct.categories, in: context) as NSSet
        
        currentProduct.productAttributes = try? ProductAttribute.findOrCreateProductAttributes(matching: newProduct.attributes, with: context) as NSSet
        
        return currentProduct
    }
    
    class func retrieveNewProduct(fromModel product : ProductModel, withContext context: NSManagedObjectContext) -> Product {
        let newProduct = Product(context: context)
        newProduct.productId = product.productId
        newProduct.sku = product.sku
        newProduct.title = product.title
        newProduct.productDescription = product.productDescription
        newProduct.listPrice = product.listPrice
        newProduct.isVatable = product.isVatable!
        newProduct.isForSale = product.isForSale!
        newProduct.ageRestricted = product.ageRestricted!
        newProduct.boxLimit = product.boxLimit!
        newProduct.alwaisOnMenu = product.alwaisOnMenu!
        newProduct.imageUrl = product.imageUrl
        newProduct.createdAt = product.createdAt
        
        newProduct.categories = try? Category.findOrCreateCategories(matching: product.categories, in: context) as NSSet
        
        newProduct.productAttributes = try? ProductAttribute.findOrCreateProductAttributes(matching: product.attributes, with: context) as NSSet
        
        return newProduct
    }
    
}
