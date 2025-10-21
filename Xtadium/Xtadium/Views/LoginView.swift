import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Iniciar sesión")
                    .font(.largeTitle).bold()

                
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                SecureField("Contraseña", text: $password)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if let err = session.authError {
                    Text(err)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }

                Button {
                    isLoading = true
                    session.login(email: email, password: password)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        isLoading = false
                    }
                } label: {
                    HStack {
                        if isLoading { ProgressView() }
                        Text("Entrar")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(email.isEmpty || password.isEmpty)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(SessionViewModel())
}

