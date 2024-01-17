//
//  JotunheimrClient.swift
//  Jotunheimr
//
//  Created by Shady El-Maadawy on 16/01/2024.
//

import CoreNFC

public final class JotunheimrClient {
 
    // MARK: - Enums
    
    private enum ClientErrorMessages: LocalizedError {
        case tagNotSupported
        case tagNotAvailable
        case invalidCapacity
    }
 
    // MARK: - Properties

    private let nfcTagSession: NFCNDEFReaderSession
    private let nfcTag: NFCNDEFTag
    
    public private(set) var nfcTagDetails: JotunheimrTag!
    
    // MARK: - Initialization
    
    public init(session nfcTagSession: NFCNDEFReaderSession, tag nfcTag: NFCNDEFTag) async throws {
        
        self.nfcTagSession = nfcTagSession
        self.nfcTag = nfcTag
        
        try await self.connectToSession()
    }
    
    // MARK: - Object Life Cycle;
    
    deinit {
        nfcTagSession.invalidate()
    }
}

// MARK: - Operations

public extension JotunheimrClient {
    
    /// Link current nfc tag to active session
    private func connectToSession() async throws {
        
        try await self.nfcTagSession.connect(to: nfcTag)
        let (tagStatus, tagCapacity) = try await nfcTag.queryNDEFStatus()
        
        self.nfcTagDetails = JotunheimrTag.init(
            tagCapacity,
            tagStatus.rawValue
        )
    }
    
    
    @discardableResult
    /// Check for writing is valid and capacity is enough
    /// - Parameters:
    ///   - nfcPayload: new payload that will be added
    ///   - checkWithCurrentMessages: true for check with current messages, false for ignore current message
    /// - Returns: true or false
    private func writeIsValid(_ nfcPayload: NFCNDEFPayload, checkWithCurrentMessages: Bool = true) async throws -> Bool {
        
        guard self.nfcTagDetails.tagStatus == .readWrite else {
            throw ClientErrorMessages.tagNotSupported
        }

        guard self.nfcTag.isAvailable else {
            throw ClientErrorMessages.tagNotAvailable
        }
        
        var totalSize = 0
        if(checkWithCurrentMessages) {
            do {
                
                var currentPayloads = try await getPayloads()
                currentPayloads.append(nfcPayload)
                
                totalSize = NFCNDEFMessage.init(records: currentPayloads).length

            } catch { // Empty messages throw error
                totalSize = NFCNDEFMessage.init(records: [nfcPayload]).length
            }
            
        } else {
            
            totalSize = NFCNDEFMessage.init(records: [nfcPayload]).length
            
        }
        
        guard totalSize <= self.nfcTagDetails.totalCapacity else {
            throw ClientErrorMessages.invalidCapacity
        }
        
        return true
    }
    
    /// Read Payloads with raw data type from nfc tag
    /// - Returns: Payloads
    func getPayloads() async throws -> [NFCNDEFPayload] {
        
        guard self.nfcTagDetails.tagStatus != .notSupported else {
            throw ClientErrorMessages.tagNotSupported
        }
        
        let tagsMessages = try await self.nfcTag.readNDEF()
        return tagsMessages.records
    }
    
    
    /// Write payload to nfc tag, that action will not erase data in tag.
    /// - Parameter nfcPayload: Required Payload
    func addPayload(_ nfcPayload: NFCNDEFPayload) async throws {
        
        try await writeIsValid(nfcPayload)
        
        var currentPayloads = try await self.getPayloads()
        if(currentPayloads.isEmpty) {
            try await self.writePayload(nfcPayload)
            return
        }
        currentPayloads.append(nfcPayload)
        
        try await self.nfcTag.writeNDEF(
            NFCNDEFMessage(records: currentPayloads)
        )
    }
    
    
    /// Write payload to nfc tag, that action will erase all data in tag.
    /// - Parameter nfcPayload: Required Payload
    func writePayload(_ nfcPayload: NFCNDEFPayload) async throws {
        
        try await writeIsValid(nfcPayload, checkWithCurrentMessages: false)
        try await nfcTag.writeNDEF(
            NFCNDEFMessage(
                records: [ nfcPayload ]
            )
        )

    }
}
