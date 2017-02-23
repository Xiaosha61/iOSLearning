//
//  TwitterUser+CoreDataClass.swift
//  Smashtag
//
//  Created by Sasa's Macbook on 19/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import Foundation
import CoreData
import Twitter


public class TwitterUser: NSManagedObject {
    
    class func twitterUserWithTwitterInfo(twitterInfo: Twitter.User, inManagedObjetContext context: NSManagedObjectContext) -> TwitterUser? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
        request.predicate = NSPredicate(format: "screenName = %@", twitterInfo.screenName)
        if let TwitterUser = (try? context.fetch(request))?.first as? TwitterUser {
            return TwitterUser
        } else if let twitterUser = NSEntityDescription.insertNewObject(forEntityName: "TwitterUser", into: context) as? TwitterUser {
            twitterUser.screenName = twitterInfo.screenName
            twitterUser.name = twitterInfo.name
            //
            return twitterUser
        }
        return nil
    }
    
}
