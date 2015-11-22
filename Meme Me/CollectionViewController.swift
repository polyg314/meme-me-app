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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        print("Mememememems")
        print(memes)
//        print(memes!.count)
        
    }
    
    
    
    
//    override func viewWillLayoutSubviews() {
////        
////        theCollection.collectionViewLayout.invalidateLayout()
//    }
//    

//    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int{
        
        if let temp = memes{
                        print(temp.count)
            return temp.count
            

            
        }else{
            
            print("ummm")
        
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath.item)
        
    }

    
//    override func collectionView(collectionView: UICollectionView, forItem
//    
////    override func collectionView(collectionView:UICollectionView, canPerformAction action: Selector,forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool{
////    
////        
////    
////    }
////    
//    
//    
    
}