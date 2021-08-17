import Foundation

class MovieDetailViewModelCoordinator {
    
    var viewModelUpdates: (() -> Void) = {  }
    var errorOccurred: ((NetworkError) -> Void) = {_ in  }
    
    var movieDetailViewModel: MovieDetailViewModel? {
        didSet {
            // Call the closure here to make view controller know about the update on movieViewModel list
            self.viewModelUpdates()
        }
    }
    
    @objc func fetchMoviewDetail(id: String, networkManager: NetworkManager = NetworkManager()) {
        networkManager.fetchMovie(with: id) { result in
            switch result {
            case .success(let responseData):
                if let movieModel: SearchResult.Movie = JSONParser.decodeJson(from: responseData) {
                    self.movieDetailViewModel = MovieDetailViewModel(movie: movieModel)
                }
                else {
                    self.errorOccurred(.invalidData)
                }
            case .failure(let error):
                self.errorOccurred(error)
            }
        }
    }
}

