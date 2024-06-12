//
//  ChatView.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 24.03.2024.
//

import SwiftUI
import Firebase

struct ChatView: View {
    
    @State var name: String
    @State var imageUrl: String
    @State var id: String
    
    @ObservedObject var chatViewModel = ChatViewModel()
    
    @State private var image: UIImage? = nil
    @State private var isShowingImagePicker = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
            messageView()
            .onAppear {
                chatViewModel.loadMessage(recipientID: id)
            }

        .navigationBarBackButtonHidden()
        .navigationBarItems(leading:
            HStack {
                AsyncImage(url: URL(string: imageUrl)) { image in image
                        .image?
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .cornerRadius(50)
                }

                Text(name)
                    .foregroundStyle(.primary)
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color(uiColor: .systemBlue))
            })
        )
    }
    
    private func messageView() -> some View {
        VStack {
            ScrollView {
                ScrollViewReader { proxy in
                    VStack {
                        ForEach(chatViewModel.messages) { message in
                            MessageView(message: message)
                        }
                        
                        HStack { Spacer() }
                            .id("Empty")
                    }
                    .onReceive(chatViewModel.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            proxy.scrollTo("Empty", anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(uiColor: .systemGray5))
            .safeAreaInset(edge: .bottom) {
                chatBottomBar()
                    .background(Color(uiColor: .systemBackground)
                        .ignoresSafeArea())
            }
            .padding(.bottom)
        }
    }
    
    struct MessageView : View {
        
        let message: ChatMessage
        
        var body: some View {
            VStack {
                if message.senderID == Auth.auth().currentUser?.uid {
                    HStack {
                        Spacer()
                        
                        HStack {
                            Text(message.message)
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .background(.blue)
                        .cornerRadius(8)
                    }
                } else {
                    HStack {
                        HStack {
                            Text(message.message)
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .background(Color(uiColor: .systemGray3))
                        .cornerRadius(8)
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func chatBottomBar() -> some View {
        HStack {
            Button(action: {
                isShowingImagePicker = true
            }, label: {
                Image(systemName: "plus")
                    .font(.system(size: 20))
            })
            
            ZStack {
                DescriptionPlaceHolder()
                TextEditor(text: $chatViewModel.messageText)
                    .opacity(chatViewModel.messageText.isEmpty ? 0.5 : 1)
                    .foregroundStyle(.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                                .stroke(Color(.separator), lineWidth: 1)
                    )
            }
            .frame(height: 45)
            
            Button(action: {
                guard !chatViewModel.messageText.isEmpty else { return }
                chatViewModel.sendMessage(recipientID: id, message: chatViewModel.messageText)
                chatViewModel.messageText = ""
            }, label: {
                Image(systemName: "paperplane.circle.fill")
                    .font(.system(size: 30))
            })
            .padding(.leading, 5)
            .padding(.vertical, 8)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: self.$image, isPresented: self.$isShowingImagePicker)
        }
    }
    
    private struct DescriptionPlaceHolder: View {
        var body: some View {
            HStack {
                Text("Mesaj yaz..")
                    .foregroundStyle(.gray)
                    .font(.system(size: 17))
                    .padding(.leading, 5)
                    .padding(.top, -4)
                
                Spacer()
            }
        }
    }
}

#Preview {
    ChatView(name: "İbrahim Ay", imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/whatsapp-551f1.appspot.com/o/images%2F8CD191B1-86A9-4186-9B86-102BF4CA3E69.jpg?alt=media&token=25c92865-fcbf-4c47-814d-937a6bfc5aa7", id: "")
}
