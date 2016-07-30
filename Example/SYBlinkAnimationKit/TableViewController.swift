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
    
    let titles = [["SYButton", "SYLabel", "SYTextField", "SYView", "SYCollectionView", "SYImageView", "SYTextView", "SYAlertView", "SYNavigationBar", "SYSwitch", "SYControll", "SYSlider", "SYActivityIndicator"]]
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
            return
        case 1:
            cell.animationType = .borderWithShadow
            cell.titleLabel.labelTextColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1)
            cell.startAnimation()
            return
        case 2:
            cell.animationType = .ripple
            cell.titleLabel.labelTextColor = UIColor(red: 210/255, green: 82/255, blue: 127/255, alpha: 1)
            cell.startAnimation()
            return
        case 3:
            cell.animationType = .background
            cell.titleLabel.labelTextColor = UIColor(red: 108/255, green: 122/255, blue: 137/255, alpha: 1)
            cell.startAnimation()
            return
        case 4:  cell.titleLabel.animationTextColor = UIColor(red: 245/255, green: 215/255, blue: 110/255, alpha: 1)
        case 5:  cell.titleLabel.animationTextColor = UIColor(red: 58/255, green: 83/255, blue: 155/255, alpha: 1)
        case 6:  cell.titleLabel.animationTextColor = UIColor(red: 211/255, green: 84/255, blue: 0/255, alpha: 1)
        case 7:  cell.titleLabel.animationTextColor = UIColor(red: 108/255, green: 122/255, blue: 137/255, alpha: 1)
        case 8:  cell.titleLabel.animationTextColor = UIColor(red: 210/255, green: 77/255, blue: 87/255, alpha: 1)
        case 9:  cell.titleLabel.animationTextColor = UIColor(red: 246/255, green: 36/255, blue: 89/255, alpha: 1)
        case 10: cell.titleLabel.animationTextColor = UIColor(red: 191/255, green: 85/255, blue: 236/255, alpha: 1)
        case 11: cell.titleLabel.animationTextColor = UIColor(red: 37/255, green: 116/255, blue: 169/255, alpha: 1)
        case 12: cell.titleLabel.animationTextColor = UIColor(red: 1/255, green: 152/255, blue: 117/255, alpha: 1)
        default:
            break
        }
        cell.titleLabel.animationType = .text
        cell.titleLabel.startAnimation()
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
