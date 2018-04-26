//
//  PhotoModel.swift
//  Unplash
//
//  Created by Ky Nguyen Coinhako on 4/25/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class Photo {
    var author: String
    var url: String
    var ratio: CGFloat = 1
    var displayHeight: CGFloat {
        return CGFloat(floor(Double(ratio * screenWidth)))
    }
    
    init(author: String, url: String, ratio: CGFloat) {
        self.author = author
        self.url = url
        self.ratio = ratio
    }
}
