//
//  SearchUserViewController.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/13/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let customTransition = CustomModalTransition(duration: 2.0)
    
    var users = [User]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    class func identifier() -> String {
        return "SearchUserViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.collectionViewLayout = CustomFlowLayout(columns: 2)
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update(searchTerm: String) {
        
        if let token = OAuthClient.shared.token {
            
        if let url = NSURL(string: "https://api.github.com/search/users?access_token=\(token)&q=\(searchTerm)") {
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    
                    if let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                        
                        if let items = json["items"] as? [[String : AnyObject]] {
                            
                            var users = [User]()
                            
                            for item in items {
                                
                                let name = item["login"] as? String
                                let profileImageUrl = item["avatar_url"] as? String
                                let location = item["location"] as? String?
                                
                                if let name = name, profileImageUrl = profileImageUrl, location = location {
                                    
                                    users.append(User(name: name, profileImageUrl: profileImageUrl, location: location))
                                    print(users)
                                }
                            }
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.users = users
                            })
                        }
                    }
                }
                
                }.resume()
        }
    }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userCell", forIndexPath: indexPath) as! UserCollectionViewCell
        let user = self.users[indexPath.row]
        cell.user = user
        return cell
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            if String.validateInput(searchTerm) {
                self.update(searchTerm)
            } else {
                let alert = UIAlertController(title: "Invalid Search", message: "Your query for '\(searchBar.text!)' contains spaces or character(s) that will be ignored", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Please Try Again!", style: .Cancel, handler: nil)
                alert.addAction(action)
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.resignFirstResponder()
        return true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
    // MARK: prepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == UserDetailViewController.identifier() {
            if let cell = sender as? UICollectionViewCell, indexPath = collectionView.indexPathForCell(cell) {
                guard let userDetailViewController = segue.destinationViewController as? UserDetailViewController else {return}
                userDetailViewController.transitioningDelegate = self
                
                let user = users[indexPath.item]
                userDetailViewController.selectedUser = user
            }
        }
    }
    
    // MARK: Transition
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.customTransition
    }
}



