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
    static let kDefaultDataSize = 16
    
    static let kDefaultGroupSize = 2
    static let kDefaultEndianGroupSize = 4

    static let kDefaultFileOffset : UInt64 = 0
    static let kDefaultDataIncrementSize : UInt64 = UInt64(kDefaultDataSize)

    @Argument var filename: String
    @Option(name: .shortAndLong)
    var groupsize : Int?
    
    @Flag(name: .short)
    var endian : Bool = false


    func run() throws {
        
        // little endian format has a different default group size than big-endian. Set accordingly and check for incompatable values
        var theGroupSize : Int
        if (endian) {
            theGroupSize = groupsize ?? SwiftXXD.kDefaultEndianGroupSize
            
            // must be a power of 2 for [little endian](https://graphics.stanford.edu/~seander/bithacks.html#DetermineIfPowerOf2)
            if !((theGroupSize != 0) && ((theGroupSize & (theGroupSize - 1)) == 0)) {
                print("swift-xdd: number of octets per group must be a power of 2 with -e.")
                return
            }
        } else {
            theGroupSize = groupsize ?? SwiftXXD.kDefaultGroupSize
            
            // ensure that the group size doesn't exceed the max. xxd just goes on by setting it to the max
            theGroupSize = theGroupSize > SwiftXXD.kDefaultDataSize ? SwiftXXD.kDefaultDataSize : theGroupSize
        }
        
        // start reading from the file..
        do {
            let fileHandle = try FileHandle(forReadingFrom: URL(fileURLWithPath: filename))
            
            // assume we start at zero unless otherwise indicated
            var fileOffset = SwiftXXD.kDefaultFileOffset
            if (fileOffset > 0) {
                try fileHandle.seek(toOffset: fileOffset)
            }
            
            // read in the next chunk
            while let values = fileHandle.readUInt8s(ofSize: SwiftXXD.kDefaultDataSize) {
                // create the ASCII view
                let theView = String(values)
                
                // create the offset value
                let theOffset = String(format: "%08X", fileOffset)
                
                // create the line of hex data in the approperiate chunks in the correct format
                let theLine = endian
                    ? values.chunked(into: theGroupSize).map { $0.toLittleEndian().toHexString() }.joined(separator: " ")
                    : values.chunked(into: theGroupSize).map { $0.toHexString() }.joined(separator: " ")

                // write all the data out in xxd format
                print("\(theOffset): \(theLine)  \(theView)")
                fileOffset += SwiftXXD.kDefaultDataIncrementSize
            }
            
            fileHandle.closeFile()
            
        } catch {
            print("Error reading file: \(error)")
            MyLogger.log.error("\(error)")
        }
    }
}

struct MyLogger {
    static let log = Logger(subsystem: "com.gruecorner.swift-xxd", category: "swift-xxd")
}
