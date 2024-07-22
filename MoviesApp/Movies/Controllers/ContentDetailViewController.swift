//
//  TitleDetailViewController.swift
//  Movies
//
//  Created by Lucas Martins on 16/06/24.
//

import UIKit

class ContentDetailViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var contentWishButton: UIBarButtonItem!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentGenreLabel: UILabel!
    @IBOutlet weak var contentCountryLabel: UILabel!
    @IBOutlet weak var contentReleasedLabel: UILabel!
    @IBOutlet weak var contentLanguageLabel: UILabel!
    @IBOutlet weak var contentPlotLabel: UILabel!
    @IBOutlet weak var contentCastLabel: UILabel!
    
    @IBOutlet weak var contentRatingsSegCtrl: UISegmentedControl!
    
    // Services
    var contentService = ContentService()
    var wishListService = WishListService.shared
    var rateService = RateService.shared
    
    // Data
    var contentId: String?
    var contentTitle: String?
    var contentType: ContentType?
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
                self.addRateOptions()
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
        contentCastLabel.text = content?.actors
        updateWishButton()
    }
    
    private func updateWishButton() {
        guard let content = content else { return }
        
        let isWished = wishListService.isWished(contentId: content.id)
        self.content?.isWished = isWished
        let wishIcon = isWished ? "clock.fill" : "clock"
        contentWishButton.image = .init(systemName: wishIcon)
    }
    
    private func updateContentImage(withImageData imageData: Data?) {
        guard let imageData = imageData else { return }
        
        DispatchQueue.main.async {
            let contentImage = UIImage(data: imageData)
            self.contentImageView.image = contentImage
        }
    }
    
    private func addRateOptions() {
        guard let content = content else { return }
        let rate = rateService.getRate(withId: content.id)
        contentRatingsSegCtrl.removeAllSegments()
        for (index, option) in RateOptions.allCases.enumerated() {
            contentRatingsSegCtrl.insertSegment(withTitle: option.rawValue, at: index, animated: false)
            if option == rate {
                contentRatingsSegCtrl.selectedSegmentIndex = index
            }
        }
    }
    
    @IBAction func ratingValueChanged(_ sender: Any) {
        guard let content = content else { return }

        let newRate = RateOptions.allCases[contentRatingsSegCtrl.selectedSegmentIndex]

        if newRate == .unset {
            if rateService.isRated(contentId: content.id) {
                rateService.removeContent(withId: content.id)
            }
        } else {
            if !rateService.isRated(contentId: content.id) {
                rateService.addContent(content)
            }
            rateService.updateRate(forId: content.id, newRate: newRate)
        }
        //print(self.content ?? "")
    }
    
    @IBAction func didTapWishButton(_ sender: Any) {
        guard var content = content else { return }
        content.contentType = contentType
        
        if content.isWished {
            wishListService.removeContent(withId: content.id)
        } else {
            wishListService.addContent(content)
        }
        
        updateWishButton()
    }
}
