//
//  MovieAPIManager.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/27.
//

import Foundation
import SwiftyJSON
import Alamofire
import UIKit
import Kingfisher


class MovieAPIManager {
    static let shared = MovieAPIManager()
    func fetchMovieData(dayOrWeek: DayOrWeek, category: MediaCategory, page: Int, result: @escaping (Int, JSON)->() ) {
        
        let url = "https://api.themoviedb.org/3/trending/\(category.rawValue)/\(dayOrWeek.rawValue)?api_key=\(API.THE_MOVIE_DATABASE_API)&page=\(page)&language=ko-KR"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let code = response.response?.statusCode ?? 500
                
                result(code, json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchMovieCredit(category: String, id: Int, result: @escaping (Int, JSON) -> ()) {
        let url = "https://api.themoviedb.org/3/\(category)/\(id)/credits?api_key=\(API.THE_MOVIE_DATABASE_API)&language=ko-KR"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let code = response.response?.statusCode ?? 500
                result(code, json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchGenres(mediaType: String,result: @escaping (JSON)->()) {
        let url = "https://api.themoviedb.org/3/genre/\(mediaType)/list?api_key=\(API.THE_MOVIE_DATABASE_API)&language=ko-KR"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                result(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchVideoInfo(category: String, mediaId: Int, result: @escaping (JSON)->()) {
        let url = "https://api.themoviedb.org/3/\(category)/\(mediaId)/videos?api_key=\(API.THE_MOVIE_DATABASE_API)&language=ko-KR"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                result(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchSearchResult(searchText: String, page: Int, result: @escaping (JSON)->()) {
        guard let query = searchText.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) else {
            return
        }
        
        let url = "https://api.themoviedb.org/3/search/multi?api_key=\(API.THE_MOVIE_DATABASE_API)&language=ko-KR&page=\(page)&include_adult=false&query=\(query)"

        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                result(json)
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
