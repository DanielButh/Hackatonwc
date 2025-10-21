import SwiftUI
import UserNotifications

@main
struct XtadiumApp: App {
    @StateObject private var session = SessionViewModel()
    private let notifDelegate = NotificationDelegate() // 👈 instancia

    init() {
        // Asignar delegado para mostrar notifs en foreground
        UNUserNotificationCenter.current().delegate = notifDelegate
    }

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
