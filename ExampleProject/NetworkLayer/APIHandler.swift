

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



// Added timeout and retry
// class APIHandler: APIHandlerProtocol {
    
//     func fetchDataFromAPI(
//         url: URL,
//         retryCount: Int = 3,
//         timeout: TimeInterval = 10
//     ) async throws -> Data {
        
//         var attempts = 0
        
//         while attempts < retryCount {
//             do {
//                 return try await withTimeout(seconds: timeout) {
//                     try await makeRequest(url: url)
//                 }
//             } catch {
//                 attempts += 1
                
//                 // If last attempt, rethrow
//                 if attempts == retryCount {
//                     throw error
//                 }
                
//                 // Optional: Small delay before retry
//                 try? await Task.sleep(for: .milliseconds(300))
//             }
//         }
        
//         throw CustomError.noData  // fallback
//     }
// }

// private extension APIHandler {
    
//     func makeRequest(url: URL) async throws -> Data {
//         let (data, response) = try await URLSession.shared.data(from: url)
        
//         guard let httpResponse = response as? HTTPURLResponse,
//               200..<300 ~= httpResponse.statusCode else {
//             throw CustomError.invalidURL
//         }
//         return data
//     }
    
//     /// Timeout wrapper
//     func withTimeout<T>(seconds: TimeInterval, _ operation: @escaping () async throws -> T) async throws -> T {
//         try await withThrowingTaskGroup(of: T.self) { group in
            
//             // Main network request task
//             group.addTask {
//                 return try await operation()
//             }
            
//             // Timeout task
//             group.addTask {
//                 try await Task.sleep(for: .seconds(seconds))
//                 throw CustomError.timeout
//             }
            
//             // Return first completed task
//             let result = try await group.next()!
//             group.cancelAll()
//             return result
//         }
//     }
// }
