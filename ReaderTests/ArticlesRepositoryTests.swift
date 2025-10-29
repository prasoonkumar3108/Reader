//
//  ArticlesRepositoryTests.swift
//  ReaderTests
//
//  Created by Prasoon Tiwari on 29/10/25.
//
import XCTest
import CoreData
@testable import Reader

class ArticlesRepositoryTests: XCTestCase {
    
    var repository: ArticlesRepository!
    
    override func setUp() {
        super.setUp()
        repository = ArticlesRepository()
        cleanCoreData()
    }
    
    override func tearDown() {
        cleanCoreData()
        repository = nil
        super.tearDown()
    }
    
    private func cleanCoreData() {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDArticle.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Cleanup error: \(error)")
        }
    }
    
    func testLoadCachedArticlesEmpty() {
        // When
        let cached = repository.loadCachedArticles()
        
        // Then
        XCTAssertTrue(cached.isEmpty)
    }
    
    func testSaveAndLoadArticles() {
        // Given
        let expectation = self.expectation(description: "Save articles")
        let articles = [
            ArticleDTO(source: SourceDTO(id: "1", name: "Test"),
                      author: "Author", title: "Test Title", description: "Desc",
                      url: "https://test.com", urlToImage: nil,
                      publishedAt: "2023-01-01T00:00:00Z", content: "Content")
        ]
        
        // When
        repository.saveArticles(articles) { result in
            // Then
            switch result {
            case .success:
                let cached = self.repository.loadCachedArticles()
                XCTAssertEqual(cached.count, 1)
                XCTAssertEqual(cached.first?.title, "Test Title")
            case .failure(let error):
                XCTFail("Expected success but got failure: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    func testToggleBookmark() {
        // Given
        let saveExpectation = self.expectation(description: "Save articles")
        let articles = [
            ArticleDTO(source: SourceDTO(id: "1", name: "Test"),
                      author: "Author", title: "Test Article", description: "Desc",
                      url: "https://test.com", urlToImage: nil,
                      publishedAt: "2023-01-01T00:00:00Z", content: "Content")
        ]
        
        repository.saveArticles(articles) { _ in saveExpectation.fulfill() }
        waitForExpectations(timeout: 2.0)
        
        guard let article = repository.loadCachedArticles().first else {
            XCTFail("No articles found")
            return
        }
        
        // When & Then - Toggle bookmark on
        repository.toggleBookmark(for: article)
        XCTAssertTrue(article.isBookmarked)
        
        // When & Then - Toggle bookmark off
        repository.toggleBookmark(for: article)
        XCTAssertFalse(article.isBookmarked)
    }
    
    func testLoadBookmarkedArticles() {
        // Given
        let saveExpectation = self.expectation(description: "Save articles")
        let articles = [
            ArticleDTO(source: SourceDTO(id: "1", name: "Test1"),
                      author: "Author1", title: "Article One", description: "Desc1",
                      url: "https://test1.com", urlToImage: nil,
                      publishedAt: "2023-01-01T00:00:00Z", content: "Content1"),
            ArticleDTO(source: SourceDTO(id: "2", name: "Test2"),
                      author: "Author2", title: "Article Two", description: "Desc2",
                      url: "https://test2.com", urlToImage: nil,
                      publishedAt: "2023-01-02T00:00:00Z", content: "Content2")
        ]
        
        repository.saveArticles(articles) { _ in saveExpectation.fulfill() }
        waitForExpectations(timeout: 2.0)
        
        let cached = repository.loadCachedArticles()
        XCTAssertEqual(cached.count, 2)
        
        // Find the specific article we want to bookmark by URL
        guard let articleToBookmark = cached.first(where: { $0.url == "https://test1.com" }) else {
            XCTFail("Article with URL https://test1.com not found")
            return
        }
        
        // When - Bookmark the specific article
        repository.toggleBookmark(for: articleToBookmark)
        let bookmarked = repository.loadBookmarkedArticles()
        
        // Then
        XCTAssertEqual(bookmarked.count, 1)
        XCTAssertEqual(bookmarked.first?.title, "Article One")
        XCTAssertEqual(bookmarked.first?.url, "https://test1.com")
        XCTAssertTrue(bookmarked.first?.isBookmarked ?? false)
    }
    
    func testLoadBookmarkedArticlesMultiple() {
        // Given
        let saveExpectation = self.expectation(description: "Save articles")
        let articles = [
            ArticleDTO(source: SourceDTO(id: "1", name: "Test1"),
                      author: "Author1", title: "First Article", description: "Desc1",
                      url: "https://test1.com", urlToImage: nil,
                      publishedAt: "2023-01-01T00:00:00Z", content: "Content1"),
            ArticleDTO(source: SourceDTO(id: "2", name: "Test2"),
                      author: "Author2", title: "Second Article", description: "Desc2",
                      url: "https://test2.com", urlToImage: nil,
                      publishedAt: "2023-01-02T00:00:00Z", content: "Content2"),
            ArticleDTO(source: SourceDTO(id: "3", name: "Test3"),
                      author: "Author3", title: "Third Article", description: "Desc3",
                      url: "https://test3.com", urlToImage: nil,
                      publishedAt: "2023-01-03T00:00:00Z", content: "Content3")
        ]
        
        repository.saveArticles(articles) { _ in saveExpectation.fulfill() }
        waitForExpectations(timeout: 2.0)
        
        let cached = repository.loadCachedArticles()
        XCTAssertEqual(cached.count, 3)
        
        // Bookmark two specific articles by their URLs
        let article1 = cached.first(where: { $0.url == "https://test1.com" })!
        let article3 = cached.first(where: { $0.url == "https://test3.com" })!
        
        repository.toggleBookmark(for: article1)
        repository.toggleBookmark(for: article3)
        
        // When
        let bookmarked = repository.loadBookmarkedArticles()
        
        // Then
        XCTAssertEqual(bookmarked.count, 2)
        
        // Verify both bookmarked articles are in the result
        let bookmarkedUrls = bookmarked.map { $0.url }
        XCTAssertTrue(bookmarkedUrls.contains("https://test1.com"))
        XCTAssertTrue(bookmarkedUrls.contains("https://test3.com"))
        XCTAssertFalse(bookmarkedUrls.contains("https://test2.com"))
    }
    
    func testLoadCachedArticlesOrder() {
        // Given
        let saveExpectation = self.expectation(description: "Save articles")
        let articles = [
            ArticleDTO(source: SourceDTO(id: "1", name: "Test1"),
                      author: "Author1", title: "Older Article", description: "Desc1",
                      url: "https://test1.com", urlToImage: nil,
                      publishedAt: "2023-01-01T00:00:00Z", content: "Content1"),
            ArticleDTO(source: SourceDTO(id: "2", name: "Test2"),
                      author: "Author2", title: "Newer Article", description: "Desc2",
                      url: "https://test2.com", urlToImage: nil,
                      publishedAt: "2023-01-02T00:00:00Z", content: "Content2")
        ]
        
        repository.saveArticles(articles) { _ in saveExpectation.fulfill() }
        waitForExpectations(timeout: 2.0)
        
        // When
        let cached = repository.loadCachedArticles()
        
        // Then - Should be sorted by publishedAt descending (newest first)
        XCTAssertEqual(cached.count, 2)
        
        // Check that articles are sorted by date (newest first)
        if let firstArticle = cached.first, let secondArticle = cached.last {
            XCTAssertTrue(firstArticle.publishedAt ?? Date() >= secondArticle.publishedAt ?? Date())
        } else {
            XCTFail("Could not get first and second articles")
        }
    }
    
    func testBookmarkPersistenceAfterSave() {
        // Given - First save articles and bookmark one
        let firstSaveExpectation = self.expectation(description: "First save articles")
        let firstArticles = [
            ArticleDTO(source: SourceDTO(id: "1", name: "Test1"),
                      author: "Author1", title: "First Article", description: "Desc1",
                      url: "https://test1.com", urlToImage: nil,
                      publishedAt: "2023-01-01T00:00:00Z", content: "Content1")
        ]
        
        repository.saveArticles(firstArticles) { _ in firstSaveExpectation.fulfill() }
        waitForExpectations(timeout: 2.0)
        
        // Bookmark the article
        let cached = repository.loadCachedArticles()
        guard let article = cached.first else {
            XCTFail("No articles found")
            return
        }
        repository.toggleBookmark(for: article)
        XCTAssertTrue(article.isBookmarked)
        
        // When - Save new articles (which should preserve bookmarks)
        let secondSaveExpectation = self.expectation(description: "Second save articles")
        let secondArticles = [
            ArticleDTO(source: SourceDTO(id: "1", name: "Test1"),
                      author: "Author1", title: "First Article Updated", description: "Desc1 Updated",
                      url: "https://test1.com", urlToImage: nil,
                      publishedAt: "2023-01-01T00:00:00Z", content: "Content1 Updated")
        ]
        
        repository.saveArticles(secondArticles) { _ in secondSaveExpectation.fulfill() }
        waitForExpectations(timeout: 2.0)
        
        // Then - The bookmark should be preserved
        let updatedCached = repository.loadCachedArticles()
        let bookmarkedArticles = repository.loadBookmarkedArticles()
        
        XCTAssertEqual(updatedCached.count, 1)
        XCTAssertEqual(bookmarkedArticles.count, 1)
        XCTAssertEqual(bookmarkedArticles.first?.title, "First Article Updated")
        XCTAssertTrue(bookmarkedArticles.first?.isBookmarked ?? false)
    }
}
