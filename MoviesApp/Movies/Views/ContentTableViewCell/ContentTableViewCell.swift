//
//  TitleTableViewCell.swift
//  Movies
//
//  Created by Lucas Martins on 16/06/24.
//

import UIKit

protocol ContentTableViewCellDelegate: AnyObject {
    func didTapWishButton(forContent content: Content)
}

class ContentTableViewCell: UITableViewCell {
    
    static let identifier = "contentTableCell"
    weak var delegate: ContentTableViewCellDelegate?
    
    // Outlets
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentGenreLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    private let contentService = ContentService()
    
    // Data
    private var content: Content?
    
    func setup(content: Content) {
        self.content = content
        contentTitleLabel.text = content.title
        contentGenreLabel.text = content.genre ?? "Undefined"
        
        contentImageView.layer.masksToBounds = true
        contentImageView.layer.cornerRadius = content.contentType == .series ? contentImageView.bounds.height/2 : 4
        contentImageView.layer.borderWidth = 1
        contentImageView.layer.borderColor = UIColor.black.cgColor
        
        // Load title's poster from URL
        if let posterURL = content.poster {
            contentService.loadImageData(fromURL: posterURL) { imageData in
                DispatchQueue.main.async {
                    let contentImage = UIImage(data: imageData ?? Data())
                    self.contentImageView.image = contentImage
                }
            }
        }
    }
    
    @IBAction func didTapWishButton(_ sender: Any) {
        guard let content = content else { return }
        delegate?.didTapWishButton(forContent: content)
    }
}
