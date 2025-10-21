//
//  loadView.swift
//  Xtadium
//
//  Created by MacBook 6 on 21/10/25.
//

import Foundation
import SwiftUI

struct LoadView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    var body: some View {
        if isActive {
            LoginView() // <- Tu vista principal
        } else {
            VStack(spacing: 10) {
                Image(systemName: "mustache") // Puedes reemplazar con tu logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.black)
                
                Text("Xtadium")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Creado por xCoders") // <- Cambia esto con tu nombre
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    opacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
#Preview {
    LoadView()
    
}
