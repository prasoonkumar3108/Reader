//
//  ArticlesViewController.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//



import UIKit

class ArticlesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ArticlesViewModel()
    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Headlines"
        view.backgroundColor = .systemBackground
        setupTable()
        setupSearch()
        bindViewModel()
        viewModel.loadArticles()
    }
    
    

    private func setupTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        let nib = UINib(nibName: "ArticleCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ArticleCell.reuseId)
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

    }

    private func setupSearch() {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Search articles"
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.delegate = self
        navigationItem.searchController = sc
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }

    @objc private func onPullToRefresh() {
        viewModel.refresh()
    }
}

extension ArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cd = viewModel.item(at: indexPath.row) else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseId, for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        cell.widthConstraint.constant = 120.0
        cell.showBookmarkButton = true
        cell.configure(with: cd)
        cell.onBookmarkTapped = { [weak self] in
            self?.viewModel.toggleBookmark(at: indexPath.row)
        }
        cell.layoutIfNeeded()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cd = viewModel.item(at: indexPath.row) else { return }
        // Open detail — show basic detail controller with SafariViewController or WebView
        if let urlStr = cd.url, let url = URL(string: urlStr) {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true)
        } else {
            let alert = UIAlertController(title: cd.title, message: cd.content, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

import SafariServices

extension ArticlesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(filter: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(filter: "")
    }
}

