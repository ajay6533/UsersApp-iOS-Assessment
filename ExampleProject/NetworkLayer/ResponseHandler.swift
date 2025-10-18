
import Foundation


protocol ResponseHandlerProtocol {
    func handleResponse<T: Codable>(type: T.Type, data: Data) async throws -> T
}


class ResponseHandler: ResponseHandlerProtocol {
    func handleResponse<T: Codable>(type: T.Type, data: Data) async throws -> T {
        do {
            let decoded = try JSONDecoder().decode(type, from: data)
            return decoded
        } catch {
            throw CustomError.decodingError
        }
    }
}

