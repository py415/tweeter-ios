//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Philip Yu on 2/20/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
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
        
    } // end viewDidAppear function
    
    @objc func loadTweets() {
        
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets!: \(Error)")
        })
        
    } // end loadTweets function
    
    func loadMoreTweets() {
        
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            print("Loading more tweets")
            
        }, failure: { (Error) in
            print("Could not retrieve more tweets!: \(Error)")
        })
        
    } // end loadMoreTweets function
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
        
    } // end tableView(willDisplay) function
    
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
        
    } // end getRelativeTime function
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let entities = tweetArray[indexPath.row]["entities"] as! NSDictionary
        
        cell.profileImageView.roundedImage()
        cell.mediaImageView.roundedBorders()
        cell.userNameLabel.text = user["name"] as? String
        let screen_name = user["screen_name"] as? String
        cell.screenNameLabel.text = "@\(screen_name!)"
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String
        cell.tweetTimestamp.text = getRelativeTime(timeString: (tweetArray[indexPath.row]["created_at"] as? String)!)
        
        let favorite_count = tweetArray[indexPath.row]["favorite_count"] as? Int
        cell.favoriteCountLabel.text = "\(favorite_count!)"
        let retweet_count = tweetArray[indexPath.row]["retweet_count"] as? Int
        cell.retweetCountLabel.text = "\(retweet_count!)"
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        if let media = entities.value(forKey: "media") as? [[String:Any]], !media.isEmpty,
            let mediaUrl = URL(string: (media[0]["media_url_https"] as? String)!) {
            let data = try? Data(contentsOf: mediaUrl)
            let mediaType = (media[0]["type"] as? String)!
            
            if mediaType == "photo" {
                if let mediaData = data {
                    cell.mediaImageView.image = UIImage(data: mediaData)
                }
            }
        }
        
        cell.setFavorited(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        cell.setNeedsUpdateConstraints()
        cell.setNeedsLayout()
        
        return cell
        
    } // end tableView(cellForRowAt) function
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    } // end numberOfSections function
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweetArray.count
        
    } // end tableView(numberOfRowsInSection) function
    
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
    } // end timeAgoDisplay function
    
} // end Date extension
