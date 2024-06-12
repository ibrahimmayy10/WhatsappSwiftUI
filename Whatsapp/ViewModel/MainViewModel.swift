//
//  MainViewModel.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 22.03.2024.
//

import Foundation
import Firebase

class MainViewModel: ObservableObject {
    
    @Published var name = String()
    
    @Published var users = [UserModel]()
    
    func getDataUser() async throws {
        guard let user = Auth.auth().currentUser else { return }
        let currentUserID = user.uid
        
        let firestore = Firestore.firestore()
        
        users.removeAll()
        
        do {
            let snapshot = try await firestore.collection("SelectedUser").whereField("userID", isEqualTo: currentUserID).getDocuments()
            for document in snapshot.documents {
                guard let name = document.get("name") as? String,
                      let imageUrl = document.get("imageUrl") as? String,
                      let id = document.get("recipientId") as? String else {
                    continue
                }
                
                let userData = UserModel(name: name, imageUrl: imageUrl, id: id)
                self.users.append(userData)
            }
        } catch {
            print("getdatauser hatası")
        }
    }
    
}
