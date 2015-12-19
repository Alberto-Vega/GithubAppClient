//
//  Repository.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/13/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

class Repository {
    
    let name: String
    let id: Int
    let url: String
    
    init(name: String, id: Int, url: String) {
        self.name = name
        self.id = id
        self.url = url
    }
}
