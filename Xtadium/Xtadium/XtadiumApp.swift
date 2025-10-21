import SwiftUI

@main
struct WorldCupTicketsApp: App {
    @StateObject private var session = SessionViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if session.isAuthenticated {
                    AuthedTabView()
                        .environmentObject(session)
                } else {
                    LoginView()
                        .environmentObject(session)
                }
            }
        }
    }
}
