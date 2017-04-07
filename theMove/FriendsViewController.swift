//
//  FriendsViewController.swift
//  theMove
//
//  Created by Mara on 3/22/17.
//  Copyright © 2017 theMove. All rights reserved.
//
import UIKit

struct FriendData {
    var firstName: String
    var lastName: String
    var userName: String
}

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var acceptedtableView: UITableView!
    
    @IBOutlet weak var addedFriendUsername: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    var friendsFromDatabase: [FriendData] = []
    var userid: String!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = friendsFromDatabase[indexPath.row].firstName + " " + friendsFromDatabase[indexPath.row].lastName
        cell.detailTextLabel?.text = "@" + friendsFromDatabase[indexPath.row].userName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsFromDatabase.count
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "friendDetails", sender: self)
//    }


    func getFriendData() {
        
        if let results = UserDefaults.standard.value(forKey: "userid") {
            userid = String(describing: results)
        }
        
        let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/getFriends.php")!
        
        let request = NSMutableURLRequest(url: url as URL);
        request.httpMethod = "POST";
        let body = "user_id=" + userid
        request.httpBody = body.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if error != nil{
                print("1\(error)")
            }
            else{
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("response string = \(responseString!)")
                
                let json = JSON.init(parseJSON: responseString as! String)
                var number_friends:Int = 0
                if let numFriends = json.dictionary?["num_friends"]?.intValue {
                    number_friends = numFriends
                }
                for index in 0..<number_friends {
                    let i = String(index)
                    if let friend = json.dictionary?[i] {
                        let fname = friend.dictionary?["first_name"]?.stringValue
                        let lname = friend.dictionary?["last_name"]?.stringValue
                        let username = friend.dictionary?["username"]?.stringValue
                        self.friendsFromDatabase.append(FriendData(firstName: fname!, lastName: lname!, userName: username!))
                    }
                }
                self.friendsFromDatabase.sort { $0.firstName.lowercased() < $1.firstName.lowercased() }
            }
            DispatchQueue.main.async {
                self.acceptedtableView.reloadData()
            }
        });
        task.resume()
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        let receiver = addedFriendUsername.text
        var sender: String!
        
        if let results = UserDefaults.standard.value(forKey: "username") {
            sender = String(describing: results)
        }
        
        let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/addFriend.php")!
        
        let request = NSMutableURLRequest(url: url as URL);
        request.httpMethod = "POST";
        let body = "sender=" + sender + "&receiver=" + receiver!
        request.httpBody = body.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if error != nil{
                print("1\(error)")
            }
            else{
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("response string = \(responseString!)")
                
                let json = JSON.init(parseJSON: responseString as! String)
                
                if let status = json.dictionary?["status"]?.stringValue {
                    if(String(status) != "200") {
                        if let message = json.dictionary?["message"]?.stringValue {
                            OperationQueue.main.addOperation {
                                print("reached error")
                                self.errorMessage.isHidden = false
                                self.errorMessage.text = message
                            }
                        }
                    }
                }
                
            }
            DispatchQueue.main.async {
                self.friendsFromDatabase.removeAll()
                self.getFriendData()
                self.acceptedtableView.reloadData()
            }
        });
        task.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        errorMessage.isHidden = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.friendsFromDatabase.removeAll()
            self.getFriendData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        acceptedtableView.dataSource = self
        acceptedtableView.delegate = self
        acceptedtableView.register(UITableViewCell.self, forCellReuseIdentifier: "friendcell")        
        
        self.title = "Friends"
        
        errorMessage.isHidden = true
        // Do any additional setup after loading the view.
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
