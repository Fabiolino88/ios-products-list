//
//  ProductDetailsCell.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import UIKit

class ProductDetailsCell: UITableViewCell {

    //Cell Identifier
    static let cellIdentifier = "ProductDetailsCellID"
    
    //Cell Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var title : String? {
        didSet{ setTitleLabelText() }
    }
    
    var productDescription: String? {
        didSet{ setDescriptionLabelText() }
    }
    
    
    func setTitleLabelText() {
        if title != nil {
            titleLabel.text = title?.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
    
    func setDescriptionLabelText() {
        if productDescription != nil {
            descriptionLabel.text = productDescription?.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
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
