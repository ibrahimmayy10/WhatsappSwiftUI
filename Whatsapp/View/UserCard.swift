//
//  UserCard.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 24.03.2024.
//

import SwiftUI

struct UserCard: View {
    
    @State var user: UserModel
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.imageUrl)) { image in image
                    .image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .cornerRadius(50)
            }
            
            Text(user.name)
                .foregroundStyle(.primary)
                .padding(.leading)
        }
    }
}

#Preview {
    UserCard(user: UserModel(name: "İbrahim Ay", imageUrl: "", id: ""))
}
