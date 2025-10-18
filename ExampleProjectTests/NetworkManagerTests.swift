//
//  UserAPIServiceTests.swift
//  ExampleProjectTests
//
//  Created by Suresh Shiga on 18/10/25.
//

import XCTest
@testable import ExampleProject


class MockAPIHandler: APIHandlerProtocol {
    var dataToReturn: Data?
    var errorToThrow: CustomError?
    
    func fetchDataFromAPI(url: URL) async throws -> Data {
        if let error = errorToThrow {
            throw error
        }
        guard let data = dataToReturn else {
            throw CustomError.noData
        }
        return data
    }
}

class MockResponseHandler: ResponseHandlerProtocol {
    var objectToReturn: Any?
    var errorToThrow: CustomError?
    
    func handleResponse<T>(type: T.Type, data: Data) async throws -> T where T : Decodable, T : Encodable {
        if let error = errorToThrow {
            throw error
        }
        if let object = objectToReturn as? T {
            return object
        }
        throw CustomError.decodingError
    }
}

final class NetworkManagerTests: XCTestCase {
    
    func testFetchRequestSuccess() async throws {
            // Arrange
            let mockAPI = MockAPIHandler()
            let mockResponse = MockResponseHandler()
            
            mockAPI.dataToReturn = UserMockData.jsonData
            mockResponse.objectToReturn = UserMockData.sampleUsers
            
            let networkManager = NetworkManager(apiHandler: mockAPI, responseHandler: mockResponse)
            let url = URL(string: "https://example.com")!
            
            // Act
            let result = try await networkManager.fetchRequest(type: [User].self, url: url)
            
            // Assert
            XCTAssertEqual(result, UserMockData.sampleUsers)
            XCTAssertEqual(result.first?.name, "Reina Mraz")
        }
    
    
    func testFetchRequestAPIError() async {
        // Arrange
        let mockAPI = MockAPIHandler()
        mockAPI.errorToThrow = .noData
        let mockResponse = MockResponseHandler()
        
        let networkManager = NetworkManager(apiHandler: mockAPI, responseHandler: mockResponse)
        let url = URL(string: "https://example.com")!
        
        // Act & Assert
        do {
                _ = try await networkManager.fetchRequest(type: [User].self, url: url)
                XCTFail("Expected error, but got success")
            } catch {
                XCTAssertEqual(error as? CustomError, .noData)
            }
    }
    
    func testFetchRequestDecodingError() async {
        // Arrange
        let mockAPI = MockAPIHandler()
        mockAPI.dataToReturn = Data("invalid json".utf8)
        let mockResponse = MockResponseHandler()
        mockResponse.errorToThrow = .decodingError
        
        let networkManager = NetworkManager(apiHandler: mockAPI, responseHandler: mockResponse)
        let url = URL(string: "https://example.com")!
        
        // Act & Assert
        do {
                _ = try await networkManager.fetchRequest(type: [User].self, url: url)
                XCTFail("Expected error, but got success")
            } catch {
                XCTAssertEqual(error as? CustomError, .noData)
            }
       
    }
}


struct UserMockData {
    
    // ✅ JSON string for your sample API response
    static let jsonString = """
    [
        {
            "id": 1,
            "name": "Reina Mraz",
            "company": "Kub, Rau and Graham",
            "username": "Susan_Hintz5",
            "email": "Winnifred_Reilly63@yahoo.com",
            "address": "459 Meagan Track",
            "zip": "14658",
            "state": "New Jersey",
            "country": "Ecuador",
            "phone": "1-452-931-7180 x28885",
            "photo": "https://json-server.dev/ai-profiles/85.png"
        }
    ]
    """

    // ✅ JSON Data (for mocking API responses)
    static var jsonData: Data {
        Data(jsonString.utf8)
    }

    // ✅ Decoded Swift model (for assertion)
    static var sampleUsers: [User] {
        do {
            return try JSONDecoder().decode([User].self, from: jsonData)
        } catch {
            fatalError("❌ Failed to decode UserMockData: \(error)")
        }
    }

    // Convenience single user
    static var sampleUser: User {
        sampleUsers.first!
    }
}
