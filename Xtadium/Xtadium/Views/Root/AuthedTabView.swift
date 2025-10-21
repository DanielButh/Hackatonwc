import SwiftUI

struct AuthedTabView: View {
    @EnvironmentObject var session: SessionViewModel
    @State private var showChat = false
    @State private var chatVM: ChatViewModel? = nil

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $session.selectedTab) {
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
                .tag(AuthedTab.tickets)

                NavigationStack {
                    StadiumMapView()
                        .navigationTitle("Mapa de Estadios")
                }
                .tabItem { Label("Mapa", systemImage: "map.fill") }
                .tag(AuthedTab.map)

                NavigationStack {
                    PanicView()
                        .navigationTitle("Alerta de Pánico")
                }
                .tabItem { Label("Pánico", systemImage: "exclamationmark.triangle.fill") }
                .tag(AuthedTab.panic)
            }

            // FAB flotante sobre el TabView
            FloatingChatButton {
                Task {
                    guard let uid = session.userId, let token = session.token else { return }
                    let ctx = try? await ChatContextService.buildContext(userId: uid, token: token)
                    let vm = ChatViewModel(initialContext: ctx)
                    vm.primeWithContextIfNeeded()
                    self.chatVM = vm
                    self.showChat = true
                }
            }
        }
        .sheet(isPresented: $showChat) {
            if let vm = chatVM {
                NavigationStack {
                    ChatView(viewModel: vm)
                        .navigationTitle("Asistente IA")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Cerrar") { showChat = false }
                            }
                        }
                }
            }
        }
    }
}


#Preview {
    let session = SessionViewModel()
    session.isAuthenticated = true
    session.token = "MOCK_TOKEN"
    session.userId = "user_001"
    session.displayName = "Juan Pérez"

    return AuthedTabView().environmentObject(session)
}
