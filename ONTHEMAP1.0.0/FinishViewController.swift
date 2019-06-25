//
//  FinishViewController.swift
//  ONTHEMAP1.0.0
//
//  Created by Najla Awadh on 16/09/1440 AH.
//  Copyright © 1440 Najla Awadh. All rights reserved.
//

import UIKit
import MapKit
class FinishViewController: UIViewController , MKMapViewDelegate{

//
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    //
    var lat : Double!
    var long : Double!
    
    var link : String?
    var locationName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationmapView()
    }
    
     func locationmapView(){
        
        let lat = CLLocationDegrees(self.lat)
        let long = CLLocationDegrees(self.long)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        /* Zoom into a specific region */
        let span = MKCoordinateSpan.init(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(region, animated: true)
        
        }
    @IBAction func finish(_ sender: Any) {
        API.addLocation(link: link ?? "", latitude: lat, longitude: long, locationName: locationName , completion:{(error) in
            if let error = error{
                let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                    return
                }))
            }else{
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            }
           
        })
        
    }
    
}
    



