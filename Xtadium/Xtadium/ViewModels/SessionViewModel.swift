import Foundation

@MainActor
final class SessionViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var token: String?
    @Published var userId: String?
    @Published var displayName: String?
    @Published var email: String?

    @Published var authError: String?

    func login(email: String, password: String) {
        Task {
            authError = nil
            do {
                let result = try await AuthService.shared.login(email: email, password: password)
                self.isAuthenticated = true
                self.token = result.token
                self.userId = result.userId
                self.displayName = result.displayName
                self.email = email
            } catch {
                self.authError = (error as NSError).localizedDescription
                self.isAuthenticated = false
            }
        }
    }

    func logout() {
        isAuthenticated = false
        token = nil
        userId = nil
        displayName = nil
        email = nil
    }
}
