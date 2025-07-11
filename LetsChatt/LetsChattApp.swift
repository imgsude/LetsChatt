//
//  LetsChattApp.swift
//  LetsChatt
//
//uygulamanin dongusunu yoneten ana baslangic dosyasi.uygulama ilk kez calistiginda tanimlanan gorunumu acar ilk ekrani 

import SwiftUI
import Firebase

@main
struct LetsChattApp: App {
    
    init() {
        FirebaseApp.configure()
    }
        var body: some Scene {
        WindowGroup {
            MainMessagesView()
        }
    }
}

