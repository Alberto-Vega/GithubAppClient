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
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var starredLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var user:User?
        {
        didSet
        {
            if let user = user
            {
                nameLabel.text = user.name
                downloadImage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()

        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        
        do {
            let token = try MBGithubOAuth.shared.accessToken()
            
            let url = NSURL(string: "https://api.github.com/user?access_token=\(token)")!
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    if let userJSON = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                        var user:User?
                        
                            let name = userJSON["login"] as? String
                            let id = userJSON["id"] as? Int
                            let url = userJSON["url"] as? String
                            let avatarUrl = userJSON["avatar_url"] as? String
                            
                            
                            if let name = name, id = id, url = url, avatarUrl = avatarUrl  {
                                let userProfile = User(name: name, profileImageUrl: avatarUrl)
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
        } catch {}
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
