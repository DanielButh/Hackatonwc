import Foundation

final class TicketService {
    static let shared = TicketService()
    private init() {}

    func fetchTickets(for userId: String, token: String) async throws -> TicketsResponse {
        // En un backend real usarías el token en headers; aquí solo validamos que no esté vacío
        guard !token.isEmpty else {
            throw NSError(domain: "Tickets", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token inválido"])
        }

        guard let url = Bundle.main.url(forResource: "mock_tickets", withExtension: "json") else {
            throw NSError(domain: "Tickets", code: 404, userInfo: [NSLocalizedDescriptionKey: "mock_tickets.json no encontrado"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        // El JSON puede contener múltiples usuarios; filtramos aquí
        let all = try decoder.decode([TicketsResponse].self, from: data)
        if let match = all.first(where: { $0.user.id == userId }) {
            return match
        } else {
            throw NSError(domain: "Tickets", code: 404, userInfo: [NSLocalizedDescriptionKey: "No hay boletos para este usuario"])
        }
    }
}
