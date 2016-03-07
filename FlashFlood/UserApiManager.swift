//
//  UserApiManager.swift
//  FlashFlood
//
//  Created by Braden Casperson on 2/13/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import Foundation
import Alamofire

private func createUser() {
    
    Alamofire.request(.POST, "https://api.flashflood.me/user/", parameters: nil)
        .responseJSON { response in
            print(response.request)
            print(response.response)
            print(response.data)
            print(response.result)
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
    }
    
}
