//
//  CollectionViewController.swift
//  Meme Me
//
//  Created by Paul Gaudin on 11/21/15.
//  Copyright © 2015 yours truly. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet var theCollection: UICollectionView!
    let identifier = "CellIdentifier"
    var memes: [Meme]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        theCollection.delegate = self
    }
    
    @IBAction func toMemeNew(sender: AnyObject) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.currentIndex = -1
        performSegueWithIdentifier("toMeme", sender: self)
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int{
        if let temp = memes{
            return temp.count
        }else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = (collectionView.frame.size.width/3)
        return CGSizeMake(size, size)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! Cell
        myCell.memeImage.image = memes![indexPath.item].memedImage
        return myCell
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.currentIndex = indexPath.item
        let indexNumber = indexPath
        performSegueWithIdentifier("toMeme", sender: indexNumber)
        return true
    }
    
}