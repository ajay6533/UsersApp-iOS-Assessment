
import XCTest
import Combine
@testable import ExampleProject

final class NetworkManagerCombineTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    func testFetchRequestPublisherSuccess() {
        // Arrange
        let networkManager = NetworkManager()
        let url = URL(string: "https://fake-json-api.mock.beeceptor.com/users")!
        let expectation = expectation(description: "Publisher completes successfully")
        
        // Act
        networkManager.fetchRequestPublisher(type: [User].self, url: url)
            .sink { completion in
                if case .failure = completion {
                    XCTFail("Expected success, got failure")
                }
            } receiveValue: { users in
                XCTAssertNotNil(users)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5)
    }
}
