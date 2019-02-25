//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Philip Yu on 2/20/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArr = [NSDictionary]()
    var numOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        numOfTweets = 20
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
    } // end viewDidLoad function
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.loadTweets()
        
    } // end viewDidAppear
    
    @objc func loadTweets() {
        
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetArr.removeAll()
            
            for tweet in tweets {
                self.tweetArr.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets!")
        })
        
    } // end loadTweets function
    
    func loadMoreTweets() {
        
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetArr.removeAll()
            
            for tweet in tweets {
                self.tweetArr.append(tweet)
            }
            
            self.tableView.reloadData()
            print("Loading more tweets")
            
        }, failure: { (Error) in
            print("Could not retrieve tweets!")
        })
        
    } // end loadMoreTweets function
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == tweetArr.count {
            loadMoreTweets()
        }
        
    } // end tableView function
    
    @IBAction func onLogout(_ sender: Any) {
        
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        
    } // end onLogout function
    
    func getRelativeTime(timeString: String) -> String {
        
        let time:Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        time = dateFormatter.date(from: timeString)!
        return time.timeAgoDisplay()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        let user = tweetArr[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweetArr[indexPath.row]["text"] as? String
        cell.tweetTimestamp.text = getRelativeTime(timeString: (tweetArr[indexPath.row]["created_at"] as? String)!)
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorited(tweetArr[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArr[indexPath.row]["id"] as! Int
        
        return cell
        
    } // end tableView function
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    } // end numberOfSections function
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArr.count
    } // end tableView function
    
} // end HomeTableViewController class

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
