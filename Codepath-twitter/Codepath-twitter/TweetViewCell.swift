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

//    @IBAction func onRetweetButton(_ sender: Any) {
//        if (!retweeted) {
//            TwitterClient.sharedInstance?.retweet(idString: self.id!, success: { 
//                print("Retweeted!")
//            }, failure: { (error: Error) in
//                print("Error retweeting: \(error)")
//            })
//        } else {
//            
//        }
//    }
}
