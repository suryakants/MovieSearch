import Foundation

class NetworkManager: NSObject {
    
    
    typealias CompletionHandler = ((Result<Data, NetworkError>) -> Void)
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    override init() {
        self.session = URLSession.shared
    }

    //MARK: - Internal structs
    private struct authParameters {
        struct Keys {
            static let accept = "Accept"
            static let apiKey = "apikey"
        }
        static let apiKey = "6c288424"
    }
    
    //An NSCach object to cache images, if necessary
    private let cache = NSCache<NSString, NSData>()
    
    //Default session configuration
    private let urlSessionConfig = URLSessionConfiguration.default
    
    //Additional headers such as authentication token, go here
    private func configSession(){
        self.urlSessionConfig.httpAdditionalHeaders = [
            AnyHashable(authParameters.Keys.accept): MIMETypes.json.rawValue
        ]
    }
        
    //MARK: - Private APIs
    private func createAuthParameters(with parameters:[String:String]) -> Data? {
        guard parameters.count > 0 else {return nil}
        return  parameters.map {"\($0.key)=\($0.value)"}.joined(separator: "&").data(using: .utf8)
    }
    
    
    private func request(url:String,
                 cachePolicy: URLRequest.CachePolicy = .reloadRevalidatingCacheData,
                 httpMethod: RequestType,
                 headers:[String:String]?,
                 body: [String:String]?,
                 parameters: [URLQueryItem]?,
                 handler:  @escaping (Data?, URLResponse?, Error?) -> Void){
        
        if var urlComponent = URLComponents(string: url) {
            urlComponent.queryItems = parameters
            if let _url = urlComponent.url {
                
                var request = URLRequest(url: _url)
                request.cachePolicy = cachePolicy
                request.allHTTPHeaderFields = headers
                
                if let _body = body {
                    request.httpBody = createAuthParameters(with: _body)
                }
                request.httpMethod = httpMethod.rawValue
                
                session.dataTask(with: request) { (data, response, error) in
                    handler(data, response, error)
                }.resume()
            }
            else {
                handler(nil, nil, NetworkError.invalidURL)
            }
        }
        else {
            handler(nil, nil, NetworkError.invalidURL)
        }
    }
    
    private func isSuccessCode(_ statusCode: Int) -> Bool {
        return statusCode == NetworkConstant.ErrorCode.httpOk
    }
    
    private func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }
        return isSuccessCode(urlResponse.statusCode)
    }

}


extension NetworkManager {
    
    func search(for name: String, page: Int = 1, completionHandler: @escaping CompletionHandler){
        var queries = [URLQueryItem]()
        queries.append(URLQueryItem(name: "s", value: name))
        queries.append(URLQueryItem(name: "type", value: "movie"))
        queries.append(URLQueryItem(name: "page", value: String(page)))
        queries.append(URLQueryItem(name: "r", value: "json"))
        queries.append(URLQueryItem(name: authParameters.Keys.apiKey, value: authParameters.apiKey))
        
        request(url: EndPoints.Search.path, httpMethod: .get, headers: nil, body: nil, parameters: queries){ (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        completionHandler(.failure(.noData))
                        return
                }
                if error == nil && self.isSuccessCode(httpResponse) {
                    completionHandler(.success(receivedData))
                }
                else {
                    completionHandler(.failure(.unknown))
                }
            }
        }
    
    func fetchMovie(with imdbID: String, completionHandler: @escaping CompletionHandler){
        var queries = [URLQueryItem]()
        queries.append(URLQueryItem(name: "i", value: imdbID))
        queries.append(URLQueryItem(name: "r", value: "json"))
        queries.append(URLQueryItem(name: authParameters.Keys.apiKey, value: authParameters.apiKey))
        
        request(url: EndPoints.Search.path, httpMethod: .get, headers: nil, body: nil, parameters: queries){ (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    completionHandler(.failure(.noData))
                    return
            }
            if error == nil && self.isSuccessCode(httpResponse) {
                completionHandler(.success(receivedData))
            }
            else {
                completionHandler(.failure(.unknown))
            }
        }
    }
}
