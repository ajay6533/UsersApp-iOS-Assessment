//
//  NetworkManager.swift
//  ExampleProject


import Foundation
import Combine

protocol NetworkManagerProtocol {
    func fetchRequest<T: Codable>(type: T.Type, url: URL) async throws -> T
    //Using Combine(Optional)
    func fetchRequestPublisher<T: Codable>(type: T.Type, url: URL) -> AnyPublisher<T, CustomError>
}


class NetworkManager: NetworkManagerProtocol {
    let apiHandler: APIHandlerProtocol
    let responseHandler: ResponseHandlerProtocol
    
    init(apiHandler: APIHandlerProtocol = APIHandler(),
         responseHandler: ResponseHandlerProtocol = ResponseHandler()) {
        self.apiHandler = apiHandler
        self.responseHandler = responseHandler
    }
    
    func fetchRequest<T: Codable>(type: T.Type, url: URL) async throws -> T {
        let data = try await apiHandler.fetchDataFromAPI(url: url)
        let decoded = try await responseHandler.handleResponse(type: type, data: data)
        return decoded
    }
    
    // Alternate: load using Combine (demonstration)
    func fetchRequestPublisher<T: Codable>(type: T.Type, url: URL) -> AnyPublisher<T, CustomError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw CustomError.invalidResponse
                }
                return data
            }
            .decode(type: type, decoder: JSONDecoder())
            .mapError { error in
                // Convert any error into your CustomError
                if error is DecodingError {
                    return .decodingError
                } else {
                    return .noData
                }
            }
            .eraseToAnyPublisher()
    }
    
}







