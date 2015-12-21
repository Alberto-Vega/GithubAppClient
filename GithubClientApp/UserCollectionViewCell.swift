//
//  UserCollectionViewCell.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/13/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    var user: User! {
        didSet {
            
            NSOperationQueue().addOperationWithBlock { () -> Void in
                
                if let imageUrl = NSURL(string: self.user.profileImageUrl) {
                    guard let imageData = NSData(contentsOfURL: imageUrl) else {return}
                    let image = UIImage(data: imageData)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.imageView.image = image
                    })
                }
            }
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
}
