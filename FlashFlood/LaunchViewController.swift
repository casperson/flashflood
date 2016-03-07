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
import Photos

class LaunchViewController : UITabBarController {
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    var locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstLaunch = userDefaults.boolForKey("FirstLaunch")
        
        if firstLaunch  {
            locManager.requestWhenInUseAuthorization()
        } else {
            locManager.requestWhenInUseAuthorization()
            let id = UIDevice.currentDevice().identifierForVendor!.UUIDString;
            let latitude = self.locManager.location?.coordinate.latitude
            let longitude = self.locManager.location?.coordinate.longitude
            
            let newUser = ["latitude": "\(latitude)", "longitude": "\(longitude)", "DeviceID": "\(id)"]
            Alamofire.request(.POST, "https://api.flashflood.me/user/", parameters: newUser, encoding: .JSON)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            self.userDefaults.setValue(9, forKey: "userId")
                            print("JSON: \(json)")
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
            userDefaults.setBool(true, forKey: "FirstLaunch")
        }
    }
}
