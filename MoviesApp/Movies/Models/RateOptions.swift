//
//  RateOptions.swift
//  Movies
//
//  Created by Lucas Martins on 14/07/24.
//

import Foundation

enum RateOptions: String, Codable, CaseIterable {
    case unset = "X"
    case good = "😍"
    case average = "😐"
    case bad = "😡"
}
