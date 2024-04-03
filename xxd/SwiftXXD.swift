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
    static let kDefaultGroupSize = 2
    static let kDefaultEndianGroupSize = 4

    static let kDefaultFileOffset = 0

    // file to process
    @Argument var filename: String
    
    // size of the groups
    @Option(name: .shortAndLong)
    var groupsize : Int?
    
    // number of columns to write
    @Option(name: .shortAndLong)
    var cols : Int?

    // number of octets to write out
    @Option(name: .shortAndLong)
    var len : Int?

    @Option(name: .short)
    var seek : Int?

    @Flag(name: .short)
    var endian : Bool = false

    func run() throws {
        
        // initialize our
        var theOctetCounter = OctetCounter(max: len ?? OctetCounter.kNoLength, size: cols ?? 16)

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
            theGroupSize = theGroupSize > theOctetCounter.octextSize ? theOctetCounter.octextSize : theGroupSize
        }
        
        // calculate the length "hex" field in terms of characters so we can pad if necessary
        var theHexFieldLen = (theOctetCounter.octextSize * 2) + (theOctetCounter.octextSize/theGroupSize)
        
        if (theOctetCounter.octextSize % theGroupSize == 0) {
            theHexFieldLen -= 1
        }
        
        
        // start reading from the file..
        do {
            let fileHandle = try FileHandle(forReadingFrom: URL(fileURLWithPath: filename))
            
            // assume we start at zero unless otherwise indicated
            var fileOffset = UInt64(seek ?? Int(SwiftXXD.kDefaultFileOffset))
            if (fileOffset > 0) {
                try fileHandle.seek(toOffset: fileOffset)
            }
            
            var theOctetsToRead = theOctetCounter.octetsToRead()
            
            // read in the next chunk
            while let values = fileHandle.readUInt8s(ofSize: theOctetsToRead) {
                theOctetCounter.incrementOctetsRead(by: theOctetsToRead)
                
                // create the ASCII view
                let theView = String(values)
                
                // create the offset value
                let theOffset = String(format: "%08X", fileOffset)
                
                // create the line of hex data in the approperiate chunks in the correct format
                let theLine = endian
                    ? values.chunked(into: theGroupSize).map { $0.toLittleEndian().toHexString() }.joined(separator: " ")
                    : values.chunked(into: theGroupSize).map { $0.toHexString() }.joined(separator: " ")

                // write all the data out in xxd format
                print("\(theOffset): \(theLine.padding(toLength: theHexFieldLen, withPad: " ", startingAt: 0))  \(theView)")
                
                fileOffset += UInt64(theOctetCounter.octextSize)
                
                theOctetsToRead = theOctetCounter.octetsToRead()
                if (theOctetsToRead == 0) {
                    break
                }
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
