//
//  AddEventVC.swift
//  theMove
//
//  Created by Rachel on 3/27/17.
//  Copyright © 2017 theMove. All rights reserved.
//

import UIKit

class AddEventVC: UIViewController {

    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var dateTime: UIDatePicker!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createButton.layer.cornerRadius = 5
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
