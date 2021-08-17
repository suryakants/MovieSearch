import UIKit

class MovieCell: UITableViewCell {
    
    let posterImageView: CachedImageView = {
        let imageView = CachedImageView();
        imageView.image = #imageLiteral(resourceName: "poster");
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView;
    }();
    
    var movieTitle: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0;
        label.font = UIFont.boldSystemFont(ofSize: MovieCellFontSizeContant.titleFontSize);
        label.lineBreakMode = .byWordWrapping;
        return label;
    }();
    
    let releaseDate : UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: MovieCellFontSizeContant.dateFontSize);
        label.textColor = .systemGray
        label.text = "1989-06-23"
        return label;
    }();
    
    var movieType: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0;
        label.font = UIFont.systemFont(ofSize: MovieCellFontSizeContant.overviewFontSize);
        label.textColor = .systemGray
        label.lineBreakMode = .byWordWrapping;
        return label;
    }();

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(posterImageView);
        self.contentView.addSubview(movieTitle);
        self.contentView.addSubview(releaseDate);
        self.contentView.addSubview(movieType);

        NSLayoutConstraint.activate([
            posterImageView.heightAnchor.constraint(equalToConstant: MovieCellPaddingContant.posterImageHeight),
            posterImageView.widthAnchor.constraint(equalToConstant: MovieCellPaddingContant.posterImageWidth),
            posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: MovieCellPaddingContant.paddingBetweenViews),
            posterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: MovieCellPaddingContant.paddingBetweenViews),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -MovieCellPaddingContant.paddingBetweenViews)
            ])
        
        NSLayoutConstraint.activate([
            movieTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: MovieCellPaddingContant.paddingBetweenViews),
            movieTitle.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor,constant: MovieCellPaddingContant.paddingBetweenViews),
            movieTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -MovieCellPaddingContant.paddingBetweenViews),
            ])
        NSLayoutConstraint.activate([
            releaseDate.topAnchor.constraint(equalTo: self.movieTitle.bottomAnchor, constant: MovieCellPaddingContant.verticalPadding),
            releaseDate.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor,constant: MovieCellPaddingContant.paddingBetweenViews),
            releaseDate.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -MovieCellPaddingContant.paddingBetweenViews),
            ])
        
        NSLayoutConstraint.activate([
            movieType.topAnchor.constraint(equalTo: self.releaseDate.bottomAnchor, constant: MovieCellPaddingContant.verticalPadding),
            movieType.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor,constant: MovieCellPaddingContant.paddingBetweenViews),
            movieType.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -MovieCellPaddingContant.paddingBetweenViews),
            ])

    }
    
    func configureCell(with viewModel: MovieViewModel){
        self.movieTitle.text = viewModel.title;
        self.releaseDate.text = viewModel.year
        self.posterImageView.loadImage(placeHolder: #imageLiteral(resourceName: "poster"),  urlString: viewModel.imageURL)
        self.movieType.text = viewModel.type.capitalized;
    }
}
