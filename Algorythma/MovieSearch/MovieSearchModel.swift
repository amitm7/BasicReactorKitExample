//
//  MovieSearchModel.swift
//  Algorythma
//
//  Created by Amit Mishra on 26/03/18.
//  Copyright © 2018 Amit Mishra. All rights reserved.
//

import Foundation
import Mapper

struct MovieSearchModel: Mappable {
    var page: Int = 0
    var totalResults: Int = 0
    var totalPages: Int = 0
    var movies:[MoviesModel] = []
    init(map: Mapper) throws {
        page = map.optionalFrom("page")!
        totalResults = map.optionalFrom("total_results")!
        totalPages = map.optionalFrom("total_pages")!
        try! movies = map.from("results")
 
    }
}
