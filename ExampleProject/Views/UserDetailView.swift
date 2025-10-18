
import SwiftUI

struct UserDetailView: View {
    @ObservedObject var viewModel: UserDetailViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.user.name ?? "")
                .font(.title)
                .bold()
            if let username = viewModel.user.username {
                Text("@\(username)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Divider()
            if let email = viewModel.user.email {
                Label(email, systemImage: "envelope")
                if let phone = viewModel.user.phone {
                    Label(phone, systemImage: "phone")
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}

#Preview {
    let user = User(id: 1, name: "Jane Doe", username: "jane", email:
                        "jane@x.com", phone: "123", photo: "")
    UserDetailView(viewModel: UserDetailViewModel(user: user))
}
