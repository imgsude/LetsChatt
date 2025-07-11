//
//  ContentView.swift
//  LetsChatt
//

//epostq ve sifre ile giris yapilmasini, hesap olusturulmasini ,profil resmi secmesini saglar

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
    struct LoginView: View {
        let didCompleteLoginProcess: () -> ()
        @State var isLoginMode = false
        @State var email = ""
        @State var password = ""
        @State var shouldShowImagePicker = false
        
        var body: some View {
            NavigationView {
                ScrollView{
                    VStack(spacing: 16){
                        Picker(selection: $isLoginMode, label: Text("Picker here")) {
                            Text("Login")
                                .tag(true)
                            Text("Create Account")
                                .tag(false)
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        if !isLoginMode {
                            Button {
                                shouldShowImagePicker.toggle()
                                
                            } label: {
                                VStack {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 120, height: 120)
                                            .scaledToFill()
                                            .cornerRadius(64)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 64))
                                            .padding()
                                            .foregroundColor(Color(.purple))
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 120)
                                    .stroke(Color.purple, lineWidth: 3))
                            }
                        }
                        
                        Group {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            
                            SecureField("Password", text: $password)
                        }
                        .background(Color.white)
                        .padding(14)
                        
                        //giris ve kayit butonu
                        Button {
                            handleAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text(isLoginMode ? "Login" : "Create Account")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .font(.system(size: 14, weight:
                                            .semibold))
                                Spacer()
                            }.background(Color.purple)
                            
                        }
                        Text(self.LoginStatusMessage)
                            .foregroundColor(.red)
                        
                        
                    }.padding()
                    
                }
                .navigationTitle(isLoginMode ? "Login" : "Create Account")
                .background(Color(.init(white: 0, alpha: 0.05))
                    .ignoresSafeArea())
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil, content: {
                ImagePicker(image: $image)
            })
        }
        
        @State var image: UIImage?
        
        private func handleAction() {
            if isLoginMode {
                //print("Should Log into your firebase with existing credentials")
                loginUser()
            } else {
                createNewAccount()
                print("Register a new account inside a firebase auth and then store image inside in Storage somehow....")
            }
        }
        //giris yapilir
        private func loginUser() {
            Auth.auth().signIn(withEmail: email, password: password) { Result, err in
                if let err = err {
                    print("Failed to login user: ", err)
                    self.LoginStatusMessage = "Failed to login user: \(err)"
                    return
                }
                print("Succesfully logged in as user: \(Result?.user.uid ?? "")")
                self.LoginStatusMessage = "Succesfully logged in as user: \(Result?.user.uid ?? "")"
                self.didCompleteLoginProcess()

                
            }
        }
        @State var LoginStatusMessage = ""
        
        //yeni kullanici olusturulur
        private func createNewAccount() {
            if self.image == nil {
                self.LoginStatusMessage = "You must select an avatar image"
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { Result,
                err in
                if let err = err {
                    print("Failed to create user: ", err)
                    self.LoginStatusMessage = "Failed to create user: \(err)"
                    return
                }
                print("Succesfully created user: \(Result?.user.uid ?? "")")
                self.LoginStatusMessage = "Succesfully created user: \(Result?.user.uid ?? "")"
                self.persistImageToStorage()
            }
        }
        
        //secilen resmi firebase e yyukler
        private func persistImageToStorage() {
            //let filename = UUID().uuidString

            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
                return
            }
            let ref =  Storage.storage().reference(withPath: uid)
            guard let imageData = self.image?.jpegData(compressionQuality: 0.5)
            else {
                return
            }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    self.LoginStatusMessage = "Failed to push image to Storage: \(err)"
                    return
                }
                ref.downloadURL { URL, err in
                    if let err = err {
                        self.LoginStatusMessage = "Failed to retrieve downloadedURL \(err)"
                        return
                    }
                    self.LoginStatusMessage = "Successfully stored image with url: \(URL?.absoluteString ?? "")"
                    print(URL?.absoluteString)
                    guard let URL = URL else {
                        return
                    }
                    storeUserInformation(imageProfileUrl: URL)
                }
            }
        }
        private func storeUserInformation(imageProfileUrl: URL){
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
                return
            }
            let userData = ["email": self.email, "profileImageUrl": imageProfileUrl.absoluteString, "uid": uid]
            FirebaseManager.shared.firestore.collection("users")
                .document(uid).setData(userData) { err in
                    if let err = err {
                        print(err)
                        self.LoginStatusMessage = "\(err)"
                        return
                    }
                    print("success")
                    self.didCompleteLoginProcess()
                }
        }
    }
    
    struct LoginView_Previews1: PreviewProvider {
        static var previews: some View {
            LoginView(didCompleteLoginProcess: {
                
            })
            
        }
    }

