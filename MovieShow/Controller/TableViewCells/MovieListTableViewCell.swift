//
//  MovieListTableViewCell.swift
//  MovieShow
//
//  Created by Gnanasekaran Gajendiran on 6/8/24.
//

import UIKit
import Kingfisher

protocol MovieListTableViewCellDelegate : AnyObject {
    func favouriteButtonClicked(tag: Int, sender: MovieListTableViewCell, boolValue: Bool)
}


class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imdbLabel: UILabel!
    
    var bool_Value = false
    var cellDelegate : MovieListTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10
        mainView.layer.borderWidth = 0.5
        mainView.layer.borderColor =   UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with imageUrl: String, index: Int, favouriteBool: Bool, searchBool: Bool) {
        
        let movie :searchData?

        if searchBool {
            movie =   SearchData.filteredMovieList[index]
        } else {
            movie =   SearchData.movieListData.Search?[index]
        }
        
        if favouriteBool{
            bool_Value = favouriteBool
            favouriteImage.image = UIImage(named: "star-2")
        } else {
            bool_Value = favouriteBool
            favouriteImage.image = UIImage(named: "star")
        }
        
        movieNameLabel.text =  movie?.Title ?? ""
        titleLabel.text =  movie?.Title ?? ""
        releaseDateLabel.text =  movie?.Year ?? ""
        imdbLabel.text =  movie?.imdbID ?? ""
        
        var imageUrl = movie?.Poster

        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            moviePoster.kf.setImage(with: url)
        } else {
            moviePoster.image = UIImage(named: "insert-picture") // Set a placeholder image if URL is invalid
        }
        
    }


    @IBAction func favouriteButtonClicked(_ sender: UIButton) {
        if bool_Value {
            bool_Value = false
        } else {
            bool_Value = true
        }
        
        cellDelegate?.favouriteButtonClicked(tag: sender.tag, sender: self, boolValue: bool_Value)
    }
    
}
