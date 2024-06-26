//
//  TitleSearchResponse.swift
//  Movies
//
//  Created by Lucas Martins on 15/06/24.
//

import Foundation

struct ContentSearchResponse: Decodable {
    let search: [Content]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
