//
//  Tweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Sasa's Macbook on 19/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import Foundation
import CoreData


extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet");
    }

    @NSManaged public var posted: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var unique: String?
    @NSManaged public var tweeter: TwitterUser?

}
