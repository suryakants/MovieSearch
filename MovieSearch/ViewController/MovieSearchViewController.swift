import UIKit

class MovieSearchViewController: UITableViewController {
    
    private var moviewListViewModel: MovieViewModelList?
    private let networkManager: NetworkManager = NetworkManager(session: URLSession.shared)
    private var searchParameters = (nextPage: 1,  batchCount: 0,  totalResults: 0)
    private let searchController = UISearchController(searchResultsController: nil)
    private var loadMoreIsCalled = false
    fileprivate var isLoading = false
    private var currentPage = 1
    fileprivate var scrollDirection = ScrollDirection.up
    fileprivate var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func search(for movieName: String, page: Int) {
        var spinner: UIActivityIndicatorView?
        if page > 1 {
            loadMoreIsCalled = true
            spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            spinner?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            spinner?.startAnimating()
            
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
        }
        if self.moviewListViewModel == nil {
            self.moviewListViewModel = MovieViewModelList()
            self.moviewListViewModel?.viewModelUpdates = { [unowned self] in
                
                self.searchParameters.batchCount = self.moviewListViewModel?.movieViewModelList.count ?? 0
                self.searchParameters.nextPage = page + 1
                self.searchParameters.totalResults = self.moviewListViewModel?.movieViewModelList.count ?? 0
                DispatchQueue.main.async {
                    self.tableView.backgroundView = UIView()
                    self.tableView.reloadData()
                    self.tableView.tableFooterView?.isHidden = true
                    spinner?.stopAnimating()
                    spinner = nil
                    self.searchController.searchBar.isLoading = false
                    self.tableView.reloadData()
                    
                }
            }
            self.moviewListViewModel?.errorOccurred = { [unowned self] error in
                DispatchQueue.main.async {
                    self.searchController.searchBar.isLoading = false
                    self.showHelpLabel(withText: "SearchMovie.noMovie.found.error.mesaage".localize())
                    self.tableView.reloadData()
                }
            }
        }
        // search method will get called everytime when there's change in search string
        // To avoid multiple network calls, throttling these calls in two steps as follows
        // 1. Cancling the previous API call if not already started
        // 2. Making another API call after half a second so that if the user going to change the displayed region again, we can cancel the call.
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(MovieViewModelList.searchMovies(for:currentPage:networkManager:)), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.moviewListViewModel?.searchMovies(for: movieName, currentPage: page)
        }
    }
        
    // MARK: - Internal Functions
    private func setupView(){
        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableView.automaticDimension
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "SearchMovie.navBar.title".localize()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "searchMovie.searchBar.placeHolder".localize()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        showHelpLabel(withText: "SearchMovie.Message".localize())
    }
    
    private func showHelpLabel(withText text: String) {
        let helpLabel = UILabel()
        helpLabel.frame.size = CGSize.zero
        helpLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        helpLabel.textColor = UIColor.lightGray
        helpLabel.textAlignment = .center
        helpLabel.text = text
        helpLabel.sizeToFit()
        tableView.backgroundView = helpLabel
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMovie" {
            if let viewController = segue.destination as? MovieDetailViewController, let movieID = sender as? String {
                viewController.imdbID = movieID
            }
        }
    }
}


// MARK: - UIScrollView
extension MovieSearchViewController {
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y >= 0 {
            scrollDirection = .down
        }else{
            scrollDirection = .up
        }
        
    }
}

// MARK: - UISearchResultsUpdating
extension MovieSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchTerm = searchController.searchBar.text {
            guard searchTerm.count > 2 else {
                self.moviewListViewModel?.movieViewModelList = []
                return
            }
            self.searchText = searchTerm
            searchController.searchBar.isLoading = true
            search(for: searchTerm, page: currentPage)
        }
    }
}

extension MovieSearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviewListViewModel?.movieViewModelList.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell {
            if let movie = (moviewListViewModel?.movieViewModelList[indexPath.row]) {
                cell.configureCell(with: movie)
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowMovie", sender: moviewListViewModel?.movieViewModelList[indexPath.row].imdbID)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        guard (moviewListViewModel?.movieViewModelList.count ?? 0) < searchParameters.totalResults else {return}
        
        if let visibleRow = self.tableView.visibleCells.last {
            guard self.loadMoreIsCalled == false else {return}
            if let lastVisibleRow = tableView.indexPath(for: visibleRow)?.row {
                if lastVisibleRow == self.moviewListViewModel?.movieViewModelList.count ?? 0 - 2 {
                    if scrollDirection == .down {
                        if !isLoading {
                            self.loadMoreIsCalled = true
                            if let _searchText = self.searchText {
                                self.search(for: _searchText, page: searchParameters.nextPage)
                            }
                        }
                    }
                }
            }
            
            
        }
    }
}




