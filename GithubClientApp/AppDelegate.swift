//
//  AppDelegate.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/13/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var oauthViewController: OAuthViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if let _ = KeychainService.loadFromKeychain() {
        } else {
            self.presentOAuthViewController()
        }
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        OAuthClient.shared.exchangeCodeInURL(url) { (success) -> () in
            if success {
                
                if let oauthViewController =  self.oauthViewController {
                    oauthViewController.view.removeFromSuperview()
                    oauthViewController.removeFromParentViewController()
                }
            }
        }
        return true

    }
    
    // MARK: Setup
    
    func checkOAuthStatus() {
        if let _ = OAuthClient.shared.token  {
            print("We have a token at did finishLaunching with options")
        } else {
            print("We do not have a token at did finishLaunching with options")
            self.presentOAuthViewController()
        }
    }
    
    func presentOAuthViewController() {
        
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            if let tabbarController = navigationController.viewControllers.first as? UITabBarController {
                if let profileViewController = tabbarController.viewControllers?.first as? MyProfileViewController {
                    
                    guard let storyboard = navigationController.storyboard else {return}
                    guard let oauthViewController = storyboard.instantiateViewControllerWithIdentifier(OAuthViewController.identifier()) as? OAuthViewController else {return}
                    
                    profileViewController.addChildViewController(oauthViewController)
                    profileViewController.view.addSubview(oauthViewController.view)
                    oauthViewController.didMoveToParentViewController(profileViewController)
                    
                    self.oauthViewController = oauthViewController;
                }
            }
        }
    }
}