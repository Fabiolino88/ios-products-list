//
//  ProductListViewModel.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

protocol ProductListViewModelDelegate : class {
    
    //Method called on online content and database fetch finish
    func onDatabaseFetchFinish()
    
    //Method called on finish fetch category list
    func onCategoryListRetrieved(_ categoryList: [Category])
    
}

class ProductListViewModel  {
    
    //Getting db container from AppDelegate
    var dbContainer : NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    //Delegate
    weak var delegate : ProductListViewModelDelegate?
    
    //GoustoApi
    fileprivate let goustoApi = GoustoApi()
    
    //Initialize the db on controller ready
    func initializeDbContent() {
        let connectionStatus = ConnectionStatus()
        
        switch  connectionStatus.currentReachabilityStatus {
            case .notReachable:
                self.delegate?.onDatabaseFetchFinish()
            
            case .reachableViaWiFi, .reachableViaWWAN:
                getAndStoreApiContent()
        }
        
    }
    
    //Get full list of categories
    func getCategoryList() {
        if let context = self.dbContainer?.viewContext {
            context.perform {
                let request : NSFetchRequest<Category> = Category.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
                do {
                    let categoriesMatches = try context.fetch(request)
                    self.delegate?.onCategoryListRetrieved(categoriesMatches)
                } catch {
                    //TODO: handle the error
                }
            }
        }
    }
    
    /*
     * Start getting the categories and save them into the db
     */
    func getAndStoreApiContent() {
        goustoApi.getCategoriesList { [weak self] (jsonResponse) in
            self?.dbContainer?.performBackgroundTask({ [weak self] (context) in
                
                let categoriesList = jsonResponse["data"]
                for (_, jsonCategory):(String, JSON) in categoriesList {
                    
                    let newCategory = CategoryModel(withJsonObject: jsonCategory)
                    _ = try? Category.findOrCreateCategory(matching: newCategory, with: context)
                }
                
                try? context.save()
                
                //On Category finish call the product list
                self?.getAndStoreProductList()
            })
        }
    }
    
    /*
     * Getting the full product list and save into db
     */
    private func getAndStoreProductList() {
        
        goustoApi.getFullList { [weak self] (jsonObj) in
            self?.dbContainer?.performBackgroundTask({ [weak self] (context) in
                
                let newData = jsonObj["data"]
                for (_, subJson):(String, JSON) in newData {
                    
                    //new product
                    var newProduct = ProductModel(withJsonObject: subJson)
                    let productId = newProduct.productId
                    
                    //Get product categories
                    var categoriesSet = [CategoryModel]()
                    let categories = subJson["categories"]
                    for (_, subJsonArray):(String, JSON) in categories {
                        let newCategory = CategoryModel(withJsonObject: subJsonArray)
                        categoriesSet.append(newCategory)
                    }
                    newProduct.categories = categoriesSet
                    
                    //Get product attributes
                    var attributesSet = [ProductAttributeModel]()
                    let attributes = subJson["attributes"]
                    for (_, subJsonArray):(String, JSON) in attributes {
                        let newAttribute = ProductAttributeModel(withJsonObject: subJsonArray, andProductId: productId!)
                        attributesSet.append(newAttribute)
                    }
                    newProduct.attributes = attributesSet
                    
                    //Store the new product in db
                    _ = try? Product.findOrCreateProduct(matching: newProduct, with: context)
                }
                
                
                try? context.save()
                
                //On finish fir the onDatabaseFetchFinish in the protocol
                self?.delegate?.onDatabaseFetchFinish()
            })
            
        }
        
    }

    
}
