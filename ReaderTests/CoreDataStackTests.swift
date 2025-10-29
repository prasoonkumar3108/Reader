//
//  CoreDataStackTests.swift
//  ReaderTests
//
//  Created by Prasoon Tiwari on 29/10/25.
//

import XCTest
import CoreData
@testable import Reader

class CoreDataStackTests: XCTestCase {
    
    func testSingletonInstance() {
        // When & Then
        let instance1 = CoreDataStack.shared
        let instance2 = CoreDataStack.shared
        
        XCTAssertNotNil(instance1)
        XCTAssertNotNil(instance2)
        // Verify it's the same instance (singleton)
        XCTAssertTrue(instance1 === instance2)
    }
    
    func testContextIsMainQueue() {
        // Given
        let context = CoreDataStack.shared.context
        
        // Then
        XCTAssertTrue(context.concurrencyType == .mainQueueConcurrencyType)
    }
    
    func testPersistentContainerSetup() {
        // Given
        let container = CoreDataStack.shared.persistentContainer
        
        // Then
        XCTAssertNotNil(container)
        XCTAssertEqual(container.name, "ReaderModel")
    }
    
    func testSaveContext() {
        // Given
        let context = CoreDataStack.shared.context
        
        // When
        let entity = NSEntityDescription.entity(forEntityName: "CDArticle", in: context)!
        let article = CDArticle(entity: entity, insertInto: context)
        article.title = "Test Article"
        article.id = UUID().uuidString
        
        // Then - Should not throw when saving
        XCTAssertNoThrow(try context.save())
    }
}
