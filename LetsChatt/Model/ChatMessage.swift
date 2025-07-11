//
//  ChatMessage.swift
//  LetsChatt
//
//mesaj modeli.Mesaj gonderildiginde Firebase e nasil kaydedilecegini ve okundugunda nasil kullanilicagini belirliyor.

import SwiftUI

import Foundation
import FirebaseFirestore

struct ChatMessage: Codable, Identifiable {
    // codable json a donusturme ve firestore ile kolay veri alisverisi icin
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}
//fromid:mesaji gonderen kisi , toid:mesaji alan kisi , timestap: mesajin gonderildigi zaman 
