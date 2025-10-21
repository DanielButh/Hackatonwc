//
//  LoginView.swift
//  MiPrimerProyecto
//
//  Created by Facultad de Contaduría y Administración on 24/03/25.
//

import SwiftUI

struct Login2View: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Bienvenido")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding(.top, 80)
                
                Text("Inicia sesión")
                
                Spacer()
                VStack {
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
                }
                .padding(20)
                .padding(.bottom, 100)
                
                
                VStack {
                    NavigationLink(destination: ButtonView()) {
                        HStack {
                            Text("Iniciar Sesión")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                }
                .padding(.bottom, 100)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Login2View()
}
