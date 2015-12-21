//
//  OAuthViewController.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/13/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

typealias OAuthViewControllerCompletionHandler = () -> ()

class OAuthViewController: UIViewController {
    
    var oAuthCompletionHandler: OAuthViewControllerCompletionHandler?
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    class func identifier() -> String {
        return "OAuthViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupAppearance() {
        self.loginButton.layer.cornerRadius = 3.0
    }
    
    func processLogin() {
        if let oAuthCompletionHandler = self.oAuthCompletionHandler {
            oAuthCompletionHandler()
        }
    }
    
//    func processOauthRequest() {
//        if let oauthCompletionHandler = self.oauthCompletionHandler {
//            oauthCompletionHandler()
//        }
//    }
    
    @IBAction func loginButtonSelected(sender: UIButton) {
        self.activityIndicatorView.startAnimating()
        NSOperationQueue().addOperationWithBlock { () -> Void in
            usleep(1000000)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                OAuthClient.shared.requestGithubAccess()
            
//                MBGithubOAuth.shared.oauthRequestWith(["scope" : "email,user,repo"])
            })
        }
    }
    
}
