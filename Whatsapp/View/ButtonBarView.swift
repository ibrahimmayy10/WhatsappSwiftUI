//
//  ButtonBarView.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 22.03.2024.
//

import SwiftUI

struct ButtonBarView: View {
    
    var currentView: CurrentView
    
    enum CurrentView {
        case updates, chats, settings
    }
    
    var body: some View {
        HStack {
            NavigationLink(destination: MainView()) {
                ButtonBarItem(systemName: currentView == .updates ? "message.badge.circle.fill" : "message.badge.circle", text: "Durumlar", isHighlighted: currentView == .updates)
            }
            
            NavigationLink(destination: MainView()) {
                ButtonBarItem(systemName: currentView == .chats ? "message.badge.fill" : "message.badge", text: "Sohbetler", isHighlighted: currentView == .chats)
            }
            
            NavigationLink(destination: MainView()) {
                ButtonBarItem(systemName: currentView == .settings ? "gear.circle.fill" : "gear.circle", text: "Ayarlar", isHighlighted: currentView == .settings)
            }
        }
    }
}

#Preview {
    ButtonBarView(currentView: .chats)
}
