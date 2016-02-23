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
        let spacing = CGFloat(2.0)
        let width = (view.frame.size.width - (2 * spacing)) / 2.0
        let height  = (view.frame.size.height - (2 * spacing)) / 3.25
        
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = CGSizeMake(width, height)
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.item]
        cell.memeImageView?.image = meme.image
        cell.memeTopText?.text = meme.topText
        cell.memeBottomText?.text = meme.bottomText
        
        cell.memeImageView.contentMode = .ScaleAspectFill
        
        cell.layer.cornerRadius = cell.bounds.size.width / 2
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView") as! MemeDetailView
        detailViewController.meme = self.memes[indexPath.item]
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
}
