//
//  TabBarController.swift
//  Movies
//
//  Created by Lucas Martins on 25/06/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewControllers = viewControllers {
            if let navController1 = viewControllers[0] as? UINavigationController {
                if let movieListViewController = navController1.viewControllers.first as? ContentListViewController {
                    movieListViewController.viewTitle = "Movies"
                    movieListViewController.contentType = ContentType.movie
                }
            }
            if let navController2 = viewControllers[1] as? UINavigationController {
                if let seriesListViewController = navController2.viewControllers.first as? ContentListViewController {
                    seriesListViewController.viewTitle = "Series"
                    seriesListViewController.contentType = ContentType.series
                }
            }
            
            
        }
    }

}
