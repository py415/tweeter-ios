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
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var tweetTimestamp: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var favorited:Bool = false
    var tweetId: Int = -1
    
    @IBAction func favoriteTweet(_ sender: Any) {
        
        let toBeFavorited = !favorited
        
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(true)
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(false)
            }, failure: { (error) in
                print("Unfavorited did not succeed: \(error)")
            })
        }
        
    } // end favoriteTweet function
    
    @IBAction func retweet(_ sender: Any) {
    } // end retweet function
    
    func setFavorited(_ isFavorited:Bool) {
        
        favorited = isFavorited
        
        if (favorited) {
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
