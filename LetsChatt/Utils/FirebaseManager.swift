//
//  FirebaseManager.swift
//  LetsChatt
//
//  Firebase Yonetim sinifi
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    var currentUser: ChatUser?
    let firestore: Firestore
    //kullanici giris cikis islemleri , kullanici foto,uygulamada oturum acmis kullanici,nosql veritabani
    static let shared = FirebaseManager()
    
    override init() {
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}
