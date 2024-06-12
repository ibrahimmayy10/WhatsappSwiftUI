//
//  ButtonBarItem.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 22.03.2024.
//

import SwiftUI

struct ButtonBarItem: View {
    
    var systemName: String
    var text: String
    var isHighlighted: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: systemName)
                .padding(.leading, 20)
                .padding(.top, 5)
                .foregroundStyle(isHighlighted ? .blue : Color(uiColor: .darkGray))
            
            Text(text)
                .font(.system(size: 12))
                .foregroundStyle(isHighlighted ? .blue : Color(uiColor: .darkGray))
                .padding(.leading, 20)
        }
    }
}

#Preview {
    ButtonBarItem(systemName: "", text: "", isHighlighted: false)
}
