//
//  DetailViewController.swift
//  rss
//
//  Created by Арина on 13.06.2020.
//  Copyright © 2020 Арина. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var feed: Any?
    var image: AnyObject?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = (feed as AnyObject).object(forKey: "title") as? String
        dateLabel.text = (feed as AnyObject).object(forKey: "pubDate") as? String
        descriptionLabel.text = (feed as AnyObject).object(forKey: "yandex:full-text") as? String
        
        let url = NSURL(string:image as! String)
        let data = NSData(contentsOf:url! as URL)
        let imageURL = UIImage(data:data! as Data)
        
        imageView.image = imageURL

    }

}
