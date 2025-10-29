//
//  ArticleCell.swift
//  Reader
//
//  Created by Prasoon Tiwari on 29/10/25.
//

import UIKit

class ArticleCell: UITableViewCell {
    static let reuseId = "ArticleCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!

    var onBookmarkTapped: (() -> Void)?
    var showBookmarkButton: Bool = true {
        didSet {
            bookmarkButton.isHidden = !showBookmarkButton
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // Force labels to calculate proper width before rendering
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
        authorLabel.preferredMaxLayoutWidth = authorLabel.frame.width
    }
        
    private func setup() {
        
        contentView.backgroundColor = .secondaryBackground
        backgroundColor = .clear
        imageContainerView.backgroundColor = .clear
        containerView.backgroundColor = .background
        titleLabel?.textColor = .textPrimary
        authorLabel?.textColor = .secondary
        thumbImageView?.tintColor = .primary
        
        bookmarkButton?.tintColor = .textPrimary
        bookmarkButton?.backgroundColor = .secondary
        
        // Apply corner radius to image view
        thumbImageView.layer.cornerRadius = 10
        thumbImageView.clipsToBounds = true
        
        // Apply corner radius to container view
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        // Apply corner radius to bookmark button
        bookmarkButton.layer.cornerRadius = 15.0
        bookmarkButton.clipsToBounds = true
    }
    
    @IBAction func bookmarkTapped(_ sender: UIButton) {
        onBookmarkTapped?()
    }
    func configure(with cdArticle: CDArticle) {
        titleLabel.text = cdArticle.title
        authorLabel.text = cdArticle.author ?? "Unknown"
        bookmarkButton.setTitle(cdArticle.isBookmarked ? "Bookmarked" : "Bookmark", for: .normal)
        ImageLoader.shared.loadImage(from: cdArticle.urlToImage) { [weak self] img in
            self?.thumbImageView.tintColor = UIColor(named: "Color/Primary")
            self?.thumbImageView.image = img
            
        }
    }
}
