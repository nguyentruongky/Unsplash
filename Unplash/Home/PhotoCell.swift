//
//  PhotoCell.swift
//  Unplash
//
//  Created by Ky Nguyen Coinhako on 4/25/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit
class PhotoCell: knTableCell {
    var heightConstraint: NSLayoutConstraint?
    var data: Photo? {
        didSet {
            guard let data = data else { return }
            authorLabel.text = data.author
            photoImageView.downloadImage(from: data.url)
            heightConstraint?.constant = data.displayHeight
        }
    }

    var longGestureAction: ((_ gesture: UILongPressGestureRecognizer) -> Void)?
    
    private let authorLabel = knUIMaker.makeLabel(color: .white)
    private let photoImageView = knUIMaker.makeImageView(contentMode: .scaleAspectFill)
    
    override func setupView() {
        
        photoImageView.tag = 1001
        let line = knUIMaker.makeLine(color: .white, height: 1)
        
        addSubviews(views: photoImageView, authorLabel, line)
        photoImageView.fill(toView: self)
        
        authorLabel.bottomLeft(toView: self, bottom: -8, left: 8)
        
        line.horizontal(toView: self)
        line.bottom(toView: self)
        
        heightConstraint = height(100, isActive: false)
        heightConstraint?.priority = UILayoutPriority(999)
        heightConstraint?.isActive = true
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(detectLongPress))
        addGestureRecognizer(longGesture)
    }
    
    @objc func detectLongPress(gesture: UILongPressGestureRecognizer) {
        longGestureAction?(gesture)
    }
}
