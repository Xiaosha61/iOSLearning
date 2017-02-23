//
//  Tweet+CoreDataClass.swift
//  Smashtag
//
//  Created by Sasa's Macbook on 19/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import Foundation
import CoreData
import Twitter


public class Tweet: NSManagedObject {
    //if exist already, just return it, otherwise, create a new, unique tweet object from network version
    class func tweetWithTwitterInfo(twitterInfo: Twitter.Tweet, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet") // which entity to fetch
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id!) //NSPredicate
        
        if let tweet = (try? context.fetch(request))?.first as? Tweet {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObject(forEntityName: "Tweet", into: context) as? Tweet {
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created
            tweet.tweeter = TwitterUser.twitterUserWithTwitterInfo(twitterInfo: twitterInfo.user, inManagedObjetContext: context)  // tweeterUser.tweets will get as one of NSSet automatically
            return tweet
            
        }
        // less concise but identical with the above if block
        /*
         do{
            let queryResults = try context.fetch(request) //returns an array
            if let tweet = queryResults.first as? Tweet {
                return tweet
            }
         } catch let error {
            // ignore error
         }
         */
        
        return nil
    }
}
