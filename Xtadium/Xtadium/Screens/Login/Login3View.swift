//
//  LoginView.swift
//  Xtadium
//
//  Created by MacBook 6 on 21/10/25.
//

import SwiftUI

struct Login3View: View {
    @State private var email: String = ""
    @State private var password: String = ""

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
                        // Navegar directamente sin validaciones
                        isShowingHome = true
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
}


#Preview {
    Login3View()
}
