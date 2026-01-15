//
//  Item.swift
//  lecturetranscriber
//
//  Created by Shadow33 on 15/1/26.
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

