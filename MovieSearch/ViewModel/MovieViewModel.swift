//
//  MovieViewModel.swift
//  MovieSearch
//
//  Created by Suryakant on 17/08/21.
//

import Foundation

struct MovieViewModel {
    
    let movie: SearchResult.Search.Movie
    
    init(movie: SearchResult.Search.Movie) {
        self.movie = movie
    }
    
    var title: String {
        return self.movie.title
    }
    
    var year: String {
        return "(" + self.movie.year + ")"
    }
    
    var type: String {
        return self.movie.type
    }
    
    var imdbID: String {
        return self.movie.imdbID
    }
    
    var imageURL: String {
        return self.movie.poster
    }
}
