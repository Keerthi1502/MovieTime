//
//  MovieListViewController.swift
//  MovieShow
//
//  Created by Gnanasekaran Gajendiran on 5/8/24.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var moviewListTableView: UITableView!
    @IBOutlet weak var networkErrorImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    
    var movieList = [searchData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewHeight.constant = 0
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.text = ""
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setView() {
        let movieListTableViewCell = UINib(nibName: "MovieListTableViewCell", bundle: nil)
        searchBar.searchTextField.textColor = UIColor.black
        searchBar.placeholder = "Search Movie"
        moviewListTableView.showsVerticalScrollIndicator = false
        moviewListTableView.showsHorizontalScrollIndicator = false
        moviewListTableView.register(movieListTableViewCell, forCellReuseIdentifier: "MovieList")
        moviewListTableView.delegate = self
        moviewListTableView.dataSource = self
         setDatas()
        movieListApiCall()
    }
    
    func setDatas() {
        searchViewHeight.constant = 0
        moviewListTableView.isHidden =  true
        noDataLabel.isHidden =  true
        networkErrorImage.isHidden =  true
       if let favouriteArr =  UserDefaults.standard.array(forKey: "FavouriteMovies") as? [String] {
           FavouratiesMainatenance.favouriteMovieImdbIDArr = favouriteArr
       } else {
           FavouratiesMainatenance.favouriteMovieImdbIDArr = []
       }
    }
    
    func movieListApiCall() {
        var url = "\(AvailableAPI.baseURL)?apikey=64e5c48a&type=movie&s=Don"
        Movie.movieApiFetch.MovieListApi(url: url) { [self] (success, error) in
            if success {
                
                if SearchData.movieListData != nil {
                    
                    if SearchData.movieListData.Search?.count != 0 {
                        self.movieList = SearchData.movieListData.Search ?? []
                        DispatchQueue.main.async {
                            self.moviewListTableView.isHidden = false
                            networkErrorImage.isHidden = true
                            noDataLabel.isHidden = true
                            self.moviewListTableView.reloadData()
                        }
                    }

                } else {
                    networkErrorImage.isHidden = true
                    self.moviewListTableView.isHidden = true
                    noDataLabel.isHidden = false
                }
                
            } else  {
                networkErrorImage.isHidden = false
                moviewListTableView.isHidden = true
                noDataLabel.isHidden = true
                print("something went wrong")
            }
            
        }
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        searchViewHeight.constant = 43
    }
    
}


extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if SearchData.searchBool{
            return  SearchData.filteredMovieList.count ?? 0
        } else {
            return  SearchData.movieListData.Search?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = moviewListTableView.dequeueReusableCell(withIdentifier: "MovieList", for: indexPath) as! MovieListTableViewCell
        var movie = searchData()
        cell.selectionStyle = .none
        if SearchData.searchBool {
            movie =   SearchData.filteredMovieList[indexPath.row]
        } else {
            if movieList.count != 0 {
                movie =  movieList[indexPath.row]
            }
        }

        var index : Int?
        cell.favouriteButton.tag = indexPath.row
        cell.cellDelegate = self
        let isSelected = FavouratiesMainatenance.favouriteMovieImdbIDArr.contains(movie.imdbID ?? "")

        cell.configure(with:  movie.Poster ?? "", index: indexPath.row, favouriteBool: isSelected, searchBool: SearchData.searchBool)
            return cell
          
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            var movie = searchData()
            
            if SearchData.searchBool {
                movie =   SearchData.filteredMovieList[indexPath.row]
            } else {
                movie =  movieList[indexPath.row]
            }
            
            FavouratiesMainatenance.selectedImbdid = movie.imdbID ?? ""
            
            var detailsVC = storyboard.self?.instantiateViewController(withIdentifier: "MovieDetails") as! MovieDetailsViewController
            navigationController?.pushViewController(detailsVC, animated: true)
            
        }
}


extension MovieListViewController: MovieListTableViewCellDelegate {
    
    func favouriteButtonClicked(tag: Int, sender: MovieListTableViewCell, boolValue: Bool) {
        
        let movie :[searchData]?

        if SearchData.searchBool {
            movie =   SearchData.filteredMovieList
        } else {
            movie =   SearchData.movieListData.Search
        }
        
        if boolValue {
            if let imdbID = movie?[tag].imdbID {
                FavouratiesMainatenance.favouriteMovieImdbIDArr.append(imdbID)
            }
            
        } else {
            if let imbdValue = movie?[tag].imdbID {
                FavouratiesMainatenance.favouriteMovieImdbIDArr.removeAll{$0 == imbdValue}
            }
        }

        if !(FavouratiesMainatenance.favouriteMovieImdbIDArr.isEmpty) {
            
            UserDefaults.standard.set(FavouratiesMainatenance.favouriteMovieImdbIDArr, forKey: "FavouriteMovies")
        }
        moviewListTableView.reloadData()
    }

}

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            SearchData.searchBool = false
            SearchData.filteredMovieList.removeAll()
        } else {
            SearchData.searchBool = true
            SearchData.filteredMovieList = movieList.filter { $0.Title?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        
        if SearchData.searchBool {
            if SearchData.filteredMovieList.count != 0 {
                noDataLabel.isHidden = true
                moviewListTableView.isHidden = false
                moviewListTableView.reloadData()
            } else {
                noDataLabel.isHidden = false
                moviewListTableView.isHidden = true
            }
        } else {
            noDataLabel.isHidden = true
            moviewListTableView.isHidden = false
            moviewListTableView.reloadData()
        }
            
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchData.searchBool = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.searchViewHeight.constant = 0
        
        if SearchData.searchBool {
            if SearchData.filteredMovieList.count != 0 {
                noDataLabel.isHidden = true
                moviewListTableView.isHidden = false
                moviewListTableView.reloadData()
            } else {
                noDataLabel.isHidden = false
                moviewListTableView.isHidden = true

            }
        } else {
            noDataLabel.isHidden = true
            moviewListTableView.isHidden = false
            moviewListTableView.reloadData()
        }

    }
}

