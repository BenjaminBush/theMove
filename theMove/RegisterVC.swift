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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func register_click(_ sender: Any) {
        // If no text
        let username_empty = usernameTxt.text!.isEmpty
        let password_empty = usernameTxt.text!.isEmpty
        let email_empty = usernameTxt.text!.isEmpty
        let firstname_empty = usernameTxt.text!.isEmpty
        let lastname_empty = usernameTxt.text!.isEmpty
        
        // Red Placeholders
        if (password_empty || email_empty || firstname_empty || lastname_empty) {
            
            
            if (username_empty) {
                usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
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
            let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/register.php")!
            
            let request = NSMutableURLRequest(url: url as URL);
            request.httpMethod = "POST";
            let body = "username=\(usernameTxt.text!.lowercased())&email=\(emailTxt.text!)&password=\(passwordTxt.text!)&firstname=\(firstnameTxt.text!)&lastname=\(lastnameTxt.text!)";
            request.httpBody = body.data(using: String.Encoding.utf8);
            
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                
                if error != nil{
                    print("1\(error)")
                }
                do {
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("response string = \(responseString!)")

                    let json = JSON.init(parseJSON: responseString as! String)
                
                    if let first = json.dictionary?["first_name"]?.stringValue {
                        UserDefaults.standard.setValue(first, forKey: "firstname")
                    }
                    if let last = json.dictionary?["last_name"]?.stringValue {
                        UserDefaults.standard.setValue(last, forKey: "lastname")
                    }
                    if let userid = json.dictionary?["user_id"]?.stringValue {
                        print("getting user id " + userid)
                        UserDefaults.standard.setValue(userid, forKey: "userid")
                    }
                    if let email = json.dictionary?["email"]?.stringValue {
                        UserDefaults.standard.setValue(email, forKey: "email")
                    }
                    if let username = json.dictionary?["username"]?.stringValue {
                        UserDefaults.standard.setValue(username, forKey: "username")
                    }
                    if let status = json.dictionary?["status"]?.stringValue {
                        print(status)
                        
                        if (status == "400") {
                            print("status was 400 and worked")
                            self.usernameTxt.text = "Username is already taken"
                            self.usernameTxt.textColor = UIColor.red
                        }
                        print("before status 200")
                        if(status == "200"){
                            print("status was 200 and worked")
                            OperationQueue.main.addOperation{
                             self.performSegue(withIdentifier: "login", sender: self)
                            }
                        }
                        
                    }
                }
            });
            task.resume()
        }

    }
    

    @IBAction func login_click(_ sender: Any) {
        performSegue(withIdentifier: "send_to_loginVC", sender: self);
    }
   
}
