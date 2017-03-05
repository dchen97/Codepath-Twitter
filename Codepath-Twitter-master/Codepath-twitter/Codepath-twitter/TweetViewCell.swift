//
//  TweetViewCell.swift
//  Codepath-twitter
//
//  Created by Diana C on 2/27/17.
//  Copyright © 2017 Diana C. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scrennameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetsButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    var idString: String?
    
    var favorited: Bool = false
    var retweeted: Bool = false
    var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

    @IBAction func onRetweetButton(_ sender: Any) {
        print(idString!)
        TwitterClient.sharedInstance?.retweet(idString: idString!, params: nil, success: {
            print("retweeted")
            self.retweetsButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            self.retweetsLabel.text = "\(Int(self.retweetsLabel.text!)! + 1)"
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        if (!favorited) {
            TwitterClient.sharedInstance?.favorite(idString: idString!, params: nil, success: {
                self.favorited = true
                self.favoritesButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
                self.favoritesLabel.text = "\(Int(self.favoritesLabel.text!)! + 1)"
                print("favorited")
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.unfavorite(idString: idString!, params: nil, success: {
                self.favorited = false
                self.favoritesButton.setImage(UIImage(named: "favor-icon"), for: .normal)
                self.favoritesLabel.text = "\(Int(self.favoritesLabel.text!)! - 1)"
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            print("unfavorited")
        }
    }
    
    func onTweetSelect() {
        
    }
    
}
