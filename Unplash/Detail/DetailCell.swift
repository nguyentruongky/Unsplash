//
//  DetailCell.swift
//  Unplash
//
//  Created by Ky Nguyen Coinhako on 4/30/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class DetailCell: knCollectionCell {
    var data: Photo? { didSet {
        imageView.downloadImage(from: data?.url)
        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        }}
    
    let imageView = knUIMaker.makeImageView(contentMode: .scaleAspectFit)
    var panAction: ((UIPanGestureRecognizer) -> Void)?
    lazy var scrollView: UIScrollView = { [weak self] in
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumZoomScale = 1
        view.maximumZoomScale = 2
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    var isFullSize = false
    
    override func prepareForReuse() {
        isFullSize = false
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        imageView.frame.size = CGSize(width: screenWidth, height: screenHeight)
    }
    
    override func setupView() {
        imageView.translatesAutoresizingMaskIntoConstraints = true

        scrollView.addSubview(imageView)

        addSubviews(views: scrollView)
        scrollView.fill(toView: self)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(detectPan))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
    }
    
    @objc func detectPan(recognizer: UIPanGestureRecognizer) {
        panAction?(recognizer)
    }
    
    @objc func doubleTapped(recognizer: UITapGestureRecognizer) {
        if (isFullSize == false) {
            imageView.frame = CGRect(x: 0, y: 0, width: screenWidth * 2, height: screenWidth * 2 / data!.ratio)
        } else {
            imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        }
        scrollView.contentSize = imageView.frame.size
        isFullSize = !isFullSize
        scrollView.isScrollEnabled = isFullSize
    }
}

extension DetailCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

