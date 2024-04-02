//
//  SwiftXXD.swift
//  xxd
//
//  Created by Matthew Axsom on 3/31/24.
//

import Foundation
import os.log
import ArgumentParser

@main
struct SwiftXXD : ParsableCommand {
    @Argument var filename: String

    static let kDefaultDataSize = 16
    static let kDefaultGroupSize = 4

    static let kDefaultFileOffset : UInt64 = 0
    static let kDefaultDataIncrementSize : UInt64 = UInt64(kDefaultDataSize)

    func run() throws {
        do {
            let fileHandle = try FileHandle(forReadingFrom: URL(fileURLWithPath: filename))
            
            var fileOffset = SwiftXXD.kDefaultFileOffset
            if (fileOffset > 0) {
                try fileHandle.seek(toOffset: fileOffset)
            }
            
            while let values = fileHandle.readUInt8s(ofSize: SwiftXXD.kDefaultDataSize) {
                let theView = String(values)
                let theOffset = String(format: "%08X", fileOffset)
                
                let theLine = values.chunked(into: SwiftXXD.kDefaultGroupSize).map { $0.toHexString() }.joined(separator: " ")

                print("\(theOffset): \(theLine)  \(theView)")
                fileOffset += SwiftXXD.kDefaultDataIncrementSize
            }
            
            fileHandle.closeFile()
            
        } catch {
            print("Error reading file: \(error)")
        }
    }
}

struct MyLogger {
    static let log = Logger(subsystem: "com.gruecorner.swift-xxd", category: "swift-xxd")
}
