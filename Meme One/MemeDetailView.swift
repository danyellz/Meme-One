//
//  MemeDetailView.swift
//  Meme One
//
//  Created by TY on 2/22/16.
//  Copyright © 2016 Kinectic. All rights reserved.
//

import UIKit

class MemeDetailView: UIViewController{
    
    var memes: [Meme]!{
        let object  = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    var meme: Meme!
    
    @IBOutlet weak var completeMemeImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.completeMemeImage?.image = meme.memedImage
    }
    
}
