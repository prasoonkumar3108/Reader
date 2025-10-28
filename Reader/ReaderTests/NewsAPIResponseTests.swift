//
//  NewsAPIResponseTests.swift
//  ReaderTests
//
//  Created by Prasoon Tiwari on 29/10/25.
//

import XCTest
@testable import Reader

class NewsAPIResponseTests: XCTestCase {
    
    func testNewsAPIResponseDecoding() throws {
        // Given
        let json = """
        {
            "status": "ok",
            "totalResults": 10,
            "articles": [
                {
                    "source": {"id": "test-id", "name": "Test Source"},
                    "author": "Test Author",
                    "title": "Test Title",
                    "description": "Test Description",
                    "url": "https://test.com",
                    "urlToImage": "https://test.com/image.jpg",
                    "publishedAt": "2023-01-01T00:00:00Z",
                    "content": "Test content"
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let response = try decoder.decode(NewsAPIResponse.self, from: json)
        
        // Then
        XCTAssertEqual(response.status, "ok")
        XCTAssertEqual(response.totalResults, 10)
        XCTAssertEqual(response.articles?.count, 1)
    }
    
    func testArticleDTODecoding() throws {
        // Given
        let json = """
        {
            "source": {"id": "test-id", "name": "Test Source"},
            "author": "Test Author",
            "title": "Test Title",
            "description": "Test Description",
            "url": "https://test.com",
            "urlToImage": "https://test.com/image.jpg",
            "publishedAt": "2023-01-01T00:00:00Z",
            "content": "Test content"
        }
        """.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let article = try decoder.decode(ArticleDTO.self, from: json)
        
        // Then
        XCTAssertEqual(article.author, "Test Author")
        XCTAssertEqual(article.title, "Test Title")
        XCTAssertEqual(article.url, "https://test.com")
        XCTAssertEqual(article.source?.id, "test-id")
        XCTAssertEqual(article.source?.name, "Test Source")
    }
    
    func testSourceDTODecoding() throws {
        // Given
        let json = """
        {
            "id": "test-id",
            "name": "Test Source"
        }
        """.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let source = try decoder.decode(SourceDTO.self, from: json)
        
        // Then
        XCTAssertEqual(source.id, "test-id")
        XCTAssertEqual(source.name, "Test Source")
    }
    
    func testOptionalFields() throws {
        // Given
        let json = """
        {
            "status": "ok",
            "totalResults": null,
            "articles": null
        }
        """.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let response = try decoder.decode(NewsAPIResponse.self, from: json)
        
        // Then
        XCTAssertEqual(response.status, "ok")
        XCTAssertNil(response.totalResults)
        XCTAssertNil(response.articles)
    }
}
