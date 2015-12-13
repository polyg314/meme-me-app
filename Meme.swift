//
//  Meme.swift
//  Meme Me
//
//  Created by Paul Gaudin on 11/20/15.
//  Copyright © 2015 yours truly. All rights reserved.
//

import Foundation
import UIKit

class Meme{

    let topText: String
    let bottomText: String
    let image: UIImage
    let memedImage:UIImage
    let bottomSpacing: NSLayoutConstraint
    let bottomTrailing: NSLayoutConstraint
    let bottomLeading: NSLayoutConstraint
    let topTextYConstraint: NSLayoutConstraint
    let topTextXConstraint: NSLayoutConstraint
    let topTextX2Constraint: NSLayoutConstraint

    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage, bottomSpacing: NSLayoutConstraint, bottomTrailing: NSLayoutConstraint, bottomLeading: NSLayoutConstraint, topTextYConstraint: NSLayoutConstraint, topTextXConstraint: NSLayoutConstraint, topTextX2Constraint: NSLayoutConstraint ){
    
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
        self.bottomSpacing = bottomSpacing
        self.bottomTrailing = bottomTrailing
        self.bottomLeading = bottomLeading
        self.topTextYConstraint = topTextYConstraint
        self.topTextXConstraint = topTextXConstraint
        self.topTextX2Constraint = topTextX2Constraint
    
    }
    

}