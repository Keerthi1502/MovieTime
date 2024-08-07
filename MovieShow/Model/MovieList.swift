//
//  MovieList.swift
//  MovieShow
//
//  Created by Gnanasekaran Gajendiran on 5/8/24.
//

import Foundation
import UIKit

struct MovieList: Codable {
    var Search: [searchData]?
    var totalResults: String?
    var Response: String?
    
}
struct searchData : Codable {
    var Title: String?
    var Year: String?
    var imdbID: String?
    var `Type` : String?
    var Poster: String?
}

struct SearchData {
    static var movieListData = MovieList()
    static  var filteredMovieList = [searchData]()
    static var searchBool = false
}




