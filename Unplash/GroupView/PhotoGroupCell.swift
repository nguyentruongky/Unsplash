//
//  PhotoGroupCell.swift
//  Unplash
//
//  Created by Ky Nguyen Coinhako on 4/26/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit
class PhotoGroupCell: knCollectionCell {
    var data: PhotoGroup? {
        didSet {
            titleLabel.text = data?.name
            imageView.downloadImage(from: data?.url)
        }}
    
    let imageView = knUIMaker.makeImageView(contentMode: .scaleAspectFill)
    let titleLabel = knUIMaker.makeLabel(font: UIFont.systemFont(ofSize: 16), color: .white, numberOfLines: 3, alignment: .center)
    
    override func setupView() {
        addSubviews(views: imageView, titleLabel)
        
        imageView.fill(toView: self)
        titleLabel.horizontal(toView: self, space: 8)
        titleLabel.centerY(toView: self)
        
        createRoundCorner(7)
    }
}
