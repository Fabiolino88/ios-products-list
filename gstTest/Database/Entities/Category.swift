//
//  Category.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {
    
    //For single category
    class func findOrCreateCategory(matching category: CategoryModel, with context: NSManagedObjectContext) throws -> Category {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "categoryId = %@", category.categoryId!)
        
        do {
            let matches = try context.fetch(request)
            if matches.count == 1 {
                return updateNewCategory(withCategory: matches[0], andNewCategory: category, withContext: context)
            }
        } catch {
            throw error
        }
        
        let newCategory = retrieveNewCategory(fromModel: category, withContext: context)
        return newCategory
    }
    
    //For Array of category from the product
    class func findOrCreateCategories(matching categories: [CategoryModel], in context: NSManagedObjectContext) throws -> Set<Category> {
        
        var newSetOfCategories = Set<Category>()
        
        for category in categories {
            
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            request.predicate = NSPredicate(format: "categoryId = %@", category.categoryId!)
            
            do {
                let matches = try context.fetch(request)
                if matches.count == 1 {
                    newSetOfCategories.insert(updateNewCategory(withCategory: matches[0], andNewCategory: category, withContext: context))
                    continue
                }
            } catch {
                throw error
            }
            
            let newCategory = retrieveNewCategory(fromModel: category, withContext: context)
            newSetOfCategories.insert(newCategory)
        }
        
        return newSetOfCategories
        
    }
    
    class func retrieveNewCategory(fromModel category: CategoryModel, withContext context: NSManagedObjectContext) -> Category {
        let newCategory = Category(context: context)
        newCategory.categoryId = category.categoryId
        newCategory.title = category.title
        newCategory.boxLimit = category.boxLimit!
        newCategory.isDefault = category.isDefault!
        newCategory.recentlyAdded = category.recentlyAdded!
        newCategory.hidden = category.hidden!
        newCategory.createdAt = category.createdAt
        
        return newCategory
    }
    
    class func updateNewCategory(withCategory currentCategory: Category, andNewCategory newCategory: CategoryModel, withContext context: NSManagedObjectContext) -> Category {
        
        currentCategory.categoryId = newCategory.categoryId
        currentCategory.title = newCategory.title
        currentCategory.boxLimit = newCategory.boxLimit!
        currentCategory.isDefault = newCategory.isDefault!
        currentCategory.recentlyAdded = newCategory.recentlyAdded!
        currentCategory.hidden = newCategory.hidden!
        currentCategory.createdAt = newCategory.createdAt
        
        return currentCategory
    }
    
}
