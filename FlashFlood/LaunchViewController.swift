//
//  LaunchViewController.swift
//  FlashFlood
//
//  Created by Braden Casperson on 2/12/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class LaunchViewController : UITabBarController, CLLocationManagerDelegate {
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    var locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstLaunch = userDefaults.boolForKey("FirstLaunch")
        
        if firstLaunch  {
            locManager.delegate = self
            locManager.requestWhenInUseAuthorization()
            locManager.startUpdatingLocation()
            print("Not First Launch")
        } else {
            locManager.delegate = self
            locManager.requestWhenInUseAuthorization()
            locManager.startUpdatingLocation()
            let id = UIDevice.currentDevice().identifierForVendor!.UUIDString;
            
            UserApiManager.sharedInstance.createUser() {
                (result: JSON) in
                    print(result)
            }
//            let latitude = self.locManager.location?.coordinate.latitude
//            let longitude = self.locManager.location?.coordinate.longitude
//            
//            let newUser = ["latitude": "\(latitude)", "longitude": "\(longitude)", "DeviceID": "\(id)"]
//            Alamofire.request(.POST, "http://api.flashflood.me/user/", parameters: newUser, encoding: .JSON)
//                .responseJSON { response in
//                    switch response.result {
//                    case .Success:
//                        if let value = response.result.value {
//                            let json = JSON(value)
//                            print("JSON: \(json)")
//                            self.userDefaults.setValue(json["Item"]["UniqueUserID"].int, forKey: "userId")
//                        }
//                    case .Failure(let error):
//                        print(error)
//                    }
//            }
            userDefaults.setBool(true, forKey: "FirstLaunch")
        }
    }
}
