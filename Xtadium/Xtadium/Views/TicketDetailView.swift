import SwiftUI

struct TicketDetailView: View {
    let ticket: Ticket

    var body: some View {
        ScrollView {
            ScrollView {
                if let imgName = ticket.event.venue.image {
                    Image(imgName)
                        .resizable()
                        /*.scaledToFit()
                        .frame(maxWidth: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom, 8)*/
                        .aspectRatio(1, contentMode: .fit)
                        .edgesIgnoringSafeArea(.top)
                        
                    
                }
                VStack {
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
                .padding(.top)
                .background(Color.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .offset(x: 0, y:-30.0)
                .shadow(radius: 70)
            }
            .edgesIgnoringSafeArea(.top)
            .padding(.top, -120)
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

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

#Preview {
    let session = SessionViewModel()
    // (Opcional) simular sesión iniciada:
    session.isAuthenticated = true
    session.token = "MOCK_TOKEN"
    session.userId = "user_001"
    session.displayName = "Juan Pérez"

    return TicketsView()
        .environmentObject(session)
}

