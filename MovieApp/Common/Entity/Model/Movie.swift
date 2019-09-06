//
//  Movie.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

enum MovieListType: Int {
    case popular
    case topRated
    case upcoming
    case search
}

protocol Movie {
    var originalTitle: String? { get }
    var title: String? { get }
    var voteCount: Int? { get }
    var voteAverage: Double? { get }
    var popularity: Double? { get }
    var hasVideo: Bool? { get }
    var mediaType: String? { get }
    var releaseDate: String? { get }
    var originalLanguage: String? { get }
    var overView: String? { get }
    var isAdultRated: Bool? { get }
    var genreIds: [Int]? { get }
    var posterPath: String? { get }
    var pages: Set<Int>? { get }
    var listTypes: Set<MovieListType>? { get }
    var genres: [String] { get }
}

struct MovieEntity: CodableEntity, Movie {
    
    var originalTitle: String?
    var title: String?
    var voteCount: Int?
    var voteAverage: Double?
    var popularity: Double?
    var hasVideo: Bool?
    var mediaType: String?
    var releaseDate: String?
    var originalLanguage: String?
    var overView: String?
    var isAdultRated: Bool?
    var genreIds: [Int]?
    var posterPath: String?
    var pages: Set<Int>?
    var listTypes: Set<MovieListType>?
    var genres: [String] = []
    
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
    
    init() {}
    
    init(originalTitle: String?,
         title: String?,
         voteCount: Int?,
         voteAverage: Double?,
         popularity: Double?,
         hasVideo: Bool?,
         mediaType: String?,
         releaseDate: String?,
         originalLanguage: String?,
         overView: String?,
         isAdultRated: Bool?,
         genreIds: [Int]?,
         posterPath: String?,
         pages: Set<Int>?) {
        
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
        self.pages = pages
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        title = try container.decode(String.self, forKey: .title)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        popularity = try container.decode(Double.self, forKey: .popularity)
        hasVideo = try container.decode(Bool.self, forKey: .hasVideo)
        mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        overView = try container.decode(String.self, forKey: .overView)
        isAdultRated = try container.decode(Bool.self, forKey: .isAdultRated)
        genreIds = try container.decode([Int].self, forKey: .genreIds)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    }
    
}
