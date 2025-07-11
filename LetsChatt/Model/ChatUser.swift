//
//  ChatUser.swift
//  LetsChatt
//

//kullaniciyi temmsil eder

import Foundation

struct ChatUser: Identifiable{
    //benzersizlik
    
    var id: String { uid }
    
    //firebqse kullanici id si:uid yani essiz idmiz.
    
    let uid, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        //firebaseten veri cektigimizde bu veriler bir sozluk olarak gelir.BSozlukteki degerleri alip string turune ceviriyoruz.basarisiz olursa bos string atanir.
        
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        
        
    }
}
