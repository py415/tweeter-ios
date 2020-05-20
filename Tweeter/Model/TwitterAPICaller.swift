//
//  APIManager.swift
//  Twitter
//
//  Created by Dan on 1/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterAPICaller: BDBOAuth1SessionManager {
    
    // MARK: - Properties
    private var loginSuccess: (() -> Void)?
    private var loginFailure: ((Error) -> Void)?
    
    static let client = TwitterAPICaller(baseURL: URL(string: "https://api.twitter.com"), consumerKey: Constant.consumerKey, consumerSecret: Constant.consumerSecret)
    
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        TwitterAPICaller.client?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (_: BDBOAuth1Credential!) in
            self.loginSuccess?()
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
        
    }
    
    func login(url: String, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterAPICaller.client?.deauthorize()
        TwitterAPICaller.client?.fetchRequestToken(withPath: url, method: "GET", callbackURL: URL(string: "alamoTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            UIApplication.shared.open(url)
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        })
        
    }
    
    func logout () {
        
        deauthorize()
        
    }
    
    func getDictionaryRequest(url: String, parameters: [String: Any], success: @escaping (NSDictionary) -> Void, failure: @escaping (Error) -> Void) {
        
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            success(response as! NSDictionary)
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func getDictionariesRequest(url: String, parameters: [String: Any], success: @escaping ([NSDictionary]) -> Void, failure: @escaping (Error) -> Void) {
        
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            success(response as! [NSDictionary])
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func postRequest(url: String, parameters: [Any], success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        TwitterAPICaller.client?.post(url, parameters: parameters, progress: nil, success: { (_: URLSessionDataTask, _: Any?) in
            success()
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func postTweet(tweetString: String, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        TwitterAPICaller.client?.post(Constant.updateURL, parameters: ["status": tweetString], progress: nil, success: { (_: URLSessionDataTask, _: Any?) in
            success()
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func favoriteTweet(tweetId: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        TwitterAPICaller.client?.post(Constant.favoriteURL, parameters: ["id": tweetId], progress: nil, success: { (_: URLSessionDataTask, _: Any?) in
            success()
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func unfavoriteTweet(tweetId: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        TwitterAPICaller.client?.post(Constant.unfavoriteURL, parameters: ["id": tweetId], progress: nil, success: { (_: URLSessionDataTask, _: Any?) in
            success()
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func retweet(tweetId: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        let retweetURL = "https://api.twitter.com/1.1/statuses/retweet/\(tweetId).json"
        
        TwitterAPICaller.client?.post(retweetURL, parameters: ["id": tweetId], progress: nil, success: { (_: URLSessionDataTask, _: Any?) in
            success()
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
}
