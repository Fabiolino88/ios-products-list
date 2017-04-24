//
//  ProductCell.swift
//  gstTest
//
//  Created by Fabio Santoro on 23/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductCell: UITableViewCell {

    static let cellIdentifier = "ProductCellID"
    
    //outlet UI
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var cellInfo : Product? {
        didSet {
            setCellLayout()
        }
    }
    
    func setCellLayout() {
        
        guard let info = cellInfo else {
            prepareForReuse()
            return
        }
        
        //Background Image with alamofireimage
        if let imageUrl = info.imageUrl, let url = URL(string: imageUrl) {
            backgroundImageView?.af_setImage(withURL: url)
        } else {
            backgroundImageView?.image = nil
        }
        
        //Set title label
        if let title = info.title {
            titleLabel.text = title.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        //Set price label
        if let price = info.listPrice {
            priceLabel.text = "£" + price.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
    
    //Preparing the cell for reuse
    override func prepareForReuse() {
        
        //Cancel the image request form alamofire is still running
        backgroundImageView.af_cancelImageRequest()
        
        //Reset ui
        backgroundImageView.image = nil
        titleLabel.text = ""
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
