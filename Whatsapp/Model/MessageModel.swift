//
//  MessageModel.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 27.03.2024.
//

import Foundation
import Firebase

struct MessageModel {
    let senderID: String
    let message: String
    let time: Timestamp

    init(data: [String: Any]) {
        self.senderID = data["senderID"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.time = data["time"] as? Timestamp ?? Timestamp(date: Date())
    }
}
