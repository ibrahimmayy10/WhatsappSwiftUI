//
//  RegisterView.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 18.03.2024.
//

import SwiftUI
import PhotosUI
import UIKit

struct RegisterView: View {
    
    @State var isPresented = false
    
    @ObservedObject var registerViewModel = RegisterViewModel()
    
    @State private var image: UIImage? = nil
    @State private var isShowingImagePicker = false
    
    var body: some View {
        VStack {
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
            Text("Email adresinizle kaydolunuz")
                .font(.title3)
                .foregroundStyle(Color(uiColor: .darkGray))
                .padding(.top, 35)
            
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .cornerRadius(50)
            } else {
                Button(action: {
                    isShowingImagePicker = true
                }, label: {
                    Image(systemName: "person")
                        .font(.system(size: 70))
                        .foregroundStyle(.blue)
                        .padding(.top)
                })
            }
            
            if !registerViewModel.errorMessage.isEmpty {
                Text(registerViewModel.errorMessage)
                    .foregroundStyle(.red)
            }
            
            TextField("Ad Soyad", text: $registerViewModel.name)
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
            
            TextField("Email", text: $registerViewModel.email)
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
            
            SecureField("Şifre", text: $registerViewModel.password)
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
                if let selectedImage = image {
                    registerViewModel.registerUser(selectedImage: selectedImage) { success in
                        if success {
                            isPresented = true
                        } else {
                            
                        }
                    }
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 50)
                        .padding()
                    
                    Text("Kayıt Ol")
                        .foregroundStyle(.white)
                }
            })
            .padding(.top)
            
            Spacer()
            
            Text("Zaten bir hesabın var mı ?")
                .foregroundStyle(.black)
            NavigationLink(destination: LoginView()) {
                Text("Giriş Yap")
            }
        }
        .navigationBarBackButtonHidden()
        .background(
            NavigationLink(destination: LoginView(), isActive: $isPresented) { EmptyView() }
        )
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: self.$image, isPresented: self.$isShowingImagePicker)
        }
    }
}

#Preview {
    RegisterView()
}
