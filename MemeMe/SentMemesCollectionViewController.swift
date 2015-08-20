//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Oleg Trofimov on 8/19/15.
//  Copyright (c) 2015 Oleg Trofimov. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var memes: [Meme]!
    let reuseIdentifier = "SentMemesCollectionCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemesCollectionCell

        let meme = self.memes[indexPath.item]

        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        cell.memeImageView = UIImageView(image: meme.image)

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsViewController") as! UIViewController
        self.navigationController!.pushViewController(detailVC, animated: true)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

}
