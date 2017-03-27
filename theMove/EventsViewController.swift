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
    var peopleGoing: String
}

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var eventsFromDatabase: [MoveData] = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = eventsFromDatabase[indexPath.row].eventName
        cell.detailTextLabel?.text = eventsFromDatabase[indexPath.row].peopleGoing
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsFromDatabase.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let details = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil)
        navigationController?.pushViewController(details, animated: true)
        
    }
    
    
    func getEventData() {
        let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/getEvents.php")!
        
        let request = NSMutableURLRequest(url: url as URL);
        request.httpMethod = "POST";
        let body = "username=test";
        request.httpBody = body.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if error != nil{
                print("1\(error)")
            }
            else{
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("response string = \(responseString!)")
                
                let json = JSON.init(parseJSON: responseString as! String)
                var number_events:Int = 0
                if let numEvents = json.dictionary?["num_events"]?.intValue {
                    number_events = numEvents
                }
                for index in 0..<number_events {
                    let i = String(index)
                    if let event = json.dictionary?[i] {
                        let name = event.dictionary?["event_name"]?.stringValue
                        let attending = (event.dictionary?["numGuests"]?.stringValue)! + " people moving here"
                        print("name: " + name!)
                        print("guests: " + attending)
                        self.eventsFromDatabase.append(MoveData(eventName: name!, peopleGoing: attending))
                    }

                }
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        });
        task.resume()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.getEventData()
            print(self.eventsFromDatabase.count)
            
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                print(self.eventsFromDatabase.count)
//            }
        }
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
