//
//  MovieDetailsViewController.swift
//  MovieShow
//
//  Created by Gnanasekaran Gajendiran on 7/8/24.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var boxOffficeLabel: UILabel!
    @IBOutlet weak var imbdLabel: UILabel!
    @IBOutlet weak var awardsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var progressFiveLabel: UILabel!
    @IBOutlet weak var progressFiveView: UIProgressView!
    @IBOutlet weak var progressFourLabel: UILabel!
    @IBOutlet weak var progressFourView: UIProgressView!
    @IBOutlet weak var progressThreeLabel: UILabel!
    @IBOutlet weak var progressThreeView: UIProgressView!
    @IBOutlet weak var imbdVotesLabel: UILabel!
    @IBOutlet weak var progressViewSourceTwo: UIProgressView!
    @IBOutlet weak var sourceTwoLabel: UILabel!
    @IBOutlet weak var progressViewSourceOne: UIProgressView!
    @IBOutlet weak var sourceOneLabel: UILabel!
    @IBOutlet weak var directerLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView() 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setView() {
        movieDetailsCall()
        progressViewSourceOne.progress = 0.0
        progressViewSourceTwo.progress = 0.0
        progressThreeView.progress = 0.0
        progressFourView.progress = 0.0
        progressFiveView.progress = 0.0

    }
    
    
    func movieDetailsCall() {
        
        var url = AvailableAPI.baseURL

        Movie.movieApiFetch.fetchMovieDetails(url: url, imdbID: FavouratiesMainatenance.selectedImbdid, apikey: "b57617d") { (success, error) in
            if success {
                
                if MovieDetailsData.MovieDetailsList != nil {
                    DispatchQueue.main.async {
                        self.setData()
                    }
                 
                }
                
            } else  {
                print("something went wrong")
            }
            
        }
    }

    
    func setData() {
         
        var detailsArr = MovieDetailsData.MovieDetailsList
        movieNameLabel.text = detailsArr.Title
        titleLabel.text = detailsArr.Title
        writerLabel.text = detailsArr.Writer
        boxOffficeLabel.text = detailsArr.Writer
        imbdLabel.text = detailsArr.imdbID
        awardsLabel.text = detailsArr.Awards
        languageLabel.text = detailsArr.Language
        countryLabel.text = detailsArr.Country
        releasedLabel.text = detailsArr.Released
        runtimeLabel.text = detailsArr.Runtime
        ratedLabel.text = detailsArr.Rated
        yearLabel.text = detailsArr.Year
        plotLabel.text = detailsArr.Plot
        genreLabel.text = detailsArr.Genre
        directerLabel.text = detailsArr.Director
        imbdVotesLabel.text = detailsArr.imdbVotes
        if  detailsArr.Ratings?.count == 3{
            progressViewSourceOne.progress = setProgreess(data: detailsArr.Ratings?[0].Value ?? "")
            sourceOneLabel.text =  detailsArr.Ratings?[0].Source ?? ""
            progressViewSourceTwo.progress = setProgreess(data: detailsArr.Ratings?[1].Value ?? "")
            sourceTwoLabel.text =  detailsArr.Ratings?[1].Source ?? ""
            progressThreeView.progress = setProgreess(data: detailsArr.Ratings?[2].Value ?? "")
            progressThreeLabel.text =  detailsArr.Ratings?[2].Source ?? ""
        }
        
        progressFourView.progress = setProgreess(data: detailsArr.Metascore ?? "")
        progressFourLabel.text = "Metascore"
        progressFiveView.progress = setProgreess(data: detailsArr.imdbRating ?? "")
        progressFiveLabel.text = "imdbRating"
        var imageUrl = detailsArr.Poster
        
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(named: "insert-picture") // Set a placeholder image if URL is invalid
        }
    

        
    }
    
    
    func setProgreess(data: String) -> Float {
        
       
            if data.contains("/") {
                let components = data.split(separator: "/")
                if let numerator = Float(components[0]), let denominator = Float(components[1]) {
                    return numerator / denominator
                }
            } else if data.contains("%") {
                if let percentage = Float(data.replacingOccurrences(of: "%", with: "")) {
                    return percentage / 100.0
                }
            } else if data.contains(".") {
                if var  dataValue = data as? String {
                    return Float(dataValue)! / Float(10)
                }

            } else {
                if var dataValue = data as? String {
                    return Float(dataValue)! / Float(100)
                }
                
            }
            return 0.0
        }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    

}
