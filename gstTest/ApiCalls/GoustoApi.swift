//
//  GoustoApi.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import Foundation
import SwiftyJSON

class GoustoApi {
    
    private struct goustoEndpoints {
        private static let productsUrl = "https://api.gousto.co.uk/products/v2.0/products"
        private static let categoriesUrl = "https://api.gousto.co.uk/products/v2.0/categories"
        private static let fullListUrl = "https://api.gousto.co.uk/products/v2.0/products?includes%5B%5D=categories&includes%5B%5D=attributes&image_sizes%5B%5D={IMAGE_SIZE}"
        
        static func getProductsUrl() -> String {
            return productsUrl
        }
        
        static func getCategoriesUrl() -> String {
            return categoriesUrl
        }
        
        static func getFullListUrl(withImageWidthSize imageWidth: String) ->String {
            return fullListUrl.replacingOccurrences(of: "{IMAGE_SIZE}", with: imageWidth)
        }
    }
    
    
    func getPoductsList(complitionHandler completion: @escaping (JSON) -> ()) {
        let urlRequest = URL(string: goustoEndpoints.getProductsUrl())
        URLSession.shared.dataTask(with: urlRequest!, completionHandler: { (data, response, error) in
            if error == nil, let dataResult = data {
                let jsonObj = JSON(dataResult)
                completion(jsonObj)
            } else {
                completion(JSON.null)
            }
        }).resume()
    }
    
    
    func getCategoriesList(complitionHandler completion: @escaping (JSON) -> ()) {
        let urlRequest = URL(string: goustoEndpoints.getCategoriesUrl())
        
        URLSession.shared.dataTask(with: urlRequest!, completionHandler: { (data, response, error) in
            if error == nil, let dataResult = data {
                let jsonObj = JSON(dataResult)
                completion(jsonObj)
            } else {
                completion(JSON.null)
            }
        }).resume()
    }
    
    func getFullList(complitionHandler completion: @escaping (JSON) -> ()) {
        let screenWidth = String(describing: Int(UIScreen.main.bounds.size.width * UIScreen.main.scale))
        let url = goustoEndpoints.getFullListUrl(withImageWidthSize: screenWidth)
        let urlRequest = URL(string: url)
        
        URLSession.shared.dataTask(with: urlRequest!, completionHandler: { (data, response, error) in
            if error == nil, let dataResult = data {
                let jsonObj = JSON(dataResult)
                completion(jsonObj)
            } else {
                completion(JSON.null)
            }
        }).resume()
    }
}
