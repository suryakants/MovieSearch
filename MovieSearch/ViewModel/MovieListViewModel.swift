import Foundation

class MovieViewModelList {
    var viewModelUpdates: (() -> Void) = {  }
    var errorOccurred: ((NetworkError) -> Void) = {_ in  }
    var totalResults = 0
    var movieViewModelList = [MovieViewModel]() {
        didSet {
            // Call the closure here to make view controller know about the update on movieViewModel list
            self.viewModelUpdates()
        }
    }
    
    @objc func searchMovies(for name: String, currentPage: Int = 1, networkManager: NetworkManager = NetworkManager()) {
        networkManager.search(for: name, page: currentPage) { result in
            switch result {
            case .success(let responseData):
                if let searchResult: SearchResult.Search = JSONParser.decodeJson(from: responseData) {
                    if let movieList = searchResult.results?.map(MovieViewModel.init(movie:)) {
                        self.totalResults = Int(searchResult.totalResults ?? "0") ?? 0
                        self.movieViewModelList += movieList
                    }
                    else {
                        self.errorOccurred(.invalidData)
                    }
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
