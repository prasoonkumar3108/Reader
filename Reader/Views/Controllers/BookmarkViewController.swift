//
//  BookmarkViewController.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//



import UIKit
import SafariServices

final class BookmarkViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let repository = ArticlesRepository()
    private var bookmarks: [CDArticle] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmarks"
        view.backgroundColor = .systemBackground
        setupTable()
        loadBookmarks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks() // always re-fetch fresh list from Core Data
    }

    private func setupTable() {
        let nib = UINib(nibName: "ArticleCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ArticleCell.reuseId)
    }

    private func loadBookmarks() {
        bookmarks = repository.loadBookmarkedArticles()
        tableView.reloadData()
    }

}

extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseId, for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        let article = bookmarks[indexPath.row]
        cell.configure(with: article)
        cell.showBookmarkButton = false  //Hide button in bookmark tab
        cell.widthConstraint.constant = 0.0
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = bookmarks[indexPath.row]
        if let urlStr = article.url, let url = URL(string: urlStr) {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true)
        } else {
            let alert = UIAlertController(title: article.title, message: article.content, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

