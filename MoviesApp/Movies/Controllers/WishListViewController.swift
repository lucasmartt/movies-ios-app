import UIKit

class WishListViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    
    // Services
    var wishListService = WishListService.shared
    
    // Search
    private let searchController = UISearchController()
    private var content: [Content] = []
    private let segueIdentifier = "showContentDetailVC"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        content = wishListService.listAll()
        tableView.reloadData()
    }
    
    private func setupViewController() {
        setupSearchController()
        setupTableView()
        content = wishListService.listAll()
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
        tableView.delegate = self
    }
    
    @IBAction func toggleAscending(_ sender: Any) {
        wishListService.toggleAscending()
        let buttonText = wishListService.isAscending() ? "A-Z" : "Z-A"
        sortButton.setTitle(buttonText, for: .normal)
        wishListService.sort()
        content = wishListService.listAll()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contentDetailVC = segue.destination as? ContentDetailViewController,
              let content = sender as? Content else {
                  return
              }
        
        contentDetailVC.contentId = content.id
        contentDetailVC.contentTitle = content.title
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

// MARK: - UITableViewDelegate

extension WishListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContent = content[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: selectedContent)
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
            content = wishListService.listAll()
        } else {
            content = filteredTitles(byTitle: searchText)
        }
        
        tableView.reloadData()
    }
    
    private func filteredTitles(byTitle contentTitle: String) -> [Content] {
        wishListService.listAll().filter({ content in
            content.title.contains(contentTitle)
        })
    }
}
