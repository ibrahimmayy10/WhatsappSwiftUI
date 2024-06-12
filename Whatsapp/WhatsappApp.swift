//
//  WhatsappApp.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 18.03.2024.
//

import SwiftUI
import FirebaseCore

@main
struct WhatsappApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
