//
//  UIImage.swift
//  kLibrary
//
//  Created by Ky Nguyen on 8/26/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {

    func downloadImage(from url: String?, placeholder: UIImage? = nil, completeAction: ((UIImage?) -> Void)? = nil) {

        guard let url = url, let nsurl = URL(string: url) else { return }
        kf.setImage(with: ImageResource(downloadURL: nsurl), placeholder: placeholder) { (image, _, _, _) in
            completeAction?(image)
            
        }
    }
    
    func change(color: UIColor) {
        guard let image = image else { return }
        self.image = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        tintColor = color
    }
    
}

extension UIImage {
    
    func changeColor() -> UIImage {
        return withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }
}
