//
//  User.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/13/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var profileImageUrl: String
    
    init(name: String, profileImageUrl: String) {
        self.name = name
        self.profileImageUrl = profileImageUrl
    }
    
}