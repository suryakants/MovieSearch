import XCTest
@testable import TaxiSearch

class VehicleViewModelTests: XCTestCase {

    var networkManager: NetworkManager!
    var vehicleListViewModel: VehicleListViewModel?
    override func setUp() {
        super.setUp()
        let session = MockURLSession()
        session.nextData = validJson
        networkManager = NetworkManager(session: session)
    }

    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func vehicleViewModelCreation() {
        vehicleListViewModel = VehicleListViewModel {
            XCTAssertTrue(true)
        }
        let (p1, p2) = CommonUtility.hamburgBound()
        vehicleListViewModel?.fetchVehicles(from: p1, to: p2, networkManager: networkManager)
    }
    func testVehicleListViewModel() {
        vehicleViewModelCreation()
        XCTAssertEqual(vehicleListViewModel?.vehicles.count, 2)
        XCTAssertEqual(vehicleListViewModel?.vehicles.first?.id, -972941910)
        XCTAssertEqual(vehicleListViewModel?.vehicles.first?.type, "Taxi")
        XCTAssertEqual(vehicleListViewModel?.vehicles.first?.isAvailableForHire, true)
        XCTAssertEqual(vehicleListViewModel?.vehicles.first?.heading, 53.76201248168945)
        XCTAssertEqual(vehicleListViewModel?.vehicles.first?.coordinate.latitude, 53.55488010226958)
        XCTAssertEqual(vehicleListViewModel?.vehicles.first?.coordinate.longitude, 9.925684779882431)
    }
    
    func testVehicleListViewModelWithInvalidJSON() {
        let session = MockURLSession()
        session.nextData = invalidJson
        networkManager = nil
        networkManager = NetworkManager(session: session
        )
        
        vehicleListViewModel = VehicleListViewModel {
            XCTAssertTrue(false)
        }
        
        vehicleListViewModel?.errorOccurred = { error in
            XCTAssertEqual(error, .invalidData)
        }

        let (p1, p2) = CommonUtility.hamburgBound()
        vehicleListViewModel?.fetchVehicles(from: p1, to: p2, networkManager: networkManager)
    }

}
