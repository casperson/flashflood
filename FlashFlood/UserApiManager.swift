//
//  UserApiManager.swift
//  FlashFlood
//
//  Created by Braden Casperson on 2/13/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class UserApiManager : NSObject, CLLocationManagerDelegate {
    static let sharedInstance = UserApiManager()
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    var locManager = CLLocationManager()
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updated Locations")
    }
    
    func createUser(onCompletion: (result: JSON) -> Void){
        let id = UIDevice.currentDevice().identifierForVendor!.UUIDString;
//        var latitude: CLLocationDegrees!
//        var longitude: CLLocationDegrees!
//        locManager.startUpdatingLocation()
        
//        if locManager.location?.coordinate.longitude != nil {
        
            let latitude = userDefaults.doubleForKey("latitude")
            let longitude = userDefaults.doubleForKey("longitude")
            
            let newUser = ["latitude": "\(latitude)", "longitude": "\(longitude)", "DeviceID": "\(id)"]

            Alamofire.request(.POST, "http://api.flashflood.me/user/", parameters: newUser, encoding: .JSON)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            print(json["token"])
                            self.userDefaults.setValue(json["token"].string, forKey: "token")
                            onCompletion(result: "Success")
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
//        }
    }

    
}
