//
//  Animation.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/15/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class Animation {
    
    class func expandImage(imageView: UIImageView) {
        imageView.clipsToBounds = true
        imageView.transform = CGAffineTransformScale(imageView.transform, 5.2, 5.2)
    }
    
    class func animateImageRotatingZoomIn(imageView: UIImageView) {
        //             Example of rotating view 45 degrees clockwise.
        for _ in 0...7 {
            UIView.animateWithDuration(1.0) { () -> Void in
                imageView.transform = CGAffineTransformRotate(imageView.transform, CGFloat(M_PI * 45 / 180.0))
                imageView.transform = CGAffineTransformScale(imageView.transform, 0.82, 0.82)
            }
        }
    }
}
