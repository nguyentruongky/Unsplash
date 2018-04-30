//
//  AnimationHub.swift
//  Unplash
//
//  Created by Ky Nguyen Coinhako on 4/30/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class Animator {
    var view = UIView()
    lazy var dropZone = self.makeDropZone()
    var dragImageView: UIImageView?
    var startPoint = CGPoint.zero
    var recognizer: UILongPressGestureRecognizer?
    
    func makeDropZone() -> UIView {
        let edge = 250
        let missingEdge: CGFloat = 50
        let view = UIView(frame: CGRect(x: -edge,
                                        y: Int(screenHeight) + edge,
                                        width: edge, height: edge))
        view.createRoundCorner(125)
        view.backgroundColor = .black
        
        let label = knUIMaker.makeLabel(text: "↓\nDrop here\nto download", font: UIFont.boldSystemFont(ofSize: 18), color: .white, numberOfLines: 0)
        label.tag = 1001
        label.translatesAutoresizingMaskIntoConstraints = true
        view.addSubviews(views: label)
        label.frame = CGRect(x: Int(missingEdge) + 24,
                             y: -25,
                             width: edge - Int(missingEdge) - 16,
                             height: edge)
        return view
    }
    
    func animateDropZone(visible: Bool) {
        let edge = 250
        let missingEdge: CGFloat = 50
        view.bringSubview(toFront: dropZone)
        if visible == true {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.dropZone.frame = CGRect(x: -Int(missingEdge),
                                              y: Int(screenHeight) - edge + Int(missingEdge),
                                              width: edge, height: edge)
            })
        }
        else {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.dropZone.frame = CGRect(x: -edge,
                                              y: Int(screenHeight) + edge,
                                              width: edge, height: edge)
            })
        }
    }
    
    func zoomDropZone(bigger: Bool) {
        let edge = 250
        let missingEdge: CGFloat = 50
        
        let yPosition = screenHeight - CGFloat(edge) + missingEdge - 50.0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            
            guard let dropZone = self?.dropZone, let label = dropZone.viewWithTag(1001) else { return }
            if bigger == true {
                dropZone.frame = CGRect(x: -Int(missingEdge),
                                        y: Int(yPosition),
                                        width: edge + 100, height: edge + 100)
                dropZone.createRoundCorner(CGFloat((edge + 100) / 2))
                label.frame.origin.y = 25
            }
            else {
                dropZone.frame = CGRect(x: -Int(missingEdge),
                                        y: Int(screenHeight - CGFloat(edge) + missingEdge),
                                        width: edge, height: edge)
                dropZone.createRoundCorner(CGFloat(edge) / 2)
                label.frame.origin.y = -25
            }
            
            
        })
        
        
    }
    
    func detechDownloading() {
        guard let imageView = recognizer?.view?.superview?.viewWithTag(1001) as? UIImageView, let recognizer = recognizer else { return }
        
        switch recognizer.state {
        case .began:
            dragImageView = cloneImageView(from: imageView)
            view.addSubviews(views: dragImageView!)
            animateSelection(view: imageView)
        case .changed:
            guard let dragImageView = dragImageView else { return }
            let newPoint = locationInView(from: recognizer)
            if newPoint == startPoint { return }
            zoom(view: dragImageView, to: 0.5)
            dragImageView.center = newPoint
            animateDropZone(visible: true)
            view.bringSubview(toFront: dragImageView)
            
            if checkContain(bigView: dragImageView, smallView: dropZone) {
                zoomDropZone(bigger: true)
            }
            else {
                zoomDropZone(bigger: false)
            }
            
        case .ended:
            guard let dragImageView = dragImageView else { return }
            if (checkContain(bigView: dragImageView, smallView: dropZone)) {
                print("Downloading")
                
                animateImageWhenDownload()
                animateDropZone(visible: false)
            } else {
                print("Cancel download")
                let originalFrame = changeFrameToView(from: imageView)
                animateImageWhenCancel(to: originalFrame)
                animateDropZone(visible: false)
            }
            
            
        default:
            print("Any other action?")
        }
    }
    
    func animateSelection(view: UIImageView) {
        guard let recognizer = recognizer else { return }
        view.addSubviews(views: dragImageView!)
        dragImageView!.frame = changeFrameToView(from: view)
        startPoint = locationInView(from: recognizer)
        zoom(view: dragImageView!, to: 1.02)
    }
    
    func animateMoving() {
        guard let recognizer = recognizer else { return }
        guard let dragImageView = dragImageView else { return }
        let newPoint = locationInView(from: recognizer)
        if newPoint == startPoint { return }
        zoom(view: dragImageView, to: 0.5)
        dragImageView.center = newPoint
        animateDropZone(visible: true)
        view.bringSubview(toFront: dragImageView)
        
        if checkContain(bigView: dragImageView, smallView: dropZone) {
            zoomDropZone(bigger: true)
        }
        else {
            zoomDropZone(bigger: false)
        }
    }
    
    func animateImageWhenDownload() {
        guard let imageView = dragImageView else { return }
        UIView.animate(withDuration: 0.2,
                       animations: {
                        imageView.alpha = 0
                        imageView.frame.origin.y = screenHeight + 10
        }, completion: { _ in imageView.removeFromSuperview() })
    }
    
    func animateImageWhenCancel(to frame: CGRect) {
        guard let imageView = dragImageView else { return }
        UIView.animate(withDuration: 0.2,
                       animations: {
                        imageView.frame = frame },
                       completion: { _ in
                        imageView.removeFromSuperview()
        })
    }
    
    func checkContain(bigView: UIView, smallView: UIView) -> Bool {
        return bigView.frame.intersects(smallView.frame) || smallView.frame.intersects(bigView.frame)
    }
    
    func cloneImageView(from imageView: UIImageView) -> UIImageView {
        let iv = knUIMaker.makeImageView(image: imageView.image, contentMode: imageView.contentMode)
        iv.translatesAutoresizingMaskIntoConstraints = true
        return iv
    }
    
    func changeFrameToView(from childView: UIView) -> CGRect {
        return childView.convert(childView.frame, to: view)
    }
    
    func locationInView(from gesture: UILongPressGestureRecognizer) -> CGPoint {
        return gesture.location(in: view)
    }
    
    func zoom(view: UIView, to level: CGFloat) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: level, y: level)
        })
    }
    
}
