//
//  ImageLoader.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//


import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}

    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let s = urlString, let url = URL(string: s) else {
            completion(UIImage(named: "placeholder"))
            return
        }
        if let cached = cache.object(forKey: s as NSString) {
            completion(cached)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            var img: UIImage?
            if let data = data { img = UIImage(data: data) }
            if let img = img {
                self.cache.setObject(img, forKey: s as NSString)
            }
            DispatchQueue.main.async { completion(img ?? UIImage(named: "placeholder")) }
        }
        task.resume()
    }
}

