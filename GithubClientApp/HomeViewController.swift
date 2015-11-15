//
//  ViewController.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 11/13/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController, UITableViewDataSource, SFSafariViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
        
//        if let tabBarController = self.tabBarController, viewControllers = tabBarController.viewControllers {
//            if let searchUserViewController = viewControllers[2] as? SearchUserViewController {
//                searchUserViewController.delegate = self
//                self.searchUserViewController.reloadData()
//            }
//        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func update() {
        
        do {
            let token = try MBGithubOAuth.shared.accessToken()
            
            let url = NSURL(string: "https://api.github.com/user/repos?access_token=\(token)")!
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    if let arraysOfRepoDictionaries = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [[String : AnyObject]] {
                        
                        var repositories = [Repository]()
                        
                        for eachRepository in arraysOfRepoDictionaries {
                            
                            let name = eachRepository["name"] as? String
                            let id = eachRepository["id"] as? Int
                            let url = eachRepository["svn_url"] as? String
                            
                            
                            if let name = name, id = id, url = url  {
                                let repo = Repository(name: name, id: id, url: url)
                                repositories.append(repo)
                            }
                        }
                        
                        // This is because NSURLSession comes back on a background q.
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.repositories = repositories
                        })
                    }
                }
                }.resume()
        } catch {}
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let repository = self.repositories[indexPath.row]
        
        cell.textLabel?.text = repository.name
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedRepositoryUrl = repositories[indexPath.row].url
        print("The selected repo url for safari is: \(selectedRepositoryUrl)")
        
        let safariViewController = SFSafariViewController(URL: NSURL(string: selectedRepositoryUrl)!, entersReaderIfAvailable: true)
        safariViewController.delegate = self
        self.presentViewController(safariViewController, animated: true, completion: nil)
    }
    
    
    // MARK: SFSafariViewControllerDelegate
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}



