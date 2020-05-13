//
//  Constants.swift
//  Tweeter
//
//  Created by Philip Yu on 5/12/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import Foundation

struct Constants {

    static let consumerKey = fetchFromPlist(forResource: "ApiKeys", forKey: "CONSUMER_KEY")
    static let consumerSecret = fetchFromPlist(forResource: "ApiKeys", forKey: "CONSUMER_SECRET")
    
}


