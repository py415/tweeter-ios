//
//  TweetViewController.swift
//  Tweeter
//
//  Created by Philip Yu on 2/24/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tweetTextView.delegate = self
        
        // Rounded tweet text view border
        tweetTextView.becomeFirstResponder()
        tweetTextView.layer.cornerRadius = 20
        tweetTextView.layer.borderWidth = 1
        tweetTextView.layer.borderColor = UIColor.black.cgColor
        tweetTextView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        
    } // end viewDidLoad function
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Set the max character limit
        let characterLimit = 140
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // TODO: Update Character Count Label
        characterCountLabel.text = "\(newText.count)"
        
        if newText.count >= (characterLimit - 20) {
            characterCountLabel.textColor = UIColor.red
        } else {
            characterCountLabel.textColor = UIColor.black
        }
        
        // The new text should be allowed? True/False
        return newText.count < characterLimit
        
    } // end textView function
    
    @IBAction func cancelTweet(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    } // end cancelTweet function
    
    
    @IBAction func tweetMessage(_ sender: Any) {
        
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet: \(error)")
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
