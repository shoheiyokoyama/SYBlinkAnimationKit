//
//  CollectionViewController.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 2016/07/31.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import SYBlinkAnimationKit

class CollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        registerCell()
    }
    
    fileprivate func configure() {
        collectionView.delegate        = self
        collectionView.dataSource      = self
        collectionView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection         = .vertical
        layout.minimumLineSpacing      = 5
        layout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = layout
    }
    
    fileprivate func registerCell() {
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    fileprivate func configureCell(_ cell: CollectionViewCell, indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
        case 0:
            cell.titileLabel.text = "Border Animation"
            cell.animationType    = .border
        case 1:
            cell.titileLabel.text = "BorderWithShadow\nAnimation"
            cell.animationType    = .borderWithShadow
            cell.titileLabel.textAlignmentMode = .center
        case 2:
            cell.titileLabel.text = "Background Animation"
            cell.animationType    = .background
        case 3:
            cell.titileLabel.text = "ripple Animation"
            cell.animationType    = .ripple
        default:
            cell.titileLabel.text          = "SYCollectionViewCell"
            cell.titileLabel.animationType = .text
            cell.titileLabel.startAnimation()
        }
        cell.startAnimation()
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 5
        let height: CGFloat = 150
        
        let rowCount: CGFloat = 2
        return CGSize(width: view.frame.width / rowCount - (margin * (rowCount - 1) / rowCount), height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
    
}
