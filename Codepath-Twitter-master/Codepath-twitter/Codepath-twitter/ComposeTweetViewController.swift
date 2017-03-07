//
//  ComposeTweetViewController.swift
//  Codepath-twitter
//
//  Created by Diana C on 3/6/17.
//  Copyright © 2017 Diana C. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tweetStatusLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetStatusLabel.isHidden = true
        textField.text = ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onTweetButton(_ sender: Any) {
        if (textField.text?.isEmpty)! {
            tweetStatusLabel.text = "Please enter your tweet into the text field."
            tweetStatusLabel.textColor = UIColor.red
            tweetStatusLabel.isHidden = false
        } else if ((textField.text?.characters.count)! > 140) {
            tweetStatusLabel.text = "Please enter a tweet that is under 140 characters.\nRight now, you have \((textField.text?.characters.count)!) characters."
            tweetStatusLabel.textColor = UIColor.red
            tweetStatusLabel.isHidden = false
        } else {
            TwitterClient.sharedInstance?.tweet(status: textField.text!, params: nil, success: { 
                self.tweetStatusLabel.text = "Tweeted successfully!"
                self.tweetStatusLabel.textColor = UIColor.green
                self.tweetStatusLabel.isHidden = false
                print("tweeted")
            }, failure: { (error: Error) in
                self.tweetStatusLabel.text = "Error tweeting. Please try again later."
                self.tweetStatusLabel.textColor = UIColor.red
                self.tweetStatusLabel.isHidden = false
                print(error.localizedDescription)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileFromCompose") {
            let profileVC = segue.destination as! ProfileViewController
            profileVC.user = User.currentUser!
        }
    }

}
