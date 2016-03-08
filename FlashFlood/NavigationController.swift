//
//  NavigationController.swift
//  FlashFlood
//
//  Created by Braden Casperson on 3/7/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit

class NavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Pacifico-Regular", size: 20)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        UINavigationBar.appearance().topItem?.title = "flashflood"
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSFontAttributeName: UIFont(name: "Pacifico-Regular", size: 30)!,
//            NSForegroundColorAttributeName: UIColor.whiteColor()
//        ]

    }
}
