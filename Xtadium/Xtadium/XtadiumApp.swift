//
//  XtadiumApp.swift
//  Xtadium
//
//  Created by MacBook 6 on 21/10/25.
//

import SwiftUI

@main
struct WorldCupTicketsApp: App {
    @StateObject private var session = SessionViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if session.isAuthenticated {
                    TicketsView()
                        .environmentObject(session)
                } else {
                    LoginView()
                        .environmentObject(session)
                }
            }
        }
    }
}

