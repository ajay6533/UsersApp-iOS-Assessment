# UsersApp-iOS-Assessment

📱 ExampleProject
A modern SwiftUI iOS application demonstrating Clean Architecture, async/await, Combine, and unit testing for API-driven data. It fetches and displays a list of users from a mock REST API using a structured, testable networking layer.

🚀 Features
	•	Swift Concurrency (async/await) for asynchronous networking
	•	Combine pipeline alternative for reactive networking
	•	MVVM architecture separating UI, logic, and networking
	•	Comprehensive unit tests using XCTest and mock dependencies
	•	Reusable Network Layer with APIHandler, ResponseHandler, and NetworkManager
	•	SwiftUI views for list and detail screens
	•	Mock data for consistent test coverage

🧱 Architecture Overview
ExampleProject
├── Models
│   └── User.swift
├── Network
│   ├── APIHandler.swift
│   ├── ResponseHandler.swift
│   ├── NetworkManager.swift
│   └── CustomError.swift
├── Services
│   └── UserService.swift
├── ViewModels
│   ├── UserListViewModel.swift
│   └── UserDetailViewModel.swift
├── Views
│   ├── UserListView.swift
│   ├── UserRowView.swift
│   └── UserDetailView.swift
├── Tests
│   ├── NetworkManagerTests.swift
│   ├── UserServiceTests.swift
│   └── NetworkManagerCombineTests.swift
└── ExampleProjectApp.swift

⚙️ Networking Flow
UserListViewModel
   ↓
UserService (business logic)
   ↓
NetworkManager (coordinates API + decoding)
   ↓
APIHandler (handles URLSession)
   ↓
ResponseHandler (decodes JSON into models)

API Endpoint:
https://fake-json-api.mock.beeceptor.com/users

Example User JSON:
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

🧠 Key Components
🧩 APIHandler
Handles URLSession requests and validates HTTP responses.
🧩 ResponseHandler
Decodes JSON into Codable models with error handling.
🧩 NetworkManager
Coordinates network requests using both async/await and Combine.
🧩 UserService
A domain-level service responsible for fetching users.
🧩 UserListViewModel
Bridges between service layer and SwiftUI views.

🧪 Unit Testing
Includes full test coverage for:
	•	✅ Successful API responses
	•	✅ Network errors
	•	✅ Decoding errors
	•	✅ Combine publishers
Mock objects:
MockAPIHandler
MockResponseHandler
UserMockData
Run tests with:
⌘ + U

💡 Example Usage (Async/Await)
let userService = UserService()
Task {
    do {
        let users = try await userService.fetchUsers()
        print(users)
    } catch {
        print("❌ Error:", error)
    }
}

💡 Example Usage (Combine)
let userService = UserService()
let cancellable = userService.fetchusersPublisher()
    .sink(receiveCompletion: { print($0) },
          receiveValue: { print($0) })

🧾 Error Handling
Custom unified error enum:
enum CustomError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case invalidResponse
}

🧑‍💻 Requirements
	•	iOS 17.0+
	•	Xcode 16+
	•	Swift 6.0+

🧭 How to Run
	1	Clone the repository: git clone https://github.com/ajay6533/UsersApp-iOS-Assessment.git
	2	
	3	Open ExampleProject.xcodeproj or .xcworkspace in Xcode.
	4	Run on any iPhone simulator.

🧰 Dependencies
No external dependencies — fully native Swift & Combine.

🧩 Future Enhancements
	•	Add pagination
	•	Add image caching
	•	Add search/filtering
	•	Add UI tests using XCTest or XCUITest

📄 License
This project is licensed under the MIT License.

