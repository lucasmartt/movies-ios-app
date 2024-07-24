import UIKit

enum SortOptions: String, CaseIterable {
    case byInsertion = "Inserção"
    case byTitle = "Título"
    case byRelease = "Lançamento"
    
    func image() -> UIImage {
        switch self {
        case .byTitle:
            return UIImage(systemName: "clock") ?? UIImage()
        case .byRelease:
            return UIImage(systemName: "clock") ?? UIImage()
        case .byInsertion:
            return UIImage(systemName: "clock") ?? UIImage()
        }
    }
}

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
    private let segueIdentifier = "showContentDetailVC"
    private var currentSortOption: SortOptions = SortOptions.allCases.first ?? SortOptions.byInsertion
    private var contentType: ContentType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupPopup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        content = wishListService.listAll(of: contentType)
        sortContent()
        tableView.reloadData()
    }
    
    func setupPopup() {
        sortButton.menu = UIMenu(title: "Ordenar por", subtitle: nil, image: UIImage(systemName: "clock"), identifier: nil, options: .displayInline, children: SortOptions.allCases.map({ option in
            return UIAction(title: option.rawValue) { [weak self] _ in
                self?.currentSortOption = option
                self?.sortContent()
                self?.tableView.reloadData()
            }
        }))
        sortButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
    
    func sortContent() {
        switch currentSortOption {
        case .byInsertion:
            content.sort { $0.wishedDate ?? .now > $1.wishedDate ?? .now }
        case .byRelease:
            content.sort { $0.releaseDate() < $1.releaseDate() }
        case .byTitle:
            content.sort { $0.title < $1.title }
        }
    }
    
    private func setupViewController() {
        setupSearchController()
        setupTableView()
        content = wishListService.listAll(of: contentType)
        sortContent()
    }
    
    
    private func setupTableView() {
        let nib = UINib(nibName: "ContentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ContentTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contentDetailVC = segue.destination as? ContentDetailViewController,
              let content = sender as? Content else {
                  return
              }
        
        contentDetailVC.contentId = content.id
        contentDetailVC.contentTitle = content.title
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 1: contentType = .movie
        case 2: contentType = .series
        default: contentType = nil
        }
        content = wishListService.listAll(of: contentType)
        sortContent()
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
