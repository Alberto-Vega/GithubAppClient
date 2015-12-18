//
//  OAuthClient.swift
//  GoGoGithub
//
//  Created by Alberto Vega Gonzalez on 11/9/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

let kAccessTokenKey = "token"

class OAuthClient {
    
    var token: String?
        {
        
        get {
            
            print("Saved value is: \(KeychainService.loadFromKeychain())")
            
            return KeychainService.loadFromKeychain() as? String
        }
        
        set {
            if let newValue = newValue {
                
                print("New token is: \(newValue)")
                
                KeychainService.save(newValue)
            }
        }
    }
    
    private let kAccessTokenKey = "kAccessTokenKey"
            let kOAuthBaseURLString = "https://github.com/login/oauth/"
    private let kClientId = "405cf0ef46239dcd8971"
    private let kClientSecret = "b4418a2aab61ccf560cff2ab917e53eb9e19bed1"
    
    static let shared = OAuthClient()
    
    func requestGithubAccess() {
        let authURL = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(kClientId)&scope=user,email,repo")!
        UIApplication.sharedApplication().openURL(authURL)
    }
    
    func exchangeCodeInURL(codeURL : NSURL, completion: (success: Bool) -> ()) {
        if let code = codeURL.query {
            let request = NSMutableURLRequest(URL: NSURL(string: "https://github.com/login/oauth/access_token?\(code)&client_id=\(kClientId)&client_secret=\(kClientSecret)")!)
            
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if let _ = response as? NSHTTPURLResponse {
                    
                    if let data = data {
                        do {
                            if let rootObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String : AnyObject] {
                                print(rootObject)
                                print(rootObject["access_token"])
                                
                                if let user = rootObject["access_token"]as? String {
                                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                        OAuthClient.shared.token =  user
                                        completion(success: true)
                                    })
                                }
                            }
                        } catch _ {}
                    }
                }
            }).resume()
        }
    }
}
   