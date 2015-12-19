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
    var id: Int?
    var profileImageUrl: String
    var url: String?
    var location: String?
    
    init(name: String, profileImageUrl: String, location: String?) {
        self.name = name
        self.profileImageUrl = profileImageUrl
        self.location = location
    }
}