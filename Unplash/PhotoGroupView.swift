//
//  PhotoGroupView.swift
//  Unplash
//
//  Created by Ky Nguyen Coinhako on 4/26/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class PhotoGroupView: knView {
    var datasource = [PhotoGroup]() { didSet { collectionView.reloadData() }}
    lazy var collectionView: UICollectionView = { [weak self] in
        let layout = FAPaginationLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cv.register(PhotoGroupCell.self, forCellWithReuseIdentifier: "PhotoGroupCell")
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        return cv
        
        }()
    
    override func setupView() {
        addSubviews(views: collectionView)
        collectionView.fill(toView: self)
    }
}

extension PhotoGroupView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return datasource.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoGroupCell", for: indexPath) as! PhotoGroupCell
        cell.data = datasource[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 8 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width -= collectionView.contentInset.left
        cellSize.width -= collectionView.contentInset.right
        return cellSize
    }
}









