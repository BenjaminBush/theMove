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
    
    @IBOutlet weak var category: UITextField!
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        let url = NSURL(string: "http://ec2-35-164-58-73.us-west-2.compute.amazonaws.com/~theMove/theMove/addEvent.php")!
        
        let request = NSMutableURLRequest(url: url as URL);
        request.httpMethod = "POST";
        
        // fix this so user ID is not hardcoded!!!
        
        let name = eventTitle.text
        let date = dateTime.date
        let addr = address.text
        let cat = category.text
        
        let body1 = "host=test&name=" + name! + "&date=" + String(describing: date)
        let body2 = "&address=" + addr!
        let body3 = cat! + "&active=true"
        
        let body = body1+body2+body3;
        
        print(body)
        
        request.httpBody = body.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if error != nil{
                print("1\(error)")
            }
            else{
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("response string = \(responseString!)")
                
//                let json = JSON.init(parseJSON: responseString as! String)
//                if let response = json.dictionary?["status"]?.stringValue {
//                    if(response == "400") {
//
//                    }
//                }
            }
            
        });
        
        task.resume()
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
