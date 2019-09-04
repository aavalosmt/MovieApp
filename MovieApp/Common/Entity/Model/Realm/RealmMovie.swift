//
//  RealmMovie.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/29/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMovie: Object {

    @objc dynamic var r_originalTitle: String?
    @objc dynamic var r_title: String?
    let r_voteCount = RealmOptional<Int>()
    let r_voteAverage = RealmOptional<Double>()
    let r_popularity = RealmOptional<Double>()
    let r_hasVideo = RealmOptional<Bool>()
    @objc dynamic var r_mediaType: String?
    @objc dynamic var r_releaseDate: String?
    @objc dynamic var r_originalLanguage: String?
    @objc dynamic var r_overView: String?
    let r_isAdultRated = RealmOptional<Bool>()
    var r_genreIds = List<Int>()
    @objc dynamic var r_posterPath: String?
    var r_pages = List<Int>()
    var r_listTypes = List<Int>()
    
    public override static func primaryKey() -> String? {
        return "r_title"
    }
}

extension RealmMovie: Movie {
    var originalTitle: String? {
        get {
            return r_originalTitle
        }
        set(newValue) {
            r_originalTitle = newValue
        }
    }
    
    var title: String? {
        get {
            return r_title
        }
        set(newValue) {
            r_title = newValue
        }
    }
    
    var voteCount: Int? {
        get {
            return r_voteCount.value
        }
        set(newValue) {
            r_voteCount.value = newValue
        }
    }
    
    var voteAverage: Double? {
        get {
            return r_voteAverage.value
        }
        set(newValue) {
            r_voteAverage.value = newValue
        }
    }
    
    var popularity: Double? {
        get {
            return r_popularity.value
        }
        set(newValue) {
            r_popularity.value = newValue
        }
    }
    
    var hasVideo: Bool? {
        get {
            return r_hasVideo.value
        }
        set(newValue) {
            r_hasVideo.value = newValue
        }
    }
    
    var mediaType: String? {
        get {
            return r_mediaType
        }
        set(newValue) {
            r_mediaType = newValue
        }
    }
    
    var releaseDate: String? {
        get {
            return r_releaseDate
        }
        set(newValue) {
            r_releaseDate = newValue
        }
    }
    
    var originalLanguage: String? {
        get {
            return r_originalLanguage
        }
        set(newValue) {
            r_originalLanguage = newValue
        }
    }
    
    var overView: String? {
        get {
            return r_overView
        }
        set(newValue) {
            r_overView = newValue
        }
    }
    
    var isAdultRated: Bool? {
        get {
            return r_isAdultRated.value
        }
        set(newValue) {
            r_isAdultRated.value = newValue
        }
    }
    
    var genreIds: [Int]? {
        get {
            return getGenreIds()
        }
        set(newValue) {
            r_genreIds = getGenreList(genreIds: newValue)
        }
    }
    
    var posterPath: String? {
        get {
            return r_posterPath
        }
        set(newValue) {
            r_posterPath = newValue
        }
    }
    
    private func getGenreIds() -> [Int] {
        var genres: [Int] = []
        for genre in r_genreIds {
            genres.append(genre)
        }
        return genres
    }
    
    private func getGenreList(genreIds: [Int]?) -> List<Int> {
        let list = List<Int>()
        
        guard let genreIds = genreIds else {
            return list
        }
        
        for genre in genreIds {
            list.append(genre)
        }
        return list
    }
    
    var pages: Set<Int>? {
        get {
            return getPages()
        }
        set(newValue) {
            r_pages = getPageList(pages: newValue)
        }
    }
    
    var listTypes: Set<MovieListType>? {
        get {
            return getListTypes()
        }
        set(newValue) {
            r_listTypes = getTypesList(types: newValue)
        }
    }
    
    var genres: [String] {
        return []
    }
    
    private func getPageList(pages: Set<Int>?) -> List<Int> {
        let list = List<Int>()

        guard let pages = pages else {
            return list
        }
        
        for page in pages {
            list.append(page)
        }
        
        return list
    }
    
    private func getPages() -> Set<Int>? {
        var set: Set<Int> = []
        for page in r_pages {
            set.insert(page)
        }
        
        return (set.isEmpty ? nil: set)
    }
    
    private func getListTypes() -> Set<MovieListType>? {
        var types: Set<MovieListType> = []
        for type in r_listTypes {
            guard let listType = MovieListType(rawValue: type) else {
                continue
            }
            types.insert(listType)
        }
        return (types.isEmpty ? nil: types)
    }
    
    private func getTypesList(types: Set<MovieListType>?) -> List<Int> {
        let list = List<Int>()
        
        guard let listTypes = types else {
            return list
        }
        
        for type in listTypes {
            list.append(type.rawValue)
        }
        return list
    }
    
}
