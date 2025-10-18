
import Foundation


enum CustomError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case invalidResponse
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No Data"
        case .decodingError:
            return "Decoding failed"
        case .invalidResponse:
            return "Invald response"
        }
    }
}

