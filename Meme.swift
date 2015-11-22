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
    let topConstraints: [NSLayoutConstraint]
    let bottomConstraints: [NSLayoutConstraint]
    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage, topConstraints: [NSLayoutConstraint], bottomConstraints: [NSLayoutConstraint]){
    
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
        self.topConstraints = topConstraints
        self.bottomConstraints = bottomConstraints
    
    }
    

}