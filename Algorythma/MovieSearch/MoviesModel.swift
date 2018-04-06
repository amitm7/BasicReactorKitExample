//
//  MoviesModel.swift
//  Algorythma
//
//  Created by Amit Mishra on 26/03/18.
//  Copyright © 2018 Amit Mishra. All rights reserved.
//

import Foundation
import Mapper

struct MoviesModel: Mappable {
    var release_date: String?
    var title: String?
    var overview: String?
    var poster_path:String?

    init(map: Mapper) throws {
        release_date = map.optionalFrom("release_date")
         title = map.optionalFrom("title")
         overview = map.optionalFrom("overview")
         poster_path = map.optionalFrom("poster_path")
    }
}
