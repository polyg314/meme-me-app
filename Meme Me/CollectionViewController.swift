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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int{
        return 15
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! Cell
        
        
        myCell.memeImage.image = UIImage(named: "IMG_4849.jpg")
        
        return myCell
   
        
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