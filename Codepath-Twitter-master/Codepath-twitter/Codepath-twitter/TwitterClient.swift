//
//  TwitterClient.swift
//  Codepath-twitter
//
//  Created by Diana C on 2/27/17.
//  Copyright © 2017 Diana C. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    

    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "GHtENRfBhtsDFMUW0cOaDMPGF", consumerSecret: 	"t3eZta2rcIoaCQTvksodTSemV4uBRFlQyMOu7HahDroXnORdgO")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) ->())?
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        TwitterClient.sharedInstance?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask?, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
    
        }, failure: {(task: URLSessionDataTask?, error: Error?) -> Void in
            failure(error!)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        TwitterClient.sharedInstance?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask?, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: {(task: URLSessionDataTask?, error: Error?) -> Void in
            failure(error!)
        })
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "mycodepath-twitter://oauth") as URL!, scope: nil, success: {(requestToken: BDBOAuth1Credential?) -> Void in
            print("I got a token!")
            let urlString = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)"
            let url = URL(string: urlString)!
            UIApplication.shared.openURL(url as URL)
        }, failure: {(error: Error?) -> Void in
            self.loginFailure?(error!)
        })
        

    }
    
    func unfavorite(idString: String, params: NSDictionary?, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/destroy.json?id=\(idString)", parameters: params, success: { (task: URLSessionDataTask, response: Any?) in
                success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    //func untweet()
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "currentUserData")
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "https://api.twitter.com/oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential?) -> Void in
            print("Got access token")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
            
        }, failure: {(error: Error?) -> Void in
            self.loginFailure?(error!)
        })
    }
    
    func retweet(idString: String, params: NSDictionary?, success: @escaping () -> (), failure: @escaping(Error) -> ()){
        post("1.1/statuses/retweet/\(idString).json", parameters: params, progress: nil, success: { (task: URLSessionDataTask,response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func unretweet(idString: String, params: NSDictionary?, success: @escaping () -> (), failure: @escaping(Error) -> ()) {
        post("1.1/statuses/unretweet/\(idString).json", parameters: params, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func favorite(idString: String, params: NSDictionary?, success: @escaping () -> (), failure: @escaping(Error) -> ()) {
        post("1.1/favorites/create.json?id=\(idString)", parameters: params, progress: nil, success: {(task: URLSessionDataTask, response: Any?) in
                success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
}
