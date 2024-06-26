//
//  FavoritesViewController.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    
    // Services
    var favoriteService = FavoriteService.shared
    
    // Search
    private let searchController = UISearchController()
    private var content: [Content] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        content = favoriteService.listAll()
        tableView.reloadData()
    }
    
    private func setupViewController() {
        setupSearchController()
        setupTableView()
        content = favoriteService.listAll()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "ContentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ContentTableViewCell.identifier)
        tableView.dataSource = self
    }
    
    @IBAction func toggleAscending(_ sender: Any) {
        favoriteService.toggleAscending()
        var buttonText = favoriteService.isAscending() ? "A-Z" : "Z-A"
        sortButton.setTitle(buttonText, for: .normal)
        favoriteService.sort()
        content = favoriteService.listAll()
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        let content = content[indexPath.row]
        
        cell.delegate = self
        cell.setup(content: content)
        return cell
    }
}

// MARK: - TitleTableViewCellDelegate

extension FavoritesViewController: ContentTableViewCellDelegate {
    func didTapFavoriteButton(forContent contentItem: Content) {
        content.removeAll(where: { $0 == contentItem })
        favoriteService.removeContent(withId: contentItem.id)
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating

extension FavoritesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            content = favoriteService.listAll()
        } else {
            content = filteredTitles(byTitle: searchText)
        }
        
        tableView.reloadData()
    }
    
    private func filteredTitles(byTitle contentTitle: String) -> [Content] {
        favoriteService.listAll().filter({ content in
            content.title.contains(contentTitle)
        })
    }
}
