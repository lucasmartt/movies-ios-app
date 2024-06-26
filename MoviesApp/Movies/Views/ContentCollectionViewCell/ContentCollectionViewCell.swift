//
//  TitleCollectionViewCell.swift
//  Movies
//
//  Created by Lucas Martins on 16/06/24.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "contentCollectionCell"
    
    // Outlets
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentTitleLabel: UILabel!
    
    private let contentService = ContentService()
    
    func setup(content: Content) {
        contentImageView.layer.masksToBounds = true
        contentImageView.layer.cornerRadius = 8
        contentImageView.layer.borderWidth = 1
        contentImageView.layer.borderColor = UIColor.black.cgColor
        
        // Clean data
        contentImageView.image = nil
        contentTitleLabel.text = nil
        
        // Load title's poster from URL
        if let posterURL = content.poster {
            contentService.loadImageData(fromURL: posterURL) { imageData in
                self.updateCell(withImageData: imageData, orTitle: content.title)
            }
        }
    }
    
    private func updateCell(withImageData imageData: Data?, orTitle title: String) {
        DispatchQueue.main.async {
            if let imageData = imageData {
                // Show title's image
                let titleImage = UIImage(data: imageData)
                self.contentImageView.image = titleImage
            } else {
                // Show title's title if poster is not available
                self.contentTitleLabel.text = title
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImageView.image = nil
        contentTitleLabel.text = nil
    }
}
