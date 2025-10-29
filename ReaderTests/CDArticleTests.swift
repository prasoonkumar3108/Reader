//
//  CDArticleTests.swift
//  ReaderTests
//
//  Created by Prasoon Tiwari on 29/10/25.
//

import XCTest
import CoreData
@testable import Reader

class CDArticleTests: XCTestCase {
    
    var context: NSManagedObjectContext {
        return CoreDataStack.shared.context
    }
    
    override func tearDown() {
        // Clean up after each test
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDArticle.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Cleanup error: \(error)")
        }
        
        super.tearDown()
    }
    
    func testCDArticleCreation() {
        // When
        let entity = NSEntityDescription.entity(forEntityName: "CDArticle", in: context)!
        let article = CDArticle(entity: entity, insertInto: context)
        
        // Then
        XCTAssertNotNil(article)
        XCTAssertTrue(article is NSManagedObject)
    }
    
    func testCDArticleEntityName() {
        // When
        let entity = NSEntityDescription.entity(forEntityName: "CDArticle", in: context)
        
        // Then
        XCTAssertNotNil(entity)
        XCTAssertEqual(entity?.name, "CDArticle")
    }
}
