import Foundation
import UserNotifications

enum PanicService {
    static func requestAuthorizationIfNeeded() async throws {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        if settings.authorizationStatus == .notDetermined {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if !granted {
                throw NSError(domain: "Panic", code: 1, userInfo: [NSLocalizedDescriptionKey: "Permiso de notificaciones denegado"])
            }
        }
    }

    static func schedulePanicAlert(message: String) async throws {
        let content = UNMutableNotificationContent()
        content.title = "⚠️ Alerta de pánico"
        content.body  = message
        content.sound = .default

        // Disparar casi inmediato
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }
}
