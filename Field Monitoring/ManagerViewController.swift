//
//  ManagerViewController.swift
//  Field Monitoring
//
//  Created by R.M.K. Engineering College on 01/07/17.
//  Copyright © 2017 R.M.K. Engineering College. All rights reserved.
//

import UIKit
import Alamofire

class ManagerViewController: UIViewController {
    
    var latitude = 0.0
    var longitude = 0.0
    var address = ""
    var mapContent = ""
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet var taskTitle: UITextField!
    @IBOutlet var skills: UITextField!
    @IBOutlet var experience: UITextField!
    @IBOutlet var salary: UITextField!
    @IBOutlet var jobLocation: UITextField!
    @IBOutlet weak var latit: UILabel!
    @IBOutlet weak var longi: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle.layer.cornerRadius = 15;
        skills.layer.cornerRadius = 15;
        experience.layer.cornerRadius = 15;
        salary.layer.cornerRadius = 15;
        jobLocation.layer.cornerRadius = 15;
        secondView.layer.cornerRadius = 20;
        buttonOutlet.layer.cornerRadius = 20;
        activityIndicator.stopAnimating()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func assignJob(_ sender: Any) {
        let jobTitleValue = taskTitle.text
        let skillValue = skills.text
        let experienceValue = experience.text
        let salaryValue = salary.text
        let jobLoc = jobLocation.text
        let urlPath :String = "https://field-monitoring.herokuapp.com/users/postjob/"
        let parametersValue = ["jobTitle" : jobTitleValue, "salary" : salaryValue, "experience" : experienceValue, "address" : jobLoc, "skills" : skillValue]
        
        self.mapContent = "Job: " + jobTitleValue! + "\nSkills: " + skillValue!
        self.mapContent +=  "\nExperience: " + experienceValue! + "\nSalary : " + salaryValue!
        
        Alamofire.request(urlPath, method: .post, parameters: parametersValue, encoding: JSONEncoding.default, headers: [:])
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching colors: \(String(describing: response.result.error))")
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: String],
                    let status = responseJSON["message"],
                    let latitiude = responseJSON["latitude"],
                    let address = responseJSON["address"],
                    let longitude = responseJSON["longitude"] else {return}
                
                self.latitude = Double(latitiude)!
                self.longitude = Double(longitude)!
                self.address = address
                
                if (status == "success"){
                    self.performSegue(withIdentifier:"mapSegue", sender: self)
                }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapViewController = segue.destination as! MapViewController
        //print("\n\n\n Lat-Long")
        //print (latitude, longitude)
        mapViewController.lat = latitude
        mapViewController.long = longitude
        mapViewController.address = address
        mapViewController.mapContent = mapContent
    }
}
   

