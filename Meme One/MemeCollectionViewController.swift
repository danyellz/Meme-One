//
//  MemeCollectionViewController.swift
//  Meme One
//
//  Created by TY on 2/21/16.
//  Copyright © 2016 Kinectic. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController{
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!{
        let object  = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let spacing = CGFloat(3.0)
        let width = (view.frame.size.width - (2 * spacing)) / 3.0
        
        flowLayout.minimumInteritemSpacing = 1.0
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.itemSize = CGSizeMake(width, width)
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.memeImageView?.image = meme.image
        cell.memeTopText?.text = meme.topText
        cell.memeBottomText?.text = meme.bottomText
        
        cell.layer.cornerRadius = cell.bounds.size.width / 2
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView") as! MemeDetailView
        detailViewController.meme = memes[indexPath.item]
        navigationController!.pushViewController(detailViewController, animated: true)
    }
}
