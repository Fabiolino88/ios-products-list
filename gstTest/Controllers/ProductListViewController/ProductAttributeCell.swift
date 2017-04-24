//
//  ProductAttributeCell.swift
//  gstTest
//
//  Created by Fabio Santoro on 24/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import UIKit

class ProductAttributeCell: UITableViewCell {

    //Cell Identifier
    static let cellIdentifier = "ProductAttributeCellID"
    
    @IBOutlet weak var attributeTitleLabel: UILabel!
    @IBOutlet weak var attributeValueLabel: UILabel!
    
    var productAttributeInfo : ProductAttribute? {
        didSet{ updateUI() }
    }

    
    func updateUI() {
        
        //Set tilte
        if let attributeTitle = productAttributeInfo?.title {
            attributeTitleLabel.text = attributeTitle
        }
        
        //Set Value
        if let attributeValue = productAttributeInfo?.value {
            attributeValueLabel.text = attributeValue
        }
        
        //Add unit if exist to value label
        if let attributeUnit = productAttributeInfo?.unit {
            attributeValueLabel.text = attributeValueLabel.text! + " " + attributeUnit
        }
    }
    
    override func prepareForReuse() {
        attributeValueLabel.text = ""
        attributeTitleLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
