import SwiftUI

struct TicketDetailView: View {
    let ticket: Ticket

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imgName = ticket.event.venue.image {
                    Image(imgName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom, 8)
                }
                
                Text(ticket.event.name)
                    .font(.title2).bold()

                LabeledContent("Fecha", value: formatDateLong(ticket.event.date))
                LabeledContent("Lugar", value: ticket.event.venue.stadium)
                LabeledContent("Ciudad", value: "\(ticket.event.venue.city), \(ticket.event.venue.country)")

                Divider()

                Text("Asiento").font(.headline)
                LabeledContent("Sección", value: ticket.seat.section)
                LabeledContent("Fila", value: ticket.seat.row)
                LabeledContent("Asiento", value: ticket.seat.seat_number)

                Divider()

                Text("Compra").font(.headline)
                LabeledContent("Precio", value: "\(ticket.price.currency) \(ticket.price.amount)")
                LabeledContent("Estado", value: ticket.status.capitalized)
                LabeledContent("Entrega", value: ticket.delivery_method.capitalized)
                LabeledContent("Fecha de compra", value: formatDateLong(ticket.purchase_date))

                Divider()

                if let url = URL(string: ticket.barcode) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Código de acceso").font(.headline)
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let img):
                                img.resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 280)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            case .failure:
                                Text("No se pudo cargar el código").foregroundStyle(.secondary)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Boleto \(ticket.ticket_id)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private func formatDateLong(_ date: Date) -> String {
    let df = DateFormatter()
    df.locale = Locale(identifier: "es_ES")
    df.dateStyle = .full
    df.timeStyle = .short
    return df.string(from: date)
}
