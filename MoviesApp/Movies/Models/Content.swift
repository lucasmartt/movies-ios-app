//
//  Title.swift
//  Movies
//
//  Created by Lucas Martins on 15/06/24.
//

enum Months: String, CaseIterable {
    case january = "Jan"
    case february = "Feb"
    case march = "Mar"
    case april = "Apr"
    case may = "May"
    case june = "Jun"
    case july = "Jul"
    case agust = "Aug"
    case september = "Sep"
    case october = "Oct"
    case november = "Nov"
    case december = "Dec"
}

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
    
    var wishedDate: Date?
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
    }
    
    func releaseDate() -> Date {
        if let released = released {
            let splited = released.split(separator: " ")
            let month = Months.allCases.firstIndex(where: { $0 == Months(rawValue: String(splited[1])) }) ?? 0
            let component = DateComponents(year: Int(String(splited[2])), month: month + 1, day: Int(String(splited[0])))
            guard let date = Calendar.current.date(from: component) else { return .now }
            return date
        }
        return .now
    }
}
