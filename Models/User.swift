//
//  User.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import Foundation
import SwiftData

@Model
final class User {
    var id: UUID
    var name: String
    var email: String
    var profileImageData: Data?
    var phoneNumber: String
    var dateOfBirth: Date?
    var bio: String
    var isEmailVerified: Bool
    var createdAt: Date
    var lastLoginAt: Date?
    
    init(name: String, email: String, phoneNumber: String = "", bio: String = "") {
        self.id = UUID()
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.bio = bio
        self.profileImageData = nil
        self.dateOfBirth = nil
        self.isEmailVerified = false
        self.createdAt = Date()
        self.lastLoginAt = nil
    }
}