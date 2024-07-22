//
//  ReviewsListViewController.swift
//  Movies
//
//  Created by ios-manha-07 on 22/07/24.
//

import UIKit

class ReviewsListViewController: UIViewController {
        
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        addRateOptions()
    }
    
    
    private let searchController = UISearchController()
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
    
    
    private func addRateOptions() {
        segmentedControl.removeAllSegments()
        
        
        for (index, option) in RateOptions.allCases.enumerated() {
            segmentedControl.insertSegment(withTitle: option.rawValue, at: index, animated: false)
        }
        
        segmentedControl.removeSegment(at: 0, animated: false)
        
        segmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
            
    }
    
}

extension ReviewsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        tableView.reloadData()
    }
}
