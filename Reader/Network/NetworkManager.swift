//
//  NetworkManager.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//


import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    // MARK: - Configure these
    // 1) Sign up at https://newsapi.org and paste API key here
    private let apiKey = "822c2a8ad36a4f14b2dd09f5647fd04c"

    // Optional: You can change country or query
    private let topHeadlinesURLString = "https://newsapi.org/v2/top-headlines?country=us&pageSize=50"

    func fetchTopHeadlines(completion: @escaping (Result<[ArticleDTO], Error>) -> Void) {
        guard !apiKey.isEmpty, apiKey != "API_KEY" else {
            completion(.failure(NSError(domain: "NetworkManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "Missing NewsAPI API key. Paste it in NetworkManager.apiKey"])))
            return
        }

        guard let url = URL(string: "\(topHeadlinesURLString)&apiKey=\(apiKey)") else {
            completion(.failure(NSError(domain: "NetworkManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, resp, error in
            if let err = error {
                DispatchQueue.main.async { completion(.failure(err)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No Data"]))) }
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(NewsAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.articles ?? []))
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
        task.resume()
    }
}

