//
//  ArticlesViewController.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//



import UIKit

class ArticlesViewController: UIViewController {
    private let tableView = UITableView()
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
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        cell.configure(with: cd)
        cell.onBookmarkTapped = { [weak self] in
            self?.viewModel.toggleBookmark(at: indexPath.row)
        }
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

