//
//  ArticleDTO.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//


import Foundation

struct NewsAPIResponse: Codable {
    let status: String
    let totalResults: Int?
    let articles: [ArticleDTO]?
}

struct ArticleDTO: Codable {
    let source: SourceDTO?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String? // ISO8601
    let content: String?
}

struct SourceDTO: Codable {
    let id: String?
    let name: String?
}
