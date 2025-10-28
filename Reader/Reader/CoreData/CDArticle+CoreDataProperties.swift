//
//  CDArticle+CoreDataProperties.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//


import Foundation
import CoreData

extension CDArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDArticle> {
        return NSFetchRequest<CDArticle>(entityName: "CDArticle")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var isBookmarked: Bool
}

extension CDArticle : Identifiable {

}

