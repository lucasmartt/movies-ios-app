//
//  ContentViewController.swift
//  Movies
//
//  Created by Lucas Martins on 25/06/24.
//

import UIKit

class ContentListViewController: UIViewController {
    var contentType: ContentType = .movie
    
    // Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateIcon: UIImageView!
    @IBOutlet weak var emptyStateTitle: UILabel!
    @IBOutlet weak var emptyStateDescription: UILabel!
    
    // Services
    var contentService = ContentService()
    
    // Search
    private let searchController = UISearchController()
    private let defaultSearchName = ""
    private var content: [Content] = []
    private let segueIdentifier = "showContentDetailVC"
    
    // Collection item parameters
    private let itemsPerRow = 2.0
    private let spaceBetweenItems = 6.0
    private let itemAspectRatio = 1.5
    private let marginSize = 32.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        loadContent(withTitle: "")
    }
    
    private func setupViewController() {
        self.title = "Home"
        self.navigationItem.title = contentType == .movie ? "Movies" : "Series"
        setupSearchController()
        setupCollectionView()
    }
    
    private func updateEmptyState(isHidden: Bool, emptyStateIcon: String, emptyStateTitle: String, emptyStateDescription: String) {
        self.emptyStateView.isHidden = isHidden
        self.emptyStateIcon.image = UIImage(systemName: emptyStateIcon)
        self.emptyStateTitle.text = emptyStateTitle
        self.emptyStateDescription.text = emptyStateDescription
    }
    
    private func loadContent(withTitle contentTitle: String) {
        self.content = []
        var isHidden: Bool = false
        var emptyStateIcon: String = ""
        var emptyStateTitle: String = ""
        var emptyStateDescription: String = ""
        
        if (contentTitle == "") {
            emptyStateIcon = "magnifyingglass"
            emptyStateTitle = "Start Searching"
            emptyStateDescription = "Enter a title to begin exploring."
            self.updateEmptyState(
                isHidden: isHidden,
                emptyStateIcon: emptyStateIcon,
                emptyStateTitle: emptyStateTitle,
                emptyStateDescription: emptyStateDescription
            )
        } else {
            contentService.searchContent(withTitle: contentTitle, ofType: contentType) {
                content in DispatchQueue.main.async {
                    if (content.isEmpty) {
                        emptyStateIcon = "exclamationmark.triangle.fill"
                        emptyStateTitle = "No Results"
                        emptyStateDescription = "No items found matching your search." //Please try again with a different term.
                    } else {
                        isHidden = true
                        self.content = content
                    }
                    self.updateEmptyState(
                        isHidden: isHidden,
                        emptyStateIcon: emptyStateIcon,
                        emptyStateTitle: emptyStateTitle,
                        emptyStateDescription: emptyStateDescription
                    )
                    self.collectionView.reloadData()
                }
            }
        }
        //Image: "wifi.slash" Title: "No Connection" Description: "Check your internet connection and try again."
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "ContentCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contentDetailVC = segue.destination as? ContentDetailViewController,
              let content = sender as? Content else {
                  return
              }
        
        contentDetailVC.contentId = content.id
        contentDetailVC.contentTitle = content.title
        contentDetailVC.contentType = contentType
    }
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        contentType =  segmentedControl.selectedSegmentIndex == 0 ? .movie : .series
        navigationItem.title = contentType == .movie ? "Movies" : "Series"
        loadContent(withTitle: searchController.searchBar.text ?? "")
    }
    
}

// MARK: - UICollectionViewDataSource

extension ContentListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as? ContentCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let content = content[indexPath.row]
        cell.setup(content: content)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ContentListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionWidth = collectionView.frame.size.width - marginSize
        let availableWidth = collectionWidth - (spaceBetweenItems * itemsPerRow)
        
        let itemWidth = availableWidth / itemsPerRow
        let itemHeight = itemWidth * itemAspectRatio
        
        return .init(width: itemWidth, height: itemHeight)
    }
}

// MARK: - UICollectionViewDelegate

extension ContentListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedContent = content[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: selectedContent)
    }
}

// MARK: - UISearchResultsUpdating

extension ContentListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            loadContent(withTitle: defaultSearchName)
        } else {
            loadContent(withTitle: searchText)
        }
        
        collectionView.reloadData()
    }
}
