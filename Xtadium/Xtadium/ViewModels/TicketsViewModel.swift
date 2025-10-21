import Foundation

@MainActor
final class TicketsViewModel: ObservableObject {
    @Published var user: User?
    @Published var tickets: [Ticket] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load(userId: String, token: String) {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let res = try await TicketService.shared.fetchTickets(for: userId, token: token)
                self.user = res.user
                self.tickets = res.tickets.sorted { $0.event.date < $1.event.date }
            } catch {
                self.errorMessage = (error as NSError).localizedDescription
            }
            isLoading = false
        }
    }
}
