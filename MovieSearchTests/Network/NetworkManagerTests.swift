import XCTest
@testable import MovieSearch

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager(session: session)
    }
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func testGetRequestWithMovieURL() {
        guard let url = URL(string: "http://www.omdbapi.com/?s=test&type=movie&page=1&r=json&apikey=6c288424") else {
            fatalError("URL can't be empty")
        }
        networkManager.search(for: "test") { _ in  }
        XCTAssertEqual(session.lastURL, url)
    }
    
    func testGetRequestWithURL() {
        guard let url = URL(string: "http://www.omdbapi.com/?i=&r=json&apikey=6c288424") else {
            fatalError("URL can't be empty")
        }
        networkManager.fetchMovie(with: "") { _ in
            
        }
        XCTAssertEqual(session.lastURL, url)
    }
    func testGetResumeCalled() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        networkManager.search(for: "test") { _ in  }
        XCTAssert(dataTask.resumeWasCalled)
    }

    func testGetShouldReturnData() {
        let expectedData = "{}".data(using: .utf8)
        session.nextData = expectedData
        var actualData: Data?
        networkManager.search(for: "test") { (result) in
            //data and error return here
            switch result {
            case .success(let data):
                actualData = data
            case .failure(_):
                break
            }
        }
        XCTAssertNotNil(actualData)
        XCTAssertEqual(actualData, expectedData)
    }
}
