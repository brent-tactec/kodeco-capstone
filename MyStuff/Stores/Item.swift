//
//  Item.swift
//  MyStuff
//
//  Created by Brent Reed on 2023-11-10.
//
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
