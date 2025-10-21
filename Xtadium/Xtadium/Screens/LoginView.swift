//
//  LoginView.swift
//  MiPrimerProyecto
//
//  Created by Facultad de Contaduría y Administración on 24/03/25.
//

import SwiftUI

struct Login2View: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Bienvenido")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding(.top, 100)
                
                Text("Selecciona una opción")
                
                Spacer()
                
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
                    
                    NavigationLink(destination: MapView()) {
                        HStack {
                            Text("Registrarse")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .navigationBarBackButtonHidden()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                }
                .padding(.bottom, 200)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Login2View()
}
