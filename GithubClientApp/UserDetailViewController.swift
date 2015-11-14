//
//  UserDetailViewController.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/13/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    class func identifier() -> String {
        return "UserDetailViewController"
    }

    @IBOutlet weak var userImageView: UIImageView!
    var selectedUser: User? {
        didSet {
            print("Detail view controller received the user: \(selectedUser?.name)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.userImageView.layer.cornerRadius =    userImageView.frame.size.width/2
        self.userImageView.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func downloadImage () {
//        
//        if let url = NSURL(string: (owner?.avatarUrl)!) {
//            
//            let downloadQ = dispatch_queue_create("downloadQ", nil)
//            dispatch_async(downloadQ, { () -> Void in
//                let imageData = NSData(contentsOfURL: url)!
//                
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    let image = UIImage(data: imageData)
//                    self.userImageView.image = image
//                })
//            })
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
