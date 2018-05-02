//
//  HeaderView.swift
//  Unplash
//
//  Created by Ky Nguyen Coinhako on 4/26/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit
class HeaderView: knView {
    
    enum Style {
        case dark, light
    }
    
    var data: Photo? {didSet {
        guard let data = data else { return }
        authorLabel.text = "Photo by " + data.author
        imageView.downloadImage(from: data.url)
        }}
    
    let imageView = knUIMaker.makeImageView(contentMode: .scaleAspectFill)
    let authorLabel = knUIMaker.makeLabel(font: UIFont.systemFont(ofSize: 16), color: .white, alignment: .center)
    let titleLabel = knUIMaker.makeLabel(text: "Photos for everyone", font: UIFont.boldSystemFont(ofSize: 32), color: .white, alignment: .center)
    let searchTextField = knUIMaker.makeTextField(placeholder: "Search photos")
    
    let whiteView = knUIMaker.makeView(background: .white)
    
    override func setupView() {
        translatesAutoresizingMaskIntoConstraints = true
        
        whiteView.alpha = 0
        searchTextField.createRoundCorner(8)
        searchTextField.setLeftViewWithImage(#imageLiteral(resourceName: "search"))
        searchTextField.height(44)
        changeSearchTextFieldStyle(.dark)
        addBlur(to: searchTextField, size: CGSize(width: screenWidth - 16 * 2, height: 44))
        
        addSubviews(views: imageView, whiteView, titleLabel, searchTextField, authorLabel)
        
        whiteView.fill(toView: self)
        
        imageView.fill(toView: self)
        
        titleLabel.centerY(toView: self, space: -48)
        titleLabel.centerX(toView: self)
        
        searchTextField.horizontal(toView: self, space: 16)
        searchTextField.verticalSpacing(toView: titleLabel, space: 16)
        
        authorLabel.centerX(toView: self)
        authorLabel.bottom(toView: self, space: -16)
    }
    
    func changeSearchTextFieldStyle(_ style: Style) {
        if style == .light {
            blurEffectView.removeFromSuperview()
            searchTextField.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            let color = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
            searchTextField.changePlaceholderTextColor(color)
            (searchTextField.leftView as? UIImageView)?.change(color: color)
        }
        else {
            addBlur(to: searchTextField, size: CGSize(width: screenWidth - 16 * 2, height: 44))
            let color = UIColor.white
            searchTextField.changePlaceholderTextColor(color)
            (searchTextField.leftView as? UIImageView)?.change(color: color)
        }
    }
    
    func animateWhiteView(by opacity: CGFloat) {
        let whiteViewOpacity = opacity > 0 ? opacity : 0
        whiteView.alpha = 1 - whiteViewOpacity
    }
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    func addBlur(to view: UIView, size: CGSize) {
        blurEffectView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}








