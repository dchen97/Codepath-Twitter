//
//  Tweet.swift
//  Codepath-twitter
//
//  Created by Diana C on 2/27/17.
//  Copyright © 2017 Diana C. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var favorited: Bool = false
    var retweeted: Bool = false
    var author: User?
    var idString: String?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        favorited = (dictionary["favorited"] as? Bool) ?? false
        retweeted = (dictionary["retweeted"] as? Bool) ?? false
        idString = (dictionary["id_str"] as? String) ?? ""
        
        let userDict = dictionary["user"]
        author = User(dictionary: (userDict as? NSDictionary)!)
        
        let timestampString = dictionary["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        timestamp = formatter.date(from: timestampString!)!
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }

}
