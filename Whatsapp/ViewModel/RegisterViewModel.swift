//
//  RegisterViewModel.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 20.03.2024.
//

import Foundation
import Firebase
import SwiftUI
import UIKit

class RegisterViewModel: ObservableObject {
    
    @Published var email = String()
    @Published var name = String()
    @Published var password = String()
    @Published var errorMessage = String()
    
    func registerUser(selectedImage: UIImage, completion: @escaping (Bool) -> Void) {
        guard validate() else {
            completion(false)
            return
        }
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else { return }
        
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child("images/\(imageName).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageReference.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("resimde hata oluştu")
                completion(false)
            } else {
                print("Resim başarıyla yüklendi.")
                
                imageReference.downloadURL { (url, error) in
                    if let error = error {
                        print("Resim URL'sini alma hatası: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        Auth.auth().createUser(withEmail: self.email, password: self.password) { authData, error in
                            if error != nil {
                                print(error?.localizedDescription ?? "")
                                completion(false)
                            } else {
                                let imageUrl = url?.absoluteString
                                
                                let firestore = Firestore.firestore()
                                
                                let userData = ["userID": authData?.user.uid ?? "", "name": self.name, "imageUrl": imageUrl ?? ""] as [String: Any]
                                
                                firestore.collection("Users").addDocument(data: userData) { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                        completion(false)
                                    } else {
                                        print("Kullanıcı oluşturuldu")
                                        completion(true)
                                    }
                                }
                                completion(true)
                            }
                        }
                    }
                    completion(true)
                }
                completion(true)
            }
        }
    }
    
    func validate() -> Bool {
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Lütfen tüm alanları doldurunuz"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Lütfen geçerli bir email adresi giriniz"
            return false
        }
        
        return true
    }
    
}
