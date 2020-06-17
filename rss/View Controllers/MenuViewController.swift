//
//  MenuViewController.swift
//  rss
//
//  Created by Арина on 14.06.2020.
//  Copyright © 2020 Арина. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case world
    case security
    case policy
    case economy
    case incidents
    case society
    case culture
    case sport
    case science
    case hiTech
}

class MenuViewController: UITableViewController {
    
    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            print("Dismissinf: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }
}

