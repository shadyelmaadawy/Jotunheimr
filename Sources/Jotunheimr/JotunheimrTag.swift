//
//  JotunheimrTag.swift
//  Jotunheimr
//
//  Created by Shady El-Maadawy on 16/01/2024.
//

import Foundation

public final class JotunheimrTag {
    
    // MARK: - Enums
    
    public enum TagStatus: UInt {
        case notSupported = 1
        case readOnly = 3
        case readWrite = 2
    }
    
    // MARK: - Properties

    public internal(set) var totalCapacity: Int
    public let tagStatus: TagStatus
    
    // MARK: - Initialization
    
    internal init(_ totalCapacity: Int, _ tagStatus: UInt) {
        self.totalCapacity = totalCapacity
        self.tagStatus = TagStatus.init(rawValue: tagStatus)!
    }
    
}

