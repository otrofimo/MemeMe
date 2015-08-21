//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Oleg Trofimov on 8/19/15.
//  Copyright (c) 2015 Oleg Trofimov. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController{

    var memes: [Meme]!
    let reuseIdentifier = "SentMemesCollectionCell"
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memes = appDelegate.memes
        collectionView!.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        let meme = memes[indexPath.item]
        cell.backgroundView = UIImageView(image: meme.memedImage)
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("DetailsViewController") as! DetailsViewController
        detailVC.meme = memes[indexPath.item]
        navigationController!.pushViewController(detailVC, animated: true)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

}
