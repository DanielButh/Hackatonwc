//
//  HomeView.swift
//  FoodCup
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
                
                ScrollView (showsIndicators: false) {
                    VStack (alignment: .leading) {
                        
                        HStack {
                            Button(action: {}) {
                                Image("menu")
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10.0)
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(uiImage: #imageLiteral(resourceName: "Profile"))
                                    .resizable()
                                    .frame(width: 42, height: 42)
                                    .cornerRadius(10.0)
                            }
                        }
                        .padding(.horizontal)
                        
                    }
                }
                
                
            }
        }
    }
}

#Preview {
    HomeView()
}
