//
//  AddUserViewModel.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 22.03.2024.
//

import Foundation
import Firebase

class AddUserViewModel: ObservableObject {
    
    @Published var users = [UserModel]()
    @Published var id = String()
    
    func getDataAllUser() {
        let firestore = Firestore.firestore()
        
        firestore.collection("Users").addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let documents = snapshot?.documents, !documents.isEmpty {
                for document in documents {
                    guard let name = document.get("name") as? String,
                          let id = document.get("userID") as? String,
                          let imageUrl = document.get("imageUrl") as? String else { return }
                    
                    let users = UserModel(name: name, imageUrl: imageUrl, id: id)
                    self.users.append(users)
                }
            }
        }
    }
    
    func saveUser(userData: [String: Any]) {
        let firestore = Firestore.firestore()
        
        firestore.collection("SelectedUser").addDocument(data: userData) { error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("Yeni sohbet arkadaşı eklendi")
            }
        }
    }
}
