//
//  RegisterVC.swift
//  theMove
//
//  Created by Ben Bush on 2/18/17.
//  Copyright © 2017 theMove. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var firstnameTxt: UITextField!
    @IBOutlet var lastnameTxt: UITextField!
    
    
    // Initialize Function
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func register_click(sender: AnyObject) {
        // If no text
        //let username_empty = usernameTxt.text!.isEmpty
        let password_empty = usernameTxt.text!.isEmpty
        let email_empty = usernameTxt.text!.isEmpty
        let firstname_empty = usernameTxt.text!.isEmpty
        let lastname_empty = usernameTxt.text!.isEmpty
        
        // Red Placeholders
        if (password_empty || email_empty || firstname_empty || lastname_empty) {
            
            
            //if (username_empty) {
            //    usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            //}
            if (password_empty) {
                passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            }
            if (email_empty) {
                emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            }
            if (firstname_empty) {
                firstnameTxt.attributedPlaceholder = NSAttributedString(string: "first", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            }
            if (lastname_empty) {
                lastnameTxt.attributedPlaceholder = NSAttributedString(string: "last", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            }
            
        } else {
            // Create new user in database
            
            // Url to php register file
            let url = NSURL(string: "http://localhost/theMove/register.php")!
            let request = NSMutableURLRequest(URL: url);
            request.HTTPMethod = "POST";
            let body = "username=\(usernameTxt.text!.lowercaseString)&password=\(passwordTxt.text!)&fullname=\(firstnameTxt.text!)%20\(lastnameTxt.text!)";
            request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding);
            
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {(data:NSData?, response:NSURLResponse?, error:NSError?) in
                if (error == nil) {
                    // send request
                    dispatch_async(dispatch_get_main_queue(), {
                        do  {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                            
                            guard let parseJSON = json else {
                                print("Error while parsing")
                                return
                            }
                            let id = parseJSON["id"]
                            
                            if id != nil {
                                print(parseJSON);
                            } else {
                                self.usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
                            }
                            
                        } catch {
                            print("Caught an error: \(error)")
                        }
                    })
                } else {
                    print("error: \(error)")
                }
                
            }).resume()
            
        }
    }
    
}
