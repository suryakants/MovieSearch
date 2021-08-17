import Foundation

struct NetworkConstant {
    public struct ErrorCode {
        static let httpOk = 200
    }
}

//MARK:- Enums
public enum NetworkError: Error {
    case invalidURL
    case noData
    case noNetwork
    case invalidSyntax
    case noError
    case invalidData
    case unknown
}


enum MIMETypes: String {
    case urlencoded = "application/x-www-form-urlencoded"
    case json = "application/json"
}

enum RequestType: String {
    case post = "post"
    case get = "get"
}
