//
//  TweetDetailsViewController.swift
//  Codepath-twitter
//
//  Created by Diana C on 3/4/17.
//  Copyright © 2017 Diana C. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var screennameLabel: UILabel!
    
    var tweet: Tweet?
    
    //@IBOutlet weak var backButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameLabel.text = "\((tweet?.author?.name)!)"
        self.screennameLabel.text = "@\((tweet?.author?.screenname)!)"
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute]
        formatter.unitsStyle = .brief
        let timestamp = formatter.string(from: (tweet?.timestamp)!, to: NSDate() as Date)
        self.timeLabel.text = "\((timestamp)!)"
        self.tweetLabel.text = "\((tweet?.text)!)"
        self.favoritesLabel.text = "\((tweet?.favoritesCount)!)"
        self.repliesLabel.text = "0"
        self.retweetLabel.text = "\((tweet?.retweetCount)!)"
        
        let avatarUrl = URL(string: "\((tweet?.author?.profileUrl)!)")
        self.userAvatarImageView.setImageWith(avatarUrl!)
        
        if (tweet?.favorited)! {
            self.favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            self.favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
        
        if (tweet?.retweeted)! {
            self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
        
        self.replyButton.setImage(UIImage(named: "reply-icon"), for: .normal)

        // Do any additional setup after loading the view.
        print("\(tweet?.text)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        if (self.tweet?.retweeted)! == false {
            TwitterClient.sharedInstance?.retweet(idString: (tweet?.idString)!, params: nil, success: {
                    self.tweet?.retweeted = true
                    self.tweet?.retweetCount += 1
                    self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
                    self.retweetLabel.text = "\((Int(self.retweetLabel.text!)! + 1))"
            }, failure: { (error: Error?) in
                print("\(error?.localizedDescription)")
            })
        }
    }
    @IBAction func onFavoriteButton(_ sender: Any) {
        if (self.tweet?.favorited)! {
            TwitterClient.sharedInstance?.unfavorite(idString: (self.tweet?.idString)!, params: nil, success: {
                self.tweet?.favorited = false
                self.tweet?.favoritesCount -= 1
                self.favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
                self.favoritesLabel.text = "\((Int(self.favoritesLabel.text!)! - 1))"
            }, failure: { (error: Error?) in
                print("\(error?.localizedDescription)")
            })
        }
        TwitterClient.sharedInstance?.favorite(idString: (self.tweet?.idString)!, params: nil, success: {
                self.tweet?.favorited = true
                self.tweet?.favoritesCount += 1
                self.favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
            self.favoritesLabel.text = "\((Int(self.favoritesLabel.text!)! + 1))"
        }, failure: { (error: Error?) in
            print("\(error?.localizedDescription)")
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
