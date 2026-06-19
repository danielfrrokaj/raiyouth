//
//  Item.swift
//  raiyouth
//
//  Created by Daniel on 19.6.26.
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
