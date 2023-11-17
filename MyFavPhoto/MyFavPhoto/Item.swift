//
//  Item.swift
//  MyFavPhoto
//
//  Created by Brent Reed on 2023-11-13.
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
