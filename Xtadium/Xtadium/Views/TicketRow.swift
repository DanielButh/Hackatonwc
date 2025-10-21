import SwiftUI

struct TicketRow: View {
    let ticket: Ticket

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Text(ticket.event.name)
                .font(.headline)
                .lineLimit(2)

            Text("\(formatDate(ticket.event.date)) · \(ticket.event.venue.stadium)")
                .font(.subheadline)

            Text("Sección \(ticket.seat.section) · Fila \(ticket.seat.row) · Asiento \(ticket.seat.seat_number)")
                .font(.footnote)

            HStack {
                Text("\(ticket.price.currency) \(ticket.price.amount, format: .number.precision(.fractionLength(2)))")
                Spacer()
                Text(ticket.status.capitalized)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }
            .font(.footnote)
        }
        .padding(.vertical, 6)
    }
}

private func formatDate(_ date: Date) -> String {
    let df = DateFormatter()
    df.locale = Locale(identifier: "es_ES")
    df.dateStyle = .medium
    df.timeStyle = .short
    return df.string(from: date)
}
