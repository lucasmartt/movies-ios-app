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
    @IBOutlet weak var emptyState: UIStackView!
    @IBOutlet weak var emptyStateIcon: UIImageView!
    @IBOutlet weak var emptyStateDescription: UILabel!
    @IBOutlet weak var emptyStateTitle: UILabel!
    
    private let service = RateService.shared
    private var ratedContent: [Content] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reviews"
        setupSearchController()
        addRateOptions()
        setupTableViewCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRatedContent()
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
    
    private func updateEmptyState(isHidden: Bool) {
        self.emptyState.isHidden = isHidden
        
        if !isHidden {
        
            if !(searchController.searchBar.text?.isEmpty ?? false) {
                // tentou buscar e não encotrou
                self.emptyStateIcon.image = UIImage(systemName:
                "magnifyingglass")
                self.emptyStateTitle.text = "No Results"
                self.emptyStateDescription.text = "No items found matching your search."
            } else {
                if segmentedControl.selectedSegmentIndex == 0 {
                    // esta na aba all, então: nenhum conteudo foi avaliado
                    self.emptyStateIcon.image = UIImage(systemName: "exclamationmark.triangle.fill")
                    self.emptyStateTitle.text = "No reviews"
                    self.emptyStateDescription.text = "There is no reviews yet"
                } else {
                    // esta em outra aba que não foi avaliada, então: nenhum conteudo nessa categoria
                    self.emptyStateIcon.image = UIImage(systemName: "tray.fill")
                    self.emptyStateTitle.text = "No reviews"
                    self.emptyStateDescription.text = "There is no reviews in this category"
                }
            }
            
           
        }
    }
    
    private func addRateOptions() {
        segmentedControl.removeAllSegments()
        
        for (index, option) in RateOptions.allCases.enumerated() {
            segmentedControl.insertSegment(withTitle: option.rawValue, at: index, animated: false)
        }
        
        segmentedControl.removeSegment(at: 0, animated: false)
        
        segmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        setupRatedContent()
    }
    
    func setupRatedContent() {
        ratedContent = service.getContent(by: RateOptions.allCases[segmentedControl.selectedSegmentIndex])
    }
    
    @IBAction func segmentedTapped(_ sender: Any) {
        setupRatedContent()
        tableView.reloadData()
    }
}

extension ReviewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.updateEmptyState(isHidden: !ratedContent.isEmpty)
        return ratedContent.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as? ContentTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        let content = ratedContent[indexPath.row]
        cell.setup(content: content, acessoryImage: UIImage(systemName: "star.fill"))
        return cell
    }
    
    
}

extension ReviewsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            setupRatedContent()
            segmentedControl.isHidden = false
        } else {
            ratedContent = filteredTitles(byTitle: searchText)
            segmentedControl.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    private func filteredTitles(byTitle contentTitle: String) -> [Content] {
        service.listAll().filter({ content in
            content.title.lowercased().contains(contentTitle.lowercased())
        })
    }
}

extension ReviewsListViewController: ContentTableViewCellDelegate {
    func didTapWishButton(forContent content: Content) {
        service.removeContent(withId: content.id)
        setupRatedContent()
        tableView.reloadData()
    }
}
