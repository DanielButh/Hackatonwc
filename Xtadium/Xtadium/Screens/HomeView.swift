//
//  HomeView.swift
//  Xtadium
//
//  Created by MacBook 6 on 21/10/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            
            Text("Hello World")
            ScrollView {
                Text("Hola")
                Text("Hola")
                Text("Hola")
                Text("Hola")
                Text("Hola")
                Text("Hola")
                Text("Hola")
                Text("Hola")
                Text("Hola")
            }
            
            VStack {
                Spacer()
                BottomNavBarView()
            }
        }
    }
}

struct BottomNavBarView: View {
    var body: some View {
        NavigationView {
            HStack {
                NavigationLink(destination: MapView()) {
                    BottomNavBarItem(image: Image(systemName: "map"), action: {})
                }
                BottomNavBarItem(image: Image(systemName: "list.dash.header.rectangle"), action: {})
                BottomNavBarItem(image: Image(systemName: "exclamationmark.circle"), action: {})
            }
            .padding()
            .background(Color.white)
            .clipShape(Capsule())
            .padding(.horizontal)
            .shadow(color: Color.blue.opacity(0.15), radius: 8, x: 2, y: 6)
        }
    }
}

struct BottomNavBarItem: View {
    let image: Image
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            image
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    HomeView()
}
