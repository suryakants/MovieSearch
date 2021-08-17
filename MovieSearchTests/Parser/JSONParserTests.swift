import XCTest
@testable import MovieSearch

let validJson = """
    {"Title":"Fun","Year":"1994","Rated":"Unrated","Released":"14 Apr 1995","Runtime":"105 min","Genre":"Crime, Drama","Director":"Rafal Zielinski","Writer":"James Bosley","Actors":"Renée Humphrey, Alicia Witt, William R. Moses","Plot":"Hillary and Bonnie meet one morning by the side of the road. They become fast friends, share their secrets, and on a rising wave of frenzy later that afternoon, murder an old woman. They did it, they say later, for fun.","Language":"English","Country":"Canada","Awards":"5 wins & 4 nominations","Poster":"https://m.media-amazon.com/images/M/MV5BMTYwMjU5NzM5Nl5BMl5BanBnXkFtZTcwMzQ3MTk1NA@@._V1_SX300.jpg","Ratings":[{"Source":"Internet Movie Database","Value":"6.9/10"},{"Source":"Rotten Tomatoes","Value":"82%"}],"Metascore":"N/A","imdbRating":"6.9","imdbVotes":"1,211","imdbID":"tt0109855","Type":"movie","DVD":"N/A","BoxOffice":"N/A","Production":"N/A","Website":"N/A","Response":"True"}
""".data(using: .utf8)

let invalidJson = """
      "Title":"Fun","Year":"1994","Rated":"Unrated","Released":"14 Apr 1995","Runtime":"105 min","Genre":"Crime, Drama","Director":"Rafal Zielinski","Writer":"James Bosley","Actors":"Renée Humphrey, Alicia Witt, William R. Moses","Plot":"Hillary and Bonnie meet one morning by the side of the road. They become fast friends, share their secrets, and on a rising wave of frenzy later that afternoon, murder an old woman. They did it, they say later, for fun.","Language":"English","Country":"Canada","Awards":"5 wins & 4 nominations","Poster":"https://m.media-amazon.com/images/M/MV5BMTYwMjU5NzM5Nl5BMl5BanBnXkFtZTcwMzQ3MTk1NA@@._V1_SX300.jpg","Ratings":[{"Source":"Internet Movie Database","Value":"6.9/10"},{"Source":"Rotten Tomatoes","Value":"82%"}],"Metascore":"N/A","imdbRating":"6.9","imdbVotes":"1,211","imdbID":"tt0109855","Type":"movie","DVD":"N/A","BoxOffice":"N/A","Production":"N/A","Website":"N/A","Response":"True"
""".data(using: .utf8)

class JSONParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
            
    let emptyJSON = "{ }".data(using: .utf8)
    
    func testJSONParserWithValidJSON() {
        if let jsonData = validJson, let movieModel: SearchResult.Movie = JSONParser.decodeJson(from: jsonData) {
            XCTAssertEqual(movieModel.imdbID, "tt0109855")
            XCTAssertEqual(movieModel.genre, "Crime, Drama")
            XCTAssertEqual(movieModel.director, "Rafal Zielinski")
            XCTAssertEqual(movieModel.imdbRating, "6.9")
            XCTAssertEqual(movieModel.poster, "https://m.media-amazon.com/images/M/MV5BMTYwMjU5NzM5Nl5BMl5BanBnXkFtZTcwMzQ3MTk1NA@@._V1_SX300.jpg")
            XCTAssertEqual(movieModel.plot,"Hillary and Bonnie meet one morning by the side of the road. They become fast friends, share their secrets, and on a rising wave of frenzy later that afternoon, murder an old woman. They did it, they say later, for fun.")

        }
        else {
            XCTAssertTrue(false)
        }
    }
    
    func testJSONParserWithIEmptyJSON() {
        if let jsonData = emptyJSON {
            if let movieModel: SearchResult.Movie = JSONParser.decodeJson(from: jsonData) {
                XCTAssertTrue(false)
            }
            XCTAssertTrue(true)
        }
    }
        
        func testJSONParserWithInValidJSON() {
            if let jsonData = invalidJson, let movieModel: SearchResult.Movie = JSONParser.decodeJson(from: jsonData) {
                XCTAssertTrue(false)
            }
            XCTAssertTrue(true)
        }
    }
