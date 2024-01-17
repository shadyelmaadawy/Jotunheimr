//
//  JotunheimrListener.swift
//  Jotunheimr

//  Created by Shady El-Maadawy on 16/01/2024.
//

import CoreNFC

@available(iOS 15.6, *)
public final class Jotunheimr {
    
    // MARK: - Static Properties
    
    ///قال العرب قديماً، لا تعاند قديم المهنة، كثير الأطلاع، وواسع الحيلة.
    public static let shared = Jotunheimr()
    
    // MARK: - Object Life Cycle;

    private init() {}
    
}

// MARK: - Operations

@available(iOS 15.6, *)
public extension Jotunheimr {
    
    func scanForTag(scanMessage: String) async throws -> JotunheimrClient {
        return try await CoreNFCWrapper().scanForTag(scanMessage)
        
    }
    
}

