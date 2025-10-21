import SwiftUI

struct TicketsView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var vm = TicketsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Cargando boletos…")
                } else if let error = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text(error).foregroundStyle(.red)
                        Button("Reintentar") {
                            load()
                        }
                    }
                } else if vm.tickets.isEmpty {
                    ContentUnavailableView("No hay boletos", systemImage: "ticket")
                } else {
                    List(vm.tickets) { ticket in
                        NavigationLink {
                            TicketDetailView(ticket: ticket)
                        } label: {
                            TicketRow(ticket: ticket)
                        }
                    }
                }
            }
            .navigationTitle("Mis Boletos")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if let name = session.displayName {
                        Text(name).font(.callout)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salir") { session.logout() }
                }
            }
            .onAppear(perform: load)
        }
    }

    private func load() {
        guard let uid = session.userId, let token = session.token else { return }
        vm.load(userId: uid, token: token)
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
