//
//  RecentMesssage.swift
//  LetsChatt
//
//  bir kullaniciyla yapilan son mesajlasma bilgisini tutar.
//
import Foundation
import FirebaseFirestore

struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
        //kullanicinin hesabindan @ oncesini alarak isim olarak gosterir.
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
        //son mesajin ne kadae zaman once gonderildigini verir.
    }
}
