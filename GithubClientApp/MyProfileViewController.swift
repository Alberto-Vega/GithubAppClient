//
//  MyProfileViewController.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/15/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit



class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var myProfilePictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myLocationLabel: UILabel!
    
    private var user:User? {
        didSet {
            if let user = user {
                nameLabel.text = user.name
                downloadImage()
                myLocationLabel.text = user.location
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
        setupRoundedImage()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        Animation.expandImage(myProfilePictureView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        Animation.animateImageRotatingZoomIn(myProfilePictureView)
        
    }
    
    func update() {
        
        if let token = OAuthClient.shared.token {
            
        if let url = NSURL(string: "https://api.github.com/user?access_token=\(token)") {
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    print(data)
                    
                    if let userJSON = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                        
                        var user:User?
                        
                        let name = userJSON["login"] as? String
                        let id = userJSON["id"] as? Int
                        let url = userJSON["url"] as? String
                        let avatarUrl = userJSON["avatar_url"] as? String
                        let location = userJSON["location"] as? String
                        
                        if let name = name, id = id, url = url, avatarUrl = avatarUrl, location = location  {
                            let userProfile = User(name: name, profileImageUrl: avatarUrl, location: location)
                            print(" Profile parsed is: \(userProfile)")
                            user = userProfile
                        }
                        
                        // This is because NSURLSession comes back on a background q.
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.user = user
                            print("User value coming to main queue: \(user)")
                        })
                    }
                }
                }.resume()
    }
    }
    }
    
    func setupRoundedImage() {
        self.myProfilePictureView.layer.cornerRadius = myProfilePictureView.frame.size.width/2
    }
    
    func downloadImage () {
        guard let string = user?.profileImageUrl  else {return}
        print(string)
        guard let url = NSURL(string: (string)) else { return }
        
        let downloadQ = dispatch_queue_create("downloadQ", nil)
        dispatch_async(downloadQ, { () -> Void in
            let imageData = NSData(contentsOfURL: url)!
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                guard let image = UIImage(data: imageData) else { return }
                self.myProfilePictureView.image = image
            })
        })
    }
}
