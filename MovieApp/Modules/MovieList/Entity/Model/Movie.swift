//
//  Movie.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class MovieEntity: CodableEntity {
    
    var originalTitle: String
    var title: String
    var voteCount: Int
    var voteAverage: Double
    var popularity: Double
    var hasVideo: Bool
    var mediaType: String
    var releaseDate: String
    var originalLanguage: String
    var overView: String
    var isAdultRated: Bool
    var genreIds: [Int]
    var posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case title = "title"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case popularity = "popularity"
        case hasVideo = "video"
        case mediaType = "media_type"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case overView = "overview"
        case isAdultRated = "adult"
        case genreIds = "genre_ids"
        case posterPath = "poster_path"
    }
    
    init(originalTitle: String,
         title: String,
         voteCount: Int,
         voteAverage: Double,
         popularity: Double,
         hasVideo: Bool,
         mediaType: String,
         releaseDate: String,
         originalLanguage: String,
         overView: String,
         isAdultRated: Bool,
         genreIds: [Int],
         posterPath: String) {
        
        self.originalTitle = originalTitle
        self.title = title
        self.voteCount = voteCount
        self.voteAverage = voteAverage
        self.popularity = popularity
        self.hasVideo = hasVideo
        self.mediaType = mediaType
        self.releaseDate = releaseDate
        self.originalLanguage = originalLanguage
        self.overView = overView
        self.isAdultRated = isAdultRated
        self.genreIds = genreIds
        self.posterPath = posterPath
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        title = try container.decode(String.self, forKey: .title)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        popularity = try container.decode(Double.self, forKey: .popularity)
        hasVideo = try container.decode(Bool.self, forKey: .hasVideo)
        mediaType = try container.decode(String.self, forKey: .mediaType)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        overView = try container.decode(String.self, forKey: .overView)
        isAdultRated = try container.decode(Bool.self, forKey: .isAdultRated)
        genreIds = try container.decode([Int].self, forKey: .genreIds)
        posterPath = try container.decode(String.self, forKey: .posterPath)
    }
    
}