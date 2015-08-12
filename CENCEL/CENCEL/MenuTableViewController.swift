//
//  MenuTableViewController.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 31/05/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background bonito
        var background:UIImageView = UIImageView(frame: self.tableView.bounds)
        background.contentMode = UIViewContentMode.ScaleAspectFill
        background.image = UIImage(named: "IMG_0010.JPG")
        
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.tableView.bounds
        background.insertSubview(blurEffectView, atIndex: 0)
        
        //background.addSubview(blurEffectView)
        //background.bringSubviewToFront(blurEffectView)
        self.tableView.backgroundColor=UIColor.clearColor()
        self.tableView.backgroundView=background
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

}