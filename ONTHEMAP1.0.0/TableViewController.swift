//
//  TableViewController.swift
//  ONTHEMAP1.0.0
//
//  Created by Najla Awadh on 15/09/1440 AH.
//  Copyright © 1440 Najla Awadh. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var students : [StudentLocation]!{
        return Global.shareData.studentLocation
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

//        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
// LOGOUT
    @IBAction func logoutClick(_ sender: Any) {
        API.logoutUdacity { (error) in
            if let error = error {
               let alert = UIAlertController(title: "Error", message: error.localizedDescription ,preferredStyle: .alert)
                return }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }//END LOGOUT
//RELOAD
    @IBAction func reloadClick(_ sender: Any) {
        API.getAllLocations { (_ , error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription ,preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"OK",style:.default,handler:nil))
                return}
            }
        }//END RELOAD

    //ADD NEW LOCATION
    @IBAction func addClick(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "studentLocation") != nil{
            let alert = UIAlertController(title: "You have already posted a location. Would you like overwrite your current location?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Cancel",style:.default,handler:nil))
            alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {(action) in self.performSegue(withIdentifier: "AddLocation", sender: self)}))
           
        }else{
            self.performSegue(withIdentifier: "AddLocation", sender: self)
        }}//END ADD CLICK
    
    
    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! customCell
        let student = students[(indexPath as NSIndexPath).row]
        //cell.imageView?.image = UIImage(named:"icon_pin")
        cell.studentName?.text = student.firstName ?? " " + "" + student.lastName! 
        cell.link?.text = student.mediaURL ?? "GOOGLE"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        guard let open = student.mediaURL ,let url = URL(string:open) else{return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}
