//
//  Key.swift
//  Tweeter
//
//  Created by Philip Yu on 5/12/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import Foundation

func fetchFromPlist(forResource resource: String, forKey key: String) -> String {
    
    var key: String = ""
    let filePath = Bundle.main.path(forResource: resource, ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    if let value = plist!.object(forKey: key) as? String {
        key = value
    }
    
    return key
    
}
