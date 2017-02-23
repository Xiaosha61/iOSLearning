//
//  TweetersTableViewController.swift
//  Smashtag
//
//  Created by Sasa's Macbook on 19/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import UIKit
import CoreData

class TweetersTableViewController: CoreDataTableViewController {
    
    
    var mention: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet{ updateUI() } }
    
    private func updateUI(){
        if let metionCharactersCount = mention?.characters.count {
            if metionCharactersCount > 0 {
                if let context = managedObjectContext {
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
                    request.predicate = NSPredicate(format: "any tweets.text contains[c] %@ and !screenName beginswith[c] %@", mention!, "darkside")
                    request.sortDescriptors = [NSSortDescriptor(
                        key: "screenName", // the must be one of the user's property.
                        ascending: true,
                        selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                    )]
                    fetchedResultsController = NSFetchedResultsController(
                        fetchRequest: request,
                        managedObjectContext: context,
                        sectionNameKeyPath: nil,
                        cacheName: nil)
                } else {
                    fetchedResultsController = nil
                }
            }
        }
        
    }
    
    private func tweetCountWithMentionByTwitterUser(user: TwitterUser) -> Int? {
        
        var count: Int?
        
        user.managedObjectContext?.performAndWait { //do it synchronously
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")
            request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@", self.mention!, user)
            count = try! user.managedObjectContext?.count(for: request)
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUserCell", for: indexPath)

        // Configure the cell...
        if let twitterUser = fetchedResultsController?.object(at: indexPath) as? TwitterUser {
            var screenName: String?
            twitterUser.managedObjectContext?.performAndWait { // this might be executed in other queue.
                screenName = twitterUser.screenName
            }
            cell.textLabel?.text = screenName // UI-related.
            if let count  = tweetCountWithMentionByTwitterUser(user: twitterUser) {
                cell.detailTextLabel?.text = (count == 1) ? "1 tweet" : "\(count) tweets"
            } else {
                cell.detailTextLabel?.text = ""
            }
        }

        return cell
    }
}
