//
//  Home.swift
//  Unplash
//
//  Created by Ky Nguyen Coinhako on 4/24/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class HomeController: knCustomTableController {
    var datasource = [Photo]()
    let headerView = HeaderView()
    let animatedHeader = HeaderView()

    let categoryView = PhotoGroupView()
    var startPoint = CGPoint.zero
    
    lazy var photoGroupCell = self.makePhotoGroupCell()
    func makePhotoGroupCell() -> knTableCell {
        let font = UIFont.boldSystemFont(ofSize: 16)
        let explore = knUIMaker.makeLabel(text: "Explore", font: font, color: .black)
        let new = knUIMaker.makeLabel(text: "New", font: font, color: .black)
        
        let cell = knTableCell()
        cell.addSubviews(views: categoryView, explore, new)
        cell.addConstraints(withFormat: "V:|-12-[v0]-8-[v1]-12-[v2]-8-|", views: explore, categoryView, new)
        
        categoryView.horizontal(toView: cell)
        
        explore.left(toView: cell, space: 16)
        new.left(toView: explore)
        
        categoryView.height(150)
        return cell
    }

    private var dragImageView: UIImageView?
    lazy var dropZone = self.makeDropZone()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    let headerHeight: CGFloat = 350

    var animatedHeaderHeightConstraint: NSLayoutConstraint?
    override func setupView() {
        view.addSubviews(views: animatedHeader, tableView)
        animatedHeader.translatesAutoresizingMaskIntoConstraints = false
        animatedHeader.horizontal(toView: view)
        animatedHeaderHeightConstraint = animatedHeader.height(headerHeight)
        animatedHeader.top(toView: view)
        
        tableView.fill(toView: view)
        tableView.backgroundColor = .clear
        
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        statusBarStyle = .lightContent
        
        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: headerHeight)
        tableView.tableHeaderView = headerView
        
        view.addSubviews(views: dropZone)
    }
    
    override func registerCells() {
        tableView.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")
    }
    
    override func fetchData() {
        
        var categories = [PhotoGroup]()
        for _ in 0 ..< 5 {
            categories.append(PhotoGroup(name: "Sport", url: "https://unsplash.com/photos/zydhjnjppEc/download", id: "12bawr"))
            categories.append(PhotoGroup(name: "Computer", url: "https://unsplash.com/photos/Y6N_w94x8ik/download", id: "nvljx91"))
        }
        categoryView.datasource = categories
        
        for _ in 0 ..< 5 {
            datasource.append(Photo(author: "Kyle", url: "https://unsplash.com/photos/zydhjnjppEc/download", ratio: 0.667954600338083))
            datasource.append(Photo(author: "Mark", url: "https://unsplash.com/photos/Y6N_w94x8ik/download", ratio: 1.5))
        }
        tableView.reloadData()
        
        headerView.data = Photo(author: "Kyle", url: "https://unsplash.com/photos/zydhjnjppEc/download", ratio: 0.667954600338083)
        animatedHeader.data = headerView.data
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let stopPoint: CGFloat = 96
        let newHeight = headerHeight - yOffset
        bringFakeViewToFontIf(isTop: yOffset == 0)
        var opacity = (newHeight - stopPoint) / headerHeight
        opacity = opacity > 0 ? opacity : 0
        
        if newHeight > stopPoint {
            animatedHeaderHeightConstraint?.constant = newHeight
            headerView.isHidden = true
            animatedHeader.authorLabel.alpha = opacity
            animatedHeader.titleLabel.alpha = opacity
            statusBarStyle = .lightContent
            animatedHeader.changeSearchTextFieldStyle(.dark)
        }
        else {
            headerView.isHidden = false
            statusBarStyle = .default
            animatedHeader.changeSearchTextFieldStyle(.light)
        }
        
        let whiteViewOpacity = (newHeight * 2.2) / headerHeight
        animatedHeader.animateWhiteView(by: whiteViewOpacity)
    }
    
    func bringFakeViewToFontIf(isTop: Bool) {
        view.bringSubview(toFront: isTop ? tableView : animatedHeader)
    }
    
}

extension HomeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return datasource.count + 1}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { return photoGroupCell }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.data = datasource[indexPath.row - 1]
        
        let lpGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressCell))
        cell.contentView.addGestureRecognizer(lpGestureRecognizer)
        
        return cell
    }
    
    @objc func didLongPressCell (recognizer: UILongPressGestureRecognizer) {
        guard let imageView = recognizer.view?.superview?.viewWithTag(1001) as? UIImageView else { return }

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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
}


