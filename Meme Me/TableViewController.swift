//
//  CollectionViewController.swift
//  Meme Me
//
//  Created by Paul Gaudin on 11/21/15.
//  Copyright © 2015 yours truly. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    
    @IBOutlet var theCells: UITableView!
    let identifier = "TableCellIdentifier"
    var memes: [Meme]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        theCells.delegate = self
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "new", style: .Plain, target: self, action: "newMeme")
    }
    
    
    func newMeme() {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.currentIndex = -1
        performSegueWithIdentifier("toMemeFromTable", sender: self)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let temp = memes{
            return temp.count
        }else{
            print("there were none")
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let thisCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! TableCell
            thisCell.bottomLabel.text = memes![indexPath.item].bottomText
            thisCell.topLabel.text = memes![indexPath.item].topText
            thisCell.previewImage.image = memes![indexPath.item].image
            return thisCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as! AppDelegate
                appDelegate.currentIndex = indexPath.item
                let indexNumber = indexPath
        
                performSegueWithIdentifier("toMemeFromTable", sender: indexNumber)
    }

    
}