import SwiftUI

struct AuthedTabView: View {
    @EnvironmentObject var session: SessionViewModel

    var body: some View {
        TabView {
            // Boletos
            NavigationStack {
                TicketsView()
                    .navigationTitle("Mis Boletos")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Salir") { session.logout() }
                        }
                    }
            }
            .tabItem { Label("Boletos", systemImage: "ticket.fill") }

            // Mapa
            NavigationStack {
                StadiumMapView()
                    .navigationTitle("Mapa de Estadios")
            }
            .tabItem { Label("Mapa", systemImage: "map.fill") }

            // Pánico
            NavigationStack {
                PanicView()
                    .navigationTitle("Alerta de Pánico")
            }
            .tabItem { Label("Pánico", systemImage: "exclamationmark.triangle.fill") }
        }
    }
}

#Preview {
    let session = SessionViewModel()
    session.isAuthenticated = true
    return AuthedTabView().environmentObject(session)
}
