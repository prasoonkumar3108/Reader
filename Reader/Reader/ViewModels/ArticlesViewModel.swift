//
//  ArticlesViewModel.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//



import Foundation

class ArticlesViewModel {
    private let repository: ArticlesRepositoryProtocol
    private(set) var articles: [CDArticle] = []
    var onUpdate: (() -> Void)?

    init(repository: ArticlesRepositoryProtocol = ArticlesRepository()) {
        self.repository = repository
    }

    func loadArticles(refresh: Bool = false) {
        // Try remote fetch first, then fall back to cache
        repository.fetchRemoteArticles { [weak self] result in
            switch result {
            case .success(let dtos):
                // Save to cache and load cache
                self?.repository.saveArticles(dtos) { saveResult in
                    switch saveResult {
                    case .success():
                        self?.articles = self?.repository.loadCachedArticles() ?? []
                        self?.onUpdate?()
                    case .failure(let err):
                        print("Save error: \(err)")
                        self?.articles = self?.repository.loadCachedArticles() ?? []
                        self?.onUpdate?()
                    }
                }
            case .failure(let error):
                print("Remote fetch failed: \(error.localizedDescription). Loading cache.")
                self?.articles = self?.repository.loadCachedArticles() ?? []
                self?.onUpdate?()
            }
        }
    }

    func numberOfItems() -> Int { articles.count }

    func item(at index: Int) -> CDArticle? {
        guard index >= 0 && index < articles.count else { return nil }
        return articles[index]
    }

    func refresh() {
        loadArticles(refresh: true)
    }

    func toggleBookmark(at index: Int) {
        guard let cd = item(at: index) else { return }
        repository.toggleBookmark(for: cd)
        // reflect change
        articles = repository.loadCachedArticles()
        onUpdate?()
    }

    func search(filter: String) {
        if filter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            articles = repository.loadCachedArticles()
        } else {
            let lower = filter.lowercased()
            articles = repository.loadCachedArticles().filter { ($0.title ?? "").lowercased().contains(lower) }
        }
        onUpdate?()
    }

    func loadBookmarks() -> [CDArticle] {
        return repository.loadBookmarkedArticles()
    }
}

