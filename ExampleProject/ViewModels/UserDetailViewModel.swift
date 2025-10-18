
import Foundation

final class UserDetailViewModel: ObservableObject {
    let user: User
    init(user: User) {
        self.user = user
    }
    var title: String { user.name ?? "" }
}
