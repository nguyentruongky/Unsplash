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
    
    private func makeDropZone() -> UIView {
        let dropZoneEdge = 250
        let dropZoneMissingEdge: CGFloat = 50
        let view = UIView(frame: CGRect(x: -dropZoneEdge,
                                        y: Int(screenHeight) + dropZoneEdge,
                                        width: dropZoneEdge, height: dropZoneEdge))
        view.createRoundCorner(125)
        view.backgroundColor = .black
        
        let label = knUIMaker.makeLabel(text: "↓\nDrop here\nto download", font: UIFont.boldSystemFont(ofSize: 18), color: .white, numberOfLines: 0)
        label.tag = 1001
        label.translatesAutoresizingMaskIntoConstraints = true
        view.addSubviews(views: label)
        label.frame = CGRect(x: Int(dropZoneMissingEdge) + 24,
                             y: -25,
                             width: dropZoneEdge - Int(dropZoneMissingEdge) - 16,
                             height: dropZoneEdge)
        return view
    }
    
    private func animateDropZone(visible: Bool) {
        let dropZoneEdge = 250
        let dropZoneMissingEdge: CGFloat = 50
        view.bringSubview(toFront: dropZone)
        if visible == true {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.dropZone.frame = CGRect(x: -Int(dropZoneMissingEdge),
                                              y: Int(screenHeight) - dropZoneEdge + Int(dropZoneMissingEdge),
                                              width: dropZoneEdge, height: dropZoneEdge)
            })
        }
        else {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.dropZone.frame = CGRect(x: -dropZoneEdge,
                                              y: Int(screenHeight) + dropZoneEdge,
                                              width: dropZoneEdge, height: dropZoneEdge)
            })
        }
    }
    
    private func zoomDropZone(bigger: Bool) {
        let dropZoneEdge = 250
        let dropZoneMissingEdge: CGFloat = 50
        
        let yPosition = screenHeight - CGFloat(dropZoneEdge) + dropZoneMissingEdge - 50.0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            
            guard let dropZone = self?.dropZone, let label = dropZone.viewWithTag(1001) else { return }
            if bigger == true {
                dropZone.createRoundCorner(CGFloat((dropZoneEdge + 100) / 2))
                dropZone.frame = CGRect(x: -Int(dropZoneMissingEdge),
                                        y: Int(yPosition),
                                        width: dropZoneEdge + 100, height: dropZoneEdge + 100)
                label.frame.origin.y = 25
            }
            else {
                dropZone.createRoundCorner(CGFloat(dropZoneEdge) / 2)
                dropZone.frame = CGRect(x: -Int(dropZoneMissingEdge),
                                        y: Int(screenHeight - CGFloat(dropZoneEdge) + dropZoneMissingEdge),
                                        width: dropZoneEdge, height: dropZoneEdge)
                label.frame.origin.y = -25
            }
        })
    }
    
    func detectDownloading() {
        guard let recognizer = recognizer, let imageView = recognizer.view?.viewWithTag(1001) as? UIImageView else { return }
        
        switch recognizer.state {
        case .began:
            dragImageView = cloneImageView(from: imageView)
            view.addSubviews(views: dragImageView!)
            dragImageView!.frame = changeFrameToView(from: imageView)
            startPoint = locationInView(from: recognizer)
            zoom(view: dragImageView!, to: 1.02)
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
                if let image = dragImageView.image {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
                animateImageWhenDownload()
                animateDropZone(visible: false)
            } else {
                print("Cancel download")
                let originalFrame = changeFrameToView(from: imageView)
                animateImageWhenCancel(to: originalFrame)
                animateDropZone(visible: false)
            }
        default:
            return
        }
    }
    
    private func animateImageWhenDownload() {
        guard let imageView = dragImageView else { return }
        UIView.animate(withDuration: 0.2,
                       animations: {
                        imageView.alpha = 0
                        imageView.frame.origin.y = screenHeight + 10
        }, completion: { _ in imageView.removeFromSuperview() })
    }
    
    private func animateImageWhenCancel(to frame: CGRect) {
        guard let imageView = dragImageView else { return }
        UIView.animate(withDuration: 0.2,
                       animations: {
                        imageView.frame = frame },
                       completion: { _ in
                        imageView.removeFromSuperview()
        })
    }
    
    private func checkContain(bigView: UIView, smallView: UIView) -> Bool {
        return bigView.frame.intersects(smallView.frame) || smallView.frame.intersects(bigView.frame)
    }
    
    private func cloneImageView(from imageView: UIImageView) -> UIImageView {
        let iv = knUIMaker.makeImageView(image: imageView.image, contentMode: imageView.contentMode)
        iv.translatesAutoresizingMaskIntoConstraints = true
        return iv
    }
    
    private func changeFrameToView(from childView: UIView) -> CGRect {
        return childView.convert(childView.frame, to: view) }
    
    private func locationInView(from gesture: UILongPressGestureRecognizer) -> CGPoint {
        return gesture.location(in: view) }
    
    private func zoom(view: UIView, to level: CGFloat) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: level, y: level)
        })
    }
    
}
