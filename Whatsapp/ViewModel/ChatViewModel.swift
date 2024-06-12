//
//  ChatViewModel.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 25.03.2024.
//

import Foundation
import Firebase

struct ChatMessage: Identifiable {
    var id: String { documentId }
    
    let documentId: String
    let senderID, recipientID, message: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.senderID = data["senderID"] as? String ?? ""
        self.recipientID = data["recipientID"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
    }
}

class ChatViewModel: ObservableObject {
    
    @Published var messages = [ChatMessage]()
    @Published var messageText = String()
    
    @Published var count = 0
    
    func generateChatRoomID(user1: String, user2: String) -> String {
        let sortedIDs = [user1, user2].sorted()
        return sortedIDs.joined(separator: "_")
    }
    
    func sendMessage(recipientID: String, message: String) {
        guard let user = Auth.auth().currentUser else { return }
        let currentUserID = user.uid
        
        let firestore = Firestore.firestore()
        
        let chatRoomID = generateChatRoomID(user1: currentUserID, user2: recipientID)
        
        let messagesData = ["chatRoomID": chatRoomID, "senderID": currentUserID, "recipientID": recipientID, "message": messageText, "time": FieldValue.serverTimestamp()] as [String: Any]
        
        firestore.collection("Messages").document(chatRoomID).collection("Message").addDocument(data: messagesData) { error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("mesaj gönderildi")
                self.loadMessage(recipientID: recipientID)
                self.count += 1
            }
        }
    }
    
    func loadMessage(recipientID: String) {
        guard let user = Auth.auth().currentUser else { return }
        let currentUserID = user.uid
        
        let chatRoomID = generateChatRoomID(user1: currentUserID, user2: recipientID)
        
        let firestore = Firestore.firestore()
        
        firestore.collection("Messages").document(chatRoomID).collection("Message").order(by: "time").addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let chatMessage = ChatMessage(documentId: change.document.documentID, data: data)
                    if !self.messages.contains(where: { $0.id == chatMessage.id }) {
                        self.messages.append(chatMessage)
                    }
                }
            })
            DispatchQueue.main.async {
                self.count += 1
            }
        }
    }
}
