//
//  MainView.swift
//  Whatsapp
//
//  Created by İbrahim Ay on 18.03.2024.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var mainViewModel = MainViewModel()
    
    @State var isPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    
                    Spacer()
                    
                    Text("Sohbetler")
                        .foregroundStyle(.primary)
                        .bold()
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    Button(action: {
                        self.isPresented.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color(uiColor: .systemBlue))
                            .font(.system(size: 20))
                    })
                    .padding(.trailing)
                }
                
                List(mainViewModel.users, id: \.id) { user in
                    NavigationLink(destination: ChatView(name: user.name, imageUrl: user.imageUrl, id: user.id)) {
                        UserCard(user: user)
                    }
                }
            }
            .task {
                do {
                    try await mainViewModel.getDataUser()
                } catch {
                    print("hata")
                }
            }
            .sheet(isPresented: $isPresented) {
                AddUserView()
                    .onDisappear {
                        Task {
                            do {
                                try await mainViewModel.getDataUser()
                            } catch {
                                print("hata")
                            }
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainView()
}
