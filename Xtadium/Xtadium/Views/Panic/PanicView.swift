import SwiftUI

struct PanicView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var vm = PanicViewModel()
    @State private var showingResult = false
    @State private var resultText = ""

    var body: some View {
        VStack(spacing: 16) {
            if vm.isLoading {
                ProgressView("Cargando tus boletos…")
            } else if let err = vm.errorMessage {
                Text(err).foregroundStyle(.red)
                Button("Reintentar", action: load)
            } else if vm.tickets.isEmpty {
                ContentUnavailableView("Sin boletos", systemImage: "ticket")
            } else {
                // Selector del boleto
                Picker("Boleto", selection: $vm.selectedIndex) {
                    ForEach(vm.tickets.indices, id: \.self) { idx in
                        let t = vm.tickets[idx]
                        Text("\(t.event.venue.stadium) · Sección \(t.seat.section)")
                            .tag(idx)
                    }
                }
                .pickerStyle(.navigationLink)
                .padding(.horizontal)

                Spacer()

                // Botón gigante de pánico
                Button {
                    Task {
                        do {
                            try await PanicService.requestAuthorizationIfNeeded()
                            let msg = vm.panicMessage()
                            try await PanicService.schedulePanicAlert(message: msg)
                            resultText = "Notificación enviada:\n\(msg)"
                            showingResult = true
                        } catch {
                            resultText = (error as NSError).localizedDescription
                            showingResult = true
                        }
                    }
                } label: {
                    Text("ENVIAR ALERTA DE PÁNICO")
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 28)
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 8)
                        .padding(.horizontal)
                }

                Spacer(minLength: 20)
            }
        }
        .alert("Resultado", isPresented: $showingResult, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(resultText)
        })
        .task { load() }
    }

    private func load() {
        guard let uid = session.userId, let token = session.token else { return }
        vm.loadTickets(userId: uid, token: token)
    }
}

#Preview {
    // Preview con sesión simulada
    let s = SessionViewModel()
    s.isAuthenticated = true
    s.userId = "user_001"
    s.token = "MOCK"

    return PanicView().environmentObject(s)
}
