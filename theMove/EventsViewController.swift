//
//  EventsViewController.swift
//  theMove
//
//  Created by Rachel on 3/22/17.
//  Copyright © 2017 theMove. All rights reserved.
//

import UIKit

struct MoveData {
    var eventName: String
    var peopleGoing: Int
    var eventID: Int
    var eventDate: String
}

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var eventsFromDatabase: [MoveData] = []
    
    var username: String!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = eventsFromDatabase[indexPath.row].eventName
        cell.detailTextLabel?.text = String(eventsFromDatabase[indexPath.row].peopleGoing) + " moving"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsFromDatabase.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventDetails", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetails" {
            if let destination = segue.destination as? EventDetailViewController {
                let index = tableView.indexPathForSelectedRow?.row
                destination.selectedEventname = eventsFromDatabase[index!].eventName
                destination.selectedNumPeople = String(eventsFromDatabase[index!].peopleGoing)
                destination.selectedDate = eventsFromDatabase[index!].eventDate
                destination.eventID = eventsFromDatabase[index!].eventID
            }
        }
    }
    
    
    func getEventData() {
        let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/getEvents.php")!
        
        let request = NSMutableURLRequest(url: url as URL);
        request.httpMethod = "POST";
        
        if let results = UserDefaults.standard.value(forKey: "username") {
            username = String(describing: results)
        }
        
        let body = "username=" + username;
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
                        let attending = event.dictionary?["numGuests"]?.intValue
                        let id = event.dictionary?["event_id"]?.intValue
                        let date = event.dictionary?["event_date"]?.stringValue
                        self.eventsFromDatabase.append(MoveData(eventName: name!, peopleGoing: attending!, eventID: id!, eventDate: date!))
                    }

                }
                self.eventsFromDatabase.sort(by: { $0.peopleGoing > $1.peopleGoing })
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        });
        task.resume()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {

        DispatchQueue.global(qos: .userInitiated).async {
            self.eventsFromDatabase.removeAll()
            self.getEventData()
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        self.title = "Moves"

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
