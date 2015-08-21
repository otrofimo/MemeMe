//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Oleg Trofimov on 8/19/15.
//  Copyright (c) 2015 Oleg Trofimov. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var memes: [Meme]!
    let reuseIdentifier = "SentMemesTableCell"
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        tableView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("DetailsViewController") as! DetailsViewController
        detailVC.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailVC, animated: true)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.topText) ... \(meme.bottomText)"

        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
}
