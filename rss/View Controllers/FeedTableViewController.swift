//
//  FeedTableViewController.swift
//  rss
//
//  Created by Арина on 13.06.2020.
//  Copyright © 2020 Арина. All rights reserved.
//

import UIKit

class FeedListViewController: UITableViewController, XMLParserDelegate {
    
    var myFeed : NSArray = []
    var itemsCategory: [Any] = []
    var allItemsArray: NSArray = []
    var allImageArray: [AnyObject] = []
    var feedImgs: [AnyObject] = []
    var url: URL!
    

    
    let transiton = SlideInTransition()
    var topView: UIView?
    
    let tableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        

        tableView.estimatedRowHeight = 140
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.refreshControl = tableRefreshControl
        
        loadData()
    }
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    func chooseNewCategory(_ nameCategory: String)  {
        feedImgs.removeAll()
        itemsCategory.removeAll()
        var index = 0
        for item in allItemsArray {
           let category = (item as AnyObject).object(forKey: "category") as? String
            if category == nameCategory {
                itemsCategory.append(item)
                feedImgs.append(allImageArray[index])
            }
            index += 1
        }
    }
    
    func transitionToNew(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title
        
        topView?.removeFromSuperview()
        switch menuType {
        case .world:
            chooseNewCategory("В мире\n      ")
            myFeed = itemsCategory as NSArray
            tableView.reloadData()
        case .security:
            chooseNewCategory("Оборона и безопасность\n      ")
            myFeed = itemsCategory as NSArray
            tableView.reloadData()
        case .policy:
            chooseNewCategory("Политика\n      ")
            myFeed = itemsCategory as NSArray
            tableView.reloadData()
        case .economy:
            chooseNewCategory("Экономика\n      ")
            myFeed = itemsCategory as NSArray
            tableView.reloadData()
        case .incidents:
            chooseNewCategory("Происшествия\n      ")
            myFeed = itemsCategory as NSArray
            tableView.reloadData()
        case .society:
            chooseNewCategory("Общество\n      ")
            myFeed = itemsCategory as NSArray
            tableView.reloadData()
        case .culture:
            chooseNewCategory("Культура\n      ")
            myFeed = itemsCategory as NSArray
            tableView.reloadData()
        case .sport:
            chooseNewCategory("Спорт\n      ")
            myFeed = itemsCategory as NSArray
            tableView.reloadData()
        case .science:
            chooseNewCategory("Наука\n      ")
            myFeed = itemsCategory as NSArray
            tableView.reloadData()
        case .hiTech:
            chooseNewCategory("Hi-Tech\n      ")
            myFeed = itemsCategory as NSArray
            tableView.reloadData()
        }
    }
    
    
    @objc private func refresh(sender: UIRefreshControl) {
        loadData()
        sender.endRefreshing()
    }


    func loadData() {
        url = URL(string: "https://www.vesti.ru/vesti.rss")!
        loadRss(url);
    }

    func loadRss(_ data: URL) {


        let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager


        feedImgs = myParser.img as [AnyObject]
        allImageArray = myParser.img as [AnyObject]
        myFeed = myParser.feeds
        allItemsArray = myParser.feeds
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            let detailVC = segue.destination as! DetailViewController
            let feed = myFeed[indexPath.row]
            let image = feedImgs[indexPath.row]
            detailVC.feed = feed
            detailVC.image = image
        }
    }


    // MARK: - Table view data source.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.backgroundColor = UIColor.clear

        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(white: 1, alpha: 0)
        } else {
            cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        }

        // Load feed iamge.
        let url = NSURL(string:feedImgs[indexPath.row] as! String)
        let data = NSData(contentsOf:url! as URL)
        var image = UIImage(data:data! as Data)

        image = resizeImage(image: image!, toTheSize: CGSize(width: 70, height: 70))

        let cellImageLayer: CALayer?  = cell.imageView?.layer

        cellImageLayer!.cornerRadius = 35
        cellImageLayer!.masksToBounds = true
        

        cell.imageView?.image = image
        cell.imageView?.contentMode = .scaleAspectFill
        cell.textLabel?.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "title") as? String
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "pubDate") as? String
        cell.detailTextLabel?.textColor = UIColor.black

        return cell
    }


    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{

        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;

        let rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
}

extension FeedListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}
