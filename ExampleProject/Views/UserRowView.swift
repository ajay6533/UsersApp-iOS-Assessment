
import SwiftUI

struct UserRowView: View {
    let user: User
    var body: some View {
        HStack(alignment: .center, spacing: 12){
            AsyncImage(url: URL(string: user.photo ?? "")){phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 60, height: 60)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                case .failure(_):
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        }
        VStack(alignment: .leading, spacing: 4) {
            Text(user.name ?? "")
                .font(.headline)
            HStack{
                VStack(alignment: .leading,spacing: 8) {
                    if let email = user.email {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    if let phone = user.phone {
                        Text(phone)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }

        }
        .padding(.vertical, 8)
    }
}

#Preview {
    UserRowView(user: User(id: 1, name: "John Doe", username: "jdoe",
                           email: "john@example.com", phone: "123-456", photo: ""))
}
