//
//  FavoriteService.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import Foundation

class FavoriteService {
    static let shared = FavoriteService()
    private init() {
        favoriteContent = getFavorites()
        sort()
    }
    
    private var favoriteContent: [Content] = []
    private var sortBy: String = "title"
    private var ascending: Bool = true
    private let favoriteContentKey = "favoriteContent"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func listAll() -> [Content] { favoriteContent }
    
    func isFavorite(contentId: String) -> Bool {
        favoriteContent.contains { $0.id == contentId }
    }
    
    private func persistFavorites() {
        do {
            let data = try encoder.encode(favoriteContent)
            UserDefaults.standard.set(data, forKey: favoriteContentKey)
        } catch {
            print("Error encoding struct array: \(error)")
        }
    }
    
    private func getFavorites() -> [Content] {
        guard let data = UserDefaults.standard.data(forKey: favoriteContentKey) else { return [] }
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
            ? favoriteContent.sort { $0.title < $1.title }
            : favoriteContent.sort { $0.title > $1.title }
        default: print("Unsupported key for sorting")
        }
    }
    
    func isAscending() -> Bool { ascending }
    
    func toggleAscending() { ascending = !ascending }
        
    func addContent(_ content: Content) {
        favoriteContent.append(content)
        sort()
        persistFavorites()
    }
        
    func removeContent(withId contentId: String) {
        favoriteContent.removeAll { $0.id == contentId }
        sort()
        persistFavorites()
    }
}
