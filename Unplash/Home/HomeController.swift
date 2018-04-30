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
    let animator = Animator()
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    let headerHeight: CGFloat = 350

    var animatedHeaderHeightConstraint: NSLayoutConstraint?
    override func setupView() {
        navigationController?.isNavigationBarHidden = true 
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
        
        animator.view = view
        view.addSubviews(views: animator.dropZone)
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
        
        datasource.append(Photo(author: "Lidya Nada", url: "https://unsplash.com/photos/-iX-0JI8-0Y/download", ratio: 0.7069555302))
        datasource.append(Photo(author: "Redd Angelo", url: "https://unsplash.com/photos/RbzquZ-xTF8/download", ratio: 0.667987546))
        datasource.append(Photo(author: "enjoythelight", url: "https://unsplash.com/photos/sAX4wwWYbFE/download", ratio: 0.7815))
        datasource.append(Photo(author: "Monika Grabkowska", url: "https://unsplash.com/photos/S3g2H4Acw4g/download", ratio: 0.666667))
        datasource.append(Photo(author: "Deryn Macey", url: "https://unsplash.com/photos/QF0R6Q1C1u0/download", ratio: 0.66755))
        tableView.reloadData()
        
        headerView.data = Photo(author: "Monika Grabkowska", url: "https://unsplash.com/photos/S3g2H4Acw4g/download", ratio: 0.666667)
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
        cell.longGestureAction = { [weak self] recognizer in self?.didLongPressCell(recognizer: recognizer)}
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        let cell = tableView.cellForRow(at: indexPath)
        guard let imageView = cell?.viewWithTag(1001) as? UIImageView else { return }
        let newImageView = animator.cloneImageView(from: imageView)
        let originalFrame = animator.changeFrameToView(from: imageView)
        newImageView.frame = originalFrame
        view.addSubviews(views: newImageView)
        
        UIView.animate(withDuration: 0.35, animations: {
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.frame = UIScreen.main.bounds
        }, completion: { _ in
            let controller = DetailController()
            controller.originalFrame = originalFrame
            controller.currentPhotoIndex = indexPath.row - 1
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: false)
            newImageView.removeFromSuperview()
        })
    }
    
    @objc func didLongPressCell(recognizer: UILongPressGestureRecognizer) {
        animator.recognizer = recognizer
        animator.detectDownloading()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
}


