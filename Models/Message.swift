//
//  Message.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import Foundation
import SwiftData

@Model
final class Message {
    var id: UUID
    var content: String
    var timestamp: Date
    var isFromUser: Bool
    var memberID: UUID
    var memberName: String
    var memberProfileImage: String
    var isRead: Bool
    
    init(content: String, isFromUser: Bool, memberID: UUID, memberName: String, memberProfileImage: String = "") {
        self.id = UUID()
        self.content = content
        self.timestamp = Date()
        self.isFromUser = isFromUser
        self.memberID = memberID
        self.memberName = memberName
        self.memberProfileImage = memberProfileImage
        self.isRead = false
    }
}