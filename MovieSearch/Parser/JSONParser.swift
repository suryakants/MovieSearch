import UIKit

/***
 This class is resposible to recode all the JSON coming as response-
 to a decodable objects.
 **/
class JSONParser {
    class func decodeJson<T: Decodable>(from data: Data) -> T? {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let model = try decoder.decode(T.self, from: data)
            return model
        }
        catch _ {
            return nil
        }
    }
}

