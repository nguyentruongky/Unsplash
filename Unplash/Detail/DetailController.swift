//
//  DetailController.swift
//  Unplash
//
//  Created by Ky Nguyen Coinhako on 4/30/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class DetailController: knCollectionController {
    var datasource = [Photo]()
    var currentPhotoIndex = 0
    var originalFrame = CGRect.zero
    var initialTouchPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override func registerCells() {
        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: "DetailCell")
    }
    
    override func setupView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.backgroundColor = .black
        view.addSubviews(views: collectionView)
        collectionView.fill(toView: view)
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        statusBarStyle = .lightContent
        
        let button = knUIMaker.makeButton(image: #imageLiteral(resourceName: "cancel").changeColor())
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeView))
        view.addSubviews(views: button)
        button.square(edge: 44)
        button.topLeft(toView: view, top: 24, left: 16)
        
        view.backgroundColor = .clear
        view.isOpaque = false
    }
    
    func cloneImageView(from imageView: UIImageView) -> UIImageView {
        let iv = knUIMaker.makeImageView(image: imageView.image, contentMode: imageView.contentMode)
        iv.translatesAutoresizingMaskIntoConstraints = true
        return iv
    }
    
    @objc func closeView() {
        guard let cell = collectionView.visibleCells.first as? DetailCell else { return }
        let imageView = cell.imageView
        let newImageView = cloneImageView(from: imageView)
        view.addSubviews(views: newImageView)
        newImageView.frame = view.frame
        collectionView.isHidden = true
        
        UIView.animate(withDuration: 0.35, animations: { [unowned self] in
            newImageView.frame = self.originalFrame
        }, completion: { [weak self] _ in
            self?.dismiss(animated: false) })
    }
    
    override func fetchData() {
        datasource.append(Photo(author: "Lidya Nada", url: "https://unsplash.com/photos/-iX-0JI8-0Y/download", ratio: 0.7069555302))
        datasource.append(Photo(author: "Redd Angelo", url: "https://unsplash.com/photos/RbzquZ-xTF8/download", ratio: 0.667987546))
        datasource.append(Photo(author: "enjoythelight", url: "https://unsplash.com/photos/sAX4wwWYbFE/download", ratio: 0.7815))
        datasource.append(Photo(author: "Monika Grabkowska", url: "https://unsplash.com/photos/S3g2H4Acw4g/download", ratio: 0.666667))
        datasource.append(Photo(author: "Deryn Macey", url: "https://unsplash.com/photos/QF0R6Q1C1u0/download", ratio: 0.66755))
        collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.contentOffset = CGPoint(x: currentPhotoIndex * Int(screenWidth), y: 0)
    }
}


extension DetailController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return datasource.count }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailCell
        cell.data = datasource[indexPath.row]
        cell.panAction = { [weak self] gesture in self?.detectPan(gesture: gesture) }
        return cell
    }
    
    func detectPan(gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: view)
        
        switch gesture.state {
        case .began:
            initialTouchPoint = touchPoint
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 100 &&
                abs(touchPoint.x - initialTouchPoint.x) < 5 {
                closeView()
            }
        default:
            break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 0 }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return UIScreen.main.bounds.size }
}






