import Foundation
internal import Combine

@MainActor
final class PanicViewModel: ObservableObject {
    @Published var tickets: [Ticket] = []
    @Published var selectedIndex: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadTickets(userId: String, token: String) {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let res = try await TicketService.shared.fetchTickets(for: userId, token: token)
                // Ordena por fecha (próximos primero)
                let sorted = res.tickets.sorted { $0.event.date < $1.event.date }
                self.tickets = sorted
                // Selección por defecto: el más próximo a hoy
                if let idx = sorted.firstIndex(where: { $0.event.date > Date() }) {
                    selectedIndex = idx
                } else {
                    selectedIndex = 0
                }
            } catch {
                errorMessage = (error as NSError).localizedDescription
            }
            isLoading = false
        }
    }

    func panicMessage() -> String {
        guard tickets.indices.contains(selectedIndex) else {
            return "Alerta de pánico"
        }
        let t = tickets[selectedIndex]
        let estadio = t.event.venue.stadium
        let seccion = t.seat.section
        return "Alerta de pánico en el \(estadio) – Sección \(seccion)"
    }
}
