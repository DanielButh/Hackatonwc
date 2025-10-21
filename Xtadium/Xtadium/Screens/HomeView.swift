//
//  HomeView.swift
//  Xtadium
//
//  Created by MacBook 6 on 21/10/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1))
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack (alignment: .leading) {
                        
                        AppBarView()
                    }
                }
                
                VStack {
                    Spacer()
                    BottomNavBarView()
                }
                
            }
        }
    }
}

struct AppBarView: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "map")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10.0)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "map")
                    .resizable()
                    .frame(width: 42, height: 42)
                    .cornerRadius(10.0)
            }
        }
        .padding(.horizontal)
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
