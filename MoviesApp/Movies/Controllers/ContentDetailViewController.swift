//
//  TitleDetailViewController.swift
//  Movies
//
//  Created by Lucas Martins on 16/06/24.
//

import UIKit

class ContentDetailViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var contentFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentGenreLabel: UILabel!
    @IBOutlet weak var contentCountryLabel: UILabel!
    @IBOutlet weak var contentReleasedLabel: UILabel!
    @IBOutlet weak var contentLanguageLabel: UILabel!
    @IBOutlet weak var contentPlotLabel: UILabel!
    
    // Services
    var contentService = ContentService()
    var favoriteService = FavoriteService.shared
    
    // Data
    var contentId: String?
    var contentTitle: String?
    private var content: Content?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentTitleLabel.text = contentTitle
        loadTitleData()
    }
    
    private func loadTitleData() {
        guard let contentId = contentId else { return }
        
        contentService.searchContent(withId: contentId) { content in
            
            self.content = content
            
            // Load movie image
            if let posterURL = content?.poster {
                self.contentService.loadImageData(fromURL: posterURL) { imageData in
                    self.updateContentImage(withImageData: imageData)
                }
            }
            
            DispatchQueue.main.async {
                self.updateViewData()
            }
        }
    }
    
    private func updateViewData() {
        contentGenreLabel.text = content?.genre
        contentCountryLabel.text = content?.country
        contentLanguageLabel.text = content?.language
        contentReleasedLabel.text = content?.released
        contentPlotLabel.text = content?.plot
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        guard let content = content else { return }
        
        let isFavorite = favoriteService.isFavorite(contentId: content.id)
        self.content?.isFavorite = isFavorite
        let favoriteIcon = isFavorite ? "heart.fill" : "heart"
        contentFavoriteButton.image = .init(systemName: favoriteIcon)
    }
    
    private func updateContentImage(withImageData imageData: Data?) {
        guard let imageData = imageData else { return }
        
        DispatchQueue.main.async {
            let contentImage = UIImage(data: imageData)
            self.contentImageView.image = contentImage
        }
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let content = content else { return }
        
        if content.isFavorite {
            // Remove movie from favorite list
            favoriteService.removeContent(withId: content.id)
        } else {
            // Add movie to favorite list
            favoriteService.addContent(content)
        }
        
        updateFavoriteButton()
    }
}
