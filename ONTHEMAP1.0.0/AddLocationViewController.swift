//
//  AddLocationViewController.swift
//  ONTHEMAP1.0.0
//
//  Created by Najla Awadh on 15/09/1440 AH.
//  Copyright © 1440 Najla Awadh. All rights reserved.
//

import UIKit
import CoreLocation


class AddLocationViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet var locationTF : UITextField!
    @IBOutlet var linkTF : UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet var activity: UIActivityIndicatorView!
    
   
    var lat : Double?
    var long : Double?
     var address = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
  }
    //
    func startActvity(_ activity: UIActivityIndicatorView){
        //activityIndicator.style = UIImage(named: "loading")
       let image : UIImage = UIImage(named: "loading")!
        
        activity.hidesWhenStopped = true
        activity.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
   
    
    func stopActivity(_ activity: UIActivityIndicatorView){
        activity.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    //
    override func viewWillAppear(_ animated: Bool) {
        self.activity.isHidden = true
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submitNewLocation"{
            let vc = segue.destination  as! FinishViewController
            
            vc.link = linkTF.text
            vc.locationName = locationTF.text
            vc.long = long
            vc.lat = lat
        }
    }
    
    @IBAction func findLocation(_ sender: Any) {
        /* Check if Text Fields are Empty */
        if locationTF.text!.isEmpty{
            let alart = UIAlertController(title: "Location Text Empty", message: "You must enter your Location",preferredStyle: .alert)
            alart.addAction(UIAlertAction(title:"OK",style:.default,handler:nil))
             present(alart, animated: true, completion: nil)
        }else if linkTF.text!.isEmpty{
           let alart = UIAlertController(title: "Link Text  Empty", message: "You must enter a URL",preferredStyle: .alert)
            alart.addAction(UIAlertAction(title:"OK",style:.default,handler:nil))
             present(alart, animated: true, completion: nil)
        }else{
            address = locationTF.text!

            Geocoding(address)
        }
    }
    //Cancel Click
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*******/
    
    
    func Geocoding(_ address: String) {
        startActvity(activity)
        //
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        guard (error == nil) else {
            self.stopActivity(self.activity)
             let alart = UIAlertController(title: "Geocode Error", message: "Unable to Geocode Address",preferredStyle: .alert)
            present(alart, animated: true, completion: nil)
              dismiss(animated:true, completion: nil)
            
            return
//            let alert = UIAlertController (title: "Geocode Error", message: "Unable to Geocode Address", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
//                return
//            }))
//
//            self.present (alert, animated: true, completion: nil)
//            return
        }
        
        if let placemarks = placemarks, placemarks.count > 0 {
            let placemark = placemarks[0]
            if let location = placemark.location {
                let coordinate = location.coordinate
             
                print(placemark)
                
                lat = coordinate.latitude
               long = coordinate.longitude
                self.stopActivity(self.activity)
//               print (lat , long)
                
//
               performSegue(withIdentifier: "submitNewLocation", sender: self)
        } 
    }

    }
}
