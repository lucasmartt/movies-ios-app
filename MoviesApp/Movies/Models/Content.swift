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
    
    var rate: RateOptions = .unset
    var isWished: Bool = false
    var contentType: ContentType?
    
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
        
        case rate = "appRate"
        case isWished = "appIsWished"
        case contentType = "appContentType"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        released = try container.decodeIfPresent(String.self, forKey: .released)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        genre = try container.decodeIfPresent(String.self, forKey: .genre)
        plot = try container.decodeIfPresent(String.self, forKey: .plot)
        poster = try container.decodeIfPresent(String.self, forKey: .poster)
        seasons = try container.decodeIfPresent(String.self, forKey: .seasons)
        
        rate = try container.decodeIfPresent(RateOptions.self, forKey: .rate) ?? .unset
        isWished = try container.decodeIfPresent(Bool.self, forKey: .isWished) ?? false
        contentType = try container.decodeIfPresent(ContentType.self, forKey: .contentType)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(released, forKey: .released)
        try container.encode(language, forKey: .language)
        try container.encode(country, forKey: .country)
        try container.encode(genre, forKey: .genre)
        try container.encode(plot, forKey: .plot)
        try container.encode(poster, forKey: .poster)
        try container.encode(seasons, forKey: .seasons)
        
        try container.encode(rate, forKey: .rate)
        try container.encode(isWished, forKey: .isWished)
        try container.encode(contentType, forKey: .contentType)
    }
}
