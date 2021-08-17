import UIKit

/**
 A convenient UIImageView to load and cache images.
 */
open class CachedImageView: UIImageView {
    
    public static let imageCache = NSCache<NSString, UIImage>()
    
    open var shouldUseEmptyImage = true
    private var urlStringForChecking: String?
    private var emptyImage: UIImage?
    
    public convenience init(cornerRadius: CGFloat = 0, tapCallback: @escaping (() ->())) {
        self.init(cornerRadius: cornerRadius, emptyImage: nil)
        self.tapCallback = tapCallback
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        tapCallback?()
    }
    
    private var tapCallback: (() -> ())?
    
    public init(cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil) {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        self.emptyImage = emptyImage
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    /**
     Easily load an image from a URL string and cache it to reduce network overhead later.
     
     - parameter urlString: The url location of your image, usually on a remote server somewhere.
     - parameter completion: Optionally execute some task after the image download completes
     */
    
    open func loadImage(placeHolder: UIImage? = nil, urlString: String, completion: (() -> ())? = nil) {
        image = placeHolder
        self.urlStringForChecking = urlString
        let urlKey = urlString as NSString
        
        if let cachedItem = CachedImageView.imageCache.object(forKey: urlKey) {
            image = cachedItem
            completion?()
            return
        }
        guard let url = URL(string: urlString) else {
            if shouldUseEmptyImage {
                image = emptyImage
            }
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                completion?()
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    CachedImageView.imageCache.setObject(image, forKey: urlKey)
                    if urlString == self?.urlStringForChecking {
                        self?.image = image
                        completion?()
                    }
                }
            }
            
        }).resume()
    }
}
