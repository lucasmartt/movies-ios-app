//
//  RateService.swift
//  Movies
//
//  Created by Lucas Martins on 14/07/24.
//

import Foundation

class RateService {
    static let shared = RateService()
    private init() {
        ratedContent = getRatedContent()
        sort()
    }
    
    private var ratedContent: [Content] = []
    private var sortBy: String = "title"
    private var ascending: Bool = true
    private let ratedContentKey = "ratedContent"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func listAll() -> [Content] { ratedContent }
    
    func isRated(contentId: String) -> Bool {
        ratedContent.contains { $0.id == contentId }
    }
    
    private func persistRatings() {
        do {
            let data = try encoder.encode(ratedContent)
            UserDefaults.standard.set(data, forKey: ratedContentKey)
        } catch {
            print("Error encoding struct array: \(error)")
        }
    }
    
    private func getRatedContent() -> [Content] {
        guard let data = UserDefaults.standard.data(forKey: ratedContentKey) else { return [] }
        do {
            return try decoder.decode([Content].self, from: data)
        } catch {
            print("Error decoding struct array: \(error)")
            return []
        }
    }
    
    func sort() {
        switch sortBy {
        case "title": ascending
            ? ratedContent.sort { $0.title < $1.title }
            : ratedContent.sort { $0.title > $1.title }
        default: print("Unsupported key for sorting")
        }
    }
    
    func isAscending() -> Bool { ascending }
    
    func toggleAscending() { ascending = !ascending }
        
    func addContent(_ content: Content) {
        ratedContent.append(content)
        sort()
        persistRatings()
    }
        
    func removeContent(withId contentId: String) {
        ratedContent.removeAll { $0.id == contentId }
        sort()
        persistRatings()
    }
}
