//
//  API.swift
//  ONTHEMAP1.0.0
//
//  Created by Najla Awadh on 15/09/1440 AH.
//  Copyright © 1440 Najla Awadh. All rights reserved.
//

import Foundation
import CoreLocation
class API {
   //API Login Udacity
    static func loginUdacity (_ email : String!, _ password : String!, completion: @escaping (Bool, String, Error?)->()) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion (false, "", error)
                return
            }
        
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (false, "", statusCodeError)
                return
            }
            
            if statusCode >= 200  && statusCode < 300 {
                
                //Skipping the first 5 characters
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                
                //Print the data to see it and know you'll parse it (this can be removed after you complete building the app)
                print (String(data: newData!, encoding: .utf8)!)
                
                //TODO: Get an object based on the received data in JSON format
                let loginJsonObject = try! JSONSerialization.jsonObject(with: newData!, options: [])
                
                //TODO: Convert the object to a dictionary and call it loginDictionary
                let loginDictionary = loginJsonObject as? [String : Any]
                
                //Get the unique key of the user
                let accountDictionary = loginDictionary? ["account"] as? [String : Any]
                let uniqueKey = accountDictionary? ["key"] as? String ?? " "
                completion (true, uniqueKey, nil)
            } else {
                //TODO: call the completion handler properly
                completion (false, "", nil)
            }
        }
        //Start the task
        task.resume()
    }//END API login Udacity
    
    /****************************************/
    //API Logout Udacity
    static func logoutUdacity (completion:@escaping(Error?)->()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(error)
                return
            }
             completion(error)
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
    }// END API Logout Udacity
    /***************************************/
    //API Add location or pin
    static func addLocation (link : String, latitude:Double , longitude:Double , locationName : String, completion: @escaping (Error?)->()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"\(link)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(error)
                return
            }
            completion(nil)
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
    }//END API Add location or pin
    /*****************************/
    //API get location
    static func getAllLocations (completion: @escaping ([StudentLocation]?, Error?) -> ()) {
        var request = URLRequest (url: URL (string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if error != nil {
                completion (nil, error)
                return
            }
            
            print (String(data: data!, encoding: .utf8)!)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion (nil, statusCodeError)
                return
            }
           
            if statusCode >= 200 && statusCode < 300 {
                
                let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                
                
                let resultsArray = jsonDictionary["results"] as? [[String:Any]]
                
                guard let array = resultsArray else {return}
                
               
                let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                
              
                let studentsLocations = try! JSONDecoder().decode([StudentLocation].self, from: dataObject)
                
                Global.shareData.studentLocation = studentsLocations
                completion (studentsLocations, nil)
            }
        }
        
        task.resume()
    }//END API get location
    
}

