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
    private let service = RateService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        addRateOptions()
        setupTableViewCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    private let searchController = UISearchController()
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
    
    private func setupTableViewCell() {
        let cell = UINib(nibName: "ContentTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: ContentTableViewCell.identifier)
        tableView.dataSource = self
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

extension ReviewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        service.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as? ContentTableViewCell else { return UITableViewCell() }
        
        let content = service.getContent(by: indexPath)
        cell.setup(content: content)
        return cell
    }
    
    
}

extension ReviewsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        tableView.reloadData()
    }
}
