import UIKit

class WishListViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    // Services
    var wishListService = WishListService.shared
    
    // Search
    private let searchController = UISearchController()
    private var content: [Content] = []
    private var contentType: ContentType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        content = wishListService.listAll(of: contentType)
        tableView.reloadData()
    }
    
    private func setupViewController() {
        setupSearchController()
        setupTableView()
        content = wishListService.listAll(of: contentType)
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
        wishListService.toggleAscending()
        let buttonText = wishListService.isAscending() ? "A-Z" : "Z-A"
        sortButton.setTitle(buttonText, for: .normal)
        wishListService.sort()
        content = wishListService.listAll(of: contentType)
        tableView.reloadData()
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 1: contentType = .movie
        case 2: contentType = .series
        default: contentType = nil
        }
        content = wishListService.listAll(of: contentType)
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension WishListViewController: UITableViewDataSource {
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

extension WishListViewController: ContentTableViewCellDelegate {
    func didTapWishButton(forContent contentItem: Content) {
        content.removeAll(where: { $0 == contentItem })
        wishListService.removeContent(withId: contentItem.id)
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating

extension WishListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            content = wishListService.listAll(of: contentType)
        } else {
            content = filteredTitles(byTitle: searchText)
        }
        
        tableView.reloadData()
    }
    
    private func filteredTitles(byTitle contentTitle: String) -> [Content] {
        wishListService.listAll(of: contentType).filter({ content in
            content.title.contains(contentTitle)
        })
    }
}
