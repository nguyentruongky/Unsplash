//
//  GlobalSupporter.swift
//  Fixir
//
//  Created by Ky Nguyen on 3/9/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

var screenWidth: CGFloat { return UIScreen.main.bounds.width }
var screenHeight: CGFloat { return UIScreen.main.bounds.height }
var statusBarStyle = UIStatusBarStyle.lightContent { didSet {UIApplication.shared.statusBarStyle = statusBarStyle}}
var isStatusBarHidden = false { didSet { UIApplication.shared.isStatusBarHidden = isStatusBarHidden}}
