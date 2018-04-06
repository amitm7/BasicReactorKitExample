//
//  CollectionViewCell.swift
//  Algorythma
//
//  Created by Amit Mishra on 02/04/18.
//  Copyright © 2018 Amit Mishra. All rights reserved.
//

import UIKit
import AlamofireImage
class CollectionViewCell: UICollectionViewCell {

    @IBOutlet  var moviedetail: UILabel!
    @IBOutlet  var movieName: UILabel!
    @IBOutlet  var releadate: UILabel!
    @IBOutlet  var posterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    func setup(_ viewModel: MovieListViewModel) {
        moviedetail.text = viewModel.overview
        movieName.text = viewModel.title
        releadate.text =  "ReleaseDate:" + viewModel.release_date!
        let urlStr:String = "http://image.tmdb.org/t/p/w92\(String(describing: viewModel.poster_path))"
        let url:URL = URL.init(string: urlStr)!
        posterImage.af_setImage(
            withURL: url,
            placeholderImage: nil,
            imageTransition: .crossDissolve(0.2))
    }

}
