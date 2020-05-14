//
//  ProfileViewController.swift
//  Tweeter
//
//  Created by Philip Yu on 5/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var userId: Int? = 0
    private var tweetArray = [NSDictionary]()
    private var numberOfTweets: Int!
    private let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        Constants.makeImageCircular(profileImageView)
        
        // Pull to refresh
        myRefreshControl.addTarget(self, action: #selector(loadUserData), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        numberOfTweets = 20
        loadUserData()
        
    }
    
    // MARK: - Private Function Section
    
    @objc private func loadUserData() {
        
        let myParams = ["skip_status": true]
        
        TwitterAPICaller.client?.getDictionaryRequest(url: Constants.userURL, parameters: myParams, success: { (userData: NSDictionary) in
            let username = userData["screen_name"] as! String
            let following = userData["friends_count"] as! Int
            let followers = userData["followers_count"] as! Int
            let favorites = userData["favourites_count"] as! Int

            self.displayName.text = userData["name"] as? String
            self.usernameLabel.text = "@\(username)"
            self.followingLabel.text = "\(following) Following"
            self.followersLabel.text = "\(followers) Followers"
            self.favoritesLabel.text = "\(favorites) Favorites"
            
            // Profile image
            var imageUrlString = userData["profile_image_url_https"] as! String
            imageUrlString = imageUrlString.replacingOccurrences(of: "normal", with: "bigger")

            let imageUrl = URL(string: imageUrlString)
            let data = try? Data(contentsOf: imageUrl!)
            
            if let imageData = data {
                self.profileImageView.image = UIImage(data: imageData)
            }
            
            self.loadTweets(for: username)
        }, failure: { (error) in
            print("[\(type(of: self))] Failed to get logged in user profile data — \(error)")
        })
        
    }
    
    private func loadTweets(for screenName: String) {
        
        let myParams = ["screen_name": screenName, "count": numberOfTweets!] as [String: Any]
        
        // Load tweets
        TwitterAPICaller.client?.getDictionariesRequest(url: Constants.userTimelineURL, parameters: myParams as [String: Any], success: { (tweets: [NSDictionary]) in
            print("[\(type(of: self))] Load tweets...")
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (error) in
            print("[\(type(of: self))] Failed to load tweets  — \(error.localizedDescription)")
        })
        
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweetArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let screenName = user["screen_name"] as! String
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        let dateString = tweetArray[indexPath.row]["created_at"] as! String
        let favoriteCount = tweetArray[indexPath.row]["favorite_count"] as! Int
        let retweetCount = tweetArray[indexPath.row]["retweet_count"] as! Int
        let extendedEntities = tweetArray[indexPath.row]["extended_entities"] as? NSDictionary
        
        cell.nameLabel.text = user["name"] as? String
        cell.screenNameLabel.text = "@\(screenName)"
        cell.createdAtLabel.text = Constants.getRelativeTime(timeString: dateString)
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.setRetweet(tweetArray[indexPath.row]["retweeted"] as! Bool)
        cell.favoriteCount.text = "\(favoriteCount)"
        cell.retweetCount.text = "\(retweetCount)"
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        if let media = extendedEntities?["media"] as? [NSDictionary] {
            cell.mediaImageView.isHidden = false
            
            let urlString = media[0]["media_url_https"] as? String
            let url = URL(string: urlString!)
            let data = try? Data(contentsOf: url!)
            let type = media[0]["type"] as? String
            
            if type == "photo" {
                if let mediaData = data {
                    Constants.makeImageRounded(cell.mediaImageView, roundness: 20)
                    cell.mediaImageView.image = UIImage(data: mediaData)
                }
            }
        } else {
            // No media found
            cell.mediaImageView.isHidden = true
        }
        
        return cell
        
    }
    
    // MARK: - UITableViewDelegate Section
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
