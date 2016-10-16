//
//  TableViewController.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 2016/07/30.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import SYBlinkAnimationKit

class TableViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate let titles = [["SYButton", "SYLabel", "SYTextField", "SYView", "SYCollectionView", "SYImageView", "SYTextView", "SYAlertView", "SYNavigationBar", "SYSwitch", "SYControll", "SYSlider", "SYActivityIndicator"]]
    fileprivate let controllers = ["ButtonView", "LabelView", "TextFieldView", "AnimationView", "CollectionView"]
    
    fileprivate let cellIdentifier = "ExampleTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "SYTableViewCell"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    fileprivate func configure(_ cell: ExampleTableViewCell, at indexPath: IndexPath) {
        cell.titleLabel.text = titles[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            cell.titleLabel.animationType = .text
            cell.titleLabel.startAnimating()
            return
        case 1:
            cell.animationType = .borderWithShadow
            cell.titleLabel.labelTextColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1)
            cell.startAnimating()
            return
        case 2:
            cell.animationType = .ripple
            cell.titleLabel.labelTextColor = UIColor(red: 210/255, green: 82/255, blue: 127/255, alpha: 1)
            cell.startAnimating()
            return
        case 3:
            cell.animationType = .background
            cell.titleLabel.labelTextColor = UIColor(red: 108/255, green: 122/255, blue: 137/255, alpha: 1)
            cell.startAnimating()
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
        cell.titleLabel.startAnimating()
    }
}

// MARK: - UITableViewDataSource -

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExampleTableViewCell
        configure(cell, at: indexPath)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
}

// MARK: - UITableViewDelegate -

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if 0..<controllers.count ~= (indexPath as NSIndexPath).row {
            let identifier = controllers[(indexPath as NSIndexPath).row]
            performSegue(withIdentifier: identifier, sender: self)
        }
    }
}
