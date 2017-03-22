//
//  LoginVC.swift
//  theMove
//
//  Created by Ben on 3/22/17.
//  Copyright © 2017 theMove. All rights reserved.
//

import UIKit
//import SwiftyJSON

class LoginVC: UIViewController {
    
  
    @IBOutlet var usernameTxt: UITextField!
   
    @IBOutlet var passwordTxt: UITextField!
    
    // Initialize Function
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func login_click(_ sender: Any) {
        // If no text
        let username_empty = usernameTxt.text!.isEmpty
        let password_empty = passwordTxt.text!.isEmpty
        
        // Red Placeholders
        if (username_empty || password_empty) {
            if (username_empty) {
                usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
            if (password_empty) {
                passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
        } else {
            // Create new user in database
            
            // Url to php register file
            let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/login.php")!
            
            let request = NSMutableURLRequest(url: url as URL);
            request.httpMethod = "POST";
            let body = "username=\(usernameTxt.text!.lowercased())&password=\(passwordTxt.text!)";
            request.httpBody = body.data(using: String.Encoding.utf8);
            
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                
                if error != nil{
                    print("1\(error)")
                }
                else{
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("response string = \(responseString!)")
                }
                
                do {
                    
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                        
                        // Print out dictionary
                        print(convertedJsonIntoDict)
                        
                        // Get value by key
                        let firstNameValue = (convertedJsonIntoDict[0] as! NSDictionary)["message"] as? String
                        print("here = \(firstNameValue!)")
                        
                    }
                    else{
                        print("here")
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            });
            task.resume()
        }

    }
    
    
    @IBAction func register_click(_ sender: Any) {
        performSegue(withIdentifier: "move_to_registervc", sender: self)
    }
}