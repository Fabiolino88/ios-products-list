//
//  ProductDetailsViewController.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductDetailsViewController: UITableViewController {
    
    //Getting the product details
    var productInfo : Product?
    
    //Getting the backgroundImage
    var backgroundImage : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //No separator between the cells
        self.tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}

/// TableView and DataSource
extension ProductDetailsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let attributeCount = productInfo?.productAttributes?.count {
            return attributeCount + 2
        } else {
            return 2
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0: //BackgroundImage Row
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductImageCell.cellIdentifier, for: indexPath) as? ProductImageCell
            
            cell?.backgroundImage = backgroundImage
            return cell!
            
        case 1: //Details Row
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductDetailsCell.cellIdentifier, for: indexPath) as? ProductDetailsCell
            
            cell?.title = productInfo?.title
            cell?.productDescription = productInfo?.productDescription
            return cell!
            
        default: //Attribute Rows if attributes exist
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductAttributeCell.cellIdentifier, for: indexPath) as? ProductAttributeCell
            
            let attributeIndex = indexPath.row - 2
            let attributesArray = productInfo?.productAttributes?.allObjects
            cell?.productAttributeInfo = attributesArray?[attributeIndex] as? ProductAttribute
            
            return cell!
            
            //Get element from nsset comeon
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: //BackgroundImage row
            return 240.0
        case 1: //Details row
            return 220.0
        default: //Attribute rows
            return 50.0
        }
    }
    
}
