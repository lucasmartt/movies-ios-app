//
//  Title.swift
//  Movies
//
//  Created by Lucas Martins on 15/06/24.
//

import Foundation

struct Content: Codable, Equatable {
    let id: String
    let title: String
    let released: String?
    let language: String?
    let country: String?
    let genre: String?
    let plot: String?
    let poster: String?
    let seasons: String?
    
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case released = "Released"
        case language = "Language"
        case country = "Country"
        case genre = "Genre"
        case plot = "Plot"
        case poster = "Poster"
        case seasons = "totalSeasons"
    }
}
