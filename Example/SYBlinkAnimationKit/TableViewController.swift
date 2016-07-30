//
//  TableViewController.swift
//  SYBlinkAnimationKit
//
//  Created by 横山祥平 on 2016/07/30.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import SYBlinkAnimationKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let titles = [["SYButton", "SYLabel", "SYTextField", "SYView", "SYCollectionView", "SYImageView", "SYTextView"]]
    let controllers = ["ButtonView", "LabelView", "TextFieldView", "AnimationView"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        title = "SYTableViewCell"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        
        let nib = UINib(nibName: "ExampleTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ExampleTableViewCell")
    }
    
    func configureCell(cell: ExampleTableViewCell, indexPath: NSIndexPath) {
        cell.titleLabel.text = titles[indexPath.section][indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.animationType = .text
            cell.titleLabel.startAnimation()
        case 1:
            cell.animationType = .borderWithShadow
            cell.startAnimation()
        case 2:
            cell.animationType = .ripple
            cell.startAnimation()
        case 3:
            cell.animationType = .background
            cell.startAnimation()
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource -

extension TableViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCellWithIdentifier("ExampleTableViewCell", forIndexPath: indexPath) as! ExampleTableViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
}

// MARK: - UITableViewDelegate -

extension TableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if 0..<controllers.count ~= indexPath.row {
            let identifier = controllers[indexPath.row]
            performSegueWithIdentifier(identifier, sender: self)
        }
    }
}
