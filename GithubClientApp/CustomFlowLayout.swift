//
//  CustomFlowLayout.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/13/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    init(columns: Int) {
        
        super.init()
        
        let frame = UIScreen.mainScreen().bounds
        let width = CGRectGetWidth(frame)
        
        let sizeWidth = (width / CGFloat(columns)) - 1.0
        
        self.itemSize = CGSize(width: sizeWidth, height: sizeWidth)
        self.minimumInteritemSpacing = 1.0
        self.minimumLineSpacing = 1.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
