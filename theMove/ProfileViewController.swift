//
//  ViewController.swift
//  theMove
//
//  Created by Rachel on 2/26/17.
//  Copyright © 2017 theMove. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var pastEventsTitles: [String] = []
    
    // instantiate cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = pastEventsTitles[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastEventsTitles.count
        
    }
    
    func getUserEventData() {
        let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/getUserEvents.php")!
        
        let request = NSMutableURLRequest(url: url as URL);
        request.httpMethod = "POST";
        
        // fix this so user ID is not hardcoded!!!
        
        
        let body = "&user_id=13";
        request.httpBody = body.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if error != nil{
                print("1\(error)")
            }
            else{
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("response string = \(responseString!)")
                
                let json = JSON.init(parseJSON: responseString as! String)
                var number_events:Int = 0
                if let numEvents = json.dictionary?["num_events"]?.intValue {
                    number_events = numEvents
                }
                for index in 0..<number_events {
                    let i = String(index)
                    if let event = json.dictionary?[i] {
                        let name = event.dictionary?["event_name"]?.stringValue
                        self.pastEventsTitles.append(name!)
                    }
                    
                }
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        });
        
        task.resume()
    }
    
    func getUserInfo() {
        let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/getUserInfo.php")!
        
        let request = NSMutableURLRequest(url: url as URL);
        request.httpMethod = "POST";
        
        // fix this so username is not hardcoded!!!
        
//        if let results = UserDefaults.standard.value(forKey: "username") {
//            print("username " + String(describing: results))
//        }
        
        let body = "username=sophia.veksler";
        request.httpBody = body.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if error != nil{
                print("1\(error)")
            }
            else{
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("response string = \(responseString!)")
                
                let json = JSON.init(parseJSON: responseString as! String)
                
                if let first = json.dictionary?["first_name"]?.stringValue {
                    UserVariables.currFirstName = first
                }
                if let last = json.dictionary?["last_name"]?.stringValue {
                    UserVariables.currLastName = last
                }
                if let userid = json.dictionary?["user_id"]?.stringValue {
                    UserVariables.currUserID = userid
                }
                if let email = json.dictionary?["email"]?.stringValue {
                    UserVariables.currEmail = email
                }
               
            }

        });
        
        task.resume()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.title = "My Profile"
        
        getUserEventData()
        
        getUserInfo()
        
        fullName.text = UserVariables.currFirstName + " " + UserVariables.currLastName
        userName.text = "@" + UserVariables.currUsername
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
