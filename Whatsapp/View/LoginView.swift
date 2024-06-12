//
//  LoginView.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 18.03.2024.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var loginViewModel = LoginViewModel()
    
    @State var isPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "phone.bubble")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)
                    .padding(.top)
                
                Text("Whatsapp")
                    .font(.title2)
                    .foregroundStyle(.green)
                    .bold()
                    .padding(.top, 3)
            }
            
            Text("Email adresinizle giriş yapınız")
                .font(.title3)
                .foregroundStyle(Color(uiColor: .darkGray))
                .padding(.top, 35)
            
            if !loginViewModel.errorMessage.isEmpty {
                Text(loginViewModel.errorMessage)
                    .foregroundStyle(.red)
            }
            
            TextField("Email", text: $loginViewModel.email)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .foregroundColor(.primary)
                .padding(8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.separator), lineWidth: 1)
                )
                .padding(.horizontal, 8)
                .padding(.top)
            
            SecureField("Şifre", text: $loginViewModel.password)
                .foregroundColor(.primary)
                .padding(8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.separator), lineWidth: 1)
                )
                .padding(.horizontal, 8)
            
            Button(action: {
                loginViewModel.signIn { success in
                    if success {
                        isPresented = true
                    } else {
                        
                    }
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 50)
                        .padding()
                    
                    Text("Giriş Yap")
                        .foregroundStyle(.white)
                }
            })
            .padding(.top)
            
            Spacer()
            
            Text("Hesabın yok mu ?")
                .foregroundStyle(.black)
            NavigationLink(destination: RegisterView()) {
                Text("Kayıt Ol")
            }
            .navigationBarBackButtonHidden()
            .background(
                NavigationLink(destination: MainView(), isActive: $isPresented) { EmptyView() }
            )
        }
    }
}

#Preview {
    LoginView()
}
