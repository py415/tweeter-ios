//
//  HomeViewController.swift
//  Tweeter
//
//  Created by Philip Yu on 5/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var tweetArray = [NSDictionary]()
    private var numberOfTweets: Int!
    private let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set view controller as delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // Pull to refresh
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        // Load tweets
        numberOfTweets = 20
        loadTweets()
        
    }
    
    // MARK: - Private Function Section
    
    @objc private func loadTweets() {
        
        let myParams = ["count": numberOfTweets]
        
        // Load tweets
        TwitterAPICaller.client?.getDictionariesRequest(url: Constants.homeTimelineURL, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
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
    
    private func loadMoreTweets() {
        
        numberOfTweets = numberOfTweets + 20
        let myParams = ["count": numberOfTweets]
        
        // Load more tweets
        TwitterAPICaller.client?.getDictionariesRequest(url: Constants.homeTimelineURL, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            print("[\(type(of: self))] Load more tweets...")
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
        }, failure: { (error) in
            print("[\(type(of: self))] Failed to load tweets — \(error.localizedDescription)")
        })
        
    }
    
    // MARK: - IBAction Function Section
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        
        print("\(type(of: self)): Logout button pressed.")
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
        
    }
    
}
