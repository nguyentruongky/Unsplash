//
//  UITextField.swift
//  kLibrary
//
//  Created by Ky Nguyen on 8/27/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setLeftViewWithImage(_ image:UIImage){
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 33,height: 21))
        imgView.image = image
        imgView.contentMode = .scaleAspectFill
        leftView = imgView
        leftViewMode = .always
        leftView!.contentMode = UIViewContentMode.scaleAspectFit
        leftView!.clipsToBounds = true
    }
    
    func changePlaceholderTextColor(_ color: UIColor) {
        
        guard let placeholder = placeholder else { return }
        let attributes = [NSAttributedStringKey.foregroundColor : color]
        attributedPlaceholder = NSAttributedString(string:placeholder, attributes: attributes)
    }
    
}
