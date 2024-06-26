//
//  TitleService.swift
//  Movies
//
//  Created by Lucas Martins on 15/06/24.
//

import Foundation

struct ContentService {
    
    private let apiBaseURL = "https://www.omdbapi.com/?apikey="
    private let apiToken = "fad9f001"
    
    private var apiURL: String {
        apiBaseURL + apiToken
    }
    
    private let decoder = JSONDecoder()
    
    func searchContent(withTitle title: String, ofType type: ContentType, completion: @escaping ([Content]) -> Void) {
        let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let type = type.rawValue
        let endpoint = apiURL + "&s=\(query)" + "&type=\(type)"
        
        guard let url = URL(string: endpoint) else {
            completion([])
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                    error == nil else {
                completion([])
                return
            }
            
            do {
                let titleResponse = try decoder.decode(ContentSearchResponse.self, from: data)
                let titles = titleResponse.search
                completion(titles)
            } catch {
                print("FETCH ALL TITLES ERROR: \(error)")
                completion([])
            }
        }
        
        task.resume()
    }
    
    func searchContent(withId titleId: String, completion: @escaping (Content?) -> Void) {
        let query = titleId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = apiURL + "&i=\(query)"
        
        guard let url = URL(string: endpoint) else {
            completion(nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let title = try decoder.decode(Content.self, from: data)
                completion(title)
            } catch {
                print("FETCH TITLE ERROR: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func loadImageData(fromURL link: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data)
        }
        
        task.resume()
    }
}

