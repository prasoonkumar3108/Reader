//
//  ArticlesRepository.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//


import Foundation
import CoreData

protocol ArticlesRepositoryProtocol {
    func fetchRemoteArticles(completion: @escaping (Result<[ArticleDTO], Error>) -> Void)
    func saveArticles(_ dtos: [ArticleDTO], completion: @escaping (Result<Void, Error>) -> Void)
    func loadCachedArticles() -> [CDArticle]
    func toggleBookmark(for cdArticle: CDArticle)
    func loadBookmarkedArticles() -> [CDArticle]
}

final class ArticlesRepository: ArticlesRepositoryProtocol {
    private let core = CoreDataStack.shared
    private let network: NetworkManager

    init(network: NetworkManager = .shared) {
        self.network = network
    }

    func fetchRemoteArticles(completion: @escaping (Result<[ArticleDTO], Error>) -> Void) {
        network.fetchTopHeadlines { result in
            completion(result)
        }
    }

    func saveArticles(_ dtos: [ArticleDTO], completion: @escaping (Result<Void, Error>) -> Void) {
        let ctx = core.context
        ctx.perform {
            do {
                // Preserve bookmarks
                let bookmarkReq: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
                bookmarkReq.predicate = NSPredicate(format: "isBookmarked == YES")
                let bookmarked = try ctx.fetch(bookmarkReq)
                var bookmarkedByURL = [String: Bool]()
                for b in bookmarked {
                    if let url = b.url {
                        bookmarkedByURL[url] = true
                    }
                }

                // Delete all articles first (safe clean refresh)
                let fetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDArticle")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
                try ctx.execute(deleteRequest)

                // Insert fresh articles
                for dto in dtos {
                    guard let ent = NSEntityDescription.entity(forEntityName: "CDArticle", in: ctx) else { continue }
                    let cd = CDArticle(entity: ent, insertInto: ctx)
                    cd.id = dto.url ?? UUID().uuidString
                    cd.title = dto.title
                    cd.author = dto.author
                    cd.content = dto.content
                    cd.url = dto.url
                    cd.urlToImage = dto.urlToImage
                    if let iso = dto.publishedAt {
                        let formatter = ISO8601DateFormatter()
                        cd.publishedAt = formatter.date(from: iso)
                    }
                    cd.isBookmarked = bookmarkedByURL[dto.url ?? ""] ?? false
                }

                try ctx.save()
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    func loadCachedArticles() -> [CDArticle] {
        let ctx = core.context
        let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        return (try? ctx.fetch(req)) ?? []
    }

    func toggleBookmark(for cdArticle: CDArticle) {
        cdArticle.isBookmarked.toggle()
        core.saveContext()
    }

    func loadBookmarkedArticles() -> [CDArticle] {
        let ctx = core.context
        let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
        req.predicate = NSPredicate(format: "isBookmarked == %@", NSNumber(value: true))
        req.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        return (try? ctx.fetch(req)) ?? []
    }
}
