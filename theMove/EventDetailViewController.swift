//
//  EventDetailViewController.swift
//  theMove
//
//  Created by Rachel on 3/22/17.
//  Copyright © 2017 theMove. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    var selectedEventname: String!
    var selectedDate: String!
    var selectedNumPeople: String!
    
    var eventID: Int!
    
    @IBOutlet weak var moveButton: UIButton!
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var numPeople: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moveButton.layer.cornerRadius = 5
        
        eventName.text = selectedEventname
        numPeople.text = selectedNumPeople + " people moving"
        date.text = selectedDate
        
        // use event ID to get more info from database
        print("eventID: " + String(eventID))
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
