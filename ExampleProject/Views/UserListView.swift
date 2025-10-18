
import SwiftUI
import Combine

struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Text("Error: \(error)")
                        Button("Retry") {
                            Task { await viewModel.loadUsers() }
                        }
                    }
                } else {
                    List(viewModel.users) { user in
                        NavigationLink(destination: UserDetailView(viewModel:
                                                                    UserDetailViewModel(user: user))) {
                            UserRowView(user: user)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable {
                        await viewModel.loadUsers()
                    }
                }
            }
            .navigationTitle("Users")
        }
        .task {
            // Load once when view appears
            await viewModel.loadUsers()
            
// Alternate: load using Combine (demonstration)
//            viewModel.loadUsersCombine()

        }
    }
}

#Preview {
    UserListView()
}



