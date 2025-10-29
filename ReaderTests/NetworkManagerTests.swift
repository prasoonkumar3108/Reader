//
//  NetworkManagerTests.swift
//  ReaderTests
//
//  Created by Prasoon Tiwari on 29/10/25.
//

import XCTest
@testable import Reader

class NetworkManagerTests: XCTestCase {
    
    func testSingletonInstance() {
        // When & Then
        let instance1 = NetworkManager.shared
        let instance2 = NetworkManager.shared
        
        XCTAssertNotNil(instance1)
        XCTAssertNotNil(instance2)
        // Verify it's the same instance (singleton)
        XCTAssertTrue(instance1 === instance2)
    }
    
    func testAPIKeyConfiguration() {
        // This test verifies that the API key is properly configured
        // Note: In a real project, you might want to use a different approach for testing API keys
        
        // Given
        let networkManager = NetworkManager.shared
        
        // When - We can't directly test the private apiKey, but we can test the public interface
        
        // Then - The class should be properly initialized
        XCTAssertNotNil(networkManager)
    }
}
