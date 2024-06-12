//
//  AddUserView.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 22.03.2024.
//

import SwiftUI
import Firebase

struct AddUserView: View {
    
    @ObservedObject var addUserViewModel = AddUserViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var isPresented = false
    
    @State private var selectedUser: [(name: String, imageUrl: String, userID: String)] = []
    
    var body: some View {
        VStack {
            Text("Yeni Sohbet")
                .bold()
                .foregroundStyle(.primary)
                .padding(.top)
            
            List(addUserViewModel.users, id: \.id) { user in
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
                    
                    Spacer()
                    
                    Image(systemName: selectedUser.contains(where: { $0.name == user.name }) ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundStyle(Color(uiColor: .systemBlue))
                        .font(.system(size: 23))
                        .onTapGesture {
                            if let index = selectedUser.firstIndex(where: { $0.name == user.name }) {
                                selectedUser.remove(at: index)
                            } else {
                                selectedUser.append((name: user.name, imageUrl: user.imageUrl, userID: user.id))
                            }
                        }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if let index = selectedUser.firstIndex(where: { $0.name == user.name }) {
                        selectedUser.remove(at: index)
                    } else {
                        selectedUser.append((name: user.name, imageUrl: user.imageUrl, userID: user.id))
                    }
                }
            }
            
            HStack {
                Spacer()
                Button(action: {
                    for selectedUser in selectedUser {
                        guard let user = Auth.auth().currentUser else { return }
                        let currentUserID = user.uid
                        let userData = ["name": selectedUser.name, "userID": currentUserID, "imageUrl": selectedUser.imageUrl, "recipientId": selectedUser.userID]
                        addUserViewModel.saveUser(userData: userData)
                    }
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                })
                .padding()
            }
        }
        .task {
            addUserViewModel.getDataAllUser()
        }
    }
}

#Preview {
    AddUserView()
}
