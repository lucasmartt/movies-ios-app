import Foundation

class WishListService {
    static let shared = WishListService()
    private init() {
        wishedContent = getWishedContent()
    }
    
    private var wishedContent: [Content] = []
    private var sortBy: String = "title"
    private var ascending: Bool = true
    private let wishedContentKey = "wishedContent"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func listAll() -> [Content] { wishedContent }
    
    func isWished(contentId: String) -> Bool {
        wishedContent.contains { $0.id == contentId }
    }
    
    private func persistWishList() {
        do {
            let data = try encoder.encode(wishedContent)
            UserDefaults.standard.set(data, forKey: wishedContentKey)
        } catch {
            print("Error encoding struct array: \(error)")
        }
    }
    
    private func getWishedContent() -> [Content] {
        guard let data = UserDefaults.standard.data(forKey: wishedContentKey) else { return [] }
        do {
            return try decoder.decode([Content].self, from: data)
        } catch {
            print("Error decoding struct array: \(error)")
            return []
        }
    }
    
    func isAscending() -> Bool { ascending }
    
    func toggleAscending() { ascending = !ascending }
        
    func addContent(_ content: Content) {
        wishedContent.append(content)
        persistWishList()
    }
        
    func removeContent(withId contentId: String) {
        wishedContent.removeAll { $0.id == contentId }
        persistWishList()
    }
}
