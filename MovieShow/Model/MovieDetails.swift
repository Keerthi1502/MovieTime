//
//  MovieDetails.swift
//  MovieShow
//
//  Created by Gnanasekaran Gajendiran on 6/8/24.
//

import Foundation
import UIKit




struct MovieDetails: Codable {
    var Title: String?
    var Year: String?
    var Rated: String?
    var Released: String?
    var Runtime: String?
    var Genre: String?
    var Director: String?
    var Writer: String?
    var Actors: String?
    var Plot: String?
    var Language: String?
    var Country: String?
    var Awards: String?
    var Poster: String?
    var Ratings: [Rating]?
    var Metascore: String?
    var imdbRating: String?
    var imdbVotes: String?
    var imdbID: String?
    var `Type`: String?
    var DVD: String?
    var BoxOffice: String?
    var Production: String?
    var Website: String?
    var Response: String?
}

struct Rating: Codable {
    var Source: String?
    var Value: String?
}

struct MovieDetailsData {
    static var MovieDetailsList = MovieDetails()
}


struct FavouratiesMainatenance {
    
    static var favouriteMovieImdbIDArr = [String]()
    static var selectedImbdid = ""
    
}
