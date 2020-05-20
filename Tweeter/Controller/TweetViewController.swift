//
//  TweetViewController.swift
//  Tweeter
//
//  Created by Philip Yu on 5/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var composeButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        
        Constant.makeTextViewRounded(tweetTextView, roundness: 15, borderWidth: 1)
        Constant.makeButtonRounded(composeButton, roundness: 15)
        
    }
    
    // MARK: - IBAction Section
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        
        print("\(type(of: self)): Cancel button pressed.")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func composeButtonPressed(_ sender: UIButton) {
        
        if !tweetTextView.text.isEmpty {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                print("[\(type(of: self))] Successfully posted tweet.")
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("[\(type(of: self))] Failed to compose tweet — \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}

extension TweetViewController: UITextViewDelegate {
    
    // MARK: - UITextViewDelegate Section
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Set the max character limit
        let characterLimit = 140

        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)

        // Update character count Label
        characterCountLabel.text = "\(newText.count)"
        
        // Change character count label color if label is almost at limit
        if newText.count >= (characterLimit - 20) {
            characterCountLabel.textColor = UIColor.red
        } else {
            characterCountLabel.textColor = UIColor.black
        }

        // The new text should be allowed? True/False
        return newText.count < characterLimit
        
    }
    
}
