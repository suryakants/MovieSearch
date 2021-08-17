//
//  MovieDetailViewController.swift
//  MovieSearch
//
//  Created by Suryakant on 17/08/21.
//

import UIKit

class MovieDetailViewController: UITableViewController {
    
    @IBOutlet var posterImageView: CachedImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var imdbRateScore: UILabel!
    @IBOutlet var metascoreLabel: UILabel!
    @IBOutlet var directorCell: UITableViewCell!
    @IBOutlet var writerCell: UITableViewCell!
    @IBOutlet var plotCell: UITableViewCell!
    @IBOutlet var genreCell: UITableViewCell!
    
    private var movieDetailViewModelCoordinator: MovieDetailViewModelCoordinator?
    var networkManager: NetworkManager?
    
    private var numberOfSections = 1
    
    var imdbID: String? {
        didSet{
            if let id = imdbID {
                movieDetailViewModelCoordinator = MovieDetailViewModelCoordinator()
                movieDetailViewModelCoordinator?.errorOccurred = { error in
                    self.numberOfSections = 0
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.showHelpLabel(withText: error.localizedDescription)
                    print(error.localizedDescription)
                }
                movieDetailViewModelCoordinator?.viewModelUpdates = {
                    if let moviewDetails = self.movieDetailViewModelCoordinator?.movieDetailViewModel, moviewDetails.response.lowercased() ==  "true" {
                        self.numberOfSections = 1
                        self.setMovieInfo(with: moviewDetails)
                    }else{
                        self.numberOfSections = 0
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        self.showHelpLabel(withText: "movie.not.exist.messgae".localize())
                    }
                }
                movieDetailViewModelCoordinator?.fetchMoviewDetail(id: id)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Internal Functions
    
    func showHelpLabel(withText text: String) {
        DispatchQueue.main.async {
            let helpLabel = UILabel()
            helpLabel.frame.size = CGSize.zero
            helpLabel.font = UIFont.preferredFont(forTextStyle: .callout)
            helpLabel.textColor = UIColor.lightGray
            helpLabel.textAlignment = .center
            helpLabel.text = text
            helpLabel.numberOfLines = 0
            helpLabel.lineBreakMode = .byWordWrapping
            helpLabel.sizeToFit()
            self.tableView.backgroundView = helpLabel
        }
    }
    
    func setupView(){
        tableView.tableFooterView = UIView()
        navigationItem.title = "Movie.details.navBar.title".localize()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        for item in [plotCell, writerCell, genreCell, directorCell] {
            item?.textLabel?.numberOfLines = 0
            item?.textLabel?.lineBreakMode = .byWordWrapping
        }
        
        infoLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        infoLabel.minimumScaleFactor = 0.6
        infoLabel.adjustsFontSizeToFitWidth = true
        
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = UIFont.boldSystemFont(ofSize: MovieCellFontSizeContant.titleFontSize)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        
        yearLabel.textColor = UIColor.gray
        yearLabel.numberOfLines = 1
        yearLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.posterImageView.contentMode = .scaleToFill
    }
        
    func setMovieInfo(with movie: MovieDetailViewModel){
        DispatchQueue.main.async {
            let activityView = UIActivityIndicatorView()
            activityView.style = .medium
            self.tableView.backgroundView = UIView()
            
            self.posterImageView.image = UIImage()
            self.posterImageView.clipsToBounds = true
            self.posterImageView.addSubview(activityView)
            activityView.center = self.posterImageView.center
            activityView.startAnimating()
            self.posterImageView.loadImage(placeHolder: #imageLiteral(resourceName: "poster"),  urlString: movie.imageURL) {
                DispatchQueue.main.async {
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                }
            }
            self.nameLabel.text = movie.title
            self.yearLabel.text = movie.year
            
            for label in [self.imdbRateScore, self.metascoreLabel] {
                label?.textAlignment = .center
                label?.numberOfLines = 2
            }
                        
            var _title = NSAttributedString(string: "IMDB.text".localize(),
                                            attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout) ])
            var _value = NSAttributedString(string: movie.imdbRating,
                                            attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout) , NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.imdbRateScore.attributedText = self.attributedString(from: [_title, _value])
            
            _title = NSAttributedString(string: "metascore.text".localize(),
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout) ])
            _value = NSAttributedString(string: movie.metascore,
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout), NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.metascoreLabel.attributedText = self.attributedString(from: [_title, _value])
            
            self.infoLabel.text = "\(movie.language) | \(movie.runtime)"
            
            
            _title = NSAttributedString(string: "director.text".localize(),
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout) ])
            _value = NSAttributedString(string: movie.director,
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout), NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.directorCell.textLabel?.attributedText = self.attributedString(from: [_title, _value])
            
            _title = NSAttributedString(string: "writer.text".localize(),
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout) ])
            _value = NSAttributedString(string: movie.writer,
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout), NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.writerCell.textLabel?.attributedText = self.attributedString(from: [_title, _value])
            
            _title = NSAttributedString(string: "genre.text".localize(),
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout) ])
            _value = NSAttributedString(string: movie.genre,
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout), NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.genreCell.textLabel?.attributedText = self.attributedString(from: [_title, _value])
            
            _title = NSAttributedString(string: "plot.text".localize(),
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout) ])
            _value = NSAttributedString(string: movie.plot,
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout) , NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.plotCell.textLabel?.attributedText = self.attributedString(from: [_title, _value])
            self.tableView.reloadData()
        }
    }
    
    func attributedString(from items: [NSAttributedString]) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString()
        for item in items {
            mutableAttributedString.append(item)
        }
        
        return mutableAttributedString
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        case 2:
            return 55
        default:
            return UITableView.automaticDimension
        }
    }

}
