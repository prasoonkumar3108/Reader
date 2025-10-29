//
//  ImageLoaderTests.swift
//  ReaderTests
//
//  Created by Prasoon Tiwari on 29/10/25.
//

import XCTest
@testable import Reader

class ImageLoaderTests: XCTestCase {
    
    var imageLoader: ImageLoader!
    
    override func setUp() {
        super.setUp()
        imageLoader = ImageLoader.shared
    }
    
    override func tearDown() {
        imageLoader = nil
        super.tearDown()
    }
    
    func testSingletonInstance() {
        // When & Then
        let instance1 = ImageLoader.shared
        let instance2 = ImageLoader.shared
        
        XCTAssertNotNil(instance1)
        XCTAssertNotNil(instance2)
        // Verify it's the same instance (singleton)
        XCTAssertTrue(instance1 === instance2)
    }
    
    func testLoadImageWithNilURLString() {
        // Given
        let expectation = self.expectation(description: "Load image with nil URL")
        
        // When
        imageLoader.loadImage(from: nil) { image in
            // Then - Should return placeholder or nil
            XCTAssertNotNil(image) // Based on your implementation, it returns UIImage(named: "placeholder")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadImageWithEmptyURLString() {
        // Given
        let expectation = self.expectation(description: "Load image with empty URL")
        
        // When
        imageLoader.loadImage(from: "") { image in
            // Then - Should return placeholder or nil
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadImageWithInvalidURLString() {
        // Given
        let expectation = self.expectation(description: "Load image with invalid URL")
        
        // When
        imageLoader.loadImage(from: "invalid url") { image in
            // Then - Should return placeholder or nil
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
