<p align="center">
  <img width="400" height="350" src="https://raw.githubusercontent.com/shadyelmaadawy/Jotunheimr/master/Logo.png">
  <br />
<a>
    <img src="http://img.shields.io/badge/License-MIT-green.svg?style=flat"/> </a> 
<a> 
<a>
    <img src="https://img.shields.io/badge/Platforms-IOS-red?style=flat"/> </a> 
<a> 
<a>
    <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg?style=flat"/> </a> 
<a> 
<a>
    <img src="https://img.shields.io/badge/Twitter-@shadudiix-blue.svg?style=flat"/> </a> 
<a> 
</p>

## Jotunheimr

HEY HEY, It's so long since the last article, right? I know, sorry super-busy.. as usual, Btw let's start 2024 with something great!!

I am in deep love with simplicity, complexity disgusts me.. It's shit, and that is the reason for crafting this package in the first place.

> Any fool can write code that a computer can understand.
> 
> Good programmers write code that humans can understand.
> 
> — Martin Fowler

Playing with operating system is super fun, but making what you craft reusable, scalable, and developer-friendly, It's one of the skills that cannot be learned easily, only **VETERANS** own it, 

Instead of a long introduction, **What is that, and how I use it?**

## What is that?

I crafted an elegent-wrapper for CoreNFC framework, for ease of use, almost anything that comes my way becomes reusable, I hate wasting my time writing the same code over and over and over, the same as complexity.

Btw, this package currently owns four operations and one property.

- Jotunheimr 
    - Scan for tag 
        - Enabling scan mode and waiting to detect any NFC tag
- Jotunheimr Client
    - Properties:
        - Nfc Tag
            - Total Capacity:
                - return total tag capacity
            - Tag Status:
                - Return if It's supported, read only, or write and read.
    - Operations:
        - Get payloads
             - Get all messages and paylods saved In NFC tag
        - Add payload
            - Add a new payload to current messages.
        - Write payload
            - Write a new payload and delete previous messages.
## How to use it?

It's simple, add the package via Swift package manager.

```swift
https://github.com/shadyelmaadawy/Jotunheimr.git
```

Then add NFC read permission to Info.plist

```swift
    <key>NFCReaderUsageDescription</key>
    <string>NFC Reader Permission Usage Description </string>
```

![](https://raw.githubusercontent.com/shadyelmaadawy/Jotunheimr/master/Screenshot/1.png)

Last thing, add near field communication tag reading to capabilities
![](https://raw.githubusercontent.com/shadyelmaadawy/Jotunheimr/master/Screenshot/2.png)


Okaaaay, But how I read messages/payloads in the tag?
```swift
    import Jotunheimr
    let jotunheimr = Jotunheimr.shared
    func readRecords() async {
        
        do {
            
            let jotunheimrClient = try await jotunheimr.scanForTag(scanMessage: "Hello, Scan your tag!")
            let records: [NFCNDEFPayload] = try await jotunheimrClient.getPayloads()
            
        } catch {}
        
    }
```
Very simple, no magic, just two lines of code!

How I write a message/payload?

```swift
    import Jotunheimr
    let jotunheimr = Jotunheimr.shared
    func addPayload() async {
        
        do {
            
            let jotunheimrClient = try await jotunheimr.scanForTag(scanMessage: "Hello, Scan your tag!")
            // Default APPLE Implementation
            let nfcPayload = NFCNDEFPayload.init(
                format: NFCTypeNameFormat.nfcWellKnown,
                type: "T".data(using: .utf8)!,
                identifier: Data.init(count: 0),
                payload: "Hello-World!;".data(using: .utf8)!,
                chunkSize: 0
            )
            try await jotunheimrClient.addPayload(nfcPayload)
            
        } catch {}
        
    }
```

What if I want to override all messages?
```swift
    import Jotunheimr
    let jotunheimr = Jotunheimr.shared
    func overridePayloads() async {
        
        do {
            
            let jotunheimrClient = try await jotunheimr.scanForTag(scanMessage: "Hello, Scan your tag!")
            // Default APPLE Implementation
            let nfcPayload = NFCNDEFPayload.init(
                format: NFCTypeNameFormat.nfcWellKnown,
                type: "T".data(using: .utf8)!,
                identifier: Data.init(count: 0),
                payload: "Hello-World!;".data(using: .utf8)!,
                chunkSize: 0
            )
            try await jotunheimrClient.writePayload(nfcPayload)
           
        } catch {}
        
    }
```

The same with one word changed, مبحبش اعقد العالم, also it uses default APPLE implementation for payloads, maybe later I wrap it , but currently for simplicity use.

## PoC: 

![](https://raw.githubusercontent.com/shadyelmaadawy/Jotunheimr/master/PoC/PoC.gif)

## To Infinity and beyond!

An example project is Included, you can try it, Btw… I will support this project and add more features and more cool stuff, please if you find any bug, don’t hesitate to report it, with all my love. ✨💜

## Credits

### Copyright (©) 2024, Shady K. Maadawy, All rights reserved. 
 [@shadudiix](https://github.com/shadyelmaadawy)
