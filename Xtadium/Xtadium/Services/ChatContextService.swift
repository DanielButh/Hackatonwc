import Foundation

struct ChatContextService {

    /// Construye un contexto textual a partir de tickets (usuario) y lugares (mapa)
    static func buildContext(userId: String, token: String) async throws -> String {
        // 1) Tickets del usuario
        let ticketsResponse = try await TicketService.shared.fetchTickets(for: userId, token: token)
        let tickets = ticketsResponse.tickets.sorted { $0.event.date < $1.event.date }

        // 2) Mapa (estadios + restaurantes cercanos)
        let stadiums = try MapDataService.shared.loadMapData()

        // 3) Seleccionar próximos eventos y un resumen de lugares cercanos al estadio
        let now = Date()
        let nextTickets = tickets.filter { $0.event.date >= now }.prefix(5)

        var ticketLines: [String] = []
        for t in nextTickets {
            let venue = t.event.venue
            let seat = t.seat
            ticketLines.append("""
            - Boleto \(t.ticket_id): "\(t.event.name)" el \(iso8601String(t.event.date)), Estadio: \(venue.stadium) (\(venue.city), \(venue.country)), Asiento: Sección \(seat.section), Fila \(seat.row), Asiento \(seat.seat_number)
            """)
        }
        if ticketLines.isEmpty {
            ticketLines.append("- (No hay próximos boletos)")
        }

        // Mapeo estadio -> restaurantes
        var venueBlocks: [String] = []
        for s in stadiums {
            let est = s.estadio
            let list = s.restaurantes.prefix(5).map { "  • \($0.nombre) (\($0.latitud), \($0.longitud))" }.joined(separator: "\n")
            venueBlocks.append("""
            Estadio: \(est.nombre) [\(est.latitud), \(est.longitud)]
            Restaurantes cercanos:
            \(list.isEmpty ? "  • (Sin datos)" : list)
            """)
        }

        // 4) Instrucciones del asistente + datos
        let system = """
        Eres un asistente para un fan que tiene boletos del Mundial 2026. Responde SOLO con base en los datos provistos a continuación:
        - Recomienda restaurantes cercanos según el estadio de sus próximos partidos.
        - Si el usuario pregunta por asientos, estadio o fecha, usa la información exacta del ticket.
        - Si te piden direcciones, sugiere una breve guía basada en cercanía (sin inventar).
        - Si no hay datos suficientes, dilo explícitamente.

        FORMATO BREVE: titula en una línea y da 3–5 bullets cuando recomiendes.
        """

        let ticketsSection = """
        =========== BOLETOS PRÓXIMOS ===========
        \(ticketLines.joined(separator: "\n"))
        """

        let venuesSection = """
        =========== ESTADIOS Y LUGARES ===========
        \(venueBlocks.joined(separator: "\n\n"))
        """

        return [system, ticketsSection, venuesSection].joined(separator: "\n\n")
    }

    private static func iso8601String(_ date: Date) -> String {
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return df.string(from: date)
    }
}
