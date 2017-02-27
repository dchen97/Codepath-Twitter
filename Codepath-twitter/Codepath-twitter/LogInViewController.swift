//
//  LogInViewController.swift
//  Codepath-twitter
//
//  Created by Diana C on 2/23/17.
//  Copyright © 2017 Diana C. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LogInViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func onLoginButton(_ sender: Any) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "GHtENRfBhtsDFMUW0cOaDMPGF", consumerSecret: 	"t3eZta2rcIoaCQTvksodTSemV4uBRFlQyMOu7HahDroXnORdgO")
        
        twitterClient?.deauthorize()
        
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "mycodepath-twitter://oauth") as URL!, scope: nil, success: {(requestToken: BDBOAuth1Credential?) -> Void in
                print("I got a token!")
                let urlString = "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)! as String)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: urlString!)
                UIApplication.shared.openURL(url as! URL!)
        }, failure: {(error: Error?) -> Void in print("There was an error getting token.\n error:\(error?.localizedDescription)")})
        
        
    }

}
