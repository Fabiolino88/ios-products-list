//
//  ProductImageCell.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductImageCell: UITableViewCell {

    //Cell Identifier
    static let cellIdentifier = "ProductImageCellID"
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var backgroundImage : UIImage? {
        didSet{ setBackgroundImage() }
    }
    
    func setBackgroundImage() {
        
        if backgroundImage != nil {
            backgroundImageView.image = backgroundImage
            backgroundImageView.contentMode = .scaleAspectFill
            imageView?.autoresizingMask = .flexibleTopMargin
        } else {
            backgroundImageView.image = nil
        }
        
    }
    
    override func prepareForReuse() {
        backgroundImageView.image = nil
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
