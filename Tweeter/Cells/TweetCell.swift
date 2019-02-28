//
//  TweetCell.swift
//  Twitter
//
//  Created by Philip Yu on 2/20/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var tweetTimestamp: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var favorited:Bool = false
    var retweeted:Bool = false
    var tweetId: Int = -1
    
    @IBAction func favoriteTweet(_ sender: Any) {
        
        let toBeFavorited = !favorited
        
        if toBeFavorited {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(true)
                print("Favorited: ", self.favorited)
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(false)
                print("Favorited: ", self.favorited)
            }, failure: { (error) in
                print("Unfavorited did not succeed: \(error)")
            })
        }
        
    } // end favoriteTweet function
    
    @IBAction func retweet(_ sender: Any) {
        
        let toBeRetweeted = !retweeted
        
        if toBeRetweeted {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweeted(true)
                print("Retweeted: ", self.retweeted)
            }, failure: { (error) in
                print("Error in retweeting: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unretweet(tweetId: tweetId, success: {
                self.setRetweeted(false)
                print("Untweeted: ", self.retweeted)
            }, failure: { (error) in
                print("Error in unretweeting: \(error)")
            })
        }
        
    } // end retweet function
    
    func setRetweeted(_ isRetweeted:Bool) {
        
        retweeted = isRetweeted
        
        if retweeted == true {
            retweetButton.setImage(UIImage(named:"retweet-icon-green"), for: UIControl.State.normal)
        } else {
            retweetButton.setImage(UIImage(named:"retweet-icon"), for: UIControl.State.normal)
        }
        
    } // end setRetweeted function
    
    func setFavorited(_ isFavorited:Bool) {
        
        favorited = isFavorited
        
        if favorited {
            favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        } else {
            favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
        
    } // end setFavorited function
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    } // end awakeFromNib function
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    } // end setSelected function
    
} // end TweetCell class

extension UIImageView {
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func roundedBorders() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
}
