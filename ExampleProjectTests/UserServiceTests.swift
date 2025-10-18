
import XCTest
@testable import ExampleProject

final class UserServiceTests: XCTestCase {
    
    func testFetchUsersSuccess() async throws {
          let mockAPI = MockAPIHandler()
          mockAPI.dataToReturn = UserMockData.jsonData
          let mockResponse = MockResponseHandler()
          mockResponse.objectToReturn = UserMockData.sampleUsers
          
          let networkManager = NetworkManager(apiHandler: mockAPI, responseHandler: mockResponse)
          let service = UserService(networkManager: networkManager)
          
          let users = try await service.fetchUsers()
          
          XCTAssertEqual(users.count, 1)
          XCTAssertEqual(users.first, UserMockData.sampleUser)
      }
    
    func testFetchUsersFailure() async {
        // Arrange
        let mockAPI = MockAPIHandler()
        mockAPI.errorToThrow = .noData
        let mockResponse = MockResponseHandler()
        let networkManager = NetworkManager(apiHandler: mockAPI, responseHandler: mockResponse)
        let userService = UserService(networkManager: networkManager)
        
        // Act & Assert
        do {
                _ = try await userService.fetchUsers()
                XCTFail("Expected error, but got success")
            } catch {
                XCTAssertEqual(error as? CustomError, .noData)
            }
    }
}
