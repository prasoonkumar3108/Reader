//
//  CDArticleExtensionTests.swift
//  ReaderTests
//
//  Created by Prasoon Tiwari on 29/10/25.
//

import XCTest
import CoreData
@testable import Reader

class CDArticleExtensionTests: XCTestCase {
    
    var context: NSManagedObjectContext {
        return CoreDataStack.shared.context
    }
    
    override func tearDown() {
        cleanCoreData()
        super.tearDown()
    }
    
    private func cleanCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDArticle.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Cleanup error: \(error)")
        }
    }
    
    func testFetchRequestCreation() {
        // When
        let fetchRequest = CDArticle.fetchRequest()
        
        // Then
        XCTAssertEqual(fetchRequest.entityName, "CDArticle")
        XCTAssertTrue(fetchRequest is NSFetchRequest<CDArticle>)
    }
    
    func testCDArticleProperties() {
        // Given
        let entity = NSEntityDescription.entity(forEntityName: "CDArticle", in: context)!
        let article = CDArticle(entity: entity, insertInto: context)
        
        // When
        article.id = "test-id"
        article.title = "Test Title"
        article.author = "Test Author"
        article.content = "Test Content"
        article.url = "https://test.com"
        article.urlToImage = "https://test.com/image.jpg"
        article.publishedAt = Date()
        article.isBookmarked = true
        
        // Then
        XCTAssertEqual(article.id, "test-id")
        XCTAssertEqual(article.title, "Test Title")
        XCTAssertEqual(article.author, "Test Author")
        XCTAssertEqual(article.content, "Test Content")
        XCTAssertEqual(article.url, "https://test.com")
        XCTAssertEqual(article.urlToImage, "https://test.com/image.jpg")
        XCTAssertNotNil(article.publishedAt)
        XCTAssertTrue(article.isBookmarked)
    }
    
    func testDefaultIsBookmarkedValue() {
        // Given
        let entity = NSEntityDescription.entity(forEntityName: "CDArticle", in: context)!
        let article = CDArticle(entity: entity, insertInto: context)
        
        // Then
        XCTAssertFalse(article.isBookmarked)
    }
    
    func testIdentifiableConformance() {
        // Given
        let entity = NSEntityDescription.entity(forEntityName: "CDArticle", in: context)!
        let article = CDArticle(entity: entity, insertInto: context)
        article.id = "test-id"
        
        // Then - Verify Identifiable conformance by checking id property exists and works
        XCTAssertNotNil(article.id)
        XCTAssertEqual(article.id, "test-id")
        
        // Test practical usage in arrays
        let articles = [article]
        XCTAssertEqual(articles.first?.id, "test-id")
    }
}
