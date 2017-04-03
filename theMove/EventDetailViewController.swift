//
//  EventDetailViewController.swift
//  theMove
//
//  Created by Rachel on 3/22/17.
//  Copyright © 2017 theMove. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var selectedEventname: String!
    var selectedDate: String!
    var selectedNumPeople: String!
    
    var selectedAddr: String!
    var selectedCategory: String!
    var selectedHost: String!
    var selectedFriends: String = "0"
    
    var eventID: Int!
    
    var friendsAttending: [String] = []
    
    var userGoing = false
    
    @IBOutlet weak var moveButton: UIButton!
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var numPeople: UILabel!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var host: UILabel!
    @IBOutlet weak var numFriends: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell2")
        cell.textLabel!.text = friendsAttending[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsAttending.count
        
    }
    
    @IBAction func movingHerePressed(_ sender: UIButton) {
        
        if let results = UserDefaults.standard.value(forKey: "eventid") {
            if (String(describing: results) == String(eventID)) {
                // user is already going to this event, so remove them from it
                
                removeUser(eventToRemove: String(eventID))
                UserDefaults.standard.removeObject(forKey: "eventid")
            }
            else {
                // user is moving, but to a different event --> move them here and remove them from prev event
                removeUser(eventToRemove: results as! String)
                moveUser()
                
            }
        }
        
        else {
            // user has not yet selected a move
            
            moveUser()
        }
        
        
    }
    
    func moveUser () {
        print("user added to event")
        
        let id = String(eventID)
        UserDefaults.standard.setValue(id, forKey: "eventid")
        
        let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/guestAdd.php")!
        
        let request = NSMutableURLRequest(url: url as URL);
        request.httpMethod = "POST";
        
        // fix this so user ID is not hardcoded!!!
        
        let body = "event_id=" + String(eventID) + "&user_id=19";
        request.httpBody = body.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if error != nil{
                print("1\(error)")
            }
            else{
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("response string = \(responseString!)")
                
                let json = JSON.init(parseJSON: responseString as! String)
                if let response = json.dictionary?["status"]?.stringValue {
                    if(response == "1") {
                        self.userGoing = true
                        self.moveButton.backgroundColor = UIColor.red
                    }
                }
            }
            
        });
        
        task.resume()
    }
    
    func removeUser(eventToRemove: String) {
        
        let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/guestDelete.php")!
        
        let request = NSMutableURLRequest(url: url as URL);
        request.httpMethod = "POST";
        
        // fix this so user ID is not hardcoded!!!
        
        let body = "event_id=" + eventToRemove + "&user_id=19";
        request.httpBody = body.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if error != nil{
                print("1\(error)")
            }
            else{
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("response string = \(responseString!)")
                
                let json = JSON.init(parseJSON: responseString as! String)
                if let response = json.dictionary?["status"]?.stringValue {
                    if(response == "1") {
                        print("user removed")
                        //self.userGoing = true
                        //self.moveButton.backgroundColor = UIColor.white
                        
                        //UserDefaults.standard.removeObject(forKey: "eventid")
                    }
                }
            }
            
        });
        
        task.resume()
    }
    
    func getEventData() {
        let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/getEventDetail.php")!
        
        let request = NSMutableURLRequest(url: url as URL);
        request.httpMethod = "POST";
        
        // fix this so user ID is not hardcoded!!!
        
        
        let body = "event_id=" + String(eventID) + "&user_id=19";
        request.httpBody = body.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if error != nil{
                print("1\(error)")
            }
            else{
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("response string = \(responseString!)")
                
                let json = JSON.init(parseJSON: responseString as! String)
                
                if let addr = json.dictionary?["event_address"]?.stringValue {
                    self.selectedAddr = addr
                }
                if let cat = json.dictionary?["category"]?.stringValue {
                    self.selectedCategory = cat
                }
                var firstName: String!
                var lastName: String!
                if let hostFirst = json.dictionary?["host_firstname"]?.stringValue {
                    firstName = hostFirst
                }
                if let hostLast = json.dictionary?["host_lastname"]?.stringValue {
                    lastName = hostLast
                }
                self.selectedHost = firstName + " " + lastName
                
                // get friends
                if let numFriends = json.dictionary?["numFriendsAttending"]?.intValue {
                    if(numFriends > 0) {
                        self.selectedFriends = String(numFriends)
                        for result in json["friends"].arrayValue {
                            let first = result["first_name"].stringValue
                            let last = result["last_name"].stringValue
                            self.friendsAttending.append(first + " " + last)
                        }
                    }
                    
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        });
        
        task.resume()
    }
    
//    DispatchQueue.main.async {
//    // do something
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        moveButton.layer.cornerRadius = 5
        if(userGoing) {
            moveButton.backgroundColor = UIColor.red
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.getEventData()
            
        }
        
        eventName.text = selectedEventname
        numPeople.text = selectedNumPeople + " people moving"
        date.text = selectedDate
        
        //address.text = selectedAddr
        //category.text = selectedCategory
        //host.text = selectedHost
        //numFriends.text = selectedFriends
        
        DispatchQueue.main.async {
            self.address.text = self.selectedAddr
            self.category.text = self.selectedCategory
            self.host.text = self.selectedHost
            self.numFriends.text = self.selectedFriends
        }
        
        if let results = UserDefaults.standard.value(forKey: "eventid") {
            if (String(describing: results) == String(eventID)) {
                moveButton.backgroundColor = UIColor.red
            }
        }

        
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
