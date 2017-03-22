//
//  EventsViewController.swift
//  theMove
//
//  Created by Rachel on 3/22/17.
//  Copyright © 2017 theMove. All rights reserved.
//

import UIKit

struct moveData {
    var eventName: String
    var friendsGoing: Int
    var peopleGoing: Int
}

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var events:[String] = ["dog", "cat", "eat ice cream", "go to T's"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = events[indexPath.row]
        cell.detailTextLabel?.text = "10 friends, 30 people"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let details = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil)
        navigationController?.pushViewController(details, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        DispatchQueue.global(qos: .userInitiated).async {
            //self.cacheImages()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
