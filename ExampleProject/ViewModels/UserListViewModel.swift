//
//  UserListViewModel.swift
//  ExampleProject


import Foundation
import Combine


@MainActor
final class UserListViewModel: ObservableObject {
    // Published properties for SwiftUI
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    
    // Fetch using async/await
    func loadUsers() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await userService.fetchUsers()
            users = fetched
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // Alternate: load using Combine (demonstration)
    func loadUsersCombine() {
        isLoading = true
        userService.fetchusersPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let err) = completion {
                    self.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
    }
}
