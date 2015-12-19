//
//  CreateRepoViewController.swift
//  GithubClientApp
//
//  Created by Alberto Vega Gonzalez on 12/18/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

typealias completionHandler = () -> ()

class CreateRepoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var repoNameTextField: UITextField!
    @IBOutlet weak var repoDescriptionTextView: UITextView!
    
    var completion: completionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.repoNameTextField.delegate = self
        self.repoDescriptionTextView.delegate = self
        
        self.repoNameTextField.becomeFirstResponder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createRepository(name: String, description: String, isPrivate:Bool, completion: (success:Bool) -> ()) {
        do {
            guard let token = KeychainService.loadFromKeychain() else {
                completion(success: false)
                return
            }
            guard let url = NSURL(string: "\(kGitHubAPIBaseURL)\(kGitHubAPICreateRepositoryEndpoint)?access_token=\(token)") else { completion(success: false); return }
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            var parameters = [String : AnyObject]()
            parameters["name"] = name
            if description.characters.count > 0 {
                parameters["description"] = description
            }
            parameters["private"] = isPrivate
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted) as NSData
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                if let response = response as? NSHTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        completion(success: true)
                    default:
                        completion(success: false)
                    }
                }
                if let error = error {
                    print(error)
                }
        }.resume()
        } catch { completion(success: false) }
    }
    
    //Mark: Alert Controllers
    
    func displayAlertNoText() {
        let noTextAlert = UIAlertController(title: "No Input Received", message: "Please enter your text", preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        noTextAlert.addAction(okButton)
        self.presentViewController(noTextAlert, animated: true, completion: nil)
    }
    
    func displayInvalidTextAlert() {
        let invalidTextAlertController = UIAlertController(title: "Invalid Input", message: "Only alphanumeric and underscores are valid entries", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        invalidTextAlertController.addAction(okAction)
        self.presentViewController(invalidTextAlertController, animated: true, completion: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let text = self.repoNameTextField.text else {
            displayAlertNoText()
            return false
        }
        if text.characters.count > 0 {
            if String.validateInput(text) {
            self.repoNameTextField.resignFirstResponder()
            self.repoDescriptionTextView.becomeFirstResponder()
            return true
        } else {
            displayInvalidTextAlert()
        }
        }
        displayInvalidTextAlert()
        return false
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        guard let name = self.repoNameTextField.text else { return }
        guard let description = self.repoDescriptionTextView.text else { return }
        createRepository(name, description: description, isPrivate: false) { (success) -> () in
            if success {
                guard let completion = self.completion else { return }
                completion()
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completion()
                })
            }
    }
}
}
