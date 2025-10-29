//
//  BookmarkViewController.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//



import UIKit
import SafariServices

final class BookmarkViewController: UIViewController {

    private let tableView = UITableView()
    private let repository = ArticlesRepository()
    private var bookmarks: [CDArticle] = []
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmarks"
        view.backgroundColor = .systemBackground
        setupTableView()
        loadBookmarks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks() // always re-fetch fresh list from Core Data
    }

    private func setupTableView() {
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Pull to refresh
        refreshControl.addTarget(self, action: #selector(refreshBookmarks), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func loadBookmarks() {
        bookmarks = repository.loadBookmarkedArticles()
        tableView.reloadData()
    }

    @objc private func refreshBookmarks() {
        loadBookmarks()
        refreshControl.endRefreshing()
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

