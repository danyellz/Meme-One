//
//  MemeTableViewController.swift
//  Meme One
//
//  Created by TY on 2/21/16.
//  Copyright © 2016 Kinectic. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!{
        let object  = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(animated: Bool) {
        if memes.count == 0{
            newMemeAlert()
        }
        tableView!.reloadData()
    }
    
    func newMemeAlert(){
        let alert = UIAlertView()
        alert.title = "Woops!"
        alert.message = "It looks like you haven't created any Memes just yet. Press '+' to start!"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell") as! MemeTableViewCell!
        let meme = self.memes[indexPath.row]
        
        cell.memeImageView?.image = meme.image
        cell.memeTopText?.text = meme.topText
        cell.memeBottomText?.text = meme.bottomText
        
        cell.memeImageView.contentScaleFactor = UITableViewAutomaticDimension
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView") as! MemeDetailView
        detailViewController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    
    
    
    
}
