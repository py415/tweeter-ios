//
//  TweetViewController.swift
//  Tweeter
//
//  Created by Philip Yu on 2/24/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
        
    } // end viewDidLoad function
    
    @IBAction func cancelTweet(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    } // end cancelTweet function
    
    
    @IBAction func tweetMessage(_ sender: Any) {
        
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    } // end tweetMessage function
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
