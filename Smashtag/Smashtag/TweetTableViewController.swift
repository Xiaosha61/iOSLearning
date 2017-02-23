//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Sasa's Macbook on 18/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController , UITextFieldDelegate {
    
    
    // MARK: Model
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
    //each array of tweet is a fetch.
    // a section is a fetch
    // a row is one the tweet inside this fetch
    var tweets = [Array<Twitter.Tweet>]() {
        didSet{
            tableView.reloadData() //== make all code in MARK: -UITableViewDataSource to be called again
        }
    }
    
    // part of the model: only display the searched tweets
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }
    
    //this computed property var is used as the request.
    private var twitterRequest: Twitter.TwitterRequest? {
        if let query = searchText, !query.isEmpty {
            return Twitter.TwitterRequest(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.TwitterRequest?
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets{ [weak weakSelf = self] newTweets in // trailing closure syntax
                DispatchQueue.main.async { // trailing closure syntax
                    if request === weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, at: 0)
                            weakSelf?.updataDatabase(newTweets: newTweets)
                        }
                    }
                }
            }
        }
    }
    
    private func updataDatabase(newTweets: [Twitter.Tweet]) { //Tweet from the Twitter framework
        
        // this will be async, returns immediately, then "done printing... " print immediately, then this block will be exe.
        managedObjectContext?.perform { //closure trailing syntax
            for twitterInfo in newTweets {
                //create a new, unique Tweet(NSManagedObject) to coredata with that Twitter info(from network)
                _ = Tweet.tweetWithTwitterInfo(twitterInfo: twitterInfo, inManagedObjectContext: self.managedObjectContext!) // _= means I don't care the return result
            }
            do{
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error: \(error)")
            }
            
        }
        printDatabaseStatistics()
        print("done printing database statistics")
    }
    
    private func printDatabaseStatistics() {
        managedObjectContext?.perform({
            // fetch's result is an Array<NSManagedObject>
            // the objects that are in this managedObjectContext with entityName = "TwitterUser"
            if let results = try? self.managedObjectContext!.fetch(NSFetchRequest(entityName: "TwitterUser")) {
                print("\(results.count) TwitterUsers")
            }
            
            // a more memory-efficient way to count objects.
            // just count, not loading into memory
            let tweetCount = try? self.managedObjectContext!.count(for: NSFetchRequest(entityName: "Tweet"))  //this returns an Optional Int.
            if let tc = tweetCount {
                print("\(tc) Tweets")
            }
            
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TweetersMentioningSearchTerm" {
            if let tweetersTVC = segue.destination as? TweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.managedObjectContext = managedObjectContext
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight // the estimated
        tableView.rowHeight = UITableViewAutomaticDimension // I can calculate it
        //searchText = "#xxsstweet"
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)

        // Configure the cell...
        let tweet = tweets[indexPath.section][indexPath.row]
      
        if let tweetCell = cell as? TweetTableViewCell { //we have our customized cell
            tweetCell.tweet = tweet
        } else { //if no, use the default
            cell.textLabel?.text = tweet.text
            cell.detailTextLabel?.text = tweet.user.name
        }
        
        return cell
    }
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
