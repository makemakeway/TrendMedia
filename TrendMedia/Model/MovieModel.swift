//
//  MovieModel.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/27.
//

import Foundation

struct MovieModel {
    var id: Int
    var title: String?
    var original_language: String?
    var release_date: String?
    var first_air_date: String?
    var overview: String
    var original_title: String?
    var genre_ids: [Int]
    var vote_average: Double?
    var media_type: String
    var poster_path: String
    var backdrop_path: String
    var origin_country: [String]?
    var name: String?
    var original_name: String?
}

enum DayOrWeek: String {
    case day = "day"
    case week = "week"
}

enum MediaCategory: String {
    case movie = "movie"
    case tv = "tv"
    case all = "all"
    case people = "people"
}
