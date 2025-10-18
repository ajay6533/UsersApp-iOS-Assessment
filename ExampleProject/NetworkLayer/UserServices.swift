//
//  UserServiceProtocol.swift
//  ExampleProject


import Foundation
import Combine

protocol UserServiceProtocol {
    // Async function for fetching users
    func fetchUsers() async throws -> [User]
    // Combine publisher wrapper (optional) — demonstrates Combine usage
    func fetchusersPublisher() -> AnyPublisher<[User], CustomError>
}

class UserService: UserServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "https://fake-json-api.mock.beeceptor.com/users") else {
            throw CustomError.invalidResponse
        }
        
        do {
            let result: [User] = try await networkManager.fetchRequest(type: [User].self, url: url)
            return result
        } catch {
            print("❌ Error fetching users: \(error)")
            throw error
        }
    }
    
    // Combine publisher wrapper (optional) — demonstrates Combine usage
    func fetchusersPublisher() -> AnyPublisher<[User], CustomError> {
           guard let url = URL(string: "https://fake-json-api.mock.beeceptor.com/users") else {
               return Fail(error: CustomError.invalidResponse).eraseToAnyPublisher()
           }
           
           return networkManager.fetchRequestPublisher(type: [User].self, url: url)
       }
}
