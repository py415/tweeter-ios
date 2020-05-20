//
//  TweetCell.swift
//  Tweeter
//
//  Created by Philip Yu on 5/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    // MARK: - Properties
    private var favorited: Bool = false
    private var retweeted: Bool = false
    var tweetId: Int = -1
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        Constant.makeImageCircular(profileImageView)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
    func setFavorite(_ isFavorited: Bool) {
        
        favorited = isFavorited
        
        if favorited {
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
        
    }
    
    func setRetweet(_ isRetweeted: Bool) {
        
        retweeted = isRetweeted
        
        if retweeted {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
        
    }
    
    // MARK: - IBAction Section

    @IBAction func favoriteTapped(_ sender: UIButton) {
        
        let toBeFavorited = !favorited
        
        if toBeFavorited {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (error) in
                print("Failed to favorite tweet, \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (error) in
                print("Failed to unfavorite tweet, \(error)")
            })
        }
        
    }
    
    @IBAction func retweetTapped(_ sender: UIButton) {
        
        let toBeRetweeted = !retweeted
        
        if toBeRetweeted {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweet(true)
            }, failure: { (error) in
                print("Failed to retweet, \(error)")
            })
        } else {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweet(false)
            }, failure: { (error) in
                print("Failed to unretweet, \(error)")
            })
        }
        
    }
    
}
