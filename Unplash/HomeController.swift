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

    let categoryView = PhotoGroupView()
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
    
    override func setupView() {
        view.addSubview(tableView)
        tableView.fill(toView: view)
        
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        statusBarStyle = .lightContent
        
        let headerHeight: CGFloat = 350
        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: headerHeight)
        tableView.tableHeaderView = headerView

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
    }
    
    
}

extension HomeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return datasource.count + 1}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { return photoGroupCell }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.data = datasource[indexPath.row - 1]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
}


