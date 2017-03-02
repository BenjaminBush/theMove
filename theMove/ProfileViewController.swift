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
    
    var pastEventsTitles: [String] = ["Kings", "group nap", "pet dogs"]
    
    // instantiate cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = pastEventsTitles[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastEventsTitles.count
        
    }
    
    func loadPastEvents() {
        let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/pastEvents.php")!
        let request = NSMutableURLRequest(url: url as URL);
        request.httpMethod = "POST";
        
        let userID = UserVariables.currUserID
        let body = "id=\(userID)"
        request.httpBody = body.data(using: String.Encoding.utf8);
        
        //URLSession.shared.dataTask(with: request, completionHandler: {(data:Data?, response:URLResponse?, error:NSError?) in
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            if (error == nil) {
                // send request
                DispatchQueue.main.async(execute: {
                    do  {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        // display event data in table view
                        // use JSON to populate pastEventsTitles
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        print(String(describing: parseJSON))
                        
                    } catch {
                        print("Caught an error: \(error)")
                    }
                })
            } else {
                print("error: \(error)")
            }
            
        });
        task.resume();
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        fullName.text = UserVariables.currFullname
        userName.text = UserVariables.currUsername
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.title = "My Profile"
        
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
