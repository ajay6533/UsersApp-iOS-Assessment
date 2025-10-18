

import Foundation

protocol APIHandlerProtocol {
    func fetchDataFromAPI(url: URL) async throws -> Data
}

class APIHandler: APIHandlerProtocol {
    func fetchDataFromAPI(url: URL) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw CustomError.invalidURL
            }
            
            return data
        } catch {
            throw CustomError.noData
        }
    }
}
