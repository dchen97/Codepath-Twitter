//
//  TweetsViewController.swift
//  Codepath-twitter
//
//  Created by Diana C on 2/27/17.
//  Copyright © 2017 Diana C. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            
            self.tableView.reloadData()
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetViewCell") as! TweetViewCell
        let tweet = tweets[indexPath.row]
        cell.favoritesLabel.text = "\((tweet.favoritesCount))"
        cell.repliesLabel.text = "0"
        cell.retweetsLabel.text = "\((tweet.retweetCount))"
        cell.usernameButton.setTitle("\((tweet.author?.name)!)", for: .normal)
        cell.scrennameLabel.text = "@\((tweet.author?.screenname)!)"
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute]
        formatter.unitsStyle = .brief
        let timestamp = formatter.string(from: tweet.timestamp!, to: NSDate() as Date)
        cell.timeLabel.text = "\((timestamp)!)"
        
        let avatarUrl = URL(string: "\((tweet.author?.profileUrl)!)")
        cell.avatarButton.setTitle("", for: .normal)
        cell.avatarButton.setImageFor(.normal, with: avatarUrl!)
        
        
        if (tweet.favorited) {
            cell.favoritesButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            cell.favoritesButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
        
        if (tweet.retweeted) {
            cell.retweetsButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            cell.retweetsButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
        
        cell.tweetLabel.text = tweet.text
        
        cell.replyButton.setImage(UIImage(named: "reply-icon"), for: .normal)
        
        cell.idString = tweet.idString
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let indexPath = tableView.indexPath(for: cell)
        if (segue.identifier == "goToTweetDetails") {
            let tweet = tweets[(self.tableView.indexPathForSelectedRow?.row)!]
            let detailViewController = segue.destination as! TweetDetailsViewController
            detailViewController.tweet = tweet
        } else if (segue.identifier == "profileFromFeed" || segue.identifier == "profileFromDetails" || segue.identifier == "profileFromAvatar") {
            let usernameButton = sender as! UIButton
            let location = usernameButton.subviews[0].convert(CGPoint.zero, to: self.tableView)
            let indexPath = tableView.indexPathForRow(at: location)
            let tweet = self.tweets[(indexPath?.row)!]
            let profileVC = segue.destination as! ProfileViewController
            profileVC.user = tweet.author
            print("\(tweet.author?.screenname)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "goToTweetDetails", sender: self)
    }

}

extension UITableView {
    func indexPath(for view: UIView) -> IndexPath? {
        let location = view.convert(CGPoint.zero, to: self)
        return self.indexPathForRow(at: location)
    }
}
