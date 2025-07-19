//
//  JKT48Member.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import Foundation
import SwiftData

@Model
final class JKT48Member {
    var id: UUID
    var name: String
    var nickname: String
    var team: String
    var generation: String
    var profileImageURL: String
    var isOnline: Bool
    var lastSeenAt: Date?
    var isSubscribed: Bool
    var subscriberCount: Int
    var messageCount: Int
    var bio: String
    var birthDate: Date?
    var bloodType: String
    var hobby: String
    var specialSkill: String
    var socialMedia: [String: String] // Instagram, Twitter, etc.
    
    init(name: String, nickname: String, team: String, generation: String, profileImageURL: String = "") {
        self.id = UUID()
        self.name = name
        self.nickname = nickname
        self.team = team
        self.generation = generation
        self.profileImageURL = profileImageURL
        self.isOnline = Bool.random()
        self.lastSeenAt = Date()
        self.isSubscribed = false
        self.subscriberCount = Int.random(in: 1000...50000)
        self.messageCount = Int.random(in: 10...500)
        self.bio = ""
        self.birthDate = nil
        self.bloodType = ""
        self.hobby = ""
        self.specialSkill = ""
        self.socialMedia = [:]
    }
}

@Model
final class Message {
    var id: UUID
    var senderId: UUID
    var senderName: String
    var content: String
    var timestamp: Date
    var isFromMember: Bool
    var messageType: MessageType
    var imageURL: String?
    var voiceNoteURL: String?
    var isRead: Bool
    var replyToMessageId: UUID?
    
    init(senderId: UUID, senderName: String, content: String, isFromMember: Bool = true, messageType: MessageType = .text) {
        self.id = UUID()
        self.senderId = senderId
        self.senderName = senderName
        self.content = content
        self.timestamp = Date()
        self.isFromMember = isFromMember
        self.messageType = messageType
        self.imageURL = nil
        self.voiceNoteURL = nil
        self.isRead = false
        self.replyToMessageId = nil
    }
}

enum MessageType: String, CaseIterable, Codable {
    case text = "text"
    case image = "image"
    case voiceNote = "voiceNote"
    case sticker = "sticker"
}

@Model
final class Subscription {
    var id: UUID
    var userId: UUID
    var memberId: UUID
    var startDate: Date
    var endDate: Date
    var isActive: Bool
    var subscriptionType: SubscriptionType
    var price: Double
    
    init(userId: UUID, memberId: UUID, subscriptionType: SubscriptionType) {
        self.id = UUID()
        self.userId = userId
        self.memberId = memberId
        self.startDate = Date()
        self.endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        self.isActive = true
        self.subscriptionType = subscriptionType
        self.price = subscriptionType.price
    }
}

enum SubscriptionType: String, CaseIterable, Codable {
    case basic = "basic"
    case premium = "premium"
    case ultimate = "ultimate"
    
    var price: Double {
        switch self {
        case .basic: return 50000
        case .premium: return 100000
        case .ultimate: return 150000
        }
    }
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .premium: return "Premium"
        case .ultimate: return "Ultimate"
        }
    }
}