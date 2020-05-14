//
//  Constants.swift
//  Tweeter
//
//  Created by Philip Yu on 5/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit


struct Constants {
    
    static let consumerKey = fetchFromPlist(forResource: "ApiKeys", forKey: "CONSUMER_KEY")
    static let consumerSecret = fetchFromPlist(forResource: "ApiKeys", forKey: "CONSUMER_SECRET")
    static let authURL = "https://api.twitter.com/oauth/request_token"
    static let userURL = "https://api.twitter.com/1.1/account/verify_credentials.json"
    static let homeTimelineURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    static let userTimelineURL = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    static let updateURL = "https://api.twitter.com/1.1/statuses/update.json"
    static let favoriteURL = "https://api.twitter.com/1.1/favorites/create.json"
    static let unfavoriteURL = "https://api.twitter.com/1.1/favorites/destroy.json"
    
    static func fetchFromPlist(forResource resource: String, forKey key: String) -> String? {
        
        let filePath = Bundle.main.path(forResource: resource, ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)
        let value = plist?.object(forKey: key) as? String
        
        return value
        
    }
    
    static func getRelativeTime(timeString: String) -> String {
        
        let time:Date
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        time = dateFormatter.date(from: timeString)!
        
        return time.timeAgoDisplay()
        
    }
    
    static func makeImageCircular(_ image: UIImageView) {
        
        image.layer.cornerRadius = image.frame.size.height / 2
        image.clipsToBounds = true
        
    }
    
    static func makeImageRounded(_ image: UIImageView, roundness: CGFloat) {
        
        image.layer.cornerRadius = roundness
        image.clipsToBounds = true
        
    }
    
    static func makeButtonRounded(_ button: UIButton, roundness: CGFloat) {
        
        button.layer.cornerRadius = roundness
        button.clipsToBounds = true
        
    }
    
    static func makeTextViewRounded(_ textView: UITextView, roundness: CGFloat, borderWidth: CGFloat) {
        
        textView.layer.cornerRadius = roundness
        textView.layer.borderWidth = borderWidth
        textView.clipsToBounds = true
        
    }
    
}

extension Date {
    
    func timeAgoDisplay() -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / 60) minutes ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / 60 / 60) hours ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / 60 / 60 / 24) days ago"
        }
        
        return "\(secondsAgo / 60 / 60 / 24 / 7) weeks ago"
        
    }
    
}
