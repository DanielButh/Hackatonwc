import Foundation
internal import Combine

@MainActor
final class PanicViewModel: ObservableObject {
    @Published var tickets: [Ticket] = []
    @Published var selectedIndex: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Llama esto cuando cargues, igual que antes
    func loadTickets(userId: String, token: String) {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let res = try await TicketService.shared.fetchTickets(for: userId, token: token)
                self.tickets = res.tickets.sorted { $0.event.date < $1.event.date }
            } catch {
                self.errorMessage = (error as NSError).localizedDescription
            }
            isLoading = false
        }
    }

    // 1) Resolver el ticket “vigente” según el momento actual
    func resolveTicketForNow(now: Date = Date()) -> Ticket? {
        guard !tickets.isEmpty else { return nil }

        let lead: TimeInterval = 60 * 60          // 60 min antes
        let duration: TimeInterval = 2.5 * 60 * 60 // partido ~2.5h (90' + descanso + compensación)
        let windowAfter: TimeInterval = duration   // 2.5h después
        let upcomingHorizon: TimeInterval = 24 * 60 * 60 // próximos 24h

        // a) Partido en curso (o ventana inmediata)
        if let live = tickets.first(where: { t in
            let start = t.event.date.addingTimeInterval(-lead)
            let end = t.event.date.addingTimeInterval(windowAfter)
            return (start...end).contains(now)
        }) {
            return live
        }

        // b) Próximo partido dentro de 24h
        let future = tickets.filter { $0.event.date >= now }
        if let nextSoon = future.first(where: { $0.event.date.timeIntervalSince(now) <= upcomingHorizon }) {
            return nextSoon
        }

        // c) Si nada entra en la ventana, toma el más cercano en el futuro; si no hay, el más reciente pasado
        if let next = future.first {
            return next
        } else {
            return tickets.max(by: { $0.event.date < $1.event.date }) // el último pasado
        }
    }

    // 2) Mensaje dinámico en el momento del tap
    func panicMessageAtTap(now: Date = Date()) -> String {
        guard let t = resolveTicketForNow(now: now) else {
            return "Alerta de pánico"
        }
        return "Alerta de pánico en el \(t.event.venue.stadium) – Sección \(t.seat.section)"
    }
}
