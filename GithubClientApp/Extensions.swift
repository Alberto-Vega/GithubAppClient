//
//  Regex.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/15/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

extension String {
    
    static func validateInput(input: String) -> Bool {
        let searchFieldRegExPattern = "[0-9a-zA-Z_]"
        do {
            let regex = try NSRegularExpression(pattern: searchFieldRegExPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.numberOfMatchesInString(input, options: NSMatchingOptions.ReportCompletion, range: NSRange.init(location: 0, length: input.characters.count))
            if matches == input.characters.count {
                return true
            } else {
                return false
            }
        } catch { return false }
    }
}