//
//  Item.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
