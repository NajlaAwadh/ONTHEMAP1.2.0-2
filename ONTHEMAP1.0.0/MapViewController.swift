//
//  MapViewController.swift
//  ONTHEMAP1.0.0
//
//  Created by Najla Awadh on 15/09/1440 AH.
//  Copyright © 1440 Najla Awadh. All rights reserved.
//

    import UIKit
    import MapKit
    
    class MapViewController: UIViewController, MKMapViewDelegate {
        var studentLocations :[StudentLocation]!{
            return Global.shareData.studentLocation
        }
        @IBOutlet weak var logoutButton: UIBarButtonItem!
        @IBOutlet weak var reloadButton: UIBarButtonItem!
        @IBOutlet weak var addButton: UIBarButtonItem!
        @IBOutlet weak var MapView: MKMapView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            updateAnnotation()
            MapView.delegate = self
        }
        //LOGOUT
        @IBAction func logoutClick(_ sender: Any) {
            API.logoutUdacity { (error) in
                if let error = error {
                    print(error)
               return }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            
        }//END LOGOUT
        //RELOAD
        @IBAction func reloadClick(_ sender: Any) {
            API.getAllLocations { ([StudentLocation]?, error) in
                if let error = error {return}
                DispatchQueue.main.async {
                    self.updateAnnotation()
                }
            }
        }//END RELOAD
        //UPDATE ANNOTATION
        func updateAnnotation(){
            var annotations = [MKPointAnnotation] ()
            
            guard let locationsArray = studentLocations else {
                let locationsErrorAlert = UIAlertController(title: "Erorr loading locations", message: "There was an error loading locations", preferredStyle: .alert )
                
                locationsErrorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(locationsErrorAlert, animated: true, completion: nil)
                return
            }
            
            
            for locationStruct in locationsArray {
                
                let long = CLLocationDegrees (locationStruct.longitude ?? 0)
                let lat = CLLocationDegrees (locationStruct.latitude ?? 0)
                let coords = CLLocationCoordinate2D (latitude: lat, longitude: long)
                
                
                let mediaURL = locationStruct.mediaURL ?? " "
                let first = locationStruct.firstName ?? " "
                let last = locationStruct.lastName ?? " "
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coords
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                annotations.append (annotation)
                if !self.MapView.annotations.contains(where: { $0.title == annotation.title }){ }
            }
            
            self.MapView.addAnnotations (annotations)
            
        } //END UPDATE ANNOTATION
        
        //ADD NEW LOCATION
        @IBAction func addClick(_ sender: Any) {
            if UserDefaults.standard.value(forKey: "studentLocation") != nil{
            let alart = UIAlertController(title: "You have already posted a location. Would you like overwrite your current location?", message: nil, preferredStyle: .alert)
            alart.addAction(UIAlertAction(title:"Cancel",style:.default,handler:nil))
            alart.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {(action) in self.performSegue(withIdentifier: "AddLocation", sender: self)}))
            //persent(alart,animated:true,completion:nil)
        }else{
        self.performSegue(withIdentifier: "AddLocation", sender: self)
            }}//END ADD CLICK
        
        override func viewWillAppear(_ animated: Bool) {
            API.getAllLocations () {(studentsLocations, error) in
                DispatchQueue.main.async {
                    
                    if error != nil {
                        let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                        
                        errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(errorAlert, animated: true, completion: nil)
                        return
                    }
                  
            }
        }//end getAllLocations
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            
            if control == view.rightCalloutAccessoryView {
                let app = UIApplication.shared
                if let toOpen = view.annotation?.subtitle! {
                    app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                }
            }
        }
}
