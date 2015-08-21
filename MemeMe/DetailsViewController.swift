//
//  DetailsViewController.swift
//  MemeMe
//
//  Created by Oleg Trofimov on 8/19/15.
//  Copyright (c) 2015 Oleg Trofimov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var meme: Meme!
    @IBOutlet weak var detailsImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        detailsImageView.image = meme.memedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
