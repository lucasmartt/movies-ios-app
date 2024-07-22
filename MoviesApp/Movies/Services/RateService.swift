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
        ratedContent = getPersistedRatings()
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
            for c in ratedContent {
                print(c.title, c.rate)
            }
            let data = try encoder.encode(ratedContent)
            UserDefaults.standard.set(data, forKey: ratedContentKey)
        } catch {
            print("Error encoding struct array: \(error)")
        }
    }
    
    private func getPersistedRatings() -> [Content] {
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
    
    private func getContentIndex(forId id: String) -> Int? {
        return ratedContent.firstIndex(where: { $0.id == id })
    }
    
    func getContent(by rating: RateOptions) -> [Content] {
        if rating == .unset { return ratedContent }
        return ratedContent.filter({$0.rate == rating})
    }
    
    func getRate(withId id: String) -> RateOptions {
        if let index = getContentIndex(forId: id) {
            return ratedContent[index].rate
        }
        return .unset
    }
        
    func updateRate(forId id: String, newRate: RateOptions) {
        if let index = getContentIndex(forId: id) {
            ratedContent[index].rate = newRate
            sort()
            persistRatings()
        }
    }
    
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
