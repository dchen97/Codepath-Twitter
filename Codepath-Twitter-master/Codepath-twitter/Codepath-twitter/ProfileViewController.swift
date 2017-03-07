//
//  ProfileViewController.swift
//  Codepath-twitter
//
//  Created by Diana C on 3/5/17.
//  Copyright © 2017 Diana C. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print((user?.name)!)
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        self.navigationController?.title = "\((user?.name)!)"
        
        usernameLabel.text = user?.name!
        screennameLabel.text = user?.screenname!
        
        let avatarUrl = URL(string: "\((user?.profileUrl)!))")
        print((user?.profileUrl)!)
        self.profileImageView.setImageWith(avatarUrl!)
        
        let backgroundUrl = URL(string: "\((user?.profileBackgroundUrl)!)")
        backgroundImageView.setImageWith(backgroundUrl!)
        
        tweetCountLabel.text = "\((user?.tweetCount)!)"
        followingCountLabel.text = "\((user?.followingCount)!)"
        followerCountLabel.text = "\((user?.followerCount)!)"
        
        
        
        // Do any additional setup after loading the view.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTweetCell") as! ProfileTweetsTableViewCell
        
        let tweet = tweets?[indexPath.row]
        let avatarUrl = URL(string: "\(user?.profileUrl!)")
        if let pictureData = NSData(contentsOf: avatarUrl!) {
            let image = UIImage(data: pictureData as Data)
            cell.avatarButton.setImage(image, for: .normal)
        }
        //cell.avatarButton.imageView?.setImageWith(avatarUrl!)
        
        cell.favoritesLabel.text = "\((tweet?.favoritesCount))"
        cell.repliesLabel.text = "0"
        cell.retweetsLabel.text = "\((tweet?.retweetCount))"
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selfFromProfile") {
            let profileVC = segue.destination as! ProfileViewController
            profileVC.user = User.currentUser!
        }
    }

}
