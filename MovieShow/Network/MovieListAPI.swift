//
//  MovieList.swift
//  MovieShow
//
//  Created by Gnanasekaran Gajendiran on 5/8/24.
//

import Foundation
import UIKit

class Movie {
    
    static var movieApiFetch = Movie()
   
    
    func MovieListApi(url: String, completion: @escaping (Bool,String) -> Void) {
        guard let url = URL(string: url ?? "") else {
            print("Invalid url")
            return
        }
            var session = URLSession.shared
           
        session.dataTask(with: url ) { (data,response,error) in
            
            if let error = error {
                completion(false, "Network error: \(error.localizedDescription)")

            }
            if let response = response as? HTTPURLResponse {
                
                var statusCode = response.statusCode
                if (200...299).contains(statusCode) {
                    if let data = data  {
                        print(data)
                        
                        do {
                                let decoder = JSONDecoder()
                                let movieList = try decoder.decode(MovieList.self, from: data)
                            SearchData.movieListData = movieList
                                print(movieList)
                            completion(true,"")
                                
                        } catch {
                            completion(false,"Decode error")
                        }
                       
                    }
                } else {
                    completion(false,"error")
                }
            }
                
        }.resume()
        
        }
        
        
 func fetchMovieDetails(url: String, imdbID: String, apikey: String, completion: @escaping (Bool, String) -> Void) {
        let apiUrl = "\(url)?i=\(imdbID)&apikey=\(apikey)"
        guard let url = URL(string: apiUrl) else {
            print("Invalid url")
            completion(false, "Invalid URL")
            return
        }

        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(false, "Network error: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                
                if (200...299).contains(statusCode) {
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let movieDetails = try decoder.decode(MovieDetails.self, from: data)
                            MovieDetailsData.MovieDetailsList = movieDetails
                            print(movieDetails)
                            completion(true, "")
                        } catch {
                            print(error.localizedDescription)
                            completion(false, error.localizedDescription)
                        }
                    }
                } else {
                    completion(false, "Server error: \(statusCode)")
                }
            }
        }.resume()
    }
    
    }
    
    
