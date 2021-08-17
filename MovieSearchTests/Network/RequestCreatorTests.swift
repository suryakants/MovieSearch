import XCTest
@testable import TaxiSearch

class RequestCreatorTests: XCTestCase {    
    func testCreateRequest() {
        let (p1, p2) = CommonUtility.hamburgBound()
        let request = RequestCreator.createRequest(for: p1, point2: p2)
        XCTAssertEqual(request?.url?.absoluteString, "https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891")
    }
}
