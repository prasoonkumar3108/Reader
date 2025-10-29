//
//  ArticleCell.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//


import UIKit

//class ArticleCell: UITableViewCell {
//    static let reuseId = "ArticleCell"
//
//    private let thumbImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        iv.layer.cornerRadius = 8
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.widthAnchor.constraint(equalToConstant: 90).isActive = true
//        iv.heightAnchor.constraint(equalToConstant: 70).isActive = true
//        return iv
//    }()
//
//    private let titleLabel: UILabel = {
//        let l = UILabel()
//        l.numberOfLines = 2
//        l.font = .preferredFont(forTextStyle: .headline)
//        l.translatesAutoresizingMaskIntoConstraints = false
//        return l
//    }()
//
//    private let authorLabel: UILabel = {
//        let l = UILabel()
//        l.numberOfLines = 1
//        l.font = .preferredFont(forTextStyle: .subheadline)
//        l.textColor = .secondaryLabel
//        l.translatesAutoresizingMaskIntoConstraints = false
//        return l
//    }()
//
//    private let bookmarkButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("Bookmark", for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//
//    var onBookmarkTapped: (() -> Void)?
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setup()
//    }
//
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//
//    private func setup() {
//        accessoryType = .none
//        let stack = UIStackView(arrangedSubviews: [titleLabel, authorLabel, UIView()])
//        stack.axis = .vertical
//        stack.spacing = 6
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(thumbImageView)
//        contentView.addSubview(stack)
//        contentView.addSubview(bookmarkButton)
//
//        NSLayoutConstraint.activate([
//            thumbImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            thumbImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//
//            stack.leadingAnchor.constraint(equalTo: thumbImageView.trailingAnchor, constant: 12),
//            stack.trailingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor, constant: -8),
//            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
//            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
//
//            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            bookmarkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
//
//        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
//    }
//
//    @objc private func bookmarkTapped() {
//        onBookmarkTapped?()
//    }
//
//    func configure(with cdArticle: CDArticle) {
//        titleLabel.text = cdArticle.title
//        authorLabel.text = cdArticle.author ?? "Unknown"
//        let title = cdArticle.isBookmarked ? "Bookmarked" : "Bookmark"
//        bookmarkButton.setTitle(title, for: .normal)
//        ImageLoader.shared.loadImage(from: cdArticle.urlToImage) { [weak self] img in
//            self?.thumbImageView.image = img
//        }
//    }
//}


class ArticleCell: UITableViewCell {
    static let reuseId = "ArticleCell"

    private let thumbImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 90).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 2
        l.font = .preferredFont(forTextStyle: .headline)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let authorLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.font = .preferredFont(forTextStyle: .subheadline)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Bookmark", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    var onBookmarkTapped: (() -> Void)?
    var showBookmarkButton: Bool = true {
        didSet {
            bookmarkButton.isHidden = !showBookmarkButton
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        accessoryType = .none
        let stack = UIStackView(arrangedSubviews: [titleLabel, authorLabel, UIView()])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(thumbImageView)
        contentView.addSubview(stack)
        contentView.addSubview(bookmarkButton)

        NSLayoutConstraint.activate([
            thumbImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stack.leadingAnchor.constraint(equalTo: thumbImageView.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor, constant: -8),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bookmarkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
    }

    @objc private func bookmarkTapped() {
        onBookmarkTapped?()
    }

    func configure(with cdArticle: CDArticle) {
        titleLabel.text = cdArticle.title
        authorLabel.text = cdArticle.author ?? "Unknown"
        bookmarkButton.setTitle(cdArticle.isBookmarked ? "Bookmarked" : "Bookmark", for: .normal)
        ImageLoader.shared.loadImage(from: cdArticle.urlToImage) { [weak self] img in
            self?.thumbImageView.image = img
        }
    }
}
