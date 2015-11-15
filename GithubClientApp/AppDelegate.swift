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
        self.checkOAuthStatus()
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        MBGithubOAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.UserDefaults) { (success) -> () in
            if success {
                if let oauthViewController = self.oauthViewController {
                    oauthViewController.processOauthRequest()
                }
            }
        }
        return true
    }
    
    // MARK: Setup
    
    func checkOAuthStatus() {
        
        do {
            
            let token = try MBGithubOAuth.shared.accessToken()
            print(token)
            
        } catch _ { self.presentOAuthViewController() }
        
    }
    
    func presentOAuthViewController() {
        
        if let tabbarController = self.window?.rootViewController as? UITabBarController, homeViewController = tabbarController.viewControllers?.first as? HomeViewController, storyboard = tabbarController.storyboard {
            
            
            if let oauthViewController = storyboard.instantiateViewControllerWithIdentifier(OAuthViewController.identifier()) as? OAuthViewController {
                
                homeViewController.addChildViewController(oauthViewController)
                homeViewController.view.addSubview(oauthViewController.view)
                oauthViewController.didMoveToParentViewController(homeViewController)
                
                tabbarController.tabBar.hidden = true
                
                oauthViewController.oauthCompletionHandler = ({
                    UIView.animateWithDuration(0.6, delay: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        oauthViewController.view.alpha = 0.0
                        }, completion: { (finished) -> Void in
                            oauthViewController.view.removeFromSuperview()
                            oauthViewController.removeFromParentViewController()
                            
                            tabbarController.tabBar.hidden = false
                            
                            // Make the call for repositories.
                            homeViewController.update()
                    })
                })
                self.oauthViewController = oauthViewController
            }
        }
    }
}