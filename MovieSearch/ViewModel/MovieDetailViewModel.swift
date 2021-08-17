import Foundation

struct MovieDetailViewModel {
    
    let movie: SearchResult.Movie
    
    init(movie: SearchResult.Movie) {
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
    
    var imdbRating: String {
        return self.movie.imdbRating
    }

    var runtime: String {
        return self.movie.runtime
    }

    var language: String {
        return self.movie.language
    }

    var imageURL: String {
        return self.movie.poster
    }
    
    var director: String {
        return self.movie.director
    }
    
    var metascore: String {
        self.movie.metascore
    }
    
    var writer: String {
        return self.movie.writer
    }
    
    var genre: String {
        return self.movie.genre
    }
    
    var plot: String {
        return self.movie.plot
    }
    
    var response: String {
        return self.movie.response
    }

}
