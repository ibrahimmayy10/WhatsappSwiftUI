//
//  LoginViewModel.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 20.03.2024.
//

import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    
    @Published var email = String()
    @Published var password = String()
    @Published var errorMessage = String()
    
    func signIn(completion: @escaping (Bool) -> Void) {
        guard validate() else {
            completion(false)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(false)
            } else {
                print("Giriş işlemi başarılı")
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
