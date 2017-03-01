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
    
    // create global variable to keep track of userID
    //var currUserID: String!
    
    
    // Initialize Function
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func register_click(_ sender: AnyObject) {
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
                passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
            if (email_empty) {
                emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
            if (firstname_empty) {
                firstnameTxt.attributedPlaceholder = NSAttributedString(string: "first", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
            if (lastname_empty) {
                lastnameTxt.attributedPlaceholder = NSAttributedString(string: "last", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
            
        } else {
            // Create new user in database
            
            // Url to php register file
            //let url = URL(string: "http://localhost/theMove/register.php")!
            let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/register.php")!
            let request = NSMutableURLRequest(url: url as URL);
            request.httpMethod = "POST";
            let body = "username=\(usernameTxt.text!.lowercased())&password=\(passwordTxt.text!)&fullname=\(firstnameTxt.text!)%20\(lastnameTxt.text!)";
            request.httpBody = body.data(using: String.Encoding.utf8);
            
            //URLSession.shared.dataTask(with: request, completionHandler: {(data:Data?, response:URLResponse?, error:NSError?) in
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if (error == nil) {
                    // send request
                    DispatchQueue.main.async(execute: {
                        do  {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            
                            guard let parseJSON = json else {
                                print("Error while parsing")
                                return
                            }
                            let id = parseJSON["id"]
                            
                            if id != nil {
                                // store user information
                                UserVariables.currUserID = String(describing: id)
                                UserVariables.currUsername = self.usernameTxt.text!
                                UserVariables.currFullname = self.firstnameTxt.text! + " " + self.lastnameTxt.text!
                                print(parseJSON);
                            } else {
                                self.usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.red])
                            }
                            
                        } catch {
                            print("Caught an error: \(error)")
                        }
                    })
                } else {
                    print("error: \(error)")
                }
                
            });
            task.resume();
            
        }
    }
    
}
