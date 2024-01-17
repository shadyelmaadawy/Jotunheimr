//
//  CoreNFCWrapper.swift
//  Jotunheimr

//  Created by Shady El-Maadawy on 16/01/2024.
//

import CoreNFC
import Foundation

internal final class CoreNFCWrapper: NSObject {

    // MARK: - Enums
    
    private enum WrapperErrorMessages: LocalizedError {
        case invalidDetect
    }
    
    // MARK: - Properties
    
    private var continuationHandler: CheckedContinuation<JotunheimrClient, Error>!
}


// MARK: - Operations

extension CoreNFCWrapper {

    
    /// Scan for nfc tags
    /// - Parameter listenerMessage: The message that will appear in default nfc tag view
    /// - Returns: Client or exception LOL
    func scanForTag(_ listenerMessage: String) async throws -> JotunheimrClient {
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuationHandler = continuation
            let readerSession = NFCNDEFReaderSession.init(delegate: self, queue: .main, invalidateAfterFirstRead: false)
            readerSession.alertMessage = listenerMessage
            readerSession.begin()
        }

    }
    

}

// MARK: - Delegates

extension CoreNFCWrapper: NFCNDEFReaderSessionDelegate {
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {}
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
        self.continuationHandler.resume(throwing: error)
        session.invalidate(errorMessage: error.localizedDescription)
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
            
        guard tags.count == 1, let readerTag = tags.first else {
            
            self.continuationHandler.resume(throwing: WrapperErrorMessages.invalidDetect)
            return
            
        }
        
        Task {
            do {
                let currentTagClient = try await JotunheimrClient(session: session, tag: readerTag)
                
                if(readerTag.isAvailable == true) {
                
                    self.continuationHandler.resume(returning: currentTagClient)
                    
                } else {
                    
                    session.invalidate(errorMessage: "Tag is not available")
                    self.continuationHandler.resume(throwing: WrapperErrorMessages.invalidDetect)
                    
                }
            } catch {

                self.continuationHandler.resume(throwing: error)
                session.invalidate(errorMessage: error.localizedDescription)

            }
        }
            
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {}

}
