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
//        
//        let firstLaunch = userDefaults.boolForKey("FirstLaunch")
//        
//        if firstLaunch  {
//            locManager.delegate = self
//            locManager.requestWhenInUseAuthorization()
//            locManager.startUpdatingLocation()
//            print("Not First Launch")
//        } else {
//            locManager.delegate = self
//            locManager.requestWhenInUseAuthorization()
//            locManager.startUpdatingLocation()
//            let id = UIDevice.currentDevice().identifierForVendor!.UUIDString;
//            
//            UserApiManager.sharedInstance.createUser() {
//                (result: JSON) in
//                    print(result)
//            }
//
//            userDefaults.setBool(true, forKey: "FirstLaunch")
//        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userDefaults.setValue(locManager.location?.coordinate.latitude.description, forKey: "latitude")
        userDefaults.setValue(locManager.location?.coordinate.longitude.description, forKey: "longitude")
    }
}
