//
//  LoginView.swift
//  Xtadium
//
//  Created by MacBook 6 on 21/10/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var emailError: String?
    @State private var passwordError: String?

    // Estado de navegación
    @State private var isShowingHome = false
    @State private var isShowingRegister = false

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 20) {
                    // Campos de texto
                    TextField("Correo", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)

                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)

                    // Botón de login que activa la navegación
                    Button {
                        emailError = validateEmail(email)
                        passwordError = validatePassword(password)

                        // Solo navegar si no hay errores
                        if emailError == nil && passwordError == nil {
                            isShowingHome = true
                        }
                    } label: {
                        Text("Inicio sesión")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .padding(.horizontal, 64)
                    }

                    // Navegación a pantalla de registro
                    HStack {
                        Text("¿No tienes una cuenta?")
                        Button {
                            isShowingRegister = true
                        } label: {
                            Text("Regístrate")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()

                    // Errores (si los hay)
                    if let emailError = emailError {
                        Text(emailError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    if let passwordError = passwordError {
                        Text(passwordError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)

                Spacer()
                Text("¿Olvidaste tu contraseña?")
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)

                // Navegación oculta controlada por estado
                NavigationLink(destination: MapView()) {
                    Text("Mapa")
                }

                NavigationLink(destination: ButtonView()) {
                    Text("Button")
                }
            }
            .navigationTitle("Inicio de sesión")
        }
    }

    // Validaciones
    func validateEmail(_ email: String) -> String? {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email) ? nil : "Correo inválido"
    }

    func validatePassword(_ password: String) -> String? {
        password.count < 8 ? "La contraseña debe tener al menos 8 caracteres" : nil
    }
}

#Preview {
    LoginView()
}
