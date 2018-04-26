//
//  HeaderView.swift
//  Unplash
//
//  Created by Ky Nguyen Coinhako on 4/26/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit
class HeaderView: knView {
    
    var data: Photo? {didSet {
        guard let data = data else { return }
        authorLabel.text = "photo by " + data.author
        imageView.downloadImage(from: data.url)
        }}
    
    let imageView = knUIMaker.makeImageView(contentMode: .scaleAspectFill)
    let authorLabel = knUIMaker.makeLabel(font: UIFont.systemFont(ofSize: 16), color: .white, alignment: .center)
    let titleLabel = knUIMaker.makeLabel(text: "Photos for everyone", font: UIFont.boldSystemFont(ofSize: 32), color: .white, alignment: .center)
    let searchTextField = knUIMaker.makeTextField(placeholder: "Search photos")
    
    override func setupView() {
        translatesAutoresizingMaskIntoConstraints = true
        
        searchTextField.createRoundCorner(8)
        searchTextField.setLeftViewWithImage(#imageLiteral(resourceName: "search"))
        searchTextField.height(44)
        searchTextField.changePlaceholderTextColor(.white)
        addBlur(to: searchTextField, size: CGSize(width: screenWidth - 16 * 2, height: 44))
        
        addSubviews(views: imageView, titleLabel, searchTextField, authorLabel)
        
        imageView.fill(toView: self)
        
        titleLabel.centerY(toView: self, space: -48)
        titleLabel.centerX(toView: self)
        
        searchTextField.horizontal(toView: self, space: 16)
        searchTextField.verticalSpacing(toView: titleLabel, space: 16)
        
        authorLabel.centerX(toView: self)
        authorLabel.bottom(toView: self, space: -16)
        
        
    }
    
    func addBlur(to view: UIView, size: CGSize) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}








