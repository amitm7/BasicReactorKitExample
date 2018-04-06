//
//  MovieListViewModel.swift
//  Algorythma
//
//  Created by Amit Mishra on 02/04/18.
//  Copyright © 2018 Amit Mishra. All rights reserved.
//
import UIKit
import Foundation
class MovieListViewModel {
    var release_date: String?
    var title: String?
    var overview: String?
    var poster_path: String = "kBf3g9crrADGMc2AMAMlLBgSm2h.jpg"
    let reuseIdentifier = "CollectionViewCell"

    init(_ movies: MoviesModel) {
        release_date = movies.release_date
        title = movies.title
        overview = movies.overview
        if let poster = movies.poster_path{
            poster_path = poster
        }
    }
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> CollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.setup(self)
        
        return cell
    }
    
    func tapCell(_ tableView: UITableView, indexPath: IndexPath) {
        print("Tapped a cell")
    }
    
}
